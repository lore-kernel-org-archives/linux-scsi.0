From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.30-rc4
Date: Fri, 01 May 2009 14:18:11 +0000
Message-ID: <1241187492.3302.22.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38011 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438AbZEAOSX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2009 10:18:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a bunch of the usual fixes (including a large zfcp bug fix set)
plus three updates that aren't quite bug fixes but are allowed under the
rules:

     1. libosd protocol changes (update to v5 of the protocol which
        altered some field lengths).  These are incompatible changes, so
        need to be in now before we get libosd into the field 
     2. libfc/fcoe fixes and updates.  There's a new hardware based fcoe
        driver from cisco coming (using the merge window exemption) and
        most of the not quite bug fix updates are to support it. 
     3. mpt2sas updates ... these are mostly bug fixes but updates to a
        driver that was only recently added.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Abhijeet Joglekar (6):
      libfc: whenever queueing delete ev for rport, set state to NONE
      libfc: Change state to NONE in fc_lport_destroy
      libfc: During fabric logoff, flush the rport Q after logging off dns port
      libfc: Track rogue remote ports
      libfc: Do not retry if the new state is not the same as old state
      libfc: Hold disc mutex while processing gpn ft resp

Boaz Harrosh (3):
      libosd: OSD2r05: on-the-wire changes for latest OSD2 revision 5.
      libosd: OSD2r05: OSD_CRYPTO_KEYID_SIZE will grow 20 => 32 bytes
      libosd: OSD2r05: Prepare for rev5 attribute list changes

Brian King (1):
      ipr: Fix sleeping function called with interrupts disabled

Chris Leech (2):
      fcoe: fix spelling typos and bad comments
      fcoe: don't export functions that are internal to fcoe

Christof Schmitt (5):
      zfcp: Fix oops when port disappears
      zfcp: Reference counting for cfdc requests
      zfcp: Fix abort handler for completions in progress
      zfcp: Let actcli handle control file errors
      zfcp: Dont call zfcp_fsf_req_free on NULL pointer

Dan Carpenter (2):
      libosd: fix potential ERR_PTR dereference in osd_initiator.c
      fcoe: kfree() -> kfree_skb()

Dave Hansen (1):
      fix sign extension with 1.5TB usb-storage LBD=y

Eric Moore (10):
      mpt2sas : bump driver version to 01.100.02.00
      mpt2sas: fix hotplug event processing
      mpt2sas : release diagnotic buffers prior host reset
      mpt2sas : Broadcast Primative AEN bug fix
      mpt2sas : Identify Dell series-7 adapters at driver load time
      mpt2sas : driver name needs to be in the MPT2IOCINFO ioctl
      mpt2sas : running out of message frames
      mpt2sas : fix oops when firmware sends large sense buffer size
      mpt2sas : the sanity check in base_interrupt needs to be on dword boundary
      mpt2sas : unique ioctl magic number

FUJITA Tomonori (1):
      sg: return EFAULT for an invalid user address

James Smart (3):
      lpfc 8.3.1 : Update version to 8.3.1
      lpfc 8.3.1: misc fixes/changes
      lpfc 8.3.1 : Fix up kernel-doc function comments

Joe Eykholt (1):
      fcoe: fip: add multicast filter to receive FIP advertisements.

Martin Petermann (4):
      zfcp: Fix port reference counting
      zfcp: revert previous patch for sbal counting
      zfcp: remove unit will fail if add unit is not finished
      zfcp: Avoid referencing freed memory in req send

Mike Christie (5):
      cxgb3i: fix cpu use abuse during writes
      cxgb3i: fix can_queue and cmd_per_lun initialization
      cxgb3i, iser, iscsi_tcp: set target can queue
      iscsi_tcp: don't fire conn error if pdu init fails
      fix q->lock not held warning when target is busy

Peter Jones (1):
      sr: report more accurate drive status after closing the tray.

Robert Love (1):
      libfc: Fix compilation warnings with allmodconfig

Swen Schillig (6):
      zfcp: no port recovery after ADISC request timeout
      zfcp: no port recovery after storage side error inject
      zfcp: avoid false ERP complete due to sema race
      zfcp: Set WKA-port to offline on adapter deactivation
      zfcp: Dont block zfcp_wq with scan
      zfcp: Enable auto-port discovery for NPIV.

kxie@chelsio.com (1):
      cxgb3i: fix ddp map overrun

The diffstat:

 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 
 drivers/s390/scsi/zfcp_aux.c             |   11 
 drivers/s390/scsi/zfcp_ccw.c             |    1 
 drivers/s390/scsi/zfcp_cfdc.c            |    3 
 drivers/s390/scsi/zfcp_def.h             |    2 
 drivers/s390/scsi/zfcp_erp.c             |   60 ----
 drivers/s390/scsi/zfcp_ext.h             |    2 
 drivers/s390/scsi/zfcp_fc.c              |   33 +-
 drivers/s390/scsi/zfcp_fsf.c             |   59 ++--
 drivers/s390/scsi/zfcp_scsi.c            |   44 ++-
 drivers/s390/scsi/zfcp_sysfs.c           |   21 +
 drivers/scsi/cxgb3i/cxgb3i.h             |    2 
 drivers/scsi/cxgb3i/cxgb3i_ddp.c         |   32 +-
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c       |    5 
 drivers/scsi/cxgb3i/cxgb3i_offload.c     |    4 
 drivers/scsi/cxgb3i/cxgb3i_pdu.c         |   19 -
 drivers/scsi/fcoe/fcoe.c                 |   59 +---
 drivers/scsi/fcoe/libfcoe.c              |    2 
 drivers/scsi/ipr.c                       |   13 -
 drivers/scsi/iscsi_tcp.c                 |    3 
 drivers/scsi/libfc/fc_disc.c             |   54 +++-
 drivers/scsi/libfc/fc_elsct.c            |    2 
 drivers/scsi/libfc/fc_fcp.c              |    7 
 drivers/scsi/libfc/fc_lport.c            |   74 +++--
 drivers/scsi/libfc/fc_rport.c            |   82 ++++--
 drivers/scsi/libiscsi.c                  |   10 
 drivers/scsi/libiscsi_tcp.c              |    5 
 drivers/scsi/lpfc/lpfc.h                 |    2 
 drivers/scsi/lpfc/lpfc_attr.c            |  266 +++++++++++---------
 drivers/scsi/lpfc/lpfc_crtn.h            |    2 
 drivers/scsi/lpfc/lpfc_debugfs.c         |   45 +--
 drivers/scsi/lpfc/lpfc_disc.h            |    1 
 drivers/scsi/lpfc/lpfc_els.c             |  245 +++++++-----------
 drivers/scsi/lpfc/lpfc_hbadisc.c         |   88 +++---
 drivers/scsi/lpfc/lpfc_init.c            |  205 ++++++++++-----
 drivers/scsi/lpfc/lpfc_logmsg.h          |    2 
 drivers/scsi/lpfc/lpfc_mbox.c            |   63 ++--
 drivers/scsi/lpfc/lpfc_mem.c             |   19 -
 drivers/scsi/lpfc/lpfc_nportdisc.c       |   18 -
 drivers/scsi/lpfc/lpfc_scsi.c            |  126 ++++-----
 drivers/scsi/lpfc/lpfc_sli.c             |  401 ++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_version.h         |    6 
 drivers/scsi/lpfc/lpfc_vport.c           |   10 
 drivers/scsi/mpt2sas/mpt2sas_base.c      |   75 +++++
 drivers/scsi/mpt2sas/mpt2sas_base.h      |   30 ++
 drivers/scsi/mpt2sas/mpt2sas_ctl.c       |  216 +++++++++++-----
 drivers/scsi/mpt2sas/mpt2sas_ctl.h       |    7 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     |   29 +-
 drivers/scsi/osd/osd_initiator.c         |  125 +++++++--
 drivers/scsi/scsi_lib.c                  |    4 
 drivers/scsi/sd.c                        |   15 -
 drivers/scsi/sg.c                        |   13 -
 drivers/scsi/sr_ioctl.c                  |    5 
 include/scsi/fc/fc_fs.h                  |    1 
 include/scsi/libfc.h                     |    1 
 include/scsi/libiscsi.h                  |    2 
 include/scsi/osd_protocol.h              |   96 +++++--
 57 files changed, 1616 insertions(+), 1112 deletions(-)

And the diff attached below

James

---

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 13d7674..75223f5 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -599,6 +599,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler= iscsi_eh_target_reset,
+	.target_alloc		= iscsi_target_alloc,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 616c60f..3ac27ee 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -97,9 +97,7 @@ static void __init zfcp_init_device_configure(char *busid, u64 wwpn, u64 lun)
 	ccw_device_set_online(adapter->ccw_device);
 
 	zfcp_erp_wait(adapter);
-	wait_event(adapter->erp_done_wqh,
-		   !(atomic_read(&unit->status) &
-				ZFCP_STATUS_UNIT_SCSI_WORK_PENDING));
+	flush_work(&unit->scsi_work);
 
 	down(&zfcp_data.config_sema);
 	zfcp_unit_put(unit);
@@ -279,6 +277,7 @@ struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *port, u64 fcp_lun)
 
 	atomic_set(&unit->refcount, 0);
 	init_waitqueue_head(&unit->remove_wq);
+	INIT_WORK(&unit->scsi_work, zfcp_scsi_scan);
 
 	unit->port = port;
 	unit->fcp_lun = fcp_lun;
@@ -525,6 +524,8 @@ int zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 
+	zfcp_fc_nameserver_init(adapter);
+
 	if (!zfcp_adapter_scsi_register(adapter))
 		return 0;
 
@@ -553,7 +554,6 @@ void zfcp_adapter_dequeue(struct zfcp_adapter *adapter)
 
 	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
-	cancel_delayed_work_sync(&adapter->nsp.work);
 	zfcp_adapter_scsi_unregister(adapter);
 	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
 			   &zfcp_sysfs_adapter_attrs);
@@ -671,8 +671,7 @@ void zfcp_port_dequeue(struct zfcp_port *port)
 	list_del(&port->list);
 	write_unlock_irq(&zfcp_data.config_lock);
 	if (port->rport)
-		fc_remote_port_delete(port->rport);
-	port->rport = NULL;
+		port->rport->dd_data = NULL;
 	zfcp_adapter_put(port->adapter);
 	sysfs_remove_group(&port->sysfs_device.kobj, &zfcp_sysfs_port_attrs);
 	device_unregister(&port->sysfs_device);
diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index cfb0dcb..733fe3b 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -108,7 +108,6 @@ static int zfcp_ccw_set_online(struct ccw_device *ccw_device)
 	/* initialize request counter */
 	BUG_ON(!zfcp_reqlist_isempty(adapter));
 	adapter->req_no = 0;
-	zfcp_fc_nameserver_init(adapter);
 
 	zfcp_erp_modify_adapter_status(adapter, "ccsonl1", NULL,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_cfdc.c
index 10cbfd1..8305c87 100644
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -4,7 +4,7 @@
  * Userspace interface for accessing the
  * Access Control Lists / Control File Data Channel
  *
- * Copyright IBM Corporation 2008
+ * Copyright IBM Corporation 2008, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -197,6 +197,7 @@ static long zfcp_cfdc_dev_ioctl(struct file *file, unsigned int command,
 		retval = -ENXIO;
 		goto free_buffer;
 	}
+	zfcp_adapter_get(adapter);
 
 	retval = zfcp_cfdc_sg_setup(data->command, fsf_cfdc->sg,
 				    data_user->control_file);
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index a031863..4c362a9 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -255,7 +255,6 @@ enum zfcp_wka_status {
 /* logical unit status */
 #define ZFCP_STATUS_UNIT_SHARED			0x00000004
 #define ZFCP_STATUS_UNIT_READONLY		0x00000008
-#define ZFCP_STATUS_UNIT_SCSI_WORK_PENDING	0x00000020
 
 /* FSF request status (this does not have a common part) */
 #define ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT	0x00000002
@@ -530,6 +529,7 @@ struct zfcp_unit {
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
         atomic_t               erp_counter;
 	struct zfcp_latencies	latencies;
+	struct work_struct	scsi_work;
 };
 
 /* FSF request */
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 631bdb1..fdc9b43 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -719,6 +719,7 @@ static void zfcp_erp_adapter_strategy_close(struct zfcp_erp_action *act)
 	zfcp_qdio_close(adapter);
 	zfcp_fsf_req_dismiss_all(adapter);
 	adapter->fsf_req_seq_no = 0;
+	zfcp_fc_wka_port_force_offline(&adapter->nsp);
 	/* all ports and units are closed */
 	zfcp_erp_modify_adapter_status(adapter, "erascl1", NULL,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
@@ -1176,48 +1177,6 @@ static void zfcp_erp_action_dequeue(struct zfcp_erp_action *erp_action)
 	}
 }
 
-struct zfcp_erp_add_work {
-	struct zfcp_unit  *unit;
-	struct work_struct work;
-};
-
-static void zfcp_erp_scsi_scan(struct work_struct *work)
-{
-	struct zfcp_erp_add_work *p =
-		container_of(work, struct zfcp_erp_add_work, work);
-	struct zfcp_unit *unit = p->unit;
-	struct fc_rport *rport = unit->port->rport;
-
-	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
-		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
-			 scsilun_to_int((struct scsi_lun *)&unit->fcp_lun), 0);
-	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
-	zfcp_unit_put(unit);
-	wake_up(&unit->port->adapter->erp_done_wqh);
-	kfree(p);
-}
-
-static void zfcp_erp_schedule_work(struct zfcp_unit *unit)
-{
-	struct zfcp_erp_add_work *p;
-
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	if (!p) {
-		dev_err(&unit->port->adapter->ccw_device->dev,
-			"Registering unit 0x%016Lx on port 0x%016Lx failed\n",
-			(unsigned long long)unit->fcp_lun,
-			(unsigned long long)unit->port->wwpn);
-		return;
-	}
-
-	zfcp_unit_get(unit);
-	atomic_set_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
-	INIT_WORK(&p->work, zfcp_erp_scsi_scan);
-	p->unit = unit;
-	if (!queue_work(zfcp_data.work_queue, &p->work))
-		zfcp_unit_put(unit);
-}
-
 static void zfcp_erp_action_cleanup(struct zfcp_erp_action *act, int result)
 {
 	struct zfcp_adapter *adapter = act->adapter;
@@ -1226,11 +1185,11 @@ static void zfcp_erp_action_cleanup(struct zfcp_erp_action *act, int result)
 
 	switch (act->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		flush_work(&port->rport_work);
 		if ((result == ZFCP_ERP_SUCCEEDED) && !unit->device) {
-			if (!(atomic_read(&unit->status) &
-			      ZFCP_STATUS_UNIT_SCSI_WORK_PENDING))
-				zfcp_erp_schedule_work(unit);
+			zfcp_unit_get(unit);
+			if (scsi_queue_work(unit->port->adapter->scsi_host,
+					    &unit->scsi_work) <= 0)
+				zfcp_unit_put(unit);
 		}
 		zfcp_unit_put(unit);
 		break;
@@ -1352,6 +1311,11 @@ static int zfcp_erp_thread(void *data)
 
 	while (!(atomic_read(&adapter->status) &
 		 ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL)) {
+
+		zfcp_rec_dbf_event_thread_lock("erthrd1", adapter);
+		ignore = down_interruptible(&adapter->erp_ready_sem);
+		zfcp_rec_dbf_event_thread_lock("erthrd2", adapter);
+
 		write_lock_irqsave(&adapter->erp_lock, flags);
 		next = adapter->erp_ready_head.next;
 		write_unlock_irqrestore(&adapter->erp_lock, flags);
@@ -1363,10 +1327,6 @@ static int zfcp_erp_thread(void *data)
 			if (zfcp_erp_strategy(act) != ZFCP_ERP_DISMISSED)
 				zfcp_erp_wakeup(adapter);
 		}
-
-		zfcp_rec_dbf_event_thread_lock("erthrd1", adapter);
-		ignore = down_interruptible(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread_lock("erthrd2", adapter);
 	}
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index f6399ca..2e31b53 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -106,6 +106,7 @@ extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 extern void zfcp_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
 extern void zfcp_fc_nameserver_init(struct zfcp_adapter *);
+extern void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *);
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
@@ -158,6 +159,7 @@ extern void zfcp_scsi_rport_work(struct work_struct *);
 extern void zfcp_scsi_schedule_rport_register(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rport_block(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *);
+extern void zfcp_scsi_scan(struct work_struct *);
 
 /* zfcp_sysfs.c */
 extern struct attribute_group zfcp_sysfs_unit_attrs;
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index e8d032b..19ae084 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -98,13 +98,6 @@ static void zfcp_wka_port_offline(struct work_struct *work)
 	struct zfcp_wka_port *wka_port =
 			container_of(dw, struct zfcp_wka_port, work);
 
-	/* Don't wait forvever. If the wka_port is too busy take it offline
-	   through a new call later */
-	if (!wait_event_timeout(wka_port->completion_wq,
-				atomic_read(&wka_port->refcount) == 0,
-				HZ >> 1))
-		return;
-
 	mutex_lock(&wka_port->mutex);
 	if ((atomic_read(&wka_port->refcount) != 0) ||
 	    (wka_port->status != ZFCP_WKA_PORT_ONLINE))
@@ -142,6 +135,14 @@ void zfcp_fc_nameserver_init(struct zfcp_adapter *adapter)
 	INIT_DELAYED_WORK(&wka_port->work, zfcp_wka_port_offline);
 }
 
+void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *wka)
+{
+	cancel_delayed_work_sync(&wka->work);
+	mutex_lock(&wka->mutex);
+	wka->status = ZFCP_WKA_PORT_OFFLINE;
+	mutex_unlock(&wka->mutex);
+}
+
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 				   struct fcp_rscn_element *elem)
 {
@@ -372,7 +373,8 @@ static void zfcp_fc_adisc_handler(unsigned long data)
 
 	if (adisc->els.status) {
 		/* request rejected or timed out */
-		zfcp_erp_port_forced_reopen(port, 0, "fcadh_1", NULL);
+		zfcp_erp_port_forced_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
+					    "fcadh_1", NULL);
 		goto out;
 	}
 
@@ -431,11 +433,6 @@ void zfcp_fc_link_test_work(struct work_struct *work)
 		container_of(work, struct zfcp_port, test_link_work);
 	int retval;
 
-	if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_UNBLOCKED)) {
-		zfcp_port_put(port);
-		return; /* port erp is running and will update rport status */
-	}
-
 	zfcp_port_get(port);
 	port->rport_task = RPORT_DEL;
 	zfcp_scsi_rport_work(&port->rport_work);
@@ -542,6 +539,9 @@ static void zfcp_validate_port(struct zfcp_port *port)
 {
 	struct zfcp_adapter *adapter = port->adapter;
 
+	if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_NOESC))
+		return;
+
 	atomic_clear_mask(ZFCP_STATUS_COMMON_NOESC, &port->status);
 
 	if ((port->supported_classes != 0) ||
@@ -602,10 +602,8 @@ static int zfcp_scan_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft, int max_entries)
 		if (acc->wwpn == fc_host_port_name(adapter->scsi_host))
 			continue;
 		port = zfcp_get_port_by_wwpn(adapter, acc->wwpn);
-		if (port) {
-			zfcp_port_get(port);
+		if (port)
 			continue;
-		}
 
 		port = zfcp_port_enqueue(adapter, acc->wwpn,
 					 ZFCP_STATUS_COMMON_NOESC, d_id);
@@ -637,7 +635,8 @@ int zfcp_scan_ports(struct zfcp_adapter *adapter)
 	max_entries = chain ? ZFCP_GPN_FT_MAX_ENTRIES : ZFCP_GPN_FT_ENTRIES;
 	max_bytes = chain ? ZFCP_GPN_FT_MAX_SIZE : ZFCP_CT_SIZE_ONE_PAGE;
 
-	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT)
+	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT &&
+	    fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPIV)
 		return 0;
 
 	ret = zfcp_wka_port_get(&adapter->nsp);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index b29f312..74dee32 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -172,12 +172,16 @@ static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req, char *id,
 					 struct fsf_link_down_info *link_down)
 {
 	struct zfcp_adapter *adapter = req->adapter;
+	unsigned long flags;
 
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED)
 		return;
 
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
+
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	zfcp_scsi_schedule_rports_block(adapter);
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
 	if (!link_down)
 		goto out;
@@ -645,30 +649,30 @@ static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)
 	}
 }
 
-static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
-	__releases(&adapter->req_q_lock)
-	__acquires(&adapter->req_q_lock)
+static int zfcp_fsf_sbal_check(struct zfcp_adapter *adapter)
 {
 	struct zfcp_qdio_queue *req_q = &adapter->req_q;
-	long ret;
 
-	if (atomic_read(&req_q->count) <= -REQUEST_LIST_SIZE)
-		return -EIO;
-	if (atomic_read(&req_q->count) > 0)
-		return 0;
+	spin_lock_bh(&adapter->req_q_lock);
+	if (atomic_read(&req_q->count))
+		return 1;
+	spin_unlock_bh(&adapter->req_q_lock);
+	return 0;
+}
+
+static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
+{
+	long ret;
 
-	atomic_dec(&req_q->count);
 	spin_unlock_bh(&adapter->req_q_lock);
 	ret = wait_event_interruptible_timeout(adapter->request_wq,
-					atomic_read(&req_q->count) >= 0,
-					5 * HZ);
-	spin_lock_bh(&adapter->req_q_lock);
-	atomic_inc(&req_q->count);
-
+			       zfcp_fsf_sbal_check(adapter), 5 * HZ);
 	if (ret > 0)
 		return 0;
 	if (!ret)
 		atomic_inc(&adapter->qdio_outb_full);
+
+	spin_lock_bh(&adapter->req_q_lock);
 	return -EIO;
 }
 
@@ -766,8 +770,9 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_adapter *adapter,
 static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	unsigned long flags;
-	int idx;
+	unsigned long	     flags;
+	int		     idx;
+	int		     with_qtcb = (req->qtcb != NULL);
 
 	/* put allocated FSF request into hash table */
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
@@ -789,7 +794,7 @@ static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 	}
 
 	/* Don't increase for unsolicited status */
-	if (req->qtcb)
+	if (with_qtcb)
 		adapter->fsf_req_seq_no++;
 	adapter->req_no++;
 
@@ -1253,13 +1258,13 @@ int zfcp_fsf_exchange_config_data_sync(struct zfcp_adapter *adapter,
 
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
-		goto out;
+		goto out_unlock;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
 				  0, NULL);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
-		goto out;
+		goto out_unlock;
 	}
 
 	sbale = zfcp_qdio_sbale_req(req);
@@ -1278,14 +1283,16 @@ int zfcp_fsf_exchange_config_data_sync(struct zfcp_adapter *adapter,
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-out:
 	spin_unlock_bh(&adapter->req_q_lock);
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
 	zfcp_fsf_req_free(req);
+	return retval;
 
+out_unlock:
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -1352,13 +1359,13 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *adapter,
 
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
-		goto out;
+		goto out_unlock;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA, 0,
 				  NULL);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
-		goto out;
+		goto out_unlock;
 	}
 
 	if (data)
@@ -1371,14 +1378,18 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *adapter,
 	req->handler = zfcp_fsf_exchange_port_data_handler;
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-out:
 	spin_unlock_bh(&adapter->req_q_lock);
+
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 	zfcp_fsf_req_free(req);
 
 	return retval;
+
+out_unlock:
+	spin_unlock_bh(&adapter->req_q_lock);
+	return retval;
 }
 
 static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
@@ -2472,8 +2483,6 @@ out:
 
 static void zfcp_fsf_control_file_handler(struct zfcp_fsf_req *req)
 {
-	if (req->qtcb->header.fsf_status != FSF_GOOD)
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 58201e1..e8fbeae 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -171,7 +171,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
 		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL,
 					  old_req_id);
-		return SUCCESS;
+		return FAILED; /* completion could be in progress */
 	}
 	old_req->data = NULL;
 
@@ -486,10 +486,12 @@ static void zfcp_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
  */
 static void zfcp_scsi_dev_loss_tmo_callbk(struct fc_rport *rport)
 {
-	struct zfcp_port *port = rport->dd_data;
+	struct zfcp_port *port;
 
 	write_lock_irq(&zfcp_data.config_lock);
-	port->rport = NULL;
+	port = rport->dd_data;
+	if (port)
+		port->rport = NULL;
 	write_unlock_irq(&zfcp_data.config_lock);
 }
 
@@ -503,9 +505,18 @@ static void zfcp_scsi_dev_loss_tmo_callbk(struct fc_rport *rport)
  */
 static void zfcp_scsi_terminate_rport_io(struct fc_rport *rport)
 {
-	struct zfcp_port *port = rport->dd_data;
+	struct zfcp_port *port;
+
+	write_lock_irq(&zfcp_data.config_lock);
+	port = rport->dd_data;
+	if (port)
+		zfcp_port_get(port);
+	write_unlock_irq(&zfcp_data.config_lock);
 
-	zfcp_erp_port_reopen(port, 0, "sctrpi1", NULL);
+	if (port) {
+		zfcp_erp_port_reopen(port, 0, "sctrpi1", NULL);
+		zfcp_port_put(port);
+	}
 }
 
 static void zfcp_scsi_rport_register(struct zfcp_port *port)
@@ -534,8 +545,10 @@ static void zfcp_scsi_rport_register(struct zfcp_port *port)
 
 static void zfcp_scsi_rport_block(struct zfcp_port *port)
 {
-	if (port->rport)
-		fc_remote_port_delete(port->rport);
+	struct fc_rport *rport = port->rport;
+
+	if (rport)
+		fc_remote_port_delete(rport);
 }
 
 void zfcp_scsi_schedule_rport_register(struct zfcp_port *port)
@@ -583,6 +596,23 @@ void zfcp_scsi_rport_work(struct work_struct *work)
 }
 
 
