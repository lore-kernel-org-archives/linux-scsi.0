Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C235B230BD5;
	Mon,  7 Sep 2026 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788767917; cv=none; b=LNDkiBPX59CnkHgwRVMSc1D3eLIi0JMyMsa3lHylMTlRukvbr9Y63dY78kxR/cxRd72yaz7/9xrBHtYIUUJ4M0WHbOw/JyAVjNyai6Lx33vU0VNhS+ud2PJe+tyOu7GiuC+m01j7fA6GO6v/Guaft96t75UgBRZV0iJut7OuHSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788767917; c=relaxed/simple;
	bh=D2cmpWMdolTGmdheb1XXnX23t8ExgvGYIzWRWC301+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMsFMs0ixuIDjU2rjTaP1t3gboAK70Gy6rSJVbCe43gTzmWadN4OU689DUZ/KyvO9oULiM1HKwmATMMHg5tZTv0HLrt/kRl22Yp+05gAoe02aCjVPROQXKGAt6HxmHCKftlRWxNOVIiU8QNyHjOGwgV6peBQIxzOTTJ4vTggZP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gQz91ijD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gQz91ijD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YdUqwO0ycFHlUFQYn391eLAQNyvTEogNU4HywfgCNwU=; b=gQz91ijD09cQ8ssktt7j+7n4VP
	K5P1x8CRX56vUhxd9IneBjxv8kSfMN2n8+Kt7LqFG9sNICvOSQ+BGo2Zvk/J0yNQPSkZ7dLkrPA9O
	pFqZxispEUFKDo2zFZev/wm1Jz5PG9a92xtC3wGOq48B+G6/18l4YCYkUPWaAAzN6MGoAqr8z/x20
	5yDIYw+ddGUnmlrpWOw5eZnXWS1kKWChfBmZ2JRdbIhmpOu44xstnAwvDxSQQOsOvByvaBnTIPKWr
	ymb0737QcoWAhZCb+0Tw5Urm3X1khpcNMKQW4iTR7n/HRyuTZJqhcBF4kQ58KlJjjEFVu9PycFA82
	qEPtdU8w==;
Received: from [93.123.20.121] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3UFO-00000006DC2-2RGW;
	Mon, 07 Sep 2026 07:58:35 +0000
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
Date: Mon,  7 Sep 2026 10:58:11 +0300
Message-ID: <20260907075822.749818-2-hch@lst.de>
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

