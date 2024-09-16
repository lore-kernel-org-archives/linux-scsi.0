Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95C017BEB4;
	Mon, 16 Sep 2024 22:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726526990; cv=none; b=BodaQG3Z/Niwh69uOQyog/EMAPtKVW+gY9UMkdM/xhGeuKVYrlGicenTRz+WTiKm0BU/P3dDDM1tLV63LEe5wOP3dgHokPyUfuoLdsXUdTp3DEutPxr/t2n2rgxuKoV2jFEdpy9w15nEE5vYMd7Ixj1hapRagp5rBj37oCn2SJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726526990; c=relaxed/simple;
	bh=0D4ZBeW2hHDtitqEqj91MoEj//vAjJvVBf06g/Chc4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0BvzCQ05UKM86fYuDhKvpf6iifDUZrGEpar0mKO94s7PYlF7OfsYFMNAA3tICC86w6Y75V8TwB677ANQsqXwlFbST8ArrHcGdthRk76YR0rKGxPFOn+5Qmsp3MUONfeXwECQyNbSYgI8EEOkj9/xDqxDZvUYRO7EW8+FC+RqZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVngEs9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVngEs9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E92C4CECF;
	Mon, 16 Sep 2024 22:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726526990;
	bh=0D4ZBeW2hHDtitqEqj91MoEj//vAjJvVBf06g/Chc4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVngEs9mjRSKnKxtAVgyhhxICPhb5CAkw2hWHpwKNmdU8bVj8bK9Jcu20lJ+MItuG
	 VuxTcl4p3wiFpCijxYql2y4+zq+QFXieYxVYUHDhxsrknoLekqQN7Pf4PYO8+7enQP
	 dcAXEECTj01n6fzSGWm0bRWbzBUQ2SwDYrTdMdWjDTuHytyD6Rl30KO6RCzcFns2lf
	 eFtrgfI3Q5G6jBps5ObVKYA1gZyRLFoelq+mv5akYi6NoK5RaPd6I7bzktqocIQCh4
	 jESMZu9xwAcz1eZLnFJLT7EV8z/uW2I6h7Dta5MY+u5JjAuDNK02ENPhSum/m/t9bD
	 vOR4J0iF/LVJg==
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
Subject: [PATCH 06/19] scsi: qedi: Use kthread_create_on_cpu()
Date: Tue, 17 Sep 2024 00:49:10 +0200
Message-ID: <20240916224925.20540-7-frederic@kernel.org>
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
2.46.0