+void zfcp_scsi_scan(struct work_struct *work)
+{
+	struct zfcp_unit *unit = container_of(work, struct zfcp_unit,
+					      scsi_work);
+	struct fc_rport *rport;
+
+	flush_work(&unit->port->rport_work);
+	rport = unit->port->rport;
+
+	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
+		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
+				 scsilun_to_int((struct scsi_lun *)
+						&unit->fcp_lun), 0);
+
+	zfcp_unit_put(unit);
+}
+
 struct fc_function_template zfcp_transport_functions = {
 	.show_starget_port_id = 1,
 	.show_starget_port_name = 1,
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 9a3b8e2..3e51e64 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -254,12 +254,21 @@ static ssize_t zfcp_sysfs_unit_remove_store(struct device *dev,
 
 	write_lock_irq(&zfcp_data.config_lock);
 	unit = zfcp_get_unit_by_lun(port, fcp_lun);
-	if (unit && (atomic_read(&unit->refcount) == 0)) {
-		zfcp_unit_get(unit);
-		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
-		list_move(&unit->list, &unit_remove_lh);
-	} else
-		unit = NULL;
+	if (unit) {
+		write_unlock_irq(&zfcp_data.config_lock);
+		/* wait for possible timeout during SCSI probe */
+		flush_work(&unit->scsi_work);
+		write_lock_irq(&zfcp_data.config_lock);
+
+		if (atomic_read(&unit->refcount) == 0) {
+			zfcp_unit_get(unit);
+			atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE,
+					&unit->status);
+			list_move(&unit->list, &unit_remove_lh);
+		} else {
+			unit = NULL;
+		}
+	}
 
 	write_unlock_irq(&zfcp_data.config_lock);
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index d362860..59b0958 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -34,7 +34,7 @@
 #include "cxgb3i_offload.h"
 #include "cxgb3i_ddp.h"
 
-#define CXGB3I_SCSI_QDEPTH_DFLT	128
+#define CXGB3I_SCSI_HOST_QDEPTH 1024
 #define CXGB3I_MAX_TARGET	CXGB3I_MAX_CONN
 #define CXGB3I_MAX_LUN		512
 #define ISCSI_PDU_NONPAYLOAD_MAX \
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index d06a661..99c9125 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -120,20 +120,26 @@ static void clear_ddp_map(struct cxgb3i_ddp_info *ddp, unsigned int tag,
 }
 
 static inline int ddp_find_unused_entries(struct cxgb3i_ddp_info *ddp,
-					  int start, int max, int count,
+					  unsigned int start, unsigned int max,
+					  unsigned int count,
 					  struct cxgb3i_gather_list *gl)
 {
-	unsigned int i, j;
+	unsigned int i, j, k;
 
+	/* not enough entries */
+	if ((max - start) < count)
+		return -EBUSY;
+
+	max -= count;
 	spin_lock(&ddp->map_lock);
-	for (i = start; i <= max;) {
-		for (j = 0; j < count; j++) {
-			if (ddp->gl_map[i + j])
+	for (i = start; i < max;) {
+		for (j = 0, k = i; j < count; j++, k++) {
+			if (ddp->gl_map[k])
 				break;
 		}
 		if (j == count) {
-			for (j = 0; j < count; j++)
-				ddp->gl_map[i + j] = gl;
+			for (j = 0, k = i; j < count; j++, k++)
+				ddp->gl_map[k] = gl;
 			spin_unlock(&ddp->map_lock);
 			return i;
 		}
@@ -354,7 +360,7 @@ int cxgb3i_ddp_tag_reserve(struct t3cdev *tdev, unsigned int tid,
 	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
 	struct pagepod_hdr hdr;
 	unsigned int npods;
-	int idx = -1, idx_max;
+	int idx = -1;
 	int err = -ENOMEM;
 	u32 sw_tag = *tagp;
 	u32 tag;
@@ -367,17 +373,17 @@ int cxgb3i_ddp_tag_reserve(struct t3cdev *tdev, unsigned int tid,
 	}
 
 	npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
-	idx_max = ddp->nppods - npods + 1;
 
 	if (ddp->idx_last == ddp->nppods)
-		idx = ddp_find_unused_entries(ddp, 0, idx_max, npods, gl);
+		idx = ddp_find_unused_entries(ddp, 0, ddp->nppods, npods, gl);
 	else {
 		idx = ddp_find_unused_entries(ddp, ddp->idx_last + 1,
-					      idx_max, npods, gl);
-		if (idx < 0 && ddp->idx_last >= npods)
+					      ddp->nppods, npods, gl);
+		if (idx < 0 && ddp->idx_last >= npods) {
 			idx = ddp_find_unused_entries(ddp, 0,
-						      ddp->idx_last - npods + 1,
+				min(ddp->idx_last + npods, ddp->nppods),
 						      npods, gl);
+		}
 	}
 	if (idx < 0) {
 		ddp_log_debug("xferlen %u, gl %u, npods %u NO DDP.\n",
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index fff8e43..9212400 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -876,13 +876,14 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.proc_name		= "cxgb3i",
 	.queuecommand		= iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
-	.can_queue		= CXGB3I_SCSI_QDEPTH_DFLT - 1,
+	.can_queue		= CXGB3I_SCSI_HOST_QDEPTH,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= 0xFFFF,
-	.cmd_per_lun		= CXGB3I_SCSI_QDEPTH_DFLT,
+	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler	= iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_target_reset,
+	.target_alloc		= iscsi_target_alloc,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.this_id		= -1,
 };
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index 4d8654c..e11c9c1 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1737,7 +1737,7 @@ int cxgb3i_c3cn_send_pdus(struct s3_conn *c3cn, struct sk_buff *skb)
 		c3cn_tx_debug("c3cn 0x%p, snd %u - %u > %u.\n",
 				c3cn, c3cn->write_seq, c3cn->snd_una,
 				cxgb3_snd_win);
-		err = -EAGAIN;
+		err = -ENOBUFS;
 		goto out_err;
 	}
 
@@ -1775,6 +1775,8 @@ done:
 out_err:
 	if (copied == 0 && err == -EPIPE)
 		copied = c3cn->err ? c3cn->err : -EPIPE;
+	else
+		copied = err;
 	goto done;
 }
 
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index 7eebc9a..7091050 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -400,17 +400,18 @@ int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
 		return 0;
 	}
 
-	if (err < 0 && err != -EAGAIN) {
-		kfree_skb(skb);
-		cxgb3i_tx_debug("itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
-				task->itt, skb, skb->len, skb->data_len, err);
-		iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
-		iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
+	if (err == -EAGAIN || err == -ENOBUFS) {
+		/* reset skb to send when we are called again */
+		tdata->skb = skb;
 		return err;
 	}
-	/* reset skb to send when we are called again */
-	tdata->skb = skb;
-	return -EAGAIN;
+
+	kfree_skb(skb);
+	cxgb3i_tx_debug("itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
+			task->itt, skb, skb->len, skb->data_len, err);
+	iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
+	iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
+	return err;
 }
 
 int cxgb3i_pdu_init(void)
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 94e1e31..03e1926 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -57,7 +57,7 @@ DEFINE_RWLOCK(fcoe_hostlist_lock);
 DEFINE_TIMER(fcoe_timer, NULL, 0, 0);
 DEFINE_PER_CPU(struct fcoe_percpu_s, fcoe_percpu);
 
-/* Function Prototyes */
+/* Function Prototypes */
 static int fcoe_reset(struct Scsi_Host *shost);
 static int fcoe_xmit(struct fc_lport *, struct fc_frame *);
 static int fcoe_rcv(struct sk_buff *, struct net_device *,
@@ -138,7 +138,6 @@ static struct scsi_host_template fcoe_shost_template = {
 /**
  * fcoe_lport_config() - sets up the fc_lport
  * @lp: ptr to the fc_lport
- * @shost: ptr to the parent scsi host
  *
  * Returns: 0 for success
  */
@@ -256,6 +255,7 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_unicast_add(fc->real_dev, flogi_maddr, ETH_ALEN);
+	dev_mc_add(fc->real_dev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 
 	/*
@@ -380,7 +380,7 @@ static int fcoe_if_destroy(struct net_device *netdev)
 	dev_mc_delete(fc->real_dev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 
-	/* Free the per-CPU revieve threads */
+	/* Free the per-CPU receive threads */
 	fcoe_percpu_clean(lp);
 
 	/* Free existing skbs */
@@ -720,7 +720,7 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 	}
 #else
 	/*
-	 * This a non-SMP scenario where the singluar Rx thread is
+	 * This a non-SMP scenario where the singular Rx thread is
 	 * being removed. Free all skbs and stop the thread.
 	 */
 	spin_lock_bh(&p->fcoe_rx_list.lock);
@@ -777,7 +777,7 @@ static struct notifier_block fcoe_cpu_notifier = {
  * @skb: the receive skb
  * @dev: associated net device
  * @ptype: context
- * @odldev: last device
+ * @olddev: last device
  *
  * this function will receive the packet and build fc frame and pass it up
  *
@@ -884,7 +884,6 @@ err2:
 	kfree_skb(skb);
 	return -1;
 }
-EXPORT_SYMBOL_GPL(fcoe_rcv);
 
 /**
  * fcoe_start_io() - pass to netdev to start xmit for fcoe
@@ -905,7 +904,7 @@ static inline int fcoe_start_io(struct sk_buff *skb)
 }
 
 /**
- * fcoe_get_paged_crc_eof() - in case we need alloc a page for crc_eof
+ * fcoe_get_paged_crc_eof() - in case we need to alloc a page for crc_eof
  * @skb: the skb to be xmitted
  * @tlen: total len
  *
@@ -947,7 +946,7 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 
 /**
  * fcoe_fc_crc() - calculates FC CRC in this fcoe skb
- * @fp: the fc_frame containg data to be checksummed
+ * @fp: the fc_frame containing data to be checksummed
  *
  * This uses crc32() to calculate the crc for fc frame
  * Return   : 32 bit crc
@@ -1011,7 +1010,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	wlen = skb->len / FCOE_WORD_TO_BYTE;
 
 	if (!lp->link_up) {
-		kfree(skb);
+		kfree_skb(skb);
 		return 0;
 	}
 
@@ -1062,7 +1061,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 		cp = NULL;
 	}
 
-	/* adjust skb netowrk/transport offsets to match mac/fcoe/fc */
+	/* adjust skb network/transport offsets to match mac/fcoe/fc */
 	skb_push(skb, elen + hlen);
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
@@ -1123,7 +1122,6 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fcoe_xmit);
 
 /**
  * fcoe_percpu_receive_thread() - recv thread per cpu
@@ -1296,17 +1294,16 @@ void fcoe_watchdog(ulong vp)
 
 
 /**
- * fcoe_check_wait_queue() - put the skb into fcoe pending xmit queue
- * @lp: the fc_port for this skb
- * @skb: the associated skb to be xmitted
+ * fcoe_check_wait_queue() - attempt to clear the transmit backlog
+ * @lp: the fc_lport
  *
  * This empties the wait_queue, dequeue the head of the wait_queue queue
  * and calls fcoe_start_io() for each packet, if all skb have been
  * transmitted, return qlen or -1 if a error occurs, then restore
- * wait_queue and  try again later.
+ * wait_queue and try again later.
  *
  * The wait_queue is used when the skb transmit fails. skb will go
- * in the wait_queue which will be emptied by the time function OR
+ * in the wait_queue which will be emptied by the timer function or
  * by the next skb transmit.
  *
  * Returns: 0 for success
@@ -1355,10 +1352,6 @@ out:
  */
 static void fcoe_dev_setup()
 {
-	/*
-	 * here setup a interface specific wd time to
-	 * monitor the link state
-	 */
 	register_netdevice_notifier(&fcoe_notifier);
 }
 
@@ -1437,10 +1430,9 @@ out:
 
 /**
  * fcoe_if_to_netdev() - parse a name buffer to get netdev
- * @ifname: fixed array for output parsed ifname
  * @buffer: incoming buffer to be copied
  *
- * Returns: NULL or ptr to netdeive
+ * Returns: NULL or ptr to net_device
  */
 static struct net_device *fcoe_if_to_netdev(const char *buffer)
 {
@@ -1458,7 +1450,7 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
 }
 
 /**
- * fcoe_netdev_to_module_owner() - finds out the nic drive moddule of the netdev
+ * fcoe_netdev_to_module_owner() - finds out the driver module of the netdev
  * @netdev: the target netdev
  *
  * Returns: ptr to the struct module, NULL for failure
@@ -1488,7 +1480,7 @@ fcoe_netdev_to_module_owner(const struct net_device *netdev)
  * Holds the Ethernet driver module by try_module_get() for
  * the corresponding netdev.
  *
- * Returns: 0 for succsss
+ * Returns: 0 for success
  */
 static int fcoe_ethdrv_get(const struct net_device *netdev)
 {
@@ -1510,7 +1502,7 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
  * Releases the Ethernet driver module by module_put for
  * the corresponding netdev.
  *
- * Returns: 0 for succsss
+ * Returns: 0 for success
  */
 static int fcoe_ethdrv_put(const struct net_device *netdev)
 {
@@ -1528,7 +1520,7 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
 
 /**
  * fcoe_destroy() - handles the destroy from sysfs
- * @buffer: expcted to be a eth if name
+ * @buffer: expected to be an eth if name
  * @kp: associated kernel param
  *
  * Returns: 0 for success
@@ -1565,7 +1557,7 @@ out_nodev:
 
 /**
  * fcoe_create() - Handles the create call from sysfs
- * @buffer: expcted to be a eth if name
+ * @buffer: expected to be an eth if name
  * @kp: associated kernel param
  *
  * Returns: 0 for success
@@ -1652,7 +1644,6 @@ int fcoe_link_ok(struct fc_lport *lp)
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(fcoe_link_ok);
 
 /**
  * fcoe_percpu_clean() - Clear the pending skbs for an lport
@@ -1684,7 +1675,6 @@ void fcoe_percpu_clean(struct fc_lport *lp)
 		spin_unlock_bh(&pp->fcoe_rx_list.lock);
 	}
 }
-EXPORT_SYMBOL_GPL(fcoe_percpu_clean);
 
 /**
  * fcoe_clean_pending_queue() - Dequeue a skb and free it
@@ -1705,7 +1695,6 @@ void fcoe_clean_pending_queue(struct fc_lport *lp)
 	}
 	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
 }
-EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
 
 /**
  * fcoe_reset() - Resets the fcoe
@@ -1719,11 +1708,10 @@ int fcoe_reset(struct Scsi_Host *shost)
 	fc_lport_reset(lport);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fcoe_reset);
 
 /**
  * fcoe_hostlist_lookup_softc() - find the corresponding lport by a given device
- * @device: this is currently ptr to net_device
+ * @dev: this is currently ptr to net_device
  *
  * Returns: NULL or the located fcoe_softc
  */
@@ -1757,11 +1745,10 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 
 	return (fc) ? fc->ctlr.lp : NULL;
 }
-EXPORT_SYMBOL_GPL(fcoe_hostlist_lookup);
 
 /**
  * fcoe_hostlist_add() - Add a lport to lports list
- * @lp: ptr to the fc_lport to badded
+ * @lp: ptr to the fc_lport to be added
  *
  * Returns: 0 for success
  */
@@ -1778,11 +1765,10 @@ int fcoe_hostlist_add(const struct fc_lport *lp)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fcoe_hostlist_add);
 
 /**
  * fcoe_hostlist_remove() - remove a lport from lports list
- * @lp: ptr to the fc_lport to badded
+ * @lp: ptr to the fc_lport to be removed
  *
  * Returns: 0 for success
  */
@@ -1798,7 +1784,6 @@ int fcoe_hostlist_remove(const struct fc_lport *lp)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fcoe_hostlist_remove);
 
 /**
  * fcoe_init() - fcoe module loading initialization
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index f410f4a..62ba0f3 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -122,7 +122,7 @@ static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
 }
 
 /**
- * fcoe_ctrl_destroy() - Disable and tear-down the FCoE controller.
+ * fcoe_ctlr_destroy() - Disable and tear-down the FCoE controller.
  * @fip:	FCoE controller.
  *
  * This is called by FCoE drivers before freeing the &fcoe_ctlr.
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index c09d775..dd689de 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3654,6 +3654,7 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
 	struct ipr_resource_entry *res;
+	struct ata_port *ap = NULL;
 	unsigned long lock_flags = 0;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -3672,12 +3673,16 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 		}
 		if (ipr_is_vset_device(res) || ipr_is_scsi_disk(res))
 			sdev->allow_restart = 1;
-		if (ipr_is_gata(res) && res->sata_port) {
+		if (ipr_is_gata(res) && res->sata_port)
+			ap = res->sata_port->ap;
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+
+		if (ap) {
 			scsi_adjust_queue_depth(sdev, 0, IPR_MAX_CMD_PER_ATA_LUN);
-			ata_sas_slave_configure(sdev, res->sata_port->ap);
-		} else {
+			ata_sas_slave_configure(sdev, ap);
+		} else
 			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
-		}
+		return 0;
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return 0;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b3e5e08..b7c092d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -463,7 +463,7 @@ static int iscsi_sw_tcp_pdu_init(struct iscsi_task *task,
 	}
 
 	if (err) {
-		iscsi_conn_failure(conn, err);
+		/* got invalid offset/len */
 		return -EIO;
 	}
 	return 0;
@@ -851,6 +851,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.use_clustering         = DISABLE_CLUSTERING,
 	.slave_alloc            = iscsi_sw_tcp_slave_alloc,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
+	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 };
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index e57556e..4c88065 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -113,6 +113,11 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 		lport->tt.rport_logoff(rport);
 	}
 
+	list_for_each_entry_safe(rdata, next, &disc->rogue_rports, peers) {
+		rport = PRIV_TO_RPORT(rdata);
+		lport->tt.rport_logoff(rport);
+	}
+
 	mutex_unlock(&disc->disc_mutex);
 }
 
@@ -131,23 +136,32 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_disc *disc = &lport->disc;
-	int found = 0;
 
 	FC_DEBUG_DISC("Received a %d event for port (%6x)\n", event,
 		      rport->port_id);
 
-	if (event == RPORT_EV_CREATED) {
+	switch (event) {
+	case RPORT_EV_CREATED:
 		if (disc) {
-			found = 1;
 			mutex_lock(&disc->disc_mutex);
 			list_add_tail(&rdata->peers, &disc->rports);
 			mutex_unlock(&disc->disc_mutex);
 		}
+		break;
+	case RPORT_EV_LOGO:
+	case RPORT_EV_FAILED:
+	case RPORT_EV_STOP:
+		mutex_lock(&disc->disc_mutex);
+		mutex_lock(&rdata->rp_mutex);
+		if (rdata->trans_state == FC_PORTSTATE_ROGUE)
+			list_del(&rdata->peers);
+		mutex_unlock(&rdata->rp_mutex);
+		mutex_unlock(&disc->disc_mutex);
+		break;
+	default:
+		break;
 	}
 
-	if (!found)
-		FC_DEBUG_DISC("The rport (%6x) is not maintained "
-			      "by the discovery layer\n", rport->port_id);
 }
 
 /**
@@ -439,6 +453,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 			rdata = rport->dd_data;
 			rdata->ops = &fc_disc_rport_ops;
 			rdata->rp_state = RPORT_ST_INIT;
+			list_add_tail(&rdata->peers, &disc->rogue_rports);
 			lport->tt.rport_login(rport);
 		}
 	}
@@ -461,21 +476,29 @@ static void fc_disc_del_target(struct fc_disc *disc, struct fc_rport *rport)
 /**
  * fc_disc_done() - Discovery has been completed
  * @disc: FC discovery context
+ * Locking Note: This function expects that the disc mutex is locked before
+ * it is called. The discovery callback is then made with the lock released,
+ * and the lock is re-taken before returning from this function
  */
 static void fc_disc_done(struct fc_disc *disc)
 {
 	struct fc_lport *lport = disc->lport;
+	enum fc_disc_event event;
 
 	FC_DEBUG_DISC("Discovery complete for port (%6x)\n",
 		      fc_host_port_id(lport->host));
 
-	disc->disc_callback(lport, disc->event);
+	event = disc->event;
 	disc->event = DISC_EV_NONE;
 
 	if (disc->requested)
 		fc_disc_gpn_ft_req(disc);
 	else
 		disc->pending = 0;
+
+	mutex_unlock(&disc->disc_mutex);
+	disc->disc_callback(lport, event);
+	mutex_lock(&disc->disc_mutex);
 }
 
 /**
@@ -622,6 +645,8 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 				rdata = rport->dd_data;
 				rdata->ops = &fc_disc_rport_ops;
 				rdata->local_port = lport;
+				list_add_tail(&rdata->peers,
+					      &disc->rogue_rports);
 				lport->tt.rport_login(rport);
 			} else
 				FC_DBG("Failed to allocate memory for "
@@ -681,8 +706,8 @@ static void fc_disc_timeout(struct work_struct *work)
  * @fp: response frame
  * @lp_arg: Fibre Channel host port instance
  *
- * Locking Note: This function expects that the disc_mutex is locked
- *		 before it is called.
+ * Locking Note: This function is called without disc mutex held, and
+ *		 should do all its processing with the mutex held
  */
 static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 				void *disc_arg)
@@ -695,11 +720,13 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	unsigned int len;
 	int error;
 
+	mutex_lock(&disc->disc_mutex);
 	FC_DEBUG_DISC("Received a GPN_FT response on port (%6x)\n",
 		      fc_host_port_id(disc->lport->host));
 
 	if (IS_ERR(fp)) {
 		fc_disc_error(disc, fp);
+		mutex_unlock(&disc->disc_mutex);
 		return;
 	}
 
@@ -744,6 +771,8 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 			disc->seq_count++;
 	}
 	fc_frame_free(fp);
