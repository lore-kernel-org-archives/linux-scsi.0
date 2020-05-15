Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF1FC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C10C520758
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:33:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BZXMkHOr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgEOKc5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:32:57 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36763 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbgEOKc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538776; x=1621074776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=K+mfsWPV71l4I6VcEyWEcajK2rXWSFwJIFjlvnbdyFQ=;
  b=BZXMkHOrqBzKEhEfeHfYlJqARgubI8n09/NHnoYqQfm75Kzs99wPn0FA
   wR76XXdJwNi1ZxYOzQsnogyZqhw6SiUrBWs2WvFIpBgX5aX6dcKNk15n9
   KaZAsaCIHcQZL0hX81JV4RUVSYWTG+lVaOG29hej3BCV+tWDBeWwYssGh
   WAxBI8wcxlhiLWok+RRqXYR/g/KYBjs3t6Tkn4DiOTsdU3dJVis+xEBmu
   uBpHIbnLwQtZ1hK1Qjqnv8V5syzyz+dOxsGZB3sRgGyxdy+sug7uofj3Z
   RrOFTIGhM7BxOCOZaVZlG4Pgoy5BTAbmoYIHsJw0+R++g+9/IYVIuntHJ
   g==;
IronPort-SDR: klas3jsgaGyHhjV0LvVByp2EbreOaWFEQ3Q2cKLKyFi2yPwV7IECW6gZi4pGXtLU8vdE/u0JIO
 VG4wLJuOBj+xU3CkQrXj7tEmAiW3PrqNLMl9aRVbmwCaQCF+O5F/p32s2jICRgswHF9pqxms7R
 V484D30fJ+rR0QJUZoi8RL4lIStRQV0U+sGfxOqy6V0R6lxm51RAOLYokf6r3oSb4CWUVJjoP5
 jCxxmqIu4y3ooJY6Z9lyLgcAJYF6k/tSjwq3ojAasQwJTtwEXsjkg21EThmZEykR6T8yURD0FK
 TOg=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="139202600"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:32:56 +0800
IronPort-SDR: JMZ/kvRtQ3W+ROOUKqPfnbdFe8R7awFYOrVDkG7512H4zY+vcGZtBReNbGI1XmqMMbHAJ1iL45
 94JaXpv2tdnFO7c0pym7ov7fBTgvG+FOo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:22:33 -0700
IronPort-SDR: JmWbGoI6s9sjYLw/5CEvdCvkKJOfwYwU5WNsSRJf/0IRiVYlG/misjWGVpYwP6urAwbGJaUSvi
 yisecNphVk0A==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:32:51 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [RFC PATCH 11/13] scsi: Allow device handler set their own CDB
Date:   Fri, 15 May 2020 13:30:12 +0300
Message-Id: <1589538614-24048-12-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow scsi device handler handle their own CDB and ship it down the
stream of scsi passthrough command setup flow, without any further
interventions.

This is useful for setting DRV-OP that implements vendor commands via
the scsi device handlers framework.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/scsi_lib.c | 5 +++--
 drivers/scsi/sd.c       | 9 +++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6b6dd40..4e98714 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1148,14 +1148,15 @@ static blk_status_t scsi_setup_fs_cmnd(struct scsi_device *sdev,
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 
+	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
+	memset(cmd->cmnd, 0, BLK_MAX_CDB);
+
 	if (unlikely(sdev->handler && sdev->handler->prep_fn)) {
 		blk_status_t ret = sdev->handler->prep_fn(sdev, req);
 		if (ret != BLK_STS_OK)
 			return ret;
 	}
 
-	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
-	memset(cmd->cmnd, 0, BLK_MAX_CDB);
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a793cb0..246bef8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1221,6 +1221,14 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua);
+	} else if (unlikely(sdp->handler && blk_rq_is_private(rq))) {
+		/*
+		 * scsi device handler that implements vendor commands -
+		 * the command was already constructed in the device handler's
+		 * prep_fn, so no need to do anything here
+		 */
+		rq->cmd_flags = REQ_OP_READ;
+		ret = BLK_STS_OK;
 	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
 		   sdp->use_10_for_rw || protect) {
 		ret = sd_setup_rw10_cmnd(cmd, write, lba, nr_blocks,
@@ -1285,6 +1293,7 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 		return sd_setup_write_same_cmnd(cmd);
 	case REQ_OP_FLUSH:
 		return sd_setup_flush_cmnd(cmd);
+	case REQ_OP_DRV_IN:
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
 		return sd_setup_read_write_cmnd(cmd);
-- 
2.7.4

