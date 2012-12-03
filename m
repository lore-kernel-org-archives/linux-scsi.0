From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 2/7] RESEND ipr: Handler ID memory allocation failure
Date: Mon, 03 Dec 2012 12:31:14 -0600
Message-ID: <20121203183211.906863907@linux.vnet.ibm.com>
References: <20121203183112.822371464@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:28934 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750904Ab2LCSe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 13:34:27 -0500
Content-Disposition: inline; filename=fix_mem_alloc_fail
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

From: Brian King <brking@linux.vnet.ibm.com>

Add code to handle memory allocation failures at module load time.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2012-11-14 23:07:30.067656109 -0600
+++ b/drivers/scsi/ipr.c	2012-11-14 23:09:49.484214019 -0600
@@ -8516,6 +8516,10 @@ static int __devinit ipr_alloc_mem(struc
 					     BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
 		ioa_cfg->vset_ids = kzalloc(sizeof(unsigned long) *
 					    BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
+
+		if (!ioa_cfg->target_ids || !ioa_cfg->array_ids
+			|| !ioa_cfg->vset_ids)
+			goto out_free_res_entries;
 	}
 
 	for (i = 0; i < ioa_cfg->max_devs_supported; i++) {
@@ -8591,6 +8595,9 @@ out_free_vpd_cbs:
 			    ioa_cfg->vpd_cbs, ioa_cfg->vpd_cbs_dma);
 out_free_res_entries:
 	kfree(ioa_cfg->res_entries);
+	kfree(ioa_cfg->target_ids);
+	kfree(ioa_cfg->array_ids);
+	kfree(ioa_cfg->vset_ids);
 	goto out;
 }
 

-- 
