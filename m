Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917FE1FF5F3;
	Tue, 12 Nov 2024 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731421388; cv=none; b=D9QW6CIxKmk0xblfvPaQzo72RH55iD8fGTdpG8FYdUKTBZPCerV3f1EpM5IOPSpFyl+5SkIMwGg/jB29uvhkl0iuFz0wET8sQuK/VQBVty0hpU+j+ZxoZijMpuV6l25+JZgf8AlwKpfo5iXqFRpijs3xlFhOHPWG/lllZu8qxaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731421388; c=relaxed/simple;
	bh=LFXpL5/nrAXstPiOj0IbxTit69TGzKOpoS47R1I/bUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQ9n00UokcR/GfcHz51waoMOrIWQkhnfn2gucJo2f5apy8tA0GqNDCYMAhDiixeQ078LIx/Imfe1VAz/mcezDWej3e0k4yD0RQ3VxltY1wPamlYOjO2r/xuGQ2wn0lItscUcV5p1hqiQEQp/40CfQHLLsUTOO4XNzjvxOvuZ9yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWeFbVtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWeFbVtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0229C4CED0;
	Tue, 12 Nov 2024 14:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731421388;
	bh=LFXpL5/nrAXstPiOj0IbxTit69TGzKOpoS47R1I/bUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWeFbVtRpVrrinGrTd1jzAL2j4kNcQABzPxJZxhzZ+GTXNND7O3Y/ZO7NeDOmsvVe
	 MvkMbhqILaysbgRcZrXBh/IR9TR9MY+X9a0xnfh0Y1iwzJwckKgR2fRULKkXiFFko7
	 meZ5wyV5Hb+gPjFNS/QJwlI8YD46N6BvqO03esOi3qHXYURgHc/v2YhstQTyN2z6Fz
	 tuGFzK/af7GyBV+Ghaw+415yxEABuzVB/tgNG3xSKUq0pgGlvh8aU+iuKUUvOZrQMD
	 BCwY2rMIdT9Sg10WpU+Rnyt7wMa9NYeclu/jMyW2vc5WAqsu7iaal+6uPg5yXFUpqA
	 ilY/DsP4It78A==
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
Subject: [PATCH 05/21] scsi: bnx2i: Use kthread_create_on_cpu()
Date: Tue, 12 Nov 2024 15:22:29 +0100
Message-ID: <20241112142248.20503-6-frederic@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241112142248.20503-1-frederic@kernel.org>
References: <20241112142248.20503-1-frederic@kernel.org>
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

