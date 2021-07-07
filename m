Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B601C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 19:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B1CC61CBD
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 19:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhGGTCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 15:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhGGTCj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 15:02:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B02C06175F
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:59:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k11-20020a056902070bb029055a2303fc2dso3754709ybt.11
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WPuzbQ+kAAJtt1uY7T99xiyaeKuRM2Kc6c/2JJ6Jb8E=;
        b=lV/e0eVEBAGfZfSHTQ+4JUoC01NRo3xfqb1UTk4JNHtaogkNEzNW4DvvNejFRj5sGE
         RXY5i5ihVR3R+IYvorNqvy7zIV9b6p2kjZupuaSmTxepNCDAiEgGUhz70cXojU/QBue8
         8G0kQgz9yw/wh8Jfw+KInzRM6gsl+WZcsTGjkqYOGgcKl5jU18hOWC8kVG5n4qbD/u5p
         gLe4DtS+SnqfyyB97HVuemCnTgWO4bKrMF/IOCods2YUBO2BD5Ok67qRwTW2JU6tByAY
         In9HESy2A8UcDspX9KZa4bzBFSzmULBeg0ZyMX9lG28g6bxx2QhmyBin1bs9Yoguh6da
         VxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WPuzbQ+kAAJtt1uY7T99xiyaeKuRM2Kc6c/2JJ6Jb8E=;
        b=rv5XHJ0HCSA1j5+U1IvlK89hKXI8HnpDWW54Ex/RXQ3DPwL5nkEzQRPwjAPf6SWB12
         SML/4aO957fGJqsFcpur5v4ENpS6oSWV1qYQ+QPrqOVfpxIi25j/OEymml6EjYDoJ5OY
         xzypU2zMD2X/0Mxh/6edPHmHU3TmrXktipBv+OgE8GUnj1XtLbSsyi7LevFfm4xd/x6+
         2bZ1VRzbFozXwjt/QKtBofWVtAbARfDHaidDhQTiy6VYwiRhpOxn/CxSCTTtPQ/nfsEt
         MpAKrh7d88iEwIge8gt4RiEuLI6uDmeD5GKIH6xujyoXjbkM5YXJVvIU4web2QOwngEb
         weDg==
X-Gm-Message-State: AOAM531BAJqF4kz2fC2Fx2EVbYnzxRT3W5Z5XnnpG1InsdCdcE1rpVQM
        ZRiTMVjZnd1Xd+Q41Gd6FWr1Wc0b0grAAg==
X-Google-Smtp-Source: ABdhPJzGBmoUm/5s5XsVKbevLjRoP59MrqpIqojm7ocpi4FJx1gnJQugI71rIpBI/rJ9TQ5gZnPc+flYjA2+Nw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:22a7:3ca4:3b1d:67bf])
 (user=ipylypiv job=sendgmr) by 2002:a25:11c2:: with SMTP id
 185mr35451010ybr.101.1625684398627; Wed, 07 Jul 2021 11:59:58 -0700 (PDT)
Date:   Wed,  7 Jul 2021 11:59:45 -0700
Message-Id: <20210707185945.35559-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH] scsi: pm80xx: Fix tmf task completion race condition
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The tmf timeout timer may trigger at the same time when the response
from a controller is being handled. When this happens the sas task may
get freed before the response processing is finished.

Fix this by calling complete() only when SAS_TASK_STATE_DONE is not set.

Similar race condition was fixed in commit b90cd6f2b905
("scsi: libsas: fix a race condition when smp task timeout")

Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6f33d821e545..1d35587c28e0 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -682,8 +682,7 @@ int pm8001_dev_found(struct domain_device *dev)
 
 void pm8001_task_done(struct sas_task *task)
 {
-	if (!del_timer(&task->slow_task->timer))
-		return;
+	del_timer(&task->slow_task->timer);
 	complete(&task->slow_task->completion);
 }
 
@@ -691,9 +690,14 @@ static void pm8001_tmf_timedout(struct timer_list *t)
 {
 	struct sas_task_slow *slow = from_timer(slow, t, timer);
 	struct sas_task *task = slow->task;
+	unsigned long flags;
 
-	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
-	complete(&task->slow_task->completion);
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+		complete(&task->slow_task->completion);
+	}
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 }
 
 #define PM8001_TASK_TIMEOUT 20
@@ -746,13 +750,10 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		}
 		res = -TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
-		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					   "TMF task[%x]timeout.\n",
-					   tmf->tmf);
-				goto ex_err;
-			}
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			pm8001_dbg(pm8001_ha, FAIL, "TMF task[%x]timeout.\n",
+				   tmf->tmf);
+			goto ex_err;
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
@@ -832,12 +833,9 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		wait_for_completion(&task->slow_task->completion);
 		res = TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
-		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					   "TMF task timeout.\n");
-				goto ex_err;
-			}
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			pm8001_dbg(pm8001_ha, FAIL, "TMF task timeout.\n");
+			goto ex_err;
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
-- 
2.32.0.93.g670b81a890-goog

