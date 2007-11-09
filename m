From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 2/6] scsi: megaraid_sas - check max_sgl reported by FW
	forsetting max_sectors_per_req
Date: Fri, 09 Nov 2007 04:14:00 -0500
Message-ID: <1194599640.6035.3.camel@dhcp-75-884.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34369 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbXKIVIa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2007 16:08:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, bo.Yang@lsi.com, Sumant.patro@lsi.com

1. Setting the max_sectors_per_req based on max SGL supported by the FW. Prior versions calculated 
        this value from controller info's max_sectors_1, max_sectors_2. For certain controllers/FW,
        this was resulting in a value greater than max SGL supported by the FW. Now we take the min 
        of max sgl from FW and max_sectors calculation.

2. Increased MFI_POLL_TIMEOUT_SECS to 60 seconds from 10. FW may take a max of 60 seconds to 
        respond to the INIT cmd.

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |   14 +++++++++-----
 drivers/scsi/megaraid/megaraid_sas.h |    2 +-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:01:52.687143648 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:26:01.144944592 -0500
@@ -1889,6 +1889,7 @@ static int megasas_init_mfi(struct megas
 	u32 reply_q_sz;
 	u32 max_sectors_1;
 	u32 max_sectors_2;
+	u32 tmp_sectors;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
 	/*
@@ -1981,17 +1982,20 @@ static int megasas_init_mfi(struct megas
 	 * Note that older firmwares ( < FW ver 30) didn't report information
 	 * to calculate max_sectors_1. So the number ended up as zero always.
 	 */
+	tmp_sectors = 0;
 	if (ctrl_info && !megasas_get_ctrl_info(instance, ctrl_info)) {
 
 		max_sectors_1 = (1 << ctrl_info->stripe_sz_ops.min) *
 		    ctrl_info->max_strips_per_io;
 		max_sectors_2 = ctrl_info->max_request_size;
 
-		instance->max_sectors_per_req = (max_sectors_1 < max_sectors_2)
-		    ? max_sectors_1 : max_sectors_2;
-	} else
-		instance->max_sectors_per_req = instance->max_num_sge *
-		    PAGE_SIZE / 512;
+		tmp_sectors = min_t(u32, max_sectors_1 , max_sectors_2);
+	}
+
+	instance->max_sectors_per_req = instance->max_num_sge *
+						PAGE_SIZE / 512;
+	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
+		instance->max_sectors_per_req = tmp_sectors;
 
 	kfree(ctrl_info);
 
diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 02:01:52.687143648 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 02:21:17.349088120 -0500
@@ -571,7 +571,7 @@ struct megasas_ctrl_info {
 #define IS_DMA64				(sizeof(dma_addr_t) == 8)
 
 #define MFI_OB_INTR_STATUS_MASK			0x00000002
-#define MFI_POLL_TIMEOUT_SECS			10
+#define MFI_POLL_TIMEOUT_SECS			60
 
 #define MFI_REPLY_1078_MESSAGE_INTERRUPT	0x80000000
 

