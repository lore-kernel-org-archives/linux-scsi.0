From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 10/15] lpfc 8.1.7 : Adding new issue_reset sysfs attribute
Date: Thu, 06 Jul 2006 15:50:22 -0400
Message-ID: <1152215422.23158.27.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:27788 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750781AbWGFTuH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:50:07 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66Jo61d006969
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:50:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adding new issue_reset sysfs attribute 

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-07-06 14:49:10.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-07-06 14:58:54.000000000 -0400
@@ -243,6 +243,47 @@ lpfc_issue_lip(struct Scsi_Host *host)
 	return 0;
 }
 
+static int
+lpfc_selective_reset(struct lpfc_hba *phba)
+{
+	struct completion online_compl;
+	int status = 0;
+
+	init_completion(&online_compl);
+	lpfc_workq_post_event(phba, &status, &online_compl,
+			      LPFC_EVT_OFFLINE);
+	wait_for_completion(&online_compl);
+
+	if (status != 0)
+		return -EIO;
+
+	init_completion(&online_compl);
+	lpfc_workq_post_event(phba, &status, &online_compl,
+			      LPFC_EVT_ONLINE);
+	wait_for_completion(&online_compl);
+
+	if (status != 0)
+		return -EIO;
+
+	return 0;
+}
+
+static ssize_t
+lpfc_issue_reset(struct class_device *cdev, const char *buf, size_t count)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	int status = -EINVAL;
+
+	if (strncmp(buf, "selective", sizeof("selective") - 1) == 0)
+		status = lpfc_selective_reset(phba);
+
+	if (status == 0)
+		return strlen(buf);
+	else
+		return status;
+}
+
 static ssize_t
 lpfc_nport_evt_cnt_show(struct class_device *cdev, char *buf)
 {
@@ -546,6 +587,7 @@ static CLASS_DEVICE_ATTR(board_online, S
 			 lpfc_board_online_show, lpfc_board_online_store);
 static CLASS_DEVICE_ATTR(board_mode, S_IRUGO | S_IWUSR,
 			 lpfc_board_mode_show, lpfc_board_mode_store);
+static CLASS_DEVICE_ATTR(issue_reset, S_IWUSR, NULL, lpfc_issue_reset);
 
 static int lpfc_poll = 0;
 module_param(lpfc_poll, int, 0);
@@ -751,6 +793,7 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_management_version,
 	&class_device_attr_board_online,
 	&class_device_attr_board_mode,
+	&class_device_attr_issue_reset,
 	&class_device_attr_lpfc_poll,
 	&class_device_attr_lpfc_poll_tmo,
 	NULL,


