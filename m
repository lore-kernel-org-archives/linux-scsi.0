From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: [PATCH] scsi_dh_rdac:Log batched lun information with mode select
 command
Date: Wed, 24 Jul 2013 13:04:45 +0000
Message-ID: <FB8A412F33166C4A930D37BD63236C902ACB8559@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:14429 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3GXNEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jul 2013 09:04:46 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.de" <hare@suse.de>

With RDAC mode, mode select is batched together for multiple LUNs and sent to one of the path for failover.
Currently Modeselect is logged without details of LUNs batched together. Modeselect command can be logged
with batched lun id information so that failover command can be tracked on per LUN basis in the syslog.

Incase if the luns involved in mode select are 16 or less, plain lun number information is logged.
If luns are large, all the lun numbers are encoded into 256 bit format and logged as hex string.

Encode Logic for each lun number into 32 byte string:
lun_bit_string[lun/8] |= (1 << (lun % 8));

Decode Logic for any specific lun number which is set in mode select in 32 byte string:
lun number = number of bits before the specific byte +  position index [0-7] of the set bit in the specific byte from R->L.

Log Snippet:

Jul 24 17:46:05 Linux-215 kernel: sd 30:0:0:94: rdac: array Marryjane, ctlr 1, queueing MODE_SELECT command for 11 lun(s) [43,89,93,94,95,97,99,100,106,107,111]
Jul 24 17:46:06 Linux-215 kernel: sd 30:0:0:94: rdac: array Marryjane, ctlr 1, MODE_SELECT completed for 11 lun(s) [43,89,93,94,95,97,99,100,106,107,111]

Jul 24 17:49:17 Linux-215 kernel: sd 29:0:1:9: rdac: array Marryjane, ctlr 0, queueing MODE_SELECT command for 54 lun(s) [0082a0aa8aaaeaaaaafaeaeb5aad000000000000000000000000000000000000]
Jul 24 17:49:19 Linux-215 kernel: sd 29:0:1:9: rdac: array Marryjane, ctlr 0, MODE_SELECT completed for 54 lun(s) [0082a0aa8aaaeaaaaafaeaeb5aad000000000000000000000000000000000000]

Signed-off-by: Shiva Krishna Merla<shivakrishna.merla@netapp.com>
Signed-off-by: Krishnasamy Somasundaram<somasundaram.krishnasamy@netapp.com>
Signed-off-by: Sean Stewart <sean.stewart@netapp.com>

---
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2013-07-04 19:05:10.000000000 +0530
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c	2013-07-24 17:56:42.000000000 +0530
@@ -257,6 +257,11 @@ do { \
 		sdev_printk(KERN_INFO, sdev, RDAC_NAME ": " f "\n", ## arg); \
 } while (0);
 
+/* number of bytes needed to represent luns involved
+ * in mode select in bit string format
+ */
+#define LUN_FAILOVER_BYTES	32
+
 static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
@@ -295,7 +300,8 @@ static struct request *get_rdac_req(stru
 }
 
 static struct request *rdac_failover_get(struct scsi_device *sdev,
-			struct rdac_dh_data *h, struct list_head *list)
+			struct rdac_dh_data *h, struct list_head *list,
+			unsigned int *num_luns)
 {
 	struct request *rq;
 	struct rdac_mode_common *common;
@@ -331,7 +337,10 @@ static struct request *rdac_failover_get
 	common->rdac_options = RDAC_FORCED_QUIESENCE;
 
 	list_for_each_entry(qdata, list, entry) {
-		lun_table[qdata->h->lun] = 0x81;
+		if (lun_table[qdata->h->lun] != 0x81) {
+			lun_table[qdata->h->lun] = 0x81;
+			(*num_luns)++;
+		}
 	}
 
 	/* get request for block layer packet command */
@@ -582,6 +591,77 @@ done:
 	return err;
 }
 
