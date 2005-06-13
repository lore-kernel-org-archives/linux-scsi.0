From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: further testing w/ multipath ... and bugs
Date: Mon, 13 Jun 2005 11:20:42 -0700
Message-ID: <20050613182042.GA24059@plap.qlogic.org>
References: <20050613081154.GA28251@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050613081154.GA28251@averon.dyndns.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@free.fr>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 13 Jun 2005, Christophe Varoqui wrote:

> 
> I'm testing Mike Christie's START_STOP hwhandler and discovered a bunch of new, interesting, phenomenons :
> 
> A little context first :
> o kernel 2.6.12-rc6 + qlogic discovery patch
> o qla2342 (dual 2GB)
> o EVA5000, Solaris-tagged connections
> 
> Here is a map create by multipath, fresh from boot :
> 
> eva1_lun2 (3600508b400014ba7000120000cf00000)
> [size=50 GB][features="1 queue_if_no_path"][hwhandler="1 hp_sw"]
> \_ round-robin 0 [active][best]
>   \_ 0:0:0:2 sdb  8:16    [ready ][active]
>   \_ 1:0:0:2 sdf  8:80    [ready ][active]
> \_ round-robin 0 [enabled]
>   \_ 0:0:1:2 sdd  8:48    [faulty][active]
>   \_ 1:0:1:2 sdh  8:112   [faulty][active]
> 
> Start a background stream read with dd on that map.
> 
> Do a port disable on the FC switch port connected to HBA 0
> Consistently at this moment I get the following in the logs :
> 
> qla2300 0000:05:0d.0: LOOP DOWN detected.
> Debug: sleeping function called from invalid context at include/linux/rwsem.h:43
> in_atomic():1, irqs_disabled():1
>  [<c0120a74>] __might_sleep+0xa4/0xc0
>  [<c026a466>] device_for_each_child+0x26/0x80
>  [<c02b3180>] target_block+0x0/0x30
>  [<c02bbdae>] fc_remote_port_block+0x2e/0x60
>  [<c02bdbf5>] qla2x00_mark_all_devices_lost+0x55/0x60
>  [<c02c597e>] qla2x00_async_event+0x83e/0xd60
>  [<c011dd2b>] find_busiest_group+0xbb/0x310
>  [<c02cdce4>] sd_rw_intr+0x164/0x320
>  [<c02c4e37>] qla2300_intr_handler+0x77/0x240
>  [<c0144882>] handle_IRQ_event+0x32/0x70

Without wanting to making a number of large changes to the qla2xxx
internals to deal with these pre-qualifications, could you try the
following patch (lightly tested with latest linus git tree).  

We'll need to update the fc_remote_port docs in order to account for
this semantic change in device_for_each_child().

--
av



Postpone fc_rport block/unblock to scheduled work.


diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -33,6 +33,7 @@
 #include <linux/mempool.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
+#include <linux/workqueue.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
@@ -1644,6 +1645,8 @@ typedef struct fc_port {
     	uint8_t cur_path;		/* current path id */
 
 	struct fc_rport *rport;
+	struct work_struct block_work;
+	struct work_struct unblock_work;
 } fc_port_t;
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -82,6 +82,8 @@ extern void qla2x00_cmd_timeout(srb_t *)
 
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
+extern void qla2x00_block_fcport(void *);
+extern void qla2x00_unblock_fcport(void *);
 
 extern void qla2x00_blink_led(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1534,6 +1534,8 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	fcport->iodesc_idx_sent = IODESC_INVALID_INDEX;
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	fcport->flags = FCF_RLC_SUPPORT;
+	INIT_WORK(&fcport->block_work, qla2x00_block_fcport, fcport);
+	INIT_WORK(&fcport->unblock_work, qla2x00_unblock_fcport, fcport);
 
 	return (fcport);
 }
@@ -1899,7 +1901,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 	struct fc_rport *rport;
 
 	if (fcport->rport) {
-		fc_remote_port_unblock(fcport->rport);
+		schedule_work(&fcport->unblock_work);
 		return;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1407,6 +1407,8 @@ void qla2x00_remove_one(struct pci_dev *
 
 	qla2x00_free_sysfs_attr(ha);
 
+	flush_scheduled_work();
+
 	fc_remove_host(ha->host);
 
 	scsi_remove_host(ha->host);
@@ -1481,7 +1483,7 @@ void qla2x00_mark_device_lost(scsi_qla_h
     int do_login)
 {
 	if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-		fc_remote_port_block(fcport->rport);
+		schedule_work(&fcport->block_work);
 	/* 
 	 * We may need to retry the login, so don't change the state of the
 	 * port but do the retries.
@@ -1542,11 +1544,25 @@ qla2x00_mark_all_devices_lost(scsi_qla_h
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
 		if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-			fc_remote_port_block(fcport->rport);
+			schedule_work(&fcport->block_work);
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 }
 
+void
+qla2x00_block_fcport(void *data)
+{
+	fc_port_t *fcport = (fc_port_t *)data;
+	fc_remote_port_block(fcport->rport);
+}
+
+void
+qla2x00_unblock_fcport(void *data)
+{
+	fc_port_t *fcport = (fc_port_t *)data;
+	fc_remote_port_unblock(fcport->rport);
+}
+
 /*
 * qla2x00_mem_alloc
 *      Allocates adapter memory.
