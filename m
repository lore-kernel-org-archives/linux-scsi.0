Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E6D21504E;
	Fri, 10 Jan 2025 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526428; cv=none; b=CPDXOFf0wr/6WgvExL8DL65u/AZX6qGEvpodzg6Gtq+pISZF+EKEVEovr6/lpFtf76wEmzZ2ZoNBcLHXaLJ1GFlaCVNCi13rcwxU+o6e5HBgKNe6NtZJZLeRr7Vc16Xxl6MprVw0k6rAcFa5J4PeKGKDsgkgLNHjU4VxjpX+bjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526428; c=relaxed/simple;
	bh=KZEW4nhkxc3r/pWy7TVGP1x5+haiTt3SJOI/nLc24UA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pzyuo2btqzHp2cuvzkz+K9BYEH0YH4cU9k+IrLb0rOs1jW/0lz6yYIHprFJgMV4/fewaTASN3EbJUwcEiinRbGrL5eZ81SgsqYMJGAf9WPVyfxjM2qkCWrjZLLjGmPEBTrMjF8SmyNtrHDsIyc0hwlOv5smF8OqzGsoC5C5SqOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nh99LV66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nh99LV66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB67BC4CED6;
	Fri, 10 Jan 2025 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736526428;
	bh=KZEW4nhkxc3r/pWy7TVGP1x5+haiTt3SJOI/nLc24UA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nh99LV66Sd7DFDIC3HFT/s/WX1XS4Kouaa+FRlKEPrQl02bLY70e0ahgqaED7jDXt
	 p4xtbPSM17TN7JBo/1uxr+fG5dERy8zsLHSSLb76T3dcpllib6SADSc+dIHq4L4OWa
	 oxjPgtjDagdSD6gccU0RBHjtfD9okWrGKw6Oga5GHgllCZy7K2mtwP1ryFt0p+82QM
	 JnoTutQcIv9B1cQBb9ZIrC0d6ls3+slYvZSP1oa+IFkcxLw5ZcA/uIahG0NRNKk640
	 YcT8t5bqRt7l4xBVudpSwfynD2GztItYFhhvepnH0jnp54GgSlwoNbeusBsvKt3RJA
	 zuAL3xAzJk/ng==
From: Daniel Wagner <wagi@kernel.org>
Date: Fri, 10 Jan 2025 17:26:47 +0100
Subject: [PATCH v5 9/9] doc: update managed_irq documentation
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250110-isolcpus-io-queues-v5-9-0e4f118680b0@kernel.org>
References: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
In-Reply-To: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, storagedev@microchip.com, 
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

The managed_irq documentation is a bit difficult to understand. Rephrase
the current text and add the latest changes how managed_irq CPU sets are
handled.

Isolated CPUs and housekeeping CPUs are grouped into sets and the
possibility of stalls if all housekeeping CPUs are offlined in a set.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 46 +++++++++++++------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 3872bc6ec49d63772755504966ae70113f24a1db..e4bf1fc984943c1d4938dffb85d97da05010a325 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2460,28 +2460,30 @@
 			  "number of CPUs in system - 1".
 
 			managed_irq
-
-			  Isolate from being targeted by managed interrupts
-			  which have an interrupt mask containing isolated
-			  CPUs. The affinity of managed interrupts is
-			  handled by the kernel and cannot be changed via
-			  the /proc/irq/* interfaces.
-
-			  This isolation is best effort and only effective
-			  if the automatically assigned interrupt mask of a
-			  device queue contains isolated and housekeeping
-			  CPUs. If housekeeping CPUs are online then such
-			  interrupts are directed to the housekeeping CPU
-			  so that IO submitted on the housekeeping CPU
-			  cannot disturb the isolated CPU.
-
-			  If a queue's affinity mask contains only isolated
-			  CPUs then this parameter has no effect on the
-			  interrupt routing decision, though interrupts are
-			  only delivered when tasks running on those
-			  isolated CPUs submit IO. IO submitted on
-			  housekeeping CPUs has no influence on those
-			  queues.
+			  Isolate CPUs from IRQ-related work for drivers
+			  that support managed interrupts, ensuring no
+			  IRQ work is scheduled on the isolated CPUs. The
+			  kernel manages the affinity of managed
+			  interrupts, which cannot be changed via the
+			  /proc/irq/* interfaces.
+
+			  Since isolated CPUs do not handle IRQ work, the
+			  work is forwarded to housekeeping CPUs.
+			  Housekeeping and isolated CPUs are grouped into
+			  sets, ensuring at least one housekeeping CPU is
+			  available per set. Consequently, if all
+			  housekeeping CPUs in a set are offlined, there
+			  will be no CPU available to handle IRQ work for
+			  the isolated CPUs. Therefore, users should
+			  offline all isolated CPUs before offlining the
+			  housekeeping CPUs in a set to avoid stalls.
+
+			  The block layer ensures that no I/O is
+			  scheduled on isolated CPU, except when user
+			  applications running on the isolated CPUs issue
+			  I/O requests. In this case the I/O is issued
+			  from the isolated CPU and the IRQ related work
+			  is forwared to a housekeeping CPU.
 
 			The format of <cpu-list> is described above.
 

-- 
2.47.1

