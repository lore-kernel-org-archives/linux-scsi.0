Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CCA7F7E2;
	Tue,  2 Apr 2024 13:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063228; cv=none; b=CZmkbA7PgjcetxniCE47nSjQUiOkZRGtmWwyQ4XnVZ6+ArbbE4JXBuprhiNkGxZ+Jv3mAgzE0Kkq+QdGh2PztcLQlDX3gP3oDCAF/LB6Dr/eD3yGKxzii/x02MR/JtTJ5htxCXfqTYtouTXUseDbGipivb1vrrPnnrbvK+oEJCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063228; c=relaxed/simple;
	bh=2p41IC6LMFCVMXzIO+KqIosaIi0kkjbOZLTGm3QzNcY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gb5wUC9R0945VHhImuezjgaVGJmS13Q+Yab9jGS9WMmff1nybCzRhNIIcoISjWjx3SLWHyNeMRCfFvfoi5+5beJtczCqI5b4sfRFtkWkBELzySA9xEgrgRzVXP+7GQ9rmeUemjP6uG743ZhIdlHCudAr+Hb+FSiPgTtz52Ps6EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KWKR7Ayw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KWKR7Ayw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=b4mNhGxzA9LjEehWNVRQAxLvg0/AqdN3hCnsH/xgLFY=; b=KWKR7AywTYpq/FXB8hzPvYInQs
	hRke4pmlbZ0U7jc22c14Mx6ID7qBx8mLOCxPmMCHCKcdybm9Fr0ZlPmEZOEFCXScwV0LPwt4DoBzi
	22quToblVu+2qkz/+qxpZxx0zUBK+Ionw0HnnNCXwj1BB7MKGVxoCS4TvpttAkzVmocYsM6ZJRduh
	qYX8OQUvWTWkRPrg2N6kPjQMtU3s++P8RLT7meDOqUGoJUsl3qRlZOGJvHQO9g41LGxbkdBm0i2oX
	sYZ0bAmHciEi7Qt1bU52dALJ+CSynQaaB3E8aNjQuB7FZ6vDMt/ZFMbybxFAW+aRxJy5tGI+jhivv
	hMt6UNHQ==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdqj-0000000BFIy-3GLA;
	Tue, 02 Apr 2024 13:06:50 +0000
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
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 01/23] block: add a helper to cancel atomic queue limit updates
Date: Tue,  2 Apr 2024 15:06:23 +0200
Message-Id: <20240402130645.653507-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240402130645.653507-1-hch@lst.de>
References: <20240402130645.653507-1-hch@lst.de>
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

