Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2077714E2CC;
	Tue, 12 Nov 2024 17:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731430856; cv=none; b=nRTWYNge5Vs7CjAwDijTZa9BDHweF5AE0Z5rKEekLvWhB+8IpWGl8drts5z4jlRishltcTzEifidupcPsRlSp0THxB/ucKqcqzNzZ/ILNjjYGMsLCbRTgIR1nClmJ1AKqHN9s5qsWAuIBYUhDXM2nA78rl40k8NeLvoMb+Y/Z9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731430856; c=relaxed/simple;
	bh=MuD5gvZL0r08qy3l2opxyH9jW8dydBSdefA2uUURWXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n1Eavno6jx/aGGuDhyUNza+phcvVVCf6CxgFFEwBNvd6pli3rSMW41h1hDdOyvFAm5xizEIHHl/uua5Wg4PvwuEH9GLVDBEXlN/yFHnD+a2XKiJ/nqtx+gyOfWVbLsZ3dSIKxgNLWaND5F//MAx4ioEWr5JWNwkcFJ1GQ74aEcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xpSmnioe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xpSmnioe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=0X6QXqLgv/qUD1YCoZ0VfCTqcnxhofuv+SDj9XCYKMA=; b=xpSmnioefIiGZ0uRDWAGABnBx/
	iQmvnf2WYuBhM2N+grs2+LOXpTWQNRpAhnE95W5iVkHf9F9QtEj8gPCSzKFnNX3PU6CPRuZQSL0kP
	1JBlkEFPoyMN8E8ThRqdJO4cIMHoDWxJou3+qXwgAdwhdPulBFljWg+uRh76aE+cvVIAJ9BBFzVE3
	fHqMAo/DJeZMcp40tGwbYBWK3zppwqoA1Tf3wbN9zPTOewkLGTVAoCSSkKtPGE+LsRsdB4vaKNBnR
	LIEyPhHG6uZol6pgGvIjUtzw4z35zbawukYQChaj/EJ2x3XbnYMudOIhQojFg1W4Ungz8u1W0cRZe
	2kpPFj1A==;
Received: from 2a02-8389-2341-5b80-9a3d-4734-1162-bba0.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9a3d:4734:1162:bba0] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tAuG5-00000004GVa-37BT;
	Tue, 12 Nov 2024 17:00:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: remove two fields from struct request
Date: Tue, 12 Nov 2024 18:00:37 +0100
Message-ID: <20241112170050.1612998-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens,

this series removes two fields from struct request that just duplicate
information in the bios.  As-is it doesn't actually shrink the structure
size but instead just creates a 4 byte hole, but that will probably
become useful sooner or later.

Diffstat:
 block/blk-merge.c            |   26 ++++++++++++++------------
 block/blk-mq.c               |    5 +----
 drivers/scsi/sd.c            |    6 +++---
 include/linux/blk-mq.h       |    8 +++-----
 include/trace/events/block.h |    6 +++---
 5 files changed, 24 insertions(+), 27 deletions(-)
