Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986C0386C2A;
	Fri, 21 Aug 2026 05:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289111; cv=none; b=r0KSrbYuTLaMWr+Ua05GhJBQB/kq2GrSmnaKEXnHiak1hXF6AgxAx0fggkBAlEMescWx2Mewpx6D6Q+5PKjkJcEFP34skh6cdM/Ei7Lm2IZYx9dE7MsPkJBWu/h+/92oTQGeeaEQh96vN+Uh4k6HtnAqgzp3HMf6sbxkowAlklM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289111; c=relaxed/simple;
	bh=uXE7rgxul83qx2402yjpO3HCKIB3DXhVLR+tHZLBE1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UYy2uTjHUiZQEyDDWLb3+r8kHkTjDIhm4GhdgtViw1Lr/5Cam4PhxeOSlRQuya6SEnZ0TBZlAxmABAY9PnZwLE+RftChndhJIjIz3eHO7Q+KmFiaGBR+JmM1hPkAPS736jq+3KSfiUVSySM3kbrPRK1gVXlw3qNhJM60SnQ2Tno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Er2TbDaR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Er2TbDaR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=uXE7rgxul83qx2402yjpO3HCKIB3DXhVLR+tHZLBE1M=; b=Er2TbDaRfgycfmvc+QJtYuFew4
	4ZXuOBk/npD50gaoxukHpA4X1c0ENl6Jn9GpIXHwUPRfFisGiW2gUkYl7nXQlvq4E7/7QGz1O8w1I
	p9LCF2XLvSn5oGg1OtkIX59cBK7Qjq3cRHlBe/kvac8BLONp/OUeA0SFj5ibALqTuVn9Q7cYQNVgt
	wMksfpjGOjIjf9EONeyNcK2tPNZCK6ErICS3xHqvIGQq0g1K1ZYzMzkpvjttcC+4AMppo80HXky2G
	+k9+m4Ni8QRiQQleD8nqLTbPCrebXA1+k1B5WkUD5RFp3g8n8PsG98QARycoR3COT41hKSZkhgzwr
	vUyohz9A==;
Received: from [46.255.74.83] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHXW-0000000CYAX-133e;
	Fri, 21 Aug 2026 05:11:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-scsi@vger.kernel.org
Subject: add tests for file system on devices using protection information v2
Date: Fri, 21 Aug 2026 07:11:25 +0200
Message-ID: <20260821051133.1817670-1-hch@lst.de>
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

Changes since v1:
 - fix various requirements
 - use _exit
 - cleanup up the scsi_debug options building
 - add a new PI group
 - mark one of the new tests dangerous as it can crash Linux 7.2 and earlier
