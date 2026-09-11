Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEEC43E4AC;
	Fri, 11 Sep 2026 07:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110541; cv=none; b=fifCendf65Rpld8Jkuth/KHgM11Cf0ahZ0zXOUD7mCtJRlmxCzz5PWKLvLwmwRGmZJkXdIezKsbq0PwWHGuC666mCEQ8YbzK9PsHblG9PjSRuWVrjplShFkZNQ6V+wtlvCJdLs52JXnWLiH94LaGtx9vC85LZygZgIR3KsyyIuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110541; c=relaxed/simple;
	bh=zBo63tGkPm5iaIIIwFbV4kbXQ98RWNsCKf7VywCsXqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw6HDBMQecyAxrObQ2OQ/nvgmGbL9bffkIjDtqFVM4jgGQrtlR+naQUEK8cLIGhwozr+ooaEopncp8IaYSr6vgkBDJElpsmqsSi/F2JQljRVXG7AFjXB6WZAlkTq3Y6l4CRHH/e7sSfmByqeejkVeu+G6wXztz5qnKEsCeSnx1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F2q5BmBd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F2q5BmBd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q+/xN7R+bf//DO6afRgMxxqtD3AwNv0Mf20w9YnutMA=; b=F2q5BmBd6q/GO8mzAqVh/+I3K8
	DPuBsS0iVAnQ4X4HY4UcEHYQlv52lPPNlmSjJUFd5HX/t/wKyGDX2jOw+ZriLHoO1LfEEW+nfVBaO
	28/j8X3gxFlphEGTzdgQ95niGqry6L1nEr3nXi8wERCFfoy6BAkX7cpg/ZkOoCa/tsBFXAJeKbT4J
	JxhkjPG/9I6w0S+DJvL9H2W5mxzaPI+POQPa1LUsIgv79LkiIS5IePFl+qfBVfyntYdmpy9KmwXPz
	jxAJuHsWIU0H6pDTQZG9c85qDsQFZpjSOqvQ5O+FuGQrUrvdjpCwQQVVBdfi/uXwofG4W0h+uQ6W3
	ZwlKzjZA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vNR-0000000G08P-0bBE;
	Fri, 11 Sep 2026 07:08:49 +0000
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
Date: Fri, 11 Sep 2026 09:08:22 +0200
Message-ID: <20260911070831.1760646-5-hch@lst.de>
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

Add a group for tests exercising T10 protection information.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
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

