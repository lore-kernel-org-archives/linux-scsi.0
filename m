Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D47C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 15:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C18F6600D3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 15:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhJSPiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234130AbhJSPiR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 11:38:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27CC9600D3;
        Tue, 19 Oct 2021 15:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634657764;
        bh=NzBsq2V2m7i7GEd2bbQfY/EVxbEmxKIigcuDaW2asqA=;
        h=From:To:Cc:Subject:Date:From;
        b=HG7qfJNHok6ozu/kVnyDlCo2lY04bMPt2YhqG/NLvzZ/Gs5Jbw/BUfYLSzxw/xtkG
         dFdeb6yINcamV/c0o0MFePpc8EPO9d3UINgzvsdM7iHjthbQP0OPYRmyc4eRwlHwDz
         wc6Jp+X4suL+sC7Jyo59DYwIxpELyw1ZiLzgKKMzckZ7sjg8cdY1bxudDngNtkmRaq
         QZkslu2J9g6jHtbfpzHGOmDU47Eo6dxdjnxbwoeTuUnTiA1PpwCSRI0Oh+QU2p5VHc
         fqVJ1XuK711OATIFTtfJNdejUV9K6ELm12jshUO448mbGM46XVshKmrj8qaqBES8F0
         gkHa/PlvdOpnQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: core: ufs-pci: hide unused ufshcd_pci_restore function
Date:   Tue, 19 Oct 2021 17:35:51 +0200
Message-Id: <20211019153600.380220-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_PM_SLEEP is disabled, ufshcd_pci_restore() fails
to compile but is also unused:

drivers/scsi/ufs/ufshcd-pci.c: In function 'ufshcd_pci_restore':
drivers/scsi/ufs/ufshcd-pci.c:459:16: error: implicit declaration of function 'ufshcd_system_resume'; did you mean 'ufshcd_runtime_resume'? [-Werror=implicit-function-declaration]
  459 |         return ufshcd_system_resume(dev);
      |                ^~~~~~~~~~~~~~~~~~~~
      |                ufshcd_runtime_resume
At top level:
drivers/scsi/ufs/ufshcd-pci.c:452:12: error: 'ufshcd_pci_restore' defined but not used [-Werror=unused-function]
  452 | static int ufshcd_pci_restore(struct device *dev)
      |            ^~~~~~~~~~~~~~~~~~

Enclose it within the same #ifdef as the related code.

Fixes: 21431d5bdf15 ("scsi: core: ufs-pci: Force a full restore after suspend-to-disk")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/ufs/ufshcd-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index d65e6cd7a28d..51424557810d 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -449,6 +449,7 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 	.device_reset		= ufs_intel_device_reset,
 };
 
+#ifdef CONFIG_PM_SLEEP
 static int ufshcd_pci_restore(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -458,6 +459,7 @@ static int ufshcd_pci_restore(struct device *dev)
 
 	return ufshcd_system_resume(dev);
 }
+#endif
 
 /**
  * ufshcd_pci_shutdown - main function to put the controller in reset state
-- 
2.29.2

