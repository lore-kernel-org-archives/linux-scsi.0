Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5601C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 20:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344143AbiBJULy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 15:11:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238091AbiBJULx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 15:11:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724A22735
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 12:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644523913; x=1676059913;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VcXqnaIprzfiLaLU8ODnuzBX5A/fp8FLhJ5hqPFltm4=;
  b=qzT3y5nJkKNUzAuvmJzvx3O5nsU5OhYbQ7GGXZdUJdSFU9O8oqHbtlZB
   uL6QGvqbaALnVRlemGxsiK1pWnac1m3tRMpEkcYLGNn0iZNTlnTItQdDc
   fI+s5JySHjuR51cqWcBe4D3KQKu5bbdEZpbz/zp9CanXHnQzBKFiTvrCQ
   Ti+nYKFyo50IpUFgPOYnX5QqUxEH5zLVh+fkr93oF7D3XEjHf5FORdhSb
   XkQoxzQ5WkhAUVQECAlSWw/ugGDj9Ejzoe1PDrUy6pNGylmGnMQypAFCh
   xFEl/2tTSWddpOopJ1TJTQy1MUVV/2IYPewleraBST/CxNhhxdA7U0CGL
   A==;
IronPort-SDR: 3BEnI9DPj+d6Szg49Gd0LXegFrAl77iSnalkgPm0BPH94X0Yrr6nbWEQ4FO+gvxaaK7cOrFY04
 /AmHg7viIdojsVjXcHKKJvf93xUOHm45O6tuFCLPnLrSA0e9s5rSgtmBidfnMBkPFuHhQP7qlP
 71rF+myD0Mg8hG6KXU/2B5TS6R8eb/y/UM0KzlxA9rd6ovbmicZK29ruRx+KnnvE6++hVTaUyS
 bdl7aArdq4m4U04bv0m/J8chRwDpWNi3r8Wn4DOuvxMnN6EtUpPX2GOmbv6d0/wNp+RSxiMXPB
 fVIYT6cUaaK0WscjE0CCQW1y
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="85343768"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2022 13:11:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 10 Feb 2022 13:11:52 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 10 Feb 2022 13:11:52 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id E135270240E; Thu, 10 Feb 2022 14:11:51 -0600 (CST)
From:   Don Brace <don.brace@microchip.com>
To:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>
Subject: [PATCH] smartpqi: fix unused variable pqi_pm_ops for clang
Date:   Thu, 10 Feb 2022 14:11:51 -0600
Message-ID: <20220210201151.236170-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver added a new dev_pm_ops structure used only if CONFIG_PM is set.
The CONFIG_PM MACRO needed to be moved up in the code to avoid the
compiler warnings. The HUNK to move the location was missing from
the above patch.

Found by kernel test robot by building driver with
CONFIG_PM disabled.

Link: https://lore.kernel.org/all/202202090657.bstNLuce-lkp@intel.com/

Correct compiler warning
>> drivers/scsi/smartpqi/smartpqi_init.c:9067:32:
   warning: unused variable 'pqi_pm_ops' [-Wunused-const-variable]
   static const struct dev_pm_ops pqi_pm_ops = {
                                  ^
   1 warning generated.

Fixes: c66e078ad89e ("scsi: smartpqi: Fix hibernate and suspend)"
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike Mcgowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 61366642ea95..4611912ae261 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8951,6 +8951,8 @@ static void pqi_process_module_params(void)
 	pqi_process_lockup_action_param();
 }
 
+#if defined(CONFIG_PM)
+
 static inline enum bmic_flush_cache_shutdown_event pqi_get_flush_cache_shutdown_event(struct pci_dev *pci_dev)
 {
 	if (pci_dev->subsystem_vendor == PCI_VENDOR_ID_ADAPTEC2 && pci_dev->subsystem_device == 0x1304)
@@ -9073,6 +9075,8 @@ static const struct dev_pm_ops pqi_pm_ops = {
 	.restore = pqi_resume_or_restore,
 };
 
+#endif /* CONFIG_PM */
+
 /* Define the PCI IDs for the controllers that we support. */
 static const struct pci_device_id pqi_pci_id_table[] = {
 	{
-- 
2.28.0.rc1.9.ge7ae437ac1

