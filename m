From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 3/3][RESUBMIT] scsi_dh_rdac: changes for rdac debug logging
Date: Fri, 28 Aug 2009 08:23:06 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474C65F3F@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:40445 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZH1OXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 10:23:12 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'device mapper development' <dm-devel@redhat.com>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Patch to add debugging stuff for rdac device handler. 
- Added a bit mask "module parameter" rdac_logging with 2 bits for each type of logging.
- currently defined only two types of logging(failover and sense logging). Can be enhanced later if required.
- By default only failover logging is enabled which is equivalent of current logging.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

---
--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-08-27 18:33:39.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-27 18:35:24.000000000 -0500
@@ -201,6 +201,31 @@ static const char *lun_state[] =
 static LIST_HEAD(ctlr_list);
 static DEFINE_SPINLOCK(list_lock);
 
+/* 
+ * module parameter to enable rdac debug logging.
+ * 2 bits for each type of logging, only two types defined for now 
+ * Can be enhanced if required at later point
+ */
+static int rdac_logging = 1;
+module_param(rdac_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(rdac_logging, "A bit mask of rdac logging levels, "
+		"Default is 1 - failover logging enabled, "
+		"set it to 0xF to enable all the logs");
+
+#define RDAC_LOG_FAILOVER	0
+#define RDAC_LOG_SENSE		2
+
+#define RDAC_LOG_BITS		2
+
+#define RDAC_LOG_LEVEL(SHIFT)  \
+        ((rdac_logging >> (SHIFT)) & ((1 << (RDAC_LOG_BITS)) - 1))
+
+#define RDAC_LOG(SHIFT, sdev, f, arg...) \
+do { \
+	if (unlikely(RDAC_LOG_LEVEL(SHIFT))) \
+		sdev_printk(KERN_INFO, sdev, RDAC_NAME ": " f "\n", ## arg); \
+} while (0);
+
 static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
@@ -480,6 +505,7 @@ static int mode_select_handle_sense(stru
 {
 	struct scsi_sense_hdr sense_hdr;
 	int err = SCSI_DH_IO, ret;
+	struct rdac_dh_data *h = get_rdac_data(sdev);
 
 	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 	if (!ret)
@@ -508,11 +534,14 @@ static int mode_select_handle_sense(stru
 			err = SCSI_DH_RETRY;
 		break;
 	default:
-		sdev_printk(KERN_INFO, sdev,
-			    "MODE_SELECT failed with sense %02x/%02x/%02x.\n",
-			    sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
+		break;
 	}
 
+	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
+		"MODE_SELECT returned with sense %02x/%02x/%02x",
+		(char *) h->ctlr->array_name, h->ctlr->index,
+		sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
+
 done:
 	return err;
 }
@@ -529,7 +558,9 @@ retry:
 	if (!rq)
 		goto done;
 
-	sdev_printk(KERN_INFO, sdev, "%s MODE_SELECT command.\n",
+	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
+		"%s MODE_SELECT command",
+		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
 	err = blk_execute_rq(q, NULL, rq, 1);
@@ -539,8 +570,12 @@ retry:
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
 	}
-	if (err == SCSI_DH_OK)
+	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
+		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
+				"MODE_SELECT completed",
+				(char *) h->ctlr->array_name, h->ctlr->index);
+	}
 
 done:
 	return err;
@@ -578,6 +613,12 @@ static int rdac_check_sense(struct scsi_
 				struct scsi_sense_hdr *sense_hdr)
 {
 	struct rdac_dh_data *h = get_rdac_data(sdev);
+		
+	RDAC_LOG(RDAC_LOG_SENSE, sdev, "array %s, ctlr %d, "
+			"I/O returned with sense %02x/%02x/%02x",
+			(char *) h->ctlr->array_name, h->ctlr->index,
+			sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
+
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)


