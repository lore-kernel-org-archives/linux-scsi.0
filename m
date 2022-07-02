Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFF5C43334
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jul 2022 22:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiGBWFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jul 2022 18:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGBWFu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2022 18:05:50 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AD7CE10
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jul 2022 15:05:49 -0700 (PDT)
Received: from fsav113.sakura.ne.jp (fsav113.sakura.ne.jp [27.133.134.240])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 262M5cUv093313;
        Sun, 3 Jul 2022 07:05:38 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav113.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp);
 Sun, 03 Jul 2022 07:05:38 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 262M5cXm093309
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 3 Jul 2022 07:05:38 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <4159f0bc-0baf-4e9e-9608-8f786ccbef16@I-love.SAKURA.ne.jp>
Date:   Sun, 3 Jul 2022 07:05:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: [PATCH v4 4/4] scsi: qla2xxx: avoid flush_scheduled_work() usage
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <4b3c4c8f-02b0-4d95-85ef-9368b5557cbf@I-love.SAKURA.ne.jp>
 <387068ba-a98c-8ac3-dfde-4b04e1d950cf@I-love.SAKURA.ne.jp>
 <2334071a-806e-f8aa-42bc-873a9b52183a@I-love.SAKURA.ne.jp>
In-Reply-To: <2334071a-806e-f8aa-42bc-873a9b52183a@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although qla2xxx driver is calling schedule_{,delayed}_work() from 10
locations, I assume that flush_scheduled_work() from qlt_stop_phase1()
needs to flush only works scheduled by qlt_sched_sess_work(), for this
loop continues while "struct qla_tgt"->sess_works_list is not empty.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
This patch is only compile tested.

Changes in v4:
  Repost as a new thread.

Changes in v3:
  Use flush_work().

Changes in v2:
  Use per "struct qla_tgt" workqueue.

 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 9013c162d4aa..b0cb463cf032 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1559,7 +1559,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	spin_lock_irqsave(&tgt->sess_work_lock, flags);
 	do {
 		spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
-		flush_scheduled_work();
+		flush_work(&tgt->sess_work);
 		spin_lock_irqsave(&tgt->sess_work_lock, flags);
 	} while (!list_empty(&tgt->sess_works_list));
 	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
-- 
2.18.4

