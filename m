Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57371C8255;
	Tue,  6 Aug 2024 12:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946052; cv=none; b=WMvFAmmjQHlv1A73+sa25Tdz1N3nnDwSDSAsvgpaq1mmcOEWd5Trz03Zn+MiWDVNCjCmAdf/qdjyNXIZZfcoBcvpfBz/XqsgtPmkp0RpsU2SygYZ2sN9absZkIvba3l71DrV7j+cDDmFcRUnG2D4D95QaqpmQrodCDEAY1+6wZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946052; c=relaxed/simple;
	bh=K215LfaK75UCVOUo04GL6NK2RKxN/vjy3m+r1pJMnDU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XWntDhZExqXcQzkwLvmzUPb+GgbKUUHL4EziaMwqYpYdYZCtJ9aCixGAnfI7xZiT8MADv5ZYaY2QULqcAJw72J6hh/YWfMFkvLBdS0x5NPldmnz42FGfBFOy5dnjaBvAQrbbQz+cWlMaU0xIC/Z1gfmp2Q80ADIKorgsq/10Wdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=v2ETkv+B; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="v2ETkv+B"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5DD50DAE1D;
	Tue,  6 Aug 2024 14:07:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722946048; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=HGHIibLh7VAu9I4NPj8HyvkwsyByHUpfbBbGy49uXs8=;
	b=v2ETkv+BBkWSAxgMFSEQzaS4FkIjHuM35t/9M3xy6fA0tFeZkNYnxxHcGAssFmbjzBrf+E
	bwOIH6tKTIxeZcwItusD7HyJV4lFWqvogq/eZAP2F2S96QY+RTkvbGf+PPr50yM0Z1+IhK
	vIkfb2fBqatq3jg1t/MF47GnwBZsHRrK2ZEmAMRKz9VHewQdMldpAqFYsKeUcC3ACMhBzP
	HjaZWUkPI3kU+mQhBlSwy9BCVcNSZYSb2qZAaMukwR3xs1LvxgbbpUALG5cXEG8tRkAid1
	rzIm1IB4dvY6e0bWnvPYcnrBedr/C30z6+7T5pEOKGxPsrqVsMR+kjfcBFH9Ew==
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 06 Aug 2024 14:06:40 +0200
Subject: [PATCH v3 08/15] sched/isolation: Add io_queue housekeeping option
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240806-isolcpus-io-queues-v3-8-da0eecfeaf8b@suse.de>
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

Multiqueue drivers such as nvme-pci are spreading IO queues on all CPUs
for optimal performance. isolcpu users are usually more concerned about
noise on isolated CPUs. Introduce a new isolcpus mask which allows the
user to define on which CPUs IO queues should be placed.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 include/linux/sched/isolation.h | 15 +++++++++++++++
 kernel/sched/isolation.c        |  7 +++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 2b461129d1fa..0101d0fc8c00 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -6,6 +6,20 @@
 #include <linux/init.h>
 #include <linux/tick.h>
 
+/**
+ * enum hk_type - housekeeping cpu mask types
+ * @HK_TYPE_TIMER:	housekeeping cpu mask for timers
+ * @HK_TYPE_RCU:	housekeeping cpu mask for RCU
+ * @HK_TYPE_MISC:	housekeeping cpu mask for miscalleanous resources
+ * @HK_TYPE_SCHED:	housekeeping cpu mask for scheduling
+ * @HK_TYPE_TICK:	housekeeping cpu maks for timer tick
+ * @HK_TYPE_DOMAIN:	housekeeping cpu mask for general SMP balancing
+ *			and scheduling algoririthms
+ * @HK_TYPE_WQ:		housekeeping cpu mask for worksqueues
+ * @HK_TYPE_MANAGED_IRQ: housekeeping cpu mask for managed IRQs
+ * @HK_TYPE_KTHREAD:	housekeeping cpu mask for kthreads
+ * @HK_TYPE_IO_QUEUE:	housekeeping cpu mask for I/O queues
+ */
 enum hk_type {
 	HK_TYPE_TIMER,
 	HK_TYPE_RCU,
@@ -16,6 +30,7 @@ enum hk_type {
 	HK_TYPE_WQ,
 	HK_TYPE_MANAGED_IRQ,
 	HK_TYPE_KTHREAD,
+	HK_TYPE_IO_QUEUE,
 	HK_TYPE_MAX
 };
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 5891e715f00d..91d7a434330c 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -18,6 +18,7 @@ enum hk_flags {
 	HK_FLAG_WQ		= BIT(HK_TYPE_WQ),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
 	HK_FLAG_KTHREAD		= BIT(HK_TYPE_KTHREAD),
+	HK_FLAG_IO_QUEUE	= BIT(HK_TYPE_IO_QUEUE),
 };
 
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
@@ -228,6 +229,12 @@ static int __init housekeeping_isolcpus_setup(char *str)
 			continue;
 		}
 
+		if (!strncmp(str, "io_queue,", 9)) {
+			str += 9;
+			flags |= HK_FLAG_IO_QUEUE;
+			continue;
+		}
+
 		/*
 		 * Skip unknown sub-parameter and validate that it is not
 		 * containing an invalid character.

-- 
2.46.0

