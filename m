Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08F2315531;
	Wed,  2 Jul 2025 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751474072; cv=none; b=AJOdWFqxSrQIKswThTtZTYBF+uAx5saV51e7RZTiuj2V8LTfT9oCzvzvHujo7AnM9nWoHCisvhF2N1P0pliteeTGZPhszvs/LSjI8iUZH+mP2sUCETedRyMhw4SsTQw5XK2Gfyk550logWJErNJb+6ZLmoAU1tjCZ3uqrD/qSNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751474072; c=relaxed/simple;
	bh=vxQYCEdaJjhalXM2LWdmwU2NhYSit9L084ZrGvIAi1s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fAf99RPBDC6rzt2ngvQ+HOZabbqPsWKB86LzH90j3GqxqBtCWRNU0tbGklCH2VGthYUUZVQ2Hc8noQJhfGJECbpZN+drq81c8cIha6y2PC5kj/sopHqiV/uR6nUO5Z7WG7k77SO8JD1xs7VI9JWACypZ3W6OP55RUigd1VISuk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YlsqVWRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YlsqVWRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914E1C4CEE7;
	Wed,  2 Jul 2025 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751474072;
	bh=vxQYCEdaJjhalXM2LWdmwU2NhYSit9L084ZrGvIAi1s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YlsqVWRqiOBec/ZJdDuUpTDrfzbfsA+bKi15TlITzblzeP22TZmGTvlkF19SPArgo
	 H7D3EBxICYst9MAFD+hOcP7eRP96DiFZcLNoMb36JG0ZrR4jKNwuVsBMijfbId73xQ
	 cgOvlGuiLyWnaiuZ4gxNpoN4TAdi1AlxKtPj6HMOHpgdQGUb1c+5CvFLLr5KRK7dhm
	 Z7rj95qpCR6A9qix29WifwcQkjNrPp6Il1stkf/rSwvPTonaYg5RLy7H1wdMPp5+Gd
	 YToOqMCLr5TOE0aB6RSl0rvQVZTFXd81MtLk8qfWSZojEpoEwqt6O+vyftQm9AuIk+
	 95aQqtRPe2o/Q==
From: Daniel Wagner <wagi@kernel.org>
Date: Wed, 02 Jul 2025 18:34:00 +0200
Subject: [PATCH v7 10/10] docs: add io_queue flag to isolcpus
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250702-isolcpus-io-queues-v7-10-557aa7eacce4@kernel.org>
References: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
In-Reply-To: <20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org>
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
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, storagedev@microchip.com, 
 virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

The io_queue flag informs multiqueue device drivers where to place
hardware queues. Document this new flag in the isolcpus
command-line argument description.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f1f2c0874da9ddfc95058c464fdf5dabaf0de713..7594ac5448575cc895ebf7af0fe051d42dc5e0e9 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2590,7 +2590,6 @@
 			  "number of CPUs in system - 1".
 
 			managed_irq
-
 			  Isolate from being targeted by managed interrupts
 			  which have an interrupt mask containing isolated
 			  CPUs. The affinity of managed interrupts is
@@ -2613,6 +2612,24 @@
 			  housekeeping CPUs has no influence on those
 			  queues.
 
+			io_queue
+			  Isolate from I/O queue work caused by multiqueue
+			  device drivers. Restrict the placement of
+			  queues to housekeeping CPUs only, ensuring that
+			  all I/O work is processed by a housekeeping CPU.
+
+			  Housekeeping CPUs that serve isolated CPUs
+			  cannot be offlined.
+
+			  The io_queue configuration takes precedence over
+			  managed_irq; thus, when io_queue is used,
+			  managed_irq has no effect.
+
+			  Note: When an isolated CPU issues an I/O request,
+			  it is forwarded to a housekeeping CPU. This will
+			  trigger a software interrupt on the completion
+			  path.
+
 			The format of <cpu-list> is described above.
 
 	iucv=		[HW,NET]

-- 
2.50.0

