From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] defer rport block/unblock() operations to the keventd thread.
Date: Tue, 4 Oct 2005 15:30:47 -0700
Message-ID: <20051004223047.GH15160@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:60883 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S965020AbVJDWav (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2005 18:30:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

The current documentation for fc_remote_port_block() and
fc_remote_port_unblock() state that the functions can be called from
either interrupt and process context.  This is not the case, as
del_timer_sync(), cancel_delayed_work(), and flush_workqueue() can all
sleep:

	Debug: sleeping function called from invalid context at
	kernel/workqueue.c:264
	in_atomic():1, irqs_disabled():1
	 [<c011b434>] __might_sleep+0xa4/0xc0
	 [<c0127b32>] try_to_del_timer_sync+0x52/0x60
	 [<c012faac>] flush_workqueue+0x1c/0xb0
	 [<c0127b68>] del_timer_sync+0x28/0x40
	 [<c02c00d0>] fc_remote_port_unblock+0x70/0xa0
	 [<c02c00d0>] fc_remote_port_unblock+0x70/0xa0
	 [<f8aefeca>] qla2x00_send_login_iocb_cb+0x59a/0x7c0 [qla2xxx]
	 [<c03a3def>] _spin_lock_irqsave+0xf/0x20
	 [<c0127b32>] try_to_del_timer_sync+0x52/0x60
	 [<f8af079c>] qla2x00_process_iodesc+0x9c/0x150 [qla2xxx]
	 [<f8ae76e3>] qla2x00_process_response_queue+0xd3/0x180 [qla2xxx]
	 [<f8ae6c30>] qla2300_intr_handler+0x160/0x230 [qla2xxx]
	 [<c0127ef0>] update_wall_time+0x10/0x50
	 [<c013ef79>] handle_IRQ_event+0x39/0x70
	 [<c013f047>] __do_IRQ+0x97/0x110
	 [<c01053e6>] do_IRQ+0x46/0x70
	 =======================
	 [<c0103b4e>] common_interrupt+0x1a/0x20
	 [<c023c82d>] acpi_processor_idle+0x107/0x29d
	 [<c0100e89>] cpu_idle+0x69/0x80
	 [<c047da3a>] start_kernel+0x19a/0x1e0
	 [<c047d3b0>] unknown_bootoption+0x0/0x1e0

earlier in June we were indirectly hit by something similar during the
klist transition:

	http://marc.theaimsgroup.com/?l=linux-scsi&m=111868700022257&w=2

	Debug: sleeping function called from invalid context at include/linux/rwsem.h:43
	in_atomic():1, irqs_disabled():1
	[<c0120a74>] __might_sleep+0xa4/0xc0
	[<c026a466>] device_for_each_child+0x26/0x80
	[<c02b3180>] target_block+0x0/0x30
	[<c02bbdae>] fc_remote_port_block+0x2e/0x60
	[<c02bdbf5>] qla2x00_mark_all_devices_lost+0x55/0x60
	[<c02c597e>] qla2x00_async_event+0x83e/0xd60
	[<c011dd2b>] find_busiest_group+0xbb/0x310
	[<c02cdce4>] sd_rw_intr+0x164/0x320
	[<c02c4e37>] qla2300_intr_handler+0x77/0x240
	[<c0144882>] handle_IRQ_event+0x32/0x70


The attached patch, defers the block/unblock() operations to the keventd
thread.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -215,6 +215,8 @@ fc_bitfield_name_search(remote_port_role
 static void fc_timeout_blocked_rport(void *data);
 static void fc_scsi_scan_rport(void *data);
 static void fc_rport_terminate(struct fc_rport  *rport);
+static void fc_block_rport(void *data);
+static void fc_unblock_rport(void *data);
 
 /*
  * Attribute counts pre object type...
@@ -1233,6 +1235,8 @@ fc_rport_create(struct Scsi_Host *shost,
 
 	INIT_WORK(&rport->dev_loss_work, fc_timeout_blocked_rport, rport);
 	INIT_WORK(&rport->scan_work, fc_scsi_scan_rport, rport);
+	INIT_WORK(&rport->block_work, fc_block_rport, rport);
+	INIT_WORK(&rport->unblock_work, fc_unblock_rport, rport);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
@@ -1585,6 +1589,19 @@ fc_timeout_blocked_rport(void  *data)
 	scsi_remove_target(&rport->dev);
 }
 
+static void
+fc_block_rport(void *data)
+{
+	struct fc_rport *rport = (struct fc_rport *)data;
+
+	scsi_target_block(&rport->dev);
+
+	/* cap the length the devices can be blocked */
+	schedule_delayed_work(&rport->dev_loss_work, rport->dev_loss_tmo * HZ);
+
+	rport->port_state = FC_PORTSTATE_BLOCKED;
+}
+
 /**
  * fc_remote_port_block - temporarily block any scsi traffic to a remote port.
  * @rport:	remote port to be blocked.
@@ -1611,35 +1628,19 @@ int
 fc_remote_port_block(struct fc_rport *rport)
 {
 	int timeout = rport->dev_loss_tmo;
-	struct work_struct *work = &rport->dev_loss_work;
 
 	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
 		return -EINVAL;
 
-	scsi_target_block(&rport->dev);
-
-	/* cap the length the devices can be blocked */
-	schedule_delayed_work(work, timeout * HZ);
-
-	rport->port_state = FC_PORTSTATE_BLOCKED;
+	schedule_work(&rport->block_work);
 	return 0;
 }
 EXPORT_SYMBOL(fc_remote_port_block);
 
-/**
- * fc_remote_port_unblock - restart any blocked scsi traffic to a remote port.
- * @rport:	remote port to be unblocked.
- *
- * scsi lld's with a FC transport call this routine to restart IO to all
- * devices associated with the caller's scsi target following a fc_target_block
- * request.  Called from interrupt or normal process context.
- *
- * Notes:
- *	This routine assumes no locks are held on entry.
- **/
- void
-fc_remote_port_unblock(struct fc_rport *rport)
+static void
+fc_unblock_rport(void *data)
 {
+	struct fc_rport *rport = (struct fc_rport *)data;
 	struct work_struct *work = &rport->dev_loss_work;
 	struct Scsi_Host *shost = rport_to_shost(rport);
 
@@ -1662,6 +1663,24 @@ fc_remote_port_unblock(struct fc_rport *
 
 	rport->port_state = FC_PORTSTATE_ONLINE;
 }
+
+/**
+ * fc_remote_port_unblock - restart any blocked scsi traffic to a remote port.
+ * @rport:	remote port to be unblocked.
+ *
+ * scsi lld's with a FC transport call this routine to restart IO to all
+ * devices associated with the caller's scsi target following a fc_target_block
+ * request.  Called from interrupt or normal process context.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ **/
+void
+fc_remote_port_unblock(struct fc_rport *rport)
+{
+	schedule_work(&rport->unblock_work);
+
+}
 EXPORT_SYMBOL(fc_remote_port_unblock);
 
 /**
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -203,6 +203,8 @@ struct fc_rport {	/* aka fc_starget_attr
 	struct device dev;
  	struct work_struct dev_loss_work;
  	struct work_struct scan_work;
+ 	struct work_struct block_work;
+ 	struct work_struct unblock_work;
 } __attribute__((aligned(sizeof(unsigned long))));
 
 #define	dev_to_rport(d)				\

