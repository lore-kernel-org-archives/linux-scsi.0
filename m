Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22F613C676;
	Wed,  7 Aug 2024 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723046572; cv=none; b=ccRE1fJPspREt9imgfuUmxMxoGH2QDwoYT9aXCSx1yr9e8W0lRrr6xpD6nvA2YpqctjdUkJh4Jv2tbZMdW6IiE0lAbwXhy0muver8M/KtBWqnBjf4o5lsfwaWSQ6ab9+uednMHURJYq5pdYSKWp8VMhdXrPtRtSzeihfUKDIKv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723046572; c=relaxed/simple;
	bh=OdAmLrtcC1w3Cxa06wD8vbSjhHVtYldnsGlOoNisnoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXAaSP6VazcbJIH8M7S7lt6Ib3fMSYu6jPppUlFU2xFQ/IJa2p1hJ/DV0TUsCdTpAHwmjKcSLuY3NnThYy6DZuYKoM0wyIpMetPOMmCZ9ZqP37quYhmDwXBealHEbNF7WkKozwxH2IkWs54/vcBWiWupnkEGMfgV5YV+3HV0CVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJ+jiNUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJ+jiNUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC642C32781;
	Wed,  7 Aug 2024 16:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723046572;
	bh=OdAmLrtcC1w3Cxa06wD8vbSjhHVtYldnsGlOoNisnoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJ+jiNUCcUDnRj337EnA6PFQWjDBYzEKkTT0MHs2V70C36BMobSPnIf7GLhnYV+gb
	 EUODPxPS7gq/WDtTo5ZoQUwu+iiwafSVidoi+ntDIicrYm+IBUJvzJd5I8LYf1deiy
	 JTNIwv58tFh44bUYnaDTbHYzLA4nktBfYly/1r2rsFhueikIR49tlhWPEEelD7vwzu
	 IprpKJ5dlPqA8urLXz29VnhD/QXkBZ//Pjk2vFubJIhfNlwz4gVuBoI4gJhgtvn81L
	 GdbV6Ov5Z6VopsAmTilkKQUKdRbqkcXMR87yPER4PFsArPydw1olh2bZsO9nPjjuon
	 GZMMM2kRy9itQ==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 05/19] scsi: bnx2i: Use kthread_create_on_cpu()
Date: Wed,  7 Aug 2024 18:02:11 +0200
Message-ID: <20240807160228.26206-6-frederic@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240807160228.26206-1-frederic@kernel.org>
References: <20240807160228.26206-1-frederic@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the proper API instead of open coding it.

However it looks like bnx2i_percpu_io_thread() kthread could be
replaced by the use of a high prio workqueue instead.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/scsi/bnx2i/bnx2i_init.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 872ad37e2a6e..cecc3a026762 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -415,14 +415,11 @@ static int bnx2i_cpu_online(unsigned int cpu)
 
 	p = &per_cpu(bnx2i_percpu, cpu);
 
-	thread = kthread_create_on_node(bnx2i_percpu_io_thread, (void *)p,
-					cpu_to_node(cpu),
-					"bnx2i_thread/%d", cpu);
+	thread = kthread_create_on_cpu(bnx2i_percpu_io_thread, (void *)p,
+				       cpu, "bnx2i_thread/%d");
 	if (IS_ERR(thread))
 		return PTR_ERR(thread);
 
-	/* bind thread to the cpu */
-	kthread_bind(thread, cpu);
 	p->iothread = thread;
 	wake_up_process(thread);
 	return 0;
-- 
2.45.2

