Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65039C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbiBRTxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238461AbiBRTxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:31 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A428294FC1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:08 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so9485796pjh.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:53:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJEfpYZmesmFuk0UQfGK2rmVME1mv8OVxEoziN58YoM=;
        b=wMFE1BtO64HwGKjqnKmDLDip7d1wx/vB5HBtn3lbq0ZrQGDuUd+ATnleQx2QVAjh5N
         Xfp4W5DFsxEdbyZ/q668t9Ep7RLTt4XzfCTNG8+b7y1dSk1lAeJcDG9K+bbrdbE/wWW6
         uJ4xVk6kwVNYHYhwHqKmL2G7MfgmrF4cYYdhIFO3h+NlSnqnL0dSZF9uQ+REa0K33Wp7
         GolclQ+H9Ta13krBMyWVfAbh0/kr6U1o1DuQeOTDF+a4sjNKzz1tY5M7kKI92nIF6xJv
         cL78NXHyRM4Axx3eU/DMEJwsBVS8fJ0ZJ6kOjLV3tGl4HWZf2gGVfjh0xyuCkf4Wmysn
         ylXw==
X-Gm-Message-State: AOAM533IvsysLZCwpCV3+RdUcQsTeQdyMFNnblu5k8NBMmQ7w8Sl73em
        FEkadLY9whtGx0V+mFS6aeQ=
X-Google-Smtp-Source: ABdhPJx8/ayt6zX1YA4PL3pwbqy1T0/KUVZd5/6AtFZioX5PMtr9h/SAoljCX/mC3b6ZDnwe8TaR+w==
X-Received: by 2002:a17:902:6b81:b0:14f:37e1:3940 with SMTP id p1-20020a1709026b8100b0014f37e13940mr8753565plk.115.1645213987346;
        Fri, 18 Feb 2022 11:53:07 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:53:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 43/49] scsi: smartpqi: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:51:11 -0800
Message-Id: <20220218195117.25689-44-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
