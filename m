Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B001C36;
	Fri,  3 Jan 2025 07:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735889664; cv=none; b=eMEuMx+jdW4lI0Eq/lTG7Y03hBRstRkYH3xv2F+ePh0TdlMVrkNXHSZ6wUdLzEM0oYxP2XgGwkiuhnEPtFTM86Zpk0957qtU+Monpv4ulwtoOOPXhXrHGpqpvLcuRFe7pcQmJVoK8m98LZzmzrVsGvGfRghZNfa9WTdVcalCuuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735889664; c=relaxed/simple;
	bh=oj0BNvd07UZUPrtMHOvLjYx0oGDSmv382N2KH5QMnqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EFXJmeVgzNZRTqabag8unOmVJjwWxSN/WXSu5kLxE5x6KZXq7fiy9c8bixxjP4q0TNRqqysjQc4/rk1YBjCu8nkUDcfNi+gnIdLKvUi4sec0tVaDj1UVODkKBGOPI186NX7N5NwOBVGGBvTaRQ1CgIfrbh1roV88vySa30OjY0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vrFJwQXV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vrFJwQXV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=YMdPlpNXgCMaksxcreVbW0oQ3YoG3YbUI3RMdbhf/xY=; b=vrFJwQXViQsUmDbxz+ngtQExai
	qXZoYdpJ/3ljhMFQGhIIyiTUR5HZLtVlHU9suWtBKR14FBnWYk2d9/BDsUMlC29nwjIP0kXduZDtY
	LTBnRRuy8K0GJtBmX7YtqnY+s0Ql/sRdGQ4/vG2OabNw6vGkS9FdPmKW5nbpIjsEi3NLgshApBU/2
	JZEr6TrfKttUXTjeyqbUzpVFa7TadWpk/E/QK71cZ4LqqKYxsstLVrgsHpYX6Wlz3FgoSSdUyjLXp
	wYP/vWZD4d3Pgyv5D4KJlnYdZr9v2kerMq3+uN1qt1EVIlHAEsYMxHHS8ooQ2eEFjkxPnU3Nq+In8
	g3ovb4/w==;
Received: from [2001:4bb8:2dc:484c:63c3:48c7:ceee:8370] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tTcCK-0000000CM56-162F;
	Fri, 03 Jan 2025 07:34:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: simplify passthrough bio handling
Date: Fri,  3 Jan 2025 08:33:56 +0100
Message-ID: <20250103073417.459715-1-hch@lst.de>
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

this series removes the special casing when adding pages to passthrough
bios in favor of simply checking that they match the queue limits once
before submissions.  This mirrors where the zone append users have been
moving and a recent doing the same for a single optimizes passthrough
user.

Diffstat:
 block/bio.c                        |  107 +-----------------------------
 block/blk-map.c                    |  128 ++++++++++---------------------------
 block/blk-mq.c                     |    4 -
 block/blk.h                        |    8 --
 drivers/nvme/target/passthru.c     |   18 +++--
 drivers/nvme/target/zns.c          |    3 
 drivers/target/target_core_pscsi.c |    6 -
 include/linux/bio.h                |    2 
 include/linux/blk-mq.h             |    8 --
 9 files changed, 57 insertions(+), 227 deletions(-)
