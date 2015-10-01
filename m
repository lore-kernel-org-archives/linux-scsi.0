From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v5 20/34] cxlflash: Fix to prevent workq from accessing freed memory
Date: Thu,  1 Oct 2015 10:57:10 -0500
Message-ID: <1443715030-18438-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:48415 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbbJAP6S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 11:58:18 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 1 Oct 2015 09:58:18 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 7E8611FF0043
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2015 09:46:28 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t91Fv1sa1114510
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2015 08:57:01 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t91FwELd001976
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2015 09:58:16 -0600
In-Reply-To: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The workq can process work in parallel with a remove event, leading
to a condition where the workq handler can access freed memory.

To remedy, the workq should be terminated prior to freeing memory. Move
the termination call earlier in remove and use cancel_work_sync() instead
of flush_work() as there is not a need to process any scheduled work when
shutting down.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 6b8b159..d0b9972 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -736,11 +736,11 @@ static void cxlflash_remove(struct pci_dev *pdev)
 		/* Fall through */
 	case INIT_STATE_AFU:
 		term_afu(cfg);
+		cancel_work_sync(&cfg->work_q);
 	case INIT_STATE_PCI:
 		pci_release_regions(cfg->dev);
 		pci_disable_device(pdev);
 	case INIT_STATE_NONE:
-		flush_work(&cfg->work_q);
 		free_mem(cfg);
 		scsi_host_put(cfg->host);
 		break;
-- 
2.1.0

