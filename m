Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38020C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15022600EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhFSAyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 20:54:55 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:33608 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhFSAyz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 20:54:55 -0400
Received: by mail-pl1-f176.google.com with SMTP id f10so3427237plg.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 17:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PMDaYpLYt4JkjA4HmKwzmbxRcR4IlRXyCDb8XJ8mvmU=;
        b=eDnYAiU3RDPOjD45u4Atmagsf1WMWN1nYNiTJzoE8blBSxMbn+5YHNPZDGnVlKqKLA
         grke5xkdgK/ZyizXihZ4DFGA2La3salQEuV0TbBruX5ozRVNPjxrEZPgUjPZke2WR5/U
         VxuBue1irDSgkaF5HisATypdGpZoZJciyub9Ku5QRDmIlSQS6MYv1/LnyEdwdL1r1lx5
         syMsnTeyrs8IbNlTaNHMyHCfOI9JC2eKcqPL5um8MulIUF4coI9PwW1df27XgJp9pYUQ
         bh4sWcUwjftwwDkFc6zYFJe/7nZzronySoA7LzftYZZ9pckse3udiviAMHJOp9O6RfNl
         DN1A==
X-Gm-Message-State: AOAM531UwKl6lt6DIaiUSPLGJP0RnAJLxOVQ303B0M6xUGcz0q5N3COl
        c8w0MAgJ2HWT7CBpv5dqF1c=
X-Google-Smtp-Source: ABdhPJw6DDfL0B7bEqbev7RJkez/IOamSkTOSNq7AdEvJvzkLQxulhaPUyqL+2IwWZu/TEy/Iua3Ww==
X-Received: by 2002:a17:902:bcc9:b029:11b:d8a8:e54 with SMTP id o9-20020a170902bcc9b029011bd8a80e54mr7201952pls.72.1624063964866;
        Fri, 18 Jun 2021 17:52:44 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p6sm9934460pjh.24.2021.06.18.17.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 17:52:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Gilad Broner <gbroner@codeaurora.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH RFC 2/4] ufs: Remove a check from ufshcd_queuecommand()
Date:   Fri, 18 Jun 2021 17:52:26 -0700
Message-Id: <20210619005228.28569-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619005228.28569-1-bvanassche@acm.org>
References: <20210619005228.28569-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
shost->can_queue to hba->nutrs. In other words, we know that tag values
will be in the range [0, hba->nutrs). Remove a check that verifies what
we already know. This check was introduced by commit 14497328b6a6 ("scsi:
ufs: verify command tag validity").

Cc: Gilad Broner <gbroner@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c230d2a6a55c..71c720d940a3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2701,21 +2701,11 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
  */
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
+	struct ufs_hba *hba = shost_priv(host);
+	int tag = cmd->request->tag;
 	struct ufshcd_lrb *lrbp;
-	struct ufs_hba *hba;
-	int tag;
 	int err = 0;
 
-	hba = shost_priv(host);
-
-	tag = cmd->request->tag;
-	if (!ufshcd_valid_tag(hba, tag)) {
-		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
-		BUG();
-	}
-
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
