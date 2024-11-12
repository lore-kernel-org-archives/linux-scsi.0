Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3DB1FF610;
	Tue, 12 Nov 2024 14:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731421391; cv=none; b=WuFH7QJ411iEeufH8QrUTJSVERSHKj6TM1Ml38k99wEBHiqGaiZdYCM1d9bX3xOw2I6/NZhBcGzncmYoTgT4XA7CIoSq59bBAWV3/gcnIMbH258OuItE0U5qde9v/3mqyxnjfk2YrneIxTH6veS7d0j3ZQCLQltwFXwGILnWer8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731421391; c=relaxed/simple;
	bh=5gm2IlkjuHTv5aCOZyyCN0NSeTSEuIS/Liq2NVx+RNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB44AqYF2YogGnOX5cfmO6N7OIO9Gg6j92Su6ess6C88fc7IKmADaomqc6OL6vjTJo8Xsi8fANXo8KGGXCPO5+jo7ZQuYeBU9UCUqaARNztELK6GjteI73f6PY0Eqk/XyLkeOzxLRH5UTzIvSPYRm/yGSbEuiZYRoHBoIYl3QyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVTJHWe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVTJHWe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A13C4CED9;
	Tue, 12 Nov 2024 14:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731421390;
	bh=5gm2IlkjuHTv5aCOZyyCN0NSeTSEuIS/Liq2NVx+RNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVTJHWe2xpVxcww+Rkvo5Sr/kLbpCw0OIWy5DD1AkchKxN2ZCHg9P/HkJudwJltzA
	 qthwMBk/7QCpv3aOHHusF5OxxYvGGV42grlPAwSdQnvjj9BUKZ0qqo0lhp/a39Sxt3
	 LbZENNqdZlJaieA3JODGggbSQMkg9i641JZSF6T8avrTUvo3BEgVvgnAvekUx5kxbX
	 jupZkDK9XO860TZfZxAGv41eO0aOuynFAr0xTPExCQH51WceSmyChA1k6W3gSebnso
	 9zBRi5JdcV0eliw4+r/ZMlC07xB88qDGvo8cpFd+Gbf2R7bY+7raVhuEIUvXJwZ/yO
	 4EczqggBpj/+A==
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
Subject: [PATCH 06/21] scsi: qedi: Use kthread_create_on_cpu()
Date: Tue, 12 Nov 2024 15:22:30 +0100
Message-ID: <20241112142248.20503-7-frederic@kernel.org>
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

However it looks like qedi_percpu_io_thread() kthread could be
replaced by the use of a high prio workqueue instead.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index c5aec26019d6..4b2a9cd811c4 100644
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

