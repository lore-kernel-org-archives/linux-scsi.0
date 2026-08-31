Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449143BCD05
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 06:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158705; cv=none; b=FcQ51887POWCIUioRP4N53gkd8YXCDMaYvSadvpnyA4tNs1LMTcYNBCi5xBf6xSVX5EMwhviP89MTZhTz37vH1rM+BLkoYVzka36s0JhtNz7Rbws/zGfTEGx+rdlBtNCs1cSoCccrO7BTiacjeAPA6KUSMkWcrAc2lJxaA36Fbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158705; c=relaxed/simple;
	bh=bQrWnePBjWWgZqX5I5THeYFizdB9bPJFW/LSHP0X2Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jgus1pTCYJAEpglM3fOnPb9tvZFBlK8HxFkx0v9ODrKh1ykZonHH7V8tpd0fR8XYG8DWmER2hyXPnwMMk0Ziv41RohLYf3lJy+bAS7QAayg2fu8NaY28G8X2A8s0326cVQRcQTv0bO7MjxdywvkkQbNaAWQqaUU8fSNqA9tZecg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kVDFwaIB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kVDFwaIB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Y/x3mO4pyQMxOw0WvAYh5ymJCYrz/fe3LceN8UcyUI4=; b=kVDFwaIBmpDaKSNq2x7Et8HITi
	EPGkNCY4nTeDjJ286KsGLu3RWvknyB2FV4oDR6LhNw8sUxHrM3WFKqLe/mVW7ey8RihuClelzzFvn
	vBdjKJXEfwkdcmNDeoLjq5Y480xE3HOZBipmewl1crjQQ7HVobY/wMbaTlH7dMw+0jvwrQRPyQK4a
	C9fM2pR27svrwWLNIQqk2hPe/F0JQTYxrF7/65wkdnSe9bkfr3HquLzz7M1OtgOkYgqcR+AwXMpX3
	297N02sPiU35uxXxAcwkvDO235p2DK4LSRnIvkI0+pBToxVsfKC+BaLMN+lN1M4Ru1S+6QvS3KZoT
	gSzU8DQQ==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vlP-00000008dCG-160X;
	Mon, 31 Aug 2026 06:45:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
Subject: scsi_debug: add support to corrupt data and/or reftag v3
Date: Mon, 31 Aug 2026 09:44:56 +0300
Message-ID: <20260831064500.2576832-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This will be used for testing PI support in xfstests.

Sashiko complains about a few existing issues, and "duplicate"
existing issues because of the capacity wraparound.  I do not
plan to address them as the use case of wrap-around does not
overlap with this, and fixing it partially would be a mess.

Similarly the long non-preemptible sections if injecting a long
consecutive range of LBA are intentional, but probably a bad idea
for a user to perform.  But putting an abritrary limit on the
number of blocks would not be helpful either.

Changes since v2:
 - protect against fake_rw=1,

Changes since v1:
 - use match_int to parse the  reftag_adjust option
 - don't bypass error cleanup on parsing failure
 - allow to corrupt the entire capacity
 - set the bug_if_fake_rw to devip2sip to false
 - fix the check for unmapped LBAs
 - require DIX for reftag corruption injection
 - make the kernel messages a bit less verbose
 - add calls to sdeb_data_lock and sdeb_data_sector_lock
