Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66942C07E9C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C45D613C3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbhGNSbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:47 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:34842 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240016AbhGNSbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287328; x=1657823328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A12LawP3oulzMcsMcOVjEE4RtDeE3oxjrT+YdNBnJlM=;
  b=d//LhpRsqwyarJ5npGwjGDVeFOUyAnpArvgTobB1tWvAPHfDEFnmcdld
   kVg2SdCArnDjYW6JjtqJv+6jhm1aqI55K98H7x7dL+zEOkcghRpd0X6dq
   HeUdS1d5ocIDpCi5IIKZpHzrscTtPTwcQeeTBaicjTszE25toyKqqeGGU
   VNCZX5Lfv1NrLSo9CUrnn8vUgB5k6pG4Y8WnzUjx9MJq2Jqcmp5j5jEmU
   YHc+mcZaSdONXWPZLw/GGHRihJ3OjTmDUyNIlDA/xti9S90vedHMw2g4h
   TGFCf8h0nMTHCzE4tBXGD/nDEkp1AgVt/12KaiB84CGd5mLANm422W2J0
   w==;
IronPort-SDR: rXLpnLRoaJ2ct6fhaUO/WCzh0HngpBXrCMUJw2Or4XaTebaBJQ76RUv4b1vcy/ozEbkTbUmFO2
 vElFU1GNEMObDrTxUhJrltIQDyolkZRWJKw8wVy1kRel+VzieRRZRz7UlGlx+7sWc1Qi/UJSR1
 K1iWqMcsHe7DO4wiulWlTkc/g75F1dGX/BFQnNiUMUj2zuidwY5FjSLI9kam6+0pgi3HV/L/7x
 FMgXuq8MJSk1mlnVrFvMR7eHsDcODpCAl7XuCDMHSC0M7ouZY0+X4k9yVWR7qIoWZh9FRjW/zg
 e70=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="122053850"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2021 11:28:48 -0700
Received: from AVMBX2.microsemi.net (10.10.46.68) by AVMBX2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 11:28:47 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Jul 2021 11:28:47 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 46A8B703451; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates V3 PATCH 5/9] smartpqi: add SCSI cmd info for resets
Date:   Wed, 14 Jul 2021 13:28:43 -0500
Message-ID: <20210714182847.50360-6-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Report on SCSI command that has triggered the reset.
 - Also add check for NULL SCSI commands resulting from
   issuing sg_reset when there is no outstanding commands.

   Example:
   sg_reset -d /dev/sgXY
   smartpqi 0000:39:00.0: resetting scsi 4:0:1:0 due to cmd 0x12

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 29382b290243..ffc7ca221e27 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6033,8 +6033,10 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 
 	dev_err(&ctrl_info->pci_dev->dev,
-		"resetting scsi %d:%d:%d:%d\n",
-		shost->host_no, device->bus, device->target, device->lun);
+		"resetting scsi %d:%d:%d:%d due to cmd 0x%02x\n",
+		shost->host_no,
+		device->bus, device->target, device->lun,
+		scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff);
 
 	pqi_check_ctrl_health(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
-- 
2.28.0.rc1.9.ge7ae437ac1

