Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3319C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC7E64FCA
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhCJUCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:02:24 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25967 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbhCJUCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:02:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406527; x=1646942527;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S0d9LzKXMWIDoW6HTJO0GRL2EVaCJ1p3x/08rIhT3qY=;
  b=fEM4bN8mZ7j6AH7qnZZYXb/LhtgDEZiGXlS5eskcOZLcy7blRcDU+CSn
   GRnRIABvG7gKum32p3vvsIXI8r2wj35iBBn36dUKViC3nXC2rGx61elz5
   AA1hY+iTepHfgnighCfSw912RITl6vLiAEyteF9m5o94Q/ISYWQ53Em13
   8GhxzsJUs9JN8aNyTf4TJANh99i/BncZn5g2v9Lo0Aw2IQnPIBO2Rcb7h
   tDyeYNd0RnxbUksyEAQe+Ep49EyoDz19mdecukHqvh+QggGmwgxzqE9VX
   ONvhEHvLZEP/T1yAb1nVbnj6v+ksV0TWjdqAUvwUtC3hdDmPKTrHTA/bZ
   g==;
IronPort-SDR: Eu4qhY3boJo2NopR0fSeQZX5HoSaulE4T/UAe5Isb1qnCU3o2L8aVttevoRKexcB3jshOpBSe/
 UHPjyjMKVv0yt72ryy2UgRaBUBheDGX6KeAHxv8NsJ595l7ChyyY6mB/vOcvKmwSw8tBOHiuNK
 M4ysxzUM1cfkEiYRoRqczHV9c0l9u12OnqczFrBdEdpliBpszgtb5OcCLjb22exlv658mwmmwx
 fLdVMoJlOjvuW49wfrJVKmwUvLhFO0HgVF60+W4yzAmSsn/ePJfVqfeAueTqFrZE0+PFKzDtS8
 glM=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="112731789"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:02:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:02:01 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:02:01 -0700
Subject: [PATCH V4 13/31] smartpqi: disable write_same for nvme hba disks
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:02:01 -0600
Message-ID: <161540652104.19430.11180129958216744631.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
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
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 991883ada641..d605ef1b9968 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6252,10 +6252,13 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
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

