From: brking@us.ibm.com
Subject: [PATCH 11/26] ipr: Convert to use kzalloc
Date: Tue, 01 Nov 2005 17:01:20 -0600
Message-ID: <200511012301.jA1N1LlG023290@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:3565 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751407AbVKAXBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:01:23 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N1M6S029877
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:22 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N1Mbn117090
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:22 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N1Lnb023323
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Convert appropriate kmalloc/memset calls to use kzalloc.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_kzalloc drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_kzalloc	2005-10-31 21:53:09.960274168 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:53:10.014265960 -0600
@@ -2248,7 +2248,7 @@ static struct ipr_sglist *ipr_alloc_ucod
 		num_elem = buf_len / bsize_elem;
 
 	/* Allocate a scatter/gather list for the DMA */
-	sglist = kmalloc(sizeof(struct ipr_sglist) +
+	sglist = kzalloc(sizeof(struct ipr_sglist) +
 			 (sizeof(struct scatterlist) * (num_elem - 1)),
 			 GFP_KERNEL);
 
@@ -2257,9 +2257,6 @@ static struct ipr_sglist *ipr_alloc_ucod
 		return NULL;
 	}
 
-	memset(sglist, 0, sizeof(struct ipr_sglist) +
-	       (sizeof(struct scatterlist) * (num_elem - 1)));
-
 	scatterlist = sglist->scatterlist;
 
 	sglist->order = order;
@@ -2614,14 +2611,13 @@ static int ipr_alloc_dump(struct ipr_ioa
 	unsigned long lock_flags = 0;
 
 	ENTER;
-	dump = kmalloc(sizeof(struct ipr_dump), GFP_KERNEL);
+	dump = kzalloc(sizeof(struct ipr_dump), GFP_KERNEL);
 
 	if (!dump) {
 		ipr_err("Dump memory allocation failed\n");
 		return -ENOMEM;
 	}
 
-	memset(dump, 0, sizeof(struct ipr_dump));
 	kref_init(&dump->kref);
 	dump->ioa_cfg = ioa_cfg;
 
@@ -5665,15 +5661,12 @@ static int __devinit ipr_alloc_mem(struc
 	int i, rc = -ENOMEM;
 
 	ENTER;
-	ioa_cfg->res_entries = kmalloc(sizeof(struct ipr_resource_entry) *
+	ioa_cfg->res_entries = kzalloc(sizeof(struct ipr_resource_entry) *
 				       IPR_MAX_PHYSICAL_DEVS, GFP_KERNEL);
 
 	if (!ioa_cfg->res_entries)
 		goto out;
 
-	memset(ioa_cfg->res_entries, 0,
-	       sizeof(struct ipr_resource_entry) * IPR_MAX_PHYSICAL_DEVS);
-
 	for (i = 0; i < IPR_MAX_PHYSICAL_DEVS; i++)
 		list_add_tail(&ioa_cfg->res_entries[i].queue, &ioa_cfg->free_res_q);
 
@@ -5714,15 +5707,12 @@ static int __devinit ipr_alloc_mem(struc
 		list_add_tail(&ioa_cfg->hostrcb[i]->queue, &ioa_cfg->hostrcb_free_q);
 	}
 
-	ioa_cfg->trace = kmalloc(sizeof(struct ipr_trace_entry) *
+	ioa_cfg->trace = kzalloc(sizeof(struct ipr_trace_entry) *
 				 IPR_NUM_TRACE_ENTRIES, GFP_KERNEL);
 
 	if (!ioa_cfg->trace)
 		goto out_free_hostrcb_dma;
 
-	memset(ioa_cfg->trace, 0,
-	       sizeof(struct ipr_trace_entry) * IPR_NUM_TRACE_ENTRIES);
-
 	rc = 0;
 out:
 	LEAVE;
_
