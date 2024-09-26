Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613AF1B140D;
	Thu, 26 Sep 2024 22:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727390968; cv=none; b=kci0CCR0gxFZ1wWme+xR0ybKW9b9n1/kzOAOpbO6of6blHMf9uUlSGKEWjo2NwpdZpU7Wmk2pJF5kAj2zogrmdEA4qGkbOFnR0UCUf10/9YrcggsJYO5BhVX0ByD8Wqkv/rbdtytSsa/IkGxEwFvtwAnVu/D8tFPabjQg63XOAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727390968; c=relaxed/simple;
	bh=LFXpL5/nrAXstPiOj0IbxTit69TGzKOpoS47R1I/bUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M54J4GhQS6OgIC6tbgNnpLdi7eI/hn9UpdAqmh6F38twV36ChvaBngfyBT89bAe3IgR8sqBRFAJqHVTjkp+uDkxcxA0vUY/5mXnYKHk4bjXCJTBnvrOPo3vBY+4w5ZKgDbcfzBB/6cmTkVuI00cU3H9EMUZncLw57QOybz1JAbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmBba2Un; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmBba2Un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0F3C4CEC9;
	Thu, 26 Sep 2024 22:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727390967;
	bh=LFXpL5/nrAXstPiOj0IbxTit69TGzKOpoS47R1I/bUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmBba2UnkZIb9p6p1rdb6P8aQjl7oareIrQ/4NATZEsBVRZPvbzcwJ/17rvFdqNF7
	 nh9SMwxXzKEbJrwdEzlB+Ic6vxFBVSF9EoJC83mwgn5m0WDFtBQUHbNMUg6aQAFgP3
	 I7FRMUdm0a6+mxHwLRxQXfGdtmicY62IkURK7hiP5lUIi3zIo6mjUGqxaRiEsTfYHw
	 DryZHn1hDRxSO0e3ICeZG7QU0t59qbS2vGn6qzwO279/DrCTJRytQkPWwU4BUlRFXi
	 CBqEE2XNowZhHd2s452qZlR9tKpsg5Cow1O6Ey4fvHl/0RxKmU6tyZce4F8Cv1BFTb
	 wgwSCjvGBPZAw==
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
Subject: [PATCH 05/20] scsi: bnx2i: Use kthread_create_on_cpu()
Date: Fri, 27 Sep 2024 00:48:53 +0200
Message-ID: <20240926224910.11106-6-frederic@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240926224910.11106-1-frederic@kernel.org>
References: <20240926224910.11106-1-frederic@kernel.org>
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
2.46.0

