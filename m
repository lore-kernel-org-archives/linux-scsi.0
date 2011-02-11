From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH} scsi_dh_rdac: fix for lun_table update for rdac device
 handler
Date: Fri, 11 Feb 2011 15:14:08 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF60C1F1@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:47884 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757938Ab1BKWNO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2011 17:13:14 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>

During one of our testing, we noticed that mode select command sent from the host did not have the lun_table updated.

Problem is root caused to the way lun table is updated. Lun table update was done after the call to blk_rq_map_kern is made. This was causing problem because kernel uses bounce buffer(bio_copy_kern) if the address is not aligned.  The command buffer updated after the call(blk_rq_map_kern) was not going on the wire. Moved the code to update the lun_table before the call to fix the problem.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Signed-off-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>
Signed-off-by: Yanling Qi <Yanling.Qi@lsi.com>

---
--- linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-02-11 12:41:27.000000000 -0600
+++ linux-2.6.38-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-02-11 14:04:23.000000000 -0600
@@ -281,11 +281,13 @@ static struct request *get_rdac_req(stru
 }
 
 static struct request *rdac_failover_get(struct scsi_device *sdev,
-					 struct rdac_dh_data *h)
+			struct rdac_dh_data *h, struct list_head *list)
 {
 	struct request *rq;
 	struct rdac_mode_common *common;
 	unsigned data_size;
+	struct rdac_queue_data *qdata;
+	u8 *lun_table;
 
 	if (h->ctlr->use_ms10) {
 		struct rdac_pg_expanded *rdac_pg;
@@ -298,6 +300,7 @@ static struct request *rdac_failover_get
 		rdac_pg->subpage_code = 0x1;
 		rdac_pg->page_len[0] = 0x01;
 		rdac_pg->page_len[1] = 0x28;
+		lun_table = rdac_pg->lun_table;
 	} else {
 		struct rdac_pg_legacy *rdac_pg;
 
@@ -307,11 +310,16 @@ static struct request *rdac_failover_get
 		common = &rdac_pg->common;
 		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER;
 		rdac_pg->page_len = 0x68;
+		lun_table = rdac_pg->lun_table;
 	}
 	common->rdac_mode[1] = RDAC_MODE_TRANSFER_SPECIFIED_LUNS;
 	common->quiescence_timeout = RDAC_QUIESCENCE_TIME;
 	common->rdac_options = RDAC_FORCED_QUIESENCE;
 
+	list_for_each_entry(qdata, list, entry) {
+		lun_table[qdata->h->lun] = 0x81;
+	}
+
 	/* get request for block layer packet command */
 	rq = get_rdac_req(sdev, &h->ctlr->mode_select, data_size, WRITE);
 	if (!rq)
@@ -565,7 +573,6 @@ static void send_mode_select(struct work
 	int err, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
-	u8 *lun_table;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -573,21 +580,12 @@ static void send_mode_select(struct work
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
-	if (ctlr->use_ms10)
-		lun_table = ctlr->mode_select.expanded.lun_table;
-	else
-		lun_table = ctlr->mode_select.legacy.lun_table;
-
 retry:
 	err = SCSI_DH_RES_TEMP_UNAVAIL;
-	rq = rdac_failover_get(sdev, h);
+	rq = rdac_failover_get(sdev, h, &list);
 	if (!rq)
 		goto done;
 
-	list_for_each_entry(qdata, &list, entry) {
-		lun_table[qdata->h->lun] = 0x81;
-	}
-
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"%s MODE_SELECT command",
 		(char *) h->ctlr->array_name, h->ctlr->index,


