Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5754C77B7E
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 21:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346048AbjD1VH7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 17:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjD1VH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 17:07:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D228AE69;
        Fri, 28 Apr 2023 14:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682716077; x=1714252077;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tD9qOeu/Elao5wbiibECWMxhAjUFS+S00Z29+QgzHWY=;
  b=0cBRFESvMDKkFk0gzVm2l7rdlHZNQvPl7r6R/QV/o2IhKjWbcYn5YPcC
   6TpKTWJFVtuE81D8LI7FRVfWy7X2sNdv4JTvoXQTURjcBgVvnCm/SDVJv
   uqkTer/n0T3xDpBmaMSSq9c6vwPHbALHOEmUGOFE5RuuMniLgjDHWVCDk
   0MWOEDgQJgXYlYOp1OnJPnubpCpTku3uT2RUzO5SNFvjl/whJr7KiK4/U
   w3UQqVjpc3jSl+4RaApKuETVpVYlAJQxTXstNsj8QMKWKfi41szAuXc/q
   KqG0Yt8Jv8S4WDV0HAau+7sc7cyLx0J666PzwlhzPbyzTdM7XGz6LEbLo
   w==;
X-IronPort-AV: E=Sophos;i="5.99,235,1677567600"; 
   d="scan'208";a="211700208"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 14:07:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 14:07:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 14:07:54 -0700
From:   Sagar Biradar <sagar.biradar@microchip.com>
To:     Don Brace <don.brace@microchip.com>,
        Sagar Biradar <sagar.biradar@microchip.com>,
        Gilbert Wu <gilbert.wu@microchip.com>,
        <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        <stable@vger.kernel.org>, Tom White <tom.white@microchip.com>
Subject: [PATCH v2] aacraid: reply queue mapping to CPUs based of IRQ affinity
Date:   Fri, 28 Apr 2023 14:07:51 -0700
Message-ID: <20230428210751.29722-1-sagar.biradar@microchip.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the IO hang that arises because of MSIx vector not
having a mapped online CPU upon receiving completion.
This patch sets up a reply queue mapping to CPUs based on the
IRQ affinity retrieved using pci_irq_get_affinity() API.

aac_setup_reply_map() is an explicit mapping for internally
generated (non-SCSI) cmds.
The SCSI cmds take the blk_mq route, and the non-SCSI cmds are mapped
to the reply_map.

Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
---
 drivers/scsi/aacraid/aacraid.h  |  1 +
 drivers/scsi/aacraid/comminit.c | 32 ++++++++++++++++++++++++++++++++
 drivers/scsi/aacraid/commsup.c  |  6 +++++-
 drivers/scsi/aacraid/linit.c    | 25 +++++++++++++++++++++++++
 drivers/scsi/aacraid/src.c      | 13 +++++++++++--
 5 files changed, 74 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 5e115e8b2ba4..20f8560a3038 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1678,6 +1678,7 @@ struct aac_dev
 	u32			handle_pci_error;
 	bool			init_reset;
 	u8			soft_reset_support;
+	unsigned int		*reply_map;
 };
 
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index bd99c5492b7d..6f4e40cdaade 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -33,6 +33,8 @@
 
 #include "aacraid.h"
 
+void aac_setup_reply_map(struct aac_dev *dev);
+
 struct aac_common aac_config = {
 	.irq_mod = 1
 };
@@ -630,6 +632,9 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 
 	if (aac_is_src(dev))
 		aac_define_int_mode(dev);
+
+	aac_setup_reply_map(dev);
+
 	/*
 	 *	Ok now init the communication subsystem
 	 */
@@ -658,3 +663,30 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	return dev;
 }
 
