Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23FC207DFE
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 19:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750274688; cv=none; b=qr6uLPVoVgRvzUzFz9YWjGFuvZvWZLMzHXl28DHL5xbandrbG6qHtAJxQ7rhEv26QoMqttOgv2NIQg0V0u2BnfW+5xzNYfQ2IPtEkBExFdPuhRcZmDS6PZ0nE1oP2K4/ine+VJrMBwxhev+/P+IW5+pRAjwY2L54jI23hcjN7nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750274688; c=relaxed/simple;
	bh=/NNk+xDYkHLLPcQyn83HOi+4usToLHXcVycTLOO4Lbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=evlWYGs5fXijqfangqKiIxaGQp4yzXH9eeT9HFoPfiuWtpN0PI96fdDli7wL+tT45Rh9LrMvWhmfqLaA2Bd1+EYS4UhTpIVde9g+LYX6HNduwaAs3hDWFfPhkmCYSopaX1vQiMDpGuAglmqIQvp7iyZ8ECJAeO9aoIdrV3ho1x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZB/EpVFe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZB/EpVFe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750274684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SgCM0b6C1uE4ZAd4LogCpecVhPStmO4EChfm/sWzEb4=;
	b=ZB/EpVFefAzwtkJSM/8P0AgrHNK+AprDxFLIuA8WUeKS9Knx88++9AZqX2efkKiHcehoXY
	Yh1h9mLm0pbwOpvwEMmUfUJ7weYnAaoz48qHRzmU0WGWju3NzuuOtHGvQFjCTEJuEkjrJx
	6W+wUvQu2Ca/Sz6jufpXsuMQVJz7ox4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-Q6xFdzm0NXWSJGORpyh8vA-1; Wed,
 18 Jun 2025 15:24:38 -0400
X-MC-Unique: Q6xFdzm0NXWSJGORpyh8vA-1
X-Mimecast-MFC-AGG-ID: Q6xFdzm0NXWSJGORpyh8vA_1750274676
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32E9A1800343;
	Wed, 18 Jun 2025 19:24:36 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen3.rmtusnh.csb (unknown [10.22.64.21])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2348919560B0;
	Wed, 18 Jun 2025 19:24:32 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	aacraid@microsemi.com,
	corbet@lwn.net
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thenzl@redhat.com,
	Scott.Benesh@microchip.com,
	Don.Brace@microchip.com,
	Tom.White@microchip.com,
	Abhinav.Kuchibhotla@microchip.com,
	sagar.biradar@microchip.com,
	mpatalan@redhat.com
Subject: [PATCH v3] scsi: aacraid: Fix reply queue mapping to CPUs based on IRQ affinity
Date: Wed, 18 Jun 2025 15:24:27 -0400
Message-ID: <20250618192427.3845724-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Sagar Biradar <sagar.biradar@microchip.com>

From: Sagar Biradar <sagar.biradar@microchip.com>

This patch fixes a bug in the original path that caused I/O hangs. The
I/O hangs were because of an MSIx vector not having a mapped online CPU
upon receiving completion.

This patch enables Multi-Q support in the aacriad driver. Multi-Q support
in the driver is needed to support CPU offlining.

SCSI cmds use the mq_map to get the vector_no via blk_mq_unique_tag()
and blk_mq_unique_tag_to_hwq() - which are setup during the blk_mq init.
For reserved cmds, or the ones before the blk_mq init, use the vector_no
0, which is the norm since don't yet have a proper mapping to the queues.

Note that this change can cause a drop in performance in some
configurations. To address any concerns about performance the
CONFIG_SCSI_AACRAID_MULTIQ option has been added.

The CONFIG_SCSI_AACRAID_MULTIQ option is on by default to ensure that
CPU offlining with MultiQ support is enabled. To disable MultiQ support
compile the kernel with CONFIG_SCSI_AACRAID_MULTIQ=N. Disabling MultiQ
support should not be done if your application uses CPU offling.

Closes: https://lore.kernel.org/linux-scsi/20250130173314.608836-1-sagar.biradar@microchip.com/

