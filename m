From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/4] qla4xxx: Assign correct CHAP table address to FLT
Date: Fri, 22 Mar 2013 07:08:32 -0400
Message-ID: <1363950514-15483-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1363950514-15483-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:52633 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932790Ab3CVLbQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Mar 2013 07:31:16 -0400
In-Reply-To: <1363950514-15483-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Issue:
If flash read for FLT fails, we are assigning wrong default
address for CHAP table in FLT, which will cause CHAP table
read/write to wrong address.

Fix:
Assign correct default CHAP table address to FLT.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 71d3d23..31fac90 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3166,14 +3166,15 @@ no_flash_data:
 	hw->flt_region_boot     = FA_BOOT_CODE_ADDR_82;
 	hw->flt_region_bootload = FA_BOOT_LOAD_ADDR_82;
 	hw->flt_region_fw       = FA_RISC_CODE_ADDR_82;
-	hw->flt_region_chap	= FA_FLASH_ISCSI_CHAP;
+	hw->flt_region_chap	= FA_FLASH_ISCSI_CHAP >> 2;
 	hw->flt_chap_size	= FA_FLASH_CHAP_SIZE;
 
 done:
-	DEBUG2(ql4_printk(KERN_INFO, ha, "FLT[%s]: flt=0x%x fdt=0x%x "
-	    "boot=0x%x bootload=0x%x fw=0x%x\n", loc, hw->flt_region_flt,
-	    hw->flt_region_fdt,	hw->flt_region_boot, hw->flt_region_bootload,
-	    hw->flt_region_fw));
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "FLT[%s]: flt=0x%x fdt=0x%x boot=0x%x bootload=0x%x fw=0x%x chap=0x%x\n",
+			  loc, hw->flt_region_flt, hw->flt_region_fdt,
+			  hw->flt_region_boot, hw->flt_region_bootload,
+			  hw->flt_region_fw, hw->flt_region_chap));
 }
 
 static void
-- 
1.8.2.GIT

