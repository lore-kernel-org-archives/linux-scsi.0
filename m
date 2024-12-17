Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966F11FA141;
	Tue, 17 Dec 2024 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734460196; cv=none; b=XRwkmj79k+0gNZAwo3WbvwxNyHrkHOrzb68li39+VsGCbgVxPl8q7Ywz7lRl17AaIPzBi90AX139xrPmtOVHGKREQDqTWW+Xm+N5Dlo+3zEwsm7U3jwVX3vMjDR70/qsM29qmHrSwtsy64HCsVadZya195CrA+JCjZSHGmKc5+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734460196; c=relaxed/simple;
	bh=0ycW44IR1uqmQrDJLN8IiSf67ET1Zi70MGLU1ocQlSU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cZweStJ61vIaY6ql2aaePFyp9CzuyFAZKd5VopFGzFDRP+l+ClT75/jpNW5yJ2hiz0Dx31+E/NEazP2EPT7Y64KZPOvpkQqn/jpmW3tmsn7uEloLPDY5ej621F4KvLua6CVHbuPdkSZBahY86FjrNDD2aBr3wS+fMMmxclY0ReE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6LqJjc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6LqJjc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED67FC4CEDD;
	Tue, 17 Dec 2024 18:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734460196;
	bh=0ycW44IR1uqmQrDJLN8IiSf67ET1Zi70MGLU1ocQlSU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f6LqJjc+pL+hWAmpAZ1nqP1TaaZNM+c6KdbH0B6nrd0IxTtwOELC/n/9Xxy4XYQez
	 7WfXF1wmrvAMZV39XLXohDdZJtoB0H3nBi8tzM6KNu/gsLKCIMYwI/KXFNtOeaq/XV
	 SECpmC0ZwS0WwblJ2NNKwrRjvmKYncDgdmYAUjmLW66JibnGEXjMC+wCzXaycd5P20
	 zfSaPkO6v0G3pYVHt0z92kJo5upot7QrFFcEDQh24KvefXx1S5J4IqatYIEo/AgLEQ
	 RJg4CNTu6VwUvYv/5al5nNOhMcBmuHF1Q+VnQajvLdsJUcrvgq14K3LqA+LR2Y7MGV
	 dkBUQ/S3uBwng==
From: Daniel Wagner <wagi@kernel.org>
Date: Tue, 17 Dec 2024 19:29:39 +0100
Subject: [PATCH v4 5/9] scsi: use block layer helpers to calculate num of
 queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241217-isolcpus-io-queues-v4-5-5d355fbb1e14@kernel.org>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
In-Reply-To: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Don Brace <don.brace@microchip.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Thomas Gleixner <tglx@linutronix.de>
Cc: Costa Shulyupin <costa.shul@redhat.com>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

Multiqueue devices should only allocate queues for the housekeeping CPUs
when isolcpus=managed_irq is set. This avoids that the isolated CPUs get
disturbed with OS workload.

Use helpers which calculates the correct number of queues which should
be used when isolcpus is used.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 15 +++++++++------
 drivers/scsi/qla2xxx/qla_isr.c            | 10 +++++-----
 drivers/scsi/smartpqi/smartpqi_init.c     |  5 ++---
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 49abd7dd75a7b7c1ddcfac41acecbbcf7de8f5a4..59d385e5a917979ae2f61f5db2c3355b9cab7e08 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5962,7 +5962,8 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
 		else
 			instance->iopoll_q_count = 0;
 
-		num_msix_req = num_online_cpus() + instance->low_latency_index_start;
+		num_msix_req = blk_mq_num_online_queues(0) +
+			instance->low_latency_index_start;
 		instance->msix_vectors = min(num_msix_req,
 				instance->msix_vectors);
 
@@ -5978,7 +5979,8 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
 		/* Disable Balanced IOPS mode and try realloc vectors */
 		instance->perf_mode = MR_LATENCY_PERF_MODE;
 		instance->low_latency_index_start = 1;
