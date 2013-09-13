From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 18/22] be2iscsi: Fix log level for protocol specific logs
Date: Thu, 12 Sep 2013 22:10:08 -0700
Message-ID: <1379049014-32716-18-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39798 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3IMFgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:50 -0400
Received: by mail-pa0-f44.google.com with SMTP id fz6so2060306pac.17
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:48 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   11 ++++++++---
 drivers/scsi/be2iscsi/be_main.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index af3ec3a..9e9d9c4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -149,7 +149,8 @@ BEISCSI_RW_ATTR(log_enable, 0x00,
 		"\t\t\t\tMiscellaneous Events	: 0x04\n"
 		"\t\t\t\tError Handling		: 0x08\n"
 		"\t\t\t\tIO Path Events		: 0x10\n"
-		"\t\t\t\tConfiguration Path	: 0x20\n");
+		"\t\t\t\tConfiguration Path	: 0x20\n"
+		"\t\t\t\tiSCSI Protocol		: 0x40\n");
 
 DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
 DEVICE_ATTR(beiscsi_adapter_family, S_IRUGO, beiscsi_adap_family_disp, NULL);
@@ -5029,8 +5030,12 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 		struct beiscsi_hba *phba = NULL;
 
 		phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_IO,
-			    "BM_%d : scsi_dma_map Failed\n");
+		beiscsi_log(phba, KERN_ERR,
+			    BEISCSI_LOG_IO | BEISCSI_LOG_ISCSI,
+			    "BM_%d : scsi_dma_map Failed "
+			    "Driver_ITT : 0x%x ITT : 0x%x Xferlen : 0x%x\n",
+			    be32_to_cpu(io_task->cmd_bhs->iscsi_hdr.itt),
+			    io_task->libiscsi_itt, scsi_bufflen(sc));
 
 		return num_sg;
 	}
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 88291b0..a8ae6b8 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1040,6 +1040,7 @@ struct hwi_context_memory {
 #define BEISCSI_LOG_EH		0x0008	/* Error Handler */
 #define BEISCSI_LOG_IO		0x0010	/* IO Code Path */
 #define BEISCSI_LOG_CONFIG	0x0020	/* CONFIG Code Path */
+#define BEISCSI_LOG_ISCSI	0x0040	/* SCSI/iSCSI Protocol related Logs */
 
 #define beiscsi_log(phba, level, mask, fmt, arg...) \
 do { \
-- 
1.7.10.4

