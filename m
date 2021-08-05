Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7ACC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAEE261078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbhHETUh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:37 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:36702 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242816AbhHETUh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:37 -0400
Received: by mail-pj1-f46.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so17332757pjr.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6sK1fKwOoW9yeCIf0iMKqEBAsSbKi8QdCpxtF/ZJyCA=;
        b=srmjzDsc4WBtcFLVbg9akkIMKOoIA6YjGMITCd+xJwlQT1z68zTp/FCXtINUf8EUuQ
         fL90Kk5xdt/eotBE3FU3bd0c7C+9NJ60SKYuYpQwWklt9Nd+/b5S+Pg55THjxlhuZy0g
         mc3nCFEZVbwY4mzK7vMDM9Irw1ZBgi9V48gxj8qk+zlO1ioRQk+pYnPluzNB7L+nCU3s
         mnFKmR4YJIiGWR0vNCvv8NoOlcYvK652Ym4/gl8ar17e2WtNu0MbLeh+q/a+sZEm44Dq
         xBY0GnyVFl92xSn0xONMw/8LzjOD/szFhjdo8Cc2wLqdgC+glIcBxAEbybcwokA42+ln
         64ew==
X-Gm-Message-State: AOAM5307rhxbdYrCu8V0EOH8cQ0kPGGjkq9tKRr84A4yEJIKyaqA7QKv
        YLKlS7YXisE30tVpc7yEdSo=
X-Google-Smtp-Source: ABdhPJxRBtaw1yL3jwNWgtDuV1yz8YnsfD5p9Nd0ppSOcKVcHsE44n59cscTmajRvrd+LdT6LagQdQ==
X-Received: by 2002:a17:902:d50c:b029:12c:9177:65b0 with SMTP id b12-20020a170902d50cb029012c917765b0mr5218308plg.1.1628191222773;
        Thu, 05 Aug 2021 12:20:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:20:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Colin Ian King <colin.king@canonical.com>,
        Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH v4 50/52] tcm_loop: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:26 -0700
Message-Id: <20210805191828.3559897-51-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
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
 
