Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0532C695;
	Tue,  9 Apr 2024 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673493; cv=none; b=gcPq0WHD7+G1E3AG5VI33zw1tN8DxoPexH6vTVmS6aOCGsmR4+qXyDEgFmneMpESLMuhd9w2LFwko++8+jBIL6tZz/Ra5HG8Gt+rnnPmHgPgHtRCxsIHI+Ax1KZnxscLrBZgwVG9Ok7OHHN8Pmzz82dEBVuAoK8RDuDCjbsU0og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673493; c=relaxed/simple;
	bh=hOemByO5WgYltIs4RqgB0djileS9eDKxHul+XFaguiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FJpeMcNhfwok+JcM/V2ZpoujJgImse6aEFPEqcWmHLiuhuQ8kx+7d9ebFOkhzmPnqHzHggsVFfvExg93EgBeQQBhsySXyhm2K0J7MD6Xf+PRc34S0szpEmytOsGHcRh/0lFa7oInTRFrPDOw/+yvw5S1cwA12w1+vV/v0UrxMoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YjuIPpiD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YjuIPpiD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D8DxquL1CuBNuSFc3gPk4WkvzemBPok3WoQ6pw/OFO4=; b=YjuIPpiDDqP1jjM+Pk3XSw24bu
	2K1ugy2hc+vqmMr/juYxMKvU9pN1kGxHZybEJV6la2A4WLxdvFe0kni2ka/jJDP9N2rjxSr5oyabt
	KVpHe0FdCXCgDGAOmaY0HZhns9MhqNK+1+wyTpzx/zvMVREDZHKKAwLnnBfFxnnCDyn26U8g6hk3w
	Qc5NqC5ay1+zLJGQ9qqDq/vEbvvG/jnnqnjOLEEFWgv6OCiExmsLZiPjMDx1F4TOhgUYnpzPgs0ik
	2pGkQ4qUsqMvNxTof4BFeIS8RicWPJ6cEKjIUOJ7mRk1Efo6dKfMOA33zQ2c24CMHFttn2XYzm4rA
	UYoxvu6w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCbi-00000002Rta-0Tzi;
	Tue, 09 Apr 2024 14:37:54 +0000
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
	Kanchan Joshi <joshi.k@samsung.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/23] block: add a helper to cancel atomic queue limit updates
Date: Tue,  9 Apr 2024 16:37:26 +0200
Message-Id: <20240409143748.980206-2-hch@lst.de>
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

Drivers might have to perform complex actions to determine queue limits,
and those might fail.  Add a helper to cancel a queue limit update
that can be called in those cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/blkdev.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c3e8f7cf96be9e..ded7f66dc4b964 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -892,6 +892,19 @@ int queue_limits_commit_update(struct request_queue *q,
 		struct queue_limits *lim);
 int queue_limits_set(struct request_queue *q, struct queue_limits *lim);
 
+/**
+ * queue_limits_cancel_update - cancel an atomic update of queue limits
+ * @q:		queue to update
+ *
+ * This functions cancels an atomic update of the queue limits started by
+ * queue_limits_start_update() and should be used when an error occurs after
+ * starting update.
+ */
+static inline void queue_limits_cancel_update(struct request_queue *q)
+{
+	mutex_unlock(&q->limits_lock);
+}
+
 /*
  * Access functions for manipulating queue properties
  */
-- 
2.39.2

