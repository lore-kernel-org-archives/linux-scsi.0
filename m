Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6EBC4320E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 260F660BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbhHETTY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:24 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:39769 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242913AbhHETTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:20 -0400
Received: by mail-pj1-f42.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so8405957pjn.4
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LiOXrYiSEaQ0APiscDckVyE+quRgh1YmL8LN30mCp+w=;
        b=BPYdgf9FkT299Vkj7T7JfkgjmoQ6z3Casfs83kMvpltQB/skacUTGSSWXPIC2qyYo1
         HrGXaCPa+V3GFocZcUaevgbkURH/sbyqqpb17Gu0O77ciRCVstx2EewuxkpHLBGusPgg
         bmqcoF+kxcM7hPTnm/csx34QuqLW+NjVwopJxjILx1+QHDiA6cmTkD2dzsh29rJdhhll
         4Qa72gL5gblox8CGatn+mkE2VDEPdjTvuRliQm2UnFIpfSOa3xFrT9v3pAd71GBJ3/Na
         18/SWFo6Z3sakz7LMNvV9Akbe/HaexKXKkEWjbRR87JxJthkI8TaF6wxtXGxK2c/20Sr
         PBZw==
X-Gm-Message-State: AOAM532cK6gw84e+o5ZJTdBJ5FkR+GXezZknmucnKKqAfVmjYa18hVzW
        lw33kiSOVSFbL/NiLMii044=
X-Google-Smtp-Source: ABdhPJzr35AgeejnJlLI0dyDNGHTdT6O4OictJe6jGZBgFpaTgXemFqJl0CBNju9Ut+YQLvXr/PhjQ==
X-Received: by 2002:a17:90b:1d0d:: with SMTP id on13mr17133521pjb.69.1628191140965;
        Thu, 05 Aug 2021 12:19:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 14/52] advansys: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:50 -0700
Message-Id: <20210805191828.3559897-15-bvanassche@acm.org>
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
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index f3377e2ef5fb..ffb391967573 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7423,7 +7423,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 * Set the srb_tag to the command tag + 1, as
 	 * srb_tag '0' is used internally by the chip.
 	 */
-	srb_tag = scp->request->tag + 1;
+	srb_tag = scsi_cmd_to_rq(scp)->tag + 1;
 	asc_scsi_q->q2.srb_tag = srb_tag;
 
 	/*
@@ -7637,7 +7637,7 @@ static int
 adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	      adv_req_t **adv_reqpp)
 {
-	u32 srb_tag = scp->request->tag;
+	u32 srb_tag = scsi_cmd_to_rq(scp)->tag;
 	adv_req_t *reqp;
 	ADV_SCSI_REQ_Q *scsiqp;
 	int ret;
