Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD7743AB0;
	Mon, 31 Aug 2026 06:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158785; cv=none; b=dmNNEa+eLvdBYPeGde7uFl9ucl/lFjh2n4Irp6jbyK0Z1LktArv2h3Z1VdN+iDujAHF68NxLKbDs6aH6fNbIRn881TqBwtr1Z8QTm0epgVP6NvUGrl7VHgNKNfpyoI97GcDocumkVnxz9bWLDHVpNs+E9QumajZts2sJkV72XFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158785; c=relaxed/simple;
	bh=odKe3sNHSCtaisKa2MiKOyhgstzzFYVPMcgORJbjPCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxPREPXi3t+HwFYKAWuCKem7YxuvRHstZWgpGorUvKh2EZh3VUyawEzjdBmjwjXcz0IDsho1TZ2V3McFjin6gnY0+QiClVqlxSSwPLV22+wl2hyMpWkXN6PWUsksVdVkNwB0Cb3bK2+HSOs5b3TAFU1RHXyQyYXBifDgcoYyPt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ln7z0RbE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ln7z0RbE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yhL0M419z5f1+iKmJhl1kj8Hoi7aiEKOj5EVHX4j7Fg=; b=Ln7z0RbE+IzaH46DzZx+Z2UmpJ
	Jln4sUsm1ZJbyo09VN4Ylqj91le3Ih7bfRUmu8ZAKcINwGClOd8lVdluj4Z4NgswJryWEIBxdd/uZ
	ceIrVoTmnhGIyFb9LHQXLnNrzTAN/4t9JmQOGuqh45kwAXMPw/CKlN2fnC9eFrWML1YTcwlic4W2f
	ax5AggoTK1bEqitWXaceYDPoFzqD9Rj9tbtwIjHrdmw4OouDWdEDYd5u6EBue0iWcfwCC/N+LXOz4
	NgNbH6kUbHd5CW2A95vYuEhFZLWLGwsRK5RW8BhyDY37kJh5mTddMS5HC4T6mnFoYjJKowEo4cDTe
	jCDELoNQ==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vmh-00000008dHu-2EYh;
	Mon, 31 Aug 2026 06:46:24 +0000
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
Date: Mon, 31 Aug 2026 09:45:48 +0300
Message-ID: <20260831064557.2577241-5-hch@lst.de>
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

