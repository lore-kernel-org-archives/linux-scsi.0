Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E3BC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 02:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D9461409
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 02:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhHXCar (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 22:30:47 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:15207 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbhHXCap (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 22:30:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GttNR3mMhz1CZpt;
        Tue, 24 Aug 2021 10:29:27 +0800 (CST)
Received: from dggema773-chm.china.huawei.com (10.1.198.217) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 24 Aug 2021 10:29:58 +0800
Received: from localhost.huawei.com (10.175.124.27) by
 dggema773-chm.china.huawei.com (10.1.198.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 24 Aug 2021 10:29:58 +0800
From:   Li Jinlin <lijinlin3@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <john.garry@huawei.com>, <bvanassche@acm.org>,
        <qiulaibin@huawei.com>, <linfeilong@huawei.com>,
        <wubo40@huawei.com>
Subject: [PATCH v3] scsi: core: Fix hang of freezing queue between blocking and running device
Date:   Tue, 24 Aug 2021 10:59:21 +0800
Message-ID: <20210824025921.3277629-1-lijinlin3@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema773-chm.china.huawei.com (10.1.198.217)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Li Jinlin <lijinlin3@huawei.com>

We found a hang issue, the test steps are as follows:
  1. blocking device via scsi_device_set_state()
  2. dd if=/dev/sda of=/mnt/t.log bs=1M count=10
  3. echo none > /sys/block/sda/queue/scheduler
  4. echo "running" >/sys/block/sda/device/state

Step 3 and 4 should finish this work after step 4, but they hangs.

  CPU#0               CPU#1                CPU#2
  ---------------     ----------------     ----------------
                                           Step 1: blocking device

                                           Step 2: dd xxxx
                                                  ^^^^^^ get request
                                                         q_usage_counter++

                      Step 3: switching scheculer
                      elv_iosched_store
                        elevator_switch
                          blk_mq_freeze_queue
                            blk_freeze_queue
                              > blk_freeze_queue_start
                                ^^^^^^ mq_freeze_depth++

                              > blk_mq_run_hw_queues
                                ^^^^^^ can't run queue when dev blocked

                              > blk_mq_freeze_queue_wait
                                ^^^^^^ Hang here!!!
                                       wait q_usage_counter==0

  Step 4: running device
  store_state_field
    scsi_rescan_device
      scsi_attach_vpd
        scsi_vpd_inquiry
          __scsi_execute
            blk_get_request
              blk_mq_alloc_request
                blk_queue_enter
                ^^^^^^ Hang here!!!
                       wait mq_freeze_depth==0

    blk_mq_run_hw_queues
    ^^^^^^ dispatch IO, q_usage_counter will reduce to zero

                            blk_mq_unfreeze_queue
                            ^^^^^ mq_freeze_depth--

Step 3 and 4 wait for each other.

To fix this, we need to run queue before rescanning device when the device
state changes to SDEV_RUNNING.

Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after offlinining device")
Signed-off-by: Li Jinlin <lijinlin3@huawei.com>
Signed-off-by: Qiu Laibin <qiulaibin@huawei.com>
---
changes since v2 send with Message-ID:
20210809141308.3700854-1-lijinlin3@huawei.com

 - Expanded code comment in store_state_field() as suggested by Bart

 drivers/scsi/scsi_sysfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ae9bfc658203..c0d31119d6d7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -808,12 +808,15 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	ret = scsi_device_set_state(sdev, state);
 	/*
 	 * If the device state changes to SDEV_RUNNING, we need to
-	 * rescan the device to revalidate it, and run the queue to
-	 * avoid I/O hang.
+	 * run the queue to avoid I/O hang, and rescan the device
+	 * to revalidate it. Running the queue first is necessary
+	 * because another thread may be waiting inside
+	 * blk_mq_freeze_queue_wait() and because that call may be
+	 * waiting for pending I/O to finish.
 	 */
 	if (ret == 0 && state == SDEV_RUNNING) {
-		scsi_rescan_device(dev);
 		blk_mq_run_hw_queues(sdev->request_queue, true);
+		scsi_rescan_device(dev);
 	}
 	mutex_unlock(&sdev->state_mutex);
 
-- 
2.27.0

