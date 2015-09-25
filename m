From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v4 31/32] cxlflash: Correct trace string
Date: Fri, 25 Sep 2015 18:19:29 -0500
Message-ID: <1443223169-10115-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:53182 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbbIYXVF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 19:21:05 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 25 Sep 2015 19:21:05 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id D904D38C803B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 19:21:03 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8PNKtfr49938486
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 23:21:03 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8PNKTAw019292
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 19:20:31 -0400
In-Reply-To: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The trace following the failure of alloc_mem() incorrectly identifies
which function failed. This can lead to misdiagnosing a failure.

Fix the string to correctly indicate that alloc_mem() failed.

Reported-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 38e7edc..e8f8c7e 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2377,7 +2377,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	cfg->host = host;
 	rc = alloc_mem(cfg);
 	if (rc) {
-		dev_err(&pdev->dev, "%s: call to scsi_host_alloc failed!\n",
+		dev_err(&pdev->dev, "%s: call to alloc_mem failed!\n",
 			__func__);
 		rc = -ENOMEM;
 		scsi_host_put(cfg->host);
-- 
2.1.0

