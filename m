Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2D5C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbiGHSpz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbiGHSpv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:45:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C13E65D52
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305952; x=1688841952;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bJRpBTGmKCGVvVPI2q0kSaHw//a7RaFcG1Wy6g0Rr0k=;
  b=Y2besGv2zqFwLpeb+nuq8wN/9iTbt6c48DBO3d7ISdAEkZggAIIYy0XN
   Bx3vcQWrJYKBQI/WF1swwsMRi2SWvDp7+WEZiC9kJ6NY4TrK4tYXy8djH
   fe01E5SHO52D9PKlfRdjHkPZqPK9laH7+dWO9IAi20NOi2686eX9R3IX+
   X/NPjdCmZZVSUN/AhHMDHJkNODoGRufNoQeize2j4LgBmqzVCdCSVJhZO
   h7RgV43+KtxwHjzlL+gCS9N7YFapdFFpUj3e9MHkXCxfyRB+2Rf+K8ZTg
   eaDo00M9C2c8OIpU1FzI9f9Hgup60uFv6mBfwXfYG1niDHkebIqfZg8FV
   A==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="171374316"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:45:51 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:45:48 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:45:48 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IktXw177297;
        Fri, 8 Jul 2022 13:46:55 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268Iktmw177296;
        Fri, 8 Jul 2022 13:46:55 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 02/16] smartpqi: add controller fw version to console log
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:46:55 -0500
Message-ID: <165730601536.177165.17698744242908911822.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gilbert Wu <Gilbert.Wu@microchip.com>

Print controller firmware version to OS message log during driver
initialization or after OFA.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Gilbert Wu <Gilbert.Wu@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index fa5cd2dfa3ad..394583672b0d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7469,6 +7469,9 @@ static int pqi_get_ctrl_product_details(struct pqi_ctrl_info *ctrl_info)
 		sizeof(identify->vendor_id));
 	ctrl_info->vendor[sizeof(identify->vendor_id)] = '\0';
 
+	dev_info(&ctrl_info->pci_dev->dev,
+		"Firmware version: %s\n", ctrl_info->firmware_version);
+
 out:
 	kfree(identify);
 

