From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] SCSI, classes, mpt2sas: have scsi_internal_device_unblock take new state (v2)
Date: Thu, 17 May 2012 23:56:57 -0500
Message-ID: <1337317019-12001-3-git-send-email-michaelc@cs.wisc.edu>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab2ERE5E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 May 2012 00:57:04 -0400
In-Reply-To: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This has scsi_internal_device_unblock/scsi_target_unblock take
the new state to set the devices as an argument instead of
always setting to running. The patch also converts users of these
functions.

This allows the FC and iSCSI class to transition devices from blocked
to transport-offline, so that when fast_io_fail/replacement_timeout
has fired we do not set the devices back to running. Instead, we
set them to SDEV_TRANSPORT_OFFLINE.

v2:
- Rebase to scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 +-
 drivers/scsi/scsi_lib.c              |   40 +++++++++++++++++++--------------
 drivers/scsi/scsi_priv.h             |    4 ++-
 drivers/scsi/scsi_transport_fc.c     |   16 ++++++-------
 drivers/scsi/scsi_transport_iscsi.c  |    6 ++--
 include/scsi/scsi_device.h           |    2 +-
 7 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index b6dd3a5..b3a1a30 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -1158,6 +1158,7 @@ extern struct scsi_transport_template *mpt2sas_transport_template;
 extern int scsi_internal_device_block(struct scsi_device *sdev);
 extern u8 mpt2sas_stm_zero_smid_handler(struct MPT2SAS_ADAPTER *ioc,
     u8 msix_index, u32 reply);
-extern int scsi_internal_device_unblock(struct scsi_device *sdev);
+extern int scsi_internal_device_unblock(struct scsi_device *sdev,
+					enum scsi_device_state new_state);
 
 #endif /* MPT2SAS_BASE_H_INCLUDED */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 76973e8..b1ebd6f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2904,7 +2904,7 @@ _scsih_ublock_io_all_device(struct MPT2SAS_ADAPTER *ioc)
 		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev, "device_running, "
 		    "handle(0x%04x)\n",
 		    sas_device_priv_data->sas_target->handle));
-		scsi_internal_device_unblock(sdev);
+		scsi_internal_device_unblock(sdev, SDEV_RUNNING);
 	}
 }
 /**
@@ -2933,7 +2933,7 @@ _scsih_ublock_io_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address)
 			    "sas address(0x%016llx)\n", ioc->name,
 				(unsigned long long)sas_address));
 			sas_device_priv_data->block = 0;
-			scsi_internal_device_unblock(sdev);
+			scsi_internal_device_unblock(sdev, SDEV_RUNNING);
 		}
 	}
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7a3bb74..9fa7bc3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2441,6 +2441,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block);
 /**
  * scsi_internal_device_unblock - resume a device after a block request
  * @sdev:	device to resume
+ * @new_state:	state to set devices to after unblocking
  *
  * Called by scsi lld's or the midlayer to restart the device queue
  * for the previously suspended scsi device.  Called from interrupt or
@@ -2450,25 +2451,30 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block);
  *
  * Notes:       
  *	This routine transitions the device to the SDEV_RUNNING state
- *	(which must be a legal transition) allowing the midlayer to
- *	goose the queue for this device.  This routine assumes the 
- *	host_lock is held upon entry.
+ *	or to one of the offline states (which must be a legal transition)
+ *	allowing the midlayer to goose the queue for this device. This
+ *	routine assumes the host_lock is held upon entry.
  */
 int