Fixes: c5becf57dd56 ("Revert "scsi: aacraid: Reply queue mapping to CPUs based on IRQ affinity"")
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
[jmeneghi: replace aac_cpu_offline_feature with Kconfig option]
Co-developed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
---
 Documentation/scsi/aacraid.rst | 11 +++++++++++
 MAINTAINERS                    |  1 +
 drivers/scsi/Kconfig           |  2 +-
 drivers/scsi/aacraid/Kconfig   | 20 ++++++++++++++++++++
 drivers/scsi/aacraid/aachba.c  |  1 -
 drivers/scsi/aacraid/aacraid.h |  3 +++
 drivers/scsi/aacraid/commsup.c | 16 ++++++++++++++--
 drivers/scsi/aacraid/linit.c   | 23 ++++++++++++++++++++++-
 drivers/scsi/aacraid/src.c     | 28 +++++++++++++++++++++++++++-
 9 files changed, 99 insertions(+), 6 deletions(-)
 create mode 100644 drivers/scsi/aacraid/Kconfig

diff --git a/Documentation/scsi/aacraid.rst b/Documentation/scsi/aacraid.rst
index 1904674b94f3..0fc35edd0ac9 100644
--- a/Documentation/scsi/aacraid.rst
+++ b/Documentation/scsi/aacraid.rst
@@ -129,6 +129,17 @@ Supported Cards/Chipsets
 People
 ======
 
+Sagar Biradar <Sagar.Biradar@microchip.com>
+
+ - Added support for CPU offlining and updated the driver to support MultiQ.
+ - Introduced the option CONFIG_SCSI_AACRAID_MULTIQ to control this feature.
+
+By default, MultiQ support is disabled to provide optimal I/O performance.
+
+Enable CONFIG_SCSI_AACRAID_MULTIQ only if CPU offlining support is required,
+as enabling it may result in reduced performance in some configurations.
+Note : Disabling MultiQ while still offlining CPUs may lead to I/O hangs.
+
 Alan Cox <alan@lxorguk.ukuu.org.uk>
 
 Christoph Hellwig <hch@infradead.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index a92290fffa16..996c90959caa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -184,6 +184,7 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 W:	http://www.adaptec.com/
 F:	Documentation/scsi/aacraid.rst
+F:	drivers/scsi/aacraid/Kconfig
 F:	drivers/scsi/aacraid/
 
 AAEON UPBOARD FPGA MFD DRIVER
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5522310bab8d..a6739cd94db7 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -456,7 +456,7 @@ config SCSI_AACRAID
 	  To compile this driver as a module, choose M here: the module
 	  will be called aacraid.
 
-
+source "drivers/scsi/aacraid/Kconfig"
 source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
diff --git a/drivers/scsi/aacraid/Kconfig b/drivers/scsi/aacraid/Kconfig
new file mode 100644
index 000000000000..c69e1a7a77d2
--- /dev/null
+++ b/drivers/scsi/aacraid/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Kernel configuration file for the aacraid driver.
+#
+# Copyright (c) 2025 Microchip Technology Inc. and its subsidiaries
+#  (mailto:storagedev@microchip.com)
+#
+config SCSI_AACRAID_MULTIQ
+	bool "AACRAID Multiq support"
+	depends on SCSI_AACRAID
+	default n
+	help
+	  This option enables MultiQ support in the aacraid driver.
+
+	  Enabling MultiQ allows the driver to safely handle CPU offlining.
+	  However, it may cause a performance drop in certain configurations.
+
+	  Enable this option only if your system requires CPU offlining support.
+
+	  If unsure, say N.
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 0be719f38377..db9bef348834 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -328,7 +328,6 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the arrays:\n"
 	"\t1 - Array Meta Data Signature (default)\n"
 	"\t2 - Adapter Serial Number");
 
