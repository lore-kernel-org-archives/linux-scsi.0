Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3EBC77B60
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346039AbjD1Phv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345994AbjD1Php (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:37:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F405B93
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696242; x=1714232242;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOqsnKPY5t8QCmytK36IEZvWxmRVOXlnGKnoT22bIZY=;
  b=Va7S9dBqgWo7miQm/9ztz+RCtkskfeh3+QgH5tbHYJPf6HFqZc1RPZUI
   8AAb41TkCcgZe+LhTYzdwHE9AGs4myxJDMmZcz8l3NXpF3osCGdCKB7JZ
   Itx6dlnJOHA5HPXt+AapMt0Qt8B7arTquIYsDN2AwzfWJxExsQg5gYgue
   hmdXUaVS8uM9D8dLyqZgBB8O1boA72OuL0q9Piblg4a7eLQmNlTmGxUw9
   6B6Ue5YSADVkGXIqldITWviOaGf8KaPJF4wLrhf3F5m+nlZOnJbVl5gYA
   u6bAcDlZUNCJCXLxSPCpLAykIZMdawX0z7Uw19weItNHvKUy+UJd8uSs0
   g==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="211156466"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:36:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:36:56 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:36:55 -0700
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
Subject: [PATCH 01/12] smartpqi: map full length of PCI BAR 0
Date:   Fri, 28 Apr 2023 10:37:01 -0500
Message-ID: <20230428153712.297638-2-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <mike.mcgowen@microchip.com>

Map full length of PCI BAR 0 at driver init.

During driver initialization, the driver must make a kernel call
to map the controller registers into kernel address space.
A parameter to this call is the length of the memory to be mapped.
The driver is specifying the wrong length.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 03de97cd72c2..29370757b07b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8560,7 +8560,7 @@ static int pqi_pci_init(struct pqi_ctrl_info *ctrl_info)
 
 	ctrl_info->iomem_base = ioremap(pci_resource_start(
 		ctrl_info->pci_dev, 0),
-		sizeof(struct pqi_ctrl_registers));
+		pci_resource_len(ctrl_info->pci_dev, 0));
 	if (!ctrl_info->iomem_base) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"failed to map memory for controller registers\n");
-- 
2.40.1.375.g9ce9dea4e1

