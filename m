Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F10C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89A3B60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhHIXFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:32 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:38401 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbhHIXF1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:27 -0400
Received: by mail-pl1-f169.google.com with SMTP id a5so2658620plh.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q3NLUuStfZMQd5sDYZwFIx1GxfW8BLyvBbkMUeM4RQw=;
        b=HbJfW/cpU+Z5cmzXyVBLUEmSlPclmPPMLBvdWP0FD+ZamG9U2iIIYhixzwDNsUqiSA
         Vqjbk9fJsdFg+hYyH5TG53YNbTBG+XAsoWHhE5d2k9/XUF11/7kdrTLJX32jZYSRNF0M
         5SoOwC4e1p1QzQEeJdu8tndtEokBtMVpeQTuo/4rPc1x4gtLBjxXvN2oHJgDdhdns2sn
         sYpJfHAnMHzNnV81OFTUUe7Yzt7PVPQXMdgggmDp0McHziHwQvIRK5+Bm0iPqYtYMLHW
         OCIdDctLlD6Vy2VJvLrjTjU/iJdtY7kuNw0LHsHmuwx0R/dwd2KiSSiQNpPq8vHiDOdG
         jMIg==
X-Gm-Message-State: AOAM532I3J/WorYiwjTJHFvIeBCEeZKF+RL6XrJ21QcXqa8WoO2fIIKD
        Do8D2GCy0fudQeayd+2YeYxm/XpT0iVTTw==
X-Google-Smtp-Source: ABdhPJz/yFXEeqEPPCAgVRDxVin1rEgOoL22m5EMpF2h34Uyc+U4GkkX39Tb3PUj3htiFS6yekpKaA==
X-Received: by 2002:a17:902:7598:b029:12b:e9ca:dfd5 with SMTP id j24-20020a1709027598b029012be9cadfd5mr22434720pll.12.1628550306534;
        Mon, 09 Aug 2021 16:05:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 41/52] scsi_debug: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:44 -0700
Message-Id: <20210809230355.8186-42-bvanassche@acm.org>
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
