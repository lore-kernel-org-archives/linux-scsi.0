Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8B2C4332D
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D6A264F59
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhCSC4H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 22:56:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14400 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbhCSCzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 22:55:46 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F1pPv1t1Qzkbx8;
        Fri, 19 Mar 2021 10:54:11 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Fri, 19 Mar 2021
 10:55:34 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <axboe@kernel.dk>, <ming.lei@redhat.com>, <hch@lst.de>,
        <keescook@chromium.org>, <kbusch@kernel.org>,
        <linux-block@vger.kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 2/3] scsi: only copy data to user when the whole result is good
Date:   Fri, 19 Mar 2021 11:01:27 +0800
Message-ID: <20210319030128.1345061-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210319030128.1345061-1-yanaijie@huawei.com>
References: <20210319030128.1345061-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the scsi device status is offline, mode sense command will return a
result with only DID_NO_CONNECT set. Then in sg_scsi_ioctl(),
only status byte of the result is checked, and because of
bug [1], garbage data is copied to the userspace.

Only copy the buffer to userspace when the whole result is good.

[1] https://patchwork.kernel.org/project/linux-block/patch/20210318122621.330010-1-yanaijie@huawei.com/

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 block/scsi_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 6599bac0a78c..359bf0003af4 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -503,7 +503,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 			if (copy_to_user(sic->data, req->sense, bytes))
 				err = -EFAULT;
 		}
-	} else {
+	} else if (scsi_result_is_good(req->result)) {
 		if (copy_to_user(sic->data, buffer, out_len))
 			err = -EFAULT;
 	}
-- 
2.25.4

