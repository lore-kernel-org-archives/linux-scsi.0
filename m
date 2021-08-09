Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A1AC43216
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5451A6101D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhHIOhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:37:37 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3607 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbhHIOfA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 10:35:00 -0400
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gjz9L3kDjz6C9Mp;
        Mon,  9 Aug 2021 22:33:58 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 9 Aug 2021 16:34:27 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 15:34:24 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        <hare@suse.de>, <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 01/11] blk-mq: Change rqs check in blk_mq_free_rqs()
Date:   Mon, 9 Aug 2021 22:29:28 +0800
Message-ID: <1628519378-211232-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The original code in commit 24d2f90309b23 ("blk-mq: split out tag
initialization, support shared tags") would check tags->rqs is non-NULL and
then dereference tags->rqs[].

Then in commit 2af8cbe30531 ("blk-mq: split tag ->rqs[] into two"), we
started to dereference tags->static_rqs[], but continued to check non-NULL
tags->rqs.

Check tags->static_rqs as non-NULL instead, which is more logical.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2c4ac51e54eb..ae28f470893c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2348,7 +2348,7 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 {
 	struct page *page;
 
-	if (tags->rqs && set->ops->exit_request) {
+	if (tags->static_rqs && set->ops->exit_request) {
 		int i;
 
 		for (i = 0; i < tags->nr_tags; i++) {
-- 
2.26.2

