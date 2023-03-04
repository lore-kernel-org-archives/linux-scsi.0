Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C07C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjCDAei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjCDAeH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:07 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1459D410B8
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:50 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id a2so4551094plm.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+4v/C2RuRmCm2hrk+4AAfVZyUrantTB0vKA7PER/Cs=;
        b=xOcJSNhGgFBJJO02ss6qnfK3wHR9Mt0m+Oj7K18epozMcldBO8hd6ln7hP5Mkt6mIO
         zbpOEX5ompxoHYburEHvGnz3YTSC5c7QdBtsST2RhE2pmr+RKpgS9EYT4vbWLvTAEitv
         fzC2DdX9DRsFl+qie713gfGboacHtXPngmws3RNQq1ViZPGwdQpk89aJhPkbraqqzUlS
         PM6JmeomoeIT9/22lbOJJPEMo6mNuvkKAvcKaLRv6nD5Td8/r+asKIUj6mApuI80Njrv
         TqjSjVG/vb7+rCfM4VjwTdEM2AsczsVxLYYJYowLr9nt1Q2rMuXmhaBMeBsyhM2mRJiL
         VBBg==
X-Gm-Message-State: AO0yUKWC/mKaD5B5TZCQ04Aw2HdwMLAJ3ci1oYgUUPrpZGoRXnQaPdFc
        qO975/vO/JKu/38pO+j9c5Y=
X-Google-Smtp-Source: AK7set/+JbsIXirJfgkKaEXZBYHOQ9ZmLVXAw0ZopSP28rA0+2pgrJGkTJuiFjwSBJ6Q4kryj0k66A==
X-Received: by 2002:a17:903:18e:b0:19a:75b8:f4ff with SMTP id z14-20020a170903018e00b0019a75b8f4ffmr4650936plg.35.1677890017562;
        Fri, 03 Mar 2023 16:33:37 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:36 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 49/81] scsi: mac53c94: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:31 -0800
Message-Id: <20230304003103.2572793-50-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mac53c94.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index f75928f7773e..6a019132109c 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -392,7 +392,7 @@ static void set_dma_cmds(struct fsc_state *state, struct scsi_cmnd *cmd)
 	mac53c94_priv(cmd)->this_residual = total;
 }
 
-static struct scsi_host_template mac53c94_template = {
+static const struct scsi_host_template mac53c94_template = {
 	.proc_name	= "53c94",
 	.name		= "53C94",
 	.queuecommand	= mac53c94_queue,
