Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B09C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC9560F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344434AbhIRAJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:04 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:34321 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344702AbhIRAIt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:49 -0400
Received: by mail-pf1-f170.google.com with SMTP id g14so10707314pfm.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NjMfgEcFNlpNu3FLkgOkp94QH6H36cNQ1YC8D7Rlhbw=;
        b=7KvWQ+OIPQGm6Y3hlw2NmJYt/0HhsH8ZdFFk9/glEy+i6W3TJSCb/3MfRPIXiuj3Zi
         kuvGop/MY7wXT8KZEc+AWiTAJCmb123yb1nlvm2tK0t3PtN0CT5a5Tn3yxij9EyzZdp8
         IdiHVy9pgPs4e9AdaAMOFceviDuSJJqR3SJCtXb0WmHeZ52QVvX5IDE2R2spHaZWUG4e
         DpYyj4o+E3JLo4GXc//8gjBP2RDPjlsKj+gu1OrwGY88Ah1dC91IBIuHickTebCzd3kY
         s+6ykEeh5PPcCN46QWFWxGKa3MoBPd4Sh6svYDUDaCiUwBgvIhbcEFl9vm7x/itICl3n
         6PdA==
X-Gm-Message-State: AOAM530ApB2/JwEyNkLfDPWk4xhwcQ1d34ie849zPfI65SrTIhdvaMCi
        +W6p8PF+hThvXcxhFY/q77w=
X-Google-Smtp-Source: ABdhPJy1qt57KmmnuMxLikQySfmGa0MFMt0nEeXMuChOPw8L++MVU6qz0izhLPTcXdRT/VROHY0GDw==
X-Received: by 2002:a62:403:0:b0:433:9582:d449 with SMTP id 3-20020a620403000000b004339582d449mr13111933pfe.15.1631923646711;
        Fri, 17 Sep 2021 17:07:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 44/84] libiscsi: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:27 -0700
Message-Id: <20210918000607.450448-45-bvanassche@acm.org>
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
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 712a45368385..7beedc59d0c6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -468,7 +468,7 @@ static void iscsi_free_task(struct iscsi_task *task)
 		 * it will decide how to return sc to scsi-ml.
 		 */
 		if (oldstate != ISCSI_TASK_REQUEUE_SCSIQ)
-			sc->scsi_done(sc);
+			scsi_done(sc);
 	}
 }
 
@@ -1807,7 +1807,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
 	scsi_set_resid(sc, scsi_bufflen(sc));
-	sc->scsi_done(sc);
+	scsi_done(sc);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
