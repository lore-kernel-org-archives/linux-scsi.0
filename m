Return-Path: <SRS0=CnLx=YH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FF4C4CECE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Oct 2019 18:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D422C20873
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Oct 2019 18:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732352AbfJNSE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Oct 2019 14:04:26 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:35160 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730878AbfJNSE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2019 14:04:26 -0400
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@email.microchip.com
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:68.232.147.0/24 ip4:68.232.148.0/22 ip4:68.232.152.0/23
  ip4:68.232.154.0/24 ip4:216.71.150.0/24 ip4:216.71.151.0/24
  ip4:216.71.152.0/23 ip4:216.71.154.0/24 ip4:198.175.253.41
  ip4:198.175.253.82 include:servers.mcsv.net -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: F9A+6/ktoBQnp7b1IdRfs6H3hI3G/4/Yt5gX/q1dOCvypyQejYVLxxM3R3cA8EX2fLON9tOHFC
 hg0WOl44Dj9kA7r2W0Az0Fp7xpzyaPo4uQOm8fhkd+C8gatoZ5Gkeus/luNy0TSWbAuMJMYyf5
 vmaKZw98BRnQlx1rpJGxjrbz9Uv9A0z7CqabVG5HpIfv2RLM11avyvlrrBu12DC52u+A7PkVLX
 agjeSePC03PRZ2ajdDpklKXxxt3tZ4vXQ13ZZakcUYupng2zLzglHjPt6aMyloU7xgk4B0EoS2
 0kc=
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="49992413"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2019 11:03:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Oct 2019 11:03:59 -0700
Received: from [127.0.1.1] (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 14 Oct 2019 11:03:58 -0700
Subject: [PATCH] hpsa: add missing hunks in reset-patch
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 14 Oct 2019 13:03:58 -0500
Message-ID: <157107623870.17997.11208813089704833029.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- correct returning from reset before outstanding
  commands are completed for the device.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ac39ed79ccaa..216e557f703e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5477,6 +5477,8 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	c->device = dev;
+
 	enqueue_cmd_and_start_io(h, c);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
 	return 0;
@@ -5548,6 +5550,7 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 		hpsa_cmd_init(h, c->cmdindex, c);
 		c->cmd_type = CMD_SCSI;
 		c->scsi_cmd = cmd;
+		c->device = dev;
 		rc = hpsa_scsi_ioaccel_raid_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -5555,6 +5558,7 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 		hpsa_cmd_init(h, c->cmdindex, c);
 		c->cmd_type = CMD_SCSI;
 		c->scsi_cmd = cmd;
+		c->device = dev;
 		rc = hpsa_scsi_ioaccel_direct_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;

