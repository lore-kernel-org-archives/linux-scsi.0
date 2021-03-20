Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18C2C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864386193A
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhCTXYR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 19:24:17 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:42893 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhCTXYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 19:24:11 -0400
Received: by mail-pj1-f41.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so6646593pjv.1
        for <linux-scsi@vger.kernel.org>; Sat, 20 Mar 2021 16:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZIy6YnsiJ3Xs2uIxtZucjE2JC0EXqWKLMqKMxE5zEtc=;
        b=fe5kymHgO3DA2AymkKhKY17T4zkweFe4IGZd0DC8i3RJvz1IF2bMMHfRwl1LZwLsc/
         PFesQSwyvhclrVA3hSfHT2b+jjpuX9TDHXiIi0MlsEsM71YGGTPK9JDoUwBHi+/jGHyS
         A8whda/AnY4t+EShBb9P6FWAIFW4mftFvSeFdcznY9jx7QYHvDr3GSL9vpk9w5DaeblL
         cAkUooIYmKOnO8PIHFpmYij1q6D8Llj2RIBMDpVADf5xTVY8C/pLtYCYK+uV0NrJc3EU
         xAU7TwvDaHenEaNO9pTwqZcUZtPeMI1bGb7y9DtjCsodrmMWOFIhn9n9rWa4FDaos13c
         7ong==
X-Gm-Message-State: AOAM5332qiRMYSu7BPnJcSmWGqLsnNm5bJryR8sTA+Cd2lBFLcoeR5d1
        L2uELnBCu5uWZG3a7DMCe2g=
X-Google-Smtp-Source: ABdhPJyNndDqvqdNwszN3TImUABK6QRFwur1zJ3Ny21R81iQyZModQCHFKgIsZN8HgScxvObW5Bcbw==
X-Received: by 2002:a17:90a:fd0a:: with SMTP id cv10mr5381432pjb.167.1616282651499;
        Sat, 20 Mar 2021 16:24:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:9252:a76b:2952:3189])
        by smtp.gmail.com with ESMTPSA id u7sm8869159pfh.150.2021.03.20.16.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 16:24:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH v3 3/7] qla2xxx: Fix endianness annotations
Date:   Sat, 20 Mar 2021 16:23:55 -0700
Message-Id: <20210320232359.941-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210320232359.941-1-bvanassche@acm.org>
References: <20210320232359.941-1-bvanassche@acm.org>
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
Reviewed-by: Lee Duncan <lduncan@suse.com>
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
index e765ee4ce162..c89e6d0f3616 100644
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
