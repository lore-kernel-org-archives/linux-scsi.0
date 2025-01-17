Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71EC155300;
	Fri, 17 Jan 2025 07:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737099892; cv=none; b=aTo6sT2JlCK3UtyBvjNuCAu3akPWBTF+vEHqlg4tecr5hAuuvPCbP9SpJnTX0+3ECP3jrfpcLGJ3r/HBNZiZjTOL2l1fUluDMnJ69cUYZJS1g54CkfT8XsDFRyXt0+4fuAC6XEnJrjsNdRQ+ftWEJEjJBg85wnzZ2vDmD1xnqk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737099892; c=relaxed/simple;
	bh=1G+n6Eoxa8H1GBSuQ+ZUouOiGyTE3Af1srqaX1OOuD0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i5Ncs6LRBKmy2sprOCObfw2H9ce7aLx5lCGJKcfiZSP3OYw9bcsx9gowBKhmiK/pJTiQbjepEyd6rjk9YLOmVt8L+NK4sWeJfo+8/FLGPP2otEvCNeoDjr3oTHx5k18Iv1m39lNXk1S7/OY15aIDC78p+NU4nItMlxByb+I8aMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4kocN+NR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4kocN+NR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZbVYkJYrb61Wu580Ft3djKNeSj1im8n+pYtEAikpOC0=; b=4kocN+NRToqX7xNsoN8OhOoZK9
	4T+lyUH4yD+p+6JBj/iJLHSK5rQFlKM9U0qpf7NjBBJAemrEH2IRwP+MRpeWaYu69bMiysOJ7l5K9
	sJ4cnzXGJiU1qpZczQ6g7ZpcIOp54dDdlkE3cAxzjWe7gHx8TF/YQwPQ8NUP5QEYcryWyoV7YLdIY
	3Guk2qfhZ9lFuyjbOoN5Hdjl0MHOmpOrdWZEE+q9/Q3U+BWw369oCDeFqJy4ZeM3mjlBbrvju6rCD
	DakJEzIYtaMC4fdUFASZ8qv9/etP/0VbR54K0IjcL4WMIDeDBSSKJ1qe5S+3hcvgBzI2uRW1zdBVw
	SLMP0gmg==;
Received: from 2a02-8389-2341-5b80-41c4-d87f-051e-5808.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:41c4:d87f:51e:5808] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tYh25-0000000HEBf-34Fd;
	Fri, 17 Jan 2025 07:44:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-mtd@lists.infradead.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: annotate noio context
Date: Fri, 17 Jan 2025 08:44:06 +0100
Message-ID: <20250117074442.256705-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

based on the reports from lockdep annotating q_usage_count it became
clear that we need to do noio allocations in a lot more place.  One
is when the block driver calls back into the file system as in the
loop driver, the other is anything done while a process has a queue
frozen.
