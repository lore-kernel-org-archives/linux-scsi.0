Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDE5C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D3261164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344975AbhIRAJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:23 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:34563 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344221AbhIRAJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:16 -0400
Received: by mail-pg1-f171.google.com with SMTP id f129so11149416pgc.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RgGlM8P/QQlRdlbgU8H0YeA1POp4/CiTfwOXkTtPbSg=;
        b=TJG74ZyiATR+igQnq6S6a5oaaO/6oGfDkwIsiDnclr0vL5JeKals9fleDb+QzY7N1j
         3qJhD2C1yW80w5CHEFVtiHLPA7UzKl5W/TpBD4CKNzd/hia04Nz16ONYsAkd66SZUpJ9
         MLTHJ+SvUardXa+K4FJ/a2qDMkLQyZy+eguVJXpdFJenP+QYfTPkQ6WP8noFTWxmsoTQ
         g3q5NK6Oo+n2326i+hK0+fKyt0ag2+SO2NR7Ky7sBxJDakGP19xcYf01D8ll74igJcWF
         +vdkab8iEjtBYebWvLNW5YC4gujuTjzOc8TzargoIKfZ99qB1tQ5lhThFyZKiKAdCKEF
         srbA==
X-Gm-Message-State: AOAM532/dRz5gbwwzqHw3lba+VbuwMyS1ytHjwT7UmUT3+Nyfg45qa1C
        yr1UiqSi1SVsWGDkXQOk7WY=
X-Google-Smtp-Source: ABdhPJyk2aHeUEBNrtHF62rnZ2ZyZNXd4K6yMUVFnMwzjCAxyFQu/G1qlmJo9ekoSZDC5l4lO4c2SA==
X-Received: by 2002:a63:f80a:: with SMTP id n10mr12075347pgh.303.1631923673620;
        Fri, 17 Sep 2021 17:07:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 58/84] pcmcia: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:41 -0700
Message-Id: <20210918000607.450448-59-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pcmcia/nsp_cs.c       | 4 +---
 drivers/scsi/pcmcia/sym53c500_cs.c | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 7c0f931e55e8..0271d534133a 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -178,7 +178,7 @@ static void nsp_scsi_done(struct scsi_cmnd *SCpnt)
 
 	data->CurrentSC = NULL;
 
-	SCpnt->scsi_done(SCpnt);
+	scsi_done(SCpnt);
 }
 
 static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
@@ -197,8 +197,6 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt,
 		scsi_bufflen(SCpnt), scsi_sg_count(SCpnt));
 	//nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "before CurrentSC=0x%p", data->CurrentSC);
 
-	SCpnt->scsi_done	= done;
-
 	if (data->CurrentSC != NULL) {
 		nsp_msg(KERN_DEBUG, "CurrentSC!=NULL this can't be happen");
 		SCpnt->result   = DID_BAD_TARGET << 16;
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index a366ff1a3959..d2adda815d7b 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -492,7 +492,7 @@ SYM53C500_intr(int irq, void *dev_id)
 
 idle_out:
 	curSC->SCp.phase = idle;
-	curSC->scsi_done(curSC);
+	scsi_done(curSC);
 	goto out;
 }
 
@@ -556,7 +556,6 @@ SYM53C500_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	VDEB(printk("\n"));
 
 	data->current_SC = SCpnt;
-	data->current_SC->scsi_done = done;
 	data->current_SC->SCp.phase = command_ph;
 	data->current_SC->SCp.Status = 0;
 	data->current_SC->SCp.Message = 0;
