Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A7A1EFFAB;
	Mon,  5 May 2025 08:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746432719; cv=none; b=oAMA0S2p8WuCn1MclW2/i3cB7j7izzvTIzEBXXovwizzj6zzDJngbXfjhVQBTSl+SNEIpQSB3qFtfTwdEW9l/K4zVnNjIB7gtnPU1cw3U4AFJG7DPV5qDCNUXPPpsl9AL4ovH6+DptMRSz6q0wqjW+EzYflgihPTyHZqBqzozdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746432719; c=relaxed/simple;
	bh=FO6nLYvVF9ZhnyG1559CwGVx7zDkbbmezj4S0PqGmnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvWaHPfA6nmAOQLudyF/O3Om6zKaHUj4uqfYbYi3g3gEzo4X8HopLHx+mbNtjz6tT8KByzuAc1o+Wpv5MWmwYtFUdyzglbTxu2GILTQhSHHTxpttDB7ulXP6Ykqt3BJKBQbB5gJxj4/BlkMgrYzyhXK8+PKzGOA4p4w4C+wk9RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wclypl2x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wclypl2x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fy4oUQbvotJqjCLTSC+IbEg5Wy6muP8u9pnymtyKRSA=; b=Wclypl2xanXtkH1TkYyHWi14aG
	m1eimH3XxOwn7ShmUlVh6bQdwllhVOxBqfmFusOC/wB2YAhWSa+SezsPmaRK/mlripkmHdkL9dj49
	L+3D6ULaNdIyt2PdeHltV/FHknJzgUqz2RoI34TLnTbKeAwy0S2eEOfK4I7AZTHe19GrNocHfNLEN
	/TyeHlsgaFdj8/MFPuBObKd3sof99pVt3Lz6t+g7MiPM3eHQinUWaWM/ui9V6nHVGWsJK7ez+LX3s
	+8dEbOmgtf9KxhBpcdq6gV6t3rRpxy/khrC2A8RNot3Xltx2LIx3btCuq0zQY+to0Vio6gbI1zjsb
	vp0V+jUA==;
Received: from 2a02-8389-2341-5b80-f2ef-69c9-6274-23a2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f2ef:69c9:6274:23a2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBqvb-00000006kWe-0w2h;
	Mon, 05 May 2025 08:11:55 +0000
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
	linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/7] usb-storage: reject probe of device one non-DMA HCDs when using highmem
Date: Mon,  5 May 2025 10:11:23 +0200
Message-ID: <20250505081138.3435992-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505081138.3435992-1-hch@lst.de>
References: <20250505081138.3435992-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

usb-storage is the last user of the block layer bounce buffering now,
and only uses it for HCDs that do not support DMA on highmem configs.

Remove this support and fail the probe so that the block layer bounce
buffering can go away.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/usb/storage/usb.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index d36f3b6992bb..152ee3376550 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -1056,13 +1056,20 @@ int usb_stor_probe1(struct us_data **pus,
 		goto BadDevice;
 
 	/*
-	 * Some USB host controllers can't do DMA; they have to use PIO.
-	 * For such controllers we need to make sure the block layer sets
-	 * up bounce buffers in addressable memory.
+	 * Some USB host controllers can't do DMA: They have to use PIO, or they
+	 * have to use a small dedicated local memory area, or they have other
+	 * restrictions on addressable memory.
+	 *
+	 * We can't support these controllers on highmem systems as we don't
+	 * kmap or bounce buffer.
 	 */
-	if (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
-	    bus_to_hcd(us->pusb_dev->bus)->localmem_pool)
-		host->no_highmem = true;
+	if (IS_ENABLED(CONFIG_HIGHMEM) &&
+	    (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
+	     bus_to_hcd(us->pusb_dev->bus)->localmem_pool)) {
+		dev_warn(&intf->dev, "USB Mass Storage not supported on this host controller\n");
+		result = -EINVAL;
+		goto release;
+	}
 
 	/* Get the unusual_devs entries and the descriptors */
 	result = get_device_info(us, id, unusual_dev);
@@ -1081,6 +1088,7 @@ int usb_stor_probe1(struct us_data **pus,
 
 BadDevice:
 	usb_stor_dbg(us, "storage_probe() failed\n");
+release:
 	release_everything(us);
 	return result;
 }
-- 
2.47.2

