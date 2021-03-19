Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3E5C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D157364F33
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhCSC4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 22:56:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14399 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbhCSCzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 22:55:46 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F1pPv1YdMzkbQc;
        Fri, 19 Mar 2021 10:54:11 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Fri, 19 Mar 2021
 10:55:35 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <axboe@kernel.dk>, <ming.lei@redhat.com>, <hch@lst.de>,
        <keescook@chromium.org>, <kbusch@kernel.org>,
        <linux-block@vger.kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 3/3] scsi: switch to use scsi_result_is_good() in scsi_result_to_blk_status()
Date:   Fri, 19 Mar 2021 11:01:28 +0800
Message-ID: <20210319030128.1345061-4-yanaijie@huawei.com>
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

Use scsi_result_is_good() to simplify the code.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7d52a11e1b61..d1ec9f6a93f0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -626,7 +626,7 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 		 * to handle the case when a SCSI LLD sets result to
 		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
 		 */
-		if (scsi_status_is_good(result) && (result & ~0xff) == 0)
+		if (scsi_result_is_good(result))
 			return BLK_STS_OK;
 		return BLK_STS_IOERR;
 	case DID_TRANSPORT_FAILFAST:
-- 
2.25.4

