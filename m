Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0C9C0015E
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 09:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjGJJwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 05:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjGJJvl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 05:51:41 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CA4E67;
        Mon, 10 Jul 2023 02:48:17 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 36A9m7kg130589;
        Mon, 10 Jul 2023 04:48:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1688982487;
        bh=zDGEcLXLb/jmYr7sBksF2Y6lvpdbjUzDyNzFNGroX/E=;
        h=From:To:CC:Subject:Date;
        b=p7ciZghwzHQV6xLzL1+gEy1v+I9ls09Gm4XGfy87ar69VRNFInXEK6V767x6iahVF
         p/rHc8bq/uG9IibxUgF0VAAmgxPHJy1tRRjRsAMn8PVJOZo6vSxcCQK2/grhOZ9k55
         ym9ISs4VqO51lo5CFOXzWp0cEqebZfRA506zC+NA=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 36A9m7Di121026
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Jul 2023 04:48:07 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 10
 Jul 2023 04:48:07 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 10 Jul 2023 04:48:07 -0500
Received: from udit-HP-Z2-Tower-G9-Workstation-Desktop-PC.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 36A9m4rW013958;
        Mon, 10 Jul 2023 04:48:05 -0500
From:   Udit Kumar <u-kumar1@ti.com>
To:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <=martin.petersen@oracle.com>, <jejb@linux.ibm.com>, <nm@ti.com>,
        <vigneshr@ti.com>
CC:     Udit Kumar <u-kumar1@ti.com>
Subject: [PATCH] scsi: ufs: TI UFS host controller expose device tree aliases
Date:   Mon, 10 Jul 2023 15:18:01 +0530
Message-ID: <20230710094801.183149-1-u-kumar1@ti.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When TI UFS host controller driver is built as kernel module,
It was not getting auto loaded due to missing aliases in modules.

This patch adds device tree related aliases.

Signed-off-by: Udit Kumar <u-kumar1@ti.com>
---
 drivers/ufs/host/ti-j721e-ufs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/host/ti-j721e-ufs.c b/drivers/ufs/host/ti-j721e-ufs.c
index 122d650d0810..117eb7da92ac 100644
--- a/drivers/ufs/host/ti-j721e-ufs.c
+++ b/drivers/ufs/host/ti-j721e-ufs.c
@@ -81,6 +81,8 @@ static const struct of_device_id ti_j721e_ufs_of_match[] = {
 	{ },
 };
 
+MODULE_DEVICE_TABLE(of, ti_j721e_ufs_of_match);
+
 static struct platform_driver ti_j721e_ufs_driver = {
 	.probe	= ti_j721e_ufs_probe,
 	.remove	= ti_j721e_ufs_remove,
-- 
2.34.1