-scsi_internal_device_unblock(struct scsi_device *sdev)
+scsi_internal_device_unblock(struct scsi_device *sdev,
+			     enum scsi_device_state new_state)
 {
 	struct request_queue *q = sdev->request_queue; 
 	unsigned long flags;
-	
-	/* 
-	 * Try to transition the scsi device to SDEV_RUNNING
-	 * and goose the device queue if successful.  
+
+	/*
+	 * Try to transition the scsi device to SDEV_RUNNING or one of the
+	 * offlined states and goose the device queue if successful.
 	 */
 	if (sdev->sdev_state == SDEV_BLOCK)
-		sdev->sdev_state = SDEV_RUNNING;
-	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
-		sdev->sdev_state = SDEV_CREATED;
-	else if (sdev->sdev_state != SDEV_CANCEL &&
+		sdev->sdev_state = new_state;
+	else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
+		if (new_state == SDEV_TRANSPORT_OFFLINE ||
+		    new_state == SDEV_OFFLINE)
+			sdev->sdev_state = new_state;
+		else
+			sdev->sdev_state = SDEV_CREATED;
+	} else if (sdev->sdev_state != SDEV_CANCEL &&
 		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
 
@@ -2509,26 +2515,26 @@ EXPORT_SYMBOL_GPL(scsi_target_block);
 static void
 device_unblock(struct scsi_device *sdev, void *data)
 {
-	scsi_internal_device_unblock(sdev);
+	scsi_internal_device_unblock(sdev, *(enum scsi_device_state *)data);
 }
 
 static int
 target_unblock(struct device *dev, void *data)
 {
 	if (scsi_is_target_device(dev))
-		starget_for_each_device(to_scsi_target(dev), NULL,
+		starget_for_each_device(to_scsi_target(dev), data,
 					device_unblock);
 	return 0;
 }
 
 void
-scsi_target_unblock(struct device *dev)
+scsi_target_unblock(struct device *dev, enum scsi_device_state new_state)
 {
 	if (scsi_is_target_device(dev))
-		starget_for_each_device(to_scsi_target(dev), NULL,
+		starget_for_each_device(to_scsi_target(dev), &new_state,
 					device_unblock);
 	else
-		device_for_each_child(dev, NULL, target_unblock);
+		device_for_each_child(dev, &new_state, target_unblock);
 }
 EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 07ce3f5..cbfe5df 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -2,6 +2,7 @@
 #define _SCSI_PRIV_H
 
 #include <linux/device.h>
+#include <scsi/scsi_device.h>
 
 struct request_queue;
 struct request;
@@ -172,6 +173,7 @@ extern struct list_head scsi_sd_probe_domain;
 
 #define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	600	/* units in seconds */
 extern int scsi_internal_device_block(struct scsi_device *sdev);
-extern int scsi_internal_device_unblock(struct scsi_device *sdev);
+extern int scsi_internal_device_unblock(struct scsi_device *sdev,
+					enum scsi_device_state new_state);
 
 #endif /* _SCSI_PRIV_H */
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 5797604..b27be8b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2477,11 +2477,9 @@ static void fc_terminate_rport_io(struct fc_rport *rport)
 		i->f->terminate_rport_io(rport);
 
 	/*
-	 * must unblock to flush queued IO. The caller will have set
-	 * the port_state or flags, so that fc_remote_port_chkready will
-	 * fail IO.
+	 * Must unblock to flush queued IO. scsi-ml will fail incoming reqs.
 	 */
-	scsi_target_unblock(&rport->dev);
+	scsi_target_unblock(&rport->dev, SDEV_TRANSPORT_OFFLINE);
 }
 
 /**
@@ -2812,8 +2810,8 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 
 				/* if target, initiate a scan */
 				if (rport->scsi_target_id != -1) {
-					scsi_target_unblock(&rport->dev);
-
+					scsi_target_unblock(&rport->dev,
+							    SDEV_RUNNING);
 					spin_lock_irqsave(shost->host_lock,
 							  flags);
 					rport->flags |= FC_RPORT_SCAN_PENDING;
@@ -2882,7 +2880,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 			spin_unlock_irqrestore(shost->host_lock, flags);
 
 			if (ids->roles & FC_PORT_ROLE_FCP_TARGET) {
-				scsi_target_unblock(&rport->dev);
+				scsi_target_unblock(&rport->dev, SDEV_RUNNING);
 
 				/* initiate a scan of the target */
 				spin_lock_irqsave(shost->host_lock, flags);
@@ -3087,7 +3085,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 		/* ensure any stgt delete functions are done */
 		fc_flush_work(shost);
 
-		scsi_target_unblock(&rport->dev);
+		scsi_target_unblock(&rport->dev, SDEV_RUNNING);
 		/* initiate a scan of the target */
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags |= FC_RPORT_SCAN_PENDING;
@@ -3131,7 +3129,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 			"blocked FC remote port time out: no longer"
 			" a FCP target, removing starget\n");
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_target_unblock(&rport->dev);
+		scsi_target_unblock(&rport->dev, SDEV_TRANSPORT_OFFLINE);
 		fc_queue_work(shost, &rport->stgt_delete_work);
 		return;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 1cf640e..96ec21a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -907,7 +907,7 @@ static void session_recovery_timedout(struct work_struct *work)
 		session->transport->session_recovery_timedout(session);
 
 	ISCSI_DBG_TRANS_SESSION(session, "Unblocking SCSI target\n");
-	scsi_target_unblock(&session->dev);
+	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking SCSI target\n");
 }
 
@@ -930,7 +930,7 @@ static void __iscsi_unblock_session(struct work_struct *work)
 	session->state = ISCSI_SESSION_LOGGED_IN;
 	spin_unlock_irqrestore(&session->lock, flags);
 	/* start IO */
-	scsi_target_unblock(&session->dev);
+	scsi_target_unblock(&session->dev, SDEV_RUNNING);
 	/*
 	 * Only do kernel scanning if the driver is properly hooked into
 	 * the async scanning code (drivers like iscsi_tcp do login and
@@ -1180,7 +1180,7 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	session->state = ISCSI_SESSION_FREE;
 	spin_unlock_irqrestore(&session->lock, flags);
 
-	scsi_target_unblock(&session->dev);
+	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
 	/* flush running scans then delete devices */
 	scsi_flush_work(shost);
 	__iscsi_unbind_session(&session->unbind_work);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4acc1c3..5ff8180 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -373,7 +373,7 @@ extern void scsi_scan_target(struct device *parent, unsigned int channel,
 			     unsigned int id, unsigned int lun, int rescan);
 extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
-extern void scsi_target_unblock(struct device *);
+extern void scsi_target_unblock(struct device *, enum scsi_device_state);
 extern void scsi_remove_target(struct device *);
 extern void int_to_scsilun(unsigned int, struct scsi_lun *);
 extern int scsilun_to_int(struct scsi_lun *);
-- 
1.7.7.6

