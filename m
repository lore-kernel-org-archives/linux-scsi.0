From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2 20/30] cxlflash: Correct usage of scsi_host_put()
Date: Wed, 16 Sep 2015 16:30:49 -0500
Message-ID: <1442439049-49970-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:53060 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbbIPVcO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 17:32:14 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 16 Sep 2015 17:32:13 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 79693C9003C
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 17:23:13 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8GLW17h64946376
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 21:32:09 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8GLVaeO011117
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 17:31:37 -0400
In-Reply-To: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Currently, scsi_host_put() is being called prematurely in the
remove path and is missing entirely in an error cleanup path.
The former can lead to memory being freed too early with
subsequent access potentially corrupting data whilst the former
would result in a memory leak.

Move the usage on remove to be the last cleanup action taken
and introduce a call to scsi_host_put() in the one initialization
error path that does not use remove to cleanup.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index fc77cd4..1856a73 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -734,7 +734,6 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	case INIT_STATE_SCSI:
 		cxlflash_term_local_luns(cfg);
 		scsi_remove_host(cfg->host);
-		scsi_host_put(cfg->host);
 		/* Fall through */
 	case INIT_STATE_AFU:
 		term_afu(cfg);
@@ -744,6 +743,7 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	case INIT_STATE_NONE:
 		flush_work(&cfg->work_q);
 		free_mem(cfg);
+		scsi_host_put(cfg->host);
 		break;
 	}
 
@@ -2415,6 +2415,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "%s: call to scsi_host_alloc failed!\n",
 			__func__);
 		rc = -ENOMEM;
+		scsi_host_put(cfg->host);
 		goto out;
 	}
 
-- 
2.1.0

