From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 3/3] ipr: Avoid target_destroy accessing memory after it was freed
Date: Thu, 14 Mar 2013 13:52:25 -0500
Message-ID: <20130314185803.484999352@linux.vnet.ibm.com>
References: <20130314185222.994529433@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:45372 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751723Ab3CNTAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Mar 2013 15:00:32 -0400
Content-Disposition: inline; filename=define_ids_as_long
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Defined target_ids,array_ids and vsets_ids as unsigned long to avoid
target_destroy accessing memory after it was freed. 


Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   16 ----------------
 drivers/scsi/ipr.h |    6 +++---
 2 files changed, 3 insertions(+), 19 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-03-14 13:16:03.398966326 -0500
+++ b/drivers/scsi/ipr.c	2013-03-14 13:17:04.828022126 -0500
@@ -8972,19 +8972,6 @@ static int ipr_alloc_mem(struct ipr_ioa_
 	if (!ioa_cfg->res_entries)
 		goto out;
 
-	if (ioa_cfg->sis64) {
-		ioa_cfg->target_ids = kzalloc(sizeof(unsigned long) *
-					      BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
-		ioa_cfg->array_ids = kzalloc(sizeof(unsigned long) *
-					     BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
-		ioa_cfg->vset_ids = kzalloc(sizeof(unsigned long) *
-					    BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
-
-		if (!ioa_cfg->target_ids || !ioa_cfg->array_ids
-			|| !ioa_cfg->vset_ids)
-			goto out_free_res_entries;
-	}
-
 	for (i = 0; i < ioa_cfg->max_devs_supported; i++) {
 		list_add_tail(&ioa_cfg->res_entries[i].queue, &ioa_cfg->free_res_q);
 		ioa_cfg->res_entries[i].ioa_cfg = ioa_cfg;
@@ -9081,9 +9068,6 @@ out_free_vpd_cbs:
 			    ioa_cfg->vpd_cbs, ioa_cfg->vpd_cbs_dma);
 out_free_res_entries:
 	kfree(ioa_cfg->res_entries);
-	kfree(ioa_cfg->target_ids);
-	kfree(ioa_cfg->array_ids);
-	kfree(ioa_cfg->vset_ids);
 	goto out;
 }
 
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2013-03-14 11:49:21.408965542 -0500
+++ b/drivers/scsi/ipr.h	2013-03-14 13:16:20.131452448 -0500
@@ -1440,9 +1440,9 @@ struct ipr_ioa_cfg {
 	/*
 	 * Bitmaps for SIS64 generated target values
 	 */
-	unsigned long *target_ids;
-	unsigned long *array_ids;
-	unsigned long *vset_ids;
+	unsigned long target_ids[BITS_TO_LONGS(IPR_MAX_SIS64_DEVS)];
+	unsigned long array_ids[BITS_TO_LONGS(IPR_MAX_SIS64_DEVS)];
+	unsigned long vset_ids[BITS_TO_LONGS(IPR_MAX_SIS64_DEVS)];
 
 	u16 type; /* CCIN of the card */
 

-- 
