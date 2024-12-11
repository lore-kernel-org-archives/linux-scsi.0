Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB4F1DC999;
	Wed, 11 Dec 2024 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733931654; cv=none; b=UlcqMBRC6e3fypEmCOVJTZB6kRD9Qg43f0gS3AaKNNJG9uM6DXvhM/lW7I0RF/G7chbUWskXVLINJ7XBi9TiZB6vxTE97P036UBo1+d5sJeEw1W3acpgvOl7ebn9DMN/A/9c+e3i559Qn0ueIzfIlrcb+knamXHHekXhd1qjM5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733931654; c=relaxed/simple;
	bh=8evu9K6E5GzQx4Ei0JNqaBXa1Egs/UTLupfziVAOhhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTCC9vai6fK9ZV0P2J9lZmOV+7kQo6C1eBr55acxNiL9NoITJi7HsQx8YkGR1VOO7ZxKrrgbkK5wn8/Kb8ax1MuawyRMZpbL/A+jgknWnbxsW8IwPHEgTogH1tFvpHUmHD4VmW1vWsdhSEZcSNTc1AXsFrhFPolARaPU/daS/Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6ntzut6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6ntzut6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D29C4CED4;
	Wed, 11 Dec 2024 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733931653;
	bh=8evu9K6E5GzQx4Ei0JNqaBXa1Egs/UTLupfziVAOhhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6ntzut6wKAb9D/XcIGpxhpsKDJzAv/j3KZV7TRqVGndMQjodIhRFnHQERA+IENmZ
	 hjVJhkPax9/SXwdtxtOLfqRkm7WnVw2Bmx+KZNYKd4rf6i+ZIcT1ZI/jVCuHN9+dBk
	 twwDt7m+ugypNlkEREUt0AWI4+dad48ETFZDxAFQRQ/7NCVf0shpRU01PiaO7V3iZx
	 7DN+aZsQNj5XIPkQVOqlRvld+dMcIJ8M1hIGUnrmI4tZ7YhVH77SPUoUuSwHe/qpTu
	 9Ax+DfTVGI0I1TxMlCYLTwCDgdkR38P6O9JtwxqryUhLK+uue61bP00J3a0PHKeGlF
	 CdfoUrYw9xV1g==
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
Subject: [PATCH 05/19] scsi: qedi: Use kthread_create_on_cpu()
Date: Wed, 11 Dec 2024 16:40:18 +0100
Message-ID: <20241211154035.75565-6-frederic@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241211154035.75565-1-frederic@kernel.org>
References: <20241211154035.75565-1-frederic@kernel.org>
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
index 628d59dda20c..f2bb49019617 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1961,13 +1961,11 @@ static int qedi_cpu_online(unsigned int cpu)
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

