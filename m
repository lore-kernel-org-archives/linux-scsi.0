Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EC342A168;
	Fri, 11 Sep 2026 07:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110538; cv=none; b=mA/J0lhgoiclcfdBwGoHPCl/e9AP31r8Te+5cd8Gm1zm+G+fDT0V8zwa6FsrDbqaiTrBYV8EHE6gVBLusdpTezXskvktQqXXtKJ3/IbvhGT8Pbn/JfhKRk+RQpNFwhBO2wBMm2I+NeK9VzAaw3g3LrmVJnc76iUVyrIPrsFmr2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110538; c=relaxed/simple;
	bh=QLhl2HfdgFE3wTjYfuYjff1aphPGF1JM8ESoANhlWqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+qV8k19Ms373L3MUhXSRI9PuyqeL6g5/6f8zpFo1egVwkk2OiLGwvv9RGisS3YN2uujQ9f9I7s9cp0vKi06cdhHivMfIkoDkwnZT02euGu9dOc5y9k7YvdTTyuml6h31fJ/SAfr2x2UVeh6GQFiSuh+e/l4w06ddJaQxXgZmYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RFkqt/WZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RFkqt/WZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RDFrNog7bhAc78GAh/NGvr1ISlTw6COpGsWqnhZrcu8=; b=RFkqt/WZjCPMXV1770eXGCsSwI
	jcJDX9FxiBneD78JRNi3msAs+4pvvcubwPl5O6NZmuGAg7uzcvt6iWp0uuOPV3y345HnUfWhpUySP
	dLBM9kFEnUn8WJXqKlbhFydEF51/a+vh1UpAT/k+TBzcdQctOTiLUi1HZCXEBTOP0361c//tqNMPj
	m5MJKYTU61JImZe9lxCCLd35YdDmdLyGTH7dDNStk0aw+MAJBd22V9C54p4PeJxPumYU3rUXHV1S5
	9N8qY2DPvKzMwJv0MX1RIZG1OqygaorE/i+MQCR6MSj8lO1vjI7xXSYwBONtlayEmzPZWltT6ZVZr
	HsamNBEw==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vNN-0000000G07x-2QFa;
	Fri, 11 Sep 2026 07:08:45 +0000
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
Date: Fri, 11 Sep 2026 09:08:21 +0200
Message-ID: <20260911070831.1760646-4-hch@lst.de>
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

Add a helper function to find the sysfs integrity directory for a given
block device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
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

