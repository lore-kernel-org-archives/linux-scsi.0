Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D7BA48;
	Fri,  5 Jul 2024 08:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720168330; cv=none; b=GCd8+xdVmAn4rVg/j8oLiYfIfF/11ESXuJG8Ica3SF35rFHBaj1egh/fIl2jjmRI8Xi82TkamGANDF/qkf3LoWJB++IOzq6PafEPDsjwjyaQn78QAHPbWTDF46L1bjGxqinyG2BG99C1rJ/ZGP+vcvXu2gNH6VbiiaeSetyDWe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720168330; c=relaxed/simple;
	bh=a6UXqQ0PashLa/Gd5TVsr8YP/9RWVulgubUaVgbBIfI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tfm/4aoWzCHDLAXIauapDs30PhFcppyvFlvmcaodTVhoORIXmsoriq3cQUsd/EP0fQQK1EGOA5AZvG1EX1DYsOsPMX03wJIbmVAB4BT36hpztYDc5A6HvsKBVxaA8EZuyvLA8fIK85dTjmMXRhixLLkIx98uhkb3OyswkqPOmwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hzsHEVRY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hzsHEVRY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=VMFWiI7e+j+R5r7N/1miL++JtqstPr0aKimqvCuzBHA=; b=hzsHEVRYGUHKZe3ELJuegzx3Gk
	n6ax7vbuSmJc9h4TwO1aHpewcgo598doiQGVv6nEt+xAQcbz8fO9z6wPGmI9LtCOYzwoboLuSLrew
	hLPPDP80utXrxjQAVrtvMipFfbZXjsT6iMg3HL7AsNl1l0nqSDD37yOsp11e39G3bbddMG0gngCNo
	qPfHesUMu3c/+xHie/1ABAh/lbQG5mxp2YUqb9/JmnrteDE+tkWvKf/xmgkew9entrsgFfJAF7US4
	UD3GuxIo+D/zsuL1hx+m7CwWg5mkZvEmKyJV+W5+BIzlV/7mQGNRRrCez3fnR32DmnGwkv6HBxq3I
	6p49tm/w==;
Received: from 2a02-8389-2341-5b80-7f6c-d254-a41c-2a9c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7f6c:d254:a41c:2a9c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sPeMR-0000000FHg9-108N;
	Fri, 05 Jul 2024 08:32:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org
Subject: fine-grained PI control
Date: Fri,  5 Jul 2024 10:32:04 +0200
Message-ID: <20240705083205.2111277-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

I'm trying to kick of a discussion on fine grained control of T10 PI
flags.  This concerns the new io_uring metadata interface including
comments made by Martin in response to earlier series, and observations
on how block devices with PI enabled don't work quite right right now
for a few uses cases.

The SCSI and NVMe PI interfaces allow fine-grained checking of the guard,
reference and app tags.  The io_uring interface exposes them to
userspace, which is useful.  The in-kernel implementation in the posted
patch set only uses these flags when detecting user passthrough and
currently only in the nvme driver.  I think we'll need to change the
in-kernel interface matches the user one, and the submitter of the PI
data chooses which of the tags to generate and check.

Martin also mentioned he wanted to see the BIP_CTRL_NOCHECK,
BIP_DISK_NOCHECK and BIP_IP_CHECKSUM checksum flags exposed.  Can you
explain how you want them to fit into the API?  Especially as AFAIK
they can't work generically, e.g. NVMe never has an IP checksum and
SCSI controllers might not offer them either.  NVMe doesn't have a way
to distinguish between disk and controller.

Last but not least the fact that all reads and writes on PI enabled
devices by default check the guard (and reference if available for the
PI type) tags leads to a lot of annoying warnings when the kernel or
userspace does speculative reads.  Most of this is to read signatures
of file systems or partitions, and that previously always succeeded,
but now returns an error and warns in the block layer.  I've been
wondering a few things here:

 - is there much of a point in having block layer and driver warnings
   (for NVMe we'll currently get both) by default, or should we leave
   that to the submitter that needs to check errors anyway?
 - should we have an opt-out or even opt-in for guard tag verification
   to avoid the higher level code tripping up on returned errors where
   they just want to check if a signature matches?
