Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEC2C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D625361078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242775AbhHETUN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:13 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:44974 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242899AbhHETUJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:09 -0400
Received: by mail-pj1-f47.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so11976372pjh.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q3NLUuStfZMQd5sDYZwFIx1GxfW8BLyvBbkMUeM4RQw=;
        b=EAmYoJnhCZZy+M5Sq3ihekMnHhOt2pcCwzpu+ighvCxFF07p28j/db4firlNWKyeFh
         nY/EPKgTR56RtLh9+rt6fY3KFnrDDp/4HEsXmrY+l4IYjEXfIAln0IU1uQqamfSqo8Lf
         1nIh9vcGclOBb3RM9NpGcQcSH9WihcwxUzpOoMioLpvGs1HjWN8lByLRoFRDjb4X6TBd
         Rc80gotCeOMj5eq9nMdiGVAtE8lvN0+IlWGXGtYHaQNwQvofgzCK5wsV6zaM45NEfbD6
         uIKrVzUFVqWMfHsE6M+YzhfZqFTYIemSz7S0uLPS399H0LBW8fu8Shmvq4Ti1OGq2CBO
         rAcQ==
X-Gm-Message-State: AOAM531HjEoH+oVrxsXv4emACQF7ePsBUFNHhjQnHNY0CtCoRObXrlFE
        jl3H/3jY0rgdZ5AbQ+NBOzyoHRoNsju62/MOH70=
X-Google-Smtp-Source: ABdhPJwjUo8oFGHKEaEujoDv4kRs97I47URkkVplyWKZic1XnCNmzx/w94vDpeJ6nC+AlgJqomUz3A==
X-Received: by 2002:a63:db4b:: with SMTP id x11mr180068pgi.396.1628191194392;
        Thu, 05 Aug 2021 12:19:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 41/52] scsi_debug: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:17 -0700
Message-Id: <20210805191828.3559897-42-bvanassche@acm.org>
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

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 25112b15ab14..31529d8add0d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4722,7 +4722,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 {
 	u16 hwq;
-	u32 tag = blk_mq_unique_tag(cmnd->request);
+	u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 
 	hwq = blk_mq_unique_tag_to_hwq(tag);
 
@@ -4735,7 +4735,7 @@ static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 
 static u32 get_tag(struct scsi_cmnd *cmnd)
 {
-	return blk_mq_unique_tag(cmnd->request);
+	return blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 }
 
 /* Queued (deferred) command completions converge here. */
@@ -5384,7 +5384,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 {
 	bool new_sd_dp;
 	bool inject = false;
-	bool hipri = (cmnd->request->cmd_flags & REQ_HIPRI);
+	bool hipri = scsi_cmd_to_rq(cmnd)->cmd_flags & REQ_HIPRI;
 	int k, num_in_q, qdepth;
 	unsigned long iflags;
 	u64 ns_from_boot = 0;
@@ -5587,8 +5587,9 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		if (sdebug_statistics)
 			sd_dp->issuing_cpu = raw_smp_processor_id();
 		if (unlikely(sd_dp->aborted)) {
-			sdev_printk(KERN_INFO, sdp, "abort request tag %d\n", cmnd->request->tag);
-			blk_abort_request(cmnd->request);
+			sdev_printk(KERN_INFO, sdp, "abort request tag %d\n",
+				    scsi_cmd_to_rq(cmnd)->tag);
+			blk_abort_request(scsi_cmd_to_rq(cmnd));
 			atomic_set(&sdeb_inject_pending, 0);
 			sd_dp->aborted = false;
 		}
@@ -7414,7 +7415,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 					       (u32)cmd[k]);
 		}
 		sdev_printk(KERN_INFO, sdp, "%s: tag=%#x, cmd %s\n", my_name,
-			    blk_mq_unique_tag(scp->request), b);
+			    blk_mq_unique_tag(scsi_cmd_to_rq(scp)), b);
 	}
 	if (unlikely(inject_now && (sdebug_opts & SDEBUG_OPT_HOST_BUSY)))
 		return SCSI_MLQUEUE_HOST_BUSY;
