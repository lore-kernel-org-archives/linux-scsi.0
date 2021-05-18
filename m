Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150F1C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C46611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351323AbhERRrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:19 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:37514 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344873AbhERRrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:16 -0400
Received: by mail-pf1-f175.google.com with SMTP id b13so4216289pfv.4
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aKkB7ZUZ5bcLF5SUfQq+fCLVrdRbOHrGvQGZxtftTuc=;
        b=Yqih2+x0fHQdXkyoFsUfUMFeO0iTU5CfhY5Kaf0uuomLFc4+ABfCpRayD5AbZbY7zw
         cl7X8ZR0ZLeETjpMSRArMfrW+x+1phcHeqhYdzSJnid0xNOLTlFwv7nDhwFXNj0wN9F0
         s/ae/Q/Z+YQ5PosHpu7UKevfhsq0hM2eUgDLZqzvPCjYKweRL89KF+nbhPDK4285p/hs
         HoNzOufvzY2L1BkgtuSleWH4yM9XFySOs42Y1ngEfsvF/5Vua9WLj2Edn5PmwPVj/ZPP
         //qui4fZ1pwieg+yDwro8UqNp1Fm49cGZu4XuT6a2FSaCYp0pU1QdyuoOeHuFOySkI/e
         5eDg==
X-Gm-Message-State: AOAM531qaNO2rFX13G/lNwcu+PRPK/JnA8d4WBVKs4yXeT/poe6g5sYb
        QQHAdX9rljrAw6aVg+aOkHc=
X-Google-Smtp-Source: ABdhPJwi7OzuT6YYmd3Y7iVsFt0TzpXg42mbAQjAAaaGOvWOh6tWJrNgo1aJ+NaJP0+M+zV2d+cvTQ==
X-Received: by 2002:a62:7ad4:0:b029:2dc:d1a2:b093 with SMTP id v203-20020a627ad40000b02902dcd1a2b093mr6120277pfc.66.1621359957154;
        Tue, 18 May 2021 10:45:57 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH v2 48/50] tcm_loop: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:48 -0700
Message-Id: <20210518174450.20664-49-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

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
 
