From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] scsi_dh: Adding more debug options for scsi rdac handler
Date: Mon, 17 Aug 2009 11:46:58 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474B7A493@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:47773 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbZHQRrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2009 13:47:33 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

From: Babu Moger <babu.moger@lsi.com>

Hi All,
This patch adds more debugging options to scsi rdac device handler. This patch can considerably reduce the time taken to debug issues in big configurations also very helpful in addressing the support issues.
Here are the summary of changes. 
 - Added a bit mask "module parameter" rdac_logging with 2 bits for each type of logging.
 - currently defined only two types of logging(failover and sense logging). Can be enhanced later if required.
 - Only failover logging is enabled for now which is equivalent of current logging.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

---
--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-08-05 16:30:51.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-17 09:15:03.000000000 -0500
@@ -135,6 +135,8 @@ struct rdac_controller {
 		struct rdac_pg_legacy legacy;
 		struct rdac_pg_expanded expanded;
 	} mode_select;
+	u8			index;
+	u8			array_name[31];
 };
 struct c8_inquiry {
 	u8	peripheral_info;
@@ -198,6 +200,31 @@ static const char *lun_state[] =
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
+#define RDAC_DEBUG(SHIFT, sdev, f, arg...) \
+do { \
+	if (unlikely(RDAC_LOG_LEVEL(SHIFT))) \
+		sdev_printk(KERN_INFO, sdev, RDAC_NAME ": " f "\n", ## arg); \
+} while (0);
+
 static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
@@ -324,6 +351,13 @@ static struct rdac_controller *get_contr
 	/* initialize fields of controller */
 	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
 	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
+
+	/* update the controller index */
+	if (slot_id[1] == 0x31)
+		ctlr->index = 0;
+	else
+		ctlr->index = 1;
+
 	kref_init(&ctlr->kref);
 	ctlr->use_ms10 = -1;
 	list_add(&ctlr->node, &ctlr_list);
@@ -381,6 +415,26 @@ static int get_lun(struct scsi_device *s
 	return err;
 }
 
+static int get_array_name(struct scsi_device *sdev, struct rdac_dh_data *h)
+{
+	int err, i;
+	struct c8_inquiry *inqp;
+
+	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
+	if (err == SCSI_DH_OK) {
+		inqp = &h->inq.c8;
+		if (inqp->page_code != 0xc8)
+			return SCSI_DH_NOSYS;
+
+		for(i=0; i<30; ++i) {
+			h->ctlr->array_name[i] = inqp->array_user_label[(2*i)+1];
+		}
+		h->ctlr->array_name[30] = '\0';
+	}
+			
+	return err;
+}
+
 static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 {
 	int err;
@@ -450,13 +504,12 @@ static int mode_select_handle_sense(stru
 {
 	struct scsi_sense_hdr sense_hdr;
 	int err = SCSI_DH_IO, ret;
+	struct rdac_dh_data *h = get_rdac_data(sdev);
 
 	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 	if (!ret)
 		goto done;
 
-	err = SCSI_DH_OK;
-
 	switch (sense_hdr.sense_key) {
 	case NO_SENSE:
 	case ABORTED_COMMAND:
@@ -478,12 +531,15 @@ static int mode_select_handle_sense(stru
 			err = SCSI_DH_RETRY;
 		break;
 	default:
-		sdev_printk(KERN_INFO, sdev,
-			    "MODE_SELECT failed with sense %02x/%02x/%02x.\n",
-			    sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
+		break;
 	}
 
 done:
+	RDAC_DEBUG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
+		"MODE_SELECT returned with sense %02x/%02x/%02x",
+		(char *) h->ctlr->array_name, h->ctlr->index,
+		sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
+		
 	return err;
 }
 
@@ -499,7 +555,9 @@ retry:
 	if (!rq)
 		goto done;
 
-	sdev_printk(KERN_INFO, sdev, "%s MODE_SELECT command.\n",
+	RDAC_DEBUG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
+		"%s MODE_SELECT command",
+		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
 	err = blk_execute_rq(q, NULL, rq, 1);
@@ -509,8 +567,12 @@ retry:
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
 	}
-	if (err == SCSI_DH_OK)
+	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
+		RDAC_DEBUG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
+				"MODE_SELECT completed",
+				(char *) h->ctlr->array_name, h->ctlr->index);
+	}
 
 done:
 	return err;
@@ -525,12 +587,6 @@ static int rdac_activate(struct scsi_dev
 	if (err != SCSI_DH_OK)
 		goto done;
 
-	if (!h->ctlr) {
-		err = initialize_controller(sdev, h);
-		if (err != SCSI_DH_OK)
-			goto done;
-	}
-
 	if (h->ctlr->use_ms10 == -1) {
 		err = set_mode_select(sdev, h);
 		if (err != SCSI_DH_OK)
@@ -559,6 +615,12 @@ static int rdac_check_sense(struct scsi_
 				struct scsi_sense_hdr *sense_hdr)
 {
 	struct rdac_dh_data *h = get_rdac_data(sdev);
+		
+	RDAC_DEBUG(RDAC_LOG_SENSE, sdev, "array %s, ctlr %d, "
+			"command returned with sense %02x/%02x/%02x",
+			(char *) h->ctlr->array_name, h->ctlr->index,
+			sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
+
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
@@ -678,6 +740,16 @@ static int rdac_bus_attach(struct scsi_d
 	if (err != SCSI_DH_OK)
 		goto failed;
 
+	if (!h->ctlr) {
+		err = initialize_controller(sdev, h);
+		if (err != SCSI_DH_OK)
+			goto failed;
+		
+		err = get_array_name(sdev, h);
+		if (err != SCSI_DH_OK)
+			goto failed;
+	}
+
 	if (!try_module_get(THIS_MODULE))
 		goto failed;
 