+
+	mutex_unlock(&disc->disc_mutex);
 }
 
 /**
@@ -757,7 +786,6 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 {
 	struct fc_lport *lport;
-	struct fc_rport *rport;
 	struct fc_rport *new_rport;
 	struct fc_rport_libfc_priv *rdata;
 
@@ -766,15 +794,12 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 	if (dp->ids.port_id == fc_host_port_id(lport->host))
 		goto out;
 
-	rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
-	if (rport)
-		fc_disc_del_target(disc, rport);
-
 	new_rport = lport->tt.rport_create(dp);
 	if (new_rport) {
 		rdata = new_rport->dd_data;
 		rdata->ops = &fc_disc_rport_ops;
 		kfree(dp);
+		list_add_tail(&rdata->peers, &disc->rogue_rports);
 		lport->tt.rport_login(new_rport);
 	}
 	return;
@@ -836,6 +861,7 @@ int fc_disc_init(struct fc_lport *lport)
 	INIT_DELAYED_WORK(&disc->disc_work, fc_disc_timeout);
 	mutex_init(&disc->disc_mutex);
 	INIT_LIST_HEAD(&disc->rports);
+	INIT_LIST_HEAD(&disc->rogue_rports);
 
 	disc->lport = lport;
 	disc->delay = FC_DISC_DELAY;
diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index dd47fe6..5878b34 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -41,7 +41,7 @@ static struct fc_seq *fc_elsct_send(struct fc_lport *lport,
 				    void *arg, u32 timer_msec)
 {
 	enum fc_rctl r_ctl;
-	u32 did;
+	u32 did = FC_FID_NONE;
 	enum fc_fh_type fh_type;
 	int rc;
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f555ae9..521f996 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -713,7 +713,7 @@ done:
 static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 {
 	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)arg;
-	struct fc_lport *lp;
+	struct fc_lport *lport = fsp->lp;
 	struct fc_frame_header *fh;
 	struct fcp_txrdy *dd;
 	u8 r_ctl;
@@ -724,9 +724,8 @@ static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 
 	fh = fc_frame_header_get(fp);
 	r_ctl = fh->fh_r_ctl;
-	lp = fsp->lp;
 
-	if (!(lp->state & LPORT_ST_READY))
+	if (!(lport->state & LPORT_ST_READY))
 		goto out;
 	if (fc_fcp_lock_pkt(fsp))
 		goto out;
@@ -779,7 +778,7 @@ errout:
 	if (IS_ERR(fp))
 		fc_fcp_error(fsp, fp);
 	else if (rc == -ENOMEM)
-		fc_fcp_reduce_can_queue(lp);
+		fc_fcp_reduce_can_queue(lport);
 }
 
 static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index b8178ef..e0c2477 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -618,6 +618,11 @@ int fc_fabric_logoff(struct fc_lport *lport)
 {
 	lport->tt.disc_stop_final(lport);
 	mutex_lock(&lport->lp_mutex);
+	if (lport->dns_rp)
+		lport->tt.rport_logoff(lport->dns_rp);
+	mutex_unlock(&lport->lp_mutex);
+	lport->tt.rport_flush_queue();
+	mutex_lock(&lport->lp_mutex);
 	fc_lport_enter_logo(lport);
 	mutex_unlock(&lport->lp_mutex);
 	cancel_delayed_work_sync(&lport->retry_work);
@@ -639,7 +644,12 @@ EXPORT_SYMBOL(fc_fabric_logoff);
  */
 int fc_lport_destroy(struct fc_lport *lport)
 {
+	mutex_lock(&lport->lp_mutex);
+	lport->state = LPORT_ST_NONE;
+	lport->link_up = 0;
 	lport->tt.frame_send = fc_frame_drop;
+	mutex_unlock(&lport->lp_mutex);
+
 	lport->tt.fcp_abort_io(lport);
 	lport->tt.exch_mgr_reset(lport, 0, 0);
 	return 0;
@@ -1032,17 +1042,19 @@ static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a RFT_ID response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_RFT_ID) {
 		FC_DBG("Received a RFT_ID response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	fh = fc_frame_header_get(fp);
 	ct = fc_frame_payload_get(fp, sizeof(*ct));
 
@@ -1084,17 +1096,19 @@ static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a RPN_ID response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_RPN_ID) {
 		FC_DBG("Received a RPN_ID response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	fh = fc_frame_header_get(fp);
 	ct = fc_frame_payload_get(fp, sizeof(*ct));
 	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
@@ -1134,17 +1148,19 @@ static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a SCR response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_SCR) {
 		FC_DBG("Received a SCR response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC)
 		fc_lport_enter_ready(lport);
@@ -1360,17 +1376,19 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a LOGO response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_LOGO) {
 		FC_DBG("Received a LOGO response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC)
 		fc_lport_enter_reset(lport);
@@ -1400,10 +1418,6 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 
 	fc_lport_state_enter(lport, LPORT_ST_LOGO);
 
-	/* DNS session should be closed so we can release it here */
-	if (lport->dns_rp)
-		lport->tt.rport_logoff(lport->dns_rp);
-
 	fp = fc_frame_alloc(lport, sizeof(*logo));
 	if (!fp) {
 		fc_lport_error(lport, fp);
@@ -1444,17 +1458,19 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a FLOGI response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_FLOGI) {
 		FC_DBG("Received a FLOGI response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	fh = fc_frame_header_get(fp);
 	did = ntoh24(fh->fh_d_id);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 0472bb7..747d73c 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -267,6 +267,10 @@ static void fc_rport_work(struct work_struct *work)
 			       "(%6x).\n", ids.port_id);
 			event = RPORT_EV_FAILED;
 		}
+		if (rport->port_id != FC_FID_DIR_SERV)
+			if (rport_ops->event_callback)
+				rport_ops->event_callback(lport, rport,
+							  RPORT_EV_FAILED);
 		put_device(&rport->dev);
 		rport = new_rport;
 		rdata = new_rport->dd_data;
@@ -325,11 +329,20 @@ int fc_rport_login(struct fc_rport *rport)
 int fc_rport_logoff(struct fc_rport *rport)
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
 
 	mutex_lock(&rdata->rp_mutex);
 
 	FC_DEBUG_RPORT("Remove port (%6x)\n", rport->port_id);
 
+	if (rdata->rp_state == RPORT_ST_NONE) {
+		FC_DEBUG_RPORT("(%6x): Port (%6x) in NONE state,"
+			       " not removing", fc_host_port_id(lport->host),
+			       rport->port_id);
+		mutex_unlock(&rdata->rp_mutex);
+		goto out;
+	}
+
 	fc_rport_enter_logo(rport);
 
 	/*
@@ -349,6 +362,7 @@ int fc_rport_logoff(struct fc_rport *rport)
 
 	mutex_unlock(&rdata->rp_mutex);
 
+out:
 	return 0;
 }
 
@@ -430,6 +444,7 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 	case RPORT_ST_PRLI:
 	case RPORT_ST_LOGO:
 		rdata->event = RPORT_EV_FAILED;
+		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue,
 			   &rdata->event_work);
 		break;
@@ -494,7 +509,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_rport *rport = rp_arg;
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
-	struct fc_els_flogi *plp;
+	struct fc_els_flogi *plp = NULL;
 	unsigned int tov;
 	u16 csp_seq;
 	u16 cssp_seq;
@@ -505,17 +520,19 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a PLOGI response from port (%6x)\n",
 		       rport->port_id);
 
-	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
-		goto err;
-	}
-
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
 		FC_DBG("Received a PLOGI response, but in state %s\n",
 		       fc_rport_state(rport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC &&
 	    (plp = fc_frame_payload_get(fp, sizeof(*plp))) != NULL) {
@@ -614,17 +631,19 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a PRLI response from port (%6x)\n",
 		       rport->port_id);
 
-	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
-		goto err;
-	}
-
 	if (rdata->rp_state != RPORT_ST_PRLI) {
 		FC_DBG("Received a PRLI response, but in state %s\n",
 		       fc_rport_state(rport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		pp = fc_frame_payload_get(fp, sizeof(*pp));
@@ -646,6 +665,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	} else {
 		FC_DBG("Bad ELS response\n");
 		rdata->event = RPORT_EV_FAILED;
+		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue, &rdata->event_work);
 	}
 
@@ -678,23 +698,26 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a LOGO response from port (%6x)\n",
 		       rport->port_id);
 
-	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
-		goto err;
-	}
-
 	if (rdata->rp_state != RPORT_ST_LOGO) {
 		FC_DEBUG_RPORT("Received a LOGO response, but in state %s\n",
 			       fc_rport_state(rport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		fc_rport_enter_rtv(rport);
 	} else {
 		FC_DBG("Bad ELS response\n");
 		rdata->event = RPORT_EV_LOGO;
+		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue, &rdata->event_work);
 	}
 
@@ -764,17 +787,19 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a RTV response from port (%6x)\n",
 		       rport->port_id);
 
-	if (IS_ERR(fp)) {
-		fc_rport_error(rport, fp);
-		goto err;
-	}
-
 	if (rdata->rp_state != RPORT_ST_RTV) {
 		FC_DBG("Received a RTV response, but in state %s\n",
 		       fc_rport_state(rport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_rport_error(rport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		struct fc_els_rtv_acc *rtv;
@@ -1007,6 +1032,8 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 	default:
 		FC_DEBUG_RPORT("incoming PLOGI from %x in unexpected "
 			       "state %d\n", sid, rdata->rp_state);
+		fc_frame_free(fp);
+		return;
 		break;
 	}
 
@@ -1098,6 +1125,8 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 		reason = ELS_RJT_NONE;
 		break;
 	default:
+		fc_frame_free(rx_fp);
+		return;
 		break;
 	}
 	len = fr_len(rx_fp) - sizeof(*fh);
@@ -1227,6 +1256,11 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 		       "while in state %s\n", ntoh24(fh->fh_s_id),
 		       fc_rport_state(rport));
 
+	if (rdata->rp_state == RPORT_ST_NONE) {
+		fc_frame_free(fp);
+		return;
+	}
+
 	rjt_data.fp = NULL;
 	rjt_data.reason = ELS_RJT_UNAB;
 	rjt_data.explan = ELS_EXPL_NONE;
@@ -1256,7 +1290,13 @@ static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
 		       "while in state %s\n", ntoh24(fh->fh_s_id),
 		       fc_rport_state(rport));
 
+	if (rdata->rp_state == RPORT_ST_NONE) {
+		fc_frame_free(fp);
+		return;
+	}
+
 	rdata->event = RPORT_EV_LOGO;
+	fc_rport_state_enter(rport, RPORT_ST_NONE);
 	queue_work(rport_event_queue, &rdata->event_work);
 
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6896283..e72b4ad 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1463,6 +1463,16 @@ int iscsi_change_queue_depth(struct scsi_device *sdev, int depth)
 }
 EXPORT_SYMBOL_GPL(iscsi_change_queue_depth);
 
+int iscsi_target_alloc(struct scsi_target *starget)
+{
+	struct iscsi_cls_session *cls_session = starget_to_session(starget);
+	struct iscsi_session *session = cls_session->dd_data;
+
+	starget->can_queue = session->scsi_cmds_max;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iscsi_target_alloc);
+
 void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = cls_session->dd_data;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 91f8ce4..b579ca9 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1036,8 +1036,11 @@ flush:
 
 	rc = conn->session->tt->init_pdu(task, r2t->data_offset + r2t->sent,
 					 r2t->data_count);
-	if (rc)
+	if (rc) {
+		iscsi_conn_failure(conn, ISCSI_ERR_XMIT_FAILED);
 		return rc;
+	}
+
 	r2t->sent += r2t->data_count;
 	goto flush;
 }
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index dcba267..1105f9a 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -443,6 +443,7 @@ struct lpfc_hba {
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
 
+#define DEFER_ERATT		0x4 /* Deferred error attention in progress */
 	struct lpfc_dmabuf slim2p;
 
 	MAILBOX_t *mbox;
@@ -723,4 +724,3 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 
 	return;
 }
-
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 40cf0f4..c14f0cb 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -51,7 +51,7 @@
 #define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8"
 
 /**
- * lpfc_jedec_to_ascii: Hex to ascii convertor according to JEDEC rules.
+ * lpfc_jedec_to_ascii - Hex to ascii convertor according to JEDEC rules
  * @incr: integer to convert.
  * @hdw: ascii string holding converted integer plus a string terminator.
  *
@@ -82,7 +82,7 @@ lpfc_jedec_to_ascii(int incr, char hdw[])
 }
 
 /**
- * lpfc_drvr_version_show: Return the Emulex driver string with version number.
+ * lpfc_drvr_version_show - Return the Emulex driver string with version number
  * @dev: class unused variable.
  * @attr: device attribute, not used.
  * @buf: on return contains the module description text.
@@ -152,7 +152,7 @@ lpfc_bg_reftag_err_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_info_show: Return some pci info about the host in ascii.
+ * lpfc_info_show - Return some pci info about the host in ascii
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the formatted text from lpfc_info().
@@ -169,7 +169,7 @@ lpfc_info_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_serialnum_show: Return the hba serial number in ascii.
+ * lpfc_serialnum_show - Return the hba serial number in ascii
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the formatted text serial number.
@@ -188,7 +188,7 @@ lpfc_serialnum_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_temp_sensor_show: Return the temperature sensor level.
+ * lpfc_temp_sensor_show - Return the temperature sensor level
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the formatted support level.
@@ -210,7 +210,7 @@ lpfc_temp_sensor_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_modeldesc_show: Return the model description of the hba.
+ * lpfc_modeldesc_show - Return the model description of the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd model description.
@@ -229,7 +229,7 @@ lpfc_modeldesc_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_modelname_show: Return the model name of the hba.
+ * lpfc_modelname_show - Return the model name of the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd model name.
@@ -248,7 +248,7 @@ lpfc_modelname_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_programtype_show: Return the program type of the hba.
+ * lpfc_programtype_show - Return the program type of the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd program type.
@@ -267,7 +267,7 @@ lpfc_programtype_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_mlomgmt_show: Return the Menlo Maintenance sli flag.
+ * lpfc_mlomgmt_show - Return the Menlo Maintenance sli flag
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the Menlo Maintenance sli flag.
@@ -286,7 +286,7 @@ lpfc_mlomgmt_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /**
- * lpfc_vportnum_show: Return the port number in ascii of the hba.
+ * lpfc_vportnum_show - Return the port number in ascii of the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains scsi vpd program type.
@@ -305,7 +305,7 @@ lpfc_vportnum_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_fwrev_show: Return the firmware rev running in the hba.
+ * lpfc_fwrev_show - Return the firmware rev running in the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd program type.
@@ -326,7 +326,7 @@ lpfc_fwrev_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_hdw_show: Return the jedec information about the hba.
+ * lpfc_hdw_show - Return the jedec information about the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd program type.
@@ -347,7 +347,7 @@ lpfc_hdw_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /**
- * lpfc_option_rom_version_show: Return the adapter ROM FCode version.
+ * lpfc_option_rom_version_show - Return the adapter ROM FCode version
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the ROM and FCode ascii strings.
@@ -366,7 +366,7 @@ lpfc_option_rom_version_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_state_show: Return the link state of the port.
+ * lpfc_state_show - Return the link state of the port
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains text describing the state of the link.
@@ -451,7 +451,7 @@ lpfc_link_state_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_num_discovered_ports_show: Return sum of mapped and unmapped vports.
+ * lpfc_num_discovered_ports_show - Return sum of mapped and unmapped vports
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the sum of fc mapped and unmapped.
@@ -474,7 +474,7 @@ lpfc_num_discovered_ports_show(struct device *dev,
 }
 
 /**
- * lpfc_issue_lip: Misnomer, name carried over from long ago.
+ * lpfc_issue_lip - Misnomer, name carried over from long ago
  * @shost: Scsi_Host pointer.
  *
  * Description:
@@ -529,7 +529,7 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_do_offline: Issues a mailbox command to bring the link down.
+ * lpfc_do_offline - Issues a mailbox command to bring the link down
  * @phba: lpfc_hba pointer.
  * @type: LPFC_EVT_OFFLINE, LPFC_EVT_WARM_START, LPFC_EVT_KILL.
  *
@@ -537,7 +537,7 @@ lpfc_issue_lip(struct Scsi_Host *shost)
  * Assumes any error from lpfc_do_offline() will be negative.
  * Can wait up to 5 seconds for the port ring buffers count
  * to reach zero, prints a warning if it is not zero and continues.
- * lpfc_workq_post_event() returns a non-zero return coce if call fails.
+ * lpfc_workq_post_event() returns a non-zero return code if call fails.
  *
  * Returns:
  * -EIO error posting the event
@@ -591,7 +591,7 @@ lpfc_do_offline(struct lpfc_hba *phba, uint32_t type)
 }
 
 /**
- * lpfc_selective_reset: Offline then onlines the port.
+ * lpfc_selective_reset - Offline then onlines the port
  * @phba: lpfc_hba pointer.
  *
  * Description:
@@ -632,7 +632,7 @@ lpfc_selective_reset(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_issue_reset: Selectively resets an adapter.
+ * lpfc_issue_reset - Selectively resets an adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: containing the string "selective".
@@ -672,7 +672,7 @@ lpfc_issue_reset(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_nport_evt_cnt_show: Return the number of nport events.
+ * lpfc_nport_evt_cnt_show - Return the number of nport events
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the ascii number of nport events.
@@ -691,7 +691,7 @@ lpfc_nport_evt_cnt_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_board_mode_show: Return the state of the board.
+ * lpfc_board_mode_show - Return the state of the board
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the state of the adapter.
@@ -720,7 +720,7 @@ lpfc_board_mode_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_board_mode_store: Puts the hba in online, offline, warm or error state.
+ * lpfc_board_mode_store - Puts the hba in online, offline, warm or error state
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: containing one of the strings "online", "offline", "warm" or "error".
@@ -766,14 +766,14 @@ lpfc_board_mode_store(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_get_hba_info: Return various bits of informaton about the adapter.
+ * lpfc_get_hba_info - Return various bits of informaton about the adapter
  * @phba: pointer to the adapter structure.
- * @mxri max xri count.
- * @axri available xri count.
- * @mrpi max rpi count.
- * @arpi available rpi count.
- * @mvpi max vpi count.
- * @avpi available vpi count.
+ * @mxri: max xri count.
+ * @axri: available xri count.
+ * @mrpi: max rpi count.
+ * @arpi: available rpi count.
+ * @mvpi: max vpi count.
+ * @avpi: available vpi count.
  *
  * Description:
  * If an integer pointer for an count is not null then the value for the
@@ -846,7 +846,7 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_max_rpi_show: Return maximum rpi.
+ * lpfc_max_rpi_show - Return maximum rpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the maximum rpi count in decimal or "Unknown".
@@ -874,7 +874,7 @@ lpfc_max_rpi_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_used_rpi_show: Return maximum rpi minus available rpi.
+ * lpfc_used_rpi_show - Return maximum rpi minus available rpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: containing the used rpi count in decimal or "Unknown".
@@ -902,7 +902,7 @@ lpfc_used_rpi_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_max_xri_show: Return maximum xri.
+ * lpfc_max_xri_show - Return maximum xri
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the maximum xri count in decimal or "Unknown".
@@ -930,7 +930,7 @@ lpfc_max_xri_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_used_xri_show: Return maximum xpi minus the available xpi.
+ * lpfc_used_xri_show - Return maximum xpi minus the available xpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the used xri count in decimal or "Unknown".
@@ -958,7 +958,7 @@ lpfc_used_xri_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_max_vpi_show: Return maximum vpi.
+ * lpfc_max_vpi_show - Return maximum vpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the maximum vpi count in decimal or "Unknown".
@@ -986,7 +986,7 @@ lpfc_max_vpi_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_used_vpi_show: Return maximum vpi minus the available vpi.
+ * lpfc_used_vpi_show - Return maximum vpi minus the available vpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the used vpi count in decimal or "Unknown".
@@ -1014,7 +1014,7 @@ lpfc_used_vpi_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_npiv_info_show: Return text about NPIV support for the adapter.
+ * lpfc_npiv_info_show - Return text about NPIV support for the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: text that must be interpreted to determine if npiv is supported.
@@ -1042,7 +1042,7 @@ lpfc_npiv_info_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_poll_show: Return text about poll support for the adapter.
+ * lpfc_poll_show - Return text about poll support for the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the cfg_poll in hex.
@@ -1064,7 +1064,7 @@ lpfc_poll_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_poll_store: Set the value of cfg_poll for the adapter.
+ * lpfc_poll_store - Set the value of cfg_poll for the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: one or more lpfc_polling_flags values.
@@ -1136,7 +1136,7 @@ lpfc_poll_store(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_param_show: Return a cfg attribute value in decimal.
+ * lpfc_param_show - Return a cfg attribute value in decimal
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1164,7 +1164,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
 }
 
 /**
- * lpfc_param_hex_show: Return a cfg attribute value in hex.
+ * lpfc_param_hex_show - Return a cfg attribute value in hex
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1173,7 +1173,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
  * lpfc_##attr##_show: Return the hex value of an adapters cfg_xxx field.
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
- * @buf: on return contains the attribute value in hexidecimal.
+ * @buf: on return contains the attribute value in hexadecimal.
  *
  * Returns: size of formatted string.
  **/
@@ -1192,7 +1192,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
 }
 
 /**
- * lpfc_param_init: Intializes a cfg attribute.
+ * lpfc_param_init - Intializes a cfg attribute
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1226,7 +1226,7 @@ lpfc_##attr##_init(struct lpfc_hba *phba, int val) \
 }
 
 /**
- * lpfc_param_set: Set a cfg attribute value.
+ * lpfc_param_set - Set a cfg attribute value
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1260,7 +1260,7 @@ lpfc_##attr##_set(struct lpfc_hba *phba, int val) \
 }
 
 /**
- * lpfc_param_store: Set a vport attribute value.
+ * lpfc_param_store - Set a vport attribute value
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1300,7 +1300,7 @@ lpfc_##attr##_store(struct device *dev, struct device_attribute *attr, \
 }
 
 /**
- * lpfc_vport_param_show: Return decimal formatted cfg attribute value.
+ * lpfc_vport_param_show - Return decimal formatted cfg attribute value
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1326,17 +1326,17 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
 }
 
 /**
- * lpfc_vport_param_hex_show: Return hex formatted attribute value.
+ * lpfc_vport_param_hex_show - Return hex formatted attribute value
  *
  * Description:
  * Macro that given an attr e.g.
  * hba_queue_depth expands into a function with the name
  * lpfc_hba_queue_depth_show
  *
- * lpfc_##attr##_show: prints the attribute value in hexidecimal.
+ * lpfc_##attr##_show: prints the attribute value in hexadecimal.
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
- * @buf: on return contains the attribute value in hexidecimal.
+ * @buf: on return contains the attribute value in hexadecimal.
  *
  * Returns: length of formatted string.
  **/
@@ -1353,7 +1353,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
 }
 
 /**
- * lpfc_vport_param_init: Initialize a vport cfg attribute.
+ * lpfc_vport_param_init - Initialize a vport cfg attribute
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1386,7 +1386,7 @@ lpfc_##attr##_init(struct lpfc_vport *vport, int val) \
 }
 
 /**
- * lpfc_vport_param_set: Set a vport cfg attribute.
+ * lpfc_vport_param_set - Set a vport cfg attribute
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1417,7 +1417,7 @@ lpfc_##attr##_set(struct lpfc_vport *vport, int val) \
 }
 
 /**
- * lpfc_vport_param_store: Set a vport attribute.
+ * lpfc_vport_param_store - Set a vport attribute
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth
@@ -1576,7 +1576,7 @@ static DEVICE_ATTR(lpfc_temp_sensor, S_IRUGO, lpfc_temp_sensor_show, NULL);
 static char *lpfc_soft_wwn_key = "C99G71SL8032A";
 
 /**
- * lpfc_soft_wwn_enable_store: Allows setting of the wwn if the key is valid.
+ * lpfc_soft_wwn_enable_store - Allows setting of the wwn if the key is valid
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: containing the string lpfc_soft_wwn_key.
@@ -1623,10 +1623,10 @@ static DEVICE_ATTR(lpfc_soft_wwn_enable, S_IWUSR, NULL,
 		   lpfc_soft_wwn_enable_store);
 
 /**
- * lpfc_soft_wwpn_show: Return the cfg soft ww port name of the adapter.
+ * lpfc_soft_wwpn_show - Return the cfg soft ww port name of the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
- * @buf: on return contains the wwpn in hexidecimal.
+ * @buf: on return contains the wwpn in hexadecimal.
  *
  * Returns: size of formatted string.
  **/
@@ -1643,10 +1643,10 @@ lpfc_soft_wwpn_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_soft_wwpn_store: Set the ww port name of the adapter.
+ * lpfc_soft_wwpn_store - Set the ww port name of the adapter
  * @dev class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
- * @buf: contains the wwpn in hexidecimal.
+ * @buf: contains the wwpn in hexadecimal.
  * @count: number of wwpn bytes in buf
  *
  * Returns:
@@ -1729,10 +1729,10 @@ static DEVICE_ATTR(lpfc_soft_wwpn, S_IRUGO | S_IWUSR,\
 		   lpfc_soft_wwpn_show, lpfc_soft_wwpn_store);
 
 /**
- * lpfc_soft_wwnn_show: Return the cfg soft ww node name for the adapter.
+ * lpfc_soft_wwnn_show - Return the cfg soft ww node name for the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
- * @buf: on return contains the wwnn in hexidecimal.
+ * @buf: on return contains the wwnn in hexadecimal.
  *
  * Returns: size of formatted string.
  **/
@@ -1747,9 +1747,9 @@ lpfc_soft_wwnn_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_soft_wwnn_store: sets the ww node name of the adapter.
+ * lpfc_soft_wwnn_store - sets the ww node name of the adapter
  * @cdev: class device that is converted into a Scsi_host.
- * @buf: contains the ww node name in hexidecimal.
+ * @buf: contains the ww node name in hexadecimal.
  * @count: number of wwnn bytes in buf.
  *
  * Returns:
@@ -1845,7 +1845,7 @@ MODULE_PARM_DESC(lpfc_nodev_tmo,
 		 "for a device to come back");
 
 /**
- * lpfc_nodev_tmo_show: Return the hba dev loss timeout value.
+ * lpfc_nodev_tmo_show - Return the hba dev loss timeout value
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the dev loss timeout in decimal.
@@ -1864,7 +1864,7 @@ lpfc_nodev_tmo_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_nodev_tmo_init: Set the hba nodev timeout value.
+ * lpfc_nodev_tmo_init - Set the hba nodev timeout value
  * @vport: lpfc vport structure pointer.
  * @val: contains the nodev timeout value.
  *
@@ -1905,7 +1905,7 @@ lpfc_nodev_tmo_init(struct lpfc_vport *vport, int val)
 }
 
 /**
- * lpfc_update_rport_devloss_tmo: Update dev loss tmo value.
+ * lpfc_update_rport_devloss_tmo - Update dev loss tmo value
  * @vport: lpfc vport structure pointer.
  *
  * Description:
@@ -1926,7 +1926,7 @@ lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_nodev_tmo_set: Set the vport nodev tmo and devloss tmo values.
+ * lpfc_nodev_tmo_set - Set the vport nodev tmo and devloss tmo values
  * @vport: lpfc vport structure pointer.
  * @val: contains the tmo value.
  *
@@ -1982,7 +1982,7 @@ lpfc_vport_param_init(devloss_tmo, LPFC_DEF_DEVLOSS_TMO,
 lpfc_vport_param_show(devloss_tmo)
 
 /**
- * lpfc_devloss_tmo_set: Sets vport nodev tmo, devloss tmo values, changed bit.
+ * lpfc_devloss_tmo_set - Sets vport nodev tmo, devloss tmo values, changed bit
  * @vport: lpfc vport structure pointer.
  * @val: contains the tmo value.
  *
@@ -2094,7 +2094,7 @@ MODULE_PARM_DESC(lpfc_restrict_login,
 lpfc_vport_param_show(restrict_login);
 
 /**
- * lpfc_restrict_login_init: Set the vport restrict login flag.
+ * lpfc_restrict_login_init - Set the vport restrict login flag
  * @vport: lpfc vport structure pointer.
  * @val: contains the restrict login value.
  *
@@ -2128,7 +2128,7 @@ lpfc_restrict_login_init(struct lpfc_vport *vport, int val)
 }
 
 /**
- * lpfc_restrict_login_set: Set the vport restrict login flag.
+ * lpfc_restrict_login_set - Set the vport restrict login flag
  * @vport: lpfc vport structure pointer.
  * @val: contains the restrict login value.
  *
@@ -2201,7 +2201,7 @@ LPFC_VPORT_ATTR_R(scan_down, 1, 0, 1,
 */
 
 /**
- * lpfc_topology_set: Set the adapters topology field.
+ * lpfc_topology_set - Set the adapters topology field
  * @phba: lpfc_hba pointer.
  * @val: topology value.
  *
@@ -2216,18 +2216,41 @@ LPFC_VPORT_ATTR_R(scan_down, 1, 0, 1,
  * non-zero return value from lpfc_issue_lip()
  * -EINVAL val out of range
  **/
-static int
-lpfc_topology_set(struct lpfc_hba *phba, int val)
+static ssize_t
+lpfc_topology_store(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
 {
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	int val = 0;
+	int nolip = 0;
+	const char *val_buf = buf;
 	int err;
 	uint32_t prev_val;
+
+	if (!strncmp(buf, "nolip ", strlen("nolip "))) {
+		nolip = 1;
+		val_buf = &buf[strlen("nolip ")];
+	}
+
+	if (!isdigit(val_buf[0]))
+		return -EINVAL;
+	if (sscanf(val_buf, "%i", &val) != 1)
+		return -EINVAL;
+
 	if (val >= 0 && val <= 6) {
 		prev_val = phba->cfg_topology;
 		phba->cfg_topology = val;
+		if (nolip)
+			return strlen(buf);
+
 		err = lpfc_issue_lip(lpfc_shost_from_vport(phba->pport));
-		if (err)
+		if (err) {
 			phba->cfg_topology = prev_val;
-		return err;
+			return -EINVAL;
+		} else
+			return strlen(buf);
 	}
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 		"%d:0467 lpfc_topology attribute cannot be set to %d, "
@@ -2240,14 +2263,12 @@ module_param(lpfc_topology, int, 0);
 MODULE_PARM_DESC(lpfc_topology, "Select Fibre Channel topology");
 lpfc_param_show(topology)
 lpfc_param_init(topology, 0, 0, 6)
-lpfc_param_store(topology)
 static DEVICE_ATTR(lpfc_topology, S_IRUGO | S_IWUSR,
 		lpfc_topology_show, lpfc_topology_store);
 
 
 /**
- * lpfc_stat_data_ctrl_store: write call back for lpfc_stat_data_ctrl
- *  sysfs file.
+ * lpfc_stat_data_ctrl_store - write call back for lpfc_stat_data_ctrl sysfs file
  * @dev: Pointer to class device.
  * @buf: Data buffer.
  * @count: Size of the data buffer.
@@ -2282,7 +2303,7 @@ lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
 	unsigned long base, step, bucket_type;
 
 	if (!strncmp(buf, "setbucket", strlen("setbucket"))) {
-		if (strlen(buf) > LPFC_MAX_DATA_CTRL_LEN)
+		if (strlen(buf) > (LPFC_MAX_DATA_CTRL_LEN - 1))
 			return -EINVAL;
 
 		strcpy(bucket_data, buf);
@@ -2411,8 +2432,7 @@ lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
 
 
 /**
- * lpfc_stat_data_ctrl_show: Read callback function for
- *   lpfc_stat_data_ctrl sysfs file.
+ * lpfc_stat_data_ctrl_show - Read function for lpfc_stat_data_ctrl sysfs file
  * @dev: Pointer to class device object.
  * @buf: Data buffer.
  *
@@ -2489,8 +2509,7 @@ static DEVICE_ATTR(lpfc_stat_data_ctrl, S_IRUGO | S_IWUSR,
 
 
 /**
- * sysfs_drvr_stat_data_read: Read callback function for lpfc_drvr_stat_data
- *  sysfs attribute.
+ * sysfs_drvr_stat_data_read - Read function for lpfc_drvr_stat_data attribute
  * @kobj: Pointer to the kernel object
  * @bin_attr: Attribute object
  * @buff: Buffer pointer
@@ -2585,7 +2604,7 @@ static struct bin_attribute sysfs_drvr_stat_data_attr = {
 */
 
 /**
- * lpfc_link_speed_set: Set the adapters link speed.
+ * lpfc_link_speed_set - Set the adapters link speed
  * @phba: lpfc_hba pointer.
  * @val: link speed value.
  *
@@ -2601,12 +2620,29 @@ static struct bin_attribute sysfs_drvr_stat_data_attr = {
  * non-zero return value from lpfc_issue_lip()
  * -EINVAL val out of range
  **/
-static int
-lpfc_link_speed_set(struct lpfc_hba *phba, int val)
+static ssize_t
+lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
 {
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	int val = 0;
+	int nolip = 0;
+	const char *val_buf = buf;
 	int err;
 	uint32_t prev_val;
 
+	if (!strncmp(buf, "nolip ", strlen("nolip "))) {
+		nolip = 1;
+		val_buf = &buf[strlen("nolip ")];
+	}
+
+	if (!isdigit(val_buf[0]))
+		return -EINVAL;
+	if (sscanf(val_buf, "%i", &val) != 1)
+		return -EINVAL;
+
 	if (((val == LINK_SPEED_1G) && !(phba->lmt & LMT_1Gb)) ||
 		((val == LINK_SPEED_2G) && !(phba->lmt & LMT_2Gb)) ||
 		((val == LINK_SPEED_4G) && !(phba->lmt & LMT_4Gb)) ||
@@ -2614,14 +2650,19 @@ lpfc_link_speed_set(struct lpfc_hba *phba, int val)
 		((val == LINK_SPEED_10G) && !(phba->lmt & LMT_10Gb)))
 		return -EINVAL;
 
-	if ((val >= 0 && val <= LPFC_MAX_LINK_SPEED)
+	if ((val >= 0 && val <= 8)
 		&& (LPFC_LINK_SPEED_BITMAP & (1 << val))) {
 		prev_val = phba->cfg_link_speed;
 		phba->cfg_link_speed = val;
+		if (nolip)
+			return strlen(buf);
+
 		err = lpfc_issue_lip(lpfc_shost_from_vport(phba->pport));
-		if (err)
+		if (err) {
 			phba->cfg_link_speed = prev_val;
-		return err;
+			return -EINVAL;
+		} else
+			return strlen(buf);
 	}
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -2637,7 +2678,7 @@ MODULE_PARM_DESC(lpfc_link_speed, "Select link speed");
 lpfc_param_show(link_speed)
 
 /**
- * lpfc_link_speed_init: Set the adapters link speed.
+ * lpfc_link_speed_init - Set the adapters link speed
  * @phba: lpfc_hba pointer.
  * @val: link speed value.
  *
@@ -2668,7 +2709,6 @@ lpfc_link_speed_init(struct lpfc_hba *phba, int val)
 	return -EINVAL;
 }
 
-lpfc_param_store(link_speed)
 static DEVICE_ATTR(lpfc_link_speed, S_IRUGO | S_IWUSR,
 		lpfc_link_speed_show, lpfc_link_speed_store);
 
@@ -2865,7 +2905,7 @@ MODULE_PARM_DESC(lpfc_prot_guard, "host protection guard type");
 
 
 /*
- * lpfc_sg_seg_cnt: Initial Maximum DMA Segment Count
+ * lpfc_sg_seg_cnt - Initial Maximum DMA Segment Count
  * This value can be set to values between 64 and 256. The default value is
  * 64, but may be increased to allow for larger Max I/O sizes. The scsi layer
  * will be allowed to request I/Os of sizes up to (MAX_SEG_COUNT * SEG_SIZE).
@@ -2967,7 +3007,7 @@ struct device_attribute *lpfc_vport_attrs[] = {
 };
 
 /**
- * sysfs_ctlreg_write: Write method for writing to ctlreg.
+ * sysfs_ctlreg_write - Write method for writing to ctlreg
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: contains the data to be written to the adapter IOREG space.
@@ -3017,7 +3057,7 @@ sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 }
 
 /**
- * sysfs_ctlreg_read: Read method for reading from ctlreg.
+ * sysfs_ctlreg_read - Read method for reading from ctlreg
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: if succesful contains the data from the adapter IOREG space.
@@ -3078,7 +3118,7 @@ static struct bin_attribute sysfs_ctlreg_attr = {
 };
 
 /**
- * sysfs_mbox_idle: frees the sysfs mailbox.
+ * sysfs_mbox_idle - frees the sysfs mailbox
  * @phba: lpfc_hba pointer
  **/
 static void
@@ -3095,7 +3135,7 @@ sysfs_mbox_idle(struct lpfc_hba *phba)
 }
 
 /**
- * sysfs_mbox_write: Write method for writing information via mbox.
+ * sysfs_mbox_write - Write method for writing information via mbox
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: contains the data to be written to sysfs mbox.
@@ -3170,7 +3210,7 @@ sysfs_mbox_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 }
 
 /**
- * sysfs_mbox_read: Read method for reading information via mbox.
+ * sysfs_mbox_read - Read method for reading information via mbox
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: contains the data to be read from sysfs mbox.
@@ -3374,7 +3414,7 @@ static struct bin_attribute sysfs_mbox_attr = {
 };
 
 /**
- * lpfc_alloc_sysfs_attr: Creates the ctlreg and mbox entries.
+ * lpfc_alloc_sysfs_attr - Creates the ctlreg and mbox entries
  * @vport: address of lpfc vport structure.
  *
  * Return codes:
@@ -3415,7 +3455,7 @@ out:
 }
 
 /**
- * lpfc_free_sysfs_attr: Removes the ctlreg and mbox entries.
+ * lpfc_free_sysfs_attr - Removes the ctlreg and mbox entries
  * @vport: address of lpfc vport structure.
  **/
 void
@@ -3437,7 +3477,7 @@ lpfc_free_sysfs_attr(struct lpfc_vport *vport)
  */
 
 /**
- * lpfc_get_host_port_id: Copy the vport DID into the scsi host port id.
+ * lpfc_get_host_port_id - Copy the vport DID into the scsi host port id
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3450,7 +3490,7 @@ lpfc_get_host_port_id(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_get_host_port_type: Set the value of the scsi host port type.
+ * lpfc_get_host_port_type - Set the value of the scsi host port type
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3482,7 +3522,7 @@ lpfc_get_host_port_type(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_get_host_port_state: Set the value of the scsi host port state.
+ * lpfc_get_host_port_state - Set the value of the scsi host port state
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3520,7 +3560,7 @@ lpfc_get_host_port_state(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_get_host_speed: Set the value of the scsi host speed.
+ * lpfc_get_host_speed - Set the value of the scsi host speed
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3556,7 +3596,7 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_get_host_fabric_name: Set the value of the scsi host fabric name.
+ * lpfc_get_host_fabric_name - Set the value of the scsi host fabric name
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3582,7 +3622,7 @@ lpfc_get_host_fabric_name (struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_get_stats: Return statistical information about the adapter.
+ * lpfc_get_stats - Return statistical information about the adapter
  * @shost: kernel scsi host pointer.
  *
  * Notes:
@@ -3707,7 +3747,7 @@ lpfc_get_stats(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_reset_stats: Copy the adapter link stats information.
+ * lpfc_reset_stats - Copy the adapter link stats information
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3788,7 +3828,7 @@ lpfc_reset_stats(struct Scsi_Host *shost)
  */
 
 /**
- * lpfc_get_node_by_target: Return the nodelist for a target.
+ * lpfc_get_node_by_target - Return the nodelist for a target
  * @starget: kernel scsi target pointer.
  *
  * Returns:
@@ -3817,7 +3857,7 @@ lpfc_get_node_by_target(struct scsi_target *starget)
 }
 
 /**
- * lpfc_get_starget_port_id: Set the target port id to the ndlp DID or -1.
+ * lpfc_get_starget_port_id - Set the target port id to the ndlp DID or -1
  * @starget: kernel scsi target pointer.
  **/
 static void
@@ -3829,7 +3869,7 @@ lpfc_get_starget_port_id(struct scsi_target *starget)
 }
 
 /**
- * lpfc_get_starget_node_name: Set the target node name.
+ * lpfc_get_starget_node_name - Set the target node name
  * @starget: kernel scsi target pointer.
  *
  * Description: Set the target node name to the ndlp node name wwn or zero.
@@ -3844,7 +3884,7 @@ lpfc_get_starget_node_name(struct scsi_target *starget)
 }
 
 /**
- * lpfc_get_starget_port_name: Set the target port name.
+ * lpfc_get_starget_port_name - Set the target port name
  * @starget: kernel scsi target pointer.
  *
  * Description:  set the target port name to the ndlp port name wwn or zero.
@@ -3859,7 +3899,7 @@ lpfc_get_starget_port_name(struct scsi_target *starget)
 }
 
 /**
- * lpfc_set_rport_loss_tmo: Set the rport dev loss tmo.
+ * lpfc_set_rport_loss_tmo - Set the rport dev loss tmo
  * @rport: fc rport address.
  * @timeout: new value for dev loss tmo.
  *
@@ -3877,7 +3917,7 @@ lpfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 }
 
 /**
- * lpfc_rport_show_function: Return rport target information.
+ * lpfc_rport_show_function - Return rport target information
  *
  * Description:
  * Macro that uses field to generate a function with the name lpfc_show_rport_
@@ -3905,7 +3945,7 @@ lpfc_show_rport_##field (struct device *dev,				\
 static FC_RPORT_ATTR(field, S_IRUGO, lpfc_show_rport_##field, NULL)
 
 /**
- * lpfc_set_vport_symbolic_name: Set the vport's symbolic name.
+ * lpfc_set_vport_symbolic_name - Set the vport's symbolic name
  * @fc_vport: The fc_vport who's symbolic name has been changed.
  *
  * Description:
@@ -4048,7 +4088,7 @@ struct fc_function_template lpfc_vport_transport_functions = {
 };
 
 /**
- * lpfc_get_cfgparam: Used during probe_one to init the adapter structure.
+ * lpfc_get_cfgparam - Used during probe_one to init the adapter structure
  * @phba: lpfc_hba pointer.
  **/
 void
@@ -4097,7 +4137,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_get_vport_cfgparam: Used during port create, init the vport structure.
+ * lpfc_get_vport_cfgparam - Used during port create, init the vport structure
  * @vport: lpfc_vport pointer.
  **/
 void
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 07f4976..f88ce3f 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -184,6 +184,8 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_hba *);
 struct lpfc_iocbq * lpfc_sli_get_iocbq(struct lpfc_hba *);
 void lpfc_sli_release_iocbq(struct lpfc_hba *, struct lpfc_iocbq *);
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba *, struct lpfc_iocbq *);
+void lpfc_sli_cancel_iocbs(struct lpfc_hba *, struct list_head *, uint32_t,
+			   uint32_t);
 
 void lpfc_reset_barrier(struct lpfc_hba * phba);
 int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 81cdcf4..52be564 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -47,7 +47,7 @@
 #include "lpfc_debugfs.h"
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-/**
+/*
  * debugfs interface
  *
  * To access this interface the user should:
@@ -95,7 +95,7 @@ module_param(lpfc_debugfs_max_slow_ring_trc, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_max_slow_ring_trc,
 	"Set debugfs slow ring trace depth");
 
-int lpfc_debugfs_mask_disc_trc;
+static int lpfc_debugfs_mask_disc_trc;
 module_param(lpfc_debugfs_mask_disc_trc, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_mask_disc_trc,
 	"Set debugfs discovery trace mask");
@@ -127,7 +127,7 @@ static atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
 static unsigned long lpfc_debugfs_start_time = 0L;
 
 /**
- * lpfc_debugfs_disc_trc_data - Dump discovery logging to a buffer.
+ * lpfc_debugfs_disc_trc_data - Dump discovery logging to a buffer
  * @vport: The vport to gather the log info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -187,7 +187,7 @@ lpfc_debugfs_disc_trc_data(struct lpfc_vport *vport, char *buf, int size)
 }
 
 /**
- * lpfc_debugfs_slow_ring_trc_data - Dump slow ring logging to a buffer.
+ * lpfc_debugfs_slow_ring_trc_data - Dump slow ring logging to a buffer
  * @phba: The HBA to gather the log info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -250,7 +250,7 @@ lpfc_debugfs_slow_ring_trc_data(struct lpfc_hba *phba, char *buf, int size)
 static int lpfc_debugfs_last_hbq = -1;
 
 /**
- * lpfc_debugfs_hbqinfo_data - Dump host buffer queue info to a buffer.
+ * lpfc_debugfs_hbqinfo_data - Dump host buffer queue info to a buffer
  * @phba: The HBA to gather host buffer info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -369,7 +369,7 @@ skipit:
 static int lpfc_debugfs_last_hba_slim_off;
 
 /**
- * lpfc_debugfs_dumpHBASlim_data - Dump HBA SLIM info to a buffer.
+ * lpfc_debugfs_dumpHBASlim_data - Dump HBA SLIM info to a buffer
  * @phba: The HBA to gather SLIM info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -399,8 +399,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpfc_hba *phba, char *buf, int size)
 
 	len +=  snprintf(buf+len, size-len, "HBA SLIM\n");
 	lpfc_memcpy_from_slim(buffer,
-		((uint8_t *)phba->MBslimaddr) + lpfc_debugfs_last_hba_slim_off,
-		1024);
+		phba->MBslimaddr + lpfc_debugfs_last_hba_slim_off, 1024);
 
 	ptr = (uint32_t *)&buffer[0];
 	off = lpfc_debugfs_last_hba_slim_off;
@@ -426,7 +425,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpfc_hba *phba, char *buf, int size)
 }
 
 /**
- * lpfc_debugfs_dumpHostSlim_data - Dump host SLIM info to a buffer.
+ * lpfc_debugfs_dumpHostSlim_data - Dump host SLIM info to a buffer
  * @phba: The HBA to gather Host SLIM info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -501,7 +500,7 @@ lpfc_debugfs_dumpHostSlim_data(struct lpfc_hba *phba, char *buf, int size)
 }
 
 /**
- * lpfc_debugfs_nodelist_data - Dump target node list to a buffer.
+ * lpfc_debugfs_nodelist_data - Dump target node list to a buffer
  * @vport: The vport to gather target node info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -599,7 +598,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 #endif
 
 /**
- * lpfc_debugfs_disc_trc - Store discovery trace log.
+ * lpfc_debugfs_disc_trc - Store discovery trace log
  * @vport: The vport to associate this trace string with for retrieval.
  * @mask: Log entry classification.
  * @fmt: Format string to be displayed when dumping the log.
@@ -643,7 +642,7 @@ lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int mask, char *fmt,
 }
 
 /**
- * lpfc_debugfs_slow_ring_trc - Store slow ring trace log.
+ * lpfc_debugfs_slow_ring_trc - Store slow ring trace log
  * @phba: The phba to associate this trace string with for retrieval.
  * @fmt: Format string to be displayed when dumping the log.
  * @data1: 1st data parameter to be applied to @fmt.
@@ -682,7 +681,7 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /**
- * lpfc_debugfs_disc_trc_open - Open the discovery trace log.
+ * lpfc_debugfs_disc_trc_open - Open the discovery trace log
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -732,7 +731,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_slow_ring_trc_open - Open the Slow Ring trace log.
+ * lpfc_debugfs_slow_ring_trc_open - Open the Slow Ring trace log
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -782,7 +781,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_hbqinfo_open - Open the hbqinfo debugfs buffer.
+ * lpfc_debugfs_hbqinfo_open - Open the hbqinfo debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -824,7 +823,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_dumpHBASlim_open - Open the Dump HBA SLIM debugfs buffer.
+ * lpfc_debugfs_dumpHBASlim_open - Open the Dump HBA SLIM debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -866,7 +865,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_dumpHostSlim_open - Open the Dump Host SLIM debugfs buffer.
+ * lpfc_debugfs_dumpHostSlim_open - Open the Dump Host SLIM debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -993,7 +992,7 @@ lpfc_debugfs_dumpDataDif_write(struct file *file, const char __user *buf,
 
 
 /**
- * lpfc_debugfs_nodelist_open - Open the nodelist debugfs file.
+ * lpfc_debugfs_nodelist_open - Open the nodelist debugfs file
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -1035,7 +1034,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_lseek - Seek through a debugfs file.
+ * lpfc_debugfs_lseek - Seek through a debugfs file
  * @file: The file pointer to seek through.
  * @off: The offset to seek to or the amount to seek by.
  * @whence: Indicates how to seek.
@@ -1073,7 +1072,7 @@ lpfc_debugfs_lseek(struct file *file, loff_t off, int whence)
 }
 
 /**
- * lpfc_debugfs_read - Read a debugfs file.
+ * lpfc_debugfs_read - Read a debugfs file
  * @file: The file pointer to read from.
  * @buf: The buffer to copy the data to.
  * @nbytes: The number of bytes to read.
@@ -1098,7 +1097,7 @@ lpfc_debugfs_read(struct file *file, char __user *buf,
 }
 
 /**
- * lpfc_debugfs_release - Release the buffer used to store debugfs file data.
+ * lpfc_debugfs_release - Release the buffer used to store debugfs file data
  * @inode: The inode pointer that contains a vport pointer. (unused)
  * @file: The file pointer that contains the buffer to release.
  *
@@ -1210,7 +1209,7 @@ static atomic_t lpfc_debugfs_hba_count;
 #endif
 
 /**
- * lpfc_debugfs_initialize - Initialize debugfs for a vport.
+ * lpfc_debugfs_initialize - Initialize debugfs for a vport
  * @vport: The vport pointer to initialize.
  *
  * Description:
@@ -1434,7 +1433,7 @@ debug_failed:
 }
 
 /**
- * lpfc_debugfs_terminate -  Tear down debugfs infrastructure for this vport.
+ * lpfc_debugfs_terminate -  Tear down debugfs infrastructure for this vport
  * @vport: The vport pointer to remove from debugfs.
  *
  * Description:
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index f29e548..ffd1089 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -99,6 +99,7 @@ struct lpfc_nodelist {
 #define NLP_USG_FREE_ACK_BIT	0x8	/* Indicate ndlp memory free invoked */
 
 	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
+	struct lpfc_hba *phba;
 	struct fc_rport *rport;			/* Corresponding FC transport
 						   port structure */
 	struct lpfc_vport *vport;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a730248..b8b34cf 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -55,7 +55,7 @@ static void lpfc_register_new_vport(struct lpfc_hba *phba,
 static int lpfc_max_els_tries = 3;
 
 /**
- * lpfc_els_chk_latt: Check host link attention event for a vport.
+ * lpfc_els_chk_latt - Check host link attention event for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine checks whether there is an outstanding host link
@@ -116,7 +116,7 @@ lpfc_els_chk_latt(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_prep_els_iocb: Allocate and prepare a lpfc iocb data structure.
+ * lpfc_prep_els_iocb - Allocate and prepare a lpfc iocb data structure
  * @vport: pointer to a host virtual N_Port data structure.
  * @expectRsp: flag indicating whether response is expected.
  * @cmdSize: size of the ELS command.
@@ -290,7 +290,7 @@ els_iocb_free_pcmb_exit:
 }
 
 /**
- * lpfc_issue_fabric_reglogin: Issue fabric registration login for a vport.
+ * lpfc_issue_fabric_reglogin - Issue fabric registration login for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues a fabric registration login for a @vport. An
@@ -386,7 +386,7 @@ fail:
 }
 
 /**
- * lpfc_cmpl_els_flogi_fabric: Completion function for flogi to a fabric port.
+ * lpfc_cmpl_els_flogi_fabric - Completion function for flogi to a fabric port
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @sp: pointer to service parameter data structure.
@@ -509,7 +509,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 }
 
 /**
- * lpfc_cmpl_els_flogi_nport: Completion function for flogi to an N_Port.
+ * lpfc_cmpl_els_flogi_nport - Completion function for flogi to an N_Port
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @sp: pointer to service parameter data structure.
@@ -626,7 +626,7 @@ fail:
 }
 
 /**
- * lpfc_cmpl_els_flogi: Completion callback function for flogi.
+ * lpfc_cmpl_els_flogi - Completion callback function for flogi
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -751,7 +751,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_flogi: Issue an flogi iocb command for a vport.
+ * lpfc_issue_els_flogi - Issue an flogi iocb command for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -849,7 +849,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 }
 
 /**
- * lpfc_els_abort_flogi: Abort all outstanding flogi iocbs.
+ * lpfc_els_abort_flogi - Abort all outstanding flogi iocbs
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine aborts all the outstanding Fabric Login (FLOGI) IOCBs
@@ -898,7 +898,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_initial_flogi: Issue an initial fabric login for a vport.
+ * lpfc_initial_flogi - Issue an initial fabric login for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues an initial Fabric Login (FLOGI) for the @vport
@@ -949,7 +949,7 @@ lpfc_initial_flogi(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_initial_fdisc: Issue an initial fabric discovery for a vport.
+ * lpfc_initial_fdisc - Issue an initial fabric discovery for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues an initial Fabric Discover (FDISC) for the @vport
@@ -998,7 +998,7 @@ lpfc_initial_fdisc(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_more_plogi: Check and issue remaining plogis for a vport.
+ * lpfc_more_plogi - Check and issue remaining plogis for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine checks whether there are more remaining Port Logins
@@ -1031,7 +1031,7 @@ lpfc_more_plogi(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_plogi_confirm_nport: Confirm pologi wwpn matches stored ndlp.
+ * lpfc_plogi_confirm_nport - Confirm pologi wwpn matches stored ndlp
  * @phba: pointer to lpfc hba data structure.
  * @prsp: pointer to response IOCB payload.
  * @ndlp: pointer to a node-list data structure.
@@ -1165,7 +1165,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 }
 
 /**
- * lpfc_end_rscn: Check and handle more rscn for a vport.
+ * lpfc_end_rscn - Check and handle more rscn for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine checks whether more Registration State Change
@@ -1197,7 +1197,7 @@ lpfc_end_rscn(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_cmpl_els_plogi: Completion callback function for plogi.
+ * lpfc_cmpl_els_plogi - Completion callback function for plogi
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -1322,7 +1322,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_plogi: Issue an plogi iocb command for a vport.
+ * lpfc_issue_els_plogi - Issue an plogi iocb command for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @did: destination port identifier.
  * @retry: number of retries to the command IOCB.
@@ -1401,7 +1401,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 }
 
 /**
- * lpfc_cmpl_els_prli: Completion callback function for prli.
+ * lpfc_cmpl_els_prli - Completion callback function for prli
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -1472,7 +1472,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_prli: Issue a prli iocb command for a vport.
+ * lpfc_issue_els_prli - Issue a prli iocb command for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -1562,7 +1562,7 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 }
 
 /**
- * lpfc_rscn_disc: Perform rscn discovery for a vport.
+ * lpfc_rscn_disc - Perform rscn discovery for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine performs Registration State Change Notification (RSCN)
@@ -1588,7 +1588,7 @@ lpfc_rscn_disc(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_adisc_done: Complete the adisc phase of discovery.
+ * lpfc_adisc_done - Complete the adisc phase of discovery
  * @vport: pointer to lpfc_vport hba data structure that finished all ADISCs.
  *
  * This function is called when the final ADISC is completed during discovery.
@@ -1639,7 +1639,7 @@ lpfc_adisc_done(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_more_adisc: Issue more adisc as needed.
+ * lpfc_more_adisc - Issue more adisc as needed
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine determines whether there are more ndlps on a @vport
@@ -1672,7 +1672,7 @@ lpfc_more_adisc(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_cmpl_els_adisc: Completion callback function for adisc.
+ * lpfc_cmpl_els_adisc - Completion callback function for adisc
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -1760,7 +1760,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_adisc: Issue an address discover iocb to an node on a vport.
+ * lpfc_issue_els_adisc - Issue an address discover iocb to an node on a vport
  * @vport: pointer to a virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -1833,7 +1833,7 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 }
 
 /**
- * lpfc_cmpl_els_logo: Completion callback function for logo.
+ * lpfc_cmpl_els_logo - Completion callback function for logo
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -1910,7 +1910,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_logo: Issue a logo to an node on a vport.
+ * lpfc_issue_els_logo - Issue a logo to an node on a vport
  * @vport: pointer to a virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -1991,7 +1991,7 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 }
 
 /**
- * lpfc_cmpl_els_cmd: Completion callback function for generic els command.
+ * lpfc_cmpl_els_cmd - Completion callback function for generic els command
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -2031,7 +2031,7 @@ lpfc_cmpl_els_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_issue_els_scr: Issue a scr to an node on a vport.
+ * lpfc_issue_els_scr - Issue a scr to an node on a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @nportid: N_Port identifier to the remote node.
  * @retry: number of retries to the command IOCB.
@@ -2125,7 +2125,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 }
 
 /**
- * lpfc_issue_els_farpr: Issue a farp to an node on a vport.
+ * lpfc_issue_els_farpr - Issue a farp to an node on a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @nportid: N_Port identifier to the remote node.
  * @retry: number of retries to the command IOCB.
@@ -2236,7 +2236,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 }
 
 /**
- * lpfc_cancel_retry_delay_tmo: Cancel the timer with delayed iocb-cmd retry.
+ * lpfc_cancel_retry_delay_tmo - Cancel the timer with delayed iocb-cmd retry
  * @vport: pointer to a host virtual N_Port data structure.
  * @nlp: pointer to a node-list data structure.
  *
@@ -2291,7 +2291,7 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
 }
 
 /**
- * lpfc_els_retry_delay: Timer function with a ndlp delayed function timer.
+ * lpfc_els_retry_delay - Timer function with a ndlp delayed function timer
  * @ptr: holder for the pointer to the timer function associated data (ndlp).
  *
  * This routine is invoked by the ndlp delayed-function timer to check
@@ -2333,7 +2333,7 @@ lpfc_els_retry_delay(unsigned long ptr)
 }
 
 /**
- * lpfc_els_retry_delay_handler: Work thread handler for ndlp delayed function.
+ * lpfc_els_retry_delay_handler - Work thread handler for ndlp delayed function
  * @ndlp: pointer to a node-list data structure.
  *
  * This routine is the worker-thread handler for processing the @ndlp delayed
@@ -2404,7 +2404,7 @@ lpfc_els_retry_delay_handler(struct lpfc_nodelist *ndlp)
 }
 
 /**
- * lpfc_els_retry: Make retry decision on an els command iocb.
+ * lpfc_els_retry - Make retry decision on an els command iocb
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -2732,7 +2732,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_els_free_data: Free lpfc dma buffer and data structure with an iocb.
+ * lpfc_els_free_data - Free lpfc dma buffer and data structure with an iocb
  * @phba: pointer to lpfc hba data structure.
  * @buf_ptr1: pointer to the lpfc DMA buffer data structure.
  *
@@ -2764,7 +2764,7 @@ lpfc_els_free_data(struct lpfc_hba *phba, struct lpfc_dmabuf *buf_ptr1)
 }
 
 /**
- * lpfc_els_free_bpl: Free lpfc dma buffer and data structure with bpl.
+ * lpfc_els_free_bpl - Free lpfc dma buffer and data structure with bpl
  * @phba: pointer to lpfc hba data structure.
  * @buf_ptr: pointer to the lpfc dma buffer data structure.
  *
@@ -2784,7 +2784,7 @@ lpfc_els_free_bpl(struct lpfc_hba *phba, struct lpfc_dmabuf *buf_ptr)
 }
 
 /**
- * lpfc_els_free_iocb: Free a command iocb and its associated resources.
+ * lpfc_els_free_iocb - Free a command iocb and its associated resources
  * @phba: pointer to lpfc hba data structure.
  * @elsiocb: pointer to lpfc els command iocb data structure.
  *
@@ -2877,7 +2877,7 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 }
 
 /**
- * lpfc_cmpl_els_logo_acc: Completion callback function to logo acc response.
+ * lpfc_cmpl_els_logo_acc - Completion callback function to logo acc response
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -2931,7 +2931,7 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_mbx_cmpl_dflt_rpi: Completion callbk func for unreg dflt rpi mbox cmd.
+ * lpfc_mbx_cmpl_dflt_rpi - Completion callbk func for unreg dflt rpi mbox cmd
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -2965,7 +2965,7 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_cmpl_els_rsp: Completion callback function for els response iocb cmd.
+ * lpfc_cmpl_els_rsp - Completion callback function for els response iocb cmd
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -3136,7 +3136,7 @@ out:
 }
 
 /**
- * lpfc_els_rsp_acc: Prepare and issue an acc response iocb command.
+ * lpfc_els_rsp_acc - Prepare and issue an acc response iocb command
  * @vport: pointer to a host virtual N_Port data structure.
  * @flag: the els command code to be accepted.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
@@ -3275,7 +3275,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 }
 
 /**
- * lpfc_els_rsp_reject: Propare and issue a rjt response iocb command.
+ * lpfc_els_rsp_reject - Propare and issue a rjt response iocb command
  * @vport: pointer to a virtual N_Port data structure.
  * @rejectError:
  * @oldiocb: pointer to the original lpfc command iocb data structure.
@@ -3356,7 +3356,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 }
 
 /**
- * lpfc_els_rsp_adisc_acc: Prepare and issue acc response to adisc iocb cmd.
+ * lpfc_els_rsp_adisc_acc - Prepare and issue acc response to adisc iocb cmd
  * @vport: pointer to a virtual N_Port data structure.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -3431,7 +3431,7 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 }
 
 /**
- * lpfc_els_rsp_prli_acc: Prepare and issue acc response to prli iocb cmd.
+ * lpfc_els_rsp_prli_acc - Prepare and issue acc response to prli iocb cmd
  * @vport: pointer to a virtual N_Port data structure.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -3529,7 +3529,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 }
 
 /**
- * lpfc_els_rsp_rnid_acc: Issue rnid acc response iocb command.
+ * lpfc_els_rsp_rnid_acc - Issue rnid acc response iocb command
  * @vport: pointer to a virtual N_Port data structure.
  * @format: rnid command format.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
@@ -3635,7 +3635,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 }
 
 /**
- * lpfc_els_disc_adisc: Issue remaining adisc iocbs to npr nodes of a vport.
+ * lpfc_els_disc_adisc - Issue remaining adisc iocbs to npr nodes of a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues Address Discover (ADISC) ELS commands to those
@@ -3693,7 +3693,7 @@ lpfc_els_disc_adisc(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_els_disc_plogi: Issue plogi for all npr nodes of a vport before adisc.
+ * lpfc_els_disc_plogi - Issue plogi for all npr nodes of a vport before adisc
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues Port Login (PLOGI) ELS commands to all the N_Ports
@@ -3752,7 +3752,7 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_els_flush_rscn: Clean up any rscn activities with a vport.
+ * lpfc_els_flush_rscn - Clean up any rscn activities with a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine cleans up any Registration State Change Notification
@@ -3791,7 +3791,7 @@ lpfc_els_flush_rscn(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_rscn_payload_check: Check whether there is a pending rscn to a did.
+ * lpfc_rscn_payload_check - Check whether there is a pending rscn to a did
  * @vport: pointer to a host virtual N_Port data structure.
  * @did: remote destination port identifier.
  *
@@ -3866,7 +3866,7 @@ return_did_out:
 }
 
 /**
- * lpfc_rscn_recovery_check: Send recovery event to vport nodes matching rscn
+ * lpfc_rscn_recovery_check - Send recovery event to vport nodes matching rscn
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine sends recovery (NLP_EVT_DEVICE_RECOVERY) event to the
@@ -3895,7 +3895,7 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_send_rscn_event: Send an RSCN event to management application.
+ * lpfc_send_rscn_event - Send an RSCN event to management application
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  *
@@ -3938,7 +3938,7 @@ lpfc_send_rscn_event(struct lpfc_vport *vport,
 }
 
 /**
- * lpfc_els_rcv_rscn: Process an unsolicited rscn iocb.
+ * lpfc_els_rcv_rscn - Process an unsolicited rscn iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4134,7 +4134,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_els_handle_rscn: Handle rscn for a vport.
+ * lpfc_els_handle_rscn - Handle rscn for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine handles the Registration State Configuration Notification
@@ -4222,7 +4222,7 @@ lpfc_els_handle_rscn(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_els_rcv_flogi: Process an unsolicited flogi iocb.
+ * lpfc_els_rcv_flogi - Process an unsolicited flogi iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4336,7 +4336,7 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_els_rcv_rnid: Process an unsolicited rnid iocb.
+ * lpfc_els_rcv_rnid - Process an unsolicited rnid iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4391,7 +4391,7 @@ lpfc_els_rcv_rnid(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_els_rcv_lirr: Process an unsolicited lirr iocb.
+ * lpfc_els_rcv_lirr - Process an unsolicited lirr iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4419,7 +4419,7 @@ lpfc_els_rcv_lirr(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_els_rsp_rps_acc: Completion callbk func for MBX_READ_LNK_STAT mbox cmd.
+ * lpfc_els_rsp_rps_acc - Completion callbk func for MBX_READ_LNK_STAT mbox cmd
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -4513,7 +4513,7 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_els_rcv_rps: Process an unsolicited rps iocb.
+ * lpfc_els_rcv_rps - Process an unsolicited rps iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4590,7 +4590,7 @@ reject_out:
 }
 
 /**
- * lpfc_els_rsp_rpl_acc: Issue an accept rpl els command.
+ * lpfc_els_rsp_rpl_acc - Issue an accept rpl els command
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdsize: size of the ELS command.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
@@ -4662,7 +4662,7 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 }
 
 /**
- * lpfc_els_rcv_rpl: Process an unsolicited rpl iocb.
+ * lpfc_els_rcv_rpl - Process an unsolicited rpl iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4721,7 +4721,7 @@ lpfc_els_rcv_rpl(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_els_rcv_farp: Process an unsolicited farp request els command.
+ * lpfc_els_rcv_farp - Process an unsolicited farp request els command
  * @vport: pointer to a virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4804,7 +4804,7 @@ lpfc_els_rcv_farp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_els_rcv_farpr: Process an unsolicited farp response iocb.
+ * lpfc_els_rcv_farpr - Process an unsolicited farp response iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4842,7 +4842,7 @@ lpfc_els_rcv_farpr(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_els_rcv_fan: Process an unsolicited fan iocb command.
+ * lpfc_els_rcv_fan - Process an unsolicited fan iocb command
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @fan_ndlp: pointer to a node-list data structure.
@@ -4890,7 +4890,7 @@ lpfc_els_rcv_fan(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_els_timeout: Handler funciton to the els timer.
+ * lpfc_els_timeout - Handler funciton to the els timer
  * @ptr: holder for the timer function associated data.
  *
  * This routine is invoked by the ELS timer after timeout. It posts the ELS
@@ -4919,7 +4919,7 @@ lpfc_els_timeout(unsigned long ptr)
 }
 
 /**
- * lpfc_els_timeout_handler: Process an els timeout event.
+ * lpfc_els_timeout_handler - Process an els timeout event
  * @vport: pointer to a virtual N_Port data structure.
  *
  * This routine is the actual handler function that processes an ELS timeout
@@ -4994,7 +4994,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_els_flush_cmd: Clean up the outstanding els commands to a vport.
+ * lpfc_els_flush_cmd - Clean up the outstanding els commands to a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine is used to clean up all the outstanding ELS commands on a
@@ -5058,25 +5058,15 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		cmd = &piocb->iocb;
-		list_del_init(&piocb->list);
-
-		if (!piocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, piocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(piocb->iocb_cmpl) (phba, piocb, piocb);
-		}
-	}
+	/* Cancell all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 
 	return;
 }
 
 /**
- * lpfc_els_flush_all_cmd: Clean up all the outstanding els commands to a HBA.
+ * lpfc_els_flush_all_cmd - Clean up all the outstanding els commands to a HBA
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is used to clean up all the outstanding ELS commands on a
@@ -5121,23 +5111,16 @@ lpfc_els_flush_all_cmd(struct lpfc_hba  *phba)
 		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
 	}
 	spin_unlock_irq(&phba->hbalock);
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		cmd = &piocb->iocb;
-		list_del_init(&piocb->list);
-		if (!piocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, piocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(piocb->iocb_cmpl) (phba, piocb, piocb);
-		}
-	}
+
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
+
 	return;
 }
 
 /**
- * lpfc_send_els_failure_event: Posts an ELS command failure event.
+ * lpfc_send_els_failure_event - Posts an ELS command failure event
  * @phba: Pointer to hba context object.
  * @cmdiocbp: Pointer to command iocb which reported error.
  * @rspiocbp: Pointer to response iocb which reported error.
@@ -5204,7 +5187,7 @@ lpfc_send_els_failure_event(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_send_els_event: Posts unsolicited els event.
+ * lpfc_send_els_event - Posts unsolicited els event
  * @vport: Pointer to vport object.
  * @ndlp: Pointer FC node object.
  * @cmd: ELS command code.
@@ -5284,7 +5267,7 @@ lpfc_send_els_event(struct lpfc_vport *vport,
 
 
 /**
- * lpfc_els_unsol_buffer: Process an unsolicited event data buffer.
+ * lpfc_els_unsol_buffer - Process an unsolicited event data buffer
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a SLI ring.
  * @vport: pointer to a host virtual N_Port data structure.
@@ -5592,7 +5575,7 @@ dropit:
 }
 
 /**
- * lpfc_find_vport_by_vpid: Find a vport on a HBA through vport identifier.
+ * lpfc_find_vport_by_vpid - Find a vport on a HBA through vport identifier
  * @phba: pointer to lpfc hba data structure.
  * @vpi: host virtual N_Port identifier.
  *
@@ -5622,7 +5605,7 @@ lpfc_find_vport_by_vpid(struct lpfc_hba *phba, uint16_t vpi)
 }
 
 /**
- * lpfc_els_unsol_event: Process an unsolicited event from an els sli ring.
+ * lpfc_els_unsol_event - Process an unsolicited event from an els sli ring
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a SLI ring.
  * @elsiocb: pointer to lpfc els iocb data structure.
@@ -5710,7 +5693,7 @@ lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_do_scr_ns_plogi: Issue a plogi to the name server for scr.
+ * lpfc_do_scr_ns_plogi - Issue a plogi to the name server for scr
  * @phba: pointer to lpfc hba data structure.
  * @vport: pointer to a virtual N_Port data structure.
  *
@@ -5781,7 +5764,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_cmpl_reg_new_vport: Completion callback function to register new vport.
+ * lpfc_cmpl_reg_new_vport - Completion callback function to register new vport
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -5850,7 +5833,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_register_new_vport: Register a new vport with a HBA.
+ * lpfc_register_new_vport - Register a new vport with a HBA
  * @phba: pointer to lpfc hba data structure.
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -5899,7 +5882,7 @@ mbox_err_exit:
 }
 
 /**
- * lpfc_cmpl_els_fdisc: Completion function for fdisc iocb command.
+ * lpfc_cmpl_els_fdisc - Completion function for fdisc iocb command
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -6007,7 +5990,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_fdisc: Issue a fdisc iocb command.
+ * lpfc_issue_els_fdisc - Issue a fdisc iocb command
  * @vport: pointer to a virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -6101,7 +6084,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 }
 
 /**
- * lpfc_cmpl_els_npiv_logo: Completion function with vport logo.
+ * lpfc_cmpl_els_npiv_logo - Completion function with vport logo
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -6136,7 +6119,7 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_issue_els_npiv_logo: Issue a logo off a vport.
+ * lpfc_issue_els_npiv_logo - Issue a logo off a vport
  * @vport: pointer to a virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  *
@@ -6197,7 +6180,7 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 }
 
 /**
- * lpfc_fabric_block_timeout: Handler function to the fabric block timer.
+ * lpfc_fabric_block_timeout - Handler function to the fabric block timer
  * @ptr: holder for the timer function associated data.
  *
  * This routine is invoked by the fabric iocb block timer after
@@ -6226,7 +6209,7 @@ lpfc_fabric_block_timeout(unsigned long ptr)
 }
 
 /**
- * lpfc_resume_fabric_iocbs: Issue a fabric iocb from driver internal list.
+ * lpfc_resume_fabric_iocbs - Issue a fabric iocb from driver internal list
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine issues one fabric iocb from the driver internal list to
@@ -6285,7 +6268,7 @@ repeat:
 }
 
 /**
- * lpfc_unblock_fabric_iocbs: Unblock issuing fabric iocb command.
+ * lpfc_unblock_fabric_iocbs - Unblock issuing fabric iocb command
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine unblocks the  issuing fabric iocb command. The function
@@ -6303,7 +6286,7 @@ lpfc_unblock_fabric_iocbs(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_block_fabric_iocbs: Block issuing fabric iocb command.
+ * lpfc_block_fabric_iocbs - Block issuing fabric iocb command
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine blocks the issuing fabric iocb for a specified amount of
@@ -6325,7 +6308,7 @@ lpfc_block_fabric_iocbs(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_cmpl_fabric_iocb: Completion callback function for fabric iocb.
+ * lpfc_cmpl_fabric_iocb - Completion callback function for fabric iocb
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -6384,7 +6367,7 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_issue_fabric_iocb: Issue a fabric iocb command.
+ * lpfc_issue_fabric_iocb - Issue a fabric iocb command
  * @phba: pointer to lpfc hba data structure.
  * @iocb: pointer to lpfc command iocb data structure.
  *
@@ -6453,7 +6436,7 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 }
 
 /**
- * lpfc_fabric_abort_vport: Abort a vport's iocbs from driver fabric iocb list.
+ * lpfc_fabric_abort_vport - Abort a vport's iocbs from driver fabric iocb list
  * @vport: pointer to a virtual N_Port data structure.
  *
  * This routine aborts all the IOCBs associated with a @vport from the
@@ -6468,7 +6451,6 @@ static void lpfc_fabric_abort_vport(struct lpfc_vport *vport)
 	LIST_HEAD(completions);
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
-	IOCB_t *cmd;
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(piocb, tmp_iocb, &phba->fabric_iocb_list,
@@ -6481,19 +6463,13 @@ static void lpfc_fabric_abort_vport(struct lpfc_vport *vport)
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&piocb->list);
-
-		cmd = &piocb->iocb;
-		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-		(piocb->iocb_cmpl) (phba, piocb, piocb);
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
 
 /**
- * lpfc_fabric_abort_nport: Abort a ndlp's iocbs from driver fabric iocb list.
+ * lpfc_fabric_abort_nport - Abort a ndlp's iocbs from driver fabric iocb list
  * @ndlp: pointer to a node-list data structure.
  *
  * This routine aborts all the IOCBs associated with an @ndlp from the
@@ -6506,10 +6482,9 @@ static void lpfc_fabric_abort_vport(struct lpfc_vport *vport)
 void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(completions);
-	struct lpfc_hba  *phba = ndlp->vport->phba;
+	struct lpfc_hba  *phba = ndlp->phba;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
-	IOCB_t *cmd;
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(piocb, tmp_iocb, &phba->fabric_iocb_list,
@@ -6521,19 +6496,13 @@ void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&piocb->list);
-
-		cmd = &piocb->iocb;
-		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-		(piocb->iocb_cmpl) (phba, piocb, piocb);
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
 
 /**
- * lpfc_fabric_abort_hba: Abort all iocbs on driver fabric iocb list.
+ * lpfc_fabric_abort_hba - Abort all iocbs on driver fabric iocb list
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine aborts all the IOCBs currently on the driver internal
@@ -6546,20 +6515,12 @@ void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
 void lpfc_fabric_abort_hba(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
-	struct lpfc_iocbq *piocb;
-	IOCB_t *cmd;
 
 	spin_lock_irq(&phba->hbalock);
 	list_splice_init(&phba->fabric_iocb_list, &completions);
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&piocb->list);
-
-		cmd = &piocb->iocb;
-		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-		(piocb->iocb_cmpl) (phba, piocb, piocb);
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 311ed6d..e764ce0 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -78,7 +78,7 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
 		return;
 	}
 
-	phba  = ndlp->vport->phba;
+	phba  = ndlp->phba;
 
 	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_RPORT,
 		"rport terminate: sid:x%x did:x%x flg:x%x",
@@ -276,7 +276,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 }
 
 /**
- * lpfc_alloc_fast_evt: Allocates data structure for posting event.
+ * lpfc_alloc_fast_evt - Allocates data structure for posting event
  * @phba: Pointer to hba context object.
  *
  * This function is called from the functions which need to post
@@ -303,7 +303,7 @@ lpfc_alloc_fast_evt(struct lpfc_hba *phba) {
 }
 
 /**
- * lpfc_free_fast_evt: Frees event data structure.
+ * lpfc_free_fast_evt - Frees event data structure
  * @phba: Pointer to hba context object.
  * @evt:  Event object which need to be freed.
  *
@@ -319,7 +319,7 @@ lpfc_free_fast_evt(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_send_fastpath_evt: Posts events generated from fast path.
+ * lpfc_send_fastpath_evt - Posts events generated from fast path
  * @phba: Pointer to hba context object.
  * @evtp: Event data structure.
  *
@@ -1858,13 +1858,18 @@ lpfc_disable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				NLP_STE_UNUSED_NODE);
 }
 /**
- * lpfc_initialize_node: Initialize all fields of node object.
+ * lpfc_initialize_node - Initialize all fields of node object
  * @vport: Pointer to Virtual Port object.
  * @ndlp: Pointer to FC node object.
  * @did: FC_ID of the node.
- *	This function is always called when node object need to
- * be initialized. It initializes all the fields of the node
- * object.
+ *
+ * This function is always called when node object need to be initialized.
+ * It initializes all the fields of the node object. Although the reference
+ * to phba from @ndlp can be obtained indirectly through it's reference to
+ * @vport, a direct reference to phba is taken here by @ndlp. This is due
+ * to the life-span of the @ndlp might go beyond the existence of @vport as
+ * the final release of ndlp is determined by its reference count. And, the
+ * operation on @ndlp needs the reference to phba.
  **/
 static inline void
 lpfc_initialize_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
@@ -1877,6 +1882,7 @@ lpfc_initialize_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_delayfunc.data = (unsigned long)ndlp;
 	ndlp->nlp_DID = did;
 	ndlp->vport = vport;
+	ndlp->phba = vport->phba;
 	ndlp->nlp_sid = NLP_NO_SID;
 	kref_init(&ndlp->kref);
 	NLP_INT_NODE_ACT(ndlp);
@@ -2086,7 +2092,6 @@ lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *icmd;
 	uint32_t rpi, i;
 
 	lpfc_fabric_abort_nport(ndlp);
@@ -2122,19 +2127,9 @@ lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 		}
 	}
 
-	while (!list_empty(&completions)) {
-		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			icmd = &iocb->iocb;
-			icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(iocb->iocb_cmpl)(phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 
 	return 0;
 }
@@ -2186,9 +2181,13 @@ lpfc_unreg_all_rpis(struct lpfc_vport *vport)
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		mbox->context1 = NULL;
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
-		if (rc == MBX_NOT_FINISHED) {
+		if (rc != MBX_TIMEOUT)
 			mempool_free(mbox, phba->mbox_mem_pool);
-		}
+
+		if ((rc == MBX_TIMEOUT) || (rc == MBX_NOT_FINISHED))
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
+				"1836 Could not issue "
+				"unreg_login(all_rpis) status %d\n", rc);
 	}
 }
 
