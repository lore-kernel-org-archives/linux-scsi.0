Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9E515B57B;
	Wed, 29 May 2024 05:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716959135; cv=none; b=V3mz0IhW9JeTdwV0Lp3POvqrFCkn2yWKDnfOAjjqhnquMFGkWw5npB85JK5A8tMyUNq4A6usokfHiq9Q+5uiZD21nDfk6IwWRpF+RUSWr6e+EhbyeAPry2z+OEd+a7lKeWOY2XagWETO8TOpgT/mJB/MvhgxRnUbUJeILv4IiyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716959135; c=relaxed/simple;
	bh=vN5VFLRXRSPHmmIU1D9ueA75sUZB/E/9TW+6jhpSrSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uli1kvvWyUSidel/wTAKV7wfeJvmgA31mTS+Fv8qxScqk4h6udCiRi+KqntlBLcMueaiExvqy39XxNYuBGd2UBmnSC+tw6PXXKpCVcHh5FR6VRTm/xBc25LyImT977RSZSqXdBl8v/p/GCj/0R1rjg3iReCn5+68VBx4fTUNepk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JV2Lk341; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JV2Lk341"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zW0EkOuxIkEXAr+kUSNAXR4zW6yla1v+V3lES4DaK0U=; b=JV2Lk341hcuT/7Vl5ccbx6rEF4
	LSvvlB9GQx61zLW6Ek9rMBriZIqorh2yE6n19JvBK8pX9/bCGIKdK8ZSpyJEO6QCmV4FTj9dJx9ct
	2mmqIL366QPU6zYx5zGQSrSTnDBwzdEgAuHzVnaP8EbOoN2JW7yLhrxCvxx4q95t/vZOmQ/fs/cKy
	Hwkml4dg7O0d9si4j5qAHqQU/FbHR3FB0PuKk8zFIIWsEMD/MnhlQRi1PZcYYk0TFsmHCcsFDcNLx
	/+4Z/3TAjBBZlqT2hEMfDtWsLUrRt4XNvmIyqd0q1bw8vLAqtevVrvfYTv+SnaOzLd/GwgYDhosg1
	p2ZtR9BA==;
Received: from 2a02-8389-2341-5b80-7775-b725-99f7-3344.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7775:b725:99f7:3344] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCBVB-00000002pbP-0kqv;
	Wed, 29 May 2024 05:05:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 07/12] sd: factor out a sd_discard_mode helper
Date: Wed, 29 May 2024 07:04:09 +0200
Message-ID: <20240529050507.1392041-8-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240529050507.1392041-1-hch@lst.de>
References: <20240529050507.1392041-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split the logic to pick the right discard mode into a little helper
to prepare for further changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 437743e3a0d37d..2d08b69154b995 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3201,6 +3201,25 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	return;
 }
 
+static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
+{
+	if (!sdkp->lbpvpd) {
+		/* LBP VPD page not provided */
+		if (sdkp->max_unmap_blocks)
+			return SD_LBP_UNMAP;
+		return SD_LBP_WS16;
+	}
+
+	/* LBP VPD page tells us what to use */
+	if (sdkp->lbpu && sdkp->max_unmap_blocks)
+		return SD_LBP_UNMAP;
+	if (sdkp->lbpws)
+		return SD_LBP_WS16;
+	if (sdkp->lbpws10)
+		return SD_LBP_WS10;
+	return SD_LBP_DISABLE;
+}
+
 /**
  * sd_read_block_limits - Query disk device for preferred I/O sizes.
  * @sdkp: disk to query
@@ -3239,23 +3258,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 			sdkp->unmap_alignment =
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
 
-		if (!sdkp->lbpvpd) { /* LBP VPD page not provided */
-
-			if (sdkp->max_unmap_blocks)
-				sd_config_discard(sdkp, SD_LBP_UNMAP);
-			else
-				sd_config_discard(sdkp, SD_LBP_WS16);
-
-		} else {	/* LBP VPD page tells us what to use */
-			if (sdkp->lbpu && sdkp->max_unmap_blocks)
-				sd_config_discard(sdkp, SD_LBP_UNMAP);
-			else if (sdkp->lbpws)
-				sd_config_discard(sdkp, SD_LBP_WS16);
-			else if (sdkp->lbpws10)
-				sd_config_discard(sdkp, SD_LBP_WS10);
-			else
-				sd_config_discard(sdkp, SD_LBP_DISABLE);
-		}
+		sd_config_discard(sdkp, sd_discard_mode(sdkp));
 	}
 
  out:
-- 
2.43.0

