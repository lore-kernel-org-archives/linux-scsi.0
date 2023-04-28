Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03DBC77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346465AbjD1Pic (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346442AbjD1PiH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:38:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148105BAC
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696270; x=1714232270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xJ/HmM//w8pSvzUIsHagQhBijwjjuliLKI69jp4nrS8=;
  b=f1FnoWBBk0dDjwZxqsgMH9Pk/UzJeeWVt0EMLLw58xg+hSpQI3bW2OHs
   z9wuw+yXD/CQpFY9MadIweT+MpgnaiSj6Mc7FXPLAPtSeWE5oLeZOAkQ8
   pJFhKs7dXKZSsHUrnyRknBNUPxcw3qVnkbna731cigJ+wypl82Gu0UHQl
   9zFCDvubXzn0LIDS6MghPaxuoAp9lhW6UADtlXjzpJsZLEZgBG1Cf85He
   QOwjmvQT2lrxfZU9WxrU+3lyVxui3GEWJ4Sy/nbuBiqzoLtQXazZAREWO
   c5N81vqxTwiqtH4+4xuHXYeZJoKMc4OodPIag/P+aSAmWkZhb0VzPn0Ct
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="211156473"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:37:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:36:59 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:36:59 -0700
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
Subject: [PATCH 04/12] smartpqi: fix-rare-sas-transport-mem-leak
Date:   Fri, 28 Apr 2023 10:37:04 -0500
Message-ID: <20230428153712.297638-5-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Free rphy when pqi_sas_port_add_rphy() returns an error.

If pqi_sas_port_add_rphy() returns an error, the 'rphy' allocated
in sas_end_device_alloc() needs to be freed.

It should be noted that no issues were ever reported.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Suggested-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_sas_transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 52dbe37364bf..36b90b55cf5f 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -293,10 +293,12 @@ int pqi_add_sas_device(struct pqi_sas_node *pqi_sas_node,
 
 	rc = pqi_sas_port_add_rphy(pqi_sas_port, rphy);
 	if (rc)
-		goto free_sas_port;
+		goto free_sas_rphy;
 
 	return 0;
 
+free_sas_rphy:
+	sas_rphy_free(rphy);
 free_sas_port:
 	pqi_free_sas_port(pqi_sas_port);
 	device->sas_port = NULL;
-- 
2.40.1.375.g9ce9dea4e1

