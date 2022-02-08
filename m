Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D33C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383387AbiBHR1Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381363AbiBHR1M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:27:12 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D981FC0612C2
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:55 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id y15-20020a17090a474f00b001b88562650aso1988085pjg.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AJ7TX03i+4PCsxfhFkr/PkiTjDmY8w4ec03p1Ruvg34=;
        b=MRjCHeHb4QgXOEmj5T+LxcM7LNFkVSX1Dd2VEu7dHUXBd3Jm4Nu3WHHREXUrUignKE
         6Lrp43rnFZFyJ9zyCmBFI8AsyKoUiMfI/nU79Xp/pspvsrWNnxBzEx578+/hBJNhsl6K
         G2aSEcd9CBS7sDn2BYTRPQ67KGYfmkN0lp9aR6iCbyzApAHrBV936TAIZn3SmYgjmmjm
         64Ms5rU38jpVagRwZSEkFD1n9flNPzf/YIzfd8O2BfB8kpp5yEiOcMPMDmAfFSjeEHax
         wJWQIOItLx2mQgWncHveB4OFinitI5akgMcc2SjVgCI0tXWNaY/LcFmvINtLlaej2u3j
         RYkw==
X-Gm-Message-State: AOAM531WRcmbe+iUZRAEOaoCyulf52ILJlQPqV7wDTlvF86850sNNWRU
        Nus6vtSkJccGr88mCg9qcpA=
X-Google-Smtp-Source: ABdhPJyaBYdIz4ccdAmrB9HLG8uVMO3gqwUkw5l3bGcn/e6gXxgs91PW5CQr4kd06MQf1lW2z64u3w==
X-Received: by 2002:a17:903:1212:: with SMTP id l18mr5636085plh.7.1644341215182;
        Tue, 08 Feb 2022 09:26:55 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Reviewed-by : Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 39/44] sym53c8xx_2: Move the SCSI pointer to private command data
Date:   Tue,  8 Feb 2022 09:25:09 -0800
Message-Id: <20220208172514.3481-40-bvanassche@acm.org>
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

Cc: Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index b04bfde65e3f..2e2852bd5860 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -118,7 +118,7 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
 	struct completion *eh_done;		/* SCSI error handling */
 };
 
-#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
+#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)scsi_cmd_priv(cmd))
 #define SYM_SOFTC_PTR(cmd) sym_get_hcb(cmd->device->host)
 
 /*
@@ -127,7 +127,6 @@ struct sym_ucmd {		/* Override the SCSI pointer structure */
 void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
 {
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
-	BUILD_BUG_ON(sizeof(struct scsi_pointer) < sizeof(struct sym_ucmd));
 
 	if (ucmd->eh_done)
 		complete(ucmd->eh_done);
@@ -1630,6 +1629,7 @@ static struct scsi_host_template sym2_template = {
 	.module			= THIS_MODULE,
 	.name			= "sym53c8xx",
 	.info			= sym53c8xx_info, 
+	.cmd_size		= sizeof(struct sym_ucmd),
 	.queuecommand		= sym53c8xx_queue_command,
 	.slave_alloc		= sym53c8xx_slave_alloc,
 	.slave_configure	= sym53c8xx_slave_configure,
