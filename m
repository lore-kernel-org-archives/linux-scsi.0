Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129AEC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Oct 2022 10:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJUKk5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 06:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJUKkr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 06:40:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203271A0466;
        Fri, 21 Oct 2022 03:40:42 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mv18d2g11zVhk8;
        Fri, 21 Oct 2022 18:36:01 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 18:40:11 +0800
Received: from build.huawei.com (10.175.101.6) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 18:40:10 +0800
From:   Wenchao Hao <haowenchao@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Steffen Maier <maier@linux.ibm.com>, <liuzhiqiang26@huawei.com>,
        <linfeilong@huawei.com>, Wenchao Hao <haowenchao@huawei.com>
Subject: [PATCH v2 1/2] scsi: increase scsi device's iodone_cnt in scsi_timeout()
Date:   Fri, 21 Oct 2022 19:56:37 -0400
Message-ID: <20221021235638.1968832-2-haowenchao@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20221021235638.1968832-1-haowenchao@huawei.com>
References: <20221021235638.1968832-1-haowenchao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If an scsi command time out and going to be aborted, we should
increase the iodone_cnt of the related scsi device, or the
iodone_cnt would be less than iorequest_cnt

Increase iodone_cnt in scsi_timeout() would not cause double
accounting issue, briefly analysed as following:

 - we add the iodone_cnt when BLK_EH_DONE would be returned in
   scsi_timeout(), so the related scsi command's timeout event
   would not happened

 - if the abort succeed and do not retry, the command would be done
   with scsi_finish_command() which would not increase iodone_cnt;

 - if the abort succeed and retry the command, it would be requeue,
   a scsi_dispatch_cmd() would be called and iorequest_cnt would be
   increased again

 - if the abort failed, the error handler successfully recover the
   device, do not retry this command, the command would be done
   with scsi_finish_command() which would not increase iodone_cnt;

 - if the abort failed, the error handler successfully recover the
   device, and retry this command, the iorequest_cnt would be
   increased again

Signed-off-by: Wenchao Hao <haowenchao@huawei.com>
---
 drivers/scsi/scsi_error.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6995c8979230..052b00f57b56 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -356,6 +356,7 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
 		 */
 		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
 			return BLK_EH_RESET_TIMER;
+		atomic_inc(&scmd->device->iodone_cnt);
 		if (scsi_abort_command(scmd) != SUCCESS) {
 			set_host_byte(scmd, DID_TIME_OUT);
 			scsi_eh_scmd_add(scmd);
-- 
2.35.3

