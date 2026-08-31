Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB89343AB0;
	Mon, 31 Aug 2026 06:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158774; cv=none; b=WvuPJvt0fulAmyiCSEYI7BnP5P5qm1/BWUL7W1k+o+N//GYwF6CCCCJr52zuezKZdAtVEvQFnQDqk6/Us73zc2fUYh1XXJvgB4WWDDhHH+I8xhFMEPGCUJqrtFtPrq+ON52PGCeG7ZyYRk4YB8ZVyfLztjyqLmT/Hws6Jd8Yvr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158774; c=relaxed/simple;
	bh=O2lez1svQJDpAXfdd3MTsFDhtseNCii9Nd4Mba+ICp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEU9LQ6en2TcyABL7FYNyRB3ByJVedQnrKZ0UW3Ay7VnYqOYJ0s9RFJhReK205yYXt3oAn///LALM/d23jq0RkzJONYYLClGRDacWYuDWJDdCt38BXqQmZx1ZTsWGNfdQ38z6Z0g11xZOjoF/JVVKV/A57F8LSZaN6sqQGO4lsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LfEEPZ1a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LfEEPZ1a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tkSZN2auPE0qCuUxesmw+FbM80fF1F2yTCZbXl/vbgA=; b=LfEEPZ1aX91miePxfNAin0p2kR
	vnJgXlfLIpzKYXVI+9sjkJJWXHjdx/mRJToNvks92JkifxkEyAEsjRcBFQkagVaaMJ1MsHxmG+Mx9
	QieG3UWDdnuyppDfyYDIAYsSHUdHJ1aOp+dDQE0FgQpqXurcBRg3hvun/hCwf/t1pI1w6COnUjCg/
	dLgGtTFNPMi7KEoImGqNPE7Gab4YGkGbOPKRdZhdsXoAQkfs3XW6pS77H2XUWuIL1CtBoNn2kTwHO
	ap7HWtCC3vpCl7ptMbQwz4VEWlZEuCE9quT+9NEDWPmKzfVEzKK2fjekpYqBm1b7lg5Obg0SagMP0
	+u3sn2LQ==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vmW-00000008dGJ-3s2b;
	Mon, 31 Aug 2026 06:46:13 +0000
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
Date: Mon, 31 Aug 2026 09:45:46 +0300
Message-ID: <20260831064557.2577241-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064557.2577241-1-hch@lst.de>
References: <20260831064557.2577241-1-hch@lst.de>
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

