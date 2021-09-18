Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BC8C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA6EA60F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344061AbhIRAJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:03 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:47009 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344612AbhIRAIs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:48 -0400
Received: by mail-pf1-f181.google.com with SMTP id 203so2789123pfy.13
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p2HaRX5pPHaZGfEsseY/SfrdWg8TP+livibGzd6jccs=;
        b=MvqdlGRxO30ZHZ3nmEGEPi5hM418rq4cm9JCVWxXW4WXkHyi1bfy9O+0m6ti50lWRl
         PJI35UIxkriFLqSM6+ut1TexHnPt577rq0ToPc3gcGlH1IBwKOf8dXGExMbKdxDyMPS6
         9jSCOaDGYlMzmBYfM17budmI34+cDzGyEgA2wRc5CsaORGgmfYkkDg31sdPrYuGIl5/j
         l+bZfy/7+qc85iAtToE52sitoKLa9D9p5KfHH6DDdvQN/pFhv3nLy95+Ug6nnoeZmeFJ
         UbdmK+fnJiJB9SkxHSqnVAJYSny16hycHip5coxj49JliLXNLoUoBHxoRhkE/2AFXYTe
         l1lw==
X-Gm-Message-State: AOAM530CQi2ekM0UUzDPEvLsf+OEs67+ypYoAz1vTr/8kD4VGWKxtcYP
        eKdRkySzinxVHUKalOM7lQ1kRBWnULYtwA==
X-Google-Smtp-Source: ABdhPJyju/TJw5PLx63W1rG9iTYDyc9fowTDl2EcAiG6PrNoQDQE649Lglf9/tRuHVA0zlpyncuJcQ==
X-Received: by 2002:a05:6a00:1c52:b0:443:41c3:1e51 with SMTP id s18-20020a056a001c5200b0044341c31e51mr9970646pfw.32.1631923645287;
        Fri, 17 Sep 2021 17:07:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 43/84] libfc: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:26 -0700
Message-Id: <20210918000607.450448-44-bvanassche@acm.org>
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
 drivers/scsi/libfc/fc_fcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 509eacd7893d..871b11edb586 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1870,7 +1870,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -1880,7 +1880,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		 * online
 		 */
 		sc_cmd->result = DID_IMM_RETRY << 16;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		goto out;
 	}
 
@@ -2087,7 +2087,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 	list_del(&fsp->list);
 	sc_cmd->SCp.ptr = NULL;
 	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 
 	/* release ref from initial allocation in queue command */
 	fc_fcp_pkt_release(fsp);
