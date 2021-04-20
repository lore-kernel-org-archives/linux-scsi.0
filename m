Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5CDC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63D03613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbhDTALh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:37 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41622 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbhDTALD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:11:03 -0400
Received: by mail-pg1-f176.google.com with SMTP id f29so25378311pgm.8
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hgmmIxs0c1ez3RIdaPx1kdyAZEy0b/uscgx4RAxSGxo=;
        b=E4odC95g7V0nXS+mh6alYJXw5ZwnHOQIaqQsfJ3VyXGy+2MQri/E4Dcv5h1+ThP5Mz
         MTHF+W6Ii2ZHPI2lGKgWVNtEkcJx2KP2Uar9mHZ/hQ4QdFdWhPTMfBqFxSSLpH9pFqGr
         7c3De5UGNk69P6X0iu4kdbOJWa/zwRqfkyKGQ/gIG6rRXxZdPWaaBvd/nRwpgsvrP9mq
         zKEoqy+vfnZYZhmBiox9iqsv/DZPHlLgpGhPzkd9hFhJYXrQdw6SaQNjsbQhVwbvjpUJ
         zMFNVU/hJUFCEzFUXslJjjeacWZsV1B+nMswEzO7j6MW22mflUKr4LVgGYeJY2QT/gsb
         /b7g==
X-Gm-Message-State: AOAM530R4K+rkc8oA6vp5DNRoOHpCT01PcuLj2BT/VYr/91bbzXRkTWK
        Wy4/JcFhTosMBiyJ0sw9UPY=
X-Google-Smtp-Source: ABdhPJxtlxq5pJAfLKtryfnYfXSeyFuRUbHlw9aOgyeg+6z7M5p6VxVfX0NRBHdKlUBKFScbzfRd0A==
X-Received: by 2002:a63:e405:: with SMTP id a5mr10555561pgi.89.1618877432188;
        Mon, 19 Apr 2021 17:10:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 087/117] qlogicfas408: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:15 -0700
Message-Id: <20210420000845.25873-88-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: GR-QLogic-Storage-Upstream@marvell.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qlogicfas408.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 136681ad18a5..67229b661224 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -415,7 +415,7 @@ static void ql_ihandl(void *dev_id)
 		return;
 	}
 	icmd = priv->qlcmd;
-	icmd->result = ql_pcmd(icmd);
+	icmd->status.combined = ql_pcmd(icmd);
 	priv->qlcmd = NULL;
 	/*
 	 *	If result is CHECK CONDITION done calls qcommand to request 
@@ -444,7 +444,7 @@ static int qlogicfas408_queuecommand_lck(struct scsi_cmnd *cmd,
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
 	if (scmd_id(cmd) == priv->qinitid) {
-		cmd->result = DID_BAD_TARGET << 16;
+		cmd->status.combined = DID_BAD_TARGET << 16;
 		done(cmd);
 		return 0;
 	}
