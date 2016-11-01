From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Tue,  1 Nov 2016 22:49:36 +0100
Message-ID: <1478036978-30583-2-git-send-email-hare@suse.de>
References: <1478036978-30583-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60305 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754593AbcKAVtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 17:49:50 -0400
In-Reply-To: <1478036978-30583-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Switch to scsi_execute_req_flags() instead of
using the block interface directly. This will set
REQ_QUIET and REQ_PREEMPT, but this is okay as
we're evaluating the errors anyway and should be
able to send the command even if the device is
quiesced.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 172 ++++++++---------------------
 1 file changed, 49 insertions(+), 123 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 06fbd0b..6cd113b 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -205,7 +205,6 @@ struct rdac_dh_data {
 #define RDAC_NON_PREFERRED	1
 	char			preferred;
 
-	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
 	union			{
 		struct c2_inquiry c2;
 		struct c4_inquiry c4;
@@ -262,40 +261,12 @@ do { \
 		sdev_printk(KERN_INFO, sdev, RDAC_NAME ": " f "\n", ## arg); \
 } while (0);
 
-static struct request *get_rdac_req(struct scsi_device *sdev,
-			void *buffer, unsigned buflen, int rw)
+static unsigned int rdac_failover_get(struct rdac_controller *ctlr,
+				      struct list_head *list,
+				      unsigned char *cdb)
 {
-	struct request *rq;
-	struct request_queue *q = sdev->request_queue;
-
-	rq = blk_get_request(q, rw, GFP_NOIO);
-
-	if (IS_ERR(rq)) {
-		sdev_printk(KERN_INFO, sdev,
-				"get_rdac_req: blk_get_request failed.\n");
-		return NULL;
-	}
-	blk_rq_set_block_pc(rq);
-
-	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
-		blk_put_request(rq);
-		sdev_printk(KERN_INFO, sdev,
-				"get_rdac_req: blk_rq_map_kern failed.\n");
-		return NULL;
-	}
-
-	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			 REQ_FAILFAST_DRIVER;
-	rq->retries = RDAC_RETRIES;
-	rq->timeout = RDAC_TIMEOUT;
-
-	return rq;
-}
-
-static struct request *rdac_failover_get(struct scsi_device *sdev,
-			struct rdac_dh_data *h, struct list_head *list)
-{
-	struct request *rq;
+	struct scsi_device *sdev = ctlr->ms_sdev;
+	struct rdac_dh_data *h = sdev->handler_data;
 	struct rdac_mode_common *common;
 	unsigned data_size;
 	struct rdac_queue_data *qdata;
@@ -332,27 +303,17 @@ static struct request *rdac_failover_get(struct scsi_device *sdev,
 		lun_table[qdata->h->lun] = 0x81;
 	}
 
-	/* get request for block layer packet command */
-	rq = get_rdac_req(sdev, &h->ctlr->mode_select, data_size, WRITE);
-	if (!rq)
-		return NULL;
-
 	/* Prepare the command. */
 	if (h->ctlr->use_ms10) {
-		rq->cmd[0] = MODE_SELECT_10;
-		rq->cmd[7] = data_size >> 8;
-		rq->cmd[8] = data_size & 0xff;
+		cdb[0] = MODE_SELECT_10;
+		cdb[7] = data_size >> 8;
+		cdb[8] = data_size & 0xff;
 	} else {
-		rq->cmd[0] = MODE_SELECT;
-		rq->cmd[4] = data_size;
+		cdb[0] = MODE_SELECT;
+		cdb[4] = data_size;
 	}
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
 
-	return rq;
+	return data_size;
 }
 
 static void release_controller(struct kref *kref)
@@ -400,46 +361,14 @@ static struct rdac_controller *get_controller(int index, char *array_name,
 	return ctlr;
 }
 
-static int submit_inquiry(struct scsi_device *sdev, int page_code,
-			  unsigned int len, struct rdac_dh_data *h)
-{
-	struct request *rq;
-	struct request_queue *q = sdev->request_queue;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
-
-	rq = get_rdac_req(sdev, &h->inq, len, READ);
-	if (!rq)
-		goto done;
-
-	/* Prepare the command. */
-	rq->cmd[0] = INQUIRY;
-	rq->cmd[1] = 1;
-	rq->cmd[2] = page_code;
-	rq->cmd[4] = len;
-	rq->cmd_len = COMMAND_SIZE(INQUIRY);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
-
-	err = blk_execute_rq(q, NULL, rq, 1);
-	if (err == -EIO)
-		err = SCSI_DH_IO;
-
-	blk_put_request(rq);
-done:
-	return err;
-}
-
 static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
 			char *array_name, u8 *array_id)
 {
-	int err, i;
-	struct c8_inquiry *inqp;
+	int err = SCSI_DH_IO, i;
+	struct c8_inquiry *inqp = &h->inq.c8;
 
-	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
-	if (err == SCSI_DH_OK) {
-		inqp = &h->inq.c8;
+	if (!scsi_get_vpd_page(sdev, 0xC8, (unsigned char *)inqp,
+			       sizeof(struct c8_inquiry))) {
 		if (inqp->page_code != 0xc8)
 			return SCSI_DH_NOSYS;
 		if (inqp->page_id[0] != 'e' || inqp->page_id[1] != 'd' ||
@@ -453,20 +382,20 @@ static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
 		*(array_name+ARRAY_LABEL_LEN-1) = '\0';
 		memset(array_id, 0, UNIQUE_ID_LEN);
 		memcpy(array_id, inqp->array_unique_id, inqp->array_uniq_id_len);
+		err = SCSI_DH_OK;
 	}
 	return err;
 }
 
 static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 {
-	int err, access_state;
+	int err = SCSI_DH_IO, access_state;
 	struct rdac_dh_data *tmp;
-	struct c9_inquiry *inqp;
+	struct c9_inquiry *inqp = &h->inq.c9;
 
 	h->state = RDAC_STATE_ACTIVE;
-	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
-	if (err == SCSI_DH_OK) {
-		inqp = &h->inq.c9;
+	if (!scsi_get_vpd_page(sdev, 0xC9, (unsigned char *)inqp,
+			       sizeof(struct c9_inquiry))) {
 		/* detect the operating mode */
 		if ((inqp->avte_cvp >> 5) & 0x1)
 			h->mode = RDAC_MODE_IOSHIP; /* LUN in IOSHIP mode */
@@ -501,6 +430,7 @@ static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 			tmp->sdev->access_state = access_state;
 		}
 		rcu_read_unlock();
+		err = SCSI_DH_OK;
 	}
 
 	return err;
@@ -509,12 +439,11 @@ static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int initialize_controller(struct scsi_device *sdev,
 		struct rdac_dh_data *h, char *array_name, u8 *array_id)
 {
-	int err, index;
-	struct c4_inquiry *inqp;
+	int err = SCSI_DH_IO, index;
+	struct c4_inquiry *inqp = &h->inq.c4;
 
-	err = submit_inquiry(sdev, 0xC4, sizeof(struct c4_inquiry), h);
-	if (err == SCSI_DH_OK) {
-		inqp = &h->inq.c4;
+	if (!scsi_get_vpd_page(sdev, 0xC4, (unsigned char *)inqp,
+			       sizeof(struct c4_inquiry))) {
 		/* get the controller index */
 		if (inqp->slot_id[1] == 0x31)
 			index = 0;
@@ -530,18 +459,18 @@ static int initialize_controller(struct scsi_device *sdev,
 			h->sdev = sdev;
 		}
 		spin_unlock(&list_lock);
+		err = SCSI_DH_OK;
 	}
 	return err;
 }
 
 static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 {
-	int err;
-	struct c2_inquiry *inqp;
+	int err = SCSI_DH_IO;
+	struct c2_inquiry *inqp = &h->inq.c2;
 
-	err = submit_inquiry(sdev, 0xC2, sizeof(struct c2_inquiry), h);
-	if (err == SCSI_DH_OK) {
-		inqp = &h->inq.c2;
+	if (!scsi_get_vpd_page(sdev, 0xC2, (unsigned char *)inqp,
+			       sizeof(struct c2_inquiry))) {
 		/*
 		 * If more than MODE6_MAX_LUN luns are supported, use
 		 * mode select 10
@@ -550,36 +479,35 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 			h->ctlr->use_ms10 = 1;
 		else
 			h->ctlr->use_ms10 = 0;
+		err = SCSI_DH_OK;
 	}
 	return err;
 }
 
 static int mode_select_handle_sense(struct scsi_device *sdev,
-					unsigned char *sensebuf)
+				    struct scsi_sense_hdr *sense_hdr)
 {
-	struct scsi_sense_hdr sense_hdr;
-	int err = SCSI_DH_IO, ret;
+	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
-	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
-	if (!ret)
+	if (!scsi_sense_valid(sense_hdr))
 		goto done;
 
-	switch (sense_hdr.sense_key) {
+	switch (sense_hdr->sense_key) {
 	case NO_SENSE:
 	case ABORTED_COMMAND:
 	case UNIT_ATTENTION:
 		err = SCSI_DH_RETRY;
 		break;
 	case NOT_READY:
-		if (sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x01)
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
 			/* LUN Not Ready and is in the Process of Becoming
 			 * Ready
 			 */
 			err = SCSI_DH_RETRY;
 		break;
 	case ILLEGAL_REQUEST:
-		if (sense_hdr.asc == 0x91 && sense_hdr.ascq == 0x36)
+		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
 			/*
 			 * Command Lock contention
 			 */
@@ -592,7 +520,7 @@ static int mode_select_handle_sense(struct scsi_device *sdev,
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
-		sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
+		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
 done:
 	return err;
@@ -602,13 +530,14 @@ static void send_mode_select(struct work_struct *work)
 {
 	struct rdac_controller *ctlr =
 		container_of(work, struct rdac_controller, ms_work);
-	struct request *rq;
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	struct request_queue *q = sdev->request_queue;
-	int err, retry_cnt = RDAC_RETRY_COUNT;
+	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
+	unsigned char cdb[COMMAND_SIZE(MODE_SELECT_10)];
+	struct scsi_sense_hdr sshdr;
+	unsigned int data_size;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -616,21 +545,19 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
-retry:
-	err = SCSI_DH_RES_TEMP_UNAVAIL;
-	rq = rdac_failover_get(sdev, h, &list);
-	if (!rq)
-		goto done;
+ retry:
+	data_size = rdac_failover_get(ctlr, &list, cdb);
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"%s MODE_SELECT command",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	err = blk_execute_rq(q, NULL, rq, 1);
-	blk_put_request(rq);
-	if (err != SCSI_DH_OK) {
-		err = mode_select_handle_sense(sdev, h->sense);
+	if (scsi_execute_req_flags(sdev, cdb, DMA_TO_DEVICE,
+				   &h->ctlr->mode_select, data_size, &sshdr,
+				   RDAC_TIMEOUT * HZ,
+				   RDAC_RETRIES, NULL, REQ_FAILFAST_MASK)) {
+		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
 		if (err == SCSI_DH_IMM_RETRY)
@@ -643,7 +570,6 @@ static void send_mode_select(struct work_struct *work)
 				(char *) h->ctlr->array_name, h->ctlr->index);
 	}
 
-done:
 	list_for_each_entry_safe(qdata, tmp, &list, entry) {
 		list_del(&qdata->entry);
 		if (err == SCSI_DH_OK)
-- 
2.6.6

