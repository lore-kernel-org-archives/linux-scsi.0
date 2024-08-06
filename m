Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1615B1C5790;
	Tue,  6 Aug 2024 12:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946046; cv=none; b=NZb+F3mU/3JXDQDUQw0nMw596Bp/5jQ86F2ZRx19IEHx2YL6irvP2uycHOePE1LEYep+5EXhREUAQbNXiiWp+6F6TbYLf4s68uYOa630bjrCx7b0EcHorOSbI+fo+cfZ8esSnUxq4fC7Rj2C2Tfz04S21YZQgxdhvWz2mESwbN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946046; c=relaxed/simple;
	bh=Qbn4POfkyJH85PtXNpe8eyfwv2m9KrCVvu5kPymGneU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oAVldIW9MUyXjB4hWmyBs5iMGq7E1V9RgxNUXPzSfcKu1zhBISJhkKHJKQ+1w4ATRithRMf2I1pm6KjTgp4qOQDqqqqm4oxmfKZhF7HWVZSwdQeDbRTu4R1h5M3BvicrtgYcp9t6ECCGtqzMLYOqp9CkNctVeTXBBBAFBN426LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=c/vpvIkD; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="c/vpvIkD"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 63821DAE16;
	Tue,  6 Aug 2024 14:07:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946035; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=osYY5nzy55CkrfzWmRIr1SR3q3EysjB9xRdYV7yd3hw=;
	b=c/vpvIkD6/xBTfCquyVI2tBGWfswjhFVVPKPVZEsAuzHu8fym6GW9S+IOVn8unfFHAA7Gl
	RNPd2WKjJFP5ONX9yTyJLnRD8LydEoWL8nSu2UbzQI+EwMUQrt0WZfM9WKQgVbV7v8mhDG
	brA6MvXTuH46yp2fFeC21vSXpBdJ/Ea7+EwynyNcMppx9Z51RDj7jcAfSGfLXi0yFM/GPl
	2HLkVbkt4hjHMgjQBOCjc2ZrVp4Fx1EjeOCBp1/6XKWNwoaqoqs3xERgIzccjXT/qQ0VxI
	PPEiGMbdC/a/nhzCffNDgwtmiBf2FEGgO0VvJJB2YNb0ZK03QWNT4kHsn6W9sw==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:34 +0200
Subject: [PATCH v3 02/15] virito: add APIs for retrieving vq affinity
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-2-da0eecfeaf8b@suse.de>
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

From: Ming Lei <ming.lei@redhat.com>

virtio-blk/virtio-scsi needs this API for retrieving vq's affinity.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/virtio/virtio.c | 10 ++++++++++
 include/linux/virtio.h  |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index a9b93e99c23a..c59a193ef337 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -592,6 +592,16 @@ int virtio_device_restore(struct virtio_device *dev)
 EXPORT_SYMBOL_GPL(virtio_device_restore);
 #endif
 
+const struct cpumask *virtio_get_vq_affinity(struct virtio_device *dev,
+		int index)
+{
+	if (!dev->config->get_vq_affinity)
+		return NULL;
+
+	return dev->config->get_vq_affinity(dev, index);
+}
+EXPORT_SYMBOL_GPL(virtio_get_vq_affinity);
+
 static int virtio_init(void)
 {
 	if (bus_register(&virtio_bus) != 0)
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index ecc5cb7b8c91..bab3858a4c8a 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -170,6 +170,8 @@ int virtio_device_restore(struct virtio_device *dev);
 void virtio_reset_device(struct virtio_device *dev);
 
 size_t virtio_max_dma_size(const struct virtio_device *vdev);
+const struct cpumask *virtio_get_vq_affinity(struct virtio_device *dev,
+					     int index);
 
 #define virtio_device_for_each_vq(vdev, vq) \
 	list_for_each_entry(vq, &vdev->vqs, list)

-- 
2.46.0

