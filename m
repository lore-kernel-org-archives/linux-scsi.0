From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 1/5] be2iscsi: Fix the sparse warning introduced in previous submission
Date: Fri,  8 Aug 2014 00:59:58 -0400
Message-ID: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45736 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaHHFAQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 01:00:16 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so6310255pdj.26
        for <linux-scsi@vger.kernel.org>; Thu, 07 Aug 2014 22:00:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 commit 73af08e11c6638e2abd6b1fa13cdab58c2bbdbf8
 Author: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
 Date:   Mon May 5 21:41:26 2014 -0400

  be2iscsi: Fix interrupt Coalescing mechanism.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index cc7405c..4e8cb61 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -26,9 +26,9 @@
  * The commands are serviced by the ARM processor in the OneConnect's MPU.
  */
 struct be_sge {
-	u32 pa_lo;
-	u32 pa_hi;
-	u32 len;
+	__le32 pa_lo;
+	__le32 pa_hi;
+	__le32 len;
 };
 
 #define MCC_WRB_SGE_CNT_SHIFT 3	/* bits 3 - 7 of dword 0 */
@@ -624,11 +624,11 @@ static inline struct be_sge *nonembedded_sgl(struct be_mcc_wrb *wrb)
 /******************** Modify EQ Delay *******************/
 struct be_cmd_req_modify_eq_delay {
 	struct be_cmd_req_hdr hdr;
-	u32 num_eq;
+	__le32 num_eq;
 	struct {
-		u32 eq_id;
-		u32 phase;
-		u32 delay_multiplier;
+		__le32 eq_id;
+		__le32 phase;
+		__le32 delay_multiplier;
 	} delay[MAX_CPUS];
 } __packed;
 
-- 
1.8.5.3

