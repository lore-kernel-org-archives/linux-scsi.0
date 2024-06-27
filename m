Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B191817838D;
	Thu, 27 Jun 2024 12:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719492575; cv=none; b=uLpsk883NxaUPxZ5dxnzk+ArDUWYwbji4ubS4RHCfLT+G8TI8TRTxYOKa2lKbsVaOKG4/PcRRqagHJ5LuLEkn6Jva0DKxREn35Z2EHfDsw9UIKcyuKhzaIe62YzM20gDkxYD1WEg9ZnpWJOsU9oQ3GIr8ETv7qCc9ykn89Y1s7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719492575; c=relaxed/simple;
	bh=9b7Y51jGr8jyffHwtkrbTojeby5RB2BEjgyDlXK3hyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uASWpDrXSI6S6r1+ET0ju14ZwjTJzit8AFD8Qo1voOrmodCkIUUXn6g0/sJzgOPrVbnNFZ3EMdgVEL1iWsXtdy6xo1lKxWaSGQvyQktX1PvOgI+Js1TScGfN9ebApyRimhhIq0Bb99mPBs3z0ZdkQbzOHo+cyby6gTd0Mzhmrm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vlzyZTi/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vlzyZTi/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MIunlz/6mUa4L4NCCNBT8Z+Zk/UqwGgoWkSvOIM/iyE=; b=vlzyZTi/+wBP5YsQ8aGr42AjHr
	QmF0tEmaEZZTKHGhB1RLndXY5UgUmKzoqljAtHlhdS0TCsry3+lDlEV072hhOBhOQR/C3fYElgSJ/
	Em/axaXEVcdGegS8oaWuyvmNtMMCHZBRdVOodnljQ0dHmNk9uweSc0jcCmAE8YdZ2rMn8lkQH9jW3
	JhZmcaCXLsl1Cv5lLfcflHE5noM0KK5YBATpjS8SlQ1ngZdXsqX1ZUpYuva12Pjhre17KpkokkE4l
	mIH/bP3XVZnl9EsymFAL/zST/fnkb4URmz1dkmRMHBACZoOCLl/GR8aeaWS4XQiFAXadtsG1n9NnT
	Re4C0THg==;
Received: from [2001:4bb8:2dc:6d4c:6789:3c0c:a17:a2fe] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMoZ7-0000000AMzV-4ACg;
	Thu, 27 Jun 2024 12:49:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	linux-block@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com
Subject: get drivers out of setting queue flags
Date: Thu, 27 Jun 2024 14:49:10 +0200
Message-ID: <20240627124926.512662-1-hch@lst.de>
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

now that driver features have been moved out of the queue flags,
the abuses where drivers set random internal queue flags stand out
even more.  This series fixes them up.

Diffstat:
 block/loop.c                      |   15 ++-------------
 block/rnbd/rnbd-clt.c             |    2 --
 scsi/megaraid/megaraid_sas_base.c |    2 --
 scsi/mpt3sas/mpt3sas_scsih.c      |    6 ------
 4 files changed, 2 insertions(+), 23 deletions(-)
