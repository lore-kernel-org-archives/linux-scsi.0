Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8215EC4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A8BB64F7E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhCQI5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhCQI5U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:20 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB733C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:19 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id r15-20020a05600c35cfb029010e639ca09eso2925331wmq.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yq9LdtQSeW2MqRbyRwlDutR9JIDqTpE5NVbsv5LbNbg=;
        b=QTvzJqmGP9un37sPXvqhxwB1ZGU6Gv6UdUsHx+n59vzvMquKJQ2tfGP+jU7SrhDOBM
         my1FrkaTRKW0odxPHVtxgpvHaQTBiKTB/6cQyKinYknDEJEBThNjq++jJ96kFt35M9Cb
         jlYWeiKqNFKYpfkYnd/A2uCi8K/3TOxPCQpoo8q0Mu61K5JOfWesU13Bqa6HnPcoY7TK
         ji09IcmhD4EsXeY5NuVOn5QNTaoXawO91VkDR4tbRdpj0SGLEc+KVX4FNsyDlkj+32G6
         +a+mIGKDR8YxL291V+0IGF8OTU/BMz7TGJGqcKdm0bnWhEotjGAU5xXcxA7vHdoALoWn
         Ts5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yq9LdtQSeW2MqRbyRwlDutR9JIDqTpE5NVbsv5LbNbg=;
        b=YU6Gz5IgqfW5JsCpt/5ntrwS2NLd/SKGJbHa9eP4dKAG1H+KdvkJW8jFv+YLqPcjqN
         79CIkr1F/XJcE0LTThSuKvE5tttx9N8AktP2Qx6I3GLeJexuDWFw3aPfm5eAGiclq/79
         3J1XpoxcNmfx/qOkLrT6mEG7tKD+c18nM8OBSQ+kaSrp4iivp+2/rv+qrx/AGLAwsfAT
         cpwEDdYVq7gIUt1wF/ajcYGGdxt2bpkeLRj23RzNfRmVcFFsSMWLFTbker1uRlpUoWVY
         Bd+vPgK6KGDBfI/0IZUBxOM/NFD8NBiTm71UbOFy38zOEJv6axciE6bE5sjzfVo82eyJ
         DM5A==
X-Gm-Message-State: AOAM530IRSGDL9TJx1/8ny2Xx3FDosAmET8odxcRvrJBfz9YGHB29JYG
        abVFbo+JR3JvKW5O6UqQd8gqBQ==
X-Google-Smtp-Source: ABdhPJzg8eQxLZE3wpQ/sNOp9p0knU6tUDLEqP9qnzFhu7vqg7pKyp84jaeSsUGEV0QiBg6UN5arew==
X-Received: by 2002:a7b:c1c9:: with SMTP id a9mr2543431wmj.145.1615971438410;
        Wed, 17 Mar 2021 01:57:18 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gotom@debian.org, linux-scsi@vger.kernel.org
Subject: [PATCH 13/18] scsi: nsp32: Remove or exclude unused variables
Date:   Wed, 17 Mar 2021 08:56:56 +0000
Message-Id: <20210317085701.2891231-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/nsp32.c: In function ‘nsp32_selection_autoscsi’:
 drivers/scsi/nsp32.c:584:17: warning: variable ‘execph’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/nsp32.c: In function ‘nsp32_msgout_occur’:
 drivers/scsi/nsp32.c:1785:7: warning: variable ‘new_sgtp’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/nsp32.c: In function ‘nsp32_analyze_sdtr’:
 drivers/scsi/nsp32.c:2227:20: warning: variable ‘syncnum’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/nsp32.c:2223:20: warning: variable ‘synct’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/nsp32.c: In function ‘nsp32_do_bus_reset’:
 drivers/scsi/nsp32.c:2841:17: warning: variable ‘intrdat’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/nsp32.c: In function ‘nsp32_getprom_param’:
 drivers/scsi/nsp32.c:2912:11: warning: variable ‘val’ set but not used [-Wunused-but-set-variable]

Cc: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: gotom@debian.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/nsp32.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index d5aa96f05bce4..54abda4d07c64 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -581,7 +581,6 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	int		status;
 	unsigned short	command	= 0;
 	unsigned int	msgout  = 0;
-	unsigned short	execph;
 	int		i;
 
 	nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "in");
@@ -605,7 +604,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	/*
 	 * clear execph
 	 */
-	execph = nsp32_read2(base, SCSI_EXECUTE_PHASE);
+	nsp32_read2(base, SCSI_EXECUTE_PHASE);
 
 	/*
 	 * clear FIFO counter to set CDBs
@@ -1781,8 +1780,6 @@ static void nsp32_msgout_occur(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int base   = SCpnt->device->host->io_port;
-	//unsigned short command;
-	long new_sgtp;
 	int i;
 	
 	nsp32_dbg(NSP32_DEBUG_MSGOUTOCCUR,
@@ -1796,14 +1793,6 @@ static void nsp32_msgout_occur(struct scsi_cmnd *SCpnt)
 		nsp32_build_nop(SCpnt);
 	}
 
-	/*
-	 * Set SGTP ADDR current entry for restarting AUTOSCSI, 
-	 * because SGTP is incremented next point.
-	 * There is few statement in the specification...
-	 */
- 	new_sgtp = data->cur_lunt->sglun_paddr + 
-		   (data->cur_lunt->cur_entry * sizeof(nsp32_sgtable));
-
 	/*
 	 * send messages
 	 */
@@ -2220,17 +2209,12 @@ static void nsp32_analyze_sdtr(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data   *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	nsp32_target     *target     = data->cur_target;
-	nsp32_sync_table *synct;
 	unsigned char     get_period = data->msginbuf[3];
 	unsigned char     get_offset = data->msginbuf[4];
 	int               entry;
-	int               syncnum;
 
 	nsp32_dbg(NSP32_DEBUG_MSGINOCCUR, "enter");
 
-	synct   = data->synct;
-	syncnum = data->syncnum;
-
 	/*
 	 * If this inititor sent the SDTR message, then target responds SDTR,
 	 * initiator SYNCREG, ACKWIDTH from SDTR parameter.
@@ -2838,8 +2822,8 @@ static int nsp32_eh_abort(struct scsi_cmnd *SCpnt)
 static void nsp32_do_bus_reset(nsp32_hw_data *data)
 {
 	unsigned int   base = data->BaseAddress;
-	unsigned short intrdat;
 	int i;
+	unsigned short __maybe_unused intrdat;
 
 	nsp32_dbg(NSP32_DEBUG_BUSRESET, "in");
 
@@ -2909,7 +2893,8 @@ static int nsp32_getprom_param(nsp32_hw_data *data)
 {
 	int vendor = data->pci_devid->vendor;
 	int device = data->pci_devid->device;
-	int ret, val, i;
+	int ret, i;
+	int __maybe_unused val;
 
 	/*
 	 * EEPROM checking.
-- 
2.27.0

