From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 20/29] cxlflash: Correct usage of scsi_host_put()
Date: Fri, 11 Sep 2015 16:17:25 -0500
Message-ID: <1442006245-47194-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:51455 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbbIKVSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:18:39 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:18:39 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 8B1DA1FF0054
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:09:46 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLHeiS47644752
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 14:17:48 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLI3KF025369
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:18:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Currently, scsi_host_put() is being called prematurely in the
remove path and is missing entirely in an error cleanup path.
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

