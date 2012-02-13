From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] mpt2sas: add missing allocation check
Date: Mon, 13 Feb 2012 18:29:58 +0100
Message-ID: <4F394896.70805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171Ab2BMRaD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 12:30:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Stanislaw Gruszka <sgruszka@redhat.com>

The __get_free_pages can fail, so the return value should be checked.
Spotted thanks to Stanislaw.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 0b2c955..590e1a1 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2575,6 +2575,11 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 
 	ioc->chain_lookup = (struct chain_tracker *)__get_free_pages(
 	    GFP_KERNEL, ioc->chain_pages);
+	if (!ioc->chain_lookup) {
+		printk(MPT2SAS_ERR_FMT "chain_lookup: get_free_pages failed, "
+		    "sz(%d)\n", ioc->name, (int)sz);
+		goto out;
+	}
 	ioc->chain_dma_pool = pci_pool_create("chain pool", ioc->pdev,
 	    ioc->request_sz, 16, 0);
 	if (!ioc->chain_dma_pool) {


