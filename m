Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2669C43334
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jul 2022 05:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiGBFAc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jul 2022 01:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGBFAb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2022 01:00:31 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689041ADA4
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 22:00:30 -0700 (PDT)
Received: from fsav412.sakura.ne.jp (fsav412.sakura.ne.jp [133.242.250.111])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 26250KZs060271;
        Sat, 2 Jul 2022 14:00:20 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav412.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp);
 Sat, 02 Jul 2022 14:00:20 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 26250KMU060264
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 2 Jul 2022 14:00:20 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <9e454c72-5af2-5de3-db86-d27f699fa0c0@I-love.SAKURA.ne.jp>
Date:   Sat, 2 Jul 2022 14:00:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: [PATCH v3 3/4] scsi: qla2xxx: always wait for qlt_sess_work_fn() from
 qlt_stop_phase1()
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <b4a96c07-76ef-c7ac-6a73-a64bba32d26f@I-love.SAKURA.ne.jp>
 <46629616-be04-9a53-b9d8-b2b947adf9d0@I-love.SAKURA.ne.jp>
In-Reply-To: <46629616-be04-9a53-b9d8-b2b947adf9d0@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently qlt_stop_phase1() may fail to call flush_scheduled_work(), for
list_empty() may return true as soon as qlt_sess_work_fn() called
list_del(). In order to close this race window, check list_empty() after
calling flush_scheduled_work().

If this patch causes problems, please check commit c4f135d643823a86
("workqueue: Wrap flush_workqueue() using a macro"). We are on the way to
remove all flush_scheduled_work() calls from the kernel.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
This patch is only compile tested.

 drivers/scsi/qla2xxx/qla_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b170ebbd05b7..9013c162d4aa 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1557,11 +1557,11 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf009,
 	    "Waiting for sess works (tgt %p)", tgt);
 	spin_lock_irqsave(&tgt->sess_work_lock, flags);
-	while (!list_empty(&tgt->sess_works_list)) {
+	do {
 		spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
 		flush_scheduled_work();
 		spin_lock_irqsave(&tgt->sess_work_lock, flags);
-	}
+	} while (!list_empty(&tgt->sess_works_list));
 	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00a,
-- 
2.18.4

