Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E919F171E76;
	Mon, 16 Sep 2024 22:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726526988; cv=none; b=gx6NXzChn3KlpmHuFHY+vtjn28hie4SKEBStwH2b05q5WhGn4ajzleZMTISCjiKSC+TWjUVnB4+QdGi+sM0udSrfQNw7FxyaJp7DnRdZanuMVZe5mB1GwNG9JeR3qpw7YAvCjrT/H6EVKI7/4GGj2oJ+BcEQrtAvpu1dC2LjvX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726526988; c=relaxed/simple;
	bh=LFXpL5/nrAXstPiOj0IbxTit69TGzKOpoS47R1I/bUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tY5Qw/QFRR0ywHChQQvbEdTA83XXXPafjCNJwCk7VfO0G1gPZrDtLd1c2yQfEfjfydsuF5ZnuVaK9mGMs854ZNf3tqDJIFWPNsHTNkPPDINFg46JB8x/f2m5ZD5ermiGk/4yKIMqhm3SMdVEUG7aw/U6UJ0HOKo0aAIdUwMBwrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uRQdGMs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uRQdGMs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37984C4CEC5;
	Mon, 16 Sep 2024 22:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726526987;
	bh=LFXpL5/nrAXstPiOj0IbxTit69TGzKOpoS47R1I/bUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRQdGMs9El42oHS8FlP1L+Cffh1xjv7mPFiZD1wzTaJP4YYNUWyWan2aBB203A0CU
	 8mvvOCVFHgJ1c6E7swTlTbR9QEIg+oSvO6rKMqsPtiNKgJPEaC7IsLEWvjE4H6YoRe
	 pILtCpvgvt6snr9/Eg4V8QvfoAnp0BZbuXfu7SmTRQgyM9nTHz/MrfzcfnIS0IFM2w
	 57XrqndQn8CJCw1RXzOZ459Avbfce6iivA3fzJF4EYqDRvB8CQw89RUl38BIkPrnDC
	 rMikcDonK2+BEhcSWIOu/QW29rlgwnJVLPYM9VzDVHtJE2AIoi1ycWgVpmiaRvB08O
	 DwZVRAsmYTtoQ==
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
Date: Tue, 17 Sep 2024 00:49:09 +0200
Message-ID: <20240916224925.20540-6-frederic@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916224925.20540-1-frederic@kernel.org>
References: <20240916224925.20540-1-frederic@kernel.org>
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

