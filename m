Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435B61C579A;
	Tue,  6 Aug 2024 12:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946046; cv=none; b=MZf4oHDjgLv+Tbm+eBVeJMCEt/3T/Q1KbTHv0v96L6mmMYiWPYJ0EJrsSRoZE4L6wapvGG8Q7aJ7UCeqpvXeaIAKaYAoIWMFsLJxHDNcKIX3aPxMZnSWTE5MG6OSlKkLD6nNn2pznH6Fzu+Yxo4KCXGL/VWxfe0vvyrKO0yboyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946046; c=relaxed/simple;
	bh=KFJy4SZl4HXY2r33ps/m1hynIPJQGpefWVTwcsC3HC4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NKZTQ33hcYehWtcTTqEhXEScZqwiVs5J50FoO/2qEALss2LRu/RoPHEXw46sC6w5L2QnbA5sQJAE1z9jKtew5T/V0QjXQGPPgXzLvCOqsKkL6XeTynpozT6jQhUGmJXYzFqvQAeGtuk7iYJnmkRkD2wwSCt2qxeB0qDZ37WxU3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=cjEtMMZn; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="cjEtMMZn"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B7202DAE1A;
	Tue,  6 Aug 2024 14:07:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946042; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=cVDCNY6LvJbeDAGt09DL8tGpto0NtX7ZOAOrA4JJUms=;
	b=cjEtMMZnl3ZSNyx2WwYX4zi03MZlzjO79YyidzppW2+d/0SpDLB9RGMn6GuB6aRpzh4Dfe
	65LGkPRM2YIp4ksmttHHY5U9cG2chZ2E5Y8wP4P0ZmxPuVNQ9Pm+sf0zPtOvG0JSMZwtP7
	EH/jVVbKnaJG8bfEOnyN6kJs2ZCal00vZknbJw7Eg/IePQ8/JtVeMNW/ym5GJa04JZ4NQZ
	ljLOrAcnGZchxyM5oXBDzC4GuabNbeMuc+ENQKbWjelUPngnAyg5BqUNZzqqff5j7JUMF4
	2kicGhMFDQlTxBAucNCHHpDKm0wSFqp4iNRgBv4VUlFJfO9E5eIdNHn1qPPedA==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:37 +0200
Subject: [PATCH v3 05/15] nvme: replace blk_mq_pci_map_queues with
 blk_mq_dev_map_queues
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-5-da0eecfeaf8b@suse.de>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
In-Reply-To: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Sagi Grimberg <sagi@grimberg.me>, Thomas Gleixner <tglx@linutronix.de>, 
 Christoph Hellwig <hch@lst.de>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 John Garry <john.g.garry@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Jonathan Corbet <corbet@lwn.net>
Cc: Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
 virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com, 
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, 
 storagedev@microchip.com, linux-doc@vger.kernel.org, 
 Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.0
X-Last-TLS-Session-Version: TLSv1.3

Replace all users of blk_mq_pci_map_queues with the more generic
blk_mq_dev_map_queues. This in preparation to retire
blk_mq_pci_map_queues.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6cd9395ba9ec..5d509405a3e4 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -457,7 +457,8 @@ static void nvme_pci_map_queues(struct blk_mq_tag_set *set)
 		 */
 		map->queue_offset = qoff;
 		if (i != HCTX_TYPE_POLL && offset)
-			blk_mq_pci_map_queues(map, to_pci_dev(dev->dev), offset);
+			blk_mq_dev_map_queues(map, to_pci_dev(dev->dev), offset,
+					      blk_mq_pci_get_queue_affinity);
 		else
 			blk_mq_map_queues(map);
 		qoff += map->nr_queues;

-- 
2.46.0

