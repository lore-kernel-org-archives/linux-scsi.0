Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A069C34F483;
	Mon, 31 Aug 2026 06:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158769; cv=none; b=vF/ohYiZiLjtihF6Al29u7TlQi5lyws00ZM+xGL4TEo0kXP5OejTyacpjVcALPO9bSG6bXaMWma0+NSyUiuYOy2flsPwv7ByWGlNtWd4kDwEop/k7pThc4JrYof/fYg25G86mZshN+e7Ok+6NJ4lLBWj82ri9WGn2qPCUZWhutU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158769; c=relaxed/simple;
	bh=D2cmpWMdolTGmdheb1XXnX23t8ExgvGYIzWRWC301+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMUTb2hftvDOWkBIWL4VHfPKy9L3PRBU48/zBWzgbS4xQGNLVXXUAtsPOvN9y53GBGO0x3SDQ0mwl5xBIQ7PYjNGQjkhdJ8QMbrUba8Rw15FLPo4o5xFQleL1jt21JPNfuQ/5VGtqFjuMxKkEIlTI7ofFGZYdMqHG5jGugXtbSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GAmQcCpk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GAmQcCpk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YdUqwO0ycFHlUFQYn391eLAQNyvTEogNU4HywfgCNwU=; b=GAmQcCpkLawbSC7jHbrA488slv
	6e6JyHxJ78uk/JyYhRSw4bnNHQXPAd8f2Y5B6AbdeuqniM9AYqJF9B/adIQND3W48Kf/thi4F4oTf
	3BCVL+eJdJ74b2alrkGKPeZ5vHwVq5Ozss+YNwVhbx8vce1umt6aOk6pIScuno9rqQt4EVX1Mr65L
	xuZt67680NxiRW/bUBywxUYISzb/+f88ONBGfksuJyH2SVBTJK/X0PXWlM2I8pWLbi8mfH5FbnaHK
	Bk7b0jwXPayPkhoe5Ysi0UHjAbDgcW0Il0I8TZkE0xtLVDUYxCWmdbOwcaVrp1c1Zc3diwqhEB++t
	HD7gdHsA==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vmR-00000008dFr-2RWp;
	Mon, 31 Aug 2026 06:46:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/6] common/scsi_debug: don't slow down I/O
Date: Mon, 31 Aug 2026 09:45:45 +0300
Message-ID: <20260831064557.2577241-2-hch@lst.de>
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

scsi_debug by defaults delays I/O and doesn't support multi-page I/O.
Flipping these defaults speed up each test using scsi_debug by more than
an order of magnitute on my test systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/scsi_debug | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/common/scsi_debug b/common/scsi_debug
index c3fe7be623fa..af51905dc4ba 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -59,9 +59,19 @@ _get_scsi_debug_dev()
 		let physical=physical/2
 		let phys_exp=phys_exp+1
 	done
-	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size $@"
-	echo "scsi_debug options $opts" >> $seqres.full
-	modprobe scsi_debug $opts
+
+	local opts=(
+		"sector_size=$logical"
+		"physblk_exp=$phys_exp"
+		"lowest_aligned=$unaligned"
+		"dev_size_mb=$size"
+		"delay=0"
+		"clustering=1"
+	)
+	opts+=("$@")
+
+	echo "scsi_debug options ${opts[*]}" >> $seqres.full
+	modprobe scsi_debug "${opts[@]}"
 	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
 	$UDEV_SETTLE_PROG
 	device=`grep -wl scsi_debug /sys/block/sd*/device/model | awk -F / '{print $4}'`
-- 
2.53.0

