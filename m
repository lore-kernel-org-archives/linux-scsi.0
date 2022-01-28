Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285E9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351623AbiA1WWM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:12 -0500
Received: from mail-pg1-f177.google.com ([209.85.215.177]:37418 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351647AbiA1WV5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:57 -0500
Received: by mail-pg1-f177.google.com with SMTP id e16so6462309pgn.4
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CnqNmH4OwYN5k7j2DBSHf1rhiC3RkTmz93Z+tzE6eac=;
        b=xgyjJdNWHuPuFM9gyr+6W4IMmgeovOb1ybjHAe57Ikn+ygECe9y4ijXX+L3kFUiNuM
         fVfef3CP+pXSP5L+V/eU+8TBe9BAvvSyWBI2oMnQhufMtwI2/wSoENzJa5i9vpLsgGwG
         1GxdMBbPCRSa+tzr6mTxGomJR1icmVkNNC//nnsU/K9aPVmg/YOeTQldRBJSOr0Yl2nD
         JwE/UGcVpxLXfxYu0ldjv/uHmg/ItU43/r66QpEpCSUta1xekQfBWIJfOSYi3vvQOqQU
         u3sjWK9vPnuDXm0Mgf8zlAoDIPi+DwXjRFKRr1FQkSJEIjbiDb3yvW8gUxZS2pMgiL3A
         i/oA==
X-Gm-Message-State: AOAM533nsdG+hho9e8De9QBiOj+3cIxPIWs3gg3LiK8Yt8LwiPsCK/iT
        BaNWiBghJdyGTXWGuluUwAE=
X-Google-Smtp-Source: ABdhPJwNHSyOTtktmiujTm1m5rFC1Iog0XKKyvRpS9VJAVfdnquyh1L2Rcwg8F4ZJE2NVAAsYEHdjA==
X-Received: by 2002:a05:6a00:1a8d:: with SMTP id e13mr4656498pfv.10.1643408511444;
        Fri, 28 Jan 2022 14:21:51 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:50 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 38/44] smartpqi: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:19:03 -0800
Message-Id: <20220128221909.8141-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f0897d587454..74426974309f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -54,6 +54,15 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
+struct pqi_cmd_priv {
+	int this_residual;
+};
+
+static struct pqi_cmd_priv *pqi_cmd_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
@@ -5555,7 +5564,7 @@ static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 	scsi_dma_unmap(scmd);
 	if (io_request->status == -EAGAIN || pqi_raid_bypass_retry_needed(io_request)) {
 		set_host_byte(scmd, DID_IMM_RETRY);
-		scmd->SCp.this_residual++;
+		pqi_cmd_priv(scmd)->this_residual++;
 	}
 
 	pqi_free_io_request(io_request);
@@ -5779,7 +5788,7 @@ static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 	if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd)))
 		return false;
 
-	return scmd->SCp.this_residual == 0;
+	return pqi_cmd_priv(scmd)->this_residual == 0;
 }
 
 /*
@@ -7159,6 +7168,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.map_queues = pqi_map_queues,
 	.sdev_groups = pqi_sdev_groups,
 	.shost_groups = pqi_shost_groups,
+	.cmd_size = sizeof(struct pqi_cmd_priv),
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
