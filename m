From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 01/10] be2iscsi: Fix boot flags in sysfs
Date: Tue, 10 Oct 2017 16:18:11 +0530
Message-ID: <1507632500-26445-2-git-send-email-jitendra.bhivare@broadcom.com>
References: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:43217 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdJJKsl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 06:48:41 -0400
Received: by mail-pf0-f178.google.com with SMTP id d2so13616481pfh.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 03:48:40 -0700 (PDT)
In-Reply-To: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

The boot flags exported through sysfs was wrongly reverted to 2.
Use boot flag 3 required per spec.
Bit 0 Block valid flag
Bit 1 Firmware booting selected

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b4542e7..56ae0f4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4917,6 +4917,13 @@ void beiscsi_start_boot_work(struct beiscsi_hba *phba, unsigned int s_handle)
 	schedule_work(&phba->boot_work);
 }
 
+/**
+ * Boot flag info for iscsi-utilities
+ * Bit 0 Block valid flag
+ * Bit 1 Firmware booting selected
+ */
+#define BEISCSI_SYSFS_ISCSI_BOOT_FLAGS	3
+
 static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
 {
 	struct beiscsi_hba *phba = data;
@@ -4972,7 +4979,7 @@ static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
 			     auth_data.chap.intr_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-		rc = sprintf(str, "2\n");
+		rc = sprintf(str, "%d\n", BEISCSI_SYSFS_ISCSI_BOOT_FLAGS);
 		break;
 	case ISCSI_BOOT_TGT_NIC_ASSOC:
 		rc = sprintf(str, "0\n");
@@ -5004,7 +5011,7 @@ static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)
 
 	switch (type) {
 	case ISCSI_BOOT_ETH_FLAGS:
-		rc = sprintf(str, "2\n");
+		rc = sprintf(str, "%d\n", BEISCSI_SYSFS_ISCSI_BOOT_FLAGS);
 		break;
 	case ISCSI_BOOT_ETH_INDEX:
 		rc = sprintf(str, "0\n");
-- 
2.7.4
