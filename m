Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39E42FB083;
	Fri,  5 Sep 2025 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084412; cv=none; b=UxHYEb2VuRRAB+EuFIap8a/+r9N67SwjtZpDSy/0yzEGioBkMVSq+Lb7cyFgNaApl8gzSpOsiMxBPGSWjbdHd3quQNnJ74rW53Q7MG0N7aC8sxHTjfiZkUvPIIdizXnByLaQDZy6t0oBO+vqKiSaBCrjCs/ACsE9Fh29VG3v5yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084412; c=relaxed/simple;
	bh=m2sLzo3dPozCWRlzuWu6SHdCjeiSOL02cNWis7fahyY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A+1J2DRXZDSdfit4w/qVczw7ET20lKItaLBAOha7OtC0n62UXKCtgmciX4BQzlVdkLJRbLTODHbRGDBvsrEunu27cyszVSZWhy0K0Q5gJJaDjDe0Wim4uDqm6fnVWEhRZWXSfEbEOqd/2cgnHDucY0XLY8o/R9FTcB99XY6jwko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQx1PZGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQx1PZGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F66C4CEF7;
	Fri,  5 Sep 2025 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084412;
	bh=m2sLzo3dPozCWRlzuWu6SHdCjeiSOL02cNWis7fahyY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KQx1PZGCYQ9/0B6O9dw9g5wh/miikRGGkyHn6n61KaKp4xkszjxvdTALCgoMAG4tu
	 U/Up255OumaB2lKWSWsQD1h5Go+Ma6Ero9oUDur+e+jZtlPrQL0XxfuSdwFxui72/U
	 t6fA15MLNlHmVeVG6a0yIa65M9jZx6Y2zfuUjoQ3oXsNPqiHdeDfGgGDII9+mdvrOY
	 R1aX1uiCbBpcg4EqldMRiiyizj2Pz8fIaganJYQdhy5Q5FKca81DhTaDSdti2RCPWd
	 scrF9v+/2dEyVHc2/rfeyrP+cJTK3WuWMBGyfoHJ84kTfUUWB0ePhxRE9MyxVrk18E
	 v8XIgjz94Jy1g==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:53 +0200
Subject: [PATCH v8 07/12] scsi: Use block layer helpers to constrain queue
 affinity
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-7-885984c5daca@kernel.org>
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
In-Reply-To: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 GR-QLogic-Storage-Upstream@marvell.com, Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the SCSI drivers
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Only convert drivers which are already using the
pci_alloc_irq_vectors_affinity with the PCI_IRQ_AFFINITY flag set.
Because these drivers are enabled to let the IRQ core code to
set the affinity. Also don't update qla2xxx because the nvme-fabrics
code is not ready yet.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 6 +++++-
 drivers/scsi/mpt3sas/mpt3sas_base.c       | 5 ++++-
 drivers/scsi/pm8001/pm8001_init.c         | 1 +
 5 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2f3d61abab3a66bf0b40a27b9411dc2cab1c44fc..9f3194ac9c0fb53d619e3a108935ef109308d131 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2607,6 +2607,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	struct pci_dev *pdev = hisi_hba->pci_dev;
 	struct irq_affinity desc = {
 		.pre_vectors = BASE_VECTORS_V3_HW,
+		.mask = blk_mq_online_queue_affinity(),
 	};
 
 	min_msi = MIN_AFFINE_VECTORS_V3_HW;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 615e06fd4ee8e5d1c14ef912460962eacb450c04..c8df2dc47689a5dad02e1364de1d71e24f6159d0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5927,7 +5927,10 @@ static int
 __megasas_alloc_irq_vectors(struct megasas_instance *instance)
 {
 	int i, irq_flags;
-	struct irq_affinity desc = { .pre_vectors = instance->low_latency_index_start };
+	struct irq_affinity desc = {
+		.pre_vectors = instance->low_latency_index_start,
+		.mask = blk_mq_online_queue_affinity(),
+	};
 	struct irq_affinity *descp = &desc;
 
 	irq_flags = PCI_IRQ_MSIX;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0152d31d430abd17ab6b71f248435d9c7c417269..a8fbc84e0ab2ed7ca68a3b874ecfa78a8ebf0c47 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -825,7 +825,11 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 	int max_vectors, min_vec;
 	int retval;
 	int i;
-	struct irq_affinity desc = { .pre_vectors =  1, .post_vectors = 1 };
+	struct irq_affinity desc = {
+		.pre_vectors =  1,
+		.post_vectors = 1,
+		.mask = blk_mq_online_queue_affinity(),
+	};
 
 	if (mrioc->is_intr_info_set)
 		return 0;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index bd3efa5b46c780d43fae58c12f0bce5057dcda85..a55dd75221a6079a29f6ebee402b3654b94411c1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3364,7 +3364,10 @@ static int
 _base_alloc_irq_vectors(struct MPT3SAS_ADAPTER *ioc)
 {
 	int i, irq_flags = PCI_IRQ_MSIX;
-	struct irq_affinity desc = { .pre_vectors = ioc->high_iops_queues };
+	struct irq_affinity desc = {
+		.pre_vectors = ioc->high_iops_queues,
+		.mask = blk_mq_online_queue_affinity(),
+	};
 	struct irq_affinity *descp = &desc;
 	/*
 	 * Don't allocate msix vectors for poll_queues.
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 599410bcdfea59aba40e3dd6749434b7b5966d48..1d4807eeed75acdfe091a3c0560a926ebb59e1e8 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -977,6 +977,7 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 		 */
 		struct irq_affinity desc = {
 			.pre_vectors = 1,
+			.mask = blk_mq_online_queue_affinity(),
 		};
 		rc = pci_alloc_irq_vectors_affinity(
 				pm8001_ha->pdev, 2, PM8001_MAX_MSIX_VEC,

-- 
2.51.0

