Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA77C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6655460F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhHIXEm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:42 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:42525 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236275AbhHIXEm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:42 -0400
Received: by mail-pj1-f47.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso2419212pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMU1nyjWq5Jlh7zpL+CIAOJ5GCQxrtVeYG6NNSO5MGA=;
        b=ELpUbGLIgQCCkF3V+3INE1rrM9J7/14B4uRR0hw8fPVwmRT4968eGBIbVp3Se9kdxA
         QuM4nmFQTQC8PcW9tb8gVyefQ9X4xo6is71PuwBj7Qi7ANa3x10CX9UkN3HCTGHVdnud
         8U75Hd4Q7p++Y1SG/Fx48IuDLprQ1deZM0KYeG+XOnnO47DepMf5rcIuc3bfD9br563F
         DTSgJ14FVzPn5nbMSkaf1mKN81YMazTPNacFGXgkd+jgTpShlDjrEQ9FMC9HnHSiws3m
         DCUS1XWZltXjCAFPqN0+oNbjru7RK24BlK26uDlgge2gOgwDzJpjkjivIiVbYKEAJizL
         AFGQ==
X-Gm-Message-State: AOAM532KFYuX/BXvyi3F54tNyvFI6oj0SD49idnqyythHSdffQg/PMsB
        yJcVWpIwM9l0k0FaCoG8zDg=
X-Google-Smtp-Source: ABdhPJwFKrL7cAezex2PRhYZbGdT5KP8i5fmxxQt5gECm4dW9FwfHUXDkfZT3wLyMKGOnN0tuxb2Yg==
X-Received: by 2002:a17:90a:a63:: with SMTP id o90mr11950692pjo.167.1628550261079;
        Mon, 09 Aug 2021 16:04:21 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 12/52] NCR5380: Use sc_data_direction instead of rq_data_dir()
Date:   Mon,  9 Aug 2021 16:03:15 -0700
Message-Id: <20210809230355.8186-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for the removal of the request pointer from struct
scsi_cmnd and does not change any functionality.

Suggested-by: Finn Thain <fthain@linux-m68k.org>
Acked-by: Finn Thain <fthain@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.c   | 6 +++---
 drivers/scsi/sun3_scsi.c | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 3baadd068768..a85589a2a8af 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -778,7 +778,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 	}
 
 #ifdef CONFIG_SUN3
-	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
+	if (sun3scsi_dma_finish(hostdata->connected->sc_data_direction)) {
 		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
 		       instance->host_no);
 		BUG();
@@ -1710,7 +1710,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				count = sun3scsi_dma_xfer_len(hostdata, cmd);
 
 				if (count > 0) {
-					if (rq_data_dir(cmd->request))
+					if (cmd->sc_data_direction == DMA_TO_DEVICE)
 						sun3scsi_dma_send_setup(hostdata,
 						                        cmd->SCp.ptr, count);
 					else
@@ -2158,7 +2158,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		count = sun3scsi_dma_xfer_len(hostdata, tmp);
 
 		if (count > 0) {
-			if (rq_data_dir(tmp->request))
+			if (tmp->sc_data_direction == DMA_TO_DEVICE)
 				sun3scsi_dma_send_setup(hostdata,
 				                        tmp->SCp.ptr, count);
 			else
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2e3fbc2fae97..9ed0bb7ecece 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -366,8 +366,9 @@ static inline int sun3scsi_dma_start(unsigned long count, unsigned char *data)
 }
 
 /* clean up after our dma is done */
-static int sun3scsi_dma_finish(int write_flag)
+static int sun3scsi_dma_finish(enum dma_data_direction data_dir)
 {
+	const bool write_flag = data_dir == DMA_TO_DEVICE;
 	unsigned short __maybe_unused count;
 	unsigned short fifo;
 	int ret = 0;
