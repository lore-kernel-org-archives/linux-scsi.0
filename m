Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1851C8FC5;
	Tue,  6 Aug 2024 12:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946054; cv=none; b=rDgjIN5tV64sisCISR2WNa+AZ8GFOcDh0ge2ZgaUOACKhTJ09JW+qL5XbBqHYtT3og6dlmKFy3UrRTtNwjQU/J6nz0ZRRIdq4v6girKTntQ8BooN0/PKIh6G32Qqyw8VlVwWu4OVXkVlFH3fW0dAvzPTyTFXoI506besKNuwAHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946054; c=relaxed/simple;
	bh=NTwierF+ULzrvJ4PzlC1WFNv9YJBBGWqvE6qmk+TK44=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uzHx7FPfPHW+hY+YvTO1SKiHDvnJb5lBKoj+uXsp+BURSRF1WuZJdkwmZBs9HA9V6zVbgY2qX8kh7rc5wS1SUMRaHoFiPBmcmzFBBW9sPE9bjofBvODP5xoJoNz2JiH1NN31Cwh5X9z6HKh5tSXT26sf/pMpsVvJbG9Zki7TQFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=p7iY69/b; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="p7iY69/b"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7D371DAE1E;
	Tue,  6 Aug 2024 14:07:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946050; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Da27AApIHCmREbL3F0FCZ+1oP8ihlsnaa1F9fgrccaw=;
	b=p7iY69/bJJXFtotZvjZBtrSM+GmEiKE449uaYkdFqaek4eNU7XBLty3NVL8BO/PnByYyO1
	bd5fZ47jjUCnPnScikX/WqWy5N/WSb6iBPrFrnNja2YLGJMv5fAMrpLXjMdLiDXp7/XsSA
	vKriLqtXVZ8fYwf9pUT/x/19tNsYETy8oSq5cQ1eiqReqoOEAhQuXzWlS9Vx1GbQQq9O4U
	6Fa6KLhEiOXnRHgiqZJK6SE7xh/V/AYklPmIWAvPgJFv4JkmXF6bW8+vDHWIH5ETCj0hvz
	8UlLLCM4YncXPIL9McUpI5vgCMt4SXdgLDAk07Bz3T+dL7/DjMYqBdeNn9TAPw==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:41 +0200
Subject: [PATCH v3 09/15] docs: add io_queue as isolcpus options
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-9-da0eecfeaf8b@suse.de>
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

isolcpus learned a new io_queue options. Explain what it does.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 Documentation/admin-guide/kernel-parameters.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f1384c7b59c9..a416cc969e97 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2446,6 +2446,15 @@
 			  housekeeping CPUs has no influence on those
 			  queues.
 
+			io_queue
+			  Isolate CPUs from IO queue placement by
+			  multiqueue drivers. Multiqueue drivers are
+			  allocating and distributing IO queues on all
+			  CPUs. When this option is set, the drivers will
+			  allocated only IO queues on the housekeeping
+			  CPUs. This option can't be used toghether with
+			  managed_irq, use one or the other.
+
 			The format of <cpu-list> is described above.
 
 	iucv=		[HW,NET]

-- 
2.46.0

