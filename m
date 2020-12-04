Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5F4C4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD7AA22D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgLDXDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:14 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1478 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLDXDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122993; x=1638658993;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lmIw3y1p92HnugvLiKGMzPtRIyxOEMgXAXE21Epvo8Y=;
  b=mpacBSnHPRt6ehh2B0Urtc2OO6jl0mCNMwknBAlmXuykW4OVs1hsRRFh
   KEFrB8YLH11aliubmYJqFKsx7axZPkZ75tCmWuLtCcsGIx7z4xDBOR/F+
   8Ww0R/aSKICUOt3TxBnIGTEypcSrmXscfYG+N2zB3G4ZJvwtNqd3jYU6z
   UGbo99cS3pcV/WCi3cjxElc0nyDXajtHPTNk081IKSg5LXpqxl4mpERXB
   VyXOZUMf3Hb7Jdd5P1+dLW5a3P5eA/P8moBjH4StKzk03PjRFJNIgBfwL
   2FjtGgVTnYP8QlDYucdDVdAXAFp617FeemkqHaFnJlaghtIwpy1E+144I
   Q==;
IronPort-SDR: bew/MqZIDjg91ngy0odT9ZVJrGoKjb6vY9E/yoMp9M0wsWjIvBfYxTPAXtH6VcsZD1dYqlsju4
 nVkUkkyX9z1/JHqa18TDTzfNlUyjIwYckrqwy3evMYA0DOdTgA267dNQZmrGbM2hPyGeEkDghe
 PQF3a7VjA+mtfVm07NJkP5cFfAaq1aoXLA4bbWBRVrfP3+b+c469AxrEnh0I0AbM0tdMesWvu4
 ogcq+zo+QQka3vZ/xvatEP56jvZbDgA+3ddm+KKNI8SazXJrbeEd63jp0xU4o813koqNTyQTLR
 GD8=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="101548671"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:06 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:06 -0700
Subject: [PATCH 13/25] smartpqi: disable write_same for nvme hba disks
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:06 -0600
Message-ID: <160712292615.21372.15639957017242633419.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
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
index be2f177b3a21..8148a270854e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6211,10 +6211,13 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
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

