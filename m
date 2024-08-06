Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8C51C3F02;
	Tue,  6 Aug 2024 12:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946044; cv=none; b=dGQ5me7bXwSU7rPGfB/mdu1TD5MEv+OAm9tMJ4iKIFYg8gZUY96gBu1fOz5uGNh/zj0x/lize1xW6+zkXw5ZxJEqmF/ImgrBG3coLdXd3Eu8naeERke9yiNq2cjJEdv/L+5GBF2Y2rC+v/GCZvdfhTKBVezhSbiZaOh1vJge188=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946044; c=relaxed/simple;
	bh=Sb6bzMXTN9gzSmH8l5ggSklEi2h8qinH0nrwbECkGVE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=f5E6tATf60pRbkkAc4qDbApQSQwZD1G/sFbwQi4mfHPbq9O5gKBX1G5a1jU8++iX6PFk2yhBpcsvMv6AlouFEPCi7znsEaZ5gXoCOkKtIXRbp1gS7JX8S31BqnRVkqMnfwAiFBMiLDAvH+K/3za3H974UFokoqT5sUIdzfI7wi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=V8+61d1k; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="V8+61d1k"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B2C88DACD6;
	Tue,  6 Aug 2024 14:07:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946040; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ws2j8Pwzi0HlI6vG7QCORuVLqH5G6khwoSILRnp90GQ=;
	b=V8+61d1k+ejXI4NezfFniN4E1SPWkLSRVxSTw5SK8nTBFn8M8hHE+y9X21LOv1Jz7oahbR
	nO29yduMOHd9bBqGqZQlotgF61drlCMJDRrC6YJWK+npVlX2/2vuEG0lezUtMtoQaOZo1Y
	+HZgVQJAXSMM6bxbWQ7spWaVo5NLLOJAiW/5ixPQqPyX6wLeQRrKZfG78C1AhHsmZsmV+F
	dNZBuOJjEKfr6+PminGWTjT1NvwgsFl80RIFtFmJaDohGiaav8oLvzgX+qDneNvqIeo/xO
	hKcqPIkMQZcbAmmjynx7mc7mgsxs143R6RQkMQTxawvFBXesUBQmLgs44edVsw==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:36 +0200
Subject: [PATCH v3 04/15] scsi: replace blk_mq_pci_map_queues with
 blk_mq_dev_map_queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-4-da0eecfeaf8b@suse.de>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
In-Reply-To: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Sagi Grimberg <sagi@grimberg.me>, Thomas Gleixner <tglx@linutronix.de>, 
 Christoph Hellwig <hch@lst.de>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 John Garry <john.g.garry@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Jonathan Corbet <corbet@lwn.net>
Cc: Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
 virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com, 
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, 
 storagedev@microchip.com, linux-doc@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.0
X-Last-TLS-Session-Version: TLSv1.3

Replace all users of blk_mq_pci_map_queues with the more generic
blk_mq_dev_map_queues. This in preparation to retire
blk_mq_pci_map_queues.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/fnic/fnic_main.c             |  3 ++-
 drivers/scsi/hisi_sas/hisi_sas.h          |  1 -
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    | 20 ++++++++++----------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  5 +++--
 drivers/scsi/megaraid/megaraid_sas_base.c |  3 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  3 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  3 ++-
 drivers/scsi/pm8001/pm8001_init.c         |  3 ++-
 drivers/scsi/qla2xxx/qla_nvme.c           |  3 ++-
 drivers/scsi/qla2xxx/qla_os.c             |  3 ++-
 drivers/scsi/smartpqi/smartpqi_init.c     |  7 ++++---
 11 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 29eead383eb9..dee7f241c38a 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -601,7 +601,8 @@ void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 		return;
 	}
 
-	blk_mq_pci_map_queues(qmap, l_pdev, FNIC_PCI_OFFSET);
+	blk_mq_dev_map_queues(qmap, l_pdev, FNIC_PCI_OFFSET,
+			      blk_mq_pci_get_queue_affinity);
 }
 
 static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index d223f482488f..010479a354ee 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -9,7 +9,6 @@
 
 #include <linux/acpi.h>
 #include <linux/blk-mq.h>
-#include <linux/blk-mq-pci.h>
 #include <linux/clk.h>
 #include <linux/debugfs.h>
 #include <linux/dmapool.h>
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 342d75f12051..91daf57f328c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3549,21 +3549,21 @@ static const struct attribute_group *sdev_groups_v2_hw[] = {
 	NULL
 };
 
