Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51CC43AB0;
	Mon, 31 Aug 2026 06:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158764; cv=none; b=h4liL7n5xkZWfvx6PQh758MTF4TSS0EhBytoihgNAb/+nVCK2jrp8GaF9Or9WhG5o4VHE7rn2T/7OSY38iCdQRKXMw7E44S9CKgHjoGiz/Ka4vc+PBp2xmPgpBDykAO6chwML997f5N0s54YchfCmmEX2OyomNv+6UGlrAf+950=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158764; c=relaxed/simple;
	bh=J4w2zvhxfCDz/AT3qGjGqJBWjT3Z55yf49IEQ0IrwEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EruLrHZ/LDParm/hCmPtsEIBaWkZakyDF1YlES1HqlNelzRmaneMVbgD2nDmZTAs0PNRSafq5YDtDn3U+gAW0rLz7XwS4v5XzNrZNgEu3LA94uZuQtIJ48SJt/NPyOynDRai59g9GKRZjtHBh3eXmcaoQwofvjvOXiTo604hxZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hCh7qaQ7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hCh7qaQ7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=J4w2zvhxfCDz/AT3qGjGqJBWjT3Z55yf49IEQ0IrwEs=; b=hCh7qaQ7R0pHnCPlErSL7vW0g7
	y1NdOgI/3kyYEHZIcoH+yTDcHIpow1DacUec7S+3Tyw1pLv7grV6kYYlJe8bR8OhKwaTJ4StF9UDn
	DMsggPBUZzv+qSXrSuIlldGiccF5YMYR/kBnvVqCFO8as5tpxCvNz5kULZZzm5CVJl8FaOhIgej3l
	0IKFfzybFrbBzmfYEqPCIQMcZzDnpftDPo1D9XbFV3aSSQ6DyLVe7Fh2FzB3swO3JAQ2N1lkUpnrR
	vgomMos17u121JfpTdEOYoSRCtihHs6OiVInaHgVb3RzPYn7Zoi4PVYaXpJAqyHHA9gexr0OmSAmb
	2Qu/NPVg==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vmM-00000008dFU-1TUO;
	Mon, 31 Aug 2026 06:46:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: add tests for file system on devices using protection information v3
Date: Mon, 31 Aug 2026 09:45:44 +0300
Message-ID: <20260831064557.2577241-1-hch@lst.de>
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

Changes since v2:
 - factor out a _bdev_disk_name helper

Changes since v1:
 - fix various requirements
 - use _exit
 - cleanup up the scsi_debug options building
 - add a new PI group
 - mark one of the new tests dangerous as it can crash Linux 7.2 and earlier
