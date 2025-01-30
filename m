Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D504C7C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738258442; cv=none; b=N1azBwkJla3JlNK+hmru3raUS/9oI4iM6UjKdOiOW0ENOfvhzI7JEjuJ39m6orRW1CiT7U4GE+H9Xkdb2fiNKWDPvr4dJKxcY1539ITrPZ1fh/VO8RXDDN/C1WUMTsRwJweuT24Y5x9u7tbB6eHBAwPczp8EbqsoUiS9+vAIzbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738258442; c=relaxed/simple;
	bh=/PVlMCZbWNwWyxcgwJQ6l+Oz0UVPDjRxgSCIia4wtnQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LzvqNj8lPIygmFevgjbLgtLeqyYEXcbV2mhpUXs3THe2YpJy2t+gwu6O/Y+RPQrL1xOyxP+MsWjggdPXFC/osF4bPxxfdprBfNpjcdMZo3CzuEI0xlZVIBkLvEP36HHIHYcwH4FNIACb6djoxR5/9vVxPPV3bxnEIp7UqfD/LcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=RoCU2fWQ; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="RoCU2fWQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1738258440; x=1769794440;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/PVlMCZbWNwWyxcgwJQ6l+Oz0UVPDjRxgSCIia4wtnQ=;
  b=RoCU2fWQYlXTUhI22JfB6yfiyA8mKH25Birci5v1TXP6gbr9XAJsmD0C
   D88wEKBKXDwQbdYt+4VRQfVxt5/6eQM6L45pkEuscguIVjnBfV04bhoCM
   b+KOq/WdHlNUYN5FsSTqKPrKJ5dh0HZqcxvc3L8S1jp9aqRMwDl0s8s+1
   8v8/Mk55A13xp1JdxyRjWMAeqmMc2dz3A5NjasGreMBdxll2oaVbhm4Wm
   48N5hWN9hgLCsoS29XvDKNDn1fKJpsI21vAuLr6iwkFc8s7I2cK4pNosE
   q4LwKH18tPvC63NhMZ5402rOSMENYiOS65x3dOUjDYWoOK9Til1T0K4Fj
   g==;
X-CSE-ConnectionGUID: 72brTRibSPmPwFNNwaFJDg==
X-CSE-MsgGUID: wtKSXltGSVCxiPucH/CBLg==
X-IronPort-AV: E=Sophos;i="6.13,246,1732604400"; 
   d="scan'208";a="41089965"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Jan 2025 10:33:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 30 Jan 2025 10:33:14 -0700
Received: from SJO-LT-C34249SMCTest.microsemi.net (10.10.85.11) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.35 via Frontend Transport; Thu, 30 Jan 2025 10:33:14 -0700
From: Sagar Biradar <sagar.biradar@microchip.com>
To: <linux-scsi@vger.kernel.org>, "Martin Petersen --to=James Bottomley
 --cc=John Meneghini"
	<martin.petersen@oracle.comjames.bottomley@hansenpartnership.comjmeneghi@redhat.com>
CC: Tomas Henzl <thenzl@redhat.com>, Marco Patalano <mpatalan@redhat.com>,
	Scott Benesh <Scott.Benesh@microchip.com>, Don Brace
	<Don.Brace@microchip.com>, Tom White <Tom.White@microchip.com>, "Abhinav
 Kuchibhotla" <Abhinav.Kuchibhotla@microchip.com>
Subject: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ affinity
Date: Thu, 30 Jan 2025 09:33:14 -0800
Message-ID: <20250130173314.608836-1-sagar.biradar@microchip.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

patch "(9dc704dcc09e scsi: aacraid: Reply queue mapping to
CPUs based on IRQ affinity)" caused issues starting V6.4.0,
which was later reverted by
patch "(c5becf57dd56 Revert "scsi: aacraid: Reply queue mapping to CPUs
based on IRQ affinity)"

Add a new modparam "aac_cpu_offline_feature" to control CPU offlining.
By default, it's disabled (0), but can be enabled during driver load
with:
	insmod ./aacraid.ko aac_cpu_offline_feature=1
Enabling this feature allows CPU offlining but may cause some IO
performance drop. It is recommended to enable it during driver load as
the relevant changes are part of the initialization routine.

Fixes an I/O hang that arises because of an MSIx vector not having a
mapped online CPU upon receiving completion.

SCSI cmds use the mq_map to get the vector_no via blk_mq_unique_tag()
and blk_mq_unique_tag_to_hwq() - which are setup during the blk_mq init.

