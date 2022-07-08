Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F2DCCA47F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239669AbiGHSql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiGHSqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8367E02A
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305999; x=1688841999;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bezAK4eEv2ap1KgJBJRD7I0Uh1zeVc2gYne0GPjw5dA=;
  b=Dy9x89/xLMy0UQAeDvOacrd8dB49+vWRT+Aa1oBUSMA7Re5m7/8+xHz1
   ZcRTScmXm0g3NI/7pzrRRbcP+JBbX6A3JWbK3WHuOCZOp2ry1jd8BvdaA
   hjXiLb8+NqIfejhJBOF4glRRm2/fr5blX8cdbgwGDdTe9ESPFj61ajzAe
   Mb2hZMypuzFnYDesovzhAueM0UVinkw2cZzfKZpWkWYTOx8QXSl7GX7Hn
   BgofU6rXZqxOVW/j2KQJCYFf76FN6dzr2NImdrRG6rBpg7RzxBVp7AqUY
   RJ4u7EpzCfVSmOBrjsKrItXWfmk2fPvMa3gbbrE8ru4yku64YNHQ4vCnw
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="181377300"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:28 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:28 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IlabI177453;
        Fri, 8 Jul 2022 13:47:36 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268IlaMK177452;
        Fri, 8 Jul 2022 13:47:36 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 10/16] smartpqi: fix dma direction for RAID requests
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:36 -0500
Message-ID: <165730605618.177165.9054223644512926624.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>

Correct a SOP READ and WRITE DMA flags for some requests.

This update corrects DMA direction issues with SCSI commands removed
from the controller's internal lookup table.

Currently, SCSI READ BLOCK LIMITS (0x5) was removed from the controller
lookup table and exposed a DMA direction flag issue.

SCSI READ BLOCK LIMITS was recently removed from our controller lookup
table so the controller uses the respective IU flag field to set the DMA
data direction. Since the DMA direction is incorrect the FW never
completes the request causing a hang.

Some SCSI commands which use SCSI READ BLOCK LIMITS
      * sg_map
      * mt -f /dev/stX status

Note: Customers after updating controller FW may notice their tape units
      failing. This patch resolves the issue.

      Also, the AIO path DMA direction is correct.

The DMA direction flag is a day-one bug with no reported BZ.
Fixes: 6c223761eb54 smartpqi: initial commit of Microsemi smartpqi driver

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 96b206ab5ecf..51b5a11efa9c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5500,10 +5500,10 @@ static int pqi_raid_submit_scsi_cmd_with_io_request(
 	}
 
 	switch (scmd->sc_data_direction) {
-	case DMA_TO_DEVICE:
+	case DMA_FROM_DEVICE:
 		request->data_direction = SOP_READ_FLAG;
 		break;
-	case DMA_FROM_DEVICE:
+	case DMA_TO_DEVICE:
 		request->data_direction = SOP_WRITE_FLAG;
 		break;
 	case DMA_NONE:

