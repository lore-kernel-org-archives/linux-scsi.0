Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF77C88CB2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 15:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242319AbjHXP45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 11:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242330AbjHXP4b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 11:56:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9F319BC
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692892589; x=1724428589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hYT9v8HjWnizIRcyZV2/IeIFPhJxvcTRLUn+v4ggGeA=;
  b=wsXdbv9fITYoWsatR3BwN5ATUi4R2QXtrSEdlm5E08zE3Eir1PYJj8YF
   T6aweNp2j0z22lZJfHnh2cGTGDlUzU4yqxJ0ilAUjJHxSZrJR40N91UCG
   6QZBlsueuWjLgHKja7OQcMh5BT5OUgBWYxjTBujbGILoMH5dvh7rZohNx
   rgNFDENg1Y4qBGhKbKHMciYCVeaRy8AfXaRsMWIS4h/bUWX7HjXDpv7SP
   MTE3KRu3bsMBtcxtUUF6L8qaEldLbEYouIuRmIdGJsOp8wiv3RWcSJkps
   fErY1JS05S09xpnu95Ngdmn4y6DQpTFw8omzKT/mOZ3PhXYY2y2267h6A
   g==;
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="1149058"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2023 08:56:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 24 Aug 2023 08:56:14 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 24 Aug 2023 08:56:14 -0700
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
Subject: [PATCH v2 4/8] smartpqi: simplify lun_number assignment
Date:   Thu, 24 Aug 2023 10:58:08 -0500
Message-ID: <20230824155812.789913-5-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824155812.789913-1-don.brace@microchip.com>
References: <20230824155812.789913-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: David Strahan <David.Strahan@microchip.com>

Simplify lun_number assignment. lun_number assignment is only
required for non-AIO requests.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2ebc72270746..999bed578138 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5656,7 +5656,6 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct pqi_io_request *io_request;
 	struct pqi_aio_path_request *request;
-	struct pqi_scsi_dev *device;
 
 	io_request = pqi_alloc_io_request(ctrl_info, scmd);
 	if (!io_request)
@@ -5676,9 +5675,8 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	request->command_priority = io_high_prio;
 	put_unaligned_le16(io_request->index, &request->request_id);
 	request->error_index = request->request_id;
-	device = scmd->device->hostdata;
-	if (!pqi_is_logical_device(device) && ctrl_info->multi_lun_device_supported)
-		put_unaligned_le64(((scmd->device->lun) << 8), &request->lun_number);
+	if (!raid_bypass && ctrl_info->multi_lun_device_supported)
+		put_unaligned_le64(scmd->device->lun << 8, &request->lun_number);
 	if (cdb_length > sizeof(request->cdb))
 		cdb_length = sizeof(request->cdb);
 	request->cdb_length = cdb_length;
-- 
2.42.0

