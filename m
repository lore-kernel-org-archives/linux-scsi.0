Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49597C27C7A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 13:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351050AbjHQNMt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351421AbjHQNMp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 09:12:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C7B3A87
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 06:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692277937; x=1723813937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JUkatfIgX+owCMGNvN9+UKRJen/QKAB9K1lXUmS+wA4=;
  b=nK1o1KskD6IPM/7pL3BeD+bdZX957b4ZQpEK055wc85PwZJc2OSzgCQb
   CTC7aJ2NLRL60aIvfZVgGaofO1dPkWZA+6fS9OMwqykUa6ucx2eyvkSFN
   T9TixPswbeUSfLxILQy6Im57nil/lORK/yayh1rfe+/RiFj3KCD3aExD3
   2s6yNLZex1m0/5/qh8mKuL+hwf9jc6ZY25a6JCGvVFKtOoKdNQKC5NNVx
   feYicCpSnxv21uCdsVcwxwxY34Ae2fv/xHbsNirxzhxpJOwx8cNulkbLn
   uRkVU0r8wRkWTHg+OpC9/mESsfiupDiQ0hdSeoZyCMht6ilspcW//Z3eP
   g==;
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="166911784"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2023 06:11:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 17 Aug 2023 06:11:00 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 17 Aug 2023 06:10:59 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 4/9] smartpqi: refactor rename pciinfo to pci_info
Date:   Thu, 17 Aug 2023 08:12:27 -0500
Message-ID: <20230817131232.86754-5-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0.rc2
In-Reply-To: <20230817131232.86754-1-don.brace@microchip.com>
References: <20230817131232.86754-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Make pci device structure names consistent and readable.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2d695e7cd83f..dedc721b007b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6332,21 +6332,21 @@ static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *ar
 	struct pci_dev *pci_dev;
 	u32 subsystem_vendor;
 	u32 subsystem_device;
-	cciss_pci_info_struct pciinfo;
+	cciss_pci_info_struct pci_info;
 
 	if (!arg)
 		return -EINVAL;
 
 	pci_dev = ctrl_info->pci_dev;
 
-	pciinfo.domain = pci_domain_nr(pci_dev->bus);
-	pciinfo.bus = pci_dev->bus->number;
-	pciinfo.dev_fn = pci_dev->devfn;
+	pci_info.domain = pci_domain_nr(pci_dev->bus);
+	pci_info.bus = pci_dev->bus->number;
+	pci_info.dev_fn = pci_dev->devfn;
 	subsystem_vendor = pci_dev->subsystem_vendor;
 	subsystem_device = pci_dev->subsystem_device;
-	pciinfo.board_id = ((subsystem_device << 16) & 0xffff0000) | subsystem_vendor;
+	pci_info.board_id = ((subsystem_device << 16) & 0xffff0000) | subsystem_vendor;
 
-	if (copy_to_user(arg, &pciinfo, sizeof(pciinfo)))
+	if (copy_to_user(arg, &pci_info, sizeof(pci_info)))
 		return -EFAULT;
 
 	return 0;
-- 
2.42.0.rc2

