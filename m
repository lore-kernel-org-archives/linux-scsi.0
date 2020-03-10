Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22694C18E5C
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB56221D56
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCJQak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:30:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35482 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726703AbgCJQaj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:39 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B99CE405C853ED6677D0;
        Wed, 11 Mar 2020 00:30:33 +0800 (CST)
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
Subject: [PATCH RFC v2 01/24] scsi: add 'nr_reserved_cmds' field to the SCSI host template
Date:   Wed, 11 Mar 2020 00:25:27 +0800
Message-ID: <1583857550-12049-2-git-send-email-john.garry@huawei.com>
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

Add a new field 'nr_reserved_cmds' to the SCSI host template to
instruct the block layer to set aside a tag space for reserved
commands.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c  | 1 +
 include/scsi/scsi_host.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41fa54c..2967325df7a0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1896,6 +1896,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		shost->tag_set.ops = &scsi_mq_ops_no_commit;
 	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
 	shost->tag_set.queue_depth = shost->can_queue;
+	shost->tag_set.reserved_tags = shost->nr_reserved_cmds;
 	shost->tag_set.cmd_size = cmd_size;
 	shost->tag_set.numa_node = NUMA_NO_NODE;
 	shost->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f577647bf5f2..3f860c8ad623 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -599,6 +599,12 @@ struct Scsi_Host {
 	 * is nr_hw_queues * can_queue.
 	 */
 	unsigned nr_hw_queues;
+
+	/*
+	 * Number of reserved commands, if any.
+	 */
+	unsigned nr_reserved_cmds;
+
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
 
-- 
2.17.1

