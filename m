Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF433CFF5C;
	Mon,  7 Sep 2026 07:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788767912; cv=none; b=WKj4qNhIV4m6VlMVFtIqceM7F9mLPMJVHonmM4VkNenKA+v3cD76a8EuBoR0L9x5R/zN8atumqtV/XyvoI05PoIH8JOB/RzxjfXTrsNkCf1U1MSbjWxOUpv2eg9d/Ak/W3y+kNn6pxA//b/qUr0bBcBMaWK9coQs3dPaNo9RUAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788767912; c=relaxed/simple;
	bh=u9yc9JsRnu5cufXNuoF93gRqp8UWrcwTxl0URU7VWl0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kXHMdoTPdgy6am2c3y6dFaWlKZeum9lMkO7RxxqQxylj9T2ty28RAwuYdWPMR5idMj/nJJmCQWRrkbM8De1u3nh0pA68HxBBGFOEpmrh/GBxAXyTWZygzJuJG59kEtJtEDO++uFRL/FWcPp3Zp3fFM4aaNApHWE86Cbihd26FOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZI/pP21i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZI/pP21i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hnlNEwCJ/uiN45xviyb2FtCz/AV2cX3c3jQsZyJJ3y8=; b=ZI/pP21isjOOq0MnSMoykbQx7g
	qEOID8CRs/cXKWzKe+NnbqOksMBEKbEsiitBYKWg2BzfqWyqJfbZuTaN0rdEucuG0QBpUPSjM1cr9
	vNKQ4IMoi8XnPAPBYmcAoWK/A3CO8qRkRrdjA80NjVJcdVKI3Nvu0i7irotuTAkKSWYhrXTTWhW8l
	CVJCB5w/VVCuzWtf+GH1zRfODKtO/4LNBvWYgfPLVR9a7dicNsxXfSiQ2JUl9R1TsRxI3Xx1ZSnDu
	senCbkwgGblP1wKCrpmGREmmQN8dfn3S8MF2/WB822Flpax3tPJDLuVESdmlSNVd6qce+XXT9Sdi9
	0Ul4x/SQ==;
Received: from [93.123.20.121] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3UFH-00000006DB9-3R1A;
	Mon, 07 Sep 2026 07:58:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: add tests for file system on devices using protection information v4
Date: Mon,  7 Sep 2026 10:58:10 +0300
Message-ID: <20260907075822.749818-1-hch@lst.de>
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

Changes since v3:
 - notrun the new tests when CONFIG_BLK_DEV_INTEGRITY is not enabled
 - remove the unused dio_opts variable
 - rename phys_blk to phys_sector
 - make the last sector calculation work on different block sizes even
   if that test doesn't test that currently
 - fix typos

Changes since v2:
 - factor out a _bdev_disk_name helper

Changes since v1:
 - fix various requirements
 - use _exit
 - cleanup up the scsi_debug options building
 - add a new PI group
 - mark one of the new tests dangerous as it can crash Linux 7.2 and earlier
