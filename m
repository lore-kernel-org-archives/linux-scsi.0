Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110CEC433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32E1650D6
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhCPD5V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:57:21 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:39317 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhCPD5G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:57:06 -0400
Received: by mail-pf1-f180.google.com with SMTP id 18so7926284pfo.6
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 20:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qo5tsFMy+gBhTZedrYPLx3HlofKn5YmGY6AB6TmW4fo=;
        b=RmGei7IkLkuBJFBo56Dzxn5GdhfB07/3GQf8yMpjXcHpFS8TqEChlo/wqSsAJXTkgr
         1pU6f0+8I1TajRTG27mZR29CmuuwAquhjqaYlFgpfgiPsEDSSk9talZs07PONOvUrGhX
         06icRfrg9cvbnl9wbDTkKc8/IWCwSRKc/PJ0OQrv/TYQIi7kpMtyDMLwmo+201nQ1SjC
         ofj/QZ2nZuL2Wv9SlHnxtJshhrBBjgNcPmZK5bQZ5EH6/EF2fcRlKBAtLntiVciP8UFn
         HXsF+Lw68CdarndVqzEyxhnbjqobfJMrnesI++PTtsV+w5Ok90I9PWbjQjxlhD0pCQFO
         w5Cw==
X-Gm-Message-State: AOAM532Pxot5lKSDsccW8l99q+GJsvACyxETlInl8PXfmJ1o451AIbFe
        AJ5KqiTSXvzUoEo4JEPYlhA=
X-Google-Smtp-Source: ABdhPJxhhIJGJTY/6SDqfSDZii5npshmcbPEp7SsDRGV1ubVpe1fExHkGsazrgfrdEV3dhsBojuhJw==
X-Received: by 2002:a62:1c93:0:b029:1fd:2216:fb45 with SMTP id c141-20020a621c930000b02901fd2216fb45mr26186323pfc.13.1615867025729;
        Mon, 15 Mar 2021 20:57:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:8641:766a:ce30:8278])
        by smtp.gmail.com with ESMTPSA id fs9sm1031673pjb.40.2021.03.15.20.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:57:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 3/7] qla2xxx: Fix endianness annotations
Date:   Mon, 15 Mar 2021 20:56:51 -0700
Message-Id: <20210316035655.2835-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316035655.2835-1-bvanassche@acm.org>
References: <20210316035655.2835-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix all recently introduced endianness annotation issues.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
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
