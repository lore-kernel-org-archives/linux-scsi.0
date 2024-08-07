Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA2313D52E;
	Wed,  7 Aug 2024 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723046575; cv=none; b=c3T8uCLBH/2Sr2TY5eRNPqjgQH7Nmv79qQUDxsYG3ia6Gd5aSIrqNfTmLx2aWDgyAnmxzUR1k2Va3rHm1KlCgLImsy4VmnRMjlo8c7BSASCvBPxcx7Z5BLUHBtwuHDw+Yh+d37ZQRwPVEYB+RICzqgNEi+MvRIaIQhgoxSZoA0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723046575; c=relaxed/simple;
	bh=/RulNbNlovlYsV+8HlxUGhpAD5m4gMOyHvdHkAFhJrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dhe5b3bt+ZeAie29X7hh/F1JinosGwoQ+JjprNlA3Ja69TDDgZJB79XLFf69tjymc1LLQQeVbqaYeyjUBDyPSTZijPT5Hm2RyOxKI9k4W51wXth0ol5n34HBOtOv9CRb12fLmN1Cjjrf32hp43eb41DmomU0LX7Ho/9gwIDiTas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udOSGmpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udOSGmpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17D2C4AF11;
	Wed,  7 Aug 2024 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723046575;
	bh=/RulNbNlovlYsV+8HlxUGhpAD5m4gMOyHvdHkAFhJrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udOSGmpVFsGUjjlO1rHBFJmZQbB2Ns5BC3uFeXamGZnpfREWIKDVOaAXggbxXLjtq
	 4HfmD13zh34K2Y5i58PlSWh0j0TWdB5bQSNpyEDw9CllSoanSym2g4vXmLDt6IOgna
	 1knt5aA87TiUuuSUs3xTB6Zk8JTJIetrdHQzMRcnFKfOdAy3c6hB1YWC4prP7yFLZ1
	 EigI88WKqUdj4TL4Wwff0e0jWqWifYKnC0MdR8ZV0CLcLRN+D1vp3WZeXLvE2jwWDi
	 35c5AYWqqdIsgVE2l1oqtKWsMUxQZpdLuTueyCn49tCF90GRKC2WTbleBmLUSwm1eR
	 safmGXwUiFfqw==
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
Date: Wed,  7 Aug 2024 18:02:12 +0200
Message-ID: <20240807160228.26206-7-frederic@kernel.org>
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

