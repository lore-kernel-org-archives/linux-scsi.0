Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF422DF701;
	Thu, 23 Jul 2026 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816945; cv=none; b=smkVM7NJuOzP7lZJYo1FhnJIADP/3vMfQ1L4eaDOKFJtiWuuykdPOmH4DXJ5rcOBcSoqh2v1VzydGQt79kaMmMUy5kMlJ6GfGFGcn8cGAq2Q+pqg9KkGK5x6kKjOvVym//8/a1YDtSTtrq74me9v92BJt0NtWQuNPFnU+WznpuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816945; c=relaxed/simple;
	bh=IBUT2Jh3FvNVrSnBtSTAgR4eNvVBXyVRNyy8ki5Qd2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlDeWM3KwYyR+mTRiBaJGa8sUF1qZdp1XuPJ1gr9m4RpnX58x+0dZZ6autNjEHlgWpi+1X6C0o5dyEk7HTAMvWmy6b5wVdWLo6acEkeFI61++kQcuga4WsuK+jDAN9/tpHChyZiOmAueR54nEUGRZsYMTpoAfXgxpUL8PIuFPLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NsdUOqCF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NsdUOqCF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=J8BtUmtD+x6Q5vcciu1ZKwqYjLWpaplwnhMLfnjFVC4=; b=NsdUOqCFsefCY52dOkA+5n0Oot
	MmQBgUSjJ9Ly6rP+bvpXHKWdN++BOoA6XChB51NiCjG7ut2We4CwcE2z7xbMwXxFPeQdEMsWDgGvi
	2nCL/pMgWD8qQSOW/pbpMZqzP+7e2ZqmpUDUTeFp2usuNm7J0J27WxxD73vjWS/tAkw2Ngwvxq5wL
	4EE9vLaWDm1SFcoBO/5668hQxxX72wP5ogQHPdhUoCY0lVXEVZ3Y0DGPrXQ/3md0eeiZ1pE3NChM4
	L2QZOJTyhBe1YwoJn0dshlWXA3hTy4pJ5ftq2IZfG1hCnN2j5GGOo0yanJXHgVymTJChLdVTk4BQt
	hG42Ni/w==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuQ3-0000000EV8h-0yus;
	Thu, 23 Jul 2026 14:29:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/4] common/scsi_debug: don't slow down I/O
Date: Thu, 23 Jul 2026 16:28:44 +0200
Message-ID: <20260723142856.108193-2-hch@lst.de>
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

scsi_debug by defaults delays I/O and doesn't support multi-page I/O.
Flipping these defaults speed up each test using scsi_debug by more than
an order of magnitute on my test systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/scsi_debug | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/common/scsi_debug b/common/scsi_debug
index c3fe7be623fa..91665547bc0c 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -59,7 +59,9 @@ _get_scsi_debug_dev()
 		let physical=physical/2
 		let phys_exp=phys_exp+1
 	done
-	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size $@"
+	opts="sector_size=$logical physblk_exp=$phys_exp"
+	opts="${opts} lowest_aligned=$unaligned dev_size_mb=$size"
+	opts="${opts} delay=0 clustering=1 $@"
 	echo "scsi_debug options $opts" >> $seqres.full
 	modprobe scsi_debug $opts
 	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
-- 
2.53.0