@@ -2206,12 +2205,14 @@ lpfc_unreg_default_rpis(struct lpfc_vport *vport)
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		mbox->context1 = NULL;
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
-		if (rc == MBX_NOT_FINISHED) {
+		if (rc != MBX_TIMEOUT)
+			mempool_free(mbox, phba->mbox_mem_pool);
+
+		if ((rc == MBX_TIMEOUT) || (rc == MBX_NOT_FINISHED))
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
 					 "1815 Could not issue "
-					 "unreg_did (default rpis)\n");
-			mempool_free(mbox, phba->mbox_mem_pool);
-		}
+					 "unreg_did (default rpis) status %d\n",
+					 rc);
 	}
 }
 
@@ -2470,14 +2471,13 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			if (ndlp->nlp_flag & NLP_RCV_PLOGI)
 				return NULL;
 
-			spin_lock_irq(shost->host_lock);
-			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-			spin_unlock_irq(shost->host_lock);
-
 			/* Since this node is marked for discovery,
 			 * delay timeout is not needed.
 			 */
 			lpfc_cancel_retry_delay_tmo(vport, ndlp);
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
+			spin_unlock_irq(shost->host_lock);
 		} else
 			ndlp = NULL;
 	} else {
@@ -2740,19 +2740,9 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			icmd = &iocb->iocb;
-			icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
 
 static void
@@ -3173,7 +3163,7 @@ lpfc_nlp_release(struct kref *kref)
 	lpfc_nlp_remove(ndlp->vport, ndlp);
 
 	/* clear the ndlp active flag for all release cases */
-	phba = ndlp->vport->phba;
+	phba = ndlp->phba;
 	spin_lock_irqsave(&phba->ndlp_lock, flags);
 	NLP_CLR_NODE_ACT(ndlp);
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
@@ -3181,7 +3171,7 @@ lpfc_nlp_release(struct kref *kref)
 	/* free ndlp memory for final ndlp release */
 	if (NLP_CHK_FREE_REQ(ndlp)) {
 		kfree(ndlp->lat_data);
-		mempool_free(ndlp, ndlp->vport->phba->nlp_mem_pool);
+		mempool_free(ndlp, ndlp->phba->nlp_mem_pool);
 	}
 }
 
@@ -3204,7 +3194,7 @@ lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 		 * ndlp reference count that is in the process of being
 		 * released.
 		 */
-		phba = ndlp->vport->phba;
+		phba = ndlp->phba;
 		spin_lock_irqsave(&phba->ndlp_lock, flags);
 		if (!NLP_CHK_NODE_ACT(ndlp) || NLP_CHK_FREE_ACK(ndlp)) {
 			spin_unlock_irqrestore(&phba->ndlp_lock, flags);
@@ -3240,7 +3230,7 @@ lpfc_nlp_put(struct lpfc_nodelist *ndlp)
 	"node put:        did:x%x flg:x%x refcnt:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag,
 		atomic_read(&ndlp->kref.refcount));
