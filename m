Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3560C43462
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C7B610A0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhECPEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 11:04:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:40900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhECPEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 11:04:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9E38BB1C2;
        Mon,  3 May 2021 15:03:44 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/18] scsi: implement reserved command handling
Date:   Mon,  3 May 2021 17:03:25 +0200
Message-Id: <20210503150333.130310-11-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210503150333.130310-1-hare@suse.de>
References: <20210503150333.130310-1-hare@suse.de>
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
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hosts.c      |  3 +++
 drivers/scsi/scsi_lib.c   | 10 +++++++++-
 drivers/scsi/scsi_sysfs.c |  2 ++
 include/scsi/scsi_host.h  | 22 +++++++++++++++++++++-
 4 files changed, 35 insertions(+), 2 deletions(-)

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
index f83b04e49bae..3c83b0fabefb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1971,7 +1971,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		tag_set->ops = &scsi_mq_ops_no_commit;
 	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
 	tag_set->nr_maps = shost->nr_maps ? : 1;
-	tag_set->queue_depth = shost->can_queue;
+	tag_set->queue_depth = shost->can_queue + shost->nr_reserved_cmds;
+	tag_set->reserved_tags = shost->nr_reserved_cmds;
 	tag_set->cmd_size = cmd_size;
 	tag_set->numa_node = NUMA_NO_NODE;
 	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
@@ -1996,6 +1997,9 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
  * @flags: BLK_MQ_REQ_* flags, e.g. BLK_MQ_REQ_NOWAIT.
  *
  * Allocates a SCSI command for internal LLDD use.
+ * If 'nr_reserved_commands' is specified by the host the
+ * command will be allocated from the reserved tag pool;
+ * otherwise the normal tag pool will be used.
  */
 struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
 	unsigned int op, blk_mq_req_flags_t flags)
@@ -2005,6 +2009,10 @@ struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
 
 	WARN_ON_ONCE(((op & REQ_OP_MASK) != REQ_OP_SCSI_IN) &&
 		     ((op & REQ_OP_MASK) != REQ_OP_SCSI_OUT));
+
+	if (sdev->host->nr_reserved_cmds)
+		flags |= BLK_MQ_REQ_RESERVED;
+
 	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
 	if (IS_ERR(rq))
 		return NULL;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d5260d1b7b38..f4119999a402 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -371,6 +371,7 @@ static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%d\n");
+shost_rd_attr(nr_reserved_cmds, "%d\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(sg_prot_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
@@ -422,6 +423,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_host_reset.attr,
 	&dev_attr_eh_deadline.attr,
 	&dev_attr_nr_hw_queues.attr,
+	&dev_attr_nr_reserved_cmds.attr,
 	NULL
 };
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f115150559ca..0831b33ee186 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -367,10 +367,19 @@ struct scsi_host_template {
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
+	 * @can_queue to calculate the maximum number of simultaneous
+	 * commands sent to the host.
+	 */
+	int nr_reserved_cmds;
+
 	/*
 	 * In many instances, especially where disconnect / reconnect are
 	 * supported, our host also has an ID on the SCSI bus.  If this is
@@ -614,6 +623,11 @@ struct Scsi_Host {
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
@@ -632,6 +646,12 @@ struct Scsi_Host {
 	 */
 	unsigned nr_hw_queues;
 	unsigned nr_maps;
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

