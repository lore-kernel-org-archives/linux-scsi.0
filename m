From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: More FC Transport Issues
Date: Tue, 3 Jan 2006 09:30:57 -0800
Message-ID: <20060103173057.GA6648@andrew-vasquezs-powerbook-g4-15.local>
References: <43AB36BC.8000003@sgi.com> <20051223195035.GG1112@andrew-vasquezs-powerbook-g4-15.local> <43AC7DBA.2040408@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:1038 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932427AbWACRa7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 12:30:59 -0500
Content-Disposition: inline
In-Reply-To: <43AC7DBA.2040408@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James.Smart@Emulex.Com, James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@sgi.com>

On Fri, 23 Dec 2005, Michael Reed wrote:

> Andrew Vasquez wrote:
> > On Thu, 22 Dec 2005, Michael Reed wrote:
> > 
> >>It's possible the OOPS is related to the qla2xxx serialization issue I reported
> >>earlier.
> >>
> >>http://marc.theaimsgroup.com/?l=linux-scsi&m=113380446825841&w=2
> >>http://marc.theaimsgroup.com/?l=linux-scsi&m=113458339109319&w=2
> > 
> > As far as the synchronization issues, could you try out the following.
> 
> As for initial testing w/git3, it's hanging during boot.
> I'll try and compile KDB into the kernel to get more info.
> Perhaps I can do some more work on this over the weekend.
> 
> It would seem as though the driver is thrashing the add/delete
> mechanism.  With lots of host ports and lots of targets, every SCN that
> comes in when another host port joins the fabric causes the others
> to delete and re-add their targets.
> 
> Picture 64 host ports and 128 targets on each.  (I only wish this were
> my test config.  Maybe Santa will bring me some more fabric!)
> 
> Perhaps check to see if target is missing after SCN and just
> delete it?

There's only one path where the qla2xxx driver adds fcports from an
interrupt context and subsequently schedules rport additions, the
RSCN handling in qla_rscn.c.  Typically, additions would occur from a
process context via the DPC thread.

Mike, here's a slight variant on the previous patch which will
hopefully handle the locking issues seen above and (temporarily, given
the semantics of rport additions) disables RSCN handling via the
driver's state-machine.

--
av

---

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7b3efd5..8a164fb 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1664,7 +1664,8 @@ typedef struct fc_port {
 	uint8_t mp_byte;		/* multi-path byte (not used) */
     	uint8_t cur_path;		/* current path id */
 
-	struct fc_rport *rport;
+	spinlock_t rport_lock;
+	struct fc_rport *rport, *drport;
 	u32 supported_classes;
 	struct work_struct rport_add_work;
 	struct work_struct rport_del_work;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c46d246..7d7d39f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1687,10 +1687,16 @@ static void
 qla2x00_rport_del(void *data)
 {
 	fc_port_t *fcport = data;
+	struct fc_rport *rport;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fcport->rport_lock, flags);
+	rport = fcport->drport;
+	fcport->drport = NULL;
+	spin_unlock_irqrestore(&fcport->rport_lock, flags);
+	if (rport)
+		fc_remote_port_delete(rport);
 
-	if (fcport->rport)
-		fc_remote_port_delete(fcport->rport);
-	fcport->rport = NULL;
 }
 
 /**
@@ -1718,6 +1724,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	fcport->flags = FCF_RLC_SUPPORT;
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
+	spin_lock_init(&fcport->rport_lock);
 	INIT_WORK(&fcport->rport_add_work, qla2x00_rport_add, fcport);
 	INIT_WORK(&fcport->rport_del_work, qla2x00_rport_del, fcport);
 
@@ -2081,10 +2088,10 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 	struct fc_rport_identifiers rport_ids;
 	struct fc_rport *rport;
 
-	if (fcport->rport) {
-		fc_remote_port_delete(fcport->rport);
-		fcport->rport = NULL;
-	}
+	if (fcport->drport)
+		qla2x00_rport_del(fcport);
+	if (fcport->rport)
+		return;
 
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
@@ -2649,10 +2656,14 @@ qla2x00_device_resync(scsi_qla_host_t *h
 
 		switch (format) {
 		case 0:
+
+			if (0) {
+#if 0
 			if (!IS_QLA2100(ha) && !IS_QLA2200(ha) &&
 			    !IS_QLA6312(ha) && !IS_QLA6322(ha) &&
 			    !IS_QLA24XX(ha) && !IS_QLA25XX(ha) &&
 			    ha->flags.init_done) {
+#endif
 				/* Handle port RSCN via asyncronous IOCBs */
 				rval2 = qla2x00_handle_port_rscn(ha, rscn_entry,
 				    NULL, 0);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5181d96..df496a4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -519,12 +519,15 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		 * us, create a new entry in our rscn fcports list and handle
 		 * the event like an RSCN.
 		 */
+		if (0) {
+#if 0
 		if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA6312(ha) &&
 		    !IS_QLA6322(ha) && !IS_QLA24XX(ha) && !IS_QLA25XX(ha) &&
 		    ha->flags.init_done && mb[1] != 0xffff &&
 		    ((ha->operating_mode == P2P && mb[1] != 0) ||
 		    (ha->operating_mode != P2P && mb[1] !=
 			SNS_FIRST_LOOP_ID)) && (mb[2] == 6 || mb[2] == 7)) {
+#endif
 			int rval;
 			fc_port_t *rscn_fcport;
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9746cd1..3de8fee 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -196,7 +196,9 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 			/* Check for pending interrupts. */
 			qla2x00_poll(ha);
 
-			udelay(10); /* v4.27 */
+			if (command != MBC_LOAD_RISC_RAM_EXTENDED &&
+			    !ha->flags.mbox_int)
+				msleep(10);
 		} /* while */
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c58c9d9..35a309d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1627,6 +1627,20 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	pci_disable_device(ha->pdev);
 }
 
+static inline void
+qla2x00_schedule_rport_del(struct scsi_qla_host *ha, fc_port_t *fcport)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fcport->rport_lock, flags);
+	if (fcport->rport) {
+		fcport->drport = fcport->rport;
+		fcport->rport = NULL;
+	}
+	spin_unlock_irqrestore(&fcport->rport_lock, flags);
+	schedule_work(&fcport->rport_del_work);
+}
+
 /*
  * qla2x00_mark_device_lost Updates fcport state when device goes offline.
  *
@@ -1639,8 +1653,8 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 void qla2x00_mark_device_lost(scsi_qla_host_t *ha, fc_port_t *fcport,
     int do_login)
 {
-	if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-		schedule_work(&fcport->rport_del_work);
+	if (atomic_read(&fcport->state) == FCS_ONLINE)
+		qla2x00_schedule_rport_del(ha, fcport);
 
 	/*
 	 * We may need to retry the login, so don't change the state of the
@@ -1701,8 +1715,8 @@ qla2x00_mark_all_devices_lost(scsi_qla_h
 		 */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
-		if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
-			schedule_work(&fcport->rport_del_work);
+		if (atomic_read(&fcport->state) == FCS_ONLINE)
+			qla2x00_schedule_rport_del(ha, fcport);
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 }