-		num_msix_req = num_online_cpus() + instance->low_latency_index_start;
+		num_msix_req = blk_mq_num_online_queues(0) +
+			instance->low_latency_index_start;
 
 		instance->msix_vectors = min(num_msix_req,
 				instance->msix_vectors);
@@ -6234,7 +6236,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		intr_coalescing = (scratch_pad_1 & MR_INTR_COALESCING_SUPPORT_OFFSET) ?
 								true : false;
 		if (intr_coalescing &&
-			(num_online_cpus() >= MR_HIGH_IOPS_QUEUE_COUNT) &&
+			(blk_mq_num_online_queues(0) >= MR_HIGH_IOPS_QUEUE_COUNT) &&
 			(instance->msix_vectors == MEGASAS_MAX_MSIX_QUEUES))
 			instance->perf_mode = MR_BALANCED_PERF_MODE;
 		else
@@ -6278,7 +6280,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		else
 			instance->low_latency_index_start = 1;
 
-		num_msix_req = num_online_cpus() + instance->low_latency_index_start;
+		num_msix_req = blk_mq_num_online_queues(0) +
+			instance->low_latency_index_start;
 
 		instance->msix_vectors = min(num_msix_req,
 				instance->msix_vectors);
@@ -6310,8 +6313,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	megasas_setup_reply_map(instance);
 
 	dev_info(&instance->pdev->dev,
-		"current msix/online cpus\t: (%d/%d)\n",
-		instance->msix_vectors, (unsigned int)num_online_cpus());
+		"current msix/max num queues\t: (%d/%u)\n",
+		instance->msix_vectors, blk_mq_num_online_queues(0));
 	dev_info(&instance->pdev->dev,
 		"RDPQ mode\t: (%s)\n", instance->is_rdpq ? "enabled" : "disabled");
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fe98c76e9be32ff03a1960f366f0d700d1168383..c4c6b5c6658c0734f7ff68bcc31b33dde87296dd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4533,13 +4533,13 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	if (USER_CTRL_IRQ(ha) || !ha->mqiobase) {
 		/* user wants to control IRQ setting for target mode */
 		ret = pci_alloc_irq_vectors(ha->pdev, min_vecs,
-		    min((u16)ha->msix_count, (u16)(num_online_cpus() + min_vecs)),
-		    PCI_IRQ_MSIX);
+			blk_mq_num_online_queues(ha->msix_count) + min_vecs,
+			PCI_IRQ_MSIX);
 	} else
 		ret = pci_alloc_irq_vectors_affinity(ha->pdev, min_vecs,
-		    min((u16)ha->msix_count, (u16)(num_online_cpus() + min_vecs)),
-		    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
-		    &desc);
+			blk_mq_num_online_queues(ha->msix_count) + min_vecs,
+			PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
+			&desc);
 
 	if (ret < 0) {
 		ql_log(ql_log_fatal, vha, 0x00c7,
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 04fb24d77e9b5c0137f26bc41f17191cc4c49728..7636c8d1c9f14a0d887c1d517c3664f0d0df7e6e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5278,15 +5278,14 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 	if (reset_devices) {
 		num_queue_groups = 1;
 	} else {
-		int num_cpus;
 		int max_queue_groups;
 
 		max_queue_groups = min(ctrl_info->max_inbound_queues / 2,
 			ctrl_info->max_outbound_queues - 1);
 		max_queue_groups = min(max_queue_groups, PQI_MAX_QUEUE_GROUPS);
 
-		num_cpus = num_online_cpus();
-		num_queue_groups = min(num_cpus, ctrl_info->max_msix_vectors);
+		num_queue_groups =
+			blk_mq_num_online_queues(ctrl_info->max_msix_vectors);
 		num_queue_groups = min(num_queue_groups, max_queue_groups);
 	}
 

-- 
2.47.1

