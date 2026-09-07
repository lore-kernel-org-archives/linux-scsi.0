Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76CF2DC331;
	Mon,  7 Sep 2026 07:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788767922; cv=none; b=egFa17Vxl9UIEpDXg2+YzLeijEOkRwqP7y0+53gwzfHI/cldzGrkpvC/1+7u24qkRz0tqBcIykJV2jo1QxQiETRYxbfkE+MnjlLEkfPWowU2hXNbZTpUj88w+zqi4HLpCnu0jYmBhcJhI3MkE3fC+PI68aTifTsCx4PKd+O69Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788767922; c=relaxed/simple;
	bh=5fjzStrZIbiodx/XEymXoakOpGBnSLYx1WR5oSv7fYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fb4etNgwOAEg3vbAv5+6FJnr2CVP9YvDaoD+RR+CEjnVW4grXLclRLGWc5EkqruB/+x9KiG+ejEV+X4MCryCZFL+MGx8xaWyAdC2pYu7KCrCDpCOrC4Qw4FKdt6SUCtf0v0pBoSOUZAPqVNmRAamW3l4JEJF+nboW2Ow1XhlD7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BZ+i/cdg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BZ+i/cdg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=317BV/HvLpVlfQbg9bbCtG1QnuB88sw+UKSw4crP9ZM=; b=BZ+i/cdgKNfGr3AWsSVow1YciL
	RTsow99DoYgeZZ6HA+oQYGwdxyCHof9uh9SjRjFsvFpumrNbrThUPU48hWaUvKMLZn9kUTykTZ/8X
	85k0A6UVnk6C2jEmWQLBTWiGh66BxECFOk/DfyM4wdapKaso9WMB7mNq/mfQb13fpwjH9/mtaeRDQ
	GXqau9YyHI5U0OylsZlLhROYSEneIeNoLxeaUzv9XXxQGCweDlC1eNRmJjS0kDfSKnq9ETE37mW30
	qfksIbBA24czDG6TvPdp+SZMqJZpLnrtQKojIFzn9kybcwmtsKj5q75lONTtAIYdLipz2CRjX8IWI
	9QGEtS4g==;
Received: from [93.123.20.121] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3UFU-00000006DCn-355T;
	Mon, 07 Sep 2026 07:58:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/6] common: factor out a _bdev_disk_name helper
Date: Mon,  7 Sep 2026 10:58:12 +0300
Message-ID: <20260907075822.749818-3-hch@lst.de>
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

This will be reused to look for the integrity subdirectory soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/common/rc b/common/rc
index 8add0eedf942..2fa7ddebd8fd 100644
--- a/common/rc
+++ b/common/rc
@@ -5233,28 +5233,35 @@ _sysfs_dev()
 	echo /sys/dev/block/$maj:$min
 }
 
-# Get the sysfs queue path for a block device, handling partitions correctly.
-_sysfs_queue_path()
+#
+# Get the name for the main disk block device given an arbitrary blockdevice
+# /dev/ entry
+#
+_bdev_disk_name()
 {
-	local dev parent
-	dev=$(_short_dev "$1")
+	local dev=$(_short_dev "$1")
 
 	# For partitions, queue details are in the parent device's sysfs dir
 	if [ -e "/sys/class/block/$dev/partition" ]; then
-		parent=$(basename "$(readlink -f /sys/class/block/$dev/..)")
-	else
-		parent="$dev"
+		dev=$(basename "$(readlink -f /sys/class/block/$dev/..)")
 	fi
 
-	local queue_path="/sys/block/$parent/queue"
+	echo "$dev"
+}
+
+# Get the sysfs queue path for a block device, handling partitions correctly.
+_sysfs_queue_path()
+{
+	local disk=$(_bdev_disk_name "$1")
+	local queue_path="/sys/block/$disk/queue"
 
 	# Verify the path exists before returning
 	if [ -e "$queue_path" ]; then
 		echo "$queue_path"
 		return 0
-	else
-		return 1
 	fi
+
+	return 1
 }
 
 # Get the minimum block size of a file.  Usually this is the
-- 
2.53.0

