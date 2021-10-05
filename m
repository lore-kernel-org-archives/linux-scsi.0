Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F72EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E1D61251
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhJEKak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:30:40 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3918 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbhJEKai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 06:30:38 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNty83YBSz67kfK;
        Tue,  5 Oct 2021 18:25:20 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 12:28:46 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 11:28:44 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v5 01/14] blk-mq: Change rqs check in blk_mq_free_rqs()
Date:   Tue, 5 Oct 2021 18:23:26 +0800
Message-ID: <1633429419-228500-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 21bf4c3f0825..bc8238ab1aef 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2342,7 +2342,7 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 {
 	struct page *page;
 
-	if (tags->rqs && set->ops->exit_request) {
+	if (tags->static_rqs && set->ops->exit_request) {
 		int i;
 
 		for (i = 0; i < tags->nr_tags; i++) {
-- 
2.26.2

