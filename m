From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH v2 2/7] ibmvscsi: Add and use enums for valid CRQ header values
Date: Wed, 10 Feb 2016 19:32:23 -0600
Message-ID: <1455154348-3226-3-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52861 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbcBKBcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2016 20:32:43 -0500
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Wed, 10 Feb 2016 18:32:42 -0700
In-Reply-To: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, jthumshirn@suse.de, manoj@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

The PAPR defines four valid header values for the first byte of a
CRQ message. Namely, an unused/empty message (0x00), a valid
command/response entry (0x80), a valid initialization entry (0xC0),
and a valid transport event (0xFF). Further, initialization responses
have two formats namely initialize (0x01) and initialize complete
(0x02). Define these values as enums and use them in the code in
place of their magic number equivalents.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 18 +++++++++---------
 drivers/scsi/ibmvscsi/viosrp.h   | 12 ++++++++++++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index adfef9d..c888ea1 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -182,7 +182,7 @@ static struct viosrp_crq *crq_queue_next_crq(struct crq_queue *queue)
 
 	spin_lock_irqsave(&queue->lock, flags);
 	crq = &queue->msgs[queue->cur];
-	if (crq->valid & 0x80) {
+	if (crq->valid != VIOSRP_CRQ_FREE) {
 		if (++queue->cur == queue->size)
 			queue->cur = 0;
 
@@ -231,7 +231,7 @@ static void ibmvscsi_task(void *data)
 		/* Pull all the valid messages off the CRQ */
 		while ((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
 			ibmvscsi_handle_crq(crq, hostdata);
-			crq->valid = 0x00;
+			crq->valid = VIOSRP_CRQ_FREE;
 		}
 
 		vio_enable_interrupts(vdev);
@@ -239,7 +239,7 @@ static void ibmvscsi_task(void *data)
 		if (crq != NULL) {
 			vio_disable_interrupts(vdev);
 			ibmvscsi_handle_crq(crq, hostdata);
-			crq->valid = 0x00;
+			crq->valid = VIOSRP_CRQ_FREE;
 		} else {
 			done = 1;
 		}
@@ -474,7 +474,7 @@ static int initialize_event_pool(struct event_pool *pool,
 		struct srp_event_struct *evt = &pool->events[i];
 		memset(&evt->crq, 0x00, sizeof(evt->crq));
 		atomic_set(&evt->free, 1);
-		evt->crq.valid = 0x80;
+		evt->crq.valid = VIOSRP_CRQ_CMD_RSP;
 		evt->crq.IU_length = cpu_to_be16(sizeof(*evt->xfer_iu));
 		evt->crq.IU_data_ptr = cpu_to_be64(pool->iu_token +
 			sizeof(*evt->xfer_iu) * i);
@@ -1767,9 +1767,9 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 	struct srp_event_struct *evt_struct =
 			(__force struct srp_event_struct *)crq->IU_data_ptr;
 	switch (crq->valid) {
-	case 0xC0:		/* initialization */
+	case VIOSRP_CRQ_INIT_RSP:		/* initialization */
 		switch (crq->format) {
-		case 0x01:	/* Initialization message */
+		case VIOSRP_CRQ_INIT:	/* Initialization message */
 			dev_info(hostdata->dev, "partner initialized\n");
 			/* Send back a response */
 			rc = ibmvscsi_send_crq(hostdata, 0xC002000000000000LL, 0);
@@ -1781,7 +1781,7 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 			}
 
 			break;
-		case 0x02:	/* Initialization response */
+		case VIOSRP_CRQ_INIT_COMPLETE:	/* Initialization response */
 			dev_info(hostdata->dev, "partner initialization complete\n");
 
 			/* Now login */
@@ -1791,7 +1791,7 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 			dev_err(hostdata->dev, "unknown crq message type: %d\n", crq->format);
 		}
 		return;
-	case 0xFF:	/* Hypervisor telling us the connection is closed */
+	case VIOSRP_CRQ_XPORT_EVENT:	/* Hypervisor telling us the connection is closed */
 		scsi_block_requests(hostdata->host);
 		atomic_set(&hostdata->request_limit, 0);
 		if (crq->format == 0x06) {
@@ -1807,7 +1807,7 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 			ibmvscsi_reset_host(hostdata);
 		}
 		return;
-	case 0x80:		/* real payload */
+	case VIOSRP_CRQ_CMD_RSP:		/* real payload */
 		break;
 	default:
 		dev_err(hostdata->dev, "got an invalid message type 0x%02x\n",
diff --git a/drivers/scsi/ibmvscsi/viosrp.h b/drivers/scsi/ibmvscsi/viosrp.h
index d1044e9..3d20851 100644
--- a/drivers/scsi/ibmvscsi/viosrp.h
+++ b/drivers/scsi/ibmvscsi/viosrp.h
@@ -51,6 +51,18 @@ union srp_iu {
 	u8 reserved[SRP_MAX_IU_LEN];
 };
 
+enum viosrp_crq_headers {
+	VIOSRP_CRQ_FREE = 0x00,
+	VIOSRP_CRQ_CMD_RSP = 0x80,
+	VIOSRP_CRQ_INIT_RSP = 0xC0,
+	VIOSRP_CRQ_XPORT_EVENT = 0xFF
+};
+
+enum viosrp_crq_init_formats {
+	VIOSRP_CRQ_INIT = 0x01,
+	VIOSRP_CRQ_INIT_COMPLETE = 0x02
+};
+
 enum viosrp_crq_formats {
 	VIOSRP_SRP_FORMAT = 0x01,
 	VIOSRP_MAD_FORMAT = 0x02,
-- 
2.5.0

