Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE229C4CED2
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF4AE21929
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388871AbfISJpv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:45:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:59258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388084AbfISJpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 05:45:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D639CB6C9;
        Thu, 19 Sep 2019 09:45:49 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        Hans Holmberg <hans.holmberg@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 1/2] blk-mq: fixup request re-insert in blk_mq_try_issue_list_directly()
Date:   Thu, 19 Sep 2019 11:45:46 +0200
Message-Id: <20190919094547.67194-2-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190919094547.67194-1-hare@suse.de>
References: <20190919094547.67194-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

When blk_mq_request_issue_directly() returns BLK_STS_RESOURCE we
need to requeue the I/O, but adding it to the global request list
will mess up with the passed-in request list. So re-add the request
to the original list and leave it to the caller to handle situations
where the list wasn't completely emptied.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b038ec680e84..44ff3c1442a4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1899,8 +1899,7 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 		if (ret != BLK_STS_OK) {
 			if (ret == BLK_STS_RESOURCE ||
 					ret == BLK_STS_DEV_RESOURCE) {
-				blk_mq_request_bypass_insert(rq,
-							list_empty(list));
+				list_add(list, &rq->queuelist);
 				break;
 			}
 			blk_mq_end_request(rq, ret);
-- 
2.16.4

