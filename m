Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7E4C2FC24
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 13:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351329AbjHQNMy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351408AbjHQNMg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 09:12:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610753598
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 06:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692277931; x=1723813931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9B7U6pD9tMIjJLDsJ1hgKCr04EnqHyirE6EeSamgd/I=;
  b=bIWmSjCn8G0ghJa4Mcy/1Ajg2rCfy6wgNx9f47gcGkzak1X4XKDCcvDF
   728FFji//Q6Y3BhMRUMw2pt2yPD09IhcfOWQ6r18P8cjfjUoUJDbpL+U/
   kiWkEOQUJWp3nbwC/Kdp0RE0r5TNl5MobuT1G97I1jhEhubQrCgbhnD2u
   xuTMXCYV+3nnCzPTyHdSChPpA4Qek8+g3SNKkmQuFqvoHYcZqjJ4KueNE
   oXwPupUGBCE4avdf4E1OTCUEpswPpdnCdkHWwWcoEN00K0xte9FxR41W6
   tVkJtFCBcgzaLL92Y8EGfEu2D+Lc5YR+oP8ITsoFBqvncN19p7cMucv5D
   A==;
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="230249337"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2023 06:11:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 17 Aug 2023 06:11:08 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 17 Aug 2023 06:11:07 -0700
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
Subject: [PATCH 7/9] smartpqi: enhance controller offline notification
Date:   Thu, 17 Aug 2023 08:12:30 -0500
Message-ID: <20230817131232.86754-8-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0.rc2
In-Reply-To: <20230817131232.86754-1-don.brace@microchip.com>
References: <20230817131232.86754-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: David Strahan <David.Strahan@microchip.com>

Add a description for the reason the controller has been taken off-line.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 50 ++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2612818d476d..a497a35431b2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8712,6 +8712,52 @@ static void pqi_ctrl_offline_worker(struct work_struct *work)
 	pqi_take_ctrl_offline_deferred(ctrl_info);
 }
 
+static char *pqi_ctrl_shutdown_reason_to_string(enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
+{
+	char *string;
+
+	switch (ctrl_shutdown_reason) {
+	case PQI_IQ_NOT_DRAINED_TIMEOUT:
+		string = "inbound queue not drained timeout";
+		break;
+	case PQI_LUN_RESET_TIMEOUT:
+		string = "LUN reset timeout";
+		break;
+	case PQI_IO_PENDING_POST_LUN_RESET_TIMEOUT:
+		string = "I/O pending timeout after LUN reset";
+		break;
+	case PQI_NO_HEARTBEAT:
+		string = "no controller heartbeat detected";
+		break;
+	case PQI_FIRMWARE_KERNEL_NOT_UP:
+		string = "firmware kernel not ready";
+		break;
+	case PQI_OFA_RESPONSE_TIMEOUT:
+		string = "OFA response timeout";
+		break;
+	case PQI_INVALID_REQ_ID:
+		string = "invalid request ID";
+		break;
+	case PQI_UNMATCHED_REQ_ID:
+		string = "unmatched request ID";
+		break;
+	case PQI_IO_PI_OUT_OF_RANGE:
+		string = "I/O queue producer index out of range";
+		break;
+	case PQI_EVENT_PI_OUT_OF_RANGE:
+		string = "event queue producer index out of range";
+		break;
+	case PQI_UNEXPECTED_IU_TYPE:
+		string = "unexpected IU type";
+		break;
+	default:
+		string = "unknown reason";
+		break;
+	}
+
+	return string;
+}
+
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
 {
@@ -8724,7 +8770,9 @@ static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	if (!pqi_disable_ctrl_shutdown)
 		sis_shutdown_ctrl(ctrl_info, ctrl_shutdown_reason);
 	pci_disable_device(ctrl_info->pci_dev);
-	dev_err(&ctrl_info->pci_dev->dev, "controller offline\n");
+	dev_err(&ctrl_info->pci_dev->dev,
+		"controller offline: reason code 0x%x (%s)\n",
+		ctrl_shutdown_reason, pqi_ctrl_shutdown_reason_to_string(ctrl_shutdown_reason));
 	schedule_work(&ctrl_info->ctrl_offline_work);
 }
 
-- 
2.42.0.rc2

