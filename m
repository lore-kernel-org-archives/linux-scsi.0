Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DC9155385;
	Fri, 26 Jul 2024 21:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722031039; cv=none; b=KrSnKfE1d36moAKugXggswOCaTImNhFepmPNauSwXwdWbCyulSiOtkJD1ABgFVoPoCh01s92+qhc8tPq2tbi94I0rppBj86McOute5E74PACog1f51nB61Ny5EEqXytBKsSiGeue14dT5zYWXyGVK7T+KuU3HRCkMTPiMeZw/Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722031039; c=relaxed/simple;
	bh=OdAmLrtcC1w3Cxa06wD8vbSjhHVtYldnsGlOoNisnoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gu1QHPHLq8Gr6ov41hX6Tdw/VsQ7oImDnB3FP1kU56SSipfcVuhuI8lalvqUGhvAYxqBKtZl/xNstn1S95hIxAHrz4Pd9pGfO9f+w32NNzHdji4djSCcC56faeScdcaNqG/GfXHucV0FDTmKDxZo4+AaYpYF+8KyhJHBJ1i5wQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBpAWcdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBpAWcdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3181BC4AF09;
	Fri, 26 Jul 2024 21:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722031038;
	bh=OdAmLrtcC1w3Cxa06wD8vbSjhHVtYldnsGlOoNisnoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBpAWcdPUAbdar3RhuqK72OujDWsU1hnIBOH7SkrnuNMROENbGJxtz156klFJVppZ
	 ylojY+psSgnSbanDF9YGu67qObcLJGP1SHyRc16qeqE0A0FgEEyPtff/lVAdZt/L7A
	 kSSIW0VbkL+RGzO+wWXv1Y98jmapJvAPpLSnsIypd+e2v4A/M7Atmd+nK8trttEtXc
	 czEnAamfVdDOYMHDMvg7t3qHMh8iW9Q9xOju8VECluNTM4fm7MJJLQbv0ESiqgLxPC
	 Yr0u8eubBrUC9trSr87J5GDs7EBWtREJoF6R35028taf5ITM+Sg1/CLfGgX/UcKBw3
	 AhuY7JQSiBXXQ==
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
Date: Fri, 26 Jul 2024 23:56:41 +0200
Message-ID: <20240726215701.19459-6-frederic@kernel.org>
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

