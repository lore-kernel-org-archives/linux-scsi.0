Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B02BC10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2999221D56
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgCJQbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:31:48 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35780 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727097AbgCJQap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:45 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 079F44E3E4A0CD650864;
        Wed, 11 Mar 2020 00:30:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:24 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 02/24] scsi: allocate separate queue for reserved commands
Date:   Wed, 11 Mar 2020 00:25:28 +0800
Message-ID: <1583857550-12049-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Allocate a separate 'reserved_cmd_q' for sending reserved commands.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c  | 17 ++++++++++++++++-
 include/scsi/scsi_host.h |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2967325df7a0..e809b0e30a11 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1881,6 +1881,7 @@ struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
 int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
+	int ret;
 
 	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
 				scsi_mq_inline_sgl_size(shost));
@@ -1904,11 +1905,25 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	shost->tag_set.driver_data = shost;
 
-	return blk_mq_alloc_tag_set(&shost->tag_set);
+	ret = blk_mq_alloc_tag_set(&shost->tag_set);
+	if (ret)
+		return ret;
+
+	if (shost->nr_reserved_cmds) {
+		shost->reserved_cmd_q = blk_mq_init_queue(&shost->tag_set);
+		if (IS_ERR(shost->reserved_cmd_q)) {
+			blk_mq_free_tag_set(&shost->tag_set);
+			ret = PTR_ERR(shost->reserved_cmd_q);
+			shost->reserved_cmd_q = NULL;
+		}
+	}
+	return ret;
 }
 
 void scsi_mq_destroy_tags(struct Scsi_Host *shost)
 {
+	if (shost->reserved_cmd_q)
+		blk_cleanup_queue(shost->reserved_cmd_q);
 	blk_mq_free_tag_set(&shost->tag_set);
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3f860c8ad623..2258a4f7b4d8 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -604,6 +604,7 @@ struct Scsi_Host {
 	 * Number of reserved commands, if any.
 	 */
 	unsigned nr_reserved_cmds;
+	struct request_queue *reserved_cmd_q;
 
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
-- 
2.17.1

