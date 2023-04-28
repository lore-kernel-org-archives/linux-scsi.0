Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C747FC77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346266AbjD1Pio (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346272AbjD1PiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:38:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E36F619A
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696271; x=1714232271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S3RLns29LbZK9cmrtwQJayEBhDAgfGjVxrb0DjUpTOg=;
  b=kydMnjJTHq204tZGPrQNYZ39EB4S0UX7wYnESOwc+sRlDywBCLc+dZcK
   9oEzCWS0KwSlSlgL5xE5acEVahmRlHArPiUbt11kd9E0aXA+BwhiQvlWf
   65YYMXLb0mUNQpb7yjT054ukT63XLNMbSDNyHB3OZKNC1sJ0T3tfb7zKZ
   G/jIPC5IENFZ4C8bLzru/0lWz4ZMbIbq643MeqbjdSazaTDqHwJa01YLl
   xU+KS7fTu7isCpabqCEcoofc+LV/D+zC1cBXmQg/DuKLVkln/O1InmdkO
   zafN7giJ6eNb5Tt8E3eWCirBK7TO9cUiihZyscCiJEL9SEXhognfd1zos
   w==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="208806430"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:37:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:37:04 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:37:03 -0700
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
Subject: [PATCH 08/12] smartpqi: fix byte aligned writew for ARM servers
Date:   Fri, 28 Apr 2023 10:37:08 -0500
Message-ID: <20230428153712.297638-9-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Correct OOPs on ARM servers during driver init.

Driver attempts to update FW with max_feature_supported value
using a writew() kernel call using a byte aligned address.

This fails on some ARM systems.

Change the writew() to two writeb() calls to update
this value.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 19a97bbf89b5..d3d4fc90dcae 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7718,8 +7718,8 @@ static int pqi_enable_firmware_features(struct pqi_ctrl_info *ctrl_info,
 			features_requested_iomem_addr +
 			(le16_to_cpu(firmware_features->num_elements) * 2) +
 			sizeof(__le16);
-		writew(PQI_FIRMWARE_FEATURE_MAXIMUM,
-			host_max_known_feature_iomem_addr);
+		writeb(PQI_FIRMWARE_FEATURE_MAXIMUM & 0xFF, host_max_known_feature_iomem_addr);
+		writeb((PQI_FIRMWARE_FEATURE_MAXIMUM & 0xFF00) >> 8, host_max_known_feature_iomem_addr + 1);
 	}
 
 	return pqi_config_table_update(ctrl_info,
-- 
2.40.1.375.g9ce9dea4e1

