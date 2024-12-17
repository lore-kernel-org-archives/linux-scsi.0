Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A09B1F8930;
	Tue, 17 Dec 2024 18:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734460189; cv=none; b=LBbDuHrvRHjWxL2dTkrzNJj2yzzPJ4SJPefhb3//0szeXQmftu1+BMlF16pW+rdeMbWJfRUQkhfhaDZeeugPK9OFZDFmu39DoDrF33hzqH68no3bCY/8jxOw8rkKCWomF4yW7Er+8wccBrMKct2+Mg3wXLMgqWghAmhLlOhw5Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734460189; c=relaxed/simple;
	bh=jEw2W00hJQ1lt+cTJ+qzs1E4wepHrE7BqSO1rO5WRPQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R/8F8YACXNBZE6m9V774q+/t8EDHIl+L/cHK7yEquqZaJm32UXNcCA9U0LSw2Op5kArFs7pLHT4a2ZOj0nsJABoYdvy/jQt2MqPzzD8ZNAIRxPNQcH0wuqntGxIu52bdSAcWVhutKly5iqqifgbdvIbFI1l67X9yUx34HRlxcEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fg2T7St/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fg2T7St/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1A3C4CED3;
	Tue, 17 Dec 2024 18:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734460188;
	bh=jEw2W00hJQ1lt+cTJ+qzs1E4wepHrE7BqSO1rO5WRPQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Fg2T7St/v8YfU2qpzV7JQguqKZ21VuLdqCSDnXtpZhe1E/4yDcm3yEvMRZsMOeYzM
	 5vUp66eT2WwpL0W/0K1D33L2GqqTbL0QmIzJ8ODYOoxrnQVI2quOOvgZOGY2O2WQnH
	 ks+eXh1WTZARtVTrjzPzTwef4rK/tJCNA2RtmKGIPG1YuM5ih6YY+/3COClq7MuHFk
	 5fJldEHT+48JpzBaL78xmuZajblNhHjPw0IZmy4zkXaF5mWhpIqgxuO8GwgAZTDSSL
	 T48xkQHtP6zxb24x4wJWXZAoPJmmRDZBeCmGXY87GT1sh4Q2Ej08IsLbwHf6T0XpWv
	 MVbbrGI9Dlp8g==
From: Daniel Wagner <wagi@kernel.org>
Date: Tue, 17 Dec 2024 19:29:36 +0100
Subject: [PATCH v4 2/9] sched/isolation: document HK_TYPE housekeeping
 option
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241217-isolcpus-io-queues-v4-2-5d355fbb1e14@kernel.org>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
In-Reply-To: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
 Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
 Don Brace <don.brace@microchip.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Thomas Gleixner <tglx@linutronix.de>
Cc: Costa Shulyupin <costa.shul@redhat.com>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, 
 Hannes Reinecke <hare@suse.de>, 
 Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
 "brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

The enum is a public API which can be used all over the kernel. This
warrants a bit of documentation.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 include/linux/sched/isolation.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 2b461129d1fad0fd0ef1ad759fe44695dc635e8c..6649c3a48e0ea0a88c84bf5f2a74bff039fadaf2 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -6,6 +6,19 @@
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
+ */
 enum hk_type {
 	HK_TYPE_TIMER,
 	HK_TYPE_RCU,

-- 
2.47.1

