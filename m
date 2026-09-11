Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEE044062E;
	Fri, 11 Sep 2026 07:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110530; cv=none; b=iqQ0wjgYnM8n3qmn5luF8XLbx45NB8j3LEnsyJAqJdEjb8nbLJ3ntFxqZdJ7mMZ5i50f+F15W30hyX605VcZy0v0vo8gSQ+E1UPQYFc14d5EDZ9Osubuqk2JSzKnLd945jJPvd7ZrV4SOTDDTtKR1x9jMMr+UeHRwsw9BHXGoqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110530; c=relaxed/simple;
	bh=5fjzStrZIbiodx/XEymXoakOpGBnSLYx1WR5oSv7fYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBsXohuW2Nul/aO6TWoVwyKqJrzWaTuW1E8DXTrwp/jIVQ711RVkzUAENkmffQKDcYAIwhYQu9XHlDKRf7pREUidfWF/GA3RpJGD4KYouhf4APh7Bpl9+e3LRRvPJxGMM5vyCF+Gt9UH8OQ2W5BAPepFh6ESSkvk6Ivd53T/Kjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TdhGHAOZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TdhGHAOZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=317BV/HvLpVlfQbg9bbCtG1QnuB88sw+UKSw4crP9ZM=; b=TdhGHAOZ3XOvLnZfFvteR1MAEK
	UAMe8XBBpeVS61lcZZBgE6B8Z/nd6jhLopECC++0qvCm3+ATxib6HCIgitmBluIN6ntxT2iHtnUHU
	mig6N9zvD1a+rNqWe/PdcG9BwNeFg6I4eqfW0lTCV+wX2fvPaVUpVXMxmfpZFzf5z2Zv50DhSN0wb
	wEVmTTl+YSDdqpVZXi21PM6i1lbDwIwQjwR4wCt1LyUx+7GsrEYJmLwjfgWGfm/+ucLp0C1uZAcLc
	DjzL9PKBjEYaPMub79Gr8VRr8c1Dj6CvToQ/l4/JeqCQQ9775XeuUS9wzYzbNLRt2FzgV2gY3XWtn
	eug8eOqw==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vNK-0000000G07O-02qW;
	Fri, 11 Sep 2026 07:08:42 +0000
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
Date: Fri, 11 Sep 2026 09:08:20 +0200
Message-ID: <20260911070831.1760646-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260911070831.1760646-1-hch@lst.de>
References: <20260911070831.1760646-1-hch@lst.de>
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

