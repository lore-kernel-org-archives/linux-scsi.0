Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C69C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF96664F18
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhCRD3H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 23:29:07 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:44751 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhCRD2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 23:28:52 -0400
Received: by mail-pf1-f178.google.com with SMTP id b184so2522371pfa.11
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 20:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o7BJY7aujxthvWxs/xiR8rg6myjeVd9MFv+Lm9F3Ikc=;
        b=rqIFZvxFQH4WQsuwasALHk2TdJuzZVJCwqxYzMZAAeSoS0Kj3SVDvUBK1SiSOw4Jdr
         eb1IxXzU0qp5+6e0vdYsuVMDw4Tqtd436HMeu0w1c9wBWVlbXrfQthKns5GE8iJjLbyL
         RB+XQnTIcg8+wxCJKaQZV/KB7g+Wnfp+vBTIYR9v6IRaRs49rxMSkJpCHHHFBfjYI+Nc
         OwcHs4Y24xZoaxdFzPPGPPj0Y92sYpL7Oq2CpBIC8Z4vVK2Q0ajc2uTeiwNv4Uc6RzJd
         6H1NjndCPE3+gJDABoNtQyuFVh3nXAQs2kWzdzOVtO0i+vcs/LfHiQIVisFM9A33mr9+
         bxFw==
X-Gm-Message-State: AOAM5306vp8K717Zn9m1e36tVkdvNTO6eyqkN0fXP7nJ6+EkzPF+wyvR
        FErqLqhcrHtrKMc/hCadSgs=
X-Google-Smtp-Source: ABdhPJwbcPM35Y2oMQDv+nG520eQssjBo2zCZaZHzFyx5c+jk297mNLL2vJs0/JoXXSaVkUgN6LAbA==
X-Received: by 2002:a62:37c6:0:b029:1f0:abe0:8d1c with SMTP id e189-20020a6237c60000b02901f0abe08d1cmr2026505pfa.23.1616038131837;
        Wed, 17 Mar 2021 20:28:51 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7fb2:1f41:ab33:bae6])
        by smtp.gmail.com with ESMTPSA id y68sm473687pgy.5.2021.03.17.20.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 20:28:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 3/6] qla2xxx: Fix endianness annotations
Date:   Wed, 17 Mar 2021 20:28:37 -0700
Message-Id: <20210318032840.7611-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210318032840.7611-1-bvanassche@acm.org>
References: <20210318032840.7611-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix all recently introduced endianness annotation issues.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 2 +-
 drivers/scsi/qla2xxx/qla_iocb.c | 3 ++-
 drivers/scsi/qla2xxx/qla_isr.c  | 2 +-
 drivers/scsi/qla2xxx/qla_sup.c  | 9 +++++----
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3bdf55bb0833..52ba75591f9a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1527,7 +1527,7 @@ struct init_sf_cb {
 	 * BIT_12 = Remote Write Optimization (1 - Enabled, 0 - Disabled)
 	 * BIT 11-0 = Reserved
 	 */
-	uint16_t flags;
+	__le16	flags;
 	uint8_t	reserved1[32];
 	uint16_t discard_OHRB_timeout_value;
 	uint16_t remote_write_opt_queue_num;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8b41cbaf8535..eb2376b138c1 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2379,7 +2379,8 @@ qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 				cpu_to_le32(NVME_PRLI_SP_FIRST_BURST);
 		if (sp->vha->flags.nvme2_enabled) {
 			/* Set service parameter BIT_7 for NVME CONF support */
-			logio->io_parameter[0] |= NVME_PRLI_SP_CONF;
+			logio->io_parameter[0] |=
+				cpu_to_le32(NVME_PRLI_SP_CONF);
 			/* Set service parameter BIT_8 for SLER support */
 			logio->io_parameter[0] |=
 				cpu_to_le32(NVME_PRLI_SP_SLER);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 27165abda96d..0fa7082f3cc8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3440,7 +3440,7 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		return;
 
 	abt = &sp->u.iocb_cmd;
-	abt->u.abt.comp_status = le16_to_cpu(pkt->comp_status);
+	abt->u.abt.comp_status = pkt->comp_status;
 	orig_sp = sp->cmd_sp;
 	/* Need to pass original sp */
 	if (orig_sp)
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index f771fabcba59..060c89237777 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2621,10 +2621,11 @@ qla24xx_read_optrom_data(struct scsi_qla_host *vha, void *buf,
 }
 
 static int
-qla28xx_extract_sfub_and_verify(struct scsi_qla_host *vha, uint32_t *buf,
+qla28xx_extract_sfub_and_verify(struct scsi_qla_host *vha, __le32 *buf,
     uint32_t len, uint32_t buf_size_without_sfub, uint8_t *sfub_buf)
 {
-	uint32_t *p, check_sum = 0;
+	uint32_t check_sum = 0;
+	__le32 *p;
 	int i;
 
 	p = buf + buf_size_without_sfub;
@@ -2790,8 +2791,8 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 			goto done;
 		}
 
-		rval = qla28xx_extract_sfub_and_verify(vha, dwptr, dwords,
-			buf_size_without_sfub, (uint8_t *)sfub);
+		rval = qla28xx_extract_sfub_and_verify(vha, (__le32 *)dwptr,
+			dwords, buf_size_without_sfub, (uint8_t *)sfub);
 
 		if (rval != QLA_SUCCESS)
 			goto done;
