Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F789C0018C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2172B23B45
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403938AbgLJUjF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:39:05 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:44703 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404641AbgLJUhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632629; x=1639168629;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zfJU0rkRYKLOEpDN2ohtgJG/aoT0ah3mnho7Sl1eXw0=;
  b=yBNnOewWAey8YZZfWOEbwLXVjuiKkiCT/Q+FLYZqFzPOTvBoz5pzDuK/
   5+U75NMtDOmcoxSvxnzD2F4XsWujshk6AlxuOqZ3RdkAwnRRVkpBWBE94
   PYcIsklQpDtYRINdp8SDWKU4qDv1aoAJb9+CjWdqKhUvVyTBIlGKzN9/Q
   nLiBULHk3QBQLTeNFhNhQnTkeuP0PHyjM+MS+MbeLX8AXWHsjb5I/MWMn
   51Q4cS05EbttbnEgPx+5/sjeCTUyj6e+FzD1h3qxhYkniu1LYyv6aUrk1
   0q7TTJprg8xclbrSpuB11oX7cQY9fO8f18amo+RMzrGtxjwuE0h000owj
   g==;
IronPort-SDR: 711gYyRurMF6urjV+4XbGazc/+jJxGCQ922UU8DO4fQrsQjA5sw5iljugXMC2sCShW7YxL+MPu
 5INQwfpPg+dV18Yckgya+B8Iw55gSfXkxxxBIRM5g43svOUCiddi1OOCWpv6OwrnkLdA+O+Si1
 /vnypGmpTQLVeMUu7dHPqYVtcwLG87dyfGYXd28lz6M75gr/AWm/baskKAMB69pPHMBPSlfFPs
 SxBHxsgb21LRt5DTit0iZUrXjAkr5pnWeHoiP1SpCDPEI98WCt4k77FXK/DfYq9lmQ2vRvsstC
 8gk=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="102325152"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:35:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:35:36 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:35:36 -0700
Subject: [PATCH V3 13/25] smartpqi: disable write_same for nvme hba disks
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:35:36 -0600
Message-ID: <160763253599.26927.2206478699294629813.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Controller do not support SCSI WRITE SAME
  for NVMe drives in HBA mode

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 19b8dc9ea6ad..1eb677bc6c69 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6280,10 +6280,13 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
 			scsi_change_queue_depth(sdev,
 				device->advertised_queue_depth);
 		}
-		if (pqi_is_logical_device(device))
+		if (pqi_is_logical_device(device)) {
 			pqi_disable_write_same(sdev);
-		else
+		} else {
 			sdev->allow_restart = 1;
+			if (device->device_type == SA_DEVICE_TYPE_NVME)
+				pqi_disable_write_same(sdev);
+		}
 	}
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);

