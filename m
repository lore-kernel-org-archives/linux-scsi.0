Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1761552FE;
	Fri, 26 Jul 2024 21:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722031036; cv=none; b=SvvZw7MpVIbFzwvKJNJ0wXvpLfASCUF5IooceT0v5GM07SyL8PDOJ8FL1j5XPfX6rERebrP57k3C17EqdC161mvmzftgkyLcdXg78QV/HNBLmZO4KLP55aDtUJIAe04vYpHFO3bJpbIXPibqHvPtfpbNNbu/H59P7Fjc4aXslaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722031036; c=relaxed/simple;
	bh=yDztet0jee00Ipe/s5EJY6qHQwJ1DkD7Qxns7aI/l+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R64IdnEbrcVoe8+wOrm7FBg+ibrM1Hc7rmKtCbHUbODnQiuZRFGhf9rJVr4Akhatg0A33/WKhUnA1aEKviOxZpg6rp2kzLlLwtkv8z5mc5rd+omPIFL8DiOb/tw0e0rFybjY1AvvFHQek7exPuIM38NN6FrcLyH/hq7sUsz/zkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GavtaFA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GavtaFA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FD5C4AF0A;
	Fri, 26 Jul 2024 21:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722031035;
	bh=yDztet0jee00Ipe/s5EJY6qHQwJ1DkD7Qxns7aI/l+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GavtaFA8yIc1xKeXM/ayPWrKoyOXfjnnpLhLizLKSSnJp99gaIWXaoSesmUSvWDrK
	 DDpFz5O3ow0e/AnZoycPeTzQ3R6o44T9efOT5wURIBIsTg4K3HdXZHss2kdBg8zpV0
	 QbczJLW7AmY8wHFIBo3P316kXQergQRc9HXiYj+oyTFHfLjVI4RIiz4WA/cJc9yubr
	 /92aqFaqkVOrNlXgf2HSCmVkzuSCdcg4MLK8u9D8SrSvt8Hta0BtGXUvb/PjrIMRDW
	 YOWr/Xef2AbSP7ijf4u4BBsbfPzZ9FKXKQcOu6SxUoxR/YNokmQskii+hubSgi3gRA
	 OtP3dZKEdiOhg==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/20] scsi: bnx2fc: Use kthread_create_on_cpu()
Date: Fri, 26 Jul 2024 23:56:40 +0200
Message-ID: <20240726215701.19459-5-frederic@kernel.org>
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

However it looks like bnx2fc_percpu_io_thread() kthread could be
replaced by the use of a high prio workqueue instead.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 1078c20c5ef6..789c155b939d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2610,14 +2610,11 @@ static int bnx2fc_cpu_online(unsigned int cpu)
 
 	p = &per_cpu(bnx2fc_percpu, cpu);
 
-	thread = kthread_create_on_node(bnx2fc_percpu_io_thread,
-					(void *)p, cpu_to_node(cpu),
-					"bnx2fc_thread/%d", cpu);
+	thread = kthread_create_on_cpu(bnx2fc_percpu_io_thread,
+				       (void *)p, cpu, "bnx2fc_thread/%d");
 	if (IS_ERR(thread))
 		return PTR_ERR(thread);
 
-	/* bind thread to the cpu */
-	kthread_bind(thread, cpu);
 	p->iothread = thread;
 	wake_up_process(thread);
 	return 0;
-- 
2.45.2

