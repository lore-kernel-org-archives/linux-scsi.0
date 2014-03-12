From: wenxiong@vmlinux.vnet.ibm.com
Subject: [PATCH RESEND 4/7] ipr: Get rid of superfluous call to pci_disbale_msi/msix()
Date: Wed, 12 Mar 2014 16:08:49 -0500
Message-ID: <20140312210906.288887472@vmlinux.vnet.ibm.com>
References: <20140312210845.384489953@vmlinux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:60422 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752731AbaCLVMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2014 17:12:10 -0400
Content-Disposition: inline; filename=001_msix
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, bjking1@us.ibm.com, Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@linux.vnet.ibm.com>

From: Alexander Gordeev <agordeev@redhat.com>

There is no need to call pci_disable_msi() or pci_disable_msix()
in case the call to pci_enable_msi() or pci_enable_msix() failed.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2014-03-11 17:16:08.849955755 -0500
+++ b/drivers/scsi/ipr.c	2014-03-11 17:18:06.709957199 -0500
@@ -9329,7 +9329,6 @@ static int ipr_enable_msix(struct ipr_io
 
 	if (err < 0) {
 		ipr_wait_for_pci_err_recovery(ioa_cfg);
-		pci_disable_msix(ioa_cfg->pdev);
 		return err;
 	}
 
@@ -9353,7 +9352,6 @@ static int ipr_enable_msi(struct ipr_ioa
 
 	if (err < 0) {
 		ipr_wait_for_pci_err_recovery(ioa_cfg);
-		pci_disable_msi(ioa_cfg->pdev);
 		return err;
 	}
 

-- 
