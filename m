Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFD042B33E;
	Mon,  7 Sep 2026 07:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788767938; cv=none; b=l0QwfbcN4cRqZr0NZLh9CmJCSjdIKfCrfI60GOdYy/yjpUeu9c4tXxM9g44nIws+Emzzx9yxGhCKPeuqHwR1RwHAaLVHX73GxQenPAWmccupeIs5CF6cx4ElkvCuVPAeAitY7Widr81G+cVII/2faOMUfsivB67PbXJjt627YH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788767938; c=relaxed/simple;
	bh=odKe3sNHSCtaisKa2MiKOyhgstzzFYVPMcgORJbjPCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfKs5Bpz9TWM/MYYHkZjqWE+nCgkgzqa9P3dV75mKvRcgBNCAZl83Crtt0yt4ebHO0jQpO8Aln2d5p0dVQaUZBA/JMerP8F99GBx0ibaFHydxGfI64rInEJ3BIXMF5Tqv9aEO5DDSmq9tAZ0o9ARROwpD3772PcxWlH6wS0oryk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z17HrJY3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z17HrJY3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yhL0M419z5f1+iKmJhl1kj8Hoi7aiEKOj5EVHX4j7Fg=; b=z17HrJY31xEn1ltxoNGnTgx5vI
	yencGe1/myzDsFROjjSMkX1Z+GqxCsBO5hhVl7bmxOmbeKl/9nSM8ftvTnVPBs5wSoo8QhpCN1ejh
	jfKoTB/xURc1dmvqTlVCrVt5tQrWfysYOhrU7AO5DEWipSFtFTDN2E0Zru4cSVfGzaW66rZrOww1M
	tgY+Ts4r5YwFg1WJAxvryGdb66MQKpZAoRzu+CjuaOWRggTG/ugXxlp4An/XLWOEQDuLFcsQRjDCZ
	rV+DGQMvOVjnoOGgmGo2QZElyYP4hB0mtCVPUgBq5tckoNawfbHKcEIJX5F19kRVAtmoxWz2FPv+L
	nm3jyY3Q==;
Received: from [93.123.20.121] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3UFj-00000006DEI-0EGP;
	Mon, 07 Sep 2026 07:58:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 4/6] add a "pi" group
Date: Mon,  7 Sep 2026 10:58:14 +0300
Message-ID: <20260907075822.749818-5-hch@lst.de>
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

Add a group for tests exercising T10 protection information.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 doc/group-names.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/doc/group-names.txt b/doc/group-names.txt
index 424e2c4a1ca6..ef6b8f51cf87 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -137,6 +137,7 @@ tape			dump and restore with a tape
 tempfsid		temporary fsid
 thin			thin provisioning
 trim			FITRIM ioctl
+pi			Protection Information
 udf			UDF functionality tests
 union			tests from the unionmount test suite
 unlink			O_TMPFILE unlinked files
-- 
2.53.0

