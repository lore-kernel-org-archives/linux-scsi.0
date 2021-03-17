Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACCEC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9853964EF3
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhCQJLx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhCQJLc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:11:32 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A00C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:32 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e9so991890wrw.10
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yq9LdtQSeW2MqRbyRwlDutR9JIDqTpE5NVbsv5LbNbg=;
        b=tpXmr/3C3OcqQCVeq61T0tdQB5GGsCi1oEXXqsBAHnj1+8fWfYQ3PnETf0ZT0/Wwc3
         FYgaiWmZdQW7HwXia9kpjpa3xGpM4zOxqAH5iraA9ZzjIfnS+mBosrDEfQTlonv83DoM
         jcFR93qm3o4tD7sWSCWizMLul9CH0tkp3hSUO822Q+Rn2YsAsWF7pdHyOz/RIutRMkSu
         hbam9GlxyOV34SBHXze1iGCQcyn1z2eAEtPANih19rc7lKHWmCpy9IqSjpZB0/btrrCL
         RfdydvVYMCG2CCl4clrCbv7c6haoLrVpQsFrTU7bpptlqKCz2SBvOF/m11j86/Iysviu
         wf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yq9LdtQSeW2MqRbyRwlDutR9JIDqTpE5NVbsv5LbNbg=;
        b=RCKpBEZW9J9BNT9GO5pmPXTyq1+JTl2ZuREO7rPmZFMHmUo4gdDWaPTX6bItZSGcir
         O/Lc7QU0X754c4/N6HpWn8Pv3fIzpz40LN4+vhLzuJSZbPKSSrR0A7cXdvcAtC7r9cfr
         yh6psZX9GFRWl7q7p/liMXia8HpsUqCJXIQnFb1QzLcbY3tHWnJt+VC3SkSHF6b7T4g3
         +feQ0PevvNaY7HisMRG/dnCf0dUUItZrWBKgj0S2wdDFXC/r0YEXWueGrpUQ7sARIxxp
         GuuWo5CiMIeItcYFQHSf/33kPFfv1+7g6LOq/45i9cSa+/2a56oCRCRfh7M2Gqsp4jPz
         z9eg==
X-Gm-Message-State: AOAM530sB94r/N4VLcrq8A/JeZ4z0Ev3aQ+5S7hh8N2VvblI+CF/WydT
        0jBKHwZ84vQYzoaTY8XBH7zAoQ==
X-Google-Smtp-Source: ABdhPJyME/VIATukQgzalo6A4MWfZ4MkMVX/KZMJJ8cyrNXbbBEYgNE9Qz1bcMh+mR9Dbxdnl2wh2A==
X-Received: by 2002:a5d:5250:: with SMTP id k16mr3311603wrc.309.1615972291167;
        Wed, 17 Mar 2021 02:11:31 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id s83sm1709279wms.16.2021.03.17.02.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:11:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gotom@debian.org, linux-scsi@vger.kernel.org
Subject: [PATCH 3/8] scsi: nsp32: Remove or exclude unused variables
Date:   Wed, 17 Mar 2021 09:11:20 +0000
Message-Id: <20210317091125.2910058-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091125.2910058-1-lee.jones@linaro.org>
References: <20210317091125.2910058-1-lee.jones@linaro.org>
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