-	phba = ndlp->vport->phba;
+	phba = ndlp->phba;
 	spin_lock_irqsave(&phba->ndlp_lock, flags);
 	/* Check the ndlp memory free acknowledge flag to avoid the
 	 * possible race condition that kref_put got invoked again
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 06874e6..86d1bdc 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -60,7 +60,7 @@ static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
 static DEFINE_IDR(lpfc_hba_index);
 
 /**
- * lpfc_config_port_prep: Perform lpfc initialization prior to config port.
+ * lpfc_config_port_prep - Perform lpfc initialization prior to config port
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine will do LPFC initialization prior to issuing the CONFIG_PORT
@@ -221,7 +221,7 @@ out_free_mbox:
 }
 
 /**
- * lpfc_config_async_cmpl: Completion handler for config async event mbox cmd.
+ * lpfc_config_async_cmpl - Completion handler for config async event mbox cmd
  * @phba: pointer to lpfc hba data structure.
  * @pmboxq: pointer to the driver internal queue element for mailbox command.
  *
@@ -242,8 +242,7 @@ lpfc_config_async_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 }
 
 /**
- * lpfc_dump_wakeup_param_cmpl: Completion handler for dump memory mailbox
- *     command used for getting wake up parameters.
+ * lpfc_dump_wakeup_param_cmpl - dump memory mailbox command completion handler
  * @phba: pointer to lpfc hba data structure.
  * @pmboxq: pointer to the driver internal queue element for mailbox command.
  *
@@ -287,7 +286,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 }
 
 /**
- * lpfc_config_port_post: Perform lpfc initialization after config port.
+ * lpfc_config_port_post - Perform lpfc initialization after config port
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine will do LPFC initialization after the CONFIG_PORT mailbox
@@ -303,6 +302,7 @@ int
 lpfc_config_port_post(struct lpfc_hba *phba)
 {
 	struct lpfc_vport *vport = phba->pport;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	LPFC_MBOXQ_t *pmb;
 	MAILBOX_t *mb;
 	struct lpfc_dmabuf *mp;
@@ -360,6 +360,11 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	       sizeof (struct lpfc_name));
 	memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
 	       sizeof (struct lpfc_name));
+
+	/* Update the fc_host data structures with new wwn. */
+	fc_host_node_name(shost) = wwn_to_u64(vport->fc_nodename.u.wwn);
+	fc_host_port_name(shost) = wwn_to_u64(vport->fc_portname.u.wwn);
+
 	/* If no serial number in VPD data, use low 6 bytes of WWNN */
 	/* This should be consolidated into parse_vpd ? - mr */
 	if (phba->SerialNumber[0] == 0) {
@@ -551,7 +556,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_hba_down_prep: Perform lpfc uninitialization prior to HBA reset.
+ * lpfc_hba_down_prep - Perform lpfc uninitialization prior to HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
  * This routine will do LPFC uninitialization before the HBA is reset when
@@ -583,7 +588,7 @@ lpfc_hba_down_prep(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_hba_down_post: Perform lpfc uninitialization after HBA reset.
+ * lpfc_hba_down_post - Perform lpfc uninitialization after HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
  * This routine will do uninitialization after the HBA is reset when bring
@@ -599,8 +604,6 @@ lpfc_hba_down_post(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *mp, *next_mp;
-	struct lpfc_iocbq *iocb;
-	IOCB_t *cmd = NULL;
 	LIST_HEAD(completions);
 	int i;
 
@@ -628,20 +631,9 @@ lpfc_hba_down_post(struct lpfc_hba *phba)
 		pring->txcmplq_cnt = 0;
 		spin_unlock_irq(&phba->hbalock);
 
-		while (!list_empty(&completions)) {
-			iocb = list_get_first(&completions, struct lpfc_iocbq,
-				list);
-			cmd = &iocb->iocb;
-			list_del_init(&iocb->list);
-
-			if (!iocb->iocb_cmpl)
-				lpfc_sli_release_iocbq(phba, iocb);
-			else {
-				cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-				cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-				(iocb->iocb_cmpl) (phba, iocb, iocb);
-			}
-		}
+		/* Cancel all the IOCBs from the completions list */
+		lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+				      IOERR_SLI_ABORTED);
 
 		lpfc_sli_abort_iocb_ring(phba, pring);
 		spin_lock_irq(&phba->hbalock);
@@ -652,7 +644,7 @@ lpfc_hba_down_post(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_hb_timeout: The HBA-timer timeout handler.
+ * lpfc_hb_timeout - The HBA-timer timeout handler
  * @ptr: unsigned long holds the pointer to lpfc hba data structure.
  *
  * This is the HBA-timer timeout handler registered to the lpfc driver. When
@@ -686,7 +678,7 @@ lpfc_hb_timeout(unsigned long ptr)
 }
 
 /**
- * lpfc_hb_mbox_cmpl: The lpfc heart-beat mailbox command callback function.
+ * lpfc_hb_mbox_cmpl - The lpfc heart-beat mailbox command callback function
  * @phba: pointer to lpfc hba data structure.
  * @pmboxq: pointer to the driver internal queue element for mailbox command.
  *
@@ -721,7 +713,7 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 }
 
 /**
- * lpfc_hb_timeout_handler: The HBA-timer timeout handler.
+ * lpfc_hb_timeout_handler - The HBA-timer timeout handler
  * @phba: pointer to lpfc hba data structure.
  *
  * This is the actual HBA-timer timeout handler to be invoked by the worker
@@ -830,7 +822,7 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_offline_eratt: Bring lpfc offline on hardware error attention.
+ * lpfc_offline_eratt - Bring lpfc offline on hardware error attention
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is called to bring the HBA offline when HBA hardware error
@@ -857,7 +849,73 @@ lpfc_offline_eratt(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_handle_eratt: The HBA hardware error handler.
+ * lpfc_handle_deferred_eratt - The HBA hardware deferred error handler
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to handle the deferred HBA hardware error
+ * conditions. This type of error is indicated by HBA by setting ER1
+ * and another ER bit in the host status register. The driver will
+ * wait until the ER1 bit clears before handling the error condition.
+ **/
+static void
+lpfc_handle_deferred_eratt(struct lpfc_hba *phba)
+{
+	uint32_t old_host_status = phba->work_hs;
+	struct lpfc_sli_ring  *pring;
+	struct lpfc_sli *psli = &phba->sli;
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+		"0479 Deferred Adapter Hardware Error "
+		"Data: x%x x%x x%x\n",
+		phba->work_hs,
+		phba->work_status[0], phba->work_status[1]);
+
+	spin_lock_irq(&phba->hbalock);
+	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	spin_unlock_irq(&phba->hbalock);
+
+
+	/*
+	 * Firmware stops when it triggred erratt. That could cause the I/Os
+	 * dropped by the firmware. Error iocb (I/O) on txcmplq and let the
+	 * SCSI layer retry it after re-establishing link.
+	 */
+	pring = &psli->ring[psli->fcp_ring];
+	lpfc_sli_abort_iocb_ring(phba, pring);
+
+	/*
+	 * There was a firmware error. Take the hba offline and then
+	 * attempt to restart it.
+	 */
+	lpfc_offline_prep(phba);
+	lpfc_offline(phba);
+
+	/* Wait for the ER1 bit to clear.*/
+	while (phba->work_hs & HS_FFER1) {
+		msleep(100);
+		phba->work_hs = readl(phba->HSregaddr);
+		/* If driver is unloading let the worker thread continue */
+		if (phba->pport->load_flag & FC_UNLOADING) {
+			phba->work_hs = 0;
+			break;
+		}
+	}
+
+	/*
+	 * This is to ptrotect against a race condition in which
+	 * first write to the host attention register clear the
+	 * host status register.
+	 */
+	if ((!phba->work_hs) && (!(phba->pport->load_flag & FC_UNLOADING)))
+		phba->work_hs = old_host_status & ~HS_FFER1;
+
+	phba->hba_flag &= ~DEFER_ERATT;
+	phba->work_status[0] = readl(phba->MBslimaddr + 0xa8);
+	phba->work_status[1] = readl(phba->MBslimaddr + 0xac);
+}
+
+/**
+ * lpfc_handle_eratt - The HBA hardware error handler
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to handle the following HBA hardware error
@@ -895,6 +953,9 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 				  (char *) &board_event,
 				  LPFC_NL_VENDOR_ID);
 
+	if (phba->hba_flag & DEFER_ERATT)
+		lpfc_handle_deferred_eratt(phba);
+
 	if (phba->work_hs & HS_FFER6) {
 		/* Re-establishing Link */
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
@@ -976,7 +1037,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_handle_latt: The HBA link event handler.
+ * lpfc_handle_latt - The HBA link event handler
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked from the worker thread to handle a HBA host
@@ -1063,7 +1124,7 @@ lpfc_handle_latt_err_exit:
 }
 
 /**
- * lpfc_parse_vpd: Parse VPD (Vital Product Data).
+ * lpfc_parse_vpd - Parse VPD (Vital Product Data)
  * @phba: pointer to lpfc hba data structure.
  * @vpd: pointer to the vital product data.
  * @len: length of the vital product data in bytes.
@@ -1213,7 +1274,7 @@ lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
 }
 
 /**
- * lpfc_get_hba_model_desc: Retrieve HBA device model name and description.
+ * lpfc_get_hba_model_desc - Retrieve HBA device model name and description
  * @phba: pointer to lpfc hba data structure.
  * @mdp: pointer to the data structure to hold the derived model name.
  * @descp: pointer to the data structure to hold the derived description.
@@ -1322,7 +1383,8 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 		m = (typeof(m)){"LPe11000", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_DCSP:
-		m = (typeof(m)){"LPe11002-SP", max_speed, "PCIe"};
+		m = (typeof(m)){"LP2105", max_speed, "PCIe"};
+		GE = 1;
 		break;
 	case PCI_DEVICE_ID_ZMID:
 		m = (typeof(m)){"LPe1150", max_speed, "PCIe"};
@@ -1392,7 +1454,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 }
 
 /**
- * lpfc_post_buffer: Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring.
+ * lpfc_post_buffer - Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a IOCB ring.
  * @cnt: the number of IOCBs to be posted to the IOCB ring.
@@ -1493,7 +1555,7 @@ lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
 }
 
 /**
- * lpfc_post_rcv_buf: Post the initial receive IOCB buffers to ELS ring.
+ * lpfc_post_rcv_buf - Post the initial receive IOCB buffers to ELS ring
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine posts initial receive IOCB buffers to the ELS ring. The
@@ -1518,7 +1580,7 @@ lpfc_post_rcv_buf(struct lpfc_hba *phba)
 #define S(N,V) (((V)<<(N))|((V)>>(32-(N))))
 
 /**
- * lpfc_sha_init: Set up initial array of hash table entries.
+ * lpfc_sha_init - Set up initial array of hash table entries
  * @HashResultPointer: pointer to an array as hash table.
  *
  * This routine sets up the initial values to the array of hash table entries
@@ -1535,7 +1597,7 @@ lpfc_sha_init(uint32_t * HashResultPointer)
 }
 
 /**
- * lpfc_sha_iterate: Iterate initial hash table with the working hash table.
+ * lpfc_sha_iterate - Iterate initial hash table with the working hash table
  * @HashResultPointer: pointer to an initial/result hash table.
  * @HashWorkingPointer: pointer to an working hash table.
  *
@@ -1592,7 +1654,7 @@ lpfc_sha_iterate(uint32_t * HashResultPointer, uint32_t * HashWorkingPointer)
 }
 
 /**
- * lpfc_challenge_key: Create challenge key based on WWPN of the HBA.
+ * lpfc_challenge_key - Create challenge key based on WWPN of the HBA
  * @RandomChallenge: pointer to the entry of host challenge random number array.
  * @HashWorking: pointer to the entry of the working hash array.
  *
@@ -1608,7 +1670,7 @@ lpfc_challenge_key(uint32_t * RandomChallenge, uint32_t * HashWorking)
 }
 
 /**
- * lpfc_hba_init: Perform special handling for LC HBA initialization.
+ * lpfc_hba_init - Perform special handling for LC HBA initialization
  * @phba: pointer to lpfc hba data structure.
  * @hbainit: pointer to an array of unsigned 32-bit integers.
  *
@@ -1637,7 +1699,7 @@ lpfc_hba_init(struct lpfc_hba *phba, uint32_t *hbainit)
 }
 
 /**
- * lpfc_cleanup: Performs vport cleanups before deleting a vport.
+ * lpfc_cleanup - Performs vport cleanups before deleting a vport
  * @vport: pointer to a virtual N_Port data structure.
  *
  * This routine performs the necessary cleanups before deleting the @vport.
@@ -1724,7 +1786,7 @@ lpfc_cleanup(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_stop_vport_timers: Stop all the timers associated with a vport.
+ * lpfc_stop_vport_timers - Stop all the timers associated with a vport
  * @vport: pointer to a virtual N_Port data structure.
  *
  * This routine stops all the timers associated with a @vport. This function
@@ -1741,7 +1803,7 @@ lpfc_stop_vport_timers(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_stop_phba_timers: Stop all the timers associated with an HBA.
+ * lpfc_stop_phba_timers - Stop all the timers associated with an HBA
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine stops all the timers associated with a HBA. This function is
@@ -1761,7 +1823,7 @@ lpfc_stop_phba_timers(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_block_mgmt_io: Mark a HBA's management interface as blocked.
+ * lpfc_block_mgmt_io - Mark a HBA's management interface as blocked
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine marks a HBA's management interface as blocked. Once the HBA's
@@ -1781,7 +1843,7 @@ lpfc_block_mgmt_io(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_online: Initialize and bring a HBA online.
+ * lpfc_online - Initialize and bring a HBA online
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine initializes the HBA and brings a HBA online. During this
@@ -1839,7 +1901,7 @@ lpfc_online(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_unblock_mgmt_io: Mark a HBA's management interface to be not blocked.
+ * lpfc_unblock_mgmt_io - Mark a HBA's management interface to be not blocked
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine marks a HBA's management interface as not blocked. Once the
@@ -1860,7 +1922,7 @@ lpfc_unblock_mgmt_io(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_offline_prep: Prepare a HBA to be brought offline.
+ * lpfc_offline_prep - Prepare a HBA to be brought offline
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to prepare a HBA to be brought offline. It performs
@@ -1917,7 +1979,7 @@ lpfc_offline_prep(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_offline: Bring a HBA offline.
+ * lpfc_offline - Bring a HBA offline
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine actually brings a HBA offline. It stops all the timers
@@ -1962,7 +2024,7 @@ lpfc_offline(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_scsi_free: Free all the SCSI buffers and IOCBs from driver lists.
+ * lpfc_scsi_free - Free all the SCSI buffers and IOCBs from driver lists
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is to free all the SCSI buffers and IOCBs from the driver
@@ -2001,7 +2063,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_create_port: Create an FC port.
+ * lpfc_create_port - Create an FC port
  * @phba: pointer to lpfc hba data structure.
  * @instance: a unique integer ID to this FC port.
  * @dev: pointer to the device data structure.
@@ -2091,7 +2153,7 @@ out:
 }
 
 /**
- * destroy_port: Destroy an FC port.
+ * destroy_port -  destroy an FC port
  * @vport: pointer to an lpfc virtual N_Port data structure.
  *
  * This routine destroys a FC port from the upper layer protocol. All the
@@ -2116,7 +2178,7 @@ destroy_port(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_get_instance: Get a unique integer ID.
+ * lpfc_get_instance - Get a unique integer ID
  *
  * This routine allocates a unique integer ID from lpfc_hba_index pool. It
  * uses the kernel idr facility to perform the task.
@@ -2139,7 +2201,7 @@ lpfc_get_instance(void)
 }
 
 /**
- * lpfc_scan_finished: method for SCSI layer to detect whether scan is done.
+ * lpfc_scan_finished - method for SCSI layer to detect whether scan is done
  * @shost: pointer to SCSI host data structure.
  * @time: elapsed time of the scan in jiffies.
  *
@@ -2197,7 +2259,7 @@ finished:
 }
 
 /**
- * lpfc_host_attrib_init: Initialize SCSI host attributes on a FC port.
+ * lpfc_host_attrib_init - Initialize SCSI host attributes on a FC port
  * @shost: pointer to SCSI host data structure.
  *
  * This routine initializes a given SCSI host attributes on a FC port. The
@@ -2252,7 +2314,7 @@ void lpfc_host_attrib_init(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_enable_msix: Enable MSI-X interrupt mode.
+ * lpfc_enable_msix - Enable MSI-X interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors. The kernel
@@ -2366,7 +2428,7 @@ msi_fail_out:
 }
 
 /**
- * lpfc_disable_msix: Disable MSI-X interrupt mode.
+ * lpfc_disable_msix - Disable MSI-X interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to release the MSI-X vectors and then disable the
@@ -2385,7 +2447,7 @@ lpfc_disable_msix(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_enable_msi: Enable MSI interrupt mode.
+ * lpfc_enable_msi - Enable MSI interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI interrupt mode. The kernel
@@ -2423,7 +2485,7 @@ lpfc_enable_msi(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_disable_msi: Disable MSI interrupt mode.
+ * lpfc_disable_msi - Disable MSI interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to disable the MSI interrupt mode. The driver
@@ -2441,7 +2503,7 @@ lpfc_disable_msi(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_log_intr_mode: Log the active interrupt mode
+ * lpfc_log_intr_mode - Log the active interrupt mode
  * @phba: pointer to lpfc hba data structure.
  * @intr_mode: active interrupt mode adopted.
  *
@@ -2490,7 +2552,7 @@ lpfc_stop_port(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_enable_intr: Enable device interrupt.
+ * lpfc_enable_intr - Enable device interrupt
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable device interrupt and associate driver's
@@ -2547,7 +2609,7 @@ lpfc_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 }
 
 /**
- * lpfc_disable_intr: Disable device interrupt.
+ * lpfc_disable_intr - Disable device interrupt
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to disable device interrupt and disassociate the
@@ -2574,7 +2636,7 @@ lpfc_disable_intr(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_pci_probe_one: lpfc PCI probe func to register device to PCI subsystem.
+ * lpfc_pci_probe_one - lpfc PCI probe func to register device to PCI subsystem
  * @pdev: pointer to PCI device
  * @pid: pointer to PCI device identifier
  *
@@ -3010,7 +3072,7 @@ out:
 }
 
 /**
- * lpfc_pci_remove_one: lpfc PCI func to unregister device from PCI subsystem.
+ * lpfc_pci_remove_one - lpfc PCI func to unregister device from PCI subsystem
  * @pdev: pointer to PCI device
  *
  * This routine is to be registered to the kernel's PCI subsystem. When an
@@ -3033,8 +3095,6 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 
 	lpfc_free_sysfs_attr(vport);
 
-	kthread_stop(phba->worker_thread);
-
 	/* Release all the vports against this physical port */
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
@@ -3052,7 +3112,12 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 	 * clears the rings, discards all mailbox commands, and resets
 	 * the HBA.
 	 */
+
+	/* HBA interrupt will be diabled after this call */
 	lpfc_sli_hba_down(phba);
+	/* Stop kthread signal shall trigger work_done one more time */
+	kthread_stop(phba->worker_thread);
+	/* Final cleanup of txcmplq and reset the HBA */
 	lpfc_sli_brdrestart(phba);
 
 	lpfc_stop_phba_timers(phba);
@@ -3095,7 +3160,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 }
 
 /**
- * lpfc_pci_suspend_one: lpfc PCI func to suspend device for power management.
+ * lpfc_pci_suspend_one - lpfc PCI func to suspend device for power management
  * @pdev: pointer to PCI device
  * @msg: power management message
  *
@@ -3139,7 +3204,7 @@ lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
 }
 
 /**
- * lpfc_pci_resume_one: lpfc PCI func to resume device for power management.
+ * lpfc_pci_resume_one - lpfc PCI func to resume device for power management
  * @pdev: pointer to PCI device
  *
  * This routine is to be registered to the kernel's PCI subsystem to support
@@ -3204,7 +3269,7 @@ lpfc_pci_resume_one(struct pci_dev *pdev)
 }
 
 /**
- * lpfc_io_error_detected: Driver method for handling PCI I/O error detected.
+ * lpfc_io_error_detected - Driver method for handling PCI I/O error detected
  * @pdev: pointer to PCI device.
  * @state: the current PCI connection state.
  *
@@ -3254,7 +3319,7 @@ static pci_ers_result_t lpfc_io_error_detected(struct pci_dev *pdev,
 }
 
 /**
- * lpfc_io_slot_reset: Restart a PCI device from scratch.
+ * lpfc_io_slot_reset - Restart a PCI device from scratch
  * @pdev: pointer to PCI device.
  *
  * This routine is registered to the PCI subsystem for error handling. This is
@@ -3313,7 +3378,7 @@ static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
 }
 
 /**
- * lpfc_io_resume: Resume PCI I/O operation.
+ * lpfc_io_resume - Resume PCI I/O operation
  * @pdev: pointer to PCI device
  *
  * This routine is registered to the PCI subsystem for error handling. It is
@@ -3426,7 +3491,7 @@ static struct pci_driver lpfc_driver = {
 };
 
 /**
- * lpfc_init: lpfc module initialization routine.
+ * lpfc_init - lpfc module initialization routine
  *
  * This routine is to be invoked when the lpfc module is loaded into the
  * kernel. The special kernel macro module_init() is used to indicate the
@@ -3472,7 +3537,7 @@ lpfc_init(void)
 }
 
 /**
- * lpfc_exit: lpfc module removal routine.
+ * lpfc_exit - lpfc module removal routine
  *
  * This routine is invoked when the lpfc module is removed from the kernel.
  * The special kernel macro module_exit() is used to indicate the role of
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index a85b7c1..1aa8570 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -27,7 +27,7 @@
 #define LOG_FCP                       0x40	/* FCP traffic history */
 #define LOG_NODE                      0x80	/* Node table events */
 #define LOG_TEMP                      0x100	/* Temperature sensor events */
-#define LOG_BG			      0x200	/* BlockBuard events */
+#define LOG_BG			      0x200	/* BlockGuard events */
 #define LOG_MISC                      0x400	/* Miscellaneous events */
 #define LOG_SLI                       0x800	/* SLI events */
 #define LOG_FCP_ERROR                 0x1000	/* log errors, not underruns */
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 34eeb08..134fc7f 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -39,7 +39,7 @@
 #include "lpfc_compat.h"
 
 /**
- * lpfc_dump_mem: Prepare a mailbox command for retrieving HBA's VPD memory.
+ * lpfc_dump_mem - Prepare a mailbox command for retrieving HBA's VPD memory
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @offset: offset for dumping VPD memory mailbox command.
@@ -77,9 +77,10 @@ lpfc_dump_mem(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, uint16_t offset)
 }
 
 /**
- * lpfc_dump_mem: Prepare a mailbox command for retrieving wakeup params.
+ * lpfc_dump_wakeup_param - Prepare mailbox command for retrieving wakeup params
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
  * This function create a dump memory mailbox command to dump wake up
  * parameters.
  */
