Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2628C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA3F460F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhHIXFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:49 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:36547 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237053AbhHIXFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:48 -0400
Received: by mail-pj1-f45.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so1464733pjr.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6sK1fKwOoW9yeCIf0iMKqEBAsSbKi8QdCpxtF/ZJyCA=;
        b=oMoOJ+Kn9jgS9VSwNaS25whqBQFWKFI3TvPWmyU2Hk0qwq/WmUT6vHgzXqrM6iKEo4
         CHVd6qJMF2Jwe82AJz2hn5Sl/tomWD+U5HiuXiR8H4eopq53VP/kAznsmjJDS9cymi5w
         ArL9r+G8M+D+8Um2ryjKzZ5lFicLldtI7vfilTWKxr5kQSDIQpTYSupo0sQIfnDqQgEI
         bpd0TH+yEjC7b/s/cBuM31QUjLjtwCnYxWdLoZK3BHECIE5m6J8sDBgDWz6cX+wQJTMb
         4KXUUrqZneAYk48FBimren9fIhfCtdINHymYyG9cGkATbz0NXOV6QonmfXxcOKHpceqT
         6cTA==
X-Gm-Message-State: AOAM531oOk/T2RW67rcQXAETt8z2NCmi/65q6clV43ImUaxLT9ZE/M5+
        4NHXUyQyioqCdj29trKFkro=
X-Google-Smtp-Source: ABdhPJyRu/oZgnZaqjC0Z6OfMp6XlgtJgW2hcSdLwsmGXqnr4o/HLb14sDJYIYnOYfUA42OkrBaQmg==
X-Received: by 2002:a63:1748:: with SMTP id 8mr131060pgx.369.1628550327206;
        Mon, 09 Aug 2021 16:05:27 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Colin Ian King <colin.king@canonical.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v5 50/52] tcm_loop: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:53 -0700
Message-Id: <20210809230355.8186-51-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
index fdc36274cb39..3dfc7ed79ba4 100644
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
 
