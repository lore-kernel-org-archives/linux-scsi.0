From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ibmvfc: Fix soft lockup on resume
Date: Thu, 17 Jun 2010 13:55:13 -0500
Message-ID: <201006171855.o5HItE0Y008469@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:50751 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab0FQSzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2010 14:55:40 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5HIpI6O013698
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:51:18 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5HItHos050068
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:55:20 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5HItFQ4008506
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:55:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


This fixes a softlockup seen on resume. During resume, the CRQ
must be reenabled. However, the H_ENABLE_CRQ hcall used to do
this may return H_BUSY or H_LONG_BUSY. When this happens, the
caller is expected to retry later. Normally the H_ENABLE_CRQ
succeeds relatively soon. However, we have seen cases where
this can take long enough to see softlockup warnings.
This patch changes a simple loop, which was causing the
softlockup, to a loop at task level which sleeps between
retries rather than simply spinning.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   81 +++++++++++++++++++++++++++--------------
 drivers/scsi/ibmvscsi/ibmvfc.h |    2 +
 2 files changed, 56 insertions(+), 27 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_reenable_sleep drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_reenable_sleep	2010-06-16 15:44:50.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2010-06-17 13:23:01.000000000 -0500
@@ -649,6 +649,8 @@ struct ibmvfc_event_pool {
 
 enum ibmvfc_host_action {
 	IBMVFC_HOST_ACTION_NONE = 0,
+	IBMVFC_HOST_ACTION_RESET,
+	IBMVFC_HOST_ACTION_REENABLE,
 	IBMVFC_HOST_ACTION_LOGO,
 	IBMVFC_HOST_ACTION_LOGO_WAIT,
 	IBMVFC_HOST_ACTION_INIT,
diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_reenable_sleep drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_reenable_sleep	2010-06-16 15:44:50.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2010-06-17 13:23:01.000000000 -0500
@@ -504,12 +504,23 @@ static void ibmvfc_set_host_action(struc
 		if (vhost->action == IBMVFC_HOST_ACTION_ALLOC_TGTS)
 			vhost->action = action;
 		break;
-	case IBMVFC_HOST_ACTION_LOGO:
 	case IBMVFC_HOST_ACTION_INIT:
 	case IBMVFC_HOST_ACTION_TGT_DEL:
+		switch (vhost->action) {
+		case IBMVFC_HOST_ACTION_RESET:
+		case IBMVFC_HOST_ACTION_REENABLE:
+			break;
+		default:
+			vhost->action = action;
+			break;
+		};
+		break;
+	case IBMVFC_HOST_ACTION_LOGO:
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
 	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 	case IBMVFC_HOST_ACTION_NONE:
+	case IBMVFC_HOST_ACTION_RESET:
+	case IBMVFC_HOST_ACTION_REENABLE:
 	default:
 		vhost->action = action;
 		break;
@@ -641,7 +652,7 @@ static int ibmvfc_send_crq_init_complete
  **/
 static void ibmvfc_release_crq_queue(struct ibmvfc_host *vhost)
 {
-	long rc;
+	long rc = 0;
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_crq_queue *crq = &vhost->crq;
 
@@ -649,6 +660,8 @@ static void ibmvfc_release_crq_queue(str
 	free_irq(vdev->irq, vhost);
 	tasklet_kill(&vhost->tasklet);
 	do {
+		if (rc)
+			msleep(100);
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 
@@ -667,11 +680,13 @@ static void ibmvfc_release_crq_queue(str
  **/
 static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 {
-	int rc;
+	int rc = 0;
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 
 	/* Re-enable the CRQ */
 	do {
+		if (rc)
+			msleep(100);
 		rc = plpar_hcall_norets(H_ENABLE_CRQ, vdev->unit_address);
 	} while (rc == H_IN_PROGRESS || rc == H_BUSY || H_IS_LONG_BUSY(rc));
 
@@ -690,15 +705,19 @@ static int ibmvfc_reenable_crq_queue(str
  **/
 static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 {
-	int rc;
+	int rc = 0;
+	unsigned long flags;
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_crq_queue *crq = &vhost->crq;
 
 	/* Close the CRQ */
 	do {
+		if (rc)
+			msleep(100);
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 
+	spin_lock_irqsave(vhost->host->host_lock, flags);
 	vhost->state = IBMVFC_NO_CRQ;
 	vhost->logged_in = 0;
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
@@ -716,6 +735,7 @@ static int ibmvfc_reset_crq(struct ibmvf
 		dev_warn(vhost->dev, "Partner adapter not ready\n");
 	else if (rc != 0)
 		dev_warn(vhost->dev, "Couldn't register crq (rc=%d)\n", rc);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 	return rc;
 }
@@ -821,17 +841,9 @@ static void ibmvfc_purge_requests(struct
  **/
 static void ibmvfc_hard_reset_host(struct ibmvfc_host *vhost)
 {
-	int rc;
-
-	scsi_block_requests(vhost->host);
 	ibmvfc_purge_requests(vhost, DID_ERROR);
-	if ((rc = ibmvfc_reset_crq(vhost)) ||
-	    (rc = ibmvfc_send_crq_init(vhost)) ||
-	    (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
-		dev_err(vhost->dev, "Error after reset rc=%d\n", rc);
-		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
-	} else
-		ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+	ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_RESET);
 }
 
 /**
@@ -2606,22 +2618,13 @@ static void ibmvfc_handle_crq(struct ibm
 			dev_info(vhost->dev, "Re-enabling adapter\n");
 			vhost->client_migrated = 1;
 			ibmvfc_purge_requests(vhost, DID_REQUEUE);
-			if ((rc = ibmvfc_reenable_crq_queue(vhost)) ||
-			    (rc = ibmvfc_send_crq_init(vhost))) {
-				ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
-				dev_err(vhost->dev, "Error after enable (rc=%ld)\n", rc);
-			} else
-				ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_REENABLE);
 		} else {
 			dev_err(vhost->dev, "Virtual adapter failed (rc=%d)\n", crq->format);
-
 			ibmvfc_purge_requests(vhost, DID_ERROR);
-			if ((rc = ibmvfc_reset_crq(vhost)) ||
-			    (rc = ibmvfc_send_crq_init(vhost))) {
-				ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
-				dev_err(vhost->dev, "Error after reset (rc=%ld)\n", rc);
-			} else
-				ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_RESET);
 		}
 		return;
 	case IBMVFC_CRQ_CMD_RSP:
@@ -4123,6 +4126,8 @@ static int __ibmvfc_work_to_do(struct ib
 	case IBMVFC_HOST_ACTION_TGT_DEL:
 	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
 	case IBMVFC_HOST_ACTION_QUERY:
+	case IBMVFC_HOST_ACTION_RESET:
+	case IBMVFC_HOST_ACTION_REENABLE:
 	default:
 		break;
 	};
@@ -4220,6 +4225,7 @@ static void ibmvfc_do_work(struct ibmvfc
 	struct ibmvfc_target *tgt;
 	unsigned long flags;
 	struct fc_rport *rport;
+	int rc;
 
 	ibmvfc_log_ae(vhost, vhost->events_to_log);
 	spin_lock_irqsave(vhost->host->host_lock, flags);
@@ -4229,6 +4235,27 @@ static void ibmvfc_do_work(struct ibmvfc
 	case IBMVFC_HOST_ACTION_LOGO_WAIT:
 	case IBMVFC_HOST_ACTION_INIT_WAIT:
 		break;
+	case IBMVFC_HOST_ACTION_RESET:
+		vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		rc = ibmvfc_reset_crq(vhost);
+		spin_lock_irqsave(vhost->host->host_lock, flags);
+		if (rc || (rc = ibmvfc_send_crq_init(vhost)) ||
+		    (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
+			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+			dev_err(vhost->dev, "Error after reset (rc=%d)\n", rc);
+		}
+		break;
+	case IBMVFC_HOST_ACTION_REENABLE:
+		vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		rc = ibmvfc_reenable_crq_queue(vhost);
+		spin_lock_irqsave(vhost->host->host_lock, flags);
+		if (rc || (rc = ibmvfc_send_crq_init(vhost))) {
+			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+			dev_err(vhost->dev, "Error after enable (rc=%d)\n", rc);
+		}
+		break;
 	case IBMVFC_HOST_ACTION_LOGO:
 		vhost->job_step(vhost);
 		break;
_
