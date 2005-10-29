From: James.Smart@Emulex.Com
Subject: [PATCH 3/15]  lpfc 8.1.0 : Return -EINVAL, -EPERM, and -EIO  instead of 0 from sysfs callbacks
Date: Fri, 28 Oct 2005 20:29:06 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A52@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64208 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750909AbVJ2A3J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:09 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0T7Dp018503
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:08 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Return -EINVAL, -EPERM, and -EIO  instead of 0 from sysfs callbacks


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -251,8 +251,6 @@ lpfc_board_online_show(struct class_devi
 	struct Scsi_Host *host = class_to_shost(cdev);
 	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
 
-	if (!phba) return 0;
-
 	if (phba->fc_flag & FC_OFFLINE_MODE)
 		return snprintf(buf, PAGE_SIZE, "0\n");
 	else
@@ -269,7 +267,7 @@ lpfc_board_online_store(struct class_dev
 	int val=0, status=0;
 
 	if (sscanf(buf, "%d", &val) != 1)
-		return 0;
+		return -EINVAL;
 
 	init_completion(&online_compl);
 
@@ -283,7 +281,7 @@ lpfc_board_online_store(struct class_dev
 	if (!status)
 		return strlen(buf);
 	else
-		return 0;
+		return -EIO;
 }
 
 
@@ -299,7 +297,7 @@ lpfc_##attr##_show(struct class_device *
 		return snprintf(buf, PAGE_SIZE, "%d\n",\
 				phba->cfg_##attr);\
 	}\
-	return 0;\
+	return -EPERM;\
 }
 
 #define lpfc_param_store(attr, minval, maxval)	\
@@ -314,13 +312,11 @@ lpfc_##attr##_store(struct class_device 
 	if (sscanf(buf, "0x%x", &val) != 1)\
 		if (sscanf(buf, "%d", &val) != 1)\
 			return -EINVAL;\
-	if (phba){\
-		if (val >= minval && val <= maxval) {\
-			phba->cfg_##attr = val;\
-			return strlen(buf);\
-		}\
+	if (val >= minval && val <= maxval) {\
+		phba->cfg_##attr = val;\
+		return strlen(buf);\
 	}\
-	return 0;\
+	return -EINVAL;\
 }
 
 #define LPFC_ATTR_R_NOINIT(name, desc) \
