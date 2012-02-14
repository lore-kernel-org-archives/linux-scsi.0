From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] mpt2sas: add missing allocation check
Date: Tue, 14 Feb 2012 09:34:22 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E49FC5B@inbmail02.lsi.com>
References: <4F394896.70805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:42724 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500Ab2BNEEa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 23:04:30 -0500
In-Reply-To: <4F394896.70805@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Stanislaw Gruszka <sgruszka@redhat.com>

This patch seem to be fine. Please consider this patch as Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

Regards,
Nagalakshmi


-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Monday, February 13, 2012 11:00 PM
To: 'linux-scsi@vger.kernel.org'
Cc: Desai, Kashyap; Nandigama, Nagalakshmi; Stanislaw Gruszka
Subject: [PATCH] mpt2sas: add missing allocation check

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


