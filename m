Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B49C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 498AB611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351317AbhERRrG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:06 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:36360 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245174AbhERRrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:02 -0400
Received: by mail-pj1-f45.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so1986937pjt.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h39FmFPPauqh1vNQLy3JtECaw+ytxqOcImNyf8L86LQ=;
        b=ZmSKJF4ISUWc5qQ5WurFoRY0j36ID5SuaZSyL7JyucrVvKIUbuC02fP5YGLiNgBhqm
         pXxEWC810ws15WSDL2RAw/PZTIESqtkwJJkLcsOr60jJ8IZ1dSfXMn4Bvl3fijfNWZt6
         nwhuUcfr4a4lW/aC5NzMSLgk9o5ejDx4GhTRIoEwQQPLOfBLFV5yKuX/NlKE7a2d48qi
         EVQ2QBzLKiIsuVrm+PGJcJ9cBIDZ5x/a2+PTkJN/jBFP0P6+xR8kV3e9grSyqwzsVo2l
         LDjR1uizqIF5XqaGK1SWstM/hHU73GmKOrM0tTCJWMwEXGXExnQDXnU1S8HYRHS11Kui
         LdhQ==
X-Gm-Message-State: AOAM530NOk3YO6XqtD0FFADWnNcBSclF+7wD8p0l9XGoKMA5ZYpKaeYB
        Bt8bz15TqqfqdauTJ974El0=
X-Google-Smtp-Source: ABdhPJxP5avFDxjHiFcwUEEPULuDjlFM0E33D68XXPxhkFFiOvr+Xl3mbihRrSNlJFXzpaEKFLIcpg==
X-Received: by 2002:a17:90a:b885:: with SMTP id o5mr6326758pjr.91.1621359943961;
        Tue, 18 May 2021 10:45:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 39/50] scsi_debug: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:39 -0700
Message-Id: <20210518174450.20664-40-bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6e2ad003c179..151b0d2f49a5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4705,7 +4705,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 {
 	u16 hwq;
-	u32 tag = blk_mq_unique_tag(cmnd->request);
+	u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 
 	hwq = blk_mq_unique_tag_to_hwq(tag);
 
@@ -4718,7 +4718,7 @@ static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 
 static u32 get_tag(struct scsi_cmnd *cmnd)
 {
-	return blk_mq_unique_tag(cmnd->request);
+	return blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 }
 
 /* Queued (deferred) command completions converge here. */
@@ -5367,7 +5367,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 {
 	bool new_sd_dp;
 	bool inject = false;
-	bool hipri = (cmnd->request->cmd_flags & REQ_HIPRI);
+	bool hipri = scsi_cmd_to_rq(cmnd)->cmd_flags & REQ_HIPRI;
 	int k, num_in_q, qdepth;
 	unsigned long iflags;
 	u64 ns_from_boot = 0;
@@ -5570,8 +5570,9 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
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
@@ -7397,7 +7398,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 					       (u32)cmd[k]);
 		}
 		sdev_printk(KERN_INFO, sdp, "%s: tag=%#x, cmd %s\n", my_name,
-			    blk_mq_unique_tag(scp->request), b);
+			    blk_mq_unique_tag(scsi_cmd_to_rq(scp)), b);
 	}
 	if (unlikely(inject_now && (sdebug_opts & SDEBUG_OPT_HOST_BUSY)))
 		return SCSI_MLQUEUE_HOST_BUSY;
