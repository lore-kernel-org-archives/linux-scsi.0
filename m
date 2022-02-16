Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF440C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiBPVDq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbiBPVDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:40 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2133B222193
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:27 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id x11so2945903pll.10
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o/DjmKMEQ/TICGYiG1zbJphAMWsxSd5D/VpqW7WFmMA=;
        b=qw9dR30iz7Nmy0CCA6PDbEs71/HPMXHHEkv/fY83VC6nWtNoMn2ak4qlc5fbUjwPyQ
         QuOXTasRtFqfiT5zBxR9OvFpZXccrC2fuiadk19dO/x5N35sK1bAd461VcYl0KP9Vg4T
         9s7w07aOcCf/wHeBZGd/ZW4lIJDgBI6bbDgi4FvjURhHmfkAnJVKrZ000Zu4i6uMcUZm
         7aFxTiZ+f+y0gCGipkubFDGobpMW1/z/TjPIrc2J/ahXg1WewoASj2cwc1H0V5JH8tAw
         AZdzLg+aDmKPl9wswXu5A2oAmor8h0oTbk60Y2MZhCsSiHD2Rco59+lzZoRGmRUg4OHg
         id5Q==
X-Gm-Message-State: AOAM531pgDJfsIoPFggzV+cuWT4OVI4brRwbNnuepBOU9oMIE9PQA7MO
        1CL3yPcrvP2TQP+KRU+FoIs=
X-Google-Smtp-Source: ABdhPJy02UEOrY8zIY+12tjQR8JrmJhItjyI17D4b0Y20AOs0x8Oq6GwDrLFIhzcxQXFUPSRpc5+Bw==
X-Received: by 2002:a17:90b:33c4:b0:1b9:3aa6:e3e0 with SMTP id lk4-20020a17090b33c400b001b93aa6e3e0mr3900460pjb.182.1645045407083;
        Wed, 16 Feb 2022 13:03:27 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:26 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 20/50] scsi: esp_scsi: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:03 -0800
Message-Id: <20220216210233.28774-21-bvanassche@acm.org>
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
 drivers/scsi/esp_scsi.c | 4 +---
 drivers/scsi/esp_scsi.h | 3 ++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 57787537285a..64ec6bb84550 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2678,6 +2678,7 @@ struct scsi_host_template scsi_esp_template = {
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= 0xffff,
 	.skip_settle_delay	= 1,
+	.cmd_size		= sizeof(struct esp_cmd_priv),
 };
 EXPORT_SYMBOL(scsi_esp_template);
 
@@ -2739,9 +2740,6 @@ static struct spi_function_template esp_transport_ops = {
 
 static int __init esp_init(void)
 {
-	BUILD_BUG_ON(sizeof(struct scsi_pointer) <
-		     sizeof(struct esp_cmd_priv));
-
 	esp_transport_template = spi_attach_transport(&esp_transport_ops);
 	if (!esp_transport_template)
 		return -ENODEV;
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 446a3d18c022..c73760d3cf83 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -262,7 +262,8 @@ struct esp_cmd_priv {
 	struct scatterlist	*cur_sg;
 	int			tot_residue;
 };
-#define ESP_CMD_PRIV(CMD)	((struct esp_cmd_priv *)(&(CMD)->SCp))
+
+#define ESP_CMD_PRIV(cmd)	((struct esp_cmd_priv *)scsi_cmd_priv(cmd))
 
 /* NOTE: this enum is ordered based on chip features! */
 enum esp_rev {
