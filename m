From: akpm@osdl.org
Subject: [patch 10/28] drivers/scsi/FlashPoint.c: remove UINT
Date: Wed, 08 Mar 2006 00:14:26 -0800
Message-ID: <200603080816.k288GFew002182@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:22956 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752098AbWCHIQS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-uint drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-uint	Mon Feb  6 14:50:02 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:02 2006
@@ -40,7 +40,6 @@
 #define FAILURE         0xFFFFFFFFL
 
 
-typedef unsigned int    UINT;
 typedef unsigned long   ULONG;
 
 
@@ -5205,7 +5204,7 @@ static void FPT_dataXferProcessor(ULONG 
 static void FPT_busMstrSGDataXferStart(ULONG p_port, PSCCB pcurrSCCB)
 {
    ULONG count,addr,tmpSGCnt;
-   UINT sg_index;
+   unsigned int sg_index;
    unsigned char sg_count, i;
    ULONG reg_offset;
 
@@ -5231,7 +5230,7 @@ static void FPT_busMstrSGDataXferStart(U
 	WR_HARPOON(p_port+hp_page_ctrl, i);
 
    while ((sg_count < (unsigned char)SG_BUF_CNT) &&
-      ((ULONG)(sg_index * (UINT)SG_ELEMENT_SIZE) < pcurrSCCB->DataLength) ) {
+      ((ULONG)(sg_index * (unsigned int)SG_ELEMENT_SIZE) < pcurrSCCB->DataLength) ) {
 
       tmpSGCnt += *(((ULONG *)pcurrSCCB->DataPointer)+
          (sg_index * 2));
@@ -5403,7 +5402,7 @@ static void FPT_hostDataXferAbort(ULONG 
 
    ULONG timeout;
    ULONG remain_cnt;
-   UINT sg_ptr;
+   unsigned int sg_ptr;
 
    FPT_BL_Card[p_card].globalFlags &= ~F_HOST_XFER_ACT;
 
@@ -5454,9 +5453,9 @@ static void FPT_hostDataXferAbort(ULONG 
 
          sg_ptr = pCurrSCCB->Sccb_sgseg + SG_BUF_CNT;
 
-         if (sg_ptr > (UINT)(pCurrSCCB->DataLength / SG_ELEMENT_SIZE)) {
+         if (sg_ptr > (unsigned int)(pCurrSCCB->DataLength / SG_ELEMENT_SIZE)) {
 
-            sg_ptr = (UINT)(pCurrSCCB->DataLength / SG_ELEMENT_SIZE);
+            sg_ptr = (unsigned int)(pCurrSCCB->DataLength / SG_ELEMENT_SIZE);
             }
 
          remain_cnt = pCurrSCCB->Sccb_XferCnt;
@@ -5659,7 +5658,7 @@ static void FPT_hostDataXferAbort(ULONG 
 static void FPT_hostDataXferRestart(PSCCB currSCCB)
 {
    ULONG data_count;
-   UINT  sg_index;
+   unsigned int  sg_index;
    ULONG *sg_ptr;
 
    if (currSCCB->Sccb_XferState & F_SG_XFER) {
@@ -7418,7 +7417,7 @@ static unsigned char FPT_queueFindSccb(P
 static void  FPT_utilUpdateResidual(PSCCB p_SCCB)
 {
    ULONG partial_cnt;
-   UINT  sg_index;
+   unsigned int  sg_index;
    ULONG *sg_ptr;
 
    if (p_SCCB->Sccb_XferState & F_ALL_XFERRED) {
_