-
 static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
 		struct fib *fibptr) {
 	struct scsi_device *device;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 0a5888b53d6d..557f9fc50012 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1672,6 +1672,9 @@ struct aac_dev
 	u32			handle_pci_error;
 	bool			init_reset;
 	u8			soft_reset_support;
+#ifdef CONFIG_SCSI_AACRAID_MULTIQ
+	u8			use_map_queue;
+#endif
 };
 
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 7d9a4dce236b..309a166ce6e4 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -215,8 +215,17 @@ int aac_fib_setup(struct aac_dev * dev)
 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 {
 	struct fib *fibptr;
+#ifdef CONFIG_SCSI_AACRAID_MULTIQ
+	u32 blk_tag;
+	int i;
 
+	blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+	i = blk_mq_unique_tag_to_tag(blk_tag);
+	fibptr = &dev->fibs[i];
+#else
 	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
+#endif
+
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
@@ -242,14 +251,17 @@ struct fib *aac_fib_alloc(struct aac_dev *dev)
 {
 	struct fib * fibptr;
 	unsigned long flags;
+
 	spin_lock_irqsave(&dev->fib_lock, flags);
+	/*  Management FIB allocation: use free list within reserved range */
 	fibptr = dev->free_fib;
-	if(!fibptr){
+	if (!fibptr) {
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
-		return fibptr;
+		return NULL;
 	}
 	dev->free_fib = fibptr->next;
 	spin_unlock_irqrestore(&dev->fib_lock, flags);
+
 	/*
 	 *	Set the proper node type code and node byte size
 	 */
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 4b12e6dd8f07..8c56579a8efc 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -506,6 +506,17 @@ static int aac_sdev_configure(struct scsi_device *sdev,
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_AACRAID_MULTIQ
+static void aac_map_queues(struct Scsi_Host *shost)
+{
+	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
+	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+
+	blk_mq_map_hw_queues(qmap, &aac->pdev->dev, 0);
+	aac->use_map_queue = true;
+}
+#endif
+
 /**
  *	aac_change_queue_depth		-	alter queue depths
  *	@sdev:	SCSI device we are considering
@@ -1490,6 +1501,9 @@ static const struct scsi_host_template aac_driver_template = {
 	.bios_param			= aac_biosparm,
 	.shost_groups			= aac_host_groups,
 	.sdev_configure			= aac_sdev_configure,
+#ifdef CONFIG_SCSI_AACRAID_MULTIQ
+	.map_queues			= aac_map_queues,
+#endif
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_groups			= aac_dev_groups,
 	.eh_abort_handler		= aac_eh_abort,
@@ -1777,7 +1791,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_lun = AAC_MAX_LUN;
 
 	pci_set_drvdata(pdev, shost);
-
+#ifdef CONFIG_SCSI_AACRAID_MULTIQ
+	shost->nr_hw_queues = aac->max_msix;
+	shost->can_queue = min_t(int, aac->vector_cap, shost->can_queue);
+	shost->host_tagset = 1;
+#endif
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
 		goto out_deinit;
@@ -1908,6 +1926,9 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	aac_cancel_rescan_worker(aac);
+#ifdef CONFIG_SCSI_AACRAID_MULTIQ
+	aac->use_map_queue = false;
+#endif
 	scsi_remove_host(shost);
 
 	__aac_shutdown(aac);
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 28115ed637e8..5881bce3ccfc 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -493,6 +493,12 @@ static int aac_src_deliver_message(struct fib *fib)
 #endif
 
 	u16 vector_no;
+#ifdef CONFIG_SCSI_AACRAID_MULTIQ
+	struct scsi_cmnd *scmd;
+	u32 blk_tag;
+	struct Scsi_Host *shost = dev->scsi_host_ptr;
+	struct blk_mq_queue_map *qmap;
+#endif
 
 	atomic_inc(&q->numpending);
 
@@ -505,8 +511,28 @@ static int aac_src_deliver_message(struct fib *fib)
 		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
 			&& dev->sa_firmware)
 			vector_no = aac_get_vector(dev);
-		else
+		else {
+#ifdef CONFIG_SCSI_AACRAID_MULTIQ
+			if (!fib->vector_no || !fib->callback_data) {
+				if (shost && dev->use_map_queue) {
+					qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+					vector_no = qmap->mq_map[raw_smp_processor_id()];
+				}
+				/*
+				 *	We hardcode the vector_no for reserved commands
+				 *	as a valid shost is absent during the init.
+				 */
+				else
+					vector_no = 0;
+			} else {
+				scmd = (struct scsi_cmnd *)fib->callback_data;
+				blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+				vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
+			}
+#else
 			vector_no = fib->vector_no;
+#endif
+		}
 
 		if (native_hba) {
 			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {
-- 
2.49.0

