Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EC92D5929
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 10:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250673; cv=none; b=AifB5XdFZdgLu/3rF/ctopu1U5ckjOecV1W1XOnz5OFgNNVRjiQp9IFkZjujdIjmGTYyS5NdB/W5h5Fk03Gqu0zncQaqwcthwiWo/cei3kvwMVERvsZAVw7/Km+U6lCOrf+hq6EeBI62MBIjtSsjYpbEGA/GQTI8BYG1/xN0AdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250673; c=relaxed/simple;
	bh=/iNo/t+cOBVq+bDynOPjrue+B9uGSz46ttUx5aN7pEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwKejWjVvnICDhDrt4D95uToWdC4wTK4rrQ74CqC/RdmHw6goEoDDtsJiOLtZ2ZOD9jf3/o5PRETLqV/FApKSSZZr2DviUMgALZmT8L119DT1xDVw5urGDCxkAVhtiC1eQdr14VeNpf6moxHWZyJuXeblvmLN6WTGScFoz4TbZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=siNuwLdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="siNuwLdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EACFC16AAE;
	Tue,  4 Nov 2025 10:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762250673;
	bh=/iNo/t+cOBVq+bDynOPjrue+B9uGSz46ttUx5aN7pEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siNuwLdP4VtnYlNJSmcLOZCPIo+sViHYdIkpfOjbls55pupxx/q6zq3En4dyIgS8L
	 tTf/XE8M+gTc6MxrcVCu3VvH+6piWL/K1ISXa/CeQsKPc9YWxq/TJKudt5R9/1B2qZ
	 8IJNDfPWC48ZMGAQdFStS0ZWfciEKHbnXdf7DNUob533mxmFH0xgHAg8mU10luy9Xo
	 ip1k1f9kB7/K0iKKjZ0Z/IdL3Bht3T8for4WDqOC4Vag4xgUn8cLTVTbi1N4Mg6IK1
	 vnKo4+kafzb+8vvfjzBGYLcYo1iW/ndrhzDoHxc5J6H8sZDtQEohJXE+hr/9WU8Vfq
	 gbSJl5rRHRAzw==
From: Hannes Reinecke <hare@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 1/4] fnic: use resulting interrupt mode during configuration
Date: Tue,  4 Nov 2025 11:04:21 +0100
Message-ID: <20251104100424.8215-2-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251104100424.8215-1-hare@kernel.org>
References: <20251104100424.8215-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The configured interrupt mode might be different than the resulting
interrupts mode after all configuration limitations have been applied.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 4cc4077ea53c..7075a23d9229 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -678,7 +678,7 @@ void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 {
 	struct fnic *fnic = *((struct fnic **) shost_priv(host));
 	struct pci_dev *l_pdev = fnic->pdev;
-	int intr_mode = fnic->config.intr_mode;
+	int intr_mode = vnic_dev_get_intr_mode(fnic->vdev);
 	struct blk_mq_queue_map *qmap = &host->tag_set.map[HCTX_TYPE_DEFAULT];
 
 	if (intr_mode == VNIC_DEV_INTR_MODE_MSI || intr_mode == VNIC_DEV_INTR_MODE_INTX) {
-- 
2.43.0