@@ -109,7 +110,7 @@ lpfc_dump_wakeup_param(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_read_nv: Prepare a mailbox command for reading HBA's NVRAM param.
+ * lpfc_read_nv - Prepare a mailbox command for reading HBA's NVRAM param
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -132,7 +133,7 @@ lpfc_read_nv(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_config_async: Prepare a mailbox command for enabling HBA async event.
+ * lpfc_config_async - Prepare a mailbox command for enabling HBA async event
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @ring: ring number for the asynchronous event to be configured.
@@ -159,7 +160,7 @@ lpfc_config_async(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb,
 }
 
 /**
- * lpfc_heart_beat: Prepare a mailbox command for heart beat.
+ * lpfc_heart_beat - Prepare a mailbox command for heart beat
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -184,7 +185,7 @@ lpfc_heart_beat(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_read_la: Prepare a mailbox command for reading HBA link attention.
+ * lpfc_read_la - Prepare a mailbox command for reading HBA link attention
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @mp: DMA buffer memory for reading the link attention information into.
@@ -228,7 +229,7 @@ lpfc_read_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, struct lpfc_dmabuf *mp)
 }
 
 /**
- * lpfc_clear_la: Prepare a mailbox command for clearing HBA link attention.
+ * lpfc_clear_la - Prepare a mailbox command for clearing HBA link attention
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -257,7 +258,7 @@ lpfc_clear_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_config_link: Prepare a mailbox command for configuring link on a HBA.
+ * lpfc_config_link - Prepare a mailbox command for configuring link on a HBA
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -305,7 +306,7 @@ lpfc_config_link(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_config_msi: Prepare a mailbox command for configuring msi-x.
+ * lpfc_config_msi - Prepare a mailbox command for configuring msi-x
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -383,7 +384,7 @@ lpfc_config_msi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_init_link: Prepare a mailbox command for initialize link on a HBA.
+ * lpfc_init_link - Prepare a mailbox command for initialize link on a HBA
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @topology: the link topology for the link to be initialized to.
@@ -463,7 +464,7 @@ lpfc_init_link(struct lpfc_hba * phba,
 }
 
 /**
- * lpfc_read_sparam: Prepare a mailbox command for reading HBA parameters.
+ * lpfc_read_sparam - Prepare a mailbox command for reading HBA parameters
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @vpi: virtual N_Port identifier.
@@ -523,7 +524,7 @@ lpfc_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb, int vpi)
 }
 
 /**
- * lpfc_unreg_did: Prepare a mailbox command for unregistering DID.
+ * lpfc_unreg_did - Prepare a mailbox command for unregistering DID
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @did: remote port identifier.
@@ -555,7 +556,7 @@ lpfc_unreg_did(struct lpfc_hba * phba, uint16_t vpi, uint32_t did,
 }
 
 /**
- * lpfc_read_config: Prepare a mailbox command for reading HBA configuration.
+ * lpfc_read_config - Prepare a mailbox command for reading HBA configuration
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -581,7 +582,7 @@ lpfc_read_config(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_read_lnk_stat: Prepare a mailbox command for reading HBA link stats.
+ * lpfc_read_lnk_stat - Prepare a mailbox command for reading HBA link stats
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -606,7 +607,7 @@ lpfc_read_lnk_stat(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_reg_login: Prepare a mailbox command for registering remote login.
+ * lpfc_reg_login - Prepare a mailbox command for registering remote login
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @did: remote port identifier.
@@ -677,7 +678,7 @@ lpfc_reg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t did,
 }
 
 /**
- * lpfc_unreg_login: Prepare a mailbox command for unregistering remote login.
+ * lpfc_unreg_login - Prepare a mailbox command for unregistering remote login
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @rpi: remote port identifier
@@ -709,7 +710,7 @@ lpfc_unreg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t rpi,
 }
 
 /**
- * lpfc_reg_vpi: Prepare a mailbox command for registering vport identifier.
+ * lpfc_reg_vpi - Prepare a mailbox command for registering vport identifier
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @sid: Fibre Channel S_ID (N_Port_ID assigned to a virtual N_Port).
@@ -741,7 +742,7 @@ lpfc_reg_vpi(struct lpfc_hba *phba, uint16_t vpi, uint32_t sid,
 }
 
 /**
- * lpfc_unreg_vpi: Prepare a mailbox command for unregistering vport id.
+ * lpfc_unreg_vpi - Prepare a mailbox command for unregistering vport id
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @pmb: pointer to the driver internal queue element for mailbox command.
@@ -771,7 +772,7 @@ lpfc_unreg_vpi(struct lpfc_hba *phba, uint16_t vpi, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_config_pcb_setup: Set up IOCB rings in the Port Control Block (PCB)
+ * lpfc_config_pcb_setup - Set up IOCB rings in the Port Control Block (PCB)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine sets up and initializes the IOCB rings in the Port Control
@@ -835,7 +836,7 @@ lpfc_config_pcb_setup(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_read_rev: Prepare a mailbox command for reading HBA revision.
+ * lpfc_read_rev - Prepare a mailbox command for reading HBA revision
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -861,7 +862,7 @@ lpfc_read_rev(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_build_hbq_profile2: Set up the HBQ Selection Profile 2.
+ * lpfc_build_hbq_profile2 - Set up the HBQ Selection Profile 2
  * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
  * @hbq_desc: pointer to the HBQ selection profile descriptor.
  *
@@ -880,7 +881,7 @@ lpfc_build_hbq_profile2(struct config_hbq_var *hbqmb,
 }
 
 /**
- * lpfc_build_hbq_profile3: Set up the HBQ Selection Profile 3.
+ * lpfc_build_hbq_profile3 - Set up the HBQ Selection Profile 3
  * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
  * @hbq_desc: pointer to the HBQ selection profile descriptor.
  *
@@ -902,7 +903,7 @@ lpfc_build_hbq_profile3(struct config_hbq_var *hbqmb,
 }
 
 /**
- * lpfc_build_hbq_profile5: Set up the HBQ Selection Profile 5.
+ * lpfc_build_hbq_profile5 - Set up the HBQ Selection Profile 5
  * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
  * @hbq_desc: pointer to the HBQ selection profile descriptor.
  *
@@ -925,7 +926,7 @@ lpfc_build_hbq_profile5(struct config_hbq_var *hbqmb,
 }
 
 /**
- * lpfc_config_hbq: Prepare a mailbox command for configuring an HBQ.
+ * lpfc_config_hbq - Prepare a mailbox command for configuring an HBQ
  * @phba: pointer to lpfc hba data structure.
  * @id: HBQ identifier.
  * @hbq_desc: pointer to the HBA descriptor data structure.
@@ -999,7 +1000,7 @@ lpfc_config_hbq(struct lpfc_hba *phba, uint32_t id,
 }
 
 /**
- * lpfc_config_ring: Prepare a mailbox command for configuring an IOCB ring.
+ * lpfc_config_ring - Prepare a mailbox command for configuring an IOCB ring
  * @phba: pointer to lpfc hba data structure.
  * @ring:
  * @pmb: pointer to the driver internal queue element for mailbox command.
@@ -1057,7 +1058,7 @@ lpfc_config_ring(struct lpfc_hba * phba, int ring, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_config_port: Prepare a mailbox command for configuring port.
+ * lpfc_config_port - Prepare a mailbox command for configuring port
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -1227,7 +1228,7 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_kill_board: Prepare a mailbox command for killing board.
+ * lpfc_kill_board - Prepare a mailbox command for killing board
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -1253,7 +1254,7 @@ lpfc_kill_board(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_mbox_put: Put a mailbox cmd into the tail of driver's mailbox queue.
+ * lpfc_mbox_put - Put a mailbox cmd into the tail of driver's mailbox queue
  * @phba: pointer to lpfc hba data structure.
  * @mbq: pointer to the driver internal queue element for mailbox command.
  *
@@ -1277,7 +1278,7 @@ lpfc_mbox_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 }
 
 /**
- * lpfc_mbox_get: Remove a mailbox cmd from the head of driver's mailbox queue.
+ * lpfc_mbox_get - Remove a mailbox cmd from the head of driver's mailbox queue
  * @phba: pointer to lpfc hba data structure.
  *
  * Driver maintains a internal mailbox command queue implemented as a linked
@@ -1304,7 +1305,7 @@ lpfc_mbox_get(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_mbox_cmpl_put: Put mailbox command into mailbox command complete list.
+ * lpfc_mbox_cmpl_put - Put mailbox command into mailbox command complete list
  * @phba: pointer to lpfc hba data structure.
  * @mbq: pointer to the driver internal queue element for mailbox command.
  *
@@ -1327,7 +1328,7 @@ lpfc_mbox_cmpl_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 }
 
 /**
- * lpfc_mbox_tmo_val: Retrieve mailbox command timeout value.
+ * lpfc_mbox_tmo_val - Retrieve mailbox command timeout value
  * @phba: pointer to lpfc hba data structure.
  * @cmd: mailbox command code.
  *
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index a4bba20..35a9767 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -41,7 +41,7 @@
 
 
 /**
- * lpfc_mem_alloc: create and allocate all PCI and memory pools
+ * lpfc_mem_alloc - create and allocate all PCI and memory pools
  * @phba: HBA to allocate pools for
  *
  * Description: Creates and allocates PCI pools lpfc_scsi_dma_buf_pool,
@@ -136,12 +136,12 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_mem_free: Frees all PCI and memory allocated by lpfc_mem_alloc
+ * lpfc_mem_free - Frees all PCI and memory allocated by lpfc_mem_alloc
  * @phba: HBA to free memory for
  *
  * Description: Frees PCI pools lpfc_scsi_dma_buf_pool, lpfc_mbuf_pool,
  * lpfc_hbq_pool.  Frees kmalloc-backed mempools for LPFC_MBOXQ_t and
- * lpfc_nodelist.  Also frees the VPI bitmask.
+ * lpfc_nodelist.  Also frees the VPI bitmask
  *
  * Returns: None
  **/
@@ -212,7 +212,7 @@ lpfc_mem_free(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_mbuf_alloc: Allocate an mbuf from the lpfc_mbuf_pool PCI pool
+ * lpfc_mbuf_alloc - Allocate an mbuf from the lpfc_mbuf_pool PCI pool
  * @phba: HBA which owns the pool to allocate from
  * @mem_flags: indicates if this is a priority (MEM_PRI) allocation
  * @handle: used to return the DMA-mapped address of the mbuf
@@ -249,7 +249,7 @@ lpfc_mbuf_alloc(struct lpfc_hba *phba, int mem_flags, dma_addr_t *handle)
 }
 
 /**
- * __lpfc_mem_free: Free an mbuf from the lpfc_mbuf_pool PCI pool (locked)
+ * __lpfc_mbuf_free - Free an mbuf from the lpfc_mbuf_pool PCI pool (locked)
  * @phba: HBA which owns the pool to return to
  * @virt: mbuf to free
  * @dma: the DMA-mapped address of the lpfc_mbuf_pool to be freed
@@ -278,7 +278,7 @@ __lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 }
 
 /**
- * lpfc_mem_free: Free an mbuf from the lpfc_mbuf_pool PCI pool (unlocked)
+ * lpfc_mbuf_free - Free an mbuf from the lpfc_mbuf_pool PCI pool (unlocked)
  * @phba: HBA which owns the pool to return to
  * @virt: mbuf to free
  * @dma: the DMA-mapped address of the lpfc_mbuf_pool to be freed
@@ -291,7 +291,6 @@ __lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
  * Returns: None
  **/
 void
-
 lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 {
 	unsigned long iflags;
@@ -303,7 +302,7 @@ lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 }
 
 /**
- * lpfc_els_hbq_alloc: Allocate an HBQ buffer
+ * lpfc_els_hbq_alloc - Allocate an HBQ buffer
  * @phba: HBA to allocate HBQ buffer for
  *
  * Description: Allocates a DMA-mapped HBQ buffer from the lpfc_hbq_pool PCI
@@ -335,7 +334,7 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_mem_hbq_free: Frees an HBQ buffer allocated with lpfc_els_hbq_alloc
+ * lpfc_mem_hbq_free - Frees an HBQ buffer allocated with lpfc_els_hbq_alloc
  * @phba: HBA buffer was allocated for
  * @hbqbp: HBQ container returned by lpfc_els_hbq_alloc
  *
@@ -355,7 +354,7 @@ lpfc_els_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp)
 }
 
 /**
- * lpfc_in_buf_free: Free a DMA buffer
+ * lpfc_in_buf_free - Free a DMA buffer
  * @phba: HBA buffer is associated with
  * @mp: Buffer to free
  *
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8f548ad..08cdc77 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -192,7 +192,6 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	struct lpfc_sli  *psli = &phba->sli;
 	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
 	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *cmd;
 
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_DISCOVERY,
@@ -223,19 +222,10 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
+
 	lpfc_cancel_retry_delay_tmo(phba->pport, ndlp);
 	return 0;
 }
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 36fd2e7..167b66d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -112,7 +112,7 @@ lpfc_debug_save_dif(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_update_stats: Update statistical data for the command completion.
+ * lpfc_update_stats - Update statistical data for the command completion
  * @phba: Pointer to HBA object.
  * @lpfc_cmd: lpfc scsi command object pointer.
  *
@@ -165,8 +165,7 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
 }
 
 /**
- * lpfc_send_sdev_queuedepth_change_event: Posts a queuedepth change
- *                   event.
+ * lpfc_send_sdev_queuedepth_change_event - Posts a queuedepth change event
  * @phba: Pointer to HBA context object.
  * @vport: Pointer to vport object.
  * @ndlp: Pointer to FC node associated with the target.
@@ -220,7 +219,7 @@ lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_rampdown_queue_depth: Post RAMP_DOWN_QUEUE event to worker thread.
+ * lpfc_rampdown_queue_depth - Post RAMP_DOWN_QUEUE event to worker thread
  * @phba: The Hba for which this call is being executed.
  *
  * This routine is called when there is resource error in driver or firmware.
@@ -261,7 +260,7 @@ lpfc_rampdown_queue_depth(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_rampup_queue_depth: Post RAMP_UP_QUEUE event for worker thread.
+ * lpfc_rampup_queue_depth - Post RAMP_UP_QUEUE event for worker thread
  * @phba: The Hba for which this call is being executed.
  *
  * This routine post WORKER_RAMP_UP_QUEUE event for @phba vport. This routine
@@ -273,14 +272,14 @@ lpfc_rampdown_queue_depth(struct lpfc_hba *phba)
  **/
 static inline void
 lpfc_rampup_queue_depth(struct lpfc_vport  *vport,
-			struct scsi_device *sdev)
+			uint32_t queue_depth)
 {
 	unsigned long flags;
 	struct lpfc_hba *phba = vport->phba;
 	uint32_t evt_posted;
 	atomic_inc(&phba->num_cmd_success);
 
-	if (vport->cfg_lun_queue_depth <= sdev->queue_depth)
+	if (vport->cfg_lun_queue_depth <= queue_depth)
 		return;
 	spin_lock_irqsave(&phba->hbalock, flags);
 	if (((phba->last_ramp_up_time + QUEUE_RAMP_UP_INTERVAL) > jiffies) ||
@@ -303,7 +302,7 @@ lpfc_rampup_queue_depth(struct lpfc_vport  *vport,
 }
 
 /**
- * lpfc_ramp_down_queue_handler: WORKER_RAMP_DOWN_QUEUE event handler.
+ * lpfc_ramp_down_queue_handler - WORKER_RAMP_DOWN_QUEUE event handler
  * @phba: The Hba for which this call is being executed.
  *
  * This routine is called to  process WORKER_RAMP_DOWN_QUEUE event for worker
@@ -361,7 +360,7 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_ramp_up_queue_handler: WORKER_RAMP_UP_QUEUE event handler.
+ * lpfc_ramp_up_queue_handler - WORKER_RAMP_UP_QUEUE event handler
  * @phba: The Hba for which this call is being executed.
  *
  * This routine is called to  process WORKER_RAMP_UP_QUEUE event for worker
@@ -410,7 +409,7 @@ lpfc_ramp_up_queue_handler(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_scsi_dev_block: set all scsi hosts to block state.
+ * lpfc_scsi_dev_block - set all scsi hosts to block state
  * @phba: Pointer to HBA context object.
  *
  * This function walks vport list and set each SCSI host to block state
@@ -439,7 +438,7 @@ lpfc_scsi_dev_block(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_new_scsi_buf: Scsi buffer allocator.
+ * lpfc_new_scsi_buf - Scsi buffer allocator
  * @vport: The virtual port for which this call being executed.
  *
  * This routine allocates a scsi buffer, which contains all the necessary
@@ -563,7 +562,7 @@ lpfc_new_scsi_buf(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_get_scsi_buf: Get a scsi buffer from lpfc_scsi_buf_list list of Hba.
+ * lpfc_get_scsi_buf - Get a scsi buffer from lpfc_scsi_buf_list list of Hba
  * @phba: The Hba for which this call is being executed.
  *
  * This routine removes a scsi buffer from head of @phba lpfc_scsi_buf_list list
@@ -592,7 +591,7 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_release_scsi_buf: Return a scsi buffer back to hba lpfc_scsi_buf_list list.
+ * lpfc_release_scsi_buf - Return a scsi buffer back to hba's lpfc_scsi_buf_list
  * @phba: The Hba for which this call is being executed.
  * @psb: The scsi buffer which is being released.
  *
@@ -611,7 +610,7 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 }
 
 /**
- * lpfc_scsi_prep_dma_buf: Routine to do DMA mapping for scsi buffer.
+ * lpfc_scsi_prep_dma_buf - Routine to do DMA mapping for scsi buffer
  * @phba: The Hba for which this call is being executed.
  * @lpfc_cmd: The scsi buffer which is going to be mapped.
  *
@@ -738,7 +737,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	 * Due to difference in data length between DIF/non-DIF paths,
 	 * we need to set word 4 of IOCB here
 	 */
-	iocb_cmd->un.fcpi.fcpi_parm = le32_to_cpu(scsi_bufflen(scsi_cmnd));
+	iocb_cmd->un.fcpi.fcpi_parm = scsi_bufflen(scsi_cmnd);
 	return 0;
 }
 
@@ -823,9 +822,9 @@ lpfc_cmd_blksize(struct scsi_cmnd *sc)
 /**
  * lpfc_get_cmd_dif_parms - Extract DIF parameters from SCSI command
  * @sc:             in: SCSI command
- * @apptagmask      out: app tag mask
- * @apptagval       out: app tag value
- * @reftag          out: ref tag (reference tag)
+ * @apptagmask:     out: app tag mask
+ * @apptagval:      out: app tag value
+ * @reftag:         out: ref tag (reference tag)
  *
  * Description:
  *   Extract DIF paramters from the command if possible.  Otherwise,
@@ -1413,7 +1412,7 @@ out:
 }
 
 /**
- * lpfc_send_scsi_error_event: Posts an event when there is SCSI error.
+ * lpfc_send_scsi_error_event - Posts an event when there is SCSI error
  * @phba: Pointer to hba context object.
  * @vport: Pointer to vport object.
  * @lpfc_cmd: Pointer to lpfc scsi command which reported the error.
@@ -1505,7 +1504,7 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
 }
 
 /**
- * lpfc_scsi_unprep_dma_buf: Routine to un-map DMA mapping of scatter gather.
+ * lpfc_scsi_unprep_dma_buf - Routine to un-map DMA mapping of scatter gather
  * @phba: The Hba for which this call is being executed.
  * @psb: The scsi buffer which is going to be un-mapped.
  *
@@ -1530,7 +1529,7 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
 }
 
 /**
- * lpfc_handler_fcp_err: FCP response handler.
+ * lpfc_handler_fcp_err - FCP response handler
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
  * @rsp_iocb: The response IOCB which contains FCP error.
@@ -1674,7 +1673,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 }
 
 /**
- * lpfc_scsi_cmd_iocb_cmpl: Scsi cmnd IOCB completion routine.
+ * lpfc_scsi_cmd_iocb_cmpl - Scsi cmnd IOCB completion routine
  * @phba: The Hba for which this call is being executed.
  * @pIocbIn: The command IOCBQ for the scsi cmnd.
  * @pIocbOut: The response IOCBQ for the scsi cmnd .
@@ -1694,10 +1693,12 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
 	int result;
-	struct scsi_device *sdev, *tmp_sdev;
+	struct scsi_device *tmp_sdev;
 	int depth = 0;
 	unsigned long flags;
 	struct lpfc_fast_path_event *fast_path_evt;
+	struct Scsi_Host *shost = cmd->device->host;
+	uint32_t queue_depth, scsi_id;
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
@@ -1808,11 +1809,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 	lpfc_update_stats(phba, lpfc_cmd);
 	result = cmd->result;
-	sdev = cmd->device;
 	if (vport->cfg_max_scsicmpl_time &&
 	   time_after(jiffies, lpfc_cmd->start_time +
 		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
-		spin_lock_irqsave(sdev->host->host_lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
 		if (pnode && NLP_CHK_NODE_ACT(pnode)) {
 			if (pnode->cmd_qdepth >
 				atomic_read(&pnode->cmd_pending) &&
@@ -1825,22 +1825,26 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 			pnode->last_change_time = jiffies;
 		}
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	} else if (pnode && NLP_CHK_NODE_ACT(pnode)) {
 		if ((pnode->cmd_qdepth < LPFC_MAX_TGT_QDEPTH) &&
 		   time_after(jiffies, pnode->last_change_time +
 			      msecs_to_jiffies(LPFC_TGTQ_INTERVAL))) {
-			spin_lock_irqsave(sdev->host->host_lock, flags);
+			spin_lock_irqsave(shost->host_lock, flags);
 			pnode->cmd_qdepth += pnode->cmd_qdepth *
 				LPFC_TGTQ_RAMPUP_PCENT / 100;
 			if (pnode->cmd_qdepth > LPFC_MAX_TGT_QDEPTH)
 				pnode->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
 			pnode->last_change_time = jiffies;
-			spin_unlock_irqrestore(sdev->host->host_lock, flags);
+			spin_unlock_irqrestore(shost->host_lock, flags);
 		}
 	}
 
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
+
+	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
+	queue_depth = cmd->device->queue_depth;
+	scsi_id = cmd->device->id;
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
@@ -1848,28 +1852,28 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		 * If there is a thread waiting for command completion
 		 * wake up the thread.
 		 */
-		spin_lock_irqsave(sdev->host->host_lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
 		lpfc_cmd->pCmd = NULL;
 		if (lpfc_cmd->waitq)
 			wake_up(lpfc_cmd->waitq);
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return;
 	}
 
 
 	if (!result)
-		lpfc_rampup_queue_depth(vport, sdev);
+		lpfc_rampup_queue_depth(vport, queue_depth);
 
 	if (!result && pnode && NLP_CHK_NODE_ACT(pnode) &&
 	   ((jiffies - pnode->last_ramp_up_time) >
 		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
 	   ((jiffies - pnode->last_q_full_time) >
 		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
-	   (vport->cfg_lun_queue_depth > sdev->queue_depth)) {
-		shost_for_each_device(tmp_sdev, sdev->host) {
+	   (vport->cfg_lun_queue_depth > queue_depth)) {
+		shost_for_each_device(tmp_sdev, shost) {
 			if (vport->cfg_lun_queue_depth > tmp_sdev->queue_depth){
-				if (tmp_sdev->id != sdev->id)
+				if (tmp_sdev->id != scsi_id)
 					continue;
 				if (tmp_sdev->ordered_tags)
 					scsi_adjust_queue_depth(tmp_sdev,
@@ -1885,7 +1889,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		}
 		lpfc_send_sdev_queuedepth_change_event(phba, vport, pnode,
 			0xFFFFFFFF,
-			sdev->queue_depth - 1, sdev->queue_depth);
+			queue_depth , queue_depth + 1);
 	}
 
 	/*
@@ -1896,8 +1900,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	    NLP_CHK_NODE_ACT(pnode)) {
 		pnode->last_q_full_time = jiffies;
 
-		shost_for_each_device(tmp_sdev, sdev->host) {
-			if (tmp_sdev->id != sdev->id)
+		shost_for_each_device(tmp_sdev, shost) {
+			if (tmp_sdev->id != scsi_id)
 				continue;
 			depth = scsi_track_queue_full(tmp_sdev,
 					tmp_sdev->queue_depth - 1);
@@ -1909,7 +1913,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		 * scsi_track_queue_full.
 		 */
 		if (depth == -1)
-			depth = sdev->host->cmd_per_lun;
+			depth = shost->cmd_per_lun;
 
 		if (depth) {
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
@@ -1925,17 +1929,17 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	 * If there is a thread waiting for command completion
 	 * wake up the thread.
 	 */
-	spin_lock_irqsave(sdev->host->host_lock, flags);
+	spin_lock_irqsave(shost->host_lock, flags);
 	lpfc_cmd->pCmd = NULL;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 }
 
 /**
- * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB.
+ * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
  * @data: A pointer to the immediate command data portion of the IOCB.
  * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
  *
@@ -1953,7 +1957,7 @@ lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
 }
 
 /**
- * lpfc_scsi_prep_cmnd:  Routine to convert scsi cmnd to FCP information unit.
+ * lpfc_scsi_prep_cmnd -  Routine to convert scsi cmnd to FCP information unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: The scsi command which needs to send.
  * @pnode: Pointer to lpfc_nodelist.
@@ -2047,7 +2051,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 }
 
 /**
- * lpfc_scsi_prep_task_mgmt_cmnd: Convert scsi TM cmnd to FCP information unit.
+ * lpfc_scsi_prep_task_mgmt_cmnd - Convert scsi TM cmnd to FCP information unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
  * @lun: Logical unit number.
@@ -2110,7 +2114,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 }
 
 /**
- * lpc_taskmgmt_def_cmpl: IOCB completion routine for task management command.
+ * lpfc_taskmgmt_def_cmpl - IOCB completion routine for task management command
  * @phba: The Hba for which this call is being executed.
  * @cmdiocbq: Pointer to lpfc_iocbq data structure.
  * @rspiocbq: Pointer to lpfc_iocbq data structure.
@@ -2131,7 +2135,7 @@ lpfc_tskmgmt_def_cmpl(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_scsi_tgt_reset: Target reset handler.
+ * lpfc_scsi_tgt_reset - Target reset handler
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure
  * @vport: The virtual port for which this call is being executed.
  * @tgt_id: Target ID.
@@ -2198,7 +2202,7 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_vport *vport,
 }
 
 /**
- * lpfc_info: Info entry point of scsi_host_template data structure.
+ * lpfc_info - Info entry point of scsi_host_template data structure
  * @host: The scsi host for which this call is being executed.
  *
  * This routine provides module information about hba.
@@ -2236,7 +2240,7 @@ lpfc_info(struct Scsi_Host *host)
 }
 
 /**
- * lpfc_poll_rearm_time: Routine to modify fcp_poll timer of hba.
+ * lpfc_poll_rearm_time - Routine to modify fcp_poll timer of hba
  * @phba: The Hba for which this call is being executed.
  *
  * This routine modifies fcp_poll_timer  field of @phba by cfg_poll_tmo.
@@ -2253,7 +2257,7 @@ static __inline__ void lpfc_poll_rearm_timer(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_poll_start_timer: Routine to start fcp_poll_timer of HBA.
+ * lpfc_poll_start_timer - Routine to start fcp_poll_timer of HBA
  * @phba: The Hba for which this call is being executed.
  *
  * This routine starts the fcp_poll_timer of @phba.
@@ -2264,7 +2268,7 @@ void lpfc_poll_start_timer(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_poll_timeout: Restart polling timer.
+ * lpfc_poll_timeout - Restart polling timer
  * @ptr: Map to lpfc_hba data structure pointer.
  *
  * This routine restarts fcp_poll timer, when FCP ring  polling is enable
@@ -2283,8 +2287,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 }
 
 /**
- * lpfc_queuecommand: Queuecommand entry point of Scsi Host Templater data
- * structure.
+ * lpfc_queuecommand - scsi_host_template queuecommand entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  * @done: Pointer to done routine.
  *
@@ -2450,7 +2453,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 }
 
 /**
- * lpfc_block_error_handler: Routine to block error  handler.
+ * lpfc_block_error_handler - Routine to block error  handler
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
  *  This routine blocks execution till fc_rport state is not FC_PORSTAT_BLCOEKD.
@@ -2472,8 +2475,7 @@ lpfc_block_error_handler(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_abort_handler: Eh_abort_handler entry point of Scsi Host Template data
- *structure.
+ * lpfc_abort_handler - scsi_host_template eh_abort_handler entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
  * This routine aborts @cmnd pending in base driver.
@@ -2578,8 +2580,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_device_reset_handler: eh_device_reset entry point of Scsi Host Template
- *data structure.
+ * lpfc_device_reset_handler - scsi_host_template eh_device_reset entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
  * This routine does a device reset by sending a TARGET_RESET task management
@@ -2587,7 +2588,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
  *
  * Return code :
  *  0x2003 - Error
- *  0ex2002 - Success
+ *  0x2002 - Success
  **/
 static int
 lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
@@ -2707,8 +2708,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_bus_reset_handler: eh_bus_reset_handler entry point of Scsi Host
- * Template data structure.
+ * lpfc_bus_reset_handler - scsi_host_template eh_bus_reset_handler entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
  * This routine does target reset to all target on @cmnd->device->host.
@@ -2808,8 +2808,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_slave_alloc: slave_alloc entry point of Scsi Host Template data
- * structure.
+ * lpfc_slave_alloc - scsi_host_template slave_alloc entry point
  * @sdev: Pointer to scsi_device.
  *
  * This routine populates the cmds_per_lun count + 2 scsi_bufs into  this host's
@@ -2883,8 +2882,7 @@ lpfc_slave_alloc(struct scsi_device *sdev)
 }
 
 /**
- * lpfc_slave_configure: slave_configure entry point of Scsi Host Templater data
- *  structure.
+ * lpfc_slave_configure - scsi_host_template slave_configure entry point
  * @sdev: Pointer to scsi_device.
  *
  * This routine configures following items
@@ -2925,7 +2923,7 @@ lpfc_slave_configure(struct scsi_device *sdev)
 }
 
 /**
- * lpfc_slave_destroy: slave_destroy entry point of SHT data structure.
+ * lpfc_slave_destroy - slave_destroy entry point of SHT data structure
  * @sdev: Pointer to scsi_device.
  *
  * This routine sets @sdev hostatdata filed to null.
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a36a120..eb5c75c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -68,7 +68,7 @@ typedef enum _lpfc_iocb_type {
 } lpfc_iocb_type;
 
 /**
- * lpfc_cmd_iocb: Get next command iocb entry in the ring.
+ * lpfc_cmd_iocb - Get next command iocb entry in the ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -85,7 +85,7 @@ lpfc_cmd_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
- * lpfc_resp_iocb: Get next response iocb entry in the ring.
+ * lpfc_resp_iocb - Get next response iocb entry in the ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -102,7 +102,7 @@ lpfc_resp_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
- * __lpfc_sli_get_iocbq: Allocates an iocb object from iocb pool.
+ * __lpfc_sli_get_iocbq - Allocates an iocb object from iocb pool
  * @phba: Pointer to HBA context object.
  *
  * This function is called with hbalock held. This function
@@ -121,7 +121,7 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_get_iocbq: Allocates an iocb object from iocb pool.
+ * lpfc_sli_get_iocbq - Allocates an iocb object from iocb pool
  * @phba: Pointer to HBA context object.
  *
  * This function is called with no lock held. This function
@@ -142,7 +142,7 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba)
 }
 
 /**
- * __lpfc_sli_release_iocbq: Release iocb to the iocb pool.
+ * __lpfc_sli_release_iocbq - Release iocb to the iocb pool
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
  *
@@ -164,7 +164,7 @@ __lpfc_sli_release_iocbq(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 }
 
 /**
- * lpfc_sli_release_iocbq: Release iocb to the iocb pool.
+ * lpfc_sli_release_iocbq - Release iocb to the iocb pool
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
  *
@@ -185,8 +185,40 @@ lpfc_sli_release_iocbq(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 }
 
 /**
- * lpfc_sli_iocb_cmd_type: Get the iocb type.
- * @iocb_cmnd : iocb command code.
+ * lpfc_sli_cancel_iocbs - Cancel all iocbs from a list.
+ * @phba: Pointer to HBA context object.
+ * @iocblist: List of IOCBs.
+ * @ulpstatus: ULP status in IOCB command field.
+ * @ulpWord4: ULP word-4 in IOCB command field.
+ *
+ * This function is called with a list of IOCBs to cancel. It cancels the IOCB
+ * on the list by invoking the complete callback function associated with the
+ * IOCB with the provided @ulpstatus and @ulpword4 set to the IOCB commond
+ * fields.
+ **/
+void
+lpfc_sli_cancel_iocbs(struct lpfc_hba *phba, struct list_head *iocblist,
+		      uint32_t ulpstatus, uint32_t ulpWord4)
+{
+	struct lpfc_iocbq *piocb;
+
+	while (!list_empty(iocblist)) {
+		list_remove_head(iocblist, piocb, struct lpfc_iocbq, list);
+
+		if (!piocb->iocb_cmpl)
+			lpfc_sli_release_iocbq(phba, piocb);
+		else {
+			piocb->iocb.ulpStatus = ulpstatus;
+			piocb->iocb.un.ulpWord[4] = ulpWord4;
+			(piocb->iocb_cmpl) (phba, piocb, piocb);
+		}
+	}
+	return;
+}
+
+/**
+ * lpfc_sli_iocb_cmd_type - Get the iocb type
+ * @iocb_cmnd: iocb command code.
  *
  * This function is called by ring event handler function to get the iocb type.
  * This function translates the iocb command to an iocb command type used to
@@ -295,7 +327,7 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd)
 }
 
 /**
- * lpfc_sli_ring_map: Issue config_ring mbox for all rings.
+ * lpfc_sli_ring_map - Issue config_ring mbox for all rings
  * @phba: Pointer to HBA context object.
  *
  * This function is called from SLI initialization code
@@ -338,7 +370,7 @@ lpfc_sli_ring_map(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_ringtxcmpl_put: Adds new iocb to the txcmplq.
+ * lpfc_sli_ringtxcmpl_put - Adds new iocb to the txcmplq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to the driver iocb object.
@@ -370,7 +402,7 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_sli_ringtx_get: Get first element of the txq.
+ * lpfc_sli_ringtx_get - Get first element of the txq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -391,7 +423,7 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
- * lpfc_sli_next_iocb_slot: Get next iocb slot in the ring.
+ * lpfc_sli_next_iocb_slot - Get next iocb slot in the ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -445,7 +477,7 @@ lpfc_sli_next_iocb_slot (struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
- * lpfc_sli_next_iotag: Get an iotag for the iocb.
+ * lpfc_sli_next_iotag - Get an iotag for the iocb
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
  *
@@ -520,7 +552,7 @@ lpfc_sli_next_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 }
 
 /**
- * lpfc_sli_submit_iocb: Submit an iocb to the firmware.
+ * lpfc_sli_submit_iocb - Submit an iocb to the firmware
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @iocb: Pointer to iocb slot in the ring.
@@ -577,7 +609,7 @@ lpfc_sli_submit_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_sli_update_full_ring: Update the chip attention register.
+ * lpfc_sli_update_full_ring - Update the chip attention register
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -608,7 +640,7 @@ lpfc_sli_update_full_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
- * lpfc_sli_update_ring: Update chip attention register.
+ * lpfc_sli_update_ring - Update chip attention register
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -632,7 +664,7 @@ lpfc_sli_update_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
- * lpfc_sli_resume_iocb: Process iocbs in the txq.
+ * lpfc_sli_resume_iocb - Process iocbs in the txq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -672,7 +704,7 @@ lpfc_sli_resume_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
- * lpfc_sli_next_hbq_slot: Get next hbq entry for the HBQ.
+ * lpfc_sli_next_hbq_slot - Get next hbq entry for the HBQ
  * @phba: Pointer to HBA context object.
  * @hbqno: HBQ number.
  *
@@ -717,7 +749,7 @@ lpfc_sli_next_hbq_slot(struct lpfc_hba *phba, uint32_t hbqno)
 }
 
 /**
- * lpfc_sli_hbqbuf_free_all: Free all the hbq buffers.
+ * lpfc_sli_hbqbuf_free_all - Free all the hbq buffers
  * @phba: Pointer to HBA context object.
  *
  * This function is called with no lock held to free all the
@@ -771,7 +803,7 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_hbq_to_firmware: Post the hbq buffer to firmware.
+ * lpfc_sli_hbq_to_firmware - Post the hbq buffer to firmware
  * @phba: Pointer to HBA context object.
  * @hbqno: HBQ number.
  * @hbq_buf: Pointer to HBQ buffer.
@@ -818,8 +850,8 @@ static struct lpfc_hbq_init lpfc_els_hbq = {
 	.profile = 0,
 	.ring_mask = (1 << LPFC_ELS_RING),
 	.buffer_count = 0,
-	.init_count = 20,
-	.add_count = 5,
+	.init_count = 40,
+	.add_count = 40,
 };
 
 /* HBQ for the extra ring if needed */
@@ -841,7 +873,7 @@ struct lpfc_hbq_init *lpfc_hbq_defs[] = {
 };
 
 /**
- * lpfc_sli_hbqbuf_fill_hbqs: Post more hbq buffers to HBQ.
+ * lpfc_sli_hbqbuf_fill_hbqs - Post more hbq buffers to HBQ
  * @phba: Pointer to HBA context object.
  * @hbqno: HBQ number.
  * @count: Number of HBQ buffers to be posted.
@@ -901,7 +933,7 @@ err:
 }
 
 /**
- * lpfc_sli_hbqbuf_add_hbqs: Post more HBQ buffers to firmware.
+ * lpfc_sli_hbqbuf_add_hbqs - Post more HBQ buffers to firmware
  * @phba: Pointer to HBA context object.
  * @qno: HBQ number.
  *
@@ -917,7 +949,7 @@ lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *phba, uint32_t qno)
 }
 
 /**
- * lpfc_sli_hbqbuf_init_hbqs: Post initial buffers to the HBQ.
+ * lpfc_sli_hbqbuf_init_hbqs - Post initial buffers to the HBQ
  * @phba: Pointer to HBA context object.
  * @qno:  HBQ queue number.
  *
@@ -933,7 +965,7 @@ lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hba *phba, uint32_t qno)
 }
 
 /**
- * lpfc_sli_hbqbuf_find: Find the hbq buffer associated with a tag.
+ * lpfc_sli_hbqbuf_find - Find the hbq buffer associated with a tag
  * @phba: Pointer to HBA context object.
  * @tag: Tag of the hbq buffer.
  *
@@ -966,7 +998,7 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
 }
 
 /**
- * lpfc_sli_free_hbq: Give back the hbq buffer to firmware.
+ * lpfc_sli_free_hbq - Give back the hbq buffer to firmware
  * @phba: Pointer to HBA context object.
  * @hbq_buffer: Pointer to HBQ buffer.
  *
@@ -988,7 +1020,7 @@ lpfc_sli_free_hbq(struct lpfc_hba *phba, struct hbq_dmabuf *hbq_buffer)
 }
 
 /**
- * lpfc_sli_chk_mbx_command: Check if the mailbox is a legitimate mailbox.
+ * lpfc_sli_chk_mbx_command - Check if the mailbox is a legitimate mailbox
  * @mbxCommand: mailbox command code.
  *
  * This function is called by the mailbox event handler function to verify
@@ -1064,8 +1096,7 @@ lpfc_sli_chk_mbx_command(uint8_t mbxCommand)
 }
 
 /**
- * lpfc_sli_wake_mbox_wait: Completion handler for mbox issued from
- *          lpfc_sli_issue_mbox_wait.
+ * lpfc_sli_wake_mbox_wait - lpfc_sli_issue_mbox_wait mbox completion handler
  * @phba: Pointer to HBA context object.
  * @pmboxq: Pointer to mailbox command.
  *
@@ -1096,7 +1127,7 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 
 
 /**
- * lpfc_sli_def_mbox_cmpl: Default mailbox completion handler.
+ * lpfc_sli_def_mbox_cmpl - Default mailbox completion handler
  * @phba: Pointer to HBA context object.
  * @pmb: Pointer to mailbox object.
  *
@@ -1140,7 +1171,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_sli_handle_mb_event: Handle mailbox completions from firmware.
+ * lpfc_sli_handle_mb_event - Handle mailbox completions from firmware
  * @phba: Pointer to HBA context object.
  *
  * This function is called with no lock held. This function processes all
@@ -1260,7 +1291,7 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_get_buff: Get the buffer associated with the buffer tag.
+ * lpfc_sli_get_buff - Get the buffer associated with the buffer tag
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @tag: buffer tag.
@@ -1288,7 +1319,7 @@ lpfc_sli_get_buff(struct lpfc_hba *phba,
 
 
 /**
- * lpfc_sli_process_unsol_iocb: Unsolicited iocb handler.
+ * lpfc_sli_process_unsol_iocb - Unsolicited iocb handler
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @saveq: Pointer to the unsolicited iocb.
@@ -1484,7 +1515,7 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_sli_iocbq_lookup: Find command iocb for the given response iocb.
+ * lpfc_sli_iocbq_lookup - Find command iocb for the given response iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @prspiocb: Pointer to response iocb object.
@@ -1521,7 +1552,7 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_sli_process_sol_iocb: process solicited iocb completion.
+ * lpfc_sli_process_sol_iocb - process solicited iocb completion
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @saveq: Pointer to the response iocb to be processed.
@@ -1597,7 +1628,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 * Ring <ringno> handler: unexpected completion IoTag
 			 * <IoTag>
 			 */
-			lpfc_printf_vlog(cmdiocbp->vport, KERN_WARNING, LOG_SLI,
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 					 "0322 Ring %d handler: "
 					 "unexpected completion IoTag x%x "
 					 "Data: x%x x%x x%x x%x\n",
@@ -1614,7 +1645,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_sli_rsp_pointers_error: Response ring pointer error handler.
+ * lpfc_sli_rsp_pointers_error - Response ring pointer error handler
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -1652,7 +1683,7 @@ lpfc_sli_rsp_pointers_error(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
- * lpfc_poll_eratt: Error attention polling timer timeout handler.
+ * lpfc_poll_eratt - Error attention polling timer timeout handler
  * @ptr: Pointer to address of HBA context object.
  *
  * This function is invoked by the Error Attention polling timer when the
@@ -1682,7 +1713,7 @@ void lpfc_poll_eratt(unsigned long ptr)
 }
 
 /**
- * lpfc_sli_poll_fcp_ring: Handle FCP ring completion in polling mode.
+ * lpfc_sli_poll_fcp_ring - Handle FCP ring completion in polling mode
  * @phba: Pointer to HBA context object.
  *
  * This function is called from lpfc_queuecommand, lpfc_poll_timeout,
@@ -1845,7 +1876,7 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_handle_fast_ring_event: Handle ring events on FCP ring.
+ * lpfc_sli_handle_fast_ring_event - Handle ring events on FCP ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @mask: Host attention register mask for this ring.
@@ -2037,7 +2068,7 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_sli_handle_slow_ring_event: Handle ring events for non-FCP rings.
+ * lpfc_sli_handle_slow_ring_event - Handle ring events for non-FCP rings
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @mask: Host attention register mask for this ring.
@@ -2311,7 +2342,7 @@ lpfc_sli_handle_slow_ring_event(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_sli_abort_iocb_ring: Abort all iocbs in the ring.
+ * lpfc_sli_abort_iocb_ring - Abort all iocbs in the ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -2325,7 +2356,6 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
 	LIST_HEAD(completions);
 	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *cmd = NULL;
 
 	if (pring->ringno == LPFC_ELS_RING) {
 		lpfc_fabric_abort_hba(phba);
@@ -2344,23 +2374,13 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
 
 /**
- * lpfc_sli_flush_fcp_rings: flush all iocbs in the fcp ring.
+ * lpfc_sli_flush_fcp_rings - flush all iocbs in the fcp ring
  * @phba: Pointer to HBA context object.
  *
  * This function flushes all iocbs in the fcp ring and frees all the iocb
@@ -2374,8 +2394,6 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 {
 	LIST_HEAD(txq);
 	LIST_HEAD(txcmplq);
-	struct lpfc_iocbq *iocb;
-	IOCB_t *cmd = NULL;
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
 
@@ -2393,38 +2411,16 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Flush the txq */
-	while (!list_empty(&txq)) {
-		iocb = list_get_first(&txq, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_DOWN;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	lpfc_sli_cancel_iocbs(phba, &txq, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_DOWN);
 
 	/* Flush the txcmpq */
-	while (!list_empty(&txcmplq)) {
-		iocb = list_get_first(&txcmplq, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_DOWN;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	lpfc_sli_cancel_iocbs(phba, &txcmplq, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_DOWN);
 }
 
 /**
- * lpfc_sli_brdready: Check for host status bits.
+ * lpfc_sli_brdready - Check for host status bits
  * @phba: Pointer to HBA context object.
  * @mask: Bit mask to be checked.
  *
@@ -2484,7 +2480,7 @@ lpfc_sli_brdready(struct lpfc_hba *phba, uint32_t mask)
 #define BARRIER_TEST_PATTERN (0xdeadbeef)
 
 /**
- * lpfc_reset_barrier: Make HBA ready for HBA reset.
+ * lpfc_reset_barrier - Make HBA ready for HBA reset
  * @phba: Pointer to HBA context object.
  *
  * This function is called before resetting an HBA. This
@@ -2564,7 +2560,7 @@ restore_hc:
 }
 
 /**
- * lpfc_sli_brdkill: Issue a kill_board mailbox command.
+ * lpfc_sli_brdkill - Issue a kill_board mailbox command
  * @phba: Pointer to HBA context object.
  *
  * This function issues a kill_board mailbox command and waits for
@@ -2651,7 +2647,7 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_brdreset: Reset the HBA.
+ * lpfc_sli_brdreset - Reset the HBA
  * @phba: Pointer to HBA context object.
  *
  * This function resets the HBA by writing HC_INITFF to the control
@@ -2714,7 +2710,7 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_brdrestart: Restart the HBA.
+ * lpfc_sli_brdrestart - Restart the HBA
  * @phba: Pointer to HBA context object.
  *
  * This function is called in the SLI initialization code path to
@@ -2781,7 +2777,7 @@ lpfc_sli_brdrestart(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_chipset_init: Wait for the restart of the HBA after a restart.
+ * lpfc_sli_chipset_init - Wait for the restart of the HBA after a restart
  * @phba: Pointer to HBA context object.
  *
  * This function is called after a HBA restart to wait for successful
@@ -2876,7 +2872,7 @@ lpfc_sli_chipset_init(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_hbq_count: Get the number of HBQs to be configured.
+ * lpfc_sli_hbq_count - Get the number of HBQs to be configured
  *
  * This function calculates and returns the number of HBQs required to be
  * configured.
@@ -2888,7 +2884,7 @@ lpfc_sli_hbq_count(void)
 }
 
 /**
- * lpfc_sli_hbq_entry_count: Calculate total number of hbq entries.
+ * lpfc_sli_hbq_entry_count - Calculate total number of hbq entries
  *
  * This function adds the number of hbq entries in every HBQ to get
  * the total number of hbq entries required for the HBA and returns
@@ -2907,7 +2903,7 @@ lpfc_sli_hbq_entry_count(void)
 }
 
 /**
- * lpfc_sli_hbq_size: Calculate memory required for all hbq entries.
+ * lpfc_sli_hbq_size - Calculate memory required for all hbq entries
  *
  * This function calculates amount of memory required for all hbq entries
  * to be configured and returns the total memory required.
@@ -2919,7 +2915,7 @@ lpfc_sli_hbq_size(void)
 }
 
 /**
- * lpfc_sli_hbq_setup: configure and initialize HBQs.
+ * lpfc_sli_hbq_setup - configure and initialize HBQs
  * @phba: Pointer to HBA context object.
  *
  * This function is called during the SLI initialization to configure
@@ -2988,7 +2984,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_config_port: Issue config port mailbox command.
+ * lpfc_sli_config_port - Issue config port mailbox command
  * @phba: Pointer to HBA context object.
  * @sli_mode: sli mode - 2/3
  *
@@ -3114,7 +3110,7 @@ do_prep_failed:
 
 
 /**
- * lpfc_sli_hba_setup: SLI intialization function.
+ * lpfc_sli_hba_setup - SLI intialization function
  * @phba: Pointer to HBA context object.
  *
  * This function is the main SLI intialization function. This function
@@ -3206,7 +3202,7 @@ lpfc_sli_hba_setup_error:
 
 
 /**
- * lpfc_mbox_timeout: Timeout call back function for mbox timer.
+ * lpfc_mbox_timeout - Timeout call back function for mbox timer
  * @ptr: context object - pointer to hba structure.
  *
  * This is the callback function for mailbox timer. The mailbox
@@ -3237,7 +3233,7 @@ lpfc_mbox_timeout(unsigned long ptr)
 
 
 /**
- * lpfc_mbox_timeout_handler: Worker thread function to handle mailbox timeout.
+ * lpfc_mbox_timeout_handler - Worker thread function to handle mailbox timeout
  * @phba: Pointer to HBA context object.
  *
  * This function is called from worker thread when a mailbox command times out.
@@ -3252,6 +3248,21 @@ lpfc_mbox_timeout_handler(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 
+	/* Check the pmbox pointer first.  There is a race condition
+	 * between the mbox timeout handler getting executed in the
+	 * worklist and the mailbox actually completing. When this
+	 * race condition occurs, the mbox_active will be NULL.
+	 */
+	spin_lock_irq(&phba->hbalock);
+	if (pmbox == NULL) {
+		lpfc_printf_log(phba, KERN_WARNING,
+				LOG_MBOX | LOG_SLI,
+				"0353 Active Mailbox cleared - mailbox timeout "
+				"exiting\n");
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+
 	/* Mbox cmd <mbxCommand> timeout */
 	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 			"0310 Mailbox command x%x timeout Data: x%x x%x x%p\n",
@@ -3259,6 +3270,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hba *phba)
 			phba->pport->port_state,
 			phba->sli.sli_flag,
 			phba->sli.mbox_active);
+	spin_unlock_irq(&phba->hbalock);
 
 	/* Setting state unknown so lpfc_sli_abort_iocb_ring
 	 * would get IOCB_ERROR from lpfc_sli_issue_iocb, allowing
@@ -3295,7 +3307,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_issue_mbox: Issue a mailbox command to firmware.
+ * lpfc_sli_issue_mbox - Issue a mailbox command to firmware
  * @phba: Pointer to HBA context object.
  * @pmbox: Pointer to mailbox object.
  * @flag: Flag indicating how the mailbox need to be processed.
@@ -3365,6 +3377,12 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox, uint32_t flag)
 		goto out_not_finished;
 	}
 
+	/* If HBA has a deferred error attention, fail the iocb. */
+	if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
+		goto out_not_finished;
+	}
+
 	psli = &phba->sli;
 
 	mb = &pmbox->mb;
@@ -3632,7 +3650,7 @@ out_not_finished:
 }
 
 /**
- * __lpfc_sli_ringtx_put: Add an iocb to the txq.
+ * __lpfc_sli_ringtx_put - Add an iocb to the txq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to address of newly added command iocb.
@@ -3651,7 +3669,7 @@ __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_sli_next_iocb: Get the next iocb in the txq.
+ * lpfc_sli_next_iocb - Get the next iocb in the txq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to address of newly added command iocb.
@@ -3683,7 +3701,7 @@ lpfc_sli_next_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * __lpfc_sli_issue_iocb: Lockless version of lpfc_sli_issue_iocb.
+ * __lpfc_sli_issue_iocb - Lockless version of lpfc_sli_issue_iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to command iocb.
@@ -3729,6 +3747,10 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	if (unlikely(pci_channel_offline(phba->pcidev)))
 		return IOCB_ERROR;
 
+	/* If HBA has a deferred error attention, fail the iocb. */
+	if (unlikely(phba->hba_flag & DEFER_ERATT))
+		return IOCB_ERROR;
+
 	/*
 	 * We should never get an IOCB if we are in a < LINK_DOWN state
 	 */
@@ -3813,7 +3835,7 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 
 /**
- * lpfc_sli_issue_iocb: Wrapper function for __lpfc_sli_issue_iocb.
+ * lpfc_sli_issue_iocb - Wrapper function for __lpfc_sli_issue_iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to command iocb.
@@ -3840,7 +3862,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_extra_ring_setup: Extra ring setup function.
+ * lpfc_extra_ring_setup - Extra ring setup function
  * @phba: Pointer to HBA context object.
  *
  * This function is called while driver attaches with the
@@ -3886,7 +3908,7 @@ lpfc_extra_ring_setup( struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_async_event_handler: ASYNC iocb handler function.
+ * lpfc_sli_async_event_handler - ASYNC iocb handler function
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @iocbq: Pointer to iocb object.
@@ -3907,6 +3929,7 @@ lpfc_sli_async_event_handler(struct lpfc_hba * phba,
 	uint16_t temp;
 	struct temp_event temp_event_data;
 	struct Scsi_Host *shost;
+	uint32_t *iocb_w;
 
 	icmd = &iocbq->iocb;
 	evt_code = icmd->un.asyncstat.evt_code;
@@ -3914,13 +3937,23 @@ lpfc_sli_async_event_handler(struct lpfc_hba * phba,
 
 	if ((evt_code != ASYNC_TEMP_WARN) &&
 		(evt_code != ASYNC_TEMP_SAFE)) {
+		iocb_w = (uint32_t *) icmd;
 		lpfc_printf_log(phba,
 			KERN_ERR,
 			LOG_SLI,
 			"0346 Ring %d handler: unexpected ASYNC_STATUS"
-			" evt_code 0x%x\n",
+			" evt_code 0x%x \n"
+			"W0  0x%08x W1  0x%08x W2  0x%08x W3  0x%08x\n"
+			"W4  0x%08x W5  0x%08x W6  0x%08x W7  0x%08x\n"
+			"W8  0x%08x W9  0x%08x W10 0x%08x W11 0x%08x\n"
+			"W12 0x%08x W13 0x%08x W14 0x%08x W15 0x%08x\n",
 			pring->ringno,
-			icmd->un.asyncstat.evt_code);
+			icmd->un.asyncstat.evt_code,
+			iocb_w[0], iocb_w[1], iocb_w[2], iocb_w[3],
+			iocb_w[4], iocb_w[5], iocb_w[6], iocb_w[7],
+			iocb_w[8], iocb_w[9], iocb_w[10], iocb_w[11],
+			iocb_w[12], iocb_w[13], iocb_w[14], iocb_w[15]);
+
 		return;
 	}
 	temp_event_data.data = (uint32_t)temp;
@@ -3954,7 +3987,7 @@ lpfc_sli_async_event_handler(struct lpfc_hba * phba,
 
 
 /**
- * lpfc_sli_setup: SLI ring setup function.
+ * lpfc_sli_setup - SLI ring setup function
  * @phba: Pointer to HBA context object.
  *
  * lpfc_sli_setup sets up rings of the SLI interface with
@@ -4076,7 +4109,7 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_queue_setup: Queue initialization function.
+ * lpfc_sli_queue_setup - Queue initialization function
  * @phba: Pointer to HBA context object.
  *
  * lpfc_sli_queue_setup sets up mailbox queues and iocb queues for each
@@ -4115,7 +4148,7 @@ lpfc_sli_queue_setup(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_host_down: Vport cleanup function.
+ * lpfc_sli_host_down - Vport cleanup function
  * @vport: Pointer to virtual port object.
  *
  * lpfc_sli_host_down is called to clean up the resources
@@ -4179,22 +4212,14 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
-	while (!list_empty(&completions)) {
-		list_remove_head(&completions, iocb, struct lpfc_iocbq, list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			iocb->iocb.ulpStatus = IOSTAT_LOCAL_REJECT;
-			iocb->iocb.un.ulpWord[4] = IOERR_SLI_DOWN;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_DOWN);
 	return 1;
 }
 
 /**
- * lpfc_sli_hba_down: Resource cleanup function for the HBA.
+ * lpfc_sli_hba_down - Resource cleanup function for the HBA
  * @phba: Pointer to HBA context object.
  *
  * This function cleans up all iocb, buffers, mailbox commands
@@ -4216,8 +4241,6 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *buf_ptr;
 	LPFC_MBOXQ_t *pmb;
-	struct lpfc_iocbq *iocb;
-	IOCB_t *cmd = NULL;
 	int i;
 	unsigned long flags = 0;
 
@@ -4245,18 +4268,9 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	}
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
-	while (!list_empty(&completions)) {
-		list_remove_head(&completions, iocb, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_DOWN;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_DOWN);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	list_splice_init(&phba->elsbuf, &completions);
@@ -4299,7 +4313,7 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_pcimem_bcopy: SLI memory copy function.
+ * lpfc_sli_pcimem_bcopy - SLI memory copy function
  * @srcp: Source memory pointer.
  * @destp: Destination memory pointer.
  * @cnt: Number of words required to be copied.
@@ -4329,7 +4343,7 @@ lpfc_sli_pcimem_bcopy(void *srcp, void *destp, uint32_t cnt)
 
 
 /**
- * lpfc_sli_ringpostbuf_put: Function to add a buffer to postbufq.
+ * lpfc_sli_ringpostbuf_put - Function to add a buffer to postbufq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @mp: Pointer to driver buffer object.
@@ -4352,8 +4366,7 @@ lpfc_sli_ringpostbuf_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_sli_get_buffer_tag: Tag allocation function for a buffer posted
- *          using CMD_QUE_XRI64_CX iocb.
+ * lpfc_sli_get_buffer_tag - allocates a tag for a CMD_QUE_XRI64_CX buffer
  * @phba: Pointer to HBA context object.
  *
  * When HBQ is enabled, buffers are searched based on tags. This function
@@ -4378,8 +4391,7 @@ lpfc_sli_get_buffer_tag(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_ring_taggedbuf_get: Search HBQ buffer associated with
- *              posted using CMD_QUE_XRI64_CX iocb.
+ * lpfc_sli_ring_taggedbuf_get - find HBQ buffer associated with given tag
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @tag: Buffer tag.
@@ -4422,8 +4434,7 @@ lpfc_sli_ring_taggedbuf_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_sli_ringpostbuf_get: SLI2 buffer search function for
- *      unsolicited ct and els events.
+ * lpfc_sli_ringpostbuf_get - search buffers for unsolicited CT and ELS events
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @phys: DMA address of the buffer.
@@ -4466,7 +4477,7 @@ lpfc_sli_ringpostbuf_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_sli_abort_els_cmpl: Completion handler for the els abort iocbs.
+ * lpfc_sli_abort_els_cmpl - Completion handler for the els abort iocbs
  * @phba: Pointer to HBA context object.
  * @cmdiocb: Pointer to driver command iocb object.
  * @rspiocb: Pointer to driver response iocb object.
@@ -4542,7 +4553,7 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_ignore_els_cmpl: Completion handler for aborted ELS command.
+ * lpfc_ignore_els_cmpl - Completion handler for aborted ELS command
  * @phba: Pointer to HBA context object.
  * @cmdiocb: Pointer to driver command iocb object.
  * @rspiocb: Pointer to driver response iocb object.
@@ -4572,7 +4583,7 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_sli_issue_abort_iotag: Abort function for a command iocb.
+ * lpfc_sli_issue_abort_iotag - Abort function for a command iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @cmdiocb: Pointer to driver command iocb object.
@@ -4658,15 +4669,14 @@ abort_iotag_exit:
 }
 
 /**
- * lpfc_sli_validate_fcp_iocb: Filtering function, used to find commands
- *                    associated with a vport/SCSI target/lun.
+ * lpfc_sli_validate_fcp_iocb - find commands associated with a vport or LUN
  * @iocbq: Pointer to driver iocb object.
  * @vport: Pointer to driver virtual port object.
  * @tgt_id: SCSI ID of the target.
  * @lun_id: LUN ID of the scsi device.
  * @ctx_cmd: LPFC_CTX_LUN/LPFC_CTX_TGT/LPFC_CTX_HOST
  *
- * This function acts as iocb filter for functions which abort or count
+ * This function acts as an iocb filter for functions which abort or count
  * all FCP iocbs pending on a lun/SCSI target/SCSI host. It will return
  * 0 if the filtering criteria is met for the given iocb and will return
  * 1 if the filtering criteria is not met.
@@ -4724,7 +4734,7 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 }
 
 /**
- * lpfc_sli_sum_iocb: Function to count the number of FCP iocbs pending.
+ * lpfc_sli_sum_iocb - Function to count the number of FCP iocbs pending
  * @vport: Pointer to virtual port.
  * @tgt_id: SCSI ID of the target.
  * @lun_id: LUN ID of the scsi device.
@@ -4762,8 +4772,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 }
 
 /**
- * lpfc_sli_abort_fcp_cmpl: Completion handler function for an aborted
- *       FCP iocb.
+ * lpfc_sli_abort_fcp_cmpl - Completion handler function for aborted FCP IOCBs
  * @phba: Pointer to HBA context object
  * @cmdiocb: Pointer to command iocb object.
  * @rspiocb: Pointer to response iocb object.
@@ -4781,8 +4790,7 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_sli_abort_iocb: This function issue abort for all SCSI commands
- *          pending on a SCSI host(vport)/target/lun.
+ * lpfc_sli_abort_iocb - issue abort for all commands on a host/target/LUN
  * @vport: Pointer to virtual port.
  * @pring: Pointer to driver SLI ring object.
  * @tgt_id: SCSI ID of the target.
@@ -4854,8 +4862,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 }
 
 /**
- * lpfc_sli_wake_iocb_wait: iocb completion handler for iocb issued using
- *                          lpfc_sli_issue_iocb_wait.
+ * lpfc_sli_wake_iocb_wait - lpfc_sli_issue_iocb_wait's completion handler
  * @phba: Pointer to HBA context object.
  * @cmdiocbq: Pointer to command iocb.
  * @rspiocbq: Pointer to response iocb.
@@ -4893,7 +4900,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_sli_issue_iocb_wait: Synchronous function to issue iocb commands.
+ * lpfc_sli_issue_iocb_wait - Synchronous function to issue iocb commands
  * @phba: Pointer to HBA context object..
  * @pring: Pointer to sli ring.
  * @piocb: Pointer to command iocb.
@@ -5000,7 +5007,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_sli_issue_mbox_wait: Synchronous function to issue mailbox.
+ * lpfc_sli_issue_mbox_wait - Synchronous function to issue mailbox
  * @phba: Pointer to HBA context object.
  * @pmboxq: Pointer to driver mailbox object.
  * @timeout: Timeout in number of seconds.
@@ -5070,7 +5077,7 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq,
 }
 
 /**
- * lpfc_sli_flush_mbox_queue: mailbox queue cleanup function.
+ * lpfc_sli_flush_mbox_queue - mailbox queue cleanup function
  * @phba: Pointer to HBA context.
  *
  * This function is called to cleanup any pending mailbox
@@ -5113,7 +5120,7 @@ lpfc_sli_flush_mbox_queue(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_sli_check_eratt: check error attention events
+ * lpfc_sli_check_eratt - check error attention events
  * @phba: Pointer to HBA context.
  *
  * This function is called form timer soft interrupt context to check HBA's
@@ -5145,11 +5152,31 @@ lpfc_sli_check_eratt(struct lpfc_hba *phba)
 		return 0;
 	}
 
+	/*
+	 * If there is deferred error attention, do not check for error
+	 * attention
+	 */
+	if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+		spin_unlock_irq(&phba->hbalock);
+		return 0;
+	}
+
 	/* Read chip Host Attention (HA) register */
 	ha_copy = readl(phba->HAregaddr);
 	if (ha_copy & HA_ERATT) {
 		/* Read host status register to retrieve error event */
 		lpfc_sli_read_hs(phba);
+
+		/* Check if there is a deferred error condition is active */
+		if ((HS_FFER1 & phba->work_hs) &&
+			((HS_FFER2 | HS_FFER3 | HS_FFER4 | HS_FFER5 |
+			HS_FFER6 | HS_FFER7) & phba->work_hs)) {
+			phba->hba_flag |= DEFER_ERATT;
+			/* Clear all interrupt enable conditions */
+			writel(0, phba->HCregaddr);
+			readl(phba->HCregaddr);
+		}
+
 		/* Set the driver HA work bitmap */
 		phba->work_ha |= HA_ERATT;
 		/* Indicate polling handles this ERATT */
@@ -5162,7 +5189,7 @@ lpfc_sli_check_eratt(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sp_intr_handler: The slow-path interrupt handler of lpfc driver.
+ * lpfc_sp_intr_handler - The slow-path interrupt handler of lpfc driver
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *
@@ -5238,6 +5265,16 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 				/* Indicate interrupt handler handles ERATT */
 				phba->hba_flag |= HBA_ERATT_HANDLED;
 		}
+
+		/*
+		 * If there is deferred error attention, do not check for any
+		 * interrupt.
+		 */
+		if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+			spin_unlock_irq(&phba->hbalock);
+			return IRQ_NONE;
+		}
+
 		/* Clear up only attention source related to slow-path */
 		writel((ha_copy & (HA_MBATT | HA_R2_CLR_MSK)),
 			phba->HAregaddr);
@@ -5309,8 +5346,22 @@ lpfc_sp_intr_handler(int irq, void *dev_id)
 			}
 		}
 		spin_lock_irqsave(&phba->hbalock, iflag);
-		if (work_ha_copy & HA_ERATT)
+		if (work_ha_copy & HA_ERATT) {
 			lpfc_sli_read_hs(phba);
+			/*
+			 * Check if there is a deferred error condition
+			 * is active
+			 */
+			if ((HS_FFER1 & phba->work_hs) &&
+				((HS_FFER2 | HS_FFER3 | HS_FFER4 | HS_FFER5 |
+				HS_FFER6 | HS_FFER7) & phba->work_hs)) {
+				phba->hba_flag |= DEFER_ERATT;
+				/* Clear all interrupt enable conditions */
+				writel(0, phba->HCregaddr);
+				readl(phba->HCregaddr);
+			}
+		}
+
 		if ((work_ha_copy & HA_MBATT) && (phba->sli.mbox_active)) {
 			pmb = phba->sli.mbox_active;
 			pmbox = &pmb->mb;
@@ -5423,7 +5474,7 @@ send_current_mbox:
 } /* lpfc_sp_intr_handler */
 
 /**
- * lpfc_fp_intr_handler: The fast-path interrupt handler of lpfc driver.
+ * lpfc_fp_intr_handler - The fast-path interrupt handler of lpfc driver
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *
@@ -5474,6 +5525,14 @@ lpfc_fp_intr_handler(int irq, void *dev_id)
 		ha_copy = readl(phba->HAregaddr);
 		/* Clear up only attention source related to fast-path */
 		spin_lock_irqsave(&phba->hbalock, iflag);
+		/*
+		 * If there is deferred error attention, do not check for
+		 * any interrupt.
+		 */
+		if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+			spin_unlock_irq(&phba->hbalock);
+			return IRQ_NONE;
+		}
 		writel((ha_copy & (HA_R0_CLR_MSK | HA_R1_CLR_MSK)),
 			phba->HAregaddr);
 		readl(phba->HAregaddr); /* flush */
@@ -5510,7 +5569,7 @@ lpfc_fp_intr_handler(int irq, void *dev_id)
 }  /* lpfc_fp_intr_handler */
 
 /**
- * lpfc_intr_handler: The device-level interrupt handler of lpfc driver.
+ * lpfc_intr_handler - The device-level interrupt handler of lpfc driver
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *
@@ -5566,6 +5625,14 @@ lpfc_intr_handler(int irq, void *dev_id)
 			phba->hba_flag |= HBA_ERATT_HANDLED;
 	}
 
+	/*
+	 * If there is deferred error attention, do not check for any interrupt.
+	 */
+	if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+		spin_unlock_irq(&phba->hbalock);
+		return IRQ_NONE;
+	}
+
 	/* Clear attention sources except link and error attentions */
 	writel((phba->ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
 	readl(phba->HAregaddr); /* flush */
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 7e32e95..e599519 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.0"
+#define LPFC_DRIVER_VERSION "8.3.1"
 
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
@@ -26,4 +26,4 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright(c) 2004-2008 Emulex.  All rights reserved."
+#define LPFC_COPYRIGHT "Copyright(c) 2004-2009 Emulex.  All rights reserved."
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 63b54c6..917ad56 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -206,7 +206,7 @@ lpfc_unique_wwpn(struct lpfc_hba *phba, struct lpfc_vport *new_vport)
 }
 
 /**
- * lpfc_discovery_wait: Wait for driver discovery to quiesce.
+ * lpfc_discovery_wait - Wait for driver discovery to quiesce
  * @vport: The virtual port for which this call is being executed.
  *
  * This driver calls this routine specifically from lpfc_vport_delete
@@ -741,7 +741,7 @@ lpfc_destroy_vport_work_array(struct lpfc_hba *phba, struct lpfc_vport **vports)
 
 
 /**
- * lpfc_vport_reset_stat_data: Reset the statistical data for the vport.
+ * lpfc_vport_reset_stat_data - Reset the statistical data for the vport
  * @vport: Pointer to vport object.
  *
  * This function resets the statistical data for the vport. This function
@@ -763,8 +763,7 @@ lpfc_vport_reset_stat_data(struct lpfc_vport *vport)
 
 
 /**
- * lpfc_alloc_bucket: Allocate data buffer required for collecting
- *  statistical data.
+ * lpfc_alloc_bucket - Allocate data buffer required for statistical data
  * @vport: Pointer to vport object.
  *
  * This function allocates data buffer required for all the FC
@@ -797,8 +796,7 @@ lpfc_alloc_bucket(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_free_bucket: Free data buffer required for collecting
- *  statistical data.
+ * lpfc_free_bucket - Free data buffer required for statistical data
  * @vport: Pointer to vport object.
  *
  * Th function frees statistical data buffer of all the FC
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a91f514..f3da592 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -636,6 +636,14 @@ _base_unmask_interrupts(struct MPT2SAS_ADAPTER *ioc)
 static irqreturn_t
 _base_interrupt(int irq, void *bus_id)
 {
+	union reply_descriptor {
+		u64 word;
+		struct {
+			u32 low;
+			u32 high;
+		} u;
+	};
+	union reply_descriptor rd;
 	u32 post_index, post_index_next, completed_cmds;
 	u8 request_desript_type;
 	u16 smid;
@@ -656,7 +664,8 @@ _base_interrupt(int irq, void *bus_id)
 
 	completed_cmds = 0;
 	do {
-		if (ioc->reply_post_free[post_index].Words == ~0ULL)
+		rd.word = ioc->reply_post_free[post_index].Words;
+		if (rd.u.low == UINT_MAX || rd.u.high == UINT_MAX)
 			goto out;
 		reply = 0;
 		cb_idx = 0xFF;
@@ -721,7 +730,7 @@ _base_interrupt(int irq, void *bus_id)
 	for (i = 0 ; i < completed_cmds; i++) {
 		post_index = post_index_next;
 		/* poison the reply post descriptor */
-		ioc->reply_post_free[post_index_next].Words = ~0ULL;
+		ioc->reply_post_free[post_index_next].Words = ULLONG_MAX;
 		post_index_next = (post_index ==
 		    (ioc->reply_post_queue_depth - 1))
 		    ? 0 : post_index + 1;
@@ -1387,6 +1396,64 @@ mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 }
 
 /**
+ * _base_display_dell_branding - Disply branding string
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_dell_branding(struct MPT2SAS_ADAPTER *ioc)
+{
+	char dell_branding[MPT2SAS_DELL_BRANDING_SIZE];
+
+	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_DELL)
+		return;
+
+	memset(dell_branding, 0, MPT2SAS_DELL_BRANDING_SIZE);
+	switch (ioc->pdev->subsystem_device) {
+	case MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID:
+		strncpy(dell_branding, MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID:
+		strncpy(dell_branding, MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID:
+		strncpy(dell_branding,
+		    MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_MODULAR_SSDID:
+		strncpy(dell_branding,
+		    MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID:
+		strncpy(dell_branding,
+		    MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_SSDID:
+		strncpy(dell_branding, MPT2SAS_DELL_PERC_H200_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_6GBPS_SAS_SSDID:
+		strncpy(dell_branding, MPT2SAS_DELL_6GBPS_SAS_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	default:
+		sprintf(dell_branding, "0x%4X", ioc->pdev->subsystem_device);
+		break;
+	}
+
+	printk(MPT2SAS_INFO_FMT "%s: Vendor(0x%04X), Device(0x%04X),"
+	    " SSVID(0x%04X), SSDID(0x%04X)\n", ioc->name, dell_branding,
+	    ioc->pdev->vendor, ioc->pdev->device, ioc->pdev->subsystem_vendor,
+	    ioc->pdev->subsystem_device);
+}
+
+/**
  * _base_display_ioc_capabilities - Disply IOC's capabilities.
  * @ioc: per adapter object
  *
@@ -1427,6 +1494,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 		i++;
 	}
 
+	_base_display_dell_branding(ioc);
+
 	i = 0;
 	printk("), ");
 	printk("Capabilities=(");
@@ -3068,7 +3137,7 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 
 	/* initialize Reply Post Free Queue */
 	for (i = 0; i < ioc->reply_post_queue_depth; i++)
