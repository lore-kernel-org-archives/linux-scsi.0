Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC7C41A57C;
	Fri, 11 Sep 2026 07:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110528; cv=none; b=Kxo0wGTXnTUDJ5Hj3HvjPLjioOLOXN/XIW1kcyO6kPu/LSmyawluYAQSeYmyVnixKORYXf3F8IbCxxUlz1YHjB1Iwbixey0p0sm5mAqCwFjbiud0OTfIL8wbpaBJLHc5vKsB613v4jeXWEKgiIIMK1+S3wH5eg8FYFe82kL4DZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110528; c=relaxed/simple;
	bh=tM+OeyLI6wzc9HTYA7Te10o1cZERrQUhR0KC80eDysM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U4iPGQmZIFH65l8lPW+T0LWv2tSMBBqk8HgP4g3ohYy5ofijXJLYAsb5qGvM7DDNsOyqxIHNt9YrZs5Cs8fXzsZcpwmmvuEK1GLYkDER/OuNywQPUTXK08qTFIo3CvdMrzfl5wWHsRxev2APOt2olVZ1VnmUuYuU74sTuRFrkpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JIl5+UiW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JIl5+UiW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=IMHBxKTprz6/igA2b2FJXbcBfgMV27zDiBDsVKIOf8g=; b=JIl5+UiWCJCo5a1EJUeXw7NFCU
	yKgz+YyEPryM9P7lj8GhB4ULqNiztruAvDeBQqpXL01GtUYJGyYzsgZZSAF8ORFvpQDkpnamETCKI
	xebHyxvQwNl8AU/7RxuwDIe58H2NIW6Jb/8Ast7aEgRH1Wy+d5rn0j505jkJWf1+NCAFgQ3BdyjUh
	XWNxtJuIjj6cQDA33/xm9mpIBiIW2oEFjF48Oo75BeBR8hX20hCruQE0LBEI4xPvc3XerwVFj8hfF
	Uqhn8ovjQigL5tE8sajsO6lf1rCSS/xA715fkid7h/tL3QFa1/HDxeRWF9hEkg18Dou1ngKLixdaV
	3qtEBVRA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vNC-0000000G06L-3dhO;
	Fri, 11 Sep 2026 07:08:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: add tests for file system on devices using protection information v5
Date: Fri, 11 Sep 2026 09:08:18 +0200
Message-ID: <20260911070831.1760646-1-hch@lst.de>
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

Changes since v4:
 - fix testing of PI checking in the last I/O sector that got broken in
   the last round

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
