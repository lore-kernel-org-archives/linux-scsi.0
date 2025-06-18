Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7694F1E5B60
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 05:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750225973; cv=none; b=ZDEqQJTrGlH/84H3CjNbCfZH3rPjIGCgtpDz8ofJulj8XBU6PbtDaHCSScjaNtyqb06NAPH3MPY+vQaJmIndJKCz+2/54mTqUz+eOKMn2GsNmIlciXcf3HP1Pcn5OhDlJuhITucDAOVfnr+Fx26mfU4JPmXn4LJebIrXFm1rb3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750225973; c=relaxed/simple;
	bh=QOIvvRiA0nP7HMPB64VvxuEyZPNmkyiNHJjMlhTCOGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=kYJtkbAsDABXqAIRyLaO7nkXGVhXsEPEgaEdpMZYd3THsosJDSPSYRZql3Bgw4mFNfs2rsXcj9E4YDimLXG4twUJ0IT6sgZqBVdf2dNIIDckZ2rWMU7eYS1iZH8U/8+g96MRidigov3aWq3TpyGVwXTQCxQ2iVehnflaChyR0dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZaqFDF8k; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZaqFDF8k"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250618055248epoutp04300a58e720f648621108f3715283a3e5~KDT7bZxyi3161031610epoutp04m
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 05:52:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250618055248epoutp04300a58e720f648621108f3715283a3e5~KDT7bZxyi3161031610epoutp04m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750225968;
	bh=AphzsfxjNeKVKXBI0eht8VGHFki7UqreyMpiNst00kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaqFDF8k4BA63Dg0MkmxtBvBwYqll1+Prexk8q6/EqErzcNWRyBn2oZEEqYr6bWwr
	 QeSGgvjmIsVJlPSs1nL9Ap0q/b+6WatUs0oj8S4qrVdoFtunXMj3lHovteTugL1U55
	 LZulMs6NWnvhMUf+dc7eNpjGG8Szmp5GKZleq9ZY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250618055248epcas5p12a63e6201e1e953d7f1f4946513407b5~KDT6xSGRA1875218752epcas5p1Z;
	Wed, 18 Jun 2025 05:52:48 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.177]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bMXvf21VJz6B9mS; Wed, 18 Jun
	2025 05:52:46 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250618055215epcas5p3232e90ae38bbd6667aacc6d32abb4189~KDTciXbNO2388423884epcas5p3k;
	Wed, 18 Jun 2025 05:52:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250618055213epsmtip2aea9608f13518dc675ff961d58899d03~KDTaWbUnp3085030850epsmtip2N;
	Wed, 18 Jun 2025 05:52:13 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: vincent.fu@samsung.com, jack@suse.cz, anuj1072538@gmail.com,
	axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org,
	hch@infradead.org, martin.petersen@oracle.com, ebiggers@kernel.org,
	adilger@dilger.ca
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH for-next v4 2/4] block: introduce pi_tuple_size field in
 blk_integrity
Date: Wed, 18 Jun 2025 11:21:51 +0530
Message-Id: <20250618055153.48823-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250618055153.48823-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250618055215epcas5p3232e90ae38bbd6667aacc6d32abb4189
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250618055215epcas5p3232e90ae38bbd6667aacc6d32abb4189
References: <20250618055153.48823-1-anuj20.g@samsung.com>
	<CGME20250618055215epcas5p3232e90ae38bbd6667aacc6d32abb4189@epcas5p3.samsung.com>

Introduce a new pi_tuple_size field in struct blk_integrity to
explicitly represent the size (in bytes) of the protection information
(PI) tuple. This is a prep patch.
Add validation in blk_validate_integrity_limits() to ensure that
pi size matches the expected size for known checksum types and never
exceeds the pi_tuple_size.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c     | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/core.c |  2 ++
 drivers/scsi/sd_dif.c    |  1 +
 include/linux/blkdev.h   |  1 +
 4 files changed, 42 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 787500ff00c3..32f3cdc9835a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -14,6 +14,8 @@
 #include <linux/jiffies.h>
 #include <linux/gfp.h>
 #include <linux/dma-mapping.h>
+#include <linux/t10-pi.h>
+#include <linux/crc64.h>
 
 #include "blk.h"
 #include "blk-rq-qos.h"
@@ -135,6 +137,42 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 		return -EINVAL;
 	}
 
+	if (bi->pi_tuple_size > bi->metadata_size) {
+		pr_warn("pi_tuple_size (%u) exceeds metadata_size (%u)\n",
+			 bi->pi_tuple_size,
+			 bi->metadata_size);
+		return -EINVAL;
+	}
+
+	switch (bi->csum_type) {
+	case BLK_INTEGRITY_CSUM_NONE:
+		if (bi->pi_tuple_size) {
+			pr_warn("pi_tuple_size must be 0 when checksum type \
+				 is none\n");
+			return -EINVAL;
+		}
+		break;
+	case BLK_INTEGRITY_CSUM_CRC:
+	case BLK_INTEGRITY_CSUM_IP:
+		if (bi->pi_tuple_size != sizeof(struct t10_pi_tuple)) {
+			pr_warn("pi_tuple_size mismatch for T10 PI: expected \
+				 %zu, got %u\n",
+				 sizeof(struct t10_pi_tuple),
+				 bi->pi_tuple_size);
+			return -EINVAL;
+		}
+		break;
+	case BLK_INTEGRITY_CSUM_CRC64:
+		if (bi->pi_tuple_size != sizeof(struct crc64_pi_tuple)) {
+			pr_warn("pi_tuple_size mismatch for CRC64 PI: \
+				 expected %zu, got %u\n",
+				 sizeof(struct crc64_pi_tuple),
+				 bi->pi_tuple_size);
+			return -EINVAL;
+		}
+		break;
+	}
+
 	if (!bi->interval_exp)
 		bi->interval_exp = ilog2(lim->logical_block_size);
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b027dda38e69..fe72accab516 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1867,6 +1867,8 @@ static bool nvme_init_integrity(struct nvme_ns_head *head,
 	}
 
 	bi->metadata_size = head->ms;
+	if (bi->csum_type)
+		bi->pi_tuple_size = head->pi_size;
 	bi->pi_offset = info->pi_offset;
 	return true;
 }
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 18bfca1f1c78..ff4217fef93b 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -53,6 +53,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp, struct queue_limits *lim)
 		bi->flags |= BLK_INTEGRITY_REF_TAG;
 
 	bi->metadata_size = sizeof(struct t10_pi_tuple);
+	bi->pi_tuple_size = bi->metadata_size;
 
 	if (dif && type) {
 		bi->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ccda87d06a38..0d4011dcfed3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -120,6 +120,7 @@ struct blk_integrity {
 	unsigned char				pi_offset;
 	unsigned char				interval_exp;
 	unsigned char				tag_size;
+	unsigned char				pi_tuple_size;
 };
 
 typedef unsigned int __bitwise blk_mode_t;
-- 
2.25.1

