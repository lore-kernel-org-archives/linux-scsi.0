Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4BDC433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jul 2022 22:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiGBWDA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jul 2022 18:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGBWDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2022 18:03:00 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2521BCAF
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jul 2022 15:02:58 -0700 (PDT)
Received: from fsav312.sakura.ne.jp (fsav312.sakura.ne.jp [153.120.85.143])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 262M2mSY092797;
        Sun, 3 Jul 2022 07:02:48 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav312.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp);
 Sun, 03 Jul 2022 07:02:48 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 262M2h5d092774
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 3 Jul 2022 07:02:48 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <4b3c4c8f-02b0-4d95-85ef-9368b5557cbf@I-love.SAKURA.ne.jp>
Date:   Sun, 3 Jul 2022 07:02:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH v4 1/4] scsi: qla2xxx: Remove unused del_sess_list field
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

"struct qla_tgt"->del_sess_list is no longer used since commit
726b85487067d7f5 ("qla2xxx: Add framework for async fabric discovery").

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
Changes in v4:
  Repost as a new thread.

 drivers/scsi/qla2xxx/qla_target.c | 1 -
 drivers/scsi/qla2xxx/qla_target.h | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2b2f68288375..d9e0e7ffe130 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6512,7 +6512,6 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	tgt->ha = ha;
 	tgt->vha = base_vha;
 	init_waitqueue_head(&tgt->waitQ);
-	INIT_LIST_HEAD(&tgt->del_sess_list);
 	spin_lock_init(&tgt->sess_work_lock);
 	INIT_WORK(&tgt->sess_work, qlt_sess_work_fn);
 	INIT_LIST_HEAD(&tgt->sess_works_list);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index de3942b8efc4..e899e13696e9 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -813,9 +813,6 @@ struct qla_tgt {
 	/* Count of sessions refering qla_tgt. Protected by hardware_lock. */
 	int sess_count;
 
-	/* Protected by hardware_lock */
-	struct list_head del_sess_list;
-
 	spinlock_t sess_work_lock;
 	struct list_head sess_works_list;
 	struct work_struct sess_work;
-- 
2.18.4
