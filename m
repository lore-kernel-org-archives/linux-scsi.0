Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C15C433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96DB46193C
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhCTXYQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 19:24:16 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:45824 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCTXYK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 19:24:10 -0400
Received: by mail-pf1-f172.google.com with SMTP id h3so8424545pfr.12
        for <linux-scsi@vger.kernel.org>; Sat, 20 Mar 2021 16:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pICydD/oUCdcAvPVq02w89w/ZtGr0pZrWAsPFMD7kYk=;
        b=oWQu7IeUg6BXDrkzisM2IPbG/2iR8W/WDaLlFxlv+wmOZm34/3QH1pQKmgmugbkIxh
         z8St/80aH4guj2KlwCihQGJaOl3BgZ//59gyT7y1yncX9hmQG2nvax3sRLiOcYx5vGqq
         eRxcIeN3YrMmpRUwwlcP/Y0ubn8KPWgOO/fGRHYdnBtLHk+GS2FNBrasvHYZRKYFE1kk
         hlt4bD9L6GHS4HcQQXujVaV5hKsd/XKGgUmx/Yte5TfbnAptMIV2eMl8wFThJ7O368kH
         5YSYbVjgPglYxEqBcIjMg10EweCZIsMYM2ms6KqJ46t3QmMbuAbz7tJmS2Yhz8wgTv/n
         k4pA==
X-Gm-Message-State: AOAM530lqoAHwKSEMzNfZb0lP4Vo96Ldj4empLzSasTxdLFoLgLYChh9
        RfjwxzI+FINMktXM/nlZGeU=
X-Google-Smtp-Source: ABdhPJz4yPqnRwLq3/dBQTYu2991SgJiGoj7+Z6jmnDo2zhONwpmL3CtVMfBQ5IOhD+kIy3Iu/oBMg==
X-Received: by 2002:a62:5f85:0:b029:204:99fa:3371 with SMTP id t127-20020a625f850000b029020499fa3371mr15352205pfb.1.1616282650012;
        Sat, 20 Mar 2021 16:24:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:9252:a76b:2952:3189])
        by smtp.gmail.com with ESMTPSA id u7sm8869159pfh.150.2021.03.20.16.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 16:24:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH v3 2/7] qla2xxx: Constify struct qla_tgt_func_tmpl
Date:   Sat, 20 Mar 2021 16:23:54 -0700
Message-Id: <20210320232359.941-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210320232359.941-1-bvanassche@acm.org>
References: <20210320232359.941-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the target function pointers are not modified at runtime, declare
the data structure with the target function pointers const.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h     | 2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 49b42b430df4..3bdf55bb0833 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3815,7 +3815,7 @@ struct qlt_hw_data {
 	__le32 __iomem *atio_q_in;
 	__le32 __iomem *atio_q_out;
 
-	struct qla_tgt_func_tmpl *tgt_ops;
+	const struct qla_tgt_func_tmpl *tgt_ops;
 	struct qla_tgt_vp_map *tgt_vp_map;
 
 	int saved_set;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 15650a0bde09..46111f031be9 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1578,7 +1578,7 @@ static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
 /*
  * Calls into tcm_qla2xxx used by qla2xxx LLD I/O path.
  */
-static struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
+static const struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
 	.find_cmd_by_tag	= tcm_qla2xxx_find_cmd_by_tag,
 	.handle_cmd		= tcm_qla2xxx_handle_cmd,
 	.handle_data		= tcm_qla2xxx_handle_data,
