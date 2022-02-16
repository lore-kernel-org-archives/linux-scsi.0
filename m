Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71D2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbiBPVEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiBPVEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:34 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FCA2B1A83
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:14 -0800 (PST)
Received: by mail-pf1-f181.google.com with SMTP id d17so3236593pfl.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:04:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJEfpYZmesmFuk0UQfGK2rmVME1mv8OVxEoziN58YoM=;
        b=POy5dOKrdaBXmqKLt1qh1uMv6Bjh3hWl/b+AuW2a4hX1cSOyMJS2QD6DxRUA0KyOSJ
         rSdDc27HEll4j5oDcw5AzFA/Etn8kac/OvkwpzoFmWhwb7WMCtPw7ZrJkxDCtYChrxv2
         uwSuVuCmhZkLDKW1riemPtOwfKiXYRr2pFO1EFcJUoM6T5nms3ffQZkb1PcL3TQGEtbg
         UO/Q6z0ny3PHy84+LFpuidi3Xq/lK42jvj1/wOPsJVBz1mqvTds6FFhQgRP4zHj0WLW3
         pqhU7Pnmtl0tEfv3TBRXhD3qeSMzWm4d0vR7TA3AJxeUJKKGVN85woexSyf2V0r4LS2K
         U7tg==
X-Gm-Message-State: AOAM532o0kQBPRRF61XfKzjQMJsubTf4MH/FVmaQxqbqJgD3RFkiqbD3
        iVxfMD995+m8ndVupl3i7xk=
X-Google-Smtp-Source: ABdhPJzs7ll1JOklhlZ81B/xoODjls3+gWBDy1xPengQWATZ/sYp/HNoGkeOxOmxpq2Kqh0lRbPp3A==
X-Received: by 2002:a05:6a00:130b:b0:4e1:7b1e:6c6 with SMTP id j11-20020a056a00130b00b004e17b1e06c6mr5247279pfu.22.1645045453465;
        Wed, 16 Feb 2022 13:04:13 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:04:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 44/50] scsi: smartpqi: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:27 -0800
Message-Id: <20220216210233.28774-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 4611912ae261..7c0d069a3158 100644
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
 static void pqi_verify_structures(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
@@ -5552,7 +5561,7 @@ static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 	scsi_dma_unmap(scmd);
 	if (io_request->status == -EAGAIN || pqi_raid_bypass_retry_needed(io_request)) {
 		set_host_byte(scmd, DID_IMM_RETRY);
-		scmd->SCp.this_residual++;
+		pqi_cmd_priv(scmd)->this_residual++;
 	}
 
 	pqi_free_io_request(io_request);
@@ -5814,7 +5823,7 @@ static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 	if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd)))
 		return false;
 
-	return scmd->SCp.this_residual == 0;
+	return pqi_cmd_priv(scmd)->this_residual == 0;
 }
 
 /*
@@ -7262,6 +7271,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.map_queues = pqi_map_queues,
 	.sdev_groups = pqi_sdev_groups,
 	.shost_groups = pqi_shost_groups,
+	.cmd_size = sizeof(struct pqi_cmd_priv),
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
