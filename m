From: James.Smart@Emulex.Com
Subject: [PATCH 7/15]  lpfc 8.1.0 : Restore HEX safe bahavior of the sysfs xxx_store functions.
Date: Fri, 28 Oct 2005 20:29:32 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A56@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:3793 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750922AbVJ2A3f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:35 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0TXDp018528
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:34 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Restore HEX safe bahavior of the sysfs xxx_store functions.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -297,6 +297,18 @@ lpfc_##attr##_show(struct class_device *
 			phba->cfg_##attr);\
 }
 
+#define lpfc_param_hex_show(attr)	\
+static ssize_t \
+lpfc_##attr##_show(struct class_device *cdev, char *buf) \
+{ \
+	struct Scsi_Host *host = class_to_shost(cdev);\
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];\
+	int val = 0;\
+	val = phba->cfg_##attr;\
+	return snprintf(buf, PAGE_SIZE, "%#x\n",\
+			phba->cfg_##attr);\
+}
+
 #define lpfc_param_init(attr, default, minval, maxval)	\
 static int \
 lpfc_##attr##_init(struct lpfc_hba *phba, int val) \
@@ -335,8 +347,10 @@ lpfc_##attr##_store(struct class_device 
 	struct Scsi_Host *host = class_to_shost(cdev);\
 	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];\
 	int val=0;\
-	if (sscanf(buf, "%d", &val) != 1)\
-	return -EPERM;\
+	if (!isdigit(buf[0]))\
+		return -EINVAL;\
+	if (sscanf(buf, "%i", &val) != 1)\
+		return -EINVAL;\
 	if (lpfc_##attr##_set(phba, val) == 0) \
 		return strlen(buf);\
 	else \
@@ -368,6 +382,25 @@ lpfc_param_store(name)\
 static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
 			 lpfc_##name##_show, lpfc_##name##_store)
 
+#define LPFC_ATTR_HEX_R(name, defval, minval, maxval, desc) \
+static int lpfc_##name = defval;\
+module_param(lpfc_##name, int, 0);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_param_hex_show(name)\
+lpfc_param_init(name, defval, minval, maxval)\
+static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
+
+#define LPFC_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
+static int lpfc_##name = defval;\
+module_param(lpfc_##name, int, 0);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_param_hex_show(name)\
+lpfc_param_init(name, defval, minval, maxval)\
+lpfc_param_set(name, defval, minval, maxval)\
+lpfc_param_store(name)\
+static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
+			 lpfc_##name##_show, lpfc_##name##_store)
+
 static CLASS_DEVICE_ATTR(info, S_IRUGO, lpfc_info_show, NULL);
 static CLASS_DEVICE_ATTR(serialnum, S_IRUGO, lpfc_serialnum_show, NULL);
 static CLASS_DEVICE_ATTR(modeldesc, S_IRUGO, lpfc_modeldesc_show, NULL);
@@ -410,7 +443,7 @@ static CLASS_DEVICE_ATTR(board_online, S
 # LOG_LIBDFC                    0x2000     LIBDFC events
 # LOG_ALL_MSG                   0xffff     LOG all messages
 */
-LPFC_ATTR_RW(log_verbose, 0x0, 0x0, 0xffff, "Verbose logging bit-mask");
+LPFC_ATTR_HEX_RW(log_verbose, 0x0, 0x0, 0xffff, "Verbose logging bit-mask");
 
 /*
 # lun_queue_depth:  This parameter is used to limit the number of outstanding
