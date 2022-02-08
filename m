Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A03BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384181AbiBHR1R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384346AbiBHR1D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:27:03 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB21C0613CA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:53 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so2337995pjm.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DpXzEajf1/HzYDqhJk6BZQGeVVV4JY+OE9SEemuZfSg=;
        b=zOMiIXSfp8pEcW/JRO8VoUDSMYwl0sDihLODt5FSZXw40PA9Esh01DBx5E5SZg2CaT
         iOUaz2GqBWIu+CLzgSaRofVCXzt6Y3jqob+CXTL5FjddTK0noSBDaEznVjaUvOSFX/XU
         gUACv2zA3ydw3GRKPZunDNwk7LXzo3cC3rzQg3ZMLu2rhGnTpLB6mFBv8uoXGwtufSvQ
         CNp8eKpbvrSC0b+ULiJeA3prVjD16ba8WuZk+J8xy+8WshLiCzu5dD0hBx3V9LsnWtjo
         9l2ahUV8nAjup3Y8tHmjXR0+Yn0ruR8jnStakCpFzAP1bhpR1BM2ca1fT88F7KGKcGb/
         V8iw==
X-Gm-Message-State: AOAM533Rc781407fmKG2BPu9gQonk/p+du2D/N6fSeuoXoUe4UyzuKYZ
        Iq9Yb4TUOWhWhPT+EW4vPHA=
X-Google-Smtp-Source: ABdhPJzeLECHWM5Laz3r/pBmMVG5MKx5yGDpgvGCj1h/ydpFN6mT1CtoHhWFVkqt3XSrGqSt3anLBg==
X-Received: by 2002:a17:902:6b49:: with SMTP id g9mr5371151plt.111.1644341213258;
        Tue, 08 Feb 2022 09:26:53 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:52 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 38/44] smartpqi: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:25:08 -0800
Message-Id: <20220208172514.3481-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
