Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2356AC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354132AbiBKWd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354118AbiBKWdw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:52 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B96D52
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:50 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id qe15so9288450pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o/DjmKMEQ/TICGYiG1zbJphAMWsxSd5D/VpqW7WFmMA=;
        b=IdX7/TmK1HYnmE0peXt1u6EwyDZ1FLAigk2gK2ZDIkbp44YlOnVQbokPw41Tv4XbHm
         3kAoAhheSeP53STw25Gi6BFqEGOdLnRGoIaWYMjQVkorUvdxuBNdQHosjiwvmzd6ZwAt
         jEMvmbqfRuNt0mc0r62tiil0Q29N5EqIr5gfkXnqnBadAhn0+xehFxq7WucK55918d9/
         hdHn3t9RFAeCcNsLmVIyxW55vROnfu+bvcSvvkur7r7JhyWdc5QsRJwZB2T57+cxM1+t
         bKb7efJfct5dVzELWb1/D7HAH2JzjZFgRXKjNQL/exaAya3eilMjNqHzs3m9sroHl0a0
         oFEA==
X-Gm-Message-State: AOAM533NWqvl9IXirpYIsZwA7ts4cwAKAZb6CkKhShQ0lySxWnpZrvSu
        lerbugmbMIIVJzKEAmq8ito=
X-Google-Smtp-Source: ABdhPJxW1GcFWSo0gmMCi1X4D4ogrT/c/Yb51BRakoa/i+ZrJLNGyoJqB0UF9cq1ZkTL6WBR3EKvuw==
X-Received: by 2002:a17:903:1212:: with SMTP id l18mr3588662plh.77.1644618829709;
        Fri, 11 Feb 2022 14:33:49 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 20/48] scsi: esp_scsi: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:19 -0800
Message-Id: <20220211223247.14369-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
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
