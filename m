Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811BA18FDD2
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 21:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013570; cv=none; b=edaa07vdMVJJODX0bHt3y46pv3Sd0jTC4HiFxKKh+fp5Nt5/MzLNWnhSitWT4Z0HZJ7jYNmKLdHr8wgzQSdsxK1KlDSHr8+0TroTvWMk5XDVPfMQxbCX8utpUSklEPO+cFmyzjia60N6ZCCmQTTHLBu/H710Fl+QNiIJChKtptU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013570; c=relaxed/simple;
	bh=2aUMKu2SFgW3v/zrsM3RD1u7K+Wf1hdFKaJ4oOIwJ+g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=swZUvIhAaOVWA4xMyaFadWJ/tP67l4001jS8i9hVgjDt0YGi+YzN7nHHRcBtPXHvjvjbSbHYk5dnDVTuoVANTeA63eJOn1kPhEYm/kHgvrZ4zg09zQahlvW7JLqwkqa5iVIoPlCKcA/E0frTELrK/icR37TsvXO3ZyLIaW1IVXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=fyrj4EJG; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="fyrj4EJG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1738013568; x=1769549568;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2aUMKu2SFgW3v/zrsM3RD1u7K+Wf1hdFKaJ4oOIwJ+g=;
  b=fyrj4EJGm9UwXE6/7oNGX5HArxJtMI2Rn/vEV3rspxu8O2AUoMshT3eK
   1BkO8X9VN0eLxhN3vZH8lE+z7jQehbFG9dRhRzLU3b01/3gPUMW0oEr+r
   lEaDO2MklIqX04y6dYT7ESalp7A7mWNCbzNjc1C3I5hyYA1m/StXTI5Q2
   xIN+vAia6mALH04rbvMMv/Bgm5oxNXOG4zzmpsJUNdW8lGMNLLDaSXlIX
   gUe+uOwqcbrT9dqFzYLe14mMuKZsaN0dHEqh+tAxa/8S4WtfY8yEWJ287
   +e+xrQfKCr6NLknXR7zM8vUR9QKdRd3+we93pYLXvx4LkVGN2l4Da8Uzh
   g==;
X-CSE-ConnectionGUID: MLNPBM2wTDOD7Ih2H0I8wg==
X-CSE-MsgGUID: ynJ/vRgnQSWuVQVbrtKnBQ==
X-IronPort-AV: E=Sophos;i="6.13,239,1732604400"; 
   d="scan'208";a="204498193"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2025 14:32:47 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 27 Jan 2025 14:32:23 -0700
Received: from SJO-LT-C34249SMCTest.microsemi.net (10.10.85.11) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.35 via Frontend Transport; Mon, 27 Jan 2025 14:32:23 -0700
From: Sagar Biradar <sagar.biradar@microchip.com>
To: <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>, "Martin Petersen
 --to=James Bottomley --cc=John Meneghini"
	<martin.petersen@oracle.comjames.bottomley@hansenpartnership.comjmeneghi@redhat.com>
CC: Tomas Henzl <thenzl@redhat.com>, Marco Patalano <mpatalan@redhat.com>,
	Scott Benesh <Scott.Benesh@microchip.com>, Don Brace
	<Don.Brace@microchip.com>, Tom White <Tom.White@microchip.com>, "Abhinav
 Kuchibhotla" <Abhinav.Kuchibhotla@microchip.com>
Subject: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IRQ affinity
Date: Mon, 27 Jan 2025 13:32:23 -0800
Message-ID: <20250127213223.318751-1-sagar.biradar@microchip.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Fixes: "(c5becf57dd56 Revert "scsi: aacraid: Reply queue mapping to CPUs
based on IRQ affinity)"
Original patch: "(9dc704dcc09e scsi: aacraid: Reply queue mapping to
CPUs based on IRQ affinity)"

Fix a rare I/O hang that arises because of an MSIx vector not having a
mapped online CPU upon receiving completion.

A new modparam "aac_cpu_offline_feature" to control CPU offlining.
By default, it's disabled (0), but can be enabled during driver load
with:
	insmod ./aacraid.ko aac_cpu_offline_feature=1
Enabling this feature allows CPU offlining but may cause some IO
performance drop. It is recommended to enable it during driver load
as the relevant changes are part of the initialization routine.

SCSI cmds use the mq_map to get the vector_no via blk_mq_unique_tag()
and blk_mq_unique_tag_to_hwq() - which are setup during the blk_mq init.
For reserved cmds, or the ones before the blk_mq init, use the vector_no
0, which is the norm since don't yet have a proper mapping to the queues.

Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
---
 drivers/scsi/aacraid/aachba.c  |  6 ++++++
 drivers/scsi/aacraid/aacraid.h |  2 ++
 drivers/scsi/aacraid/commsup.c | 10 +++++++++-
 drivers/scsi/aacraid/linit.c   | 16 ++++++++++++++++
 drivers/scsi/aacraid/src.c     | 28 ++++++++++++++++++++++++++--
 5 files changed, 59 insertions(+), 3 deletions(-)

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
index ffef61c4aa01..5e12899823ac 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -223,8 +223,16 @@ int aac_fib_setup(struct aac_dev * dev)
 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 {
 	struct fib *fibptr;
+	u32 blk_tag;
+	int i;
+
+	if (aac_cpu_offline_feature == 1) {
+		blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+		i = blk_mq_unique_tag_to_tag(blk_tag);
+		fibptr = &dev->fibs[i];
+	} else
+		fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
 
-	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 68f4dbcfff49..56c5ce10555a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -504,6 +504,15 @@ static int aac_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
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
@@ -1488,6 +1497,7 @@ static const struct scsi_host_template aac_driver_template = {
 	.bios_param			= aac_biosparm,
 	.shost_groups			= aac_host_groups,
 	.slave_configure		= aac_slave_configure,
+	.map_queues			= aac_map_queues,
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_groups			= aac_dev_groups,
 	.eh_abort_handler		= aac_eh_abort,
@@ -1775,6 +1785,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_lun = AAC_MAX_LUN;
 
 	pci_set_drvdata(pdev, shost);
+	if (aac_cpu_offline_feature == 1) {
+		shost->nr_hw_queues = aac->max_msix;
+		shost->can_queue    = aac->vector_cap;
+		shost->host_tagset = 1;
+	}
 
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
@@ -1906,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	aac_cancel_rescan_worker(aac);
+	aac->use_map_queue = false;
 	scsi_remove_host(shost);
 
 	__aac_shutdown(aac);
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 28115ed637e8..befc32353b84 100644
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
+						vector_no = qmap->mq_map[raw_smp_processor_id()];
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

