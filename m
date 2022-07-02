Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B74C43334
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jul 2022 05:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiGBFEb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jul 2022 01:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiGBFEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2022 01:04:30 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031292871A
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 22:04:28 -0700 (PDT)
Received: from fsav116.sakura.ne.jp (fsav116.sakura.ne.jp [27.133.134.243])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 26250OHN060288;
        Sat, 2 Jul 2022 14:00:24 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav116.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp);
 Sat, 02 Jul 2022 14:00:24 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav116.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 26250OFZ060285
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 2 Jul 2022 14:00:24 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <03f3312f-ec00-527b-e190-5d274c32c4cc@I-love.SAKURA.ne.jp>
Date:   Sat, 2 Jul 2022 14:00:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: [PATCH v3 4/4] scsi: qla2xxx: avoid flush_scheduled_work() usage
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

Although qla2xxx driver is calling schedule_{,delayed}_work() from 10
locations, I assume that flush_scheduled_work() from qlt_stop_phase1()
needs to flush only works scheduled by qlt_sched_sess_work(), for this
loop continues while "struct qla_tgt"->sess_works_list is not empty.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
This patch is only compile tested.

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