For reserved cmds, or the ones before the blk_mq init, use the vector_no
0, which is the norm since don't yet have a proper mapping to the queues.

Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
Reviewed-by:John Meneghini <jmeneghi@redhat.com>
Reviewed-by:Tomas Henzl <thenzl@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
---
 drivers/scsi/aacraid/aachba.c  |  6 ++++++
 drivers/scsi/aacraid/aacraid.h |  2 ++
 drivers/scsi/aacraid/commsup.c |  9 ++++++++-
 drivers/scsi/aacraid/linit.c   | 24 ++++++++++++++++++++++++
 drivers/scsi/aacraid/src.c     | 28 ++++++++++++++++++++++++++--
 5 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index abf6a82b74af..f325e79a1a01 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -328,6 +328,12 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the arrays:\n"
 	"\t1 - Array Meta Data Signature (default)\n"
 	"\t2 - Adapter Serial Number");
 
+int aac_cpu_offline_feature;
+module_param_named(aac_cpu_offline_feature, aac_cpu_offline_feature, int, 0644);
+MODULE_PARM_DESC(aac_cpu_offline_feature,
+	"This enables CPU offline feature and may result in IO performance drop in some cases:\n"
+	"\t0 - Disable (default)\n"
+	"\t1 - Enable");
 
 static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
 		struct fib *fibptr) {
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 8c384c25dca1..dba7ffc6d543 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1673,6 +1673,7 @@ struct aac_dev
 	u32			handle_pci_error;
 	bool			init_reset;
 	u8			soft_reset_support;
+	u8			use_map_queue;
 };
 
 #define aac_adapter_interrupt(dev) \
@@ -2777,4 +2778,5 @@ extern int update_interval;
 extern int check_interval;
 extern int aac_check_reset;
 extern int aac_fib_dump;
+extern int aac_cpu_offline_feature;
 #endif
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index ffef61c4aa01..1d62730e5c1b 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -223,8 +223,15 @@ int aac_fib_setup(struct aac_dev * dev)
 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 {
 	struct fib *fibptr;
+	u32 blk_tag;
+	int i;
 
-	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
+	if (aac_cpu_offline_feature == 1) {
+		blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+		i = blk_mq_unique_tag_to_tag(blk_tag);
+		fibptr = &dev->fibs[i];
+	} else
+		fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 91170a67cc91..fc4d35950ccb 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -506,6 +506,23 @@ static int aac_sdev_configure(struct scsi_device *sdev,
 	return 0;
 }
 
+/**
+ *	aac_map_queues - Map hardware queues for the SCSI host
+ *	@shost: SCSI host structure
+ *
+ *	Maps the default hardware queue for the given SCSI host to the
+ *	corresponding PCI device and enables mapped queue usage.
+ */
+
+static void aac_map_queues(struct Scsi_Host *shost)
+{
+	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
+
+	blk_mq_map_hw_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+				&aac->pdev->dev, 0);
+	aac->use_map_queue = true;
+}
+
 /**
  *	aac_change_queue_depth		-	alter queue depths
  *	@sdev:	SCSI device we are considering
@@ -1490,6 +1507,7 @@ static const struct scsi_host_template aac_driver_template = {
 	.bios_param			= aac_biosparm,
 	.shost_groups			= aac_host_groups,
 	.sdev_configure			= aac_sdev_configure,
+	.map_queues			= aac_map_queues,
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_groups			= aac_dev_groups,
 	.eh_abort_handler		= aac_eh_abort,
@@ -1777,6 +1795,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_lun = AAC_MAX_LUN;
 
 	pci_set_drvdata(pdev, shost);
+	if (aac_cpu_offline_feature == 1) {
+		shost->nr_hw_queues = aac->max_msix;
+		shost->can_queue    = aac->vector_cap;
+		shost->host_tagset = 1;
+	}
 
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
@@ -1908,6 +1931,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	aac_cancel_rescan_worker(aac);
+	aac->use_map_queue = false;
 	scsi_remove_host(shost);
 
 	__aac_shutdown(aac);
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 28115ed637e8..b9bed3e255c4 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)
 #endif
 
 	u16 vector_no;
+	struct scsi_cmnd *scmd;
+	u32 blk_tag;
+	struct Scsi_Host *shost = dev->scsi_host_ptr;
+	struct blk_mq_queue_map *qmap;
 
 	atomic_inc(&q->numpending);
 
@@ -505,8 +509,28 @@ static int aac_src_deliver_message(struct fib *fib)
 		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
 			&& dev->sa_firmware)
 			vector_no = aac_get_vector(dev);
-		else
-			vector_no = fib->vector_no;
+		else {
+			if (aac_cpu_offline_feature == 1) {
+				if (!fib->vector_no || !fib->callback_data) {
+					if (shost && dev->use_map_queue) {
+						qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+					vector_no = qmap->mq_map[raw_smp_processor_id()];
+					}
+					/*
+					 *	We hardcode the vector_no for
+					 *	reserved commands as a valid shost is
+					 *	absent during the init
+					 */
+					else
+						vector_no = 0;
+				} else {
+					scmd = (struct scsi_cmnd *)fib->callback_data;
+					blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+					vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
+				}
+			} else
+				vector_no = fib->vector_no;
+		}
 
 		if (native_hba) {
 			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {
-- 
2.31.1

