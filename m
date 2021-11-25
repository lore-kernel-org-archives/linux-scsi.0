Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D144CC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355967AbhKYPQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:15 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35572 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347856AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0FB9A212BD;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iM2GjXafZNlioaQ0AMIJlIjOzPaHTWYlGaYd5U4adSI=;
        b=MHyYY6jsT75mGsJmYt2xS/ClT/LVd2vbPyTm7vZ6c5kYzM3pDBxE5iH9MlAI2n+pP+m4T3
        yXnJ1GU3OksiNmLGUd4KVxViCajjo/J2nBJ5sgtos4K3St45s/1bgGMX2rkJp0wD1oBdGa
        aLGa3xMF9VPRcA/WBA5N92G9IHEhcvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iM2GjXafZNlioaQ0AMIJlIjOzPaHTWYlGaYd5U4adSI=;
        b=FhzqehWswRUwaZWg+1qBKSqaKUYfPljUzLhxYaahipDBqAMl3iSHbRgUY466UuzcrJUJVr
        tLnLm7krbDZ4i/AQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id AD160A3B8A;
        Thu, 25 Nov 2021 15:11:01 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9B8B451919F2; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/15] scsi: implement reserved command handling
Date:   Thu, 25 Nov 2021 16:10:36 +0100
Message-Id: <20211125151048.103910-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
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
 drivers/scsi/scsi_lib.c  |  9 ++++++++-
 include/scsi/scsi_host.h | 22 +++++++++++++++++++++-
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index a539fa2fb221..8ee7a7279b6b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -482,6 +482,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	if (sht->virt_boundary_mask)
 		shost->virt_boundary_mask = sht->virt_boundary_mask;
 
+	if (sht->nr_reserved_cmds)
+		shost->nr_reserved_cmds = sht->nr_reserved_cmds;
+
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6fbd36c9c416..e8f1025d0ed8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1939,7 +1939,9 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		tag_set->ops = &scsi_mq_ops_no_commit;
 	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
 	tag_set->nr_maps = shost->nr_maps ? : 1;
-	tag_set->queue_depth = shost->can_queue;
+	tag_set->queue_depth =
+		shost->can_queue + shost->nr_reserved_cmds;
+	tag_set->reserved_tags = shost->nr_reserved_cmds;
 	tag_set->cmd_size = cmd_size;
 	tag_set->numa_node = NUMA_NO_NODE;
 	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
@@ -1964,6 +1966,9 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
  * @nowait: do not wait for command allocation to succeed.
  *
  * Allocates a SCSI command for internal LLDD use.
+ * If 'nr_reserved_commands' is spectified by the host the
+ * command will be allocated from the reserved tag pool;
+ * otherwise the normal tag pool will be used.
  */
 struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
 	int data_direction, bool nowait)
@@ -1973,6 +1978,8 @@ struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
 	blk_mq_req_flags_t flags = 0;
 	int op;
 
+	if (sdev->host->nr_reserved_cmds)
+		flags |= BLK_MQ_REQ_RESERVED;
 	if (nowait)
 		flags |= BLK_MQ_REQ_NOWAIT;
 	op = (data_direction == DMA_TO_DEVICE) ?
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 6f49a8940dc4..7512d97aceb4 100644
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
+	 * @can_queue to calcumate the maximum number of simultaneous
+	 * commands sent to the host.
+	 */
+	int nr_reserved_cmds;
+
 	/*
 	 * In many instances, especially where disconnect / reconnect are
 	 * supported, our host also has an ID on the SCSI bus.  If this is
@@ -608,6 +617,11 @@ struct Scsi_Host {
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
@@ -626,6 +640,12 @@ struct Scsi_Host {
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
 
 	/*
-- 
2.29.2