-		ioc->reply_post_free[i].Words = ~0ULL;
+		ioc->reply_post_free[i].Words = ULLONG_MAX;
 
 	r = _base_send_ioc_init(ioc, VF_ID, sleep_flag);
 	if (r)
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 6945ff4..babd4cc 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -68,11 +68,11 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"00.100.11.16"
+#define MPT2SAS_DRIVER_VERSION		"01.100.02.00"
 #define MPT2SAS_MAJOR_VERSION		00
 #define MPT2SAS_MINOR_VERSION		100
-#define MPT2SAS_BUILD_VERSION		11
-#define MPT2SAS_RELEASE_VERSION		16
+#define MPT2SAS_BUILD_VERSION		02
+#define MPT2SAS_RELEASE_VERSION		00
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
@@ -130,6 +130,30 @@
 #define MPT2SAS_ERR_FMT			KERN_ERR MPT2SAS_FMT
 
 /*
+ * Dell HBA branding
+ */
+#define MPT2SAS_DELL_BRANDING_SIZE                 32
+
+#define MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING        "Dell 6Gbps SAS HBA"
+#define MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING    "Dell PERC H200 Adapter"
+#define MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING "Dell PERC H200 Integrated"
+#define MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING    "Dell PERC H200 Modular"
+#define MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING   "Dell PERC H200 Embedded"
+#define MPT2SAS_DELL_PERC_H200_BRANDING            "Dell PERC H200"
+#define MPT2SAS_DELL_6GBPS_SAS_BRANDING            "Dell 6Gbps SAS"
+
+/*
+ * Dell HBA SSDIDs
+ */
+#define MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID           0x1F1C
+#define MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID       0x1F1D
+#define MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID    0x1F1E
+#define MPT2SAS_DELL_PERC_H200_MODULAR_SSDID       0x1F1F
+#define MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID      0x1F20
+#define MPT2SAS_DELL_PERC_H200_SSDID               0x1F21
+#define MPT2SAS_DELL_6GBPS_SAS_SSDID               0x1F22
+
+/*
  * per target private data
  */
 #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x01
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 2d4f85c..ba6ab17 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -64,6 +64,9 @@
 static struct fasync_struct *async_queue;
 static DECLARE_WAIT_QUEUE_HEAD(ctl_poll_wait);
 
+static int _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type,
+    u8 *issue_reset);
+
 /**
  * enum block_state - blocking state
  * @NON_BLOCKING: non blocking
@@ -378,10 +381,22 @@ _ctl_verify_adapter(int ioc_number, struct MPT2SAS_ADAPTER **iocpp)
 void
 mpt2sas_ctl_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 {
+	int i;
+	u8 issue_reset;
+
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
 		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
+		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
+			if (!(ioc->diag_buffer_status[i] &
+			    MPT2_DIAG_BUFFER_IS_REGISTERED))
+				continue;
+			if ((ioc->diag_buffer_status[i] &
+			    MPT2_DIAG_BUFFER_IS_RELEASED))
+				continue;
+			_ctl_send_release(ioc, i, &issue_reset);
+		}
 		break;
 	case MPT2_IOC_AFTER_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
@@ -395,6 +410,17 @@ mpt2sas_ctl_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 	case MPT2_IOC_DONE_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
+
+		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
+			if (!(ioc->diag_buffer_status[i] &
+			    MPT2_DIAG_BUFFER_IS_REGISTERED))
+				continue;
+			if ((ioc->diag_buffer_status[i] &
+			    MPT2_DIAG_BUFFER_IS_RELEASED))
+				continue;
+			ioc->diag_buffer_status[i] |=
+			    MPT2_DIAG_BUFFER_IS_DIAG_RESET;
+		}
 		break;
 	}
 }
@@ -714,8 +740,10 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 
 		if (tm_request->TaskType ==
 		    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
-			if (_ctl_do_task_abort(ioc, &karg, tm_request))
+			if (_ctl_do_task_abort(ioc, &karg, tm_request)) {
+				mpt2sas_base_free_smid(ioc, smid);
 				goto out;
+			}
 		}
 
 		mutex_lock(&ioc->tm_cmds.mutex);
@@ -915,9 +943,9 @@ _ctl_getiocinfo(void __user *arg)
 	karg.pci_information.u.bits.function = PCI_FUNC(ioc->pdev->devfn);
 	karg.pci_information.segment_id = pci_domain_nr(ioc->pdev->bus);
 	karg.firmware_version = ioc->facts.FWVersion.Word;
-	strncpy(karg.driver_version, MPT2SAS_DRIVER_VERSION,
-	    MPT2_IOCTL_VERSION_LENGTH);
-	karg.driver_version[MPT2_IOCTL_VERSION_LENGTH - 1] = '\0';
+	strcpy(karg.driver_version, MPT2SAS_DRIVER_NAME);
+	strcat(karg.driver_version, "-");
+	strcat(karg.driver_version, MPT2SAS_DRIVER_VERSION);
 	karg.bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
 
 	if (copy_to_user(arg, &karg, sizeof(karg))) {
@@ -1551,81 +1579,38 @@ _ctl_diag_query(void __user *arg)
 }
 
 /**
- * _ctl_diag_release - request to send Diag Release Message to firmware
- * @arg - user space buffer containing ioctl content
- * @state - NON_BLOCKING or BLOCKING
+ * _ctl_send_release - Diag Release Message
+ * @ioc: per adapter object
+ * @buffer_type - specifies either TRACE or SNAPSHOT
+ * @issue_reset - specifies whether host reset is required.
  *
- * This allows ownership of the specified buffer to returned to the driver,
- * allowing an application to read the buffer without fear that firmware is
- * overwritting information in the buffer.
  */