+/*
+ * aac_setup_reply_map -  This is an explicit mapping for
+ * internally generated (non-SCSI) cmds which need to be
+ * serviced outside of IO requests.
+ * The SCSI cmds take the blk_mq mechanism,
+ * and the non-SCSI cmds are mapped to the reply_map.
+ */
+void aac_setup_reply_map(struct aac_dev *dev)
+{
+	const struct cpumask *mask;
+	unsigned int i, cpu = 1;
+
+	for (i = 1; i < dev->max_msix; i++) {
+		mask = pci_irq_get_affinity(dev->pdev, i);
+		if (!mask)
+			goto fallback;
+
+		for_each_cpu(cpu, mask) {
+			dev->reply_map[cpu] = i;
+		}
+	}
+	return;
+
+fallback:
+	for_each_possible_cpu(cpu)
+		dev->reply_map[cpu] = 0;
+}
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index deb32c9f4b3e..3f062e4013ab 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -223,8 +223,12 @@ int aac_fib_setup(struct aac_dev * dev)
 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 {
 	struct fib *fibptr;
+	u32 blk_tag;
+	int i;
 
-	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
+	blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+	i = blk_mq_unique_tag_to_tag(blk_tag);
+	fibptr = &dev->fibs[i];
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 5ba5c18b77b4..077adbcde909 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/msdos_partition.h>
+#include <linux/blk-mq-pci.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -505,6 +506,16 @@ static int aac_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static void aac_map_queues(struct Scsi_Host *shost)
+{
+	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
+
+	blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+				aac->pdev, 0);
+}
+
+
+
 /**
  *	aac_change_queue_depth		-	alter queue depths
  *	@sdev:	SCSI device we are considering
@@ -1489,6 +1500,7 @@ static struct scsi_host_template aac_driver_template = {
 	.bios_param			= aac_biosparm,
 	.shost_groups			= aac_host_groups,
 	.slave_configure		= aac_slave_configure,
+	.map_queues			= aac_map_queues,
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_groups			= aac_dev_groups,
 	.eh_abort_handler		= aac_eh_abort,
@@ -1668,6 +1680,14 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_free_host;
 	}
 
+	aac->reply_map = kzalloc(sizeof(unsigned int) * nr_cpu_ids,
+				GFP_KERNEL);
+	if (!aac->reply_map) {
+		error = -ENOMEM;
+		dev_err(&pdev->dev, "reply_map allocation failed\n");
+		goto out_free_host;
+	}
+
 	spin_lock_init(&aac->fib_lock);
 
 	mutex_init(&aac->ioctl_mutex);
@@ -1776,6 +1796,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_lun = AAC_MAX_LUN;
 
 	pci_set_drvdata(pdev, shost);
+	shost->nr_hw_queues = aac->max_msix;
+	shost->host_tagset = 1;
 
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
@@ -1797,6 +1819,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 				  aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
 	aac_adapter_ioremap(aac, 0);
+	/* By now we should have configured the reply_map */
+	kfree(aac->reply_map);
 	kfree(aac->fibs);
 	kfree(aac->fsa_dev);
  out_free_host:
@@ -1918,6 +1942,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 
 	aac_adapter_ioremap(aac, 0);
 
+	kfree(aac->reply_map);
 	kfree(aac->fibs);
 	kfree(aac->fsa_dev);
 
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 11ef58204e96..46c0f4df995d 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -493,6 +493,8 @@ static int aac_src_deliver_message(struct fib *fib)
 #endif
 
 	u16 vector_no;
+	struct scsi_cmnd *scmd;
+	u32 blk_tag;
 
 	atomic_inc(&q->numpending);
 
@@ -505,8 +507,15 @@ static int aac_src_deliver_message(struct fib *fib)
 		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
 			&& dev->sa_firmware)
 			vector_no = aac_get_vector(dev);
-		else
-			vector_no = fib->vector_no;
+		else {
+			if (!fib->vector_no || !fib->callback_data) {
+				vector_no = dev->reply_map[raw_smp_processor_id()];
+			} else {
+				scmd = (struct scsi_cmnd *)fib->callback_data;
+				blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+				vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
+			}
+		}
 
 		if (native_hba) {
 			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {
-- 
2.29.0

