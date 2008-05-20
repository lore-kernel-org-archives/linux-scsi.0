From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 6/7] scsi_dh: Update RDAC device handler
Date: Tue, 20 May 2008 16:05:48 +0200
Message-ID: <20080520140549.0760610B5DF@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:34232 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759037AbYETOFu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 10:05:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org


This patch updates the RDAC device handler to
refuse to attach to devices not supporting the
RDAC vpd pages.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c |  158 ++++++++++++++++------------
 1 files changed, 91 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index e61cde6..e11e522 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -173,6 +173,11 @@ struct rdac_dh_data {
 #define RDAC_STATE_ACTIVE	0
 #define RDAC_STATE_PASSIVE	1
 	unsigned char		state;
+
+#define RDAC_LUN_UNOWNED	0
+#define RDAC_LUN_OWNED		1
+#define RDAC_LUN_AVT		2
+	char			lun_state;
 	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
 	union			{
 		struct c2_inquiry c2;
@@ -182,6 +187,13 @@ struct rdac_dh_data {
 	} inq;
 };
 
+static const char *lun_state[] =
+{
+	"unowned",
+	"owned",
+	"owned (AVT mode)",
+};
+
 static LIST_HEAD(ctlr_list);
 static DEFINE_SPINLOCK(list_lock);
 
@@ -197,7 +209,6 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 {
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
 
 	rq = blk_get_request(q, rw, GFP_KERNEL);
 
@@ -214,10 +225,7 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 		return NULL;
 	}
 
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
+	memset(rq->cmd, 0, BLK_MAX_CDB);
 
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
@@ -227,12 +235,12 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 	return rq;
 }
 
-static struct request *rdac_failover_get(struct scsi_device *sdev)
+static struct request *rdac_failover_get(struct scsi_device *sdev,
+					 struct rdac_dh_data *h)
 {
 	struct request *rq;
 	struct rdac_mode_common *common;
 	unsigned data_size;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
 
 	if (h->ctlr->use_ms10) {
 		struct rdac_pg_expanded *rdac_pg;
@@ -277,6 +285,10 @@ static struct request *rdac_failover_get(struct scsi_device *sdev)
 	}
 	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
 
+	rq->sense = h->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = 0;
+
 	return rq;
 }
 
@@ -321,11 +333,10 @@ done:
 }
 
 static int submit_inquiry(struct scsi_device *sdev, int page_code,
-		unsigned int len)
+			  unsigned int len, struct rdac_dh_data *h)
 {
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
 	int err = SCSI_DH_RES_TEMP_UNAVAIL;
 
 	rq = get_rdac_req(sdev, &h->inq, len, READ);
@@ -338,59 +349,68 @@ static int submit_inquiry(struct scsi_device *sdev, int page_code,
 	rq->cmd[2] = page_code;
 	rq->cmd[4] = len;
 	rq->cmd_len = COMMAND_SIZE(INQUIRY);
+
+	rq->sense = h->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = 0;
+
 	err = blk_execute_rq(q, NULL, rq, 1);
 	if (err == -EIO)
 		err = SCSI_DH_IO;
+
+	blk_put_request(rq);
 done:
 	return err;
 }
 
-static int get_lun(struct scsi_device *sdev)
+static int get_lun(struct scsi_device *sdev, struct rdac_dh_data *h)
 {
 	int err;
 	struct c8_inquiry *inqp;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
 
-	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry));
+	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c8;
-		h->lun = inqp->lun[7]; /* currently it uses only one byte */
+		if (inqp->page_code != 0xc8)
+			return SCSI_DH_NOSYS;
+		if (inqp->page_id[0] != 'e' || inqp->page_id[1] != 'd' ||
+		    inqp->page_id[2] != 'i' || inqp->page_id[3] != 'd')
+			return SCSI_DH_NOSYS;
+		h->lun = scsilun_to_int((struct scsi_lun *)inqp->lun);
 	}
 	return err;
 }
 
-#define RDAC_OWNED	0
-#define RDAC_UNOWNED	1
-#define RDAC_FAILED	2
-static int check_ownership(struct scsi_device *sdev)
+static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 {
 	int err;
 	struct c9_inquiry *inqp;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
 
-	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry));
+	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
 	if (err == SCSI_DH_OK) {
-		err = RDAC_UNOWNED;
 		inqp = &h->inq.c9;
-		/*
-		 * If in AVT mode or if the path already owns the LUN,
-		 * return RDAC_OWNED;
-		 */
-		if (((inqp->avte_cvp >> 7) == 0x1) ||
-				 ((inqp->avte_cvp & 0x1) != 0))
-			err = RDAC_OWNED;
-	} else
-		err = RDAC_FAILED;
+		if ((inqp->avte_cvp >> 7) == 0x1) {
+			/* LUN in AVT mode */
+			sdev_printk(KERN_NOTICE, sdev,
+				    "%s: AVT mode detected\n",
+				    RDAC_NAME);
+			h->lun_state = RDAC_LUN_AVT;
+		} else if ((inqp->avte_cvp & 0x1) != 0) {
+			/* LUN was owned by the controller */
+			h->lun_state = RDAC_LUN_OWNED;
+		}
+	}
+
 	return err;
 }
 
