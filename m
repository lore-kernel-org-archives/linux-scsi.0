Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60409C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344651AbiA1WVR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:21:17 -0500
Received: from mail-pg1-f177.google.com ([209.85.215.177]:40786 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344698AbiA1WVJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:09 -0500
Received: by mail-pg1-f177.google.com with SMTP id t32so6442380pgm.7
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y2gxnwELUH5z6NK6QMEmHf5vunQl1GoO3xJc3G2P2mI=;
        b=1N3H1GddPf2YfDDjtXud9sRMq1bJhXKfo3+Q+u5sMbz99r1iU8vqW/JN3IhspoH+de
         3/7uAEl2ACyegedK0Wpzb+ofZXFqpB/TahI4T0ZwIztMk6PXtjK2dIziy3M0J73AwlrX
         k1i73fGnLav6KfLr93jyARBstr1DxLk1/UFWtW4cYsLEwWJFCO2ZvswvVmptfUgNEgF+
         op4kS1mOdczSARpZT//kQXLfzXVN8TtqTqyDX2V1fjfp3lFP6uA0KwfRBMm/1hvNK2xQ
         lUqpL+28mRyKWfXtAsIv1siCinGjwGS4Ta9gcymrjZ899VBR8vaI5H+IwWmFaBMiJtNx
         dNSg==
X-Gm-Message-State: AOAM532tqHfzxXA/mEFuTe38dEEOV9m5ijzsT2GStC+DawZIbpkjlqqJ
        E6bj9/CT1/n9ER+xvsObDu8=
X-Google-Smtp-Source: ABdhPJxmvSVdRJZse+NUfEbcGkX7+Bb9u2x04O+ul3cn8spoqs3Xovm0yVc/ViuzZXqTsguvtAJ4Jg==
X-Received: by 2002:a05:6a00:228c:: with SMTP id f12mr10501095pfe.34.1643408469149;
        Fri, 28 Jan 2022 14:21:09 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 16/44] esp_scsi: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:18:41 -0800
Message-Id: <20220128221909.8141-17-bvanassche@acm.org>
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
 drivers/scsi/esp_scsi.c | 1 +
 drivers/scsi/esp_scsi.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 57787537285a..9dfdca5b31e7 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2678,6 +2678,7 @@ struct scsi_host_template scsi_esp_template = {
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= 0xffff,
 	.skip_settle_delay	= 1,
+	.cmd_size		= sizeof(struct esp_cmd_priv),
 };
 EXPORT_SYMBOL(scsi_esp_template);
 
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
