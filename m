From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 2/4] be2iscsi: relinquishing control after processing 512 CQE
Date: Sun, 23 Mar 2014 18:10:46 -0400
Message-ID: <1395612648-25851-2-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1395612648-25851-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36316 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaCWWLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Mar 2014 18:11:05 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so4488121pdj.22
        for <linux-scsi@vger.kernel.org>; Sun, 23 Mar 2014 15:11:05 -0700 (PDT)
In-Reply-To: <1395612648-25851-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 stuck in IO poll for a long time. In such cases driver
 did not rearm which could lead to unprocessed eq.Change
 sched iopoll once then check for valid bit of eqe from
 eq in be_iopoll.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 9380b55..d5901a7 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -63,6 +63,7 @@
 #define BE2_SGE			32
 #define BE2_DEFPDU_HDR_SZ	64
 #define BE2_DEFPDU_DATA_SZ	8192
+#define BE2_MAX_NUM_CQ_PROC	512
 
 #define MAX_CPUS		64
 #define BEISCSI_MAX_NUM_CPUS	7
-- 
1.8.5.3

