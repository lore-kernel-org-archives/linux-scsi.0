Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0193334F483;
	Mon, 31 Aug 2026 06:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158780; cv=none; b=DRPMJUhfD64gJvMWc+lbXvhyQSRtnW6K2CiuUPLxYtb2suIHPgcXZIWht/12Lfktw1ysA5dBolqPwV1pkHEGZKe6vpbA1HPXgBW+gEZQ/qwxsntcuXsavrIK1Q3A2Ws2feZG+L9OqoF5ui10KtJXqB6bSxsqZc2nQqAT7H3zs/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158780; c=relaxed/simple;
	bh=HEJImmEGsFNrBEh2k1AB1NHBhDT8tF9pjPcbrv1Laes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KypuHTim+VVpayL6sUhOenh8X3/ESPSvlsCmzswrl1MW+p0eIo9da+KSM4IQOWxA+NQCvjmjklFSai5gwgWg9KVPze5LLTzk8QNXvlrJ9GC7kt5jgMyfjaliw8WXtu+mvrN86ZDmU8GUu1SXtJInSQoEnhAjeUusi1SM4kJvqPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UlRo/XQA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UlRo/XQA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w3XEp5TCzy2tsHnhsdtSDMPPkYuaTe+n3SqRiqu51OI=; b=UlRo/XQAgHiyNUdRJrbvpQuGen
	ChHs3V6SXVk3nyCS8M85mFhbVz7qY5q/FNKvXaO4gtewbUAexoMJS+ceJvsfE8oea4r9dolU+kFUu
	OTy9r6XCVmcvI7CifE+r5dPjUIk+oTaJTnVsGoedgDoO8BKgrpODuruHTlD5bsd2ExHObCLaqjDYt
	XPtAgl8YzrZK9xIKPx8ozBKgSfa5BqydFIyuZyQron84k+durzNpfxBr+9fGSiobSelIyy8SiOMAj
	jV9D3p30MgmBrMhv/AqBk2IWvmo1ADD4jFoX8k5t2sR2xYPj8neQn/JfPbcLgMI1N8zt4UEkr6Yd/
	wSyL+Kcw==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vmc-00000008dHF-0XQf;
	Mon, 31 Aug 2026 06:46:18 +0000
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
Date: Mon, 31 Aug 2026 09:45:47 +0300
Message-ID: <20260831064557.2577241-4-hch@lst.de>
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

Add a helper function to find the sysfs integrity directory for a given
block device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

