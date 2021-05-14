Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B8EC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92AD961440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhENVg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:28 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:33763 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbhENVgZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:25 -0400
Received: by mail-pj1-f47.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so1962543pjo.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/7sN+RIXFXqjemppu6P3wAyAKlrO4T6Y619Mi3GWqk8=;
        b=jI5J5Y0xM/UYjaNmh/Fho3+X9u4FrddcNf/BfKl7G2zkCZoFpIF4DITXzHIYq6kzbU
         iDtL8CCZZe5VMFZ8LZ9/o8d7kcY2ejahDFtYXgXfLm8ZYawe3hXNAeGnq7kTpXB9fNU3
         9YgVV/GRffHt5HqE+FI/3eoEab+weURL3KPLMs+Dnu3UNoSwHqjZCAZky7OWuNfpDPuz
         UM87YqLXY2lPMaRzLcs6+JdQpQS89gIVGNV6bjG2YjdODnoW4vOugj3QNdvjMVa4I7Lg
         VkSszcN/tKNEOZMXjf1Bj5qu7/Nwyg58BpXecsZQKWwuCR5pAuqfpHCAs0qcDMD9csb9
         7Q/w==
X-Gm-Message-State: AOAM530yI8UaMFSWoMAwV0/2te7KZcWNOVCNgyq+xE6gCEoI6zBCk+Qf
        mCr4vhSHdWxESVbeIhwB6Qqkl471Wteybg==
X-Google-Smtp-Source: ABdhPJzSRR8E+Y4bEYaro6QdwryWklSPJT29ndLjwpA7H0M4PC05ydlkaUkLMpWr7Z6QfwiAhfZYaQ==
X-Received: by 2002:a17:90a:e7c2:: with SMTP id kb2mr4756367pjb.193.1621028112110;
        Fri, 14 May 2021 14:35:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 39/50] scsi_debug: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:54 -0700
Message-Id: <20210514213356.5264-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a5d1633b5bd8..12b4f407143c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4705,7 +4705,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 {
 	u16 hwq;
-	u32 tag = blk_mq_unique_tag(cmnd->request);
+	u32 tag = blk_mq_unique_tag(blk_req(cmnd));
 
 	hwq = blk_mq_unique_tag_to_hwq(tag);
 
@@ -4718,7 +4718,7 @@ static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 
 static u32 get_tag(struct scsi_cmnd *cmnd)
 {
-	return blk_mq_unique_tag(cmnd->request);
+	return blk_mq_unique_tag(blk_req(cmnd));
 }
 
 /* Queued (deferred) command completions converge here. */
@@ -5367,7 +5367,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 {
 	bool new_sd_dp;
 	bool inject = false;
-	bool hipri = (cmnd->request->cmd_flags & REQ_HIPRI);
+	bool hipri = blk_req(cmnd)->cmd_flags & REQ_HIPRI;
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
+				    blk_req(cmnd)->tag);
+			blk_abort_request(blk_req(cmnd));
 			atomic_set(&sdeb_inject_pending, 0);
 			sd_dp->aborted = false;
 		}
@@ -7397,7 +7398,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 					       (u32)cmd[k]);
 		}
 		sdev_printk(KERN_INFO, sdp, "%s: tag=%#x, cmd %s\n", my_name,
-			    blk_mq_unique_tag(scp->request), b);
+			    blk_mq_unique_tag(blk_req(scp)), b);
 	}
 	if (unlikely(inject_now && (sdebug_opts & SDEBUG_OPT_HOST_BUSY)))
 		return SCSI_MLQUEUE_HOST_BUSY;
