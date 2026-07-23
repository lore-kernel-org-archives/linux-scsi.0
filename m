Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6367B3630B2;
	Thu, 23 Jul 2026 14:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816945; cv=none; b=IvtOOQiYuayF0J1LlhoQGcPlE6fjkRIK/PiYfdk4Z56+1rMgTpTHgTbzwVKbj2xUhcyKWkHUYzsBAdobFTnXh3rMRFiVDD8jhpKh/lH+wgspV/+KHoPm7XNOCOthQBKse0tLDNTNFwLpjrT9pTv608mL/7F6RgVSG676K3hhnDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816945; c=relaxed/simple;
	bh=NqeNO/i7dnzPHrmkKJaFJsyEWzg+od9IZwv2xB9NpXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t/Fek9mTR/POOLoj4Mb0184vi7MT9U4nu70O3yrVubLx0MerGPP3LeytTqkeTBujneUy7KVQUUr3KNE3in3lVHHtjK2tqlWBmo6txeDBCGv+cCfoIVSogZM6pOyvNLVAkd8+j3CwlrudRLTNN6nSmHu0GyMxDz2XvPR8E5bDBaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N8PoPfD0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N8PoPfD0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=NqeNO/i7dnzPHrmkKJaFJsyEWzg+od9IZwv2xB9NpXU=; b=N8PoPfD0X11cSXFQJvDBwriNFb
	O9Jk8lgiIGviLE7WaYMXqbqN3XMpgZ3zIHJHQsOqwAgv5PyersaToIuFUaJsxxYL5XAaaE2jilXkm
	W0AOe8bGrXbbi0x5TcsnBCY0QU4il7E+OuPNHV8LEPSyhKY1Fs0L/YDGcrxCt936tS0NMIemF5ZGI
	92Kv4yS2ABWItfJ1hLaa7KKgI46UGM4jPUXPU0sBbwL+l2Y7gJy0S6BQGOk7uB/n+D/skZYQAiw9W
	AEJDfPvKVx/Mp3vFE3iHN8UfS55aLlAgNuXcndEFjtNJLlJym4tbZ6L6WvS8mIfN9ujAhUMf6lM5d
	ZLH0OLQA==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuPz-0000000EV8B-2zGy;
	Thu, 23 Jul 2026 14:29:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-scsi@vger.kernel.org
Subject: add tests for file system on devices using protection information
Date: Thu, 23 Jul 2026 16:28:43 +0200
Message-ID: <20260723142856.108193-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series adds support to exercise I/O on file systems using protection
information in the device, including that corruption is properly
reported.

The second test requires a patch to inject corruption into scsi_debug
that was posted to the linux-scsi list.
