Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D30CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 19:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiKHTTR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiKHTTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 14:19:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4641515A2E
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 11:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667935144; x=1699471144;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NRg/SFK64/1Z6t9LfssV1RW2SYHYieF4vdDjRPYMTIQ=;
  b=MMzJEtT5pNphzPRuCHB1E+UsbtoTvdsDgELNYEnGl1H0UdoS/dlNMCuz
   SGUQ18YLoyAqHyd+K21hC9kaZAEcnoukFyRP2lNCHPZgie+ZMQ29CkATm
   dA+dDpPllBUAdsc8hxAheM3FR8G6n5LWMsUZJeXBNdDx1GeIoiotzlLRV
   ZnG7AKuZDNgBpXFCdcEs6n54hjACat6fVrSttj0QoRFSecap2PIL8F1OY
   6Q7jNxxnY4RGvFkzIPAvUtUUrUZCoFFPcgEFNdx1UcLK947iDR4b/4GcV
   vAw5/fPg06GkLRtLsf/nQczPLCIUaQ6m03tN5iSJRxuCHXIgkipO8Jq++
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="185978697"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2022 12:19:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 8 Nov 2022 12:19:01 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 8 Nov 2022 12:19:01 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 2A8JLrhi322612;
        Tue, 8 Nov 2022 13:21:53 -0600
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 2A8JLrBr322611;
        Tue, 8 Nov 2022 13:21:53 -0600
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH 4/8] smartpqi: change sysfs raid_level attribute to N/A for
 controllers
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Nov 2022 13:21:53 -0600
Message-ID: <166793531357.322537.8639138137605612362.stgit@brunhilda>
In-Reply-To: <166793527478.322537.6742384652975581503.stgit@brunhilda>
References: <166793527478.322537.6742384652975581503.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Change the sysfs raid_level attribute from "RAID-0" to N/A.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowan <mike.mcgowan@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 33059355f9cd..20fc6c8044ac 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7255,7 +7255,7 @@ static ssize_t pqi_raid_level_show(struct device *dev,
 		return -ENODEV;
 	}
 
-	if (pqi_is_logical_device(device))
+	if (pqi_is_logical_device(device) && device->devtype == TYPE_DISK)
 		raid_level = pqi_raid_level_to_string(device->raid_level);
 	else
 		raid_level = "N/A";

