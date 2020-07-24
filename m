Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2BBC433E8
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 21:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B6FD2070B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 21:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgGXVZK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 17:25:10 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:59044 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgGXVZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 17:25:09 -0400
IronPort-SDR: iZJxTCb2ZEuI+BCLQYiniDLpqYTB7mc+iBx63L9IwAUNTojlg+ZFyLGrig8CMd+pl9SH2TS1mL
 FKsMqmEjqX5udD0iqSOrwLTOw5J4iLzuhWDuRXk7LuOSyBazl10MEbwYUMoKnT3KEBZaJn/vv5
 RBsCH4hccToPraBnqGfunqQ8+gEbIbMWl+ZZIZl3No28RWRg6BF7KuN+Vz/bCyy73Zz8y/rQmF
 c+HjkE8yj/mjI2W9hb/CecBjEltbwioha/JcD6SRTc5Hh2ytuUdVPq5AynQoLf7OtpJo8bMcZd
 oCA=
X-IronPort-AV: E=Sophos;i="5.75,392,1589266800"; 
   d="scan'208";a="83218266"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 14:25:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 14:25:08 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 24 Jul 2020 14:25:08 -0700
Subject: [PATCH] hpsa: correct ctrl queue depth
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 24 Jul 2020 16:25:08 -0500
Message-ID: <159562590819.17915.12766718094041027754.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 - need to set queue depth for controller devices.
 - corrects compiler warning in patch:
   hpsa-increase-ctlr-eh-timeout

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 90c36d75bf92..91794a50b31f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2145,20 +2145,21 @@ static int hpsa_slave_configure(struct scsi_device *sdev)
 
 	if (sd) {
 		sd->was_removed = 0;
+		queue_depth = sd->queue_depth != 0 ?
+				sd->queue_depth : sdev->host->can_queue;
 		if (sd->external) {
 			queue_depth = EXTERNAL_QD;
 			sdev->eh_timeout = HPSA_EH_PTRAID_TIMEOUT;
 			blk_queue_rq_timeout(sdev->request_queue,
 						HPSA_EH_PTRAID_TIMEOUT);
-		} else if (is_hba_lunid(sd->scsi3addr)) {
+		}
+		if (is_hba_lunid(sd->scsi3addr)) {
 			sdev->eh_timeout = CTLR_TIMEOUT;
 			blk_queue_rq_timeout(sdev->request_queue, CTLR_TIMEOUT);
-		} else {
-			queue_depth = sd->queue_depth != 0 ?
-					sd->queue_depth : sdev->host->can_queue;
 		}
-	} else
+	} else {
 		queue_depth = sdev->host->can_queue;
+	}
 
 	scsi_change_queue_depth(sdev, queue_depth);
 

