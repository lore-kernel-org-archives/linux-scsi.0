Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBB12E0413;
	Wed,  2 Jul 2025 16:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751474058; cv=none; b=ls8ExB2Si1Z89zUwTVUf4LxJuXv6h3iyrPwCxtRWEw2Ses9PWPfB/G3NiRWeEiCDGcVZ3Un0gnzrnTgp3xQt70KKdQljccOhOTOp76t3EjmgSdc+xGhJdfoZlmF2knPSk3N9uB5w1QmZax0T6+djT0VnHioYvFStw1oGXZVEkDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751474058; c=relaxed/simple;
	bh=keykx3vAmjJbk//U6jYPt/FwMnsvXcGfTDzqkjrAAS0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ACwMP30jvb1XfF0WBBipEGp3AVgarkTiK9iWiW627mUqclqjCJxsOExQLxMdECUDB0oUDCuIFIUhiFe5Bp8ir46SpPRWmLc7KRnG/+QuxXPSeCQFnSEVtEoZbjaBLsXNMjX+vHP4inVUrTux9kVle03980fQ6DqSmOKSR6Z268Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpL8/TWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpL8/TWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ABCC4CEEF;
	Wed,  2 Jul 2025 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751474058;
	bh=keykx3vAmjJbk//U6jYPt/FwMnsvXcGfTDzqkjrAAS0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kpL8/TWqVAvG+YaSf0RYT4vdNTMunclsM+/ZK40KSdFtb0UaohF6bDZwUN8eJz36q
	 mPyK5jLF8R/TcBI7ofEDoF+mKR1Gu9fZghY1VDfc4EJ0rBtH5AB3InEU87TvMErTpD
	 SsIgo3w1ze9Y3Xpi9KR80R3KFVe1L/vkiWH20BSP1ndpzsVShxPuzpfswrtKKktAXx
	 8CwLoUSzyuXOhsi3pqS4DPS40L4PvTgAaTL+EA/kwZTuXvPu7NIs6ZaBfx4Le0LRFM
	 Hoct70WBmmi4iguDj8N8v8aEwX1/kDIT3fDix5TJf3FKh34hF8TmIN+rjsSnUPiNwJ
	 p4I2JO5EJREJQ==
From: Daniel Wagner <wagi@kernel.org>
Date: Wed, 02 Jul 2025 18:33:55 +0200
Subject: [PATCH v7 05/10] scsi: Use block layer helpers to constrain queue
 affinity
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250702-isolcpus-io-queues-v7-5-557aa7eacce4@kernel.org>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
In-Reply-To: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
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
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, storagedev@microchip.com, 
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the SCSI drivers
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/scsi/fnic/fnic_isr.c              | 7 +++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 6 +++++-
 drivers/scsi/mpt3sas/mpt3sas_base.c       | 5 ++++-
 drivers/scsi/pm8001/pm8001_init.c         | 1 +
 drivers/scsi/qla2xxx/qla_isr.c            | 1 +
 drivers/scsi/smartpqi/smartpqi_init.c     | 7 +++++--
 8 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 7ed50b11afa6a992c9a69dc746d271376ea8fe08..c6d8582c767edd8121a07966ed527260a28e5cb5 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -245,6 +245,9 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 	unsigned int m = ARRAY_SIZE(fnic->wq);
 	unsigned int o = ARRAY_SIZE(fnic->hw_copy_wq);
 	unsigned int min_irqs = n + m + 1 + 1; /*rq, raw wq, wq, err*/
+	struct irq_affinity desc = {
+		.mask = blk_mq_online_queue_affinity(),
+	};
 
 	/*
 	 * We need n RQs, m WQs, o Copy WQs, n+m+o CQs, and n+m+o+1 INTRs
@@ -263,8 +266,8 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 		int vec_count = 0;
 		int vecs = fnic->rq_count + fnic->raw_wq_count + fnic->wq_copy_count + 1;
 
-		vec_count = pci_alloc_irq_vectors(fnic->pdev, min_irqs, vecs,
-					PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+		vec_count = pci_alloc_irq_vectors_affinity(fnic->pdev, min_irqs, vecs,
+					PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc);
 		FNIC_ISR_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					"allocated %d MSI-X vectors\n",
 					vec_count);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index bc5d5356dd00710277e4b8877798f64c9674d5de..2906dd9a6c895827e07b1ba0540f0f27ac704f47 100644
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
index 1d7901a8f0e40658b78415704e8c81e28ef6d3df..c790d50cda36dc2c33571e29fdd7f661b85a48b1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -820,7 +820,11 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
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
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c4c6b5c6658c0734f7ff68bcc31b33dde87296dd..7c5adadfd731f0e395ea0050f105196ab9a503e9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4522,6 +4522,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	int min_vecs = QLA_BASE_VECTORS;
 	struct irq_affinity desc = {
 		.pre_vectors = QLA_BASE_VECTORS,
+		.mask = blk_mq_online_queue_affinity(),
 	};
 
 	if (QLA_TGT_MODE_ENABLED() && (ql2xenablemsix != 0) &&
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 125944941601e683e9aa9d4fc6a346230bef904b..24338919120e341a54d610b6fedc29a9cc29055b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4109,13 +4109,16 @@ static int pqi_enable_msix_interrupts(struct pqi_ctrl_info *ctrl_info)
 {
 	int num_vectors_enabled;
 	unsigned int flags = PCI_IRQ_MSIX;
+	struct irq_affinity desc = {
+		.mask = blk_mq_online_queue_affinity(),
+	};
 
 	if (!pqi_disable_managed_interrupts)
 		flags |= PCI_IRQ_AFFINITY;
 
-	num_vectors_enabled = pci_alloc_irq_vectors(ctrl_info->pci_dev,
+	num_vectors_enabled = pci_alloc_irq_vectors_affinity(ctrl_info->pci_dev,
 			PQI_MIN_MSIX_VECTORS, ctrl_info->num_queue_groups,
-			flags);
+			flags, &desc);
 	if (num_vectors_enabled < 0) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"MSI-X init failed with error %d\n",

-- 
2.50.0

