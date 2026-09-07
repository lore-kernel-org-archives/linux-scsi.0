Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA3E423A66;
	Mon,  7 Sep 2026 07:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788767931; cv=none; b=OgKfHRCT9u1sRmuwGzcDPrYohf4mk1WnNKXfXx2EO/Uk04QxWSPoOa9qfJtNekbbFfi23qIfRHd3WLjs0tggvhBP6/FtTpF57cOed86XuSAED6calgiTzpV7C4TRHf19vXBgpiVIUivj+j3zTpHOelyRC1wOfvz9V+Wy884gyQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788767931; c=relaxed/simple;
	bh=tsrZY+1LCz9Vym+xH59uoIrWJzHyBhyHtiG3nOCoh1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQhle/+T624pyMXSY5LKvBtM19E1SS8vwucILVNecbEXTMadAJMgP12wfs1GdVl3jkXhsQ6XKyF1ELNMQ+jxN85++hO14wtgXzIqCYAcFSEi08RCf6/bqCgE9gA8d43Z/VP+SnsJazA3t2Yq4vPbRP7w8IjopBoL6MGXAepPlT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CgPE1Gab; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CgPE1Gab"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Z+/Sp14Q3b/anPS/+CfrCbk7GKiskpc9LcfdnZzEVCA=; b=CgPE1GabqTIgFx3vN5Un41xVKz
	JoFg1PSWvNzF7cSyK3qOR8QzLjl8gZjbz1LTxxiu/uGSNLYZI7UxvedqoNS0xZ6pSIDAeYBj6dmHz
	Lu+UAwXO0HdbS5UetD+rJhHXWzbXuq2bdjWrQjv/Or1DBxXNON3GXYJcXHVvygJAnaqx5wv3PQnVs
	WHF23Lj4066Wj/PRChgZbt0nE2Wd0Ymao3jdTPVOuWTyD6MSafqes6jgo9aKsNQldO2mjLUHrp59k
	cu1Jp7+qR/tUYCxpsW2VH7aVYruufCg3ZHLE6FvfbgaZ6dzTAGjneo9fPm0C8zRqv7wnlIgkFwUtj
	lf5FWREQ==;
Received: from [93.123.20.121] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3UFb-00000006DDC-3DQV;
	Mon, 07 Sep 2026 07:58:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 3/6] common: add a _sysfs_block_integrity_path helper
Date: Mon,  7 Sep 2026 10:58:13 +0300
Message-ID: <20260907075822.749818-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907075822.749818-1-hch@lst.de>
References: <20260907075822.749818-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper function to find the sysfs integrity directory for a given
block device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/common/rc b/common/rc
index 2fa7ddebd8fd..5e709dd79993 100644
--- a/common/rc
+++ b/common/rc
@@ -5264,6 +5264,21 @@ _sysfs_queue_path()
 	return 1
 }
 
+# Get the sysfs block device integrity/ path for a block device, handling
+# partitions correctly.
+_sysfs_block_integrity_path()
+{
+	local disk=$(_bdev_disk_name "$1")
+	local integrity_path="/sys/block/$disk/integrity"
+
+	if [ -e "$integrity_path" ]; then
+		echo "$integrity_path"
+		return 0
+	fi
+
+	return 1
+}
+
 # Get the minimum block size of a file.  Usually this is the
 # minimum fs block size, but some filesystems (ocfs2) do block
 # mappings in larger units.
-- 
2.53.0

