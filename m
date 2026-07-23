Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C9D337105;
	Thu, 23 Jul 2026 14:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816950; cv=none; b=TngiJoEHYYgv3qEHr34EgtptLeHXn1FzWb1GY3PluCKCHgHALu2hjOh/fAduUOyLQZxr9+0NAMyy2qDpBiG1Y+CjIzPE74tEqZCWfphWxnkJ5e7wVq7AUKBrESzy3wGsbEw1cKwmbIIq2DlUpXbEOmEwkQk2WFWcvxkZKF0y/b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816950; c=relaxed/simple;
	bh=5r1B4Tc/D4c4KfpI2w/uve+tL0RlWwtDTOnfk0IyLdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU1GbP9iWMJCyQ7ND6HCDN4Uud70PVSr8sbAZGvvu5j1ssCkFNsWIHgyiOUgJT2Gofq3Jjn/0XTJPzcoE5p0s5Fo24dKXSMOswHJb410cc8MRYqa36xWs6H+vet2pmuEA0fL4Z7dEGP+9KFQwRTZEbcHGuXdJCfIxbYGWf9FnJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=foL3cFmz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="foL3cFmz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PHyg8cBTKftd/gGekV83gLBd6ExyRUMN8dEKXQMGkyQ=; b=foL3cFmz24BTI+1Pk8dBU9uXOR
	nV16FmUaIVG+hyGR200ipKSYB4vQLKPsTtDZW+QGne3YlMs14YTjWkhI3I8CT9Z9vzfelC/BUhMl5
	LW7fEAYcZVbdmSVcCjBC2vkiBnuSJhuoH9qScKUe7ik0DN0lWk3PXhoevexnwp5de7rntCSyEWsDM
	ogcBHjGuPx96Eus5qpFOjDnIo03+V4oZK2qJXGrtd+k0mJagZBYAHCeacVKlxvep3Pn9XPG8G3vzs
	mfMtPCnzenPCdff/+iiWSSOI8BzUZR27uoYGCyTlorRnnVWITRqrLDDGrMX9yGc/aW6ETeE+qxJec
	q4qQPySA==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuQ6-0000000EV9D-3oXh;
	Thu, 23 Jul 2026 14:29:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/4] common: add a _sysfs_block_integrity_path helper
Date: Thu, 23 Jul 2026 16:28:45 +0200
Message-ID: <20260723142856.108193-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723142856.108193-1-hch@lst.de>
References: <20260723142856.108193-1-hch@lst.de>
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
---
 common/rc | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/common/rc b/common/rc
index 106f044adc2d..96e74cfd4e5b 100644
--- a/common/rc
+++ b/common/rc
@@ -5254,6 +5254,31 @@ _sysfs_queue_path()
 	fi
 }
 
+# Get the sysfs block device integrity/ path for a block device, handling
+# partitions correctly.
+_sysfs_block_integrity_path()
+{
+	local dev parent
+	dev=$(_short_dev "$1")
+
+	# For partitions, integrity details are in the parent device's sysfs dir
+	if [ -e "/sys/class/block/$dev/partition" ]; then
+		parent=$(basename "$(readlink -f /sys/class/block/$dev/..)")
+	else
+		parent="$dev"
+	fi
+
+	local integrity_path="/sys/block/$parent/integrity"
+
+	# Verify the path exists before returning
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

