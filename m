Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAD4C3F2D7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D00F20848
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgCEL7N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 06:59:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11155 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727273AbgCEL7I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Mar 2020 06:59:08 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E1343CA14452D41E5429;
        Thu,  5 Mar 2020 19:59:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 19:58:56 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.de>, <don.brace@microsemi.com>,
        <sumit.saxena@broadcom.com>, <hch@infradead.org>,
        <kashyap.desai@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <chenxiang66@hisilicon.com>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>
Subject: [PATCH RFC v6 10/10] hpsa: enable host_tagset and switch to MQ
Date:   Thu, 5 Mar 2020 19:54:40 +0800
Message-ID: <1583409280-158604-11-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

The smart array HBAs can steer interrupt completion, so this
patch switches the implementation to use multiqueue and enables
'host_tagset' as the HBA has a shared host-wide tagset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hpsa.c | 44 +++++++-------------------------------------
 drivers/scsi/hpsa.h |  1 -
 2 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1a4ddfacb458..a1d0e41a240a 100644
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
@@ -5632,8 +5635,6 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	/* Get the ptr to our adapter structure out of cmd->host. */
 	h = sdev_to_hba(cmd->device);
 
-	BUG_ON(cmd->request->tag < 0);
-
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
@@ -5809,7 +5810,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 	sh->hostdata[0] = (unsigned long) h;
 	sh->irq = pci_irq_vector(h->pdev, 0);
 	sh->unique_id = sh->irq;
-
+	sh->nr_hw_queues = h->msix_vectors > 0 ? h->msix_vectors : 1;
 	h->scsi_host = sh;
 	return 0;
 }
@@ -5835,7 +5836,8 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
  */
 static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
 {
-	int idx = scmd->request->tag;
+	u32 blk_tag = blk_mq_unique_tag(scmd->request);
+	int idx = blk_mq_unique_tag_to_tag(blk_tag);
 
 	if (idx < 0)
 		return idx;
@@ -7435,26 +7437,6 @@ static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
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
@@ -7851,9 +7833,6 @@ static int hpsa_pci_init(struct ctlr_info *h)
 	if (err)
 		goto clean1;
 
-	/* setup mapping between CPU and reply queue */
-	hpsa_setup_reply_map(h);
-
 	err = hpsa_pci_find_memory_BAR(h->pdev, &h->paddr);
 	if (err)
 		goto clean2;	/* intmode+region, pci */
@@ -8579,7 +8558,6 @@ static struct workqueue_struct *hpsa_create_controller_wq(struct ctlr_info *h,
 
 static void hpda_free_ctlr_info(struct ctlr_info *h)
 {
-	kfree(h->reply_map);
 	kfree(h);
 }
 
@@ -8588,14 +8566,6 @@ static struct ctlr_info *hpda_alloc_ctlr_info(void)
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
2.17.1

