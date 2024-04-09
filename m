Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3922D781;
	Tue,  9 Apr 2024 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673492; cv=none; b=kt2QrPBUJSqNDnX9dM//y37/PyRMQIRX0k7Mz8lopQ2VYPVhpWsHjxR592/Os8s1Os0j7IDuvFbReaKVqHAdLCASNR9VZkHKXcAnPiF4phLfUb8ukaFErnufzXCunNZIV9FKt+Gj/Eo7TQHUSRlXQrhZFhe1227iLIrzVNFE10E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673492; c=relaxed/simple;
	bh=WWYKPGj9czOqLTO0oX9N/l4w+cm5zbzGbk+M3GLZboE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CXVjGFBfz8bj0v5g6TFgpb/+bZHHFjAgSUioLZuYqvMtTniFuiwjov3wn8SRMXMqs8au1z/ocd8TtfXWVke4+ekf5T+vM6ENVHcGSBAsOUdhAnU2x7ymAR5B8HGNHmIjLItukNkbHFEWKVrqFPq5umDIRX1ylBbzuu39TG5pZ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fLPg523d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fLPg523d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X+gXVF78AgUh7bwzkprwZK7b92TFqgltEgDLxNaodqo=; b=fLPg523dfnH0RTzcadCtiXmfuu
	AJH/gG+ptmJmZHKCEDqSG4SN+IAs+DHm499u3i6VeUPBonHNomz5fUMtA9Z8ylPOpN9fwVRuVKf1w
	2b5XQs7VUdF64Zaltfk76I9JRy5AxhWAQhuxxPW8Z9xR6IvDn3I7H3QWyeKlzj65fMjiSDMv3tBIq
	x8KSxddyfEAwixu/wczVt9qaK782OeQj1fFFeh1zjF68xdtS2Fa6i3sHLdh+ouKXMgJs7JN/pD6gl
	Kv7by94ZotET5HGuW04HYxEc4PWci+vslRktdteqryi4T+CXtjXuVHW8IGoHwDjCHqitv3d5kVl8a
	sro5b6bQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCbn-00000002Ruc-1TRV;
	Tue, 09 Apr 2024 14:37:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/23] mpi3mr: pass queue_limits to bsg_setup_queue
Date: Tue,  9 Apr 2024 16:37:28 +0200
Message-Id: <20240409143748.980206-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409143748.980206-1-hch@lst.de>
References: <20240409143748.980206-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Pass the limits to bsg_setup_queue instead of setting them up on the live
queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index a45406fae2629b..3c309e8c3a2bc8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1845,6 +1845,10 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 {
 	struct device *bsg_dev = &mrioc->bsg_dev;
 	struct device *parent = &mrioc->shost->shost_gendev;
+	struct queue_limits lim = {
+		.max_hw_sectors		= MPI3MR_MAX_APP_XFER_SECTORS,
+		.max_segments		= MPI3MR_MAX_APP_XFER_SEGMENTS,
+	};
 
 	device_initialize(bsg_dev);
 
@@ -1860,20 +1864,14 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
-	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), NULL,
+	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
 			mpi3mr_bsg_request, NULL, 0);
 	if (IS_ERR(mrioc->bsg_queue)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
 		    dev_name(bsg_dev));
 		device_del(bsg_dev);
 		put_device(bsg_dev);
-		return;
 	}
-
-	blk_queue_max_segments(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SEGMENTS);
-	blk_queue_max_hw_sectors(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SECTORS);
-
-	return;
 }
 
 /**
-- 
2.39.2

