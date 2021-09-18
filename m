Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076E9C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E55E860F23
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245742AbhIRAIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:21 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:46671 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245674AbhIRAIU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:20 -0400
Received: by mail-pg1-f181.google.com with SMTP id m21so1914725pgu.13
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xovr5aSMt2uSUC20pA1RBp5MP6CUZICgGZJSyXaXwcI=;
        b=5fpyMKM72D9cBqUb4mbMbVBHvzUOMM7rQna74aUquo/MJpXPXb1sDxSedkrEYqAnPW
         p/EE0RwuuMiDFeBrnZ6Tnu6ihJ4M5iRK81YSc+0j/JX+2Os3cOFIwDv8g+W+/t+n+tvq
         a0L2c8Ley2hLLkvdlzXLvt7GMgPnch6x3IfXAiAmNqGHA3ONcGOuOaQSQLJ3RxdA43JD
         7gDkD2ndU3fQ4JRP9ZqpsVtND3G4MqOv06DdEMIVL9nFdx9Ack4xxhWdgFFbPI39D4uT
         6F7ZUEt04W9+fYYFRH6LPcfXlxCzGuCGMV3Mh7SSIkh4/+s4NPcd+ZsyBeNg8Y49WBTo
         +uCA==
X-Gm-Message-State: AOAM533UY3omzo9rTMJmKlJXRExb+i+zns1tIBUP2i6PKcx1KmORFTwt
        kF07XuJ8HfebNwiQEiO30D8=
X-Google-Smtp-Source: ABdhPJwWxalsAxArGwV+fHxNRJCmvC2qUrlV6ZF3P2SN4PpjtFTHaDT8FuxFyK+i7vegyEeN9ds/zA==
X-Received: by 2002:a63:b204:: with SMTP id x4mr11835875pge.212.1631923617603;
        Fri, 17 Sep 2021 17:06:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 26/84] bnx2fc: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:09 -0700
Message-Id: <20210918000607.450448-27-bvanassche@acm.org>
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
 drivers/scsi/bnx2fc/bnx2fc_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index f2996a9b2f63..b9114113ee73 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -205,7 +205,7 @@ static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)
 		sc_cmd->allowed);
 	scsi_set_resid(sc_cmd, scsi_bufflen(sc_cmd));
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 }
 
 struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
@@ -1610,7 +1610,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 	}
 
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 	if (io_req->wait_for_abts_comp) {
@@ -1853,7 +1853,7 @@ int bnx2fc_queuecommand(struct Scsi_Host *host,
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -2019,7 +2019,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 		break;
 	}
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 }
 
