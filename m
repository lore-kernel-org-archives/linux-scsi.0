Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D3B1FA17F;
	Tue, 17 Dec 2024 18:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734460199; cv=none; b=sybJarCoyG1ePc7I/DxDBkI+rqr7bzcOIaJEu7/0UhUmUYNrdUo2VCHdLk86xu5uwErxJc7YsXZWfHWY7shQxdVcwGY17gdOFC8TBzwNbUxo3axa5kaVknlGvOYQHWg6ifsw/DFxG4xcwts3SV4r/37grQvQxhviwp29TCNfCDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734460199; c=relaxed/simple;
	bh=Y+iIQqMxZ1GFfz3mNIIyf5XCB6LBEtLrtx8kjb0qqss=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bWMPQ/YVN5i3LVDVMKk4aNKEnEh3KoFW+EcdyhFyaCZyE5/EZy5/2vDI4Y7TFY3aXRbHkz9McMyCusQVsmo30M5O7rTGAbMfF63GHfRlX6TndWqGMizzurS+t6UiH1Y72Hf1pdY7XD2HpKhoIgt/rkewB5eCRnI0kIYx50TXwFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pSoZ6F8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pSoZ6F8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB92C4CED7;
	Tue, 17 Dec 2024 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734460198;
	bh=Y+iIQqMxZ1GFfz3mNIIyf5XCB6LBEtLrtx8kjb0qqss=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pSoZ6F8qGVrkkdoMmGLN16Vf7JLEg1ohgX1Hu2SO9f5u+qm027a+QG6gtvkmr/OyM
	 8ZUk9wQiXoWpbnQQG6pl/lcaHZsuSE8CxyolIk5t9I5B9H6ZrWWvEmQ2l/9oRMu8ds
	 pd+j1xdlIBS6ypdMAHRoToXbpCNGj3+re2SbWXE8tj7LOTLPmew5wcoAE2OMocemoR
	 85MYkR5/J7WUakbHF4Ar0RBvCwFhBbo2t1K8WJyi69lt1SPG6RpRnrAfAA98vMqPPY
	 c90MbVqX8HL51d5WQBch8oMDz7tW4Pdb+mzX+zWU8vKZTGqjguvOAIPN3QGwXjYWKx
	 D6AXmynGoKCWg==
From: Daniel Wagner <wagi@kernel.org>
Date: Tue, 17 Dec 2024 19:29:40 +0100
Subject: [PATCH v4 6/9] virtio: blk/scsi: use block layer helpers to
 calculate num of queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241217-isolcpus-io-queues-v4-6-5d355fbb1e14@kernel.org>
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
 drivers/block/virtio_blk.c                | 5 ++---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
 drivers/scsi/virtio_scsi.c                | 1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index ed514ff46dc82acd629ae594cb0fa097bd301a9b..0287ceaaf19972f3a18e81cd2e3252e4d539ba93 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -976,9 +976,8 @@ static int init_vq(struct virtio_blk *vblk)
 		return -EINVAL;
 	}
 
-	num_vqs = min_t(unsigned int,
-			min_not_zero(num_request_queues, nr_cpu_ids),
-			num_vqs);
+	num_vqs = blk_mq_num_possible_queues(
+			min_not_zero(num_request_queues, num_vqs));
 
 	num_poll_vqs = min_t(unsigned int, poll_queues, num_vqs - 1);
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 59d385e5a917979ae2f61f5db2c3355b9cab7e08..3ff0978b3acb5baf757fee25d9fccf4971976272 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6236,7 +6236,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		intr_coalescing = (scratch_pad_1 & MR_INTR_COALESCING_SUPPORT_OFFSET) ?
 								true : false;
 		if (intr_coalescing &&
-			(blk_mq_num_online_queues(0) >= MR_HIGH_IOPS_QUEUE_COUNT) &&
+			(blk_mq_num_online_queues(0) >=
+			 MR_HIGH_IOPS_QUEUE_COUNT) &&
 			(instance->msix_vectors == MEGASAS_MAX_MSIX_QUEUES))
 			instance->perf_mode = MR_BALANCED_PERF_MODE;
 		else
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 60be1a0c61836ba643adcf9ad8d5b68563a86cb1..46ca0b82f57ce2211c7e2817dd40ee34e65bcbf9 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -919,6 +919,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	/* We need to know how many queues before we allocate. */
 	num_queues = virtscsi_config_get(vdev, num_queues) ? : 1;
 	num_queues = min_t(unsigned int, nr_cpu_ids, num_queues);
+	num_queues = blk_mq_num_possible_queues(num_queues);
 
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 

-- 
2.47.1

