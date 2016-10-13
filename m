From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH v2 3/6] ibmvscsis: Synchronize cmds at remove time
Date: Thu, 13 Oct 2016 11:02:40 -0500
Message-ID: <1476374563-13967-4-git-send-email-mikecyr@us.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
 <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756541AbcJMQE5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 12:04:57 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9DFx6wi008397
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 12:03:14 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2627t9wenj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 12:03:14 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mikecyr@us.ibm.com>;
        Thu, 13 Oct 2016 12:03:13 -0400
In-Reply-To: <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>

This patch adds code to disconnect from the client, which will make sure
any outstanding commands have been completed, before continuing on with
the remove operation.

Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 39 ++++++++++++++++++++++++++++----
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |  3 +++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 2ce1d73..41af435 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -469,6 +469,18 @@ static void ibmvscsis_disconnect(struct work_struct *work)
 
 	case WAIT_ENABLED:
 		switch (new_state) {
+		case UNCONFIGURING:
+			vscsi->state = new_state;
+			vscsi->flags |= RESPONSE_Q_DOWN;
+			vscsi->flags &= ~(SCHEDULE_DISCONNECT |
+					  DISCONNECT_SCHEDULED);
+			dma_rmb();
+			if (vscsi->flags & CFG_SLEEPING) {
+				vscsi->flags &= ~CFG_SLEEPING;
+				complete(&vscsi->unconfig);
+			}
+			break;
+
 		/* should never happen */
 		case ERR_DISCONNECT:
 		case ERR_DISCONNECT_RECONNECT:
@@ -481,6 +493,13 @@ static void ibmvscsis_disconnect(struct work_struct *work)
 
 	case WAIT_IDLE:
 		switch (new_state) {
+		case UNCONFIGURING:
+			vscsi->flags |= RESPONSE_Q_DOWN;
+			vscsi->state = new_state;
+			vscsi->flags &= ~(SCHEDULE_DISCONNECT |
+					  DISCONNECT_SCHEDULED);
+			ibmvscsis_free_command_q(vscsi);
+			break;
 		case ERR_DISCONNECT:
 		case ERR_DISCONNECT_RECONNECT:
 			vscsi->state = new_state;
@@ -1186,6 +1205,15 @@ static void ibmvscsis_adapter_idle(struct scsi_info *vscsi)
 		free_qs = true;
 
 	switch (vscsi->state) {
+	case UNCONFIGURING:
+		ibmvscsis_free_command_q(vscsi);
+		dma_rmb();
+		isync();
+		if (vscsi->flags & CFG_SLEEPING) {
+			vscsi->flags &= ~CFG_SLEEPING;
+			complete(&vscsi->unconfig);
+		}
+		break;
 	case ERR_DISCONNECT_RECONNECT:
 		ibmvscsis_reset_queue(vscsi);
 		pr_debug("adapter_idle, disc_rec: flags 0x%x\n", vscsi->flags);
@@ -3338,6 +3366,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 		     (unsigned long)vscsi);
 
 	init_completion(&vscsi->wait_idle);
+	init_completion(&vscsi->unconfig);
 
 	snprintf(wq_name, 24, "ibmvscsis%s", dev_name(&vdev->dev));
 	vscsi->work_q = create_workqueue(wq_name);
@@ -3393,10 +3422,11 @@ static int ibmvscsis_remove(struct vio_dev *vdev)
 
 	pr_debug("remove (%s)\n", dev_name(&vscsi->dma_dev->dev));
 
-	/*
-	 * TBD: Need to handle if there are commands on the waiting_rsp q
-	 *      Actually, can there still be cmds outstanding to tcm?
-	 */
+	spin_lock_bh(&vscsi->intr_lock);
+	ibmvscsis_post_disconnect(vscsi, UNCONFIGURING, 0);
+	vscsi->flags |= CFG_SLEEPING;
+	spin_unlock_bh(&vscsi->intr_lock);
+	wait_for_completion(&vscsi->unconfig);
 
 	vio_disable_interrupts(vdev);
 	free_irq(vdev->irq, vscsi);
@@ -3405,7 +3435,6 @@ static int ibmvscsis_remove(struct vio_dev *vdev)
 			 DMA_BIDIRECTIONAL);
 	kfree(vscsi->map_buf);
 	tasklet_kill(&vscsi->work_task);
-	ibmvscsis_unregister_command_q(vscsi);
 	ibmvscsis_destroy_command_q(vscsi);
 	ibmvscsis_freetimer(vscsi);
 	ibmvscsis_free_cmds(vscsi);
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
index 17e0ef4..98b0ca7 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
@@ -257,6 +257,8 @@ struct scsi_info {
 #define SCHEDULE_DISCONNECT           0x00400
 	/* disconnect handler is scheduled */
 #define DISCONNECT_SCHEDULED          0x00800
+	/* remove function is sleeping */
+#define CFG_SLEEPING                  0x01000
 	u32 flags;
 	/* adapter lock */
 	spinlock_t intr_lock;
@@ -285,6 +287,7 @@ struct scsi_info {
 
 	struct workqueue_struct *work_q;
 	struct completion wait_idle;
+	struct completion unconfig;
 	struct device dev;
 	struct vio_dev *dma_dev;
 	struct srp_target target;
-- 
2.5.0

