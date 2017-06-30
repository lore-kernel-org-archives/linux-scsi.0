From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 12/15] megaraid_sas: replace internal FALSE/TRUE definitions with false/true
Date: Fri, 30 Jun 2017 01:30:06 -0700
Message-ID: <1498811409-11157-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34107 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbdF3Ib1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2017 04:31:27 -0400
Received: by mail-pf0-f181.google.com with SMTP id s66so63608587pfs.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2017 01:31:27 -0700 (PDT)
In-Reply-To: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 40 +++++++++++++--------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 62affa7..ecc699a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -67,16 +67,6 @@ MODULE_PARM_DESC(lb_pending_cmds, "Change raid-1 load balancing outstanding "
 #define ABS_DIFF(a, b)   (((a) > (b)) ? ((a) - (b)) : ((b) - (a)))
 #define MR_LD_STATE_OPTIMAL 3
 
-#ifdef FALSE
-#undef FALSE
-#endif
-#define FALSE 0
-
-#ifdef TRUE
-#undef TRUE
-#endif
-#define TRUE 1
-
 #define SPAN_ROW_SIZE(map, ld, index_) (MR_LdSpanPtrGet(ld, index_, map)->spanRowSize)
 #define SPAN_ROW_DATA_SIZE(map_, ld, index_)   (MR_LdSpanPtrGet(ld, index_, map)->spanRowDataSize)
 #define SPAN_INVALID  0xff
@@ -709,7 +699,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	u32     pd, arRef, r1_alt_pd;
 	u8      physArm, span;
 	u64     row;
-	u8	retval = TRUE;
+	u8	retval = true;
 	u64	*pdBlock = &io_info->pdBlock;
 	__le16	*pDevHandle = &io_info->devHandle;
 	u8	*pPdInterface = &io_info->pd_interface;
@@ -727,7 +717,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	if (raid->level == 6) {
 		logArm = get_arm_from_strip(instance, ld, stripRow, map);
 		if (logArm == -1U)
-			return FALSE;
+			return false;
 		rowMod = mega_mod64(row, SPAN_ROW_SIZE(map, ld, span));
 		armQ = SPAN_ROW_SIZE(map, ld, span) - 1 - rowMod;
 		arm = armQ + 1 + logArm;
@@ -738,7 +728,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 		/* Calculate the arm */
 		physArm = get_arm(instance, ld, span, stripRow, map);
 	if (physArm == 0xFF)
-		return FALSE;
+		return false;
 
 	arRef       = MR_LdSpanArrayGet(ld, span, map);
 	pd          = MR_ArPdGet(arRef, physArm, map);
@@ -812,7 +802,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	u32         pd, arRef, r1_alt_pd;
 	u8          physArm, span;
 	u64         row;
-	u8	    retval = TRUE;
+	u8	    retval = true;
 	u64	    *pdBlock = &io_info->pdBlock;
 	__le16	    *pDevHandle = &io_info->devHandle;
 	u8	    *pPdInterface = &io_info->pd_interface;
@@ -829,7 +819,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 		u32 rowMod, armQ, arm;
 
 		if (raid->rowSize == 0)
-			return FALSE;
+			return false;
 		/* get logical row mod */
 		rowMod = mega_mod64(row, raid->rowSize);
 		armQ = raid->rowSize-1-rowMod; /* index of Q drive */
@@ -839,7 +829,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 		physArm = (u8)arm;
 	} else  {
 		if (raid->modFactor == 0)
-			return FALSE;
+			return false;
 		physArm = MR_LdDataArmGet(ld,  mega_mod64(stripRow,
 							  raid->modFactor),
 					  map);
@@ -851,7 +841,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	} else {
 		span = (u8)MR_GetSpanBlock(ld, row, pdBlock, map);
 		if (span == SPAN_INVALID)
-			return FALSE;
+			return false;
 	}
 
 	/* Get the array on which this span is present */
@@ -954,7 +944,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 	 */
 	if (raid->rowDataSize == 0) {
 		if (MR_LdSpanPtrGet(ld, 0, map)->spanRowDataSize == 0)
-			return FALSE;
+			return false;
 		else if (instance->UnevenSpanSupport) {
 			io_info->IoforUnevenSpan = 1;
 		} else {
@@ -963,7 +953,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 				"rowDataSize = 0x%0x,"
 				"but there is _NO_ UnevenSpanSupport\n",
 				MR_LdSpanPtrGet(ld, 0, map)->spanRowDataSize);
-			return FALSE;
+			return false;
 		}
 	}
 
@@ -988,7 +978,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 			dev_info(&instance->pdev->dev, "return from %s %d."
 				"Send IO w/o region lock.\n",
 				__func__, __LINE__);
-			return FALSE;
+			return false;
 		}
 
 		if (raid->spanDepth == 1) {
@@ -1004,7 +994,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 				(unsigned long long)start_row,
 				(unsigned long long)start_strip,
 				(unsigned long long)endStrip);
-			return FALSE;
+			return false;
 		}
 		io_info->start_span	= startlba_span;
 		io_info->start_row	= start_row;
@@ -1038,7 +1028,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 					       raid->capability.
 					       fpWriteAcrossStripe));
 	} else
-		io_info->fpOkForIo = FALSE;
+		io_info->fpOkForIo = false;
 
 	if (numRows == 1) {
 		/* single-strip IOs can always lock only the data needed */
@@ -1124,7 +1114,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 					pRAID_Context, map);
 		/* If IO on an invalid Pd, then FP is not possible.*/
 		if (io_info->devHandle == MR_DEVHANDLE_INVALID)
-			io_info->fpOkForIo = FALSE;
+			io_info->fpOkForIo = false;
 		return retval;
 	} else if (isRead) {
 		uint stripIdx;
@@ -1138,10 +1128,10 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 				    start_strip + stripIdx, ref_in_start_stripe,
 				    io_info, pRAID_Context, map);
 			if (!retval)
-				return TRUE;
+				return true;
 		}
 	}
-	return TRUE;
+	return true;
 }
 
 /*
-- 
2.8.3
