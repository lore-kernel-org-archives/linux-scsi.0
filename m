Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EBAC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jun 2022 10:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiFWK1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jun 2022 06:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiFWK1g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2022 06:27:36 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7205A4A3E6
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 03:27:35 -0700 (PDT)
Received: from fsav413.sakura.ne.jp (fsav413.sakura.ne.jp [133.242.250.112])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 25NAROnV062808;
        Thu, 23 Jun 2022 19:27:24 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav413.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp);
 Thu, 23 Jun 2022 19:27:24 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 25NARN6b062804
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 23 Jun 2022 19:27:23 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <0ecea6b9-da84-6da5-f6ba-bab394a80033@I-love.SAKURA.ne.jp>
Date:   Thu, 23 Jun 2022 19:27:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: [PATCH 1/2] scsi: qla2xxx: Remove unused del_sess_list field
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <b4a96c07-76ef-c7ac-6a73-a64bba32d26f@I-love.SAKURA.ne.jp>
In-Reply-To: <b4a96c07-76ef-c7ac-6a73-a64bba32d26f@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

"struct qla_tgt"->del_sess_list is no longer used since commit
726b85487067d7f5 ("qla2xxx: Add framework for async fabric discovery").

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
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

