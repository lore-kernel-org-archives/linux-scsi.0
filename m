Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05B2319155;
	Fri,  5 Sep 2025 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084425; cv=none; b=KpJA0uMeEYWz9be47KkLgb5AEHmMeefNbJL2xtD3zt02WqzfjLQaxP6mKBH7dTvGPLXfVBFl6MO7ScLH/rwU0UgLgyrTQkUV9yy4mmVi4hTmi42UG4zifLkHTIIGJiAmNHsxqSP7DXhuo1kux+v5bGsAYQYRaH90fGuwx5FQgTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084425; c=relaxed/simple;
	bh=RKC5z2WEU+s9nBjTQYx3DaugYt9DytA+/DWNBaUypdE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=syGgdnUuO8pwpSOG5rY9Ob8Zsav4ujUFINW+0A7ZfVpDkZ+BUqAO/ILoo/voGwFmRI2duNYG9n3J0gZfk5X7iPkxYvXQ2BZMnwKTaNSLXrIE0FtK+CAtX/AtcUjRars47/BoW8M6Vjv21m6VweLeQyIcjpm+i9wSX9ehhFAdx6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdOJ0F9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdOJ0F9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE966C4CEF1;
	Fri,  5 Sep 2025 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757084425;
	bh=RKC5z2WEU+s9nBjTQYx3DaugYt9DytA+/DWNBaUypdE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=sdOJ0F9ep89rr4t3o8/YdBRPJXANT7KvK1l6wVoWK5hT+7RrAFPu7P7yvCtLjUNin
	 UWU0IvjEbPVaIumQNVPqpiDWuo0KBRoY3YYnnRwVG9N8Y06YbZa3BGM0CP0De/3BUC
	 zeOPR9WTjFPrPSbX6Agci88zzzpLwsYF46vjbws4T/MRpFe5Tmyo2tIqzn5B+zNASZ
	 fFWG+qUuyG2llvuPe8xW5H1Xd4yi96YOQWCFcQzYs68Pj74mTXs3je77nc1Biqn2eP
	 AoOxHFbFfKvsUi3YYjC0ajgB6+6yh/9fDqIGJFNMvxS/7NQXCUgp5kDECQr18le+kQ
	 LNiKjOHLdfbeg==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 05 Sep 2025 16:59:58 +0200
Subject: [PATCH v8 12/12] docs: add io_queue flag to isolcpus
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-isolcpus-io-queues-v8-12-885984c5daca@kernel.org>
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
In-Reply-To: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 GR-QLogic-Storage-Upstream@marvell.com, Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

The io_queue flag informs multiqueue device drivers where to place
hardware queues. Document this new flag in the isolcpus
command-line argument description.

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 747a55abf4946bb9efe320f0f62fdcd1560b0a71..4161d4277a7086f2a3726617826c50888eefb260 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2653,7 +2653,6 @@
 			  "number of CPUs in system - 1".
 
 			managed_irq
-
 			  Isolate from being targeted by managed interrupts
 			  which have an interrupt mask containing isolated
 			  CPUs. The affinity of managed interrupts is
@@ -2676,6 +2675,27 @@
 			  housekeeping CPUs has no influence on those
 			  queues.
 
+			io_queue
+			  Isolate from I/O queue work caused by multiqueue
+			  device drivers. Restrict the placement of
+			  queues to housekeeping CPUs only, ensuring that
+			  all I/O work is processed by a housekeeping CPU.
+
+			  The io_queue configuration takes precedence
+			  over managed_irq. When io_queue is used,
+			  managed_irq placement constrains have no
+			  effect.
+
+			  Note: Offlining housekeeping CPUS which serve
+			  isolated CPUs will be rejected. Isolated CPUs
+			  need to be offlined before offlining the
+			  housekeeping CPUs.
+
+			  Note: When an isolated CPU issues an I/O request,
+			  it is forwarded to a housekeeping CPU. This will
+			  trigger a software interrupt on the completion
+			  path.
+
 			The format of <cpu-list> is described above.
 
 	iucv=		[HW,NET]

-- 
2.51.0