-static long
-_ctl_diag_release(void __user *arg, enum block_state state)
+static int
+_ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 {
-	struct mpt2_diag_release karg;
-	struct MPT2SAS_ADAPTER *ioc;
-	void *request_data;
-	int rc;
 	Mpi2DiagReleaseRequest_t *mpi_request;
 	Mpi2DiagReleaseReply_t *mpi_reply;
-	u8 buffer_type;
-	unsigned long timeleft;
 	u16 smid;
 	u16 ioc_status;
-	u8 issue_reset = 0;
-
-	if (copy_from_user(&karg, arg, sizeof(karg))) {
-		printk(KERN_ERR "failure at %s:%d/%s()!\n",
-		    __FILE__, __LINE__, __func__);
-		return -EFAULT;
-	}
-	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
-		return -ENODEV;
+	u32 ioc_state;
+	int rc;
+	unsigned long timeleft;
 
 	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
 
-	buffer_type = karg.unique_id & 0x000000ff;
-	if (!_ctl_diag_capability(ioc, buffer_type)) {
-		printk(MPT2SAS_ERR_FMT "%s: doesn't have capability for "
-		    "buffer_type(0x%02x)\n", ioc->name, __func__, buffer_type);
-		return -EPERM;
-	}
-
-	if ((ioc->diag_buffer_status[buffer_type] &
-	    MPT2_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) is not "
-		    "registered\n", ioc->name, __func__, buffer_type);
-		return -EINVAL;
-	}
-
-	if (karg.unique_id != ioc->unique_id[buffer_type]) {
-		printk(MPT2SAS_ERR_FMT "%s: unique_id(0x%08x) is not "
-		    "registered\n", ioc->name, __func__, karg.unique_id);
-		return -EINVAL;
-	}
-
-	if (ioc->diag_buffer_status[buffer_type] &
-	    MPT2_DIAG_BUFFER_IS_RELEASED) {
-		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) "
-		    "is already released\n", ioc->name, __func__,
-		    buffer_type);
-		return 0;
-	}
-
-	request_data = ioc->diag_buffer[buffer_type];
+	rc = 0;
+	*issue_reset = 0;
 
-	if (!request_data) {
-		printk(MPT2SAS_ERR_FMT "%s: doesn't have memory allocated for "
-		    "buffer_type(0x%02x)\n", ioc->name, __func__, buffer_type);
-		return -ENOMEM;
+	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
+	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
+		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "skipping due to FAULT state\n", ioc->name,
+		    __func__));
+		rc = -EAGAIN;
+		goto out;
 	}
 
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
-	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
-		return -ERESTARTSYS;
-
 	if (ioc->ctl_cmds.status != MPT2_CMD_NOT_USED) {
 		printk(MPT2SAS_ERR_FMT "%s: ctl_cmd in use\n",
 		    ioc->name, __func__);
@@ -1641,7 +1626,6 @@ _ctl_diag_release(void __user *arg, enum block_state state)
 		goto out;
 	}
 
-	rc = 0;
 	ioc->ctl_cmds.status = MPT2_CMD_PENDING;
 	memset(ioc->ctl_cmds.reply, 0, ioc->reply_sz);
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
@@ -1660,8 +1644,9 @@ _ctl_diag_release(void __user *arg, enum block_state state)
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2DiagReleaseRequest_t)/4);
 		if (!(ioc->ctl_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
-		goto issue_host_reset;
+			*issue_reset = 1;
+		rc = -EFAULT;
+		goto out;
 	}
 
 	/* process the completed Reply Message Frame */
@@ -1687,14 +1672,101 @@ _ctl_diag_release(void __user *arg, enum block_state state)
 		rc = -EFAULT;
 	}
 
- issue_host_reset:
+ out:
+	ioc->ctl_cmds.status = MPT2_CMD_NOT_USED;
+	return rc;
+}
+
+/**
+ * _ctl_diag_release - request to send Diag Release Message to firmware
+ * @arg - user space buffer containing ioctl content
+ * @state - NON_BLOCKING or BLOCKING
+ *
+ * This allows ownership of the specified buffer to returned to the driver,
+ * allowing an application to read the buffer without fear that firmware is
+ * overwritting information in the buffer.
+ */
+static long
+_ctl_diag_release(void __user *arg, enum block_state state)
+{
+	struct mpt2_diag_release karg;
+	struct MPT2SAS_ADAPTER *ioc;
+	void *request_data;
+	int rc;
+	u8 buffer_type;
+	u8 issue_reset = 0;
+
+	if (copy_from_user(&karg, arg, sizeof(karg))) {
+		printk(KERN_ERR "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -EFAULT;
+	}
+	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
+		return -ENODEV;
+
+	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	    __func__));
+
+	buffer_type = karg.unique_id & 0x000000ff;
+	if (!_ctl_diag_capability(ioc, buffer_type)) {
+		printk(MPT2SAS_ERR_FMT "%s: doesn't have capability for "
+		    "buffer_type(0x%02x)\n", ioc->name, __func__, buffer_type);
+		return -EPERM;
+	}
+
+	if ((ioc->diag_buffer_status[buffer_type] &
+	    MPT2_DIAG_BUFFER_IS_REGISTERED) == 0) {
+		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) is not "
+		    "registered\n", ioc->name, __func__, buffer_type);
+		return -EINVAL;
+	}
+
+	if (karg.unique_id != ioc->unique_id[buffer_type]) {
+		printk(MPT2SAS_ERR_FMT "%s: unique_id(0x%08x) is not "
+		    "registered\n", ioc->name, __func__, karg.unique_id);
+		return -EINVAL;
+	}
+
+	if (ioc->diag_buffer_status[buffer_type] &
+	    MPT2_DIAG_BUFFER_IS_RELEASED) {
+		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) "
+		    "is already released\n", ioc->name, __func__,
+		    buffer_type);
+		return 0;
+	}
+
+	request_data = ioc->diag_buffer[buffer_type];
+
+	if (!request_data) {
+		printk(MPT2SAS_ERR_FMT "%s: doesn't have memory allocated for "
+		    "buffer_type(0x%02x)\n", ioc->name, __func__, buffer_type);
+		return -ENOMEM;
+	}
+
+	/* buffers were released by due to host reset */
+	if ((ioc->diag_buffer_status[buffer_type] &
+	    MPT2_DIAG_BUFFER_IS_DIAG_RESET)) {
+		ioc->diag_buffer_status[buffer_type] |=
+		    MPT2_DIAG_BUFFER_IS_RELEASED;
+		ioc->diag_buffer_status[buffer_type] &=
+		    ~MPT2_DIAG_BUFFER_IS_DIAG_RESET;
+		printk(MPT2SAS_ERR_FMT "%s: buffer_type(0x%02x) "
+		    "was released due to host reset\n", ioc->name, __func__,
+		    buffer_type);
+		return 0;
+	}
+
+	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
+		return -EAGAIN;
+	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
+		return -ERESTARTSYS;
+
+	rc = _ctl_send_release(ioc, buffer_type, &issue_reset);
+
 	if (issue_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
 
- out:
-
-	ioc->ctl_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_unlock(&ioc->ctl_cmds.mutex);
 	return rc;
 }
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
index dbb6c0c..4da1143 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
@@ -50,7 +50,7 @@
 #endif
 
 #define MPT2SAS_DEV_NAME	"mpt2ctl"
-#define MPT2_MAGIC_NUMBER	'm'
+#define MPT2_MAGIC_NUMBER	'L'
 #define MPT2_IOCTL_DEFAULT_TIMEOUT (10) /* in seconds */
 
 /**
@@ -295,8 +295,9 @@ struct mpt2_ioctl_btdh_mapping {
 
 
 /* status bits for ioc->diag_buffer_status */
-#define MPT2_DIAG_BUFFER_IS_REGISTERED 	(0x01)
-#define MPT2_DIAG_BUFFER_IS_RELEASED 	(0x02)
+#define MPT2_DIAG_BUFFER_IS_REGISTERED	(0x01)
+#define MPT2_DIAG_BUFFER_IS_RELEASED	(0x02)
+#define MPT2_DIAG_BUFFER_IS_DIAG_RESET	(0x04)
 
 /* application flags for mpt2_diag_register, mpt2_diag_query */
 #define MPT2_APP_FLAGS_APP_OWNED	(0x0001)
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 0c463c4..e3a7967 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -119,7 +119,7 @@ struct sense_info {
  */
 struct fw_event_work {
 	struct list_head 	list;
-	struct delayed_work	work;
+	struct work_struct	work;
 	struct MPT2SAS_ADAPTER *ioc;
 	u8			VF_ID;
 	u8			host_reset_handling;
@@ -516,12 +516,8 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
 	handle = sas_device->handle;
 	parent_handle = sas_device->parent_handle;
 	sas_address = sas_device->sas_address;
-	if (!mpt2sas_transport_port_add(ioc, handle, parent_handle)) {
+	if (!mpt2sas_transport_port_add(ioc, handle, parent_handle))
 		_scsih_sas_device_remove(ioc, sas_device);
-	} else if (!sas_device->starget) {
-		mpt2sas_transport_port_remove(ioc, sas_address, parent_handle);
-		_scsih_sas_device_remove(ioc, sas_device);
-	}
 }
 
 /**
@@ -1203,7 +1199,9 @@ scsih_target_destroy(struct scsi_target *starget)
 	rphy = dev_to_rphy(starget->dev.parent);
 	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
 	   rphy->identify.sas_address);
-	if (sas_device)
+	if (sas_device && (sas_device->starget == starget) &&
+	    (sas_device->id == starget->id) &&
+	    (sas_device->channel == starget->channel))
 		sas_device->starget = NULL;
 
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
@@ -2009,8 +2007,8 @@ _scsih_fw_event_add(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	list_add_tail(&fw_event->list, &ioc->fw_event_list);
-	INIT_DELAYED_WORK(&fw_event->work, _firmware_event_work);
-	queue_delayed_work(ioc->firmware_event_thread, &fw_event->work, 1);
+	INIT_WORK(&fw_event->work, _firmware_event_work);
+	queue_work(ioc->firmware_event_thread, &fw_event->work);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
@@ -2054,7 +2052,7 @@ _scsih_fw_event_requeue(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
 		return;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
-	queue_delayed_work(ioc->firmware_event_thread, &fw_event->work, delay);
+	queue_work(ioc->firmware_event_thread, &fw_event->work);
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
@@ -2863,8 +2861,9 @@ scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 		struct sense_info data;
 		const void *sense_data = mpt2sas_base_get_sense_buffer(ioc,
 		    smid);
-		memcpy(scmd->sense_buffer, sense_data,
+		u32 sz = min_t(u32, SCSI_SENSE_BUFFERSIZE,
 		    le32_to_cpu(mpi_reply->SenseCount));
+		memcpy(scmd->sense_buffer, sense_data, sz);
 		_scsih_normalize_sense(scmd->sense_buffer, &data);
 		/* failure prediction threshold exceeded */
 		if (data.asc == 0x5D)
@@ -3923,7 +3922,7 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 
 		mpt2sas_scsih_issue_tm(ioc, handle, lun,
 		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30);
-		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
+		ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 
 		if ((mpi_reply->IOCStatus == MPI2_IOCSTATUS_SUCCESS) &&
 		    (mpi_reply->ResponseCode ==
@@ -3933,10 +3932,10 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 			continue;
 
 		mpt2sas_scsih_issue_tm(ioc, handle, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET, smid, 30);
+		    MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET, 0, 30);
+		ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
 	}
-	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 	ioc->broadcast_aen_busy = 0;
 	mutex_unlock(&ioc->tm_cmds.mutex);
 
@@ -4962,7 +4961,7 @@ static void
 _firmware_event_work(struct work_struct *work)
 {
 	struct fw_event_work *fw_event = container_of(work,
-	    struct fw_event_work, work.work);
+	    struct fw_event_work, work);
 	unsigned long flags;
 	struct MPT2SAS_ADAPTER *ioc = fw_event->ioc;
 
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 2a5f077..1ce6b24 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -205,6 +205,74 @@ static unsigned _osd_req_alist_elem_size(struct osd_request *or, unsigned len)
 		osdv2_attr_list_elem_size(len);
 }
 
+static void _osd_req_alist_elem_encode(struct osd_request *or,
+	void *attr_last, const struct osd_attr *oa)
+{
+	if (osd_req_is_ver1(or)) {
+		struct osdv1_attributes_list_element *attr = attr_last;
+
+		attr->attr_page = cpu_to_be32(oa->attr_page);
+		attr->attr_id = cpu_to_be32(oa->attr_id);
+		attr->attr_bytes = cpu_to_be16(oa->len);
+		memcpy(attr->attr_val, oa->val_ptr, oa->len);
+	} else {
+		struct osdv2_attributes_list_element *attr = attr_last;
+
+		attr->attr_page = cpu_to_be32(oa->attr_page);
+		attr->attr_id = cpu_to_be32(oa->attr_id);
+		attr->attr_bytes = cpu_to_be16(oa->len);
+		memcpy(attr->attr_val, oa->val_ptr, oa->len);
+	}
+}
+
+static int _osd_req_alist_elem_decode(struct osd_request *or,
+	void *cur_p, struct osd_attr *oa, unsigned max_bytes)
+{
+	unsigned inc;
+	if (osd_req_is_ver1(or)) {
+		struct osdv1_attributes_list_element *attr = cur_p;
+
+		if (max_bytes < sizeof(*attr))
+			return -1;
+
+		oa->len = be16_to_cpu(attr->attr_bytes);
+		inc = _osd_req_alist_elem_size(or, oa->len);
+		if (inc > max_bytes)
+			return -1;
+
+		oa->attr_page = be32_to_cpu(attr->attr_page);
+		oa->attr_id = be32_to_cpu(attr->attr_id);
+
+		/* OSD1: On empty attributes we return a pointer to 2 bytes
+		 * of zeros. This keeps similar behaviour with OSD2.
+		 * (See below)
+		 */
+		oa->val_ptr = likely(oa->len) ? attr->attr_val :
+						(u8 *)&attr->attr_bytes;
+	} else {
+		struct osdv2_attributes_list_element *attr = cur_p;
+
+		if (max_bytes < sizeof(*attr))
+			return -1;
+
+		oa->len = be16_to_cpu(attr->attr_bytes);
+		inc = _osd_req_alist_elem_size(or, oa->len);
+		if (inc > max_bytes)
+			return -1;
+
+		oa->attr_page = be32_to_cpu(attr->attr_page);
+		oa->attr_id = be32_to_cpu(attr->attr_id);
+
+		/* OSD2: For convenience, on empty attributes, we return 8 bytes
+		 * of zeros here. This keeps the same behaviour with OSD2r04,
+		 * and is nice with null terminating ASCII fields.
+		 * oa->val_ptr == NULL marks the end-of-list, or error.
+		 */
+		oa->val_ptr = likely(oa->len) ? attr->attr_val : attr->reserved;
+	}
+	return inc;
+}
+
 static unsigned _osd_req_alist_size(struct osd_request *or, void *list_head)
 {
 	return osd_req_is_ver1(or) ?
@@ -282,9 +350,9 @@ _osd_req_sec_params(struct osd_request *or)
 	struct osd_cdb *ocdb = &or->cdb;
 
 	if (osd_req_is_ver1(or))
-		return &ocdb->v1.sec_params;
+		return (struct osd_security_parameters *)&ocdb->v1.sec_params;
 	else
-		return &ocdb->v2.sec_params;
+		return (struct osd_security_parameters *)&ocdb->v2.sec_params;
 }
 
 void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_device)
@@ -612,9 +680,9 @@ static int _osd_req_list_objects(struct osd_request *or,
 
 	WARN_ON(or->in.bio);
 	bio = bio_map_kern(q, list, len, or->alloc_flags);
-	if (!bio) {
+	if (IS_ERR(bio)) {
 		OSD_ERR("!!! Failed to allocate list_objects BIO\n");
-		return -ENOMEM;
+		return PTR_ERR(bio);
 	}
 
 	bio->bi_rw &= ~(1 << BIO_RW);
@@ -798,7 +866,6 @@ int osd_req_add_set_attr_list(struct osd_request *or,
 	attr_last = or->set_attr.buff + total_bytes;
 
 	for (; nelem; --nelem) {
-		struct osd_attributes_list_element *attr;
 		unsigned elem_size = _osd_req_alist_elem_size(or, oa->len);
 
 		total_bytes += elem_size;
@@ -811,11 +878,7 @@ int osd_req_add_set_attr_list(struct osd_request *or,
 				or->set_attr.buff + or->set_attr.total_bytes;
 		}
 
-		attr = attr_last;
-		attr->attr_page = cpu_to_be32(oa->attr_page);
-		attr->attr_id = cpu_to_be32(oa->attr_id);
-		attr->attr_bytes = cpu_to_be16(oa->len);
-		memcpy(attr->attr_val, oa->val_ptr, oa->len);
+		_osd_req_alist_elem_encode(or, attr_last, oa);
 
 		attr_last += elem_size;
 		++oa;
@@ -1070,15 +1133,10 @@ int osd_req_decode_get_attr_list(struct osd_request *or,
 	}
 
 	for (n = 0; (n < *nelem) && (cur_bytes < returned_bytes); ++n) {
-		struct osd_attributes_list_element *attr = cur_p;
-		unsigned inc;
+		int inc = _osd_req_alist_elem_decode(or, cur_p, oa,
+						 returned_bytes - cur_bytes);
 
-		oa->len = be16_to_cpu(attr->attr_bytes);
-		inc = _osd_req_alist_elem_size(or, oa->len);
-		OSD_DEBUG("oa->len=%d inc=%d cur_bytes=%d\n",
-			  oa->len, inc, cur_bytes);
-		cur_bytes += inc;
-		if (cur_bytes > returned_bytes) {
+		if (inc < 0) {
 			OSD_ERR("BAD FOOD from target. list not valid!"
 				"c=%d r=%d n=%d\n",
 				cur_bytes, returned_bytes, n);
@@ -1086,10 +1144,7 @@ int osd_req_decode_get_attr_list(struct osd_request *or,
 			break;
 		}
 
-		oa->attr_page = be32_to_cpu(attr->attr_page);
-		oa->attr_id = be32_to_cpu(attr->attr_id);
-		oa->val_ptr = attr->attr_val;
-
+		cur_bytes += inc;
 		cur_p += inc;
 		++oa;
 	}
@@ -1159,6 +1214,24 @@ static int _osd_req_finalize_attr_page(struct osd_request *or)
 	return ret;
 }
 
+static inline void osd_sec_parms_set_out_offset(bool is_v1,
+	struct osd_security_parameters *sec_parms, osd_cdb_offset offset)
+{
+	if (is_v1)
+		sec_parms->v1.data_out_integrity_check_offset = offset;
+	else
+		sec_parms->v2.data_out_integrity_check_offset = offset;
+}
+
+static inline void osd_sec_parms_set_in_offset(bool is_v1,
+	struct osd_security_parameters *sec_parms, osd_cdb_offset offset)
+{
+	if (is_v1)
+		sec_parms->v1.data_in_integrity_check_offset = offset;
+	else
+		sec_parms->v2.data_in_integrity_check_offset = offset;
+}
+
 static int _osd_req_finalize_data_integrity(struct osd_request *or,
 	bool has_in, bool has_out, const u8 *cap_key)
 {
@@ -1182,8 +1255,8 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 		or->out_data_integ.get_attributes_bytes = cpu_to_be64(
 			or->enc_get_attr.total_bytes);
 
-		sec_parms->data_out_integrity_check_offset =
-			osd_req_encode_offset(or, or->out.total_bytes, &pad);
+		osd_sec_parms_set_out_offset(osd_req_is_ver1(or), sec_parms,
+			osd_req_encode_offset(or, or->out.total_bytes, &pad));
 
 		ret = _req_append_segment(or, pad, &seg, or->out.last_seg,
 					  &or->out);
@@ -1203,8 +1276,8 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 		};
 		unsigned pad;
 
-		sec_parms->data_in_integrity_check_offset =
-			osd_req_encode_offset(or, or->in.total_bytes, &pad);
+		osd_sec_parms_set_in_offset(osd_req_is_ver1(or), sec_parms,
+			osd_req_encode_offset(or, or->in.total_bytes, &pad));
 
 		ret = _req_append_segment(or, pad, &seg, or->in.last_seg,
 					  &or->in);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1cb64a..bb218c8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1291,10 +1291,8 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 		if (--starget->target_blocked == 0) {
 			SCSI_LOG_MLQUEUE(3, starget_printk(KERN_INFO, starget,
 					 "unblocking target at zero depth\n"));
-		} else {
-			blk_plug_device(sdev->request_queue);
+		} else
 			return 0;
-		}
 	}
 
 	if (scsi_target_is_busy(starget)) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3fcb64b..8404423 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1344,12 +1345,8 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -EINVAL;
 	}
 
-	sector_size =	(buffer[8] << 24) | (buffer[9] << 16) |
-			(buffer[10] << 8) | buffer[11];
-	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
-		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
-		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
-		((u64)buffer[6] << 8) | (u64)buffer[7]);
+	sector_size = get_unaligned_be32(&buffer[8]);
+	lba = get_unaligned_be64(&buffer[0]);
 
 	sd_read_protection_type(sdkp, buffer);
 
@@ -1400,10 +1397,8 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -EINVAL;
 	}
 
-	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
-			(buffer[6] << 8) | buffer[7];
-	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
-		(buffer[2] << 8) | buffer[3];
+	sector_size = get_unaligned_be32(&buffer[4]);
+	lba = get_unaligned_be32(&buffer[0]);
 
 	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 82312df..e1716f1 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -179,7 +179,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 /* tasklet or soft irq callback */
 static void sg_rq_end_io(struct request *rq, int uptodate);
 static int sg_start_req(Sg_request *srp, unsigned char *cmd);
-static void sg_finish_rem_req(Sg_request * srp);
+static int sg_finish_rem_req(Sg_request * srp);
 static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
 static ssize_t sg_new_read(Sg_fd * sfp, char __user *buf, size_t count,
 			   Sg_request * srp);
@@ -518,7 +518,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 		goto err_out;
 	}
 err_out:
-	sg_finish_rem_req(srp);
+	err = sg_finish_rem_req(srp);
 	return (0 == err) ? count : err;
 }
 
@@ -1696,9 +1696,10 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	return res;
 }
 
-static void
-sg_finish_rem_req(Sg_request * srp)
+static int sg_finish_rem_req(Sg_request * srp)
 {
+	int ret = 0;
+
 	Sg_fd *sfp = srp->parentfp;
 	Sg_scatter_hold *req_schp = &srp->data;
 
@@ -1710,12 +1711,14 @@ sg_finish_rem_req(Sg_request * srp)
 
 	if (srp->rq) {
 		if (srp->bio)
-			blk_rq_unmap_user(srp->bio);
+			ret = blk_rq_unmap_user(srp->bio);
 
 		blk_put_request(srp->rq);
 	}
 
 	sg_remove_request(sfp, srp);
+
+	return ret;
 }
 
 static int
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index d92ff51..291236e 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -309,6 +309,11 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 	if (0 == sr_test_unit_ready(cd->device, &sshdr))
 		return CDS_DISC_OK;
 
+	/* SK/ASC/ASCQ of 2/4/1 means "unit is becoming ready" */
+	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY
+			&& sshdr.asc == 0x04 && sshdr.ascq == 0x01)
+		return CDS_DRIVE_NOT_READY;
+
 	if (!cdrom_get_media_event(cdi, &med)) {
 		if (med.media_present)
 			return CDS_DISC_OK;
diff --git a/include/scsi/fc/fc_fs.h b/include/scsi/fc/fc_fs.h
index 1b7af3a..ac4cd38 100644
--- a/include/scsi/fc/fc_fs.h
+++ b/include/scsi/fc/fc_fs.h
@@ -149,6 +149,7 @@ enum fc_rctl {
  * Well-known fabric addresses.
  */
 enum fc_well_known_fid {
+	FC_FID_NONE =           0x000000,       /* No destination */
 	FC_FID_BCAST =		0xffffff,	/* broadcast */
 	FC_FID_FLOGI =		0xfffffe,	/* fabric login */
 	FC_FID_FCTRL =		0xfffffd,	/* fabric controller */
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 0303a6a..45f9cc6 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -637,6 +637,7 @@ struct fc_disc {
 			      enum fc_disc_event);
 
 	struct list_head	 rports;
+	struct list_head	 rogue_rports;
 	struct fc_lport		*lport;
 	struct mutex		disc_mutex;
 	struct fc_gpn_ft_resp	partial_buf;	/* partial name buffer */
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7ffaed2..0289f57 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -36,6 +36,7 @@ struct scsi_transport_template;
 struct scsi_host_template;
 struct scsi_device;
 struct Scsi_Host;
+struct scsi_target;
 struct scsi_cmnd;
 struct socket;
 struct iscsi_transport;
@@ -350,6 +351,7 @@ extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 					  bool xmit_can_sleep);
 extern void iscsi_host_remove(struct Scsi_Host *shost);
 extern void iscsi_host_free(struct Scsi_Host *shost);
+extern int iscsi_target_alloc(struct scsi_target *starget);
 
 /*
  * session management
diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index cd3cbf7..62b2ab8 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -24,17 +24,18 @@ enum {
 	OSDv1_ADDITIONAL_CDB_LENGTH = 192,
 	OSDv1_TOTAL_CDB_LEN = OSDv1_ADDITIONAL_CDB_LENGTH + 8,
 	OSDv1_CAP_LEN = 80,
+
 	/* Latest supported version */
-/* 	OSD_ADDITIONAL_CDB_LENGTH = 216,*/
+	OSDv2_ADDITIONAL_CDB_LENGTH = 228,
 	OSD_ADDITIONAL_CDB_LENGTH =
-		OSDv1_ADDITIONAL_CDB_LENGTH, /* FIXME: Pete rev-001 sup */
+		OSDv2_ADDITIONAL_CDB_LENGTH,
 	OSD_TOTAL_CDB_LEN = OSD_ADDITIONAL_CDB_LENGTH + 8,
-/* 	OSD_CAP_LEN = 104,*/
-	OSD_CAP_LEN = OSDv1_CAP_LEN,/* FIXME: Pete rev-001 sup */
+	OSD_CAP_LEN = 104,
 
 	OSD_SYSTEMID_LEN = 20,
-	OSD_CRYPTO_KEYID_SIZE = 20,
-	/*FIXME: OSDv2_CRYPTO_KEYID_SIZE = 32,*/
+	OSDv1_CRYPTO_KEYID_SIZE = 20,
+	OSDv2_CRYPTO_KEYID_SIZE = 32,
+	OSD_CRYPTO_KEYID_SIZE = OSDv2_CRYPTO_KEYID_SIZE,
 	OSD_CRYPTO_SEED_SIZE = 4,
 	OSD_CRYPTO_NONCE_SIZE = 12,
 	OSD_MAX_SENSE_LEN = 252, /* from SPC-3 */
@@ -164,7 +165,11 @@ struct osd_cdb_head {
 			/* called allocation_length in some commands */
 /*32*/			__be64	length;
 /*40*/			__be64	start_address;
-/*48*/			__be32 list_identifier;/* Rarely used */
+			union {
+/*48*/				__be32 list_identifier;/* Rarely used */
+				/* OSD2r05 5.2.5 CDB continuation length */
+/*48*/				__be32 cdb_continuation_length;
+			};
 		} __packed v2;
 	};
 /*52*/	union { /* selected attributes mode Page/List/Single */
@@ -204,29 +209,40 @@ struct osd_cdb_head {
 /*80*/
 
 /*160 v1*/
-/*184 v2*/
-struct osd_security_parameters {
-/*160*/u8	integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
+struct osdv1_security_parameters {
+/*160*/u8	integrity_check_value[OSDv1_CRYPTO_KEYID_SIZE];
 /*180*/u8	request_nonce[OSD_CRYPTO_NONCE_SIZE];
 /*192*/osd_cdb_offset	data_in_integrity_check_offset;
 /*196*/osd_cdb_offset	data_out_integrity_check_offset;
 } __packed;
 /*200 v1*/
-/*224 v2*/
 
-/* FIXME: osdv2_security_parameters */
+/*184 v2*/
+struct osdv2_security_parameters {
+/*184*/u8	integrity_check_value[OSDv2_CRYPTO_KEYID_SIZE];
+/*216*/u8	request_nonce[OSD_CRYPTO_NONCE_SIZE];
+/*228*/osd_cdb_offset	data_in_integrity_check_offset;
+/*232*/osd_cdb_offset	data_out_integrity_check_offset;
+} __packed;
+/*236 v2*/
+
+struct osd_security_parameters {
+	union {
+		struct osdv1_security_parameters v1;
+		struct osdv2_security_parameters v2;
+	};
+};
 
 struct osdv1_cdb {
 	struct osd_cdb_head h;
 	u8 caps[OSDv1_CAP_LEN];
-	struct osd_security_parameters sec_params;
+	struct osdv1_security_parameters sec_params;
 } __packed;
 
 struct osdv2_cdb {
 	struct osd_cdb_head h;
 	u8 caps[OSD_CAP_LEN];
-	struct osd_security_parameters sec_params;
-	/* FIXME: osdv2_security_parameters */
+	struct osdv2_security_parameters sec_params;
 } __packed;
 
 struct osd_cdb {
@@ -301,14 +317,25 @@ struct osd_attributes_list_attrid {
 } __packed;
 
 /*
+ * NOTE: v1: is not aligned.
+ */
+struct osdv1_attributes_list_element {
+	__be32 attr_page;
+	__be32 attr_id;
+	__be16 attr_bytes; /* valid bytes at attr_val without padding */
+	u8 attr_val[0];
+} __packed;
+
+/*
  * osd2r03: 7.1.3.3 List entry format for retrieved attributes and
  *                  for setting attributes
- * NOTE: v2 is 8-bytes aligned, v1 is not aligned.
+ * NOTE: v2 is 8-bytes aligned
  */
-struct osd_attributes_list_element {
+struct osdv2_attributes_list_element {
 	__be32 attr_page;
 	__be32 attr_id;
-	__be16 attr_bytes;
+	u8 reserved[6];
+	__be16 attr_bytes; /* valid bytes at attr_val without padding */
 	u8 attr_val[0];
 } __packed;
 
@@ -324,13 +351,13 @@ enum {
 
 static inline unsigned osdv1_attr_list_elem_size(unsigned len)
 {
-	return ALIGN(len + sizeof(struct osd_attributes_list_element),
+	return ALIGN(len + sizeof(struct osdv1_attributes_list_element),
 		     OSDv1_ATTRIBUTES_ELEM_ALIGN);
 }
 
 static inline unsigned osdv2_attr_list_elem_size(unsigned len)
 {
-	return ALIGN(len + sizeof(struct osd_attributes_list_element),
+	return ALIGN(len + sizeof(struct osdv2_attributes_list_element),
 		     OSD_ATTRIBUTES_ELEM_ALIGN);
 }
 
@@ -419,15 +446,35 @@ struct osd_data_out_integrity_info {
 	__be64 data_bytes;
 	__be64 set_attributes_bytes;
 	__be64 get_attributes_bytes;
-	__be64 integrity_check_value;
+	__u8 integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
 } __packed;
 
+/* Same osd_data_out_integrity_info is used for OSD2/OSD1. The only difference
+ * Is the sizeof the structure since in OSD1 the last array is smaller. Use
+ * below for version independent handling of this structure
+ */
+static inline int osd_data_out_integrity_info_sizeof(bool is_ver1)
+{
+	return sizeof(struct osd_data_out_integrity_info) -
+		(is_ver1 * (OSDv2_CRYPTO_KEYID_SIZE - OSDv1_CRYPTO_KEYID_SIZE));
+}
+
 struct osd_data_in_integrity_info {
 	__be64 data_bytes;
 	__be64 retrieved_attributes_bytes;
-	__be64 integrity_check_value;
+	__u8 integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
 } __packed;
 
+/* Same osd_data_in_integrity_info is used for OSD2/OSD1. The only difference
+ * Is the sizeof the structure since in OSD1 the last array is smaller. Use
+ * below for version independent handling of this structure
+ */
+static inline int osd_data_in_integrity_info_sizeof(bool is_ver1)
+{
+	return sizeof(struct osd_data_in_integrity_info) -
+		(is_ver1 * (OSDv2_CRYPTO_KEYID_SIZE - OSDv1_CRYPTO_KEYID_SIZE));
+}
+
 struct osd_timestamp {
 	u8 time[6]; /* number of milliseconds since 1/1/1970 UT (big endian) */
 } __packed;
@@ -477,7 +524,7 @@ enum osd_capability_bit_masks {
 
 	OSD_SEC_CAP_NONE1	= BIT(8),
 	OSD_SEC_CAP_NONE2	= BIT(9),
-	OSD_SEC_CAP_NONE3	= BIT(10),
+	OSD_SEC_GBL_REM 	= BIT(10), /*v2 only*/
 	OSD_SEC_CAP_QUERY	= BIT(11), /*v2 only*/
 	OSD_SEC_CAP_M_OBJECT	= BIT(12), /*v2 only*/
 	OSD_SEC_CAP_POL_SEC	= BIT(13),
@@ -552,8 +599,7 @@ struct osdv1_capability {
 
 struct osd_capability {
 	struct osd_capability_head h;
-/* 	struct osd_cap_object_descriptor od;*/
-	struct osdv1_cap_object_descriptor od; /* FIXME: Pete rev-001 sup */
+	struct osd_cap_object_descriptor od;
 } __packed;
 
 /**