-static int initialize_controller(struct scsi_device *sdev)
+static int initialize_controller(struct scsi_device *sdev,
+				 struct rdac_dh_data *h)
 {
 	int err;
 	struct c4_inquiry *inqp;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
 
-	err = submit_inquiry(sdev, 0xC4, sizeof(struct c4_inquiry));
+	err = submit_inquiry(sdev, 0xC4, sizeof(struct c4_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c4;
 		h->ctlr = get_controller(inqp->subsys_id, inqp->slot_id);
@@ -400,13 +420,12 @@ static int initialize_controller(struct scsi_device *sdev)
 	return err;
 }
 
-static int set_mode_select(struct scsi_device *sdev)
+static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 {
 	int err;
 	struct c2_inquiry *inqp;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
 
-	err = submit_inquiry(sdev, 0xC2, sizeof(struct c2_inquiry));
+	err = submit_inquiry(sdev, 0xC2, sizeof(struct c2_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c2;
 		/*
@@ -421,13 +440,13 @@ static int set_mode_select(struct scsi_device *sdev)
 	return err;
 }
 
-static int mode_select_handle_sense(struct scsi_device *sdev)
+static int mode_select_handle_sense(struct scsi_device *sdev,
+				    unsigned char *sensebuf)
 {
 	struct scsi_sense_hdr sense_hdr;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
 	int sense, err = SCSI_DH_IO, ret;
 
-	ret = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
+	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 	if (!ret)
 		goto done;
 
@@ -451,14 +470,13 @@ done:
 	return err;
 }
 
-static int send_mode_select(struct scsi_device *sdev)
+static int send_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 {
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
-	struct rdac_dh_data *h = get_rdac_data(sdev);
 	int err = SCSI_DH_RES_TEMP_UNAVAIL;
 
-	rq = rdac_failover_get(sdev);
+	rq = rdac_failover_get(sdev, h);
 	if (!rq)
 		goto done;
 
@@ -466,9 +484,11 @@ static int send_mode_select(struct scsi_device *sdev)
 
 	err = blk_execute_rq(q, NULL, rq, 1);
 	if (err != SCSI_DH_OK)
-		err = mode_select_handle_sense(sdev);
+		err = mode_select_handle_sense(sdev, h->sense);
 	if (err == SCSI_DH_OK)
 		h->state = RDAC_STATE_ACTIVE;
+
+	blk_put_request(rq);
 done:
 	return err;
 }
@@ -478,38 +498,23 @@ static int rdac_activate(struct scsi_device *sdev)
 	struct rdac_dh_data *h = get_rdac_data(sdev);
 	int err = SCSI_DH_OK;
 
-	if (h->lun == UNINITIALIZED_LUN) {
-		err = get_lun(sdev);
-		if (err != SCSI_DH_OK)
-			goto done;
-	}
-
-	err = check_ownership(sdev);
-	switch (err) {
-	case RDAC_UNOWNED:
-		break;
-	case RDAC_OWNED:
-		err = SCSI_DH_OK;
-		goto done;
-	case RDAC_FAILED:
-	default:
-		err = SCSI_DH_IO;
+	err = check_ownership(sdev, h);
+	if (err != SCSI_DH_OK)
 		goto done;
-	}
 
 	if (!h->ctlr) {
-		err = initialize_controller(sdev);
+		err = initialize_controller(sdev, h);
 		if (err != SCSI_DH_OK)
 			goto done;
 	}
 
 	if (h->ctlr->use_ms10 == -1) {
-		err = set_mode_select(sdev);
+		err = set_mode_select(sdev, h);
 		if (err != SCSI_DH_OK)
 			goto done;
 	}
-
-	err = send_mode_select(sdev);
+	if (h->lun_state == RDAC_LUN_UNOWNED)
+		err = send_mode_select(sdev, h);
 done:
 	return err;
 }
@@ -606,11 +611,12 @@ static int rdac_bus_attach(struct scsi_device *sdev)
 	struct scsi_dh_data *scsi_dh_data;
 	struct rdac_dh_data *h;
 	unsigned long flags;
+	int err;
 
 	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
 			       + sizeof(*h) , GFP_KERNEL);
 	if (!scsi_dh_data) {
-		sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
+		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
 			    RDAC_NAME);
 		return 0;
 	}
@@ -619,14 +625,32 @@ static int rdac_bus_attach(struct scsi_device *sdev)
 	h = (struct rdac_dh_data *) scsi_dh_data->buf;
 	h->lun = UNINITIALIZED_LUN;
 	h->state = RDAC_STATE_ACTIVE;
+
+	err = get_lun(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto failed;
+
+	err = check_ownership(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto failed;
+
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-	try_module_get(THIS_MODULE);
 
-	sdev_printk(KERN_NOTICE, sdev, "Attached %s\n", RDAC_NAME);
+	sdev_printk(KERN_NOTICE, sdev,
+		    "%s: LUN %d (%s)\n",
+		    RDAC_NAME, h->lun, lun_state[(int)h->lun_state]);
+
+	try_module_get(THIS_MODULE);
 
 	return 0;
+
+failed:
+	kfree(scsi_dh_data);
+	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
+		    RDAC_NAME);
+	return -EINVAL;
 }
 
 static void rdac_bus_detach( struct scsi_device *sdev )
@@ -645,7 +669,7 @@ static void rdac_bus_detach( struct scsi_device *sdev )
 		kref_put(&h->ctlr->kref, release_controller);
 	kfree(scsi_dh_data);
 	module_put(THIS_MODULE);
-	sdev_printk(KERN_NOTICE, sdev, "Detached %s\n", RDAC_NAME);
+	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", RDAC_NAME);
 }
 
 static int __init rdac_init(void)
-- 
1.5.2.4

