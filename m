Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B3E1DA11B;
	Wed, 11 Dec 2024 15:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733931650; cv=none; b=HYnspQdyi5yt9wumudZvtK1lmyzc8ZORGvD83H6A1JR88ZXsDOffdpKI4QItQE2kdwP9vFm/+rMqlWBDM4wOGk7A6Ddyp2wMXiC/+Lqgje6nKn/svBZGDSlEDkXHW0pj77HQx0fpwQdWkai3GB5qopptl9YyKCyV05VhWa3DK+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733931650; c=relaxed/simple;
	bh=LFXpL5/nrAXstPiOj0IbxTit69TGzKOpoS47R1I/bUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elQ0ZOS8lRD7ht9xXnA5u1ci0O/Pom0YvsPSJ2XJXRQX6WBS/D7BuohnIBVEBtl/M6rziisANeegahlElan1oLQZRrdKbV0SmKZBQriubM89rpNWO78ZjlYzkKFswaVCZ0b9eIq7km298a8T1nnBzWkXEWfhHUrv87MxlrkRJhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qKHzLkEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qKHzLkEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB2DC4CED2;
	Wed, 11 Dec 2024 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733931650;
	bh=LFXpL5/nrAXstPiOj0IbxTit69TGzKOpoS47R1I/bUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKHzLkEMhcHRIY0LX3GaPTQ+jtULnXufBTi5yhd8x3Ud6Wn0SEvkKR2V4GimohDbc
	 SBcYYpUeD6mrHQnV3PB1bQKWsLQSe7qWwSleuPq9SKTCifyD3X3lB+9dAGj0qWm4Kn
	 tlt4QD6C/UGxXgBLIE/OzFRbX7kllC3iZ5f1OtqgINURKVqKFQ5XXOTJrgb5DVjShq
	 fEsVwxSKdAkRWdd5c5x6gjvIATxzC1zAs1H0al9cYiWZPtD+9uEwSEYK5rsgTnvxHO
	 EWnyKYCBw61iizPXT7xFTwbtHNAm9xf6gWG+hr9Vwg8skujpu6w74StjWlFtwrOdKX
	 FPzpf+7VHJKVg==
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
Subject: [PATCH 04/19] scsi: bnx2i: Use kthread_create_on_cpu()
Date: Wed, 11 Dec 2024 16:40:17 +0100
Message-ID: <20241211154035.75565-5-frederic@kernel.org>
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

