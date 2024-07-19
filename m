Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9EB4D8A7
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jul 2024 07:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721374756; cv=none; b=EScp2QVM+i74tSTlhWwfUryFa9a8In17c7TAqe2lV7pfQ1iE1ue5PiW0wHJw2KB7D3zzoYTwYnC+sjFsmzT2u6BJgu4ttuJJoPYaOfL5wk3ynqtmFIZzpVsUdSlkljlEJBqdNwftCaYX9/IZUS6qf4CbgX2VZ6M5PX4c0Dlt7Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721374756; c=relaxed/simple;
	bh=WHhKfyC9miUT0pQix7K4cvCqHqfLQgZZnNq/08fxrl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdVb1t9cP7tNA6LAu3Qatpmg121j+mdgv0DoMNtfuzw8paUBUiNnZjBljL3aL5X01WuoR3gKYTxTf3XOYZcJ/x2Uux36+1uJldIKfWN/V+v10ukNt0vbUEJ0Q1nTwVo5ObfQUhTZYDiBlkk0wlFxyTYV3ko1yq2MYdLTj+8Bp38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p163UGer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p163UGer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A17FC32782;
	Fri, 19 Jul 2024 07:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721374756;
	bh=WHhKfyC9miUT0pQix7K4cvCqHqfLQgZZnNq/08fxrl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p163UGer6OFizhx2FPz3PlKWbcgK0SUchp9tCXsDIqG25XpYis8UUqtYg97xhRGe5
	 Y1HSjGM7dFTuLTX91YbrYNPA9hiIw+sak5lmEYzonlbBE/wsK8wlBqTlOk8tvm+qMg
	 46eH3N7hlCw8GO9X0Fv7WKuRQptTW5R2pvXUiYWiOV+bR9nqSzwkYb3IZolnD+a0bt
	 YSYeLxWn0ERlOPAXUgjfPQdeaIJ7flwsNNdzXOcW3hg+VMeTsxaZgwMm7fTR3ASLDK
	 JxG3a42COfkO9NxqeWIqr8t2e9iFT4KDmLZvhURfIgOZc6GXLOUGEiSssHbB3kqdUb
	 F4pNDTEPV7HQA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 1/2] scsi: mpi3mr: Avoid IOMMU page faults on report zones
Date: Fri, 19 Jul 2024 16:39:11 +0900
Message-ID: <20240719073913.179559-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240719073913.179559-1-dlemoal@kernel.org>
References: <20240719073913.179559-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some firmware versions of the 9600 series SAS HBA byte-swap the report
zone command reply buffer from ATA-ZAC devices by directly accessing
the buffer in the host memory. This does not respect the default
command DMA direction and causes IOMMU page faults on architectures
with an IOMMU enforcing write-only mappings for DMA_FROM_DEVICE DMA
direction (e.g. AMD hosts), leading to the device capacity to be
dropped to 0:

scsi 18:0:58:0: Direct-Access-ZBC ATA      WDC  WSH722626AL W930 PQ: 0 ANSI: 7
scsi 18:0:58:0: Power-on or device reset occurred
sd 18:0:58:0: Attached scsi generic sg9 type 20
sd 18:0:58:0: [sdj] Host-managed zoned block device
mpi3mr 0000:c1:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0001 address=0xfec0c400 flags=0x0050]
mpi3mr 0000:c1:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0001 address=0xfec0c500 flags=0x0050]
sd 18:0:58:0: [sdj] REPORT ZONES start lba 0 failed
sd 18:0:58:0: [sdj] REPORT ZONES: Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 18:0:58:0: [sdj] 0 4096-byte logical blocks: (0 B/0 B)
sd 18:0:58:0: [sdj] Write Protect is off
sd 18:0:58:0: [sdj] Mode Sense: 6b 00 10 08
sd 18:0:58:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 18:0:58:0: [sdj] Attached SCSI disk

Avoid this issue by always mapping the buffer of report zones commands
using DMA_BIDIRECTIONAL, that is, using a read-write IOMMU mapping.

Suggested-by: Christoph Hellwig <hch@lst.de>
Fixes: 023ab2a9b4ed ("scsi: mpi3mr: Add support for queue command processing")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index bce639a6cca1..3a2ec4b87440 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3453,6 +3453,17 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 		    scmd->sc_data_direction);
 		priv->meta_sg_valid = 1; /* To unmap meta sg DMA */
 	} else {
+		/*
+		 * Some firmware versions byte-swap the report zone command
+		 * reply from ATA-ZAC devices by directly accessing in the host
+		 * buffer. This does not respect the default command DMA
+		 * direction and causes IOMMU page faults on some architectures
+		 * with an IOMMU enforcing write mappings (e.g. AMD hosts).
+		 * Avoid such issue by making the report zones buffer mapping
+		 * bi-directional.
+		 */
+		if (scmd->cmnd[0] == ZBC_IN && scmd->cmnd[1] == ZI_REPORT_ZONES)
+			scmd->sc_data_direction = DMA_BIDIRECTIONAL;
 		sg_scmd = scsi_sglist(scmd);
 		sges_left = scsi_dma_map(scmd);
 	}
-- 
2.45.2