+/* encode luns involved in mode select into 256 bits string.
+ * decode logic for lun number set in each byte is as follows:
+ * lun number = number of bits before the current byte +
+ * position index [0-7] of the set bit in the current byte from R->L -
+ */
+static void lun_table_bitstring(unsigned char *lun_table,
+		unsigned int lun_table_length, unsigned char *lun_str)
+{
+	u8 lun_bit_table[LUN_FAILOVER_BYTES] = {0};
+	u8 pos = 0, ret, byte;
+	unsigned int lun;
+
+	BUG_ON(lun_str == NULL);
+
+	for (lun = 0; lun < lun_table_length; ++lun) {
+		if (lun_table[lun] == 0x81)
+			lun_bit_table[lun/8] |= (1 << (lun % 8));
+	}
+	for (byte = 0; byte < LUN_FAILOVER_BYTES; ++byte) {
+		ret = snprintf(lun_str+pos, 3, "%02x",
+				lun_bit_table[byte]);
+		pos = pos+ret;
+	}
+	lun_str[pos] = '\0';
+	return ;
+}
+
+/* get lun id's in mode select in either bit encoded
+ * or plain string format based on number of luns batched
+ */
+static void lun_table_string(unsigned char *lun_table,
+		unsigned int lun_table_length,
+		unsigned char *lun_str, unsigned int num_luns)
+{
+	u8 ret;
+	unsigned int lun, pos = 0;
+
+	BUG_ON(lun_str == NULL);
+
+	/* prefer encoded bit string for large number or luns */
+	if (num_luns > 16) {
+		lun_table_bitstring(lun_table, lun_table_length, lun_str);
+	} else {
+		for (lun = 0; lun < lun_table_length; ++lun) {
+			if (lun_table[lun] == 0x81) {
+				ret = snprintf(lun_str+pos, 4, "%d", lun);
+				lun_str[pos+ret] = ',';
+				pos = pos+ret+1;
+			}
+		}
+		lun_str[pos-1] = '\0';
+	}
+	return ;
+}
+
+/* get mode select lun table string for debug pusposes */
+static void get_ms_lunstring(struct rdac_controller *ctlr,
+			unsigned char *lun_str, unsigned int num_luns)
+{
+	if (likely(ctlr->use_ms10)) {
+		struct rdac_pg_expanded *rdac_pg = &ctlr->mode_select.expanded;
+		lun_table_string(&rdac_pg->lun_table[0],
+			256, lun_str, num_luns);
+	} else {
+		struct rdac_pg_legacy *rdac_pg = &ctlr->mode_select.legacy;
+		lun_table_string(&rdac_pg->lun_table[0],
+			MODE6_MAX_LUN, lun_str, num_luns);
+	}
+	return ;
+}
+
 static void send_mode_select(struct work_struct *work)
 {
 	struct rdac_controller *ctlr =
@@ -592,6 +672,8 @@ static void send_mode_select(struct work
 	struct request_queue *q = sdev->request_queue;
 	int err, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
+	unsigned int num_luns = 0;
+	unsigned char lun_str[LUN_FAILOVER_BYTES * 2 + 1] = {0};
 	LIST_HEAD(list);
 
 	spin_lock(&ctlr->ms_lock);
@@ -602,14 +684,19 @@ static void send_mode_select(struct work
 
 retry:
 	err = SCSI_DH_RES_TEMP_UNAVAIL;
-	rq = rdac_failover_get(sdev, h, &list);
+	rq = rdac_failover_get(sdev, h, &list, &num_luns);
 	if (!rq)
 		goto done;
 
+	/* get lun debug string only once */
+	if (retry_cnt == RDAC_RETRY_COUNT)
+		get_ms_lunstring(ctlr, lun_str, num_luns);
+
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
+		"%s MODE_SELECT command for %d lun(s) [%s]",
 		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" :
+		"retrying", num_luns, lun_str);
 
 	err = blk_execute_rq(q, NULL, rq, 1);
 	blk_put_request(rq);
@@ -621,8 +708,9 @@ retry:
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-				"MODE_SELECT completed",
-				(char *) h->ctlr->array_name, h->ctlr->index);
+			"MODE_SELECT completed for %d lun(s) [%s]",
+			(char *) h->ctlr->array_name, h->ctlr->index,
+			num_luns, lun_str);
 	}
 
 done:
--

--
