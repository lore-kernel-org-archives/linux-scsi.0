Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D65C43381
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2FC4650D4
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhCPD5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:57:20 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:45177 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhCPD5E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:57:04 -0400
Received: by mail-pg1-f173.google.com with SMTP id p21so21731592pgl.12
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 20:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jb2TJqBiyE4weUAnP+nA0nwybstPDQ+vHstqjwgy1as=;
        b=csFn0Icwq6XRs4F5gDFClwxml07T3oRoXTGIic+Ac+jKTtFEX437UTp/pdhFHBCTeU
         3fMLWmCWGZAAdASlWzz6hTEcSQ+NMwIGNdxtUk7gTyzTqFYlyZdUoMhPYnvCatzMHJvr
         wJkX3r2+HYlOsVObD58vkz5UaYLRuI6QLyWndTLQIf92wbyG3Yvx7fDH5rLurmCCmWXa
         GDqX6B9a0F1uW1/1HolckymzskFdqJaF8lekWmxv6JdXU8kA+FwfHYsOy2uWB8QyYudD
         yBhDWVBMkzxEOAX01fnpQpJWBjX4VXgTJy6XIzWA/+17mcTJYRor/egOgtubQyvWLFnI
         FQcQ==
X-Gm-Message-State: AOAM532XZ9xqbjRZkbn4zrwN9tX4aZfzm4JPU6zXbw61utKUbG3+4noa
        QLXKYUortjp5FCEpLo7nibU=
X-Google-Smtp-Source: ABdhPJx6x0mUH7AIbg9Jpc0K8NAlBHT9vryGakOgpHLQt7IFZddd17VbaYNqfMHTDpkigoeDlIzjMA==
X-Received: by 2002:a62:8203:0:b029:1f1:5ceb:4be7 with SMTP id w3-20020a6282030000b02901f15ceb4be7mr13433873pfd.48.1615867024334;
        Mon, 15 Mar 2021 20:57:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:8641:766a:ce30:8278])
        by smtp.gmail.com with ESMTPSA id fs9sm1031673pjb.40.2021.03.15.20.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:57:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 2/7] qla2xxx: Constify struct qla_tgt_func_tmpl
Date:   Mon, 15 Mar 2021 20:56:50 -0700
Message-Id: <20210316035655.2835-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316035655.2835-1-bvanassche@acm.org>
References: <20210316035655.2835-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the target function pointers are not modified at runtime, declare
the data structure with the target function pointers const.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
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
