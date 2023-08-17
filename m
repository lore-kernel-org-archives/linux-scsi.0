Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A43FC2FC14
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 13:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351138AbjHQNMu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351392AbjHQNMb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 09:12:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B222F30D6
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 06:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692277924; x=1723813924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F2BmUbmhok78MCe6S2UWhMiI0Fw+jdgKHLnvuXLzqWw=;
  b=OyRcAQtOsAwznL11MbzvwKpKYwt92l3ugQqfISOj9ldDW/cAtnzmAvHi
   ryMQRCuXg3SXZH0hUsUaHNL28ZSxS0SG5dcyvOUcvJ02YS1D4HOPdf3KH
   fENYXwOPDZC7lBX2+66fdNqc1MrdttanrBJGtikJFpv7tzDyC+eifYZq6
   6p9qH6yOBYBRsPARp6oDdKW52iImvmg62F8bxvN9+nQc0B5uHZtGOCksT
   J7T+RsWIIzYeL2j6dAjZb8guYgRVQ63drWZ0HN1spnyeZC6ETl+iPmn0E
   yw6+08OfINR1mLJcAo5HarJeglZrqBfc40Qvgd6q3jTAwHhSKxbRTOr5i
   g==;
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="229442497"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2023 06:11:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 17 Aug 2023 06:11:06 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 17 Aug 2023 06:11:05 -0700
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
Subject: [PATCH 5/9] smartpqi: simplify lun_number assignment
Date:   Thu, 17 Aug 2023 08:12:28 -0500
Message-ID: <20230817131232.86754-6-don.brace@microchip.com>
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
index dedc721b007b..e3ce5b738e15 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5429,7 +5429,6 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct pqi_io_request *io_request;
 	struct pqi_aio_path_request *request;
-	struct pqi_scsi_dev *device;
 
 	io_request = pqi_alloc_io_request(ctrl_info, scmd);
 	if (!io_request)
@@ -5449,9 +5448,8 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
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
2.42.0.rc2

