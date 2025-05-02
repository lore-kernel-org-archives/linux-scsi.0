Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E9F25334E;
	Fri,  2 May 2025 06:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168580; cv=none; b=rka2pWOmP6q5UkIQkykHNx1ITDQPqvKxnkZjPpyd4/nhRj8GcJjaX/UOOLIoY3bERN8O50nkj0hquEU7/d6eqKY+JD5JFR6zFq88wNxjBzEB7rtJiA6L+K9tyiTKKEIJW2OmPRR5jtQvy6T1hHGL3H0klhakPC6dqRqErsnxGnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168580; c=relaxed/simple;
	bh=REs9Pr4UkQGHUi3+CE4UFF8CiS0l6JDIAlNbyhMQtr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxm3GOCKRTaQTvizO87kC1UKLYroT6gaCF+6fr+TdTNcSarXczXin0Vcld+psI9rUbx/cuXx7shHiFFNJ+GkRk/gY91re5/sjgydLngFRSUXy8p6vUJob4jIAe7si/8O1ysgdBEjwfADTIdcZ/YgypNlIkIYhVqFDdf5VmEZ9e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fBJ3v7Hl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fBJ3v7Hl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2oL8x0BTuH24AYsPOwQRvxExDQJgTOpRI68w9zTOSkc=; b=fBJ3v7HlnI1NU6WPtYuIEeHs1C
	nKeFucRX8zQLGpyIwp8T3bhHOixJfyLjtWtAAaCkWeUx6A22iyAF7HX7AU5eubrtOgbuXsbLDeYAX
	MintWQ6g9MysJ0FFJ3NVYRyF2y1+In2pzU809bh9c3smC8fX/q3XBW8S0OpCry2HwmSZyDQhgSexD
	tgHcD8XRp/0PP3b2/DpO1NHmMhLXJIzlwshmugmGjULvwwqgq7+uooe02WTYtUw9HUnos/+i9KeJ1
	k8iuydxoEWIU2ObiASDJ8uqimRqJcok5Wo/c5u9L4KUtXahnEScgTBfvkJiFA69dOiFDVk3lNVoCg
	4pui77sQ==;
Received: from [185.143.37.16] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkDI-0000000113t-0iIo;
	Fri, 02 May 2025 06:49:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org
Subject: [PATCH 1/7] scsi: make aha152x depend on !HIGHMEM
Date: Fri,  2 May 2025 07:49:18 +0100
Message-ID: <20250502064930.2981820-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502064930.2981820-1-hch@lst.de>
References: <20250502064930.2981820-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is one of the last drivers depending on the block layer bounce
buffering code.  Restrict it to run on non-highmem configs so that the
bounce buffering code can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/Kconfig   | 1 +
 drivers/scsi/aha152x.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5a3c670aec27..c89e6991e934 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -403,6 +403,7 @@ config SCSI_ACARD
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
 	depends on ISA && SCSI
+	depends on !HIGHMEM
 	select SCSI_SPI_ATTRS
 	select CHECK_SIGNATURE
 	help
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 4276f868cd91..e94c0a19c435 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -746,7 +746,6 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	/* need to have host registered before triggering any interrupt */
 	list_add_tail(&HOSTDATA(shpnt)->host_list, &aha152x_host_list);
 
-	shpnt->no_highmem = true;
 	shpnt->io_port   = setup->io_port;
 	shpnt->n_io_port = IO_RANGE;
 	shpnt->irq       = setup->irq;
-- 
2.47.2

