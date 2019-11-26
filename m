Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB64C33C99
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 09:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E3DB20678
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 09:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfKZJOa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 04:14:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:41714 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727464AbfKZJO2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 04:14:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E5C55BA49;
        Tue, 26 Nov 2019 09:14:23 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/8] hpsa: switch to using blk-mq
Date:   Tue, 26 Nov 2019 10:14:16 +0100
Message-Id: <20191126091416.20052-9-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191126091416.20052-1-hare@suse.de>
References: <20191126091416.20052-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Enable host_tagset and switch to using blk-mq.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hpsa.c | 44 +++++++-------------------------------------
 drivers/scsi/hpsa.h |  1 -
 2 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ac39ed79ccaa..2b811c981b43 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -974,6 +974,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.shost_attrs = hpsa_shost_attrs,
 	.max_sectors = 2048,
 	.no_write_same = 1,
+	.host_tagset = 1,
 };
 
 static inline u32 next_command(struct ctlr_info *h, u8 q)
@@ -1138,12 +1139,14 @@ static void dial_up_lockup_detection_on_fw_flash_complete(struct ctlr_info *h,
 static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
 	struct CommandList *c, int reply_queue)
 {
+	u32 blk_tag = blk_mq_unique_tag(c->scsi_cmd->request);
+
 	dial_down_lockup_detection_during_fw_flash(h, c);
 	atomic_inc(&h->commands_outstanding);
 	if (c->device)
 		atomic_inc(&c->device->commands_outstanding);
 
-	reply_queue = h->reply_map[raw_smp_processor_id()];
+	reply_queue = blk_mq_unique_tag_to_hwq(blk_tag);
 	switch (c->cmd_type) {
 	case CMD_IOACCEL1:
 		set_ioaccel1_performant_mode(h, c, reply_queue);
@@ -5628,8 +5631,6 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	/* Get the ptr to our adapter structure out of cmd->host. */
 	h = sdev_to_hba(cmd->device);
 
-	BUG_ON(cmd->request->tag < 0);
-
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
@@ -5805,7 +5806,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 	sh->hostdata[0] = (unsigned long) h;
 	sh->irq = pci_irq_vector(h->pdev, 0);
 	sh->unique_id = sh->irq;
-
+	sh->nr_hw_queues = h->msix_vectors > 0 ? h->msix_vectors : 1;
 	h->scsi_host = sh;
 	return 0;
 }
@@ -5831,7 +5832,8 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
  */
 static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
 {
-	int idx = scmd->request->tag;
+	u32 blk_tag = blk_mq_unique_tag(scmd->request);
+	int idx = blk_mq_unique_tag_to_tag(blk_tag);
 
 	if (idx < 0)
 		return idx;
@@ -7431,26 +7433,6 @@ static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
 	h->msix_vectors = 0;
 }
 
-static void hpsa_setup_reply_map(struct ctlr_info *h)
-{
-	const struct cpumask *mask;
-	unsigned int queue, cpu;
-
-	for (queue = 0; queue < h->msix_vectors; queue++) {
-		mask = pci_irq_get_affinity(h->pdev, queue);
-		if (!mask)
-			goto fallback;
-
-		for_each_cpu(cpu, mask)
-			h->reply_map[cpu] = queue;
-	}
-	return;
-
-fallback:
-	for_each_possible_cpu(cpu)
-		h->reply_map[cpu] = 0;
-}
-
 /* If MSI/MSI-X is supported by the kernel we will try to enable it on
  * controllers that are capable. If not, we use legacy INTx mode.
  */
@@ -7847,9 +7829,6 @@ static int hpsa_pci_init(struct ctlr_info *h)
 	if (err)
 		goto clean1;
 
-	/* setup mapping between CPU and reply queue */
-	hpsa_setup_reply_map(h);
-
 	err = hpsa_pci_find_memory_BAR(h->pdev, &h->paddr);
 	if (err)
 		goto clean2;	/* intmode+region, pci */
@@ -8575,7 +8554,6 @@ static struct workqueue_struct *hpsa_create_controller_wq(struct ctlr_info *h,
 
 static void hpda_free_ctlr_info(struct ctlr_info *h)
 {
-	kfree(h->reply_map);
 	kfree(h);
 }
 
@@ -8584,14 +8562,6 @@ static struct ctlr_info *hpda_alloc_ctlr_info(void)
 	struct ctlr_info *h;
 
 	h = kzalloc(sizeof(*h), GFP_KERNEL);
-	if (!h)
-		return NULL;
-
-	h->reply_map = kcalloc(nr_cpu_ids, sizeof(*h->reply_map), GFP_KERNEL);
-	if (!h->reply_map) {
-		kfree(h);
-		return NULL;
-	}
 	return h;
 }
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index f8c88fc7b80a..ea4a609e3eb7 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -161,7 +161,6 @@ struct bmic_controller_parameters {
 #pragma pack()
 
 struct ctlr_info {
-	unsigned int *reply_map;
 	int	ctlr;
 	char	devname[8];
 	char    *product_name;
-- 
2.16.4

