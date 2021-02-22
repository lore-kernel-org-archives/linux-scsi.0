Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4BAC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEBA464E27
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhBVNa2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:30:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:47794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhBVN2Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:28:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DF3F7AFF5;
        Mon, 22 Feb 2021 13:24:15 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/31] scsi: implement reserved command handling
Date:   Mon, 22 Feb 2021 14:23:46 +0100
Message-Id: <20210222132405.91369-13-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Quite some drivers are using management commands internally, which
typically use the same hardware tag pool (ie they are being allocated
from the same hardware resources) as the 'normal' I/O commands.
These commands are set aside before allocating the block-mq tag bitmap,
so they'll never show up as busy in the tag map.
The block-layer, OTOH, already has 'reserved_tags' to handle precisely
this situation.
So this patch adds a new field 'nr_reserved_cmds' to the SCSI host
template to instruct the block layer to set aside a tag space for these
management commands by using reserved tags.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c     |  3 +++
 drivers/scsi/scsi_lib.c  | 10 +++++++++-
 include/scsi/scsi_host.h | 22 +++++++++++++++++++++-
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 2f162603876f..661ed7696562 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -469,6 +469,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	if (sht->virt_boundary_mask)
 		shost->virt_boundary_mask = sht->virt_boundary_mask;
 
+	if (sht->nr_reserved_cmds)
+		shost->nr_reserved_cmds = sht->nr_reserved_cmds;
+
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5cb464972682..90af1ab6f4f5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1916,7 +1916,9 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	else
 		tag_set->ops = &scsi_mq_ops_no_commit;
 	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
-	tag_set->queue_depth = shost->can_queue;
+	tag_set->queue_depth =
+		shost->can_queue + shost->nr_reserved_cmds;
+	tag_set->reserved_tags = shost->nr_reserved_cmds;
 	tag_set->cmd_size = cmd_size;
 	tag_set->numa_node = NUMA_NO_NODE;
 	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
@@ -1941,6 +1943,9 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
  * @op_flags: request allocation flags
  *
  * Allocates a SCSI command for internal LLDD use.
+ * If 'nr_reserved_commands' is spectified by the host the
+ * command will be allocated from the reserved tag pool;
+ * otherwise the normal tag pool will be used.
  */
 struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
 	enum dma_data_direction data_direction, int op_flags)
@@ -1950,6 +1955,9 @@ struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
 	blk_mq_req_flags_t flags = 0;
 	unsigned int op = REQ_INTERNAL | op_flags;
 
+	if (sdev->host->nr_reserved_cmds)
+		flags = BLK_MQ_REQ_RESERVED;
+
 	op |= (data_direction == DMA_TO_DEVICE) ?
 		REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN;
 	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ecc2d9dcfdf3..e826658bcecf 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -348,10 +348,19 @@ struct scsi_host_template {
 	/*
 	 * This determines if we will use a non-interrupt driven
 	 * or an interrupt driven scheme.  It is set to the maximum number
-	 * of simultaneous commands a single hw queue in HBA will accept.
+	 * of simultaneous commands a single hw queue in HBA will accept
+	 * excluding internal commands.
 	 */
 	int can_queue;
 
+	/*
+	 * This determines how many commands the HBA will set aside
+	 * for internal commands. This number will be added to
+	 * @can_queue to calcumate the maximum number of simultaneous
+	 * commands sent to the host.
+	 */
+	int nr_reserved_cmds;
+
 	/*
 	 * In many instances, especially where disconnect / reconnect are
 	 * supported, our host also has an ID on the SCSI bus.  If this is
@@ -599,6 +608,11 @@ struct Scsi_Host {
 	unsigned short max_cmd_len;
 
 	int this_id;
+
+	/*
+	 * Number of commands this host can handle at the same time.
+	 * This excludes reserved commands as specified by nr_reserved_cmds.
+	 */
 	int can_queue;
 	short cmd_per_lun;
 	short unsigned int sg_tablesize;
@@ -616,6 +630,12 @@ struct Scsi_Host {
 	 * the total queue depth is can_queue.
 	 */
 	unsigned nr_hw_queues;
+
+	/*
+	 * Number of reserved commands to allocate, if any.
+	 */
+	unsigned nr_reserved_cmds;
+
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
 
-- 
2.29.2

