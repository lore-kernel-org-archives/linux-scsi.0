Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABA83F4830;
	Fri, 21 Aug 2026 05:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289112; cv=none; b=L9vYOq0gSWbTMrxGWmtwWuXStdCPk3+oxQ4EsBLVOizdtUZsFhpxbXu3m5hetdz1CWYUXzU3Sd2AEo9NrA50kH7ybG8hM55E4lc18Lcafkjn+DLZCuzgLVBdGFP6nHfjai7cSOVAVN/oRr/fwJdusWzEsXbxzxlhnyWbYGN7+1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289112; c=relaxed/simple;
	bh=ofUz+QntHkUY/Zc6oFaEIjD04s6zU3pBrosads/IXoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0HNz+F6hzJV6nXwhLIWToHgRIHuF4LIWB/2pQcWAXXtvxuLuB2meYuGlyI66nshH1OH/g0BNEpMB9MadB8aKI89PnRpHMv7BhaE87g50TtmSuBN3qRfN3s3dzGim+kYTaCu6QpAxaWy2opJqlmDq1BKW0QKpDWZS05Vxkd41ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HQL6DwyR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HQL6DwyR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1OBGhClnpiZlLZqWZaPi+8CJZS9EwniuOuAOqYWzXDQ=; b=HQL6DwyRRRd538yi9ltK4hMySd
	WMVaQRSsBIzcloIgi0WHnn2KKL+4QXJXX9CxLYkmktMtSZy5gbDErzV+YhLW6shl9UL2qXRQwDM5I
	Jy8U5FL71uR8FrNmbtU7XuQ4pSTFScRXv2Z7zFgxt//lhc58k7doR5hb0IvSsJV9l1XNjgH9hwmsM
	E4yx9gSBoOwsn5Ao9QRojaeGvn0aQa2uJc+Wm3L+kktAiNqE1xEafk3WO3dZ9Suvf4ZVuhX0nJsKj
	Zu5zplk0sKusZiLpyMSLjva3hRoyYUzUu7v8Wd/7AKNiJvKQOSdfzGsAWgKqYh4jDWgXXlDvOoDRq
	o6tWBoCw==;
Received: from [46.255.74.83] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHXa-0000000CYAu-2pok;
	Fri, 21 Aug 2026 05:11:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/5] common/scsi_debug: don't slow down I/O
Date: Fri, 21 Aug 2026 07:11:26 +0200
Message-ID: <20260821051133.1817670-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260821051133.1817670-1-hch@lst.de>
References: <20260821051133.1817670-1-hch@lst.de>
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

