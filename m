Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BDE1FEFD1;
	Tue, 12 Nov 2024 14:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731421385; cv=none; b=Ksjlf/C3dbsBiEmMslr/a+T30yRHqH9uuSkuSUzb2Q4/fDIeIRbi/b0nLSVsZ3OW7m6NObZbcxt1033Fj445XhA6oA0+W0W/svyqFWuUgOn3OuHJbhW+di1A4MrxLNBxO5cYY4mmMvaM6/T8npxVbJs4UIUcxBO4rn5nmVsWO7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731421385; c=relaxed/simple;
	bh=4yWGGyiLUE5LgminEo1+3BKAknZRJAj6SQQ4Ov4Yt6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZOd+fN0A0zvMu5Xsl84kF7M2VyVYFwTUZbHsJOKSeR5ba3jbekmkVC98PdjMi8VXwSefp4Jt8myMsjH10GIHUEFJOjCy+sDhHGq6xcmNv4O3//f8l2+OMxpho+0DOx5ijwNBM7wI5YuhBS51k7cR3bdcswiCMpkLSk70iD6YII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tSRqfcJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tSRqfcJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2D5C4CED0;
	Tue, 12 Nov 2024 14:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731421385;
	bh=4yWGGyiLUE5LgminEo1+3BKAknZRJAj6SQQ4Ov4Yt6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSRqfcJfQPZnZELNwqlQA8czD2MCnkJ4WzSjBRCL6Nr71SLYem13aKP62AcWkPJcK
	 325LwsL+VEqq09QNFvomoMmaXyfZ6sHPBtegz4wV/3KnVHQ8QcslvG1o3N+ofzExvQ
	 LGT/v3MejRdM+h/iq7A1/WenNM78ZF/oZjt8PBnRnyUuES2fLF3I+sYft6bSpilvDr
	 if0gyHdohNTO3Pgjk6MLk96m2fnO+Nz+DSk+BAb9FrTZb0gLM0/DNVHdDr7MZ5000G
	 Uv/fwYF0scNbjZqmARmTbhM6+ktVgIphgtX9KOyqwkf2gOGAwYcvDPUpXdDuxQSlbi
	 /eRe80f3XN5gQ==
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
Subject: [PATCH 04/21] scsi: bnx2fc: Use kthread_create_on_cpu()
Date: Tue, 12 Nov 2024 15:22:28 +0100
Message-ID: <20241112142248.20503-5-frederic@kernel.org>
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

However it looks like bnx2fc_percpu_io_thread() kthread could be
replaced by the use of a high prio workqueue instead.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index f49783b89d04..36126030e76d 100644
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
2.46.0

