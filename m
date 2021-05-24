Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E63BC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A3161159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhEXDMD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:12:03 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:37841 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbhEXDL6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:58 -0400
Received: by mail-pg1-f170.google.com with SMTP id t193so19064715pgb.4
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=laV2E24Fm3RHSV+xjoxc9ZAJGQpQIIm4wmdw1Gavwm0=;
        b=gDOBPKMW/sxpyB9HyVjIKIAYzkDqJ78E07bMk2XOscLvQq6Mi1vmK97fg4+Q6SouK0
         fokMwQHA2GjkZo9WmDUIigaNe7u/SF5MFtijZ83DbwpZMzym/P4JfNIu9ZlriSe5QKsq
         ixw/Ua+V4UmAV1O1QL5b5NP+7fZGRWUT08IWZQmhPIEVUy/czGY6JbhG5g5dUYNHSrUk
         F+a7ff1HHtAw1EqoH3A7dd4R6pYRMaA8XsQLX6Vlb/3WDuqwCangi36dPFhkdLcKKqFn
         ihtPco/YP30eXUMs7c5jgY51ueASBkF5slZDuiKISjOGwKrY4b2BAMSAKzr7/XKFJfCa
         DXbw==
X-Gm-Message-State: AOAM532mo57YSNetYqVZWiY5G5VzGexdbW/4Of089fcbXwUOMtUmsdGa
        aY3afbc40wM4LOOcvoE/7InavT69SYCS2w==
X-Google-Smtp-Source: ABdhPJyeXkBrOspPzf0EUkDSBdl1VOx6SEvbyiiiT+EEh61KrxXdQTUoVD3VWxfePdQDSRmq4lbHeQ==
X-Received: by 2002:a05:6a00:c84:b029:2e4:e4da:788b with SMTP id a4-20020a056a000c84b02902e4e4da788bmr14211398pfv.72.1621825829990;
        Sun, 23 May 2021 20:10:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v3 49/51] tcm_loop: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:54 -0700
Message-Id: <20210524030856.2824-50-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/loopback/tcm_loop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 2687fd7d45db..834eceaac9cd 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -183,7 +183,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
-	tl_cmd->sc_cmd_tag = sc->request->tag;
+	tl_cmd->sc_cmd_tag = scsi_cmd_to_rq(sc)->tag;
 
 	tcm_loop_target_queue_cmd(tl_cmd);
 	return 0;
@@ -249,7 +249,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
 	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
-				 sc->request->tag, TMR_ABORT_TASK);
+				 scsi_cmd_to_rq(sc)->tag, TMR_ABORT_TASK);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
