Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F26AC47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2521361151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhEXDLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:43 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:36853 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhEXDLk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:40 -0400
Received: by mail-pg1-f180.google.com with SMTP id 27so17751568pgy.3
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h39FmFPPauqh1vNQLy3JtECaw+ytxqOcImNyf8L86LQ=;
        b=XBDtONBfntNr+m9AA0XZ+B/Eeo0BF66UZ2DevlWS4I8nr3WuOoCwCK9FcVAIJWR3zW
         40FHdiU8KvTdH+eLNo9CiP4KwtPIIrwTyl0dVz7ym7VDK4jSvyA9Zw87nbNSkOswbnZT
         cvygMqY1YHNAPObrA6YfpLBDjq3wpxerPQQEdorPZWcs2ILc4iYv7xDtBbw3QLM/1k1b
         8Y2JkDdNUE1t7pyG3Ctvbi1StmshqjjUGMyvCOoKCQ/nssybKIVDuYx+o3C7iWYjYCp/
         VAp/t4MbkmAmQDEejPOS909UFqo9gcuK6ZE/wN+DvChrH6GAXScXOEj4NZT4/TynCiuF
         PZ3Q==
X-Gm-Message-State: AOAM530MvXWCDbq/CqNnpIaPvO55MdUgwonifwAYTMspcdQxJgGzBhYo
        MB6TzFgjbDK3095b0ylwW40=
X-Google-Smtp-Source: ABdhPJwqlv7cnIQM4dRVmPwXONbB/N9lW5dlaLlPEoI/k3i3qjPq45NUPwoEiW6JqkY9Id6yV20uYg==
X-Received: by 2002:a63:31cc:: with SMTP id x195mr11477202pgx.232.1621825811903;
        Sun, 23 May 2021 20:10:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 40/51] scsi_debug: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:45 -0700
Message-Id: <20210524030856.2824-41-bvanassche@acm.org>
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
