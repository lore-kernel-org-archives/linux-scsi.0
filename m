Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65356C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E97F64ED2
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhCRD3H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 23:29:07 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:51930 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhCRD2u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 23:28:50 -0400
Received: by mail-pj1-f44.google.com with SMTP id s21so2188812pjq.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 20:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M3i/A8wZJUkDAs/8j8jYvPjyybv7H7EXp/+fIitr3iE=;
        b=NCgE6Yc9kVoDZFzU2FBiKJhKClkDqhsZRJRo8h7r0OGaJJSLH5kjPrYnIA/HLUCy+M
         zGVtnRytnAK7HzNXnEmPr//6Uio7NrIClbIJ71Nu75zFGhFrJFD3zwSZTyoFmNQRiS86
         /sa8BMnQ98IYiWSSIeFCsMbuiyHMjrKXCE5+30vKtSz0L5fN8J7c7uu9PAP7ORHDZ/qU
         AMtY3HrKEfQLI7KRPIPk9AVvZKEN6ItazpkPb9ZvuyIkfQ4HL8TGqo2YogtWiIWqGrBR
         85glOu73cj3GXSYnX1DME585GBCdxVBH8khUE89K5BgCo4iXJAF6V+kjPBE3eoXAdSoU
         Pstw==
X-Gm-Message-State: AOAM53010S/5YszCg6ZZNFPu+agUgQAPfwFLV2+u7k1oxmwXuRljzxYu
        kLvaaVLgyXzHIQR6xzuqBLY=
X-Google-Smtp-Source: ABdhPJwSj2xyWKWkqvkeYkQWL1o+8gnSZyQcrRQy3LXvCBXXR2TVnBDQUwWFXgGwbxKuahl3uG3oCA==
X-Received: by 2002:a17:90a:bb95:: with SMTP id v21mr1987944pjr.30.1616038130352;
        Wed, 17 Mar 2021 20:28:50 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7fb2:1f41:ab33:bae6])
        by smtp.gmail.com with ESMTPSA id y68sm473687pgy.5.2021.03.17.20.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 20:28:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 2/6] qla2xxx: Constify struct qla_tgt_func_tmpl
Date:   Wed, 17 Mar 2021 20:28:36 -0700
Message-Id: <20210318032840.7611-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210318032840.7611-1-bvanassche@acm.org>
References: <20210318032840.7611-1-bvanassche@acm.org>
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
