Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB898CE7B09
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 07:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjI1Hgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Sep 2023 03:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjI1HgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Sep 2023 03:36:23 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5D89C;
        Thu, 28 Sep 2023 00:36:18 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Rx4wl3XVWzrT3D;
        Thu, 28 Sep 2023 15:33:59 +0800 (CST)
Received: from build.huawei.com (10.175.101.6) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 28 Sep 2023 15:36:15 +0800
From:   Wenchao Hao <haowenchao2@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <louhongxiang@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH v2 4/4] scsi: scsi_core:  Fix IO hang when device removing
Date:   Thu, 28 Sep 2023 15:35:43 +0800
Message-ID: <20230928073543.3496394-5-haowenchao2@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230928073543.3496394-1-haowenchao2@huawei.com>
References: <20230928073543.3496394-1-haowenchao2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

shost_for_each_device() would skip devices which is in progress of
removing, so scsi_run_queue() for these devices would be skipped in
scsi_run_host_queues() after blocking hosts' IO.

IO hang would be caused if return true when state is SDEV_CANCEL with
following order:

T1:					    T2:scsi_error_handler
__scsi_remove_device()
  scsi_device_set_state(sdev, SDEV_CANCEL)
  ...
  sd_remove()
  del_gendisk()
  blk_mq_freeze_queue_wait()
  					    scsi_eh_flush_done_q()
					      scsi_queue_insert(scmd,...)

Because scsi_queue_insert() would not kick device's queue after commit
8b566edbdbfb ("scsi: core: Only kick the requeue list if necessary")

After scsi_unjam_host(), the scsi error handler would call scsi_run_queue()
to trigger run queue for devices, while it would not run queue for
devices which is in progress of removing because shost_for_each_device()
would skip them.

So the requests added to these queues would not be handled any more,
and the removing device process would hang too.

Fix this issue by using shost_for_each_device_include_deleted() in
scsi_run_queue() to trigger a run queue for devices in removing.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c2f647a7c1b0..34b408d182e2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -466,7 +466,7 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, shost)
+	shost_for_each_device_include_deleted(sdev, shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-- 
2.32.0

