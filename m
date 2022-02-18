Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D8BC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbiBRTwe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbiBRTw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:26 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04DC237FC
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:09 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso9502151pjj.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o/DjmKMEQ/TICGYiG1zbJphAMWsxSd5D/VpqW7WFmMA=;
        b=NICm2XWp1r/BjPQ1iJoVy8tNCvAcini8dQn0Y2Z/50cyWc6oZUJHq+uTVCiEYOcekQ
         iQK8oeTIctWIvwj41/nU9UFs+faEArc4De32YHa7Lq1CGaPoaxwypCz1cIsLdzUYjKaD
         NxiHGobHRqxvVw2Xb1rCivHoaypp8GEAqlfoDvzsa0sFceXT8p6Vh/7/827wZbA76FaC
         csfywcB7ZDUkFEdSKFTQpag2MRCo3YqBFtsznkyuUco+NlLY2oziM+qUY1UsobgOTc/q
         X9dcPiS4ZAkPc+cQoenXNgDHjSblcIQ6Vdfouv5daJhyf4obbiO2Kci1CmQyArQDoKC4
         uFkw==
X-Gm-Message-State: AOAM532blEhBNAw2WYEZydaZpqKXEqrwaa2F4MKSn5L2wh68r2f+b6EZ
        nqnQ1E18pulxJLQUbqMrxFI=
X-Google-Smtp-Source: ABdhPJyg8xeiJ0oeOdbAVFBdxmk82WPM+sVFTo+5lfc0jHeSx+8+84ajd2QUmVYqz2kf5u2MyQ0tKw==
X-Received: by 2002:a17:90a:8c02:b0:1b8:ed69:c2a7 with SMTP id a2-20020a17090a8c0200b001b8ed69c2a7mr9933280pjo.137.1645213929144;
        Fri, 18 Feb 2022 11:52:09 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 19/49] scsi: esp_scsi: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:50:47 -0800
Message-Id: <20220218195117.25689-20-bvanassche@acm.org>
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
