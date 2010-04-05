From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 04/05] mpt2sas: Check for NULL pointer before free_pages is added.
Date: Mon, 5 Apr 2010 14:21:07 +0530
Message-ID: <20100405085057.GE28900@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:46343 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103Ab0DEJXA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2010 05:23:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Added check before free_pages just to make sure ioc->scsi_lookup is not NULL.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 42d00dd..254557e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1916,7 +1916,10 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 		    ioc->config_page, ioc->config_page_dma);
 	}
 
-	free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pages);
+	if (ioc->scsi_lookup) {
+		free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pages);
+		ioc->scsi_lookup = NULL;
+	}
 	kfree(ioc->hpr_lookup);
 	kfree(ioc->internal_lookup);
 }
