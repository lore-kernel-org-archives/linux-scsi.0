Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE98C04E30
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6CF7207FF
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfLISCc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:02:32 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37157 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfLISCc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 13:02:32 -0500
Received: by mail-pf1-f195.google.com with SMTP id s18so7618453pfm.4
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2019 10:02:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JwyQYy9CDuJD2keml04FoOO59J90K/sPV9NiZmnzTPM=;
        b=ijHp0Ok/OoDAL0JgBwMaMXXvFxQ+WjKSkUixZKfkPxPiVIQObG3/pMwPnalyynDPWq
         xAFWyn0dOj+apRq90K4kU6kt71XBjGWmBWHPquFAjLzbTuGfZbBK1r1qeZ6twCJ8lv+J
         86nTHA2Qjg+7aA/6by8KyGmfZfc9zYgrMjNQJcZX3uDDmjzk4lCkdr4EP8sDKobXuQKf
         Rb0IVffcR/q31gp2Ymr2LHqEO/lV3b81bNraV960crMUSpHAaK+yoFn1CiYl9gGi1rNc
         i2OhoIcwy7F6QN0ChGxE5CcKxrsZsMl+RdRl7aK1RKJvm8AnK3SySjzrpYvsradYU0hj
         OnaA==
X-Gm-Message-State: APjAAAXNDr/YSQwl+KgfmMgZ572A0j6bzcjIvvRPT2gXW49l1SAJZ6wr
        RoQ0DICFu7Ibn5c6fjwe8OmKLvkB
X-Google-Smtp-Source: APXvYqwq7TmPATb1B8CXzZY3yyQ78g7HU/0HYk71jOD97ZLGVewvpi5kZ/j2c9uaUODq9+k4MNby/A==
X-Received: by 2002:a62:e208:: with SMTP id a8mr30803022pfi.258.1575914551585;
        Mon, 09 Dec 2019 10:02:31 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.7])
        by smtp.gmail.com with ESMTPSA id f13sm132393pfa.57.2019.12.09.10.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:02:30 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 1/4] qla2xxx: Check locking assumptions at runtime in qla2x00_abort_srb()
Date:   Mon,  9 Dec 2019 10:02:20 -0800
Message-Id: <20191209180223.194959-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191209180223.194959-1-bvanassche@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Document the locking assumptions this function relies on and also verify these
locking assumptions at runtime.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8b84bc4a6ac8..145ea93206f0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1700,6 +1700,8 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 	bool ret_cmd;
 	uint32_t ratov_j;
 
+	lockdep_assert_held(qp->qp_lock_ptr);
+
 	if (qla2x00_chip_is_down(vha)) {
 		sp->done(sp, res);
 		return;
