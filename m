From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 2/4] scsi: megaraid_sas - Fix the frame count calculation
Date: Mon, 17 Mar 2008 03:36:43 -0400
Message-ID: <1205739403.7479.9.camel@pcp021067pcs.se.lsil.com>
References: <9738BCBE884FDB42801FAD8A7769C26501CE50E4@NAMAIL1.ad.lsil.com>
	 <1195251505.3407.30.camel@localhost.localdomain>
	 <9738BCBE884FDB42801FAD8A7769C26501C9A4AF@NAMAIL1.ad.lsil.com>
	 <1205824386.7238.7.camel@pcp021067pcs.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:47939 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbYCQT5L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 15:57:11 -0400
In-Reply-To: <1205824386.7238.7.camel@pcp021067pcs.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, neela.kolli@lsi.com

Driver sent the wrong frame count to firmware.  This patch fixed the frame count calculation.
  
Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |   31 ++++++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas.h |    4 +++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff -rupN linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c	2008-03-17 13:51:18.000000000 -0400
+++ linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c	2008-03-17 13:50:39.000000000 -0400
@@ -488,12 +488,13 @@ megasas_make_sgl64(struct megasas_instan
 
  /**
  * megasas_get_frame_count - Computes the number of frames
+ * @frame_type		: type of frame- io or pthru frame
  * @sge_count		: number of sg elements
  *
  * Returns the number of frames required for numnber of sge's (sge_count)
  */
 
-static u32 megasas_get_frame_count(u8 sge_count)
+static u32 megasas_get_frame_count(u8 sge_count, u8 frame_type)
 {
 	int num_cnt;
 	int sge_bytes;
@@ -504,13 +505,22 @@ static u32 megasas_get_frame_count(u8 sg
 	    sizeof(struct megasas_sge32);
 
 	/*
-	* Main frame can contain 2 SGEs for 64-bit SGLs and
-	* 3 SGEs for 32-bit SGLs
-	*/
-	if (IS_DMA64)
-		num_cnt = sge_count - 2;
-	else
-		num_cnt = sge_count - 3;
+	 * Main frame can contain 2 SGEs for 64-bit SGLs and
+	 * 3 SGEs for 32-bit SGLs for ldio &
+	 * 1 SGEs for 64-bit SGLs and
+	 * 2 SGEs for 32-bit SGLs for pthru frame
+	 */
+	if (unlikely(frame_type == PTHRU_FRAME)) {
+		if (IS_DMA64)
+			num_cnt = sge_count - 1;
+		else
+			num_cnt = sge_count - 2;
+	} else {
+		if (IS_DMA64)
+			num_cnt = sge_count - 2;
+		else
+			num_cnt = sge_count - 3;
+	}
 
 	if(num_cnt>0){
 		sge_bytes = sge_sz * num_cnt;
@@ -592,7 +602,8 @@ megasas_build_dcdb(struct megasas_instan
 	 * Compute the total number of frames this command consumes. FW uses
 	 * this number to pull sufficient number of frames from host memory.
 	 */
-	cmd->frame_count = megasas_get_frame_count(pthru->sge_count);
+	cmd->frame_count = megasas_get_frame_count(pthru->sge_count,
+							PTHRU_FRAME);
 
 	return cmd->frame_count;
 }
@@ -709,7 +720,7 @@ megasas_build_ldio(struct megasas_instan
 	 * Compute the total number of frames this command consumes. FW uses
 	 * this number to pull sufficient number of frames from host memory.
 	 */
-	cmd->frame_count = megasas_get_frame_count(ldio->sge_count);
+	cmd->frame_count = megasas_get_frame_count(ldio->sge_count, IO_FRAME);
 
 	return cmd->frame_count;
 }
diff -rupN linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.h	2008-03-07 13:45:43.000000000 -0500
+++ linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.h	2008-03-07 14:03:41.000000000 -0500
@@ -542,6 +542,10 @@ struct megasas_ctrl_info {
 
 #define MEGASAS_FW_BUSY				1
 
+/* Frame Type */
+#define IO_FRAME				0
+#define PTHRU_FRAME				1
+
 /*
  * When SCSI mid-layer calls driver's reset routine, driver waits for
  * MEGASAS_RESET_WAIT_TIME seconds for all outstanding IO to complete. Note


