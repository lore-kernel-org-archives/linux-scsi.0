From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v3 19/32] cxlflash: Correct usage of scsi_host_put()
Date: Thu, 24 Sep 2015 14:40:19 -0500
Message-ID: <1443123619-17347-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:53887 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbbIXTl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2015 15:41:59 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 24 Sep 2015 13:41:59 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id D901F3E40041
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 13:41:56 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8OJchFS66650290
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 12:38:51 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8OJfL3t001797
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 13:41:24 -0600
In-Reply-To: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
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
index b6a2584..0bb6629 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -733,7 +733,6 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	case INIT_STATE_SCSI:
 		cxlflash_term_local_luns(cfg);
 		scsi_remove_host(cfg->host);
-		scsi_host_put(cfg->host);
 		/* Fall through */
 	case INIT_STATE_AFU:
 		term_afu(cfg);
@@ -743,6 +742,7 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	case INIT_STATE_NONE:
 		flush_work(&cfg->work_q);
 		free_mem(cfg);
+		scsi_host_put(cfg->host);
 		break;
 	}
 
@@ -2404,6 +2404,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "%s: call to scsi_host_alloc failed!\n",
 			__func__);
 		rc = -ENOMEM;
+		scsi_host_put(cfg->host);
 		goto out;
 	}
 
-- 
2.1.0

