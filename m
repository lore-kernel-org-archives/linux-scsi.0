Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86131C3DA6F
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 15:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242192AbjHXP4Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 11:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242222AbjHXP4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 11:56:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A03198E
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692892579; x=1724428579;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bh/Rukq3v4u0SELexpCc3NWrQkV8bCvziQKKl3gyfm8=;
  b=UonAR5brOIIbpaAd5bBqWoa6I5VSqTKXNlezdz5OQoJwsYJEEAKxCeOz
   e3KirmBHox0kCegSkPzxm6HH6aHicljfH6TvFar1PA3fZpGpcltwALaoW
   czBE+cgTy+I85RDQ5/KXjrdv9HtTuxyKZU2Iy8HCQn6ovwagIJGQwiowU
   dNXsHclv/61ndnS19ROMOpwkhmDwhmxudzylHfYCTapojE0b14BuAA/zY
   IsGut7L/CyImxojk1Fy+m3hryOEZMo+23bMpVNknEGLi/AYd20oEWPecm
   jBSOxs/IK/GmyLyCHoOejzngkkU2ENVcGucLTBKH9vaUTDLmyEdpn9ne2
   Q==;
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="1114056"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2023 08:56:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 24 Aug 2023 08:56:13 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 24 Aug 2023 08:56:13 -0700
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
Subject: [PATCH v2 3/8] smartpqi: refactor rename pciinfo to pci_info
Date:   Thu, 24 Aug 2023 10:58:07 -0500
Message-ID: <20230824155812.789913-4-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824155812.789913-1-don.brace@microchip.com>
References: <20230824155812.789913-1-don.brace@microchip.com>
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
index 97322ebd77cf..2ebc72270746 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6570,21 +6570,21 @@ static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *ar
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
2.42.0

