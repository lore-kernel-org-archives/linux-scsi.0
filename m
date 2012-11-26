From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 2/7] ipr: Handler ID memory allocation failure
Date: Mon, 26 Nov 2012 09:55:36 -0600
Message-ID: <20121126155632.125112047@linux.vnet.ibm.com>
References: <20121126155534.352187900@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:5609 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754382Ab2KZQGj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:39 -0500
Content-Disposition: inline; filename=fix_mem_alloc_fail
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com

Add code to handle memory allocation failures at module load time.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
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