+static const struct cpumask *hisi_hba_get_queue_affinity(void *dev_data,
+							 int offset, int idx)
+{
+	struct hisi_hba *hba = dev_data;
+
+	return irq_get_affinity_mask(hba->irq_map[offset + idx]);
+}
+
 static void map_queues_v2_hw(struct Scsi_Host *shost)
 {
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
-	const struct cpumask *mask;
-	unsigned int queue, cpu;
 
-	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = irq_get_affinity_mask(hisi_hba->irq_map[96 + queue]);
-		if (!mask)
-			continue;
-
-		for_each_cpu(cpu, mask)
-			qmap->mq_map[cpu] = qmap->queue_offset + queue;
-	}
+	return blk_mq_dev_map_queues(qmap, hisi_hba, 96,
+				     hisi_hba_get_queue_affinity);
 }
 
 static const struct scsi_host_template sht_v2_hw = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index feda9b54b443..0b3c7b49813a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3322,8 +3322,9 @@ static void hisi_sas_map_queues(struct Scsi_Host *shost)
 		if (i == HCTX_TYPE_POLL)
 			blk_mq_map_queues(qmap);
 		else
-			blk_mq_pci_map_queues(qmap, hisi_hba->pci_dev,
-					      BASE_VECTORS_V3_HW);
+			blk_mq_dev_map_queues(qmap, hisi_hba->pci_dev,
+					      BASE_VECTORS_V3_HW,
+					      blk_mq_pci_get_queue_affinity);
 		qoff += qmap->nr_queues;
 	}
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6c79c350a4d5..d026b7513c8d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3193,7 +3193,8 @@ static void megasas_map_queues(struct Scsi_Host *shost)
 	map = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 	map->nr_queues = instance->msix_vectors - offset;
 	map->queue_offset = 0;
-	blk_mq_pci_map_queues(map, instance->pdev, offset);
+	blk_mq_dev_map_queues(map, instance->pdev, offset,
+			      blk_mq_pci_get_queue_affinity);
 	qoff += map->nr_queues;
 	offset += map->nr_queues;
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 69b14918de59..3256a71390a4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4031,7 +4031,8 @@ static void mpi3mr_map_queues(struct Scsi_Host *shost)
 		 */
 		map->queue_offset = qoff;
 		if (i != HCTX_TYPE_POLL)
-			blk_mq_pci_map_queues(map, mrioc->pdev, offset);
+			blk_mq_dev_map_queues(map, mrioc->pdev, offset,
+					      blk_mq_pci_get_queue_affinity);
 		else
 			blk_mq_map_queues(map);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 97c2472cd434..8f7667d8bfdc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11890,7 +11890,8 @@ static void scsih_map_queues(struct Scsi_Host *shost)
 		 */
 		map->queue_offset = qoff;
 		if (i != HCTX_TYPE_POLL)
-			blk_mq_pci_map_queues(map, ioc->pdev, offset);
+			blk_mq_dev_map_queues(map, ioc->pdev, offset,
+					      blk_mq_pci_get_queue_affinity);
 		else
 			blk_mq_map_queues(map);
 
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 33e1eba62ca1..b70d17905d02 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -101,7 +101,8 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
 	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 
 	if (pm8001_ha->number_of_intr > 1) {
-		blk_mq_pci_map_queues(qmap, pm8001_ha->pdev, 1);
+		blk_mq_dev_map_queues(qmap, pm8001_ha->pdev, 1,
+				      blk_mq_pci_get_queue_affinity);
 		return;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 8f4cc136a9c9..30c4581e782b 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -841,7 +841,8 @@ static void qla_nvme_map_queues(struct nvme_fc_local_port *lport,
 {
 	struct scsi_qla_host *vha = lport->private;
 
-	blk_mq_pci_map_queues(map, vha->hw->pdev, vha->irq_offset);
+	blk_mq_dev_map_queues(map, vha->hw->pdev, vha->irq_offset,
+			      blk_mq_pci_get_queue_affinity);
 }
 
 static void qla_nvme_localport_delete(struct nvme_fc_local_port *lport)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bc3b2aea3f8b..5a6ceeb3ad2a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8068,7 +8068,8 @@ static void qla2xxx_map_queues(struct Scsi_Host *shost)
 	if (USER_CTRL_IRQ(vha->hw) || !vha->hw->mqiobase)
 		blk_mq_map_queues(qmap);
 	else
-		blk_mq_pci_map_queues(qmap, vha->hw->pdev, vha->irq_offset);
+		blk_mq_dev_map_queues(qmap, vha->hw->pdev, vha->irq_offset,
+				      blk_mq_pci_get_queue_affinity);
 }
 
 struct scsi_host_template qla2xxx_driver_template = {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 24c7cb285dca..1fb13d4e0448 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6533,10 +6533,11 @@ static void pqi_map_queues(struct Scsi_Host *shost)
 	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
 
 	if (!ctrl_info->disable_managed_interrupts)
-		return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
-			      ctrl_info->pci_dev, 0);
+		blk_mq_dev_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+				      ctrl_info->pci_dev, 0,
+				      blk_mq_pci_get_queue_affinity);
 	else
-		return blk_mq_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT]);
+		blk_mq_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT]);
 }
 
 static inline bool pqi_is_tape_changer_device(struct pqi_scsi_dev *device)

-- 
2.46.0

