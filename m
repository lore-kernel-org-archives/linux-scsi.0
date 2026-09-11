Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398FC361977;
	Fri, 11 Sep 2026 07:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110528; cv=none; b=SiqzyfP0PbnDdX6jbG++kI98Lq1dSFgT9tmLCO5HuXNsGkQr08ihsjkGO317mCoOeBnNftTbOWzxp5M+9sKDV0XAxV6rMruWisSOzXfhvtwlPM7eBkRYgSLd6X6N2RMylG1u31LDhJKPvIPiLDlp0QHdHVNEHEI6r60hPrczTO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110528; c=relaxed/simple;
	bh=D2cmpWMdolTGmdheb1XXnX23t8ExgvGYIzWRWC301+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuEbiH5YpUluwb5qKJzpRN7WYOAK1FeBpg49OvWla8+DwvFFLVEM7+2nt0WXLrLxoNwUs4pJjqUeCbrYHKq4JTuRhD5/y7Eh/NXD1fn7wA6PbG8xJUNX5aOTVAoT6hZx7wPvidNPOxRfCP7HDKevvaN7TF1Gn4hN++eUoVWk9sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nbP6YcXF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nbP6YcXF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YdUqwO0ycFHlUFQYn391eLAQNyvTEogNU4HywfgCNwU=; b=nbP6YcXFrXaEjCnWzzTpdTxv2t
	cxvexjJGuRXeQKOfqIyYC13LAxOrD57ERyC3DBKz4biJrfNKOFEwvxGwgEjZc2JXJENEEK470Dh4c
	114Eo8c6uHFBoUIOFAOdYAlDx3dv3xoBusqS7xpxlS7I8h+bCxhONTbZn2inZrhp2uj+hc/9bTNxo
	Dh1Qsd5hwkq6awur+pOftz3UqBuq5VIKyV44kAX4o0iEYrjIYayuhC+Fk3lnRAaoB5aL+DK+tzaEA
	/7gAPsDldYosiJYDEw6G9qASAhbHOh6C9qHkC2HLEjrYkcLtEa2NeBpvNfo/caD1Y4d043qlANvEp
	SgcmcEDA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vNG-0000000G06v-1mjs;
	Fri, 11 Sep 2026 07:08:38 +0000
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
Date: Fri, 11 Sep 2026 09:08:19 +0200
Message-ID: <20260911070831.1760646-2-hch@lst.de>
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

