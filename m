From: akpm@osdl.org
Subject: [patch 15/28] drivers/scsi/FlashPoint.c: untypedef struct SCCBMgr_info
Date: Wed, 08 Mar 2006 00:14:30 -0800
Message-ID: <200603080816.k288GKL5002197@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:30124 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932483AbWCHIQX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

* struct SCCBMgr_info => struct sccb_mgr_info
* PSCCBMGR_INFO => struct sccb_mgr_info *
* SCCBMGR_INFO => struct sccb_mgr_info

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-sccbmgr_info drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-sccbmgr_info	Mon Feb  6 14:50:13 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:13 2006
@@ -57,7 +57,7 @@ struct sccb;
 typedef void (*CALL_BK_FN)(struct sccb *);
 
 
-typedef struct SCCBMgr_info {
+struct sccb_mgr_info {
    unsigned long    si_baseaddr;
    unsigned char    si_present;
    unsigned char    si_intvect;
@@ -79,9 +79,8 @@ typedef struct SCCBMgr_info {
    unsigned char    si_XlatInfo[4];
    unsigned long    si_reserved2[5];
    unsigned long    si_secondary_range;
-} SCCBMGR_INFO;
+};
 
-typedef SCCBMGR_INFO *      PSCCBMGR_INFO;
 
 
 #define SCSI_PARITY_ENA		  0x0001
@@ -309,7 +308,7 @@ typedef NVRAMINFO *PNVRamInfo;
 
 typedef struct SCCBcard {
    struct sccb * currentSCCB;
-   PSCCBMGR_INFO cardInfo;
+   struct sccb_mgr_info * cardInfo;
 
    unsigned long ioPort;
 
@@ -1108,7 +1107,7 @@ static void (*FPT_s_PhaseTbl[8]) (unsign
  *
  *---------------------------------------------------------------------*/
 
-static int FlashPoint_ProbeHostAdapter(PSCCBMGR_INFO pCardInfo)
+static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info * pCardInfo)
 {
    static unsigned char first_time = 1;
 
@@ -1386,7 +1385,7 @@ static int FlashPoint_ProbeHostAdapter(P
  *
  *---------------------------------------------------------------------*/
 
-static unsigned long FlashPoint_HardwareResetHostAdapter(PSCCBMGR_INFO pCardInfo)
+static unsigned long FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info * pCardInfo)
 {
    PSCCBcard CurrCard = NULL;
 	PNVRamInfo pCurrNvRam;
@@ -7788,14 +7787,14 @@ static unsigned char FPT_CalcLrc(unsigne
 static inline unsigned char
 FlashPoint__ProbeHostAdapter(struct FlashPoint_Info *FlashPointInfo)
 {
-  return FlashPoint_ProbeHostAdapter((PSCCBMGR_INFO) FlashPointInfo);
+  return FlashPoint_ProbeHostAdapter((struct sccb_mgr_info *) FlashPointInfo);
 }
 
 
 static inline FlashPoint_CardHandle_T
 FlashPoint__HardwareResetHostAdapter(struct FlashPoint_Info *FlashPointInfo)
 {
-  return FlashPoint_HardwareResetHostAdapter((PSCCBMGR_INFO) FlashPointInfo);
+  return FlashPoint_HardwareResetHostAdapter((struct sccb_mgr_info *) FlashPointInfo);
 }
 
 static inline void
_
