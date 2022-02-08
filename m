Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9FAC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384300AbiBHR0Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384342AbiBHR0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:22 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B55C061576
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:10 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id m7so16953954pjk.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GOteDyg9anUEULJ6exhn8l6nwBwf6p+GqROBYTnbYHE=;
        b=GCxUMvrFLdkZ3rXUpr8JHD8SSoMq+jWHt5K3ONX0m0uykyMAUtp2ShdBbnKHqrz6TM
         aR8sP/DlgP4sRjfj4fGzaMB+92Q2aYsVEPftPPHiXwFo7g3bRgw7SBbNd15l1m0CRqDa
         CSGYQOkkzhnmW/+AlEARfqZ2NUqUl+CD+E0V35gURCPjUy8T7bsRIumJCUp/QE5K55OL
         MHxqi4jbxs2kR1QL2iWWwX80MLXZkbn6MKZMxo9jisvkWZcA+Vwv3UtyDp+2IRHi79SG
         uVPbpzl2iF4qFwWdIPud1sD6J8hL0ujfuh9Qz4J5JZVY8iOg4ZjZXl4qqppaSOQS/7so
         EWnw==
X-Gm-Message-State: AOAM5309zjsF1/JLHMfOgh8t7mrqRPFzIJOo3fpO4Cmp5FSJn80Wkv1F
        5IRF2CozGV1kRFpanMUNTno=
X-Google-Smtp-Source: ABdhPJwNvQL4VoqiIylZp3V13HKfGijwdstaBq3NZwcZdjrA9pN/hV+AMfNa9PTHz4pb6ffbCXsM1w==
X-Received: by 2002:a17:90b:4f87:: with SMTP id qe7mr2537919pjb.114.1644341169667;
        Tue, 08 Feb 2022 09:26:09 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 16/44] esp_scsi: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:24:46 -0800
Message-Id: <20220208172514.3481-17-bvanassche@acm.org>
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
