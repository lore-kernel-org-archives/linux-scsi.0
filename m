Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AEE155A21;
	Fri, 26 Jul 2024 21:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722031041; cv=none; b=m0f1SA7st6jk17JFIU9lBpDoqsZJduHq7H5NmcRkUlndZwXfZ9X8IBRt52714ANMjZegid66/UZK0liyQwsK6tGA5N+kKQVyW5wwGgKCYO4t25edVcqiDMsCtLxK505Z+tyxLjYx6XLXkpKC7ebK6UrHO1ngKO6tcqSts4rgIvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722031041; c=relaxed/simple;
	bh=/RulNbNlovlYsV+8HlxUGhpAD5m4gMOyHvdHkAFhJrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrwO8DIC6fRqm/mZvx9hfNiZmi3a04htFSqHYPKLFCdS+KitkUawC1JY0Infs/XnM/sNxtf3ax5gUhI/aiprYjHT5q6yRwFcrRcYACBUvbta9GCtuvsxL65xPxQ1dZWs6I5P/QZhjWUCMxK6Z42nNLgE5GWz/5pKtui2pBXIhjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENHW0rS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENHW0rS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1DFC4AF12;
	Fri, 26 Jul 2024 21:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722031041;
	bh=/RulNbNlovlYsV+8HlxUGhpAD5m4gMOyHvdHkAFhJrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENHW0rS02/kad5POLgck+he3vIm6aP6gzNJ13rtT0DHih+ZjZetNfHh+e4DQ20tT2
	 y9LKilMGULebYDWFCINkLJEgzje6QSqvzjAs5s/NAvFyJkVSGv6OQbG7VYPt7OEFQ9
	 CkDNE4j5FU3QgVKQ8zxHODULdDFakmoI4xEhYf6VKIjzPyLMxdC8GS9Z0D/rZFWlug
	 k6DydeWF7yAcaXRwhtQqr/2iGXg5w7PN+GT8+zZFsQdJNpBGYGD6JZiuXMz015EYQ2
	 JfI8sZqq8rfi4MxW9ZXBvJ7k2w2NdFNuf7ZH4ml4vO9+4Q+Z8DCg1GymSxDAOMzO5S
	 iJd4+yLvVImiQ==
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
Subject: [PATCH 06/20] scsi: qedi: Use kthread_create_on_cpu()
Date: Fri, 26 Jul 2024 23:56:42 +0200
Message-ID: <20240726215701.19459-7-frederic@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240726215701.19459-1-frederic@kernel.org>
References: <20240726215701.19459-1-frederic@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the proper API instead of open coding it.

However it looks like qedi_percpu_io_thread() kthread could be
replaced by the use of a high prio workqueue instead.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cd0180b1f5b9..f30e27bb2233 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1960,13 +1960,11 @@ static int qedi_cpu_online(unsigned int cpu)
 	struct qedi_percpu_s *p = this_cpu_ptr(&qedi_percpu);
 	struct task_struct *thread;
 
-	thread = kthread_create_on_node(qedi_percpu_io_thread, (void *)p,
-					cpu_to_node(cpu),
-					"qedi_thread/%d", cpu);
+	thread = kthread_create_on_cpu(qedi_percpu_io_thread, (void *)p,
+				       cpu, "qedi_thread/%d");
 	if (IS_ERR(thread))
 		return PTR_ERR(thread);
 
-	kthread_bind(thread, cpu);
 	p->iothread = thread;
 	wake_up_process(thread);
 	return 0;
-- 
2.45.2

