Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7376C23F291
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2025 09:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751275070; cv=none; b=pa4zm/GK7z7sY+s03d36GBcby97w8xxsHGTT2/fV4vr7FtnoyyRqqQAT9P9P6GcJ8U/8J0A7nLz7GHWQcxxPspgixigNDZZmEUE3do0Wjq8Yhb30o/SHdff+daAiPXfmcin2eiIbw+jgJ/NPcpSho7bG7c3jD1OjwR94hrEauAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751275070; c=relaxed/simple;
	bh=l7d2HmERGjJrnAdR+r/YQXVZoTEWxKity2C8MQke9Qc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rHY/VsQmc5QMwGKg+2ud00ScXAycoHWGzeKJIeCNk6IOit8jgE1OxGvjB4jPCsQrQK93dmmra0vzmdzAZ6HIeWBuDtBAJA/MzxhBmpz8O1PyR/qSbCwvGZgvYc+cszTvDj6Kar3cP2kEYrOfGqOs1fKZOUFSFyq+aVBbKYpz+dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HB85RYRf; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HB85RYRf"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250630090848epoutp03d07468b1fc00a057f9e29bd2edce065f~NxufKo6Gw1558315583epoutp03S
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2025 09:08:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250630090848epoutp03d07468b1fc00a057f9e29bd2edce065f~NxufKo6Gw1558315583epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1751274528;
	bh=6TLMo12NrRdJj8gx19wBfo3xQKMlPhwzBrcPjgdjAg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HB85RYRf3ABz+hyRWwPOopWZyHqct+Zee07rTrbB0tbbRbwq9qkJ7ehRtHuqBs0y6
	 49sMrFN8InIW4hiO2Hc/3LsR0pLdAlO3FSZJpMNvICTb1SuU9LNnLZNkfsLIwa7me9
	 3EjrdU+lPg34q2BB0vBK8SMEQuU2CJTGoDXZyW2A=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250630090848epcas5p335238c73ae5e9f65cb10149cfd011877~NxueivkNg1986819868epcas5p3E;
	Mon, 30 Jun 2025 09:08:48 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.174]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bW0hG0bswz3hhT9; Mon, 30 Jun
	2025 09:08:46 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250630090611epcas5p4e77ca8635bf5d3cefea3e3ce8a972dc3~NxsMfH3eN0099800998epcas5p4i;
	Mon, 30 Jun 2025 09:06:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250630090609epsmtip215cc84e0f6c39cc965c634fcbc404e05~NxsKTWNuq0992609926epsmtip2G;
	Mon, 30 Jun 2025 09:06:08 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: vincent.fu@samsung.com, jack@suse.cz, anuj1072538@gmail.com,
	axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org,
	hch@infradead.org, martin.petersen@oracle.com, ebiggers@kernel.org,
	adilger@dilger.ca
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH for-next v5 2/4] block: introduce pi_tuple_size field in
 blk_integrity
Date: Mon, 30 Jun 2025 14:35:46 +0530
Message-Id: <20250630090548.3317-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250630090548.3317-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250630090611epcas5p4e77ca8635bf5d3cefea3e3ce8a972dc3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250630090611epcas5p4e77ca8635bf5d3cefea3e3ce8a972dc3
References: <20250630090548.3317-1-anuj20.g@samsung.com>
	<CGME20250630090611epcas5p4e77ca8635bf5d3cefea3e3ce8a972dc3@epcas5p4.samsung.com>

Introduce a new pi_tuple_size field in struct blk_integrity to
explicitly represent the size (in bytes) of the protection information
(PI) tuple. This is a prep patch.
Add validation in blk_validate_integrity_limits() to ensure that
pi size matches the expected size for known checksum types and never
exceeds the pi_tuple_size.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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
index de8d27ceefc4..685dea0f23a3 100644
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
index edc3b458fbd9..82348fcc2455 100644
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

