From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 11/15] lpfc 8.1.7 : Remove depricated sysfs attribute
	board_online
Date: Thu, 06 Jul 2006 15:50:29 -0400
Message-ID: <1152215429.23158.28.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:29324 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750780AbWGFTuO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:50:14 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JoCVO006977
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:50:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove depricated sysfs attribute board_online, as it's replaced by the new
issue_reset attribute

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-07-06 14:58:54.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-07-06 15:02:24.000000000 -0400
@@ -293,45 +293,6 @@ lpfc_nport_evt_cnt_show(struct class_dev
 }
 
 static ssize_t
-lpfc_board_online_show(struct class_device *cdev, char *buf)
-{
-	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
-
-	if (phba->fc_flag & FC_OFFLINE_MODE)
-		return snprintf(buf, PAGE_SIZE, "0\n");
-	else
-		return snprintf(buf, PAGE_SIZE, "1\n");
-}
-
-static ssize_t
-lpfc_board_online_store(struct class_device *cdev, const char *buf,
-								size_t count)
-{
-	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
-	struct completion online_compl;
-	int val=0, status=0;
-
-	if (sscanf(buf, "%d", &val) != 1)
-		return -EINVAL;
-
-	init_completion(&online_compl);
-
-	if (val)
-		lpfc_workq_post_event(phba, &status, &online_compl,
-							LPFC_EVT_ONLINE);
-	else
-		lpfc_workq_post_event(phba, &status, &online_compl,
-							LPFC_EVT_OFFLINE);
-	wait_for_completion(&online_compl);
-	if (!status)
-		return strlen(buf);
-	else
-		return -EIO;
-}
-
-static ssize_t
 lpfc_board_mode_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -583,8 +544,6 @@ static CLASS_DEVICE_ATTR(lpfc_drvr_versi
 			 NULL);
 static CLASS_DEVICE_ATTR(management_version, S_IRUGO, management_version_show,
 			 NULL);
-static CLASS_DEVICE_ATTR(board_online, S_IRUGO | S_IWUSR,
-			 lpfc_board_online_show, lpfc_board_online_store);
 static CLASS_DEVICE_ATTR(board_mode, S_IRUGO | S_IWUSR,
 			 lpfc_board_mode_show, lpfc_board_mode_store);
 static CLASS_DEVICE_ATTR(issue_reset, S_IWUSR, NULL, lpfc_issue_reset);
@@ -791,7 +750,6 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_lpfc_max_luns,
 	&class_device_attr_nport_evt_cnt,
 	&class_device_attr_management_version,
-	&class_device_attr_board_online,
 	&class_device_attr_board_mode,
 	&class_device_attr_issue_reset,
 	&class_device_attr_lpfc_poll,


