Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A6E13BC35;
	Wed,  7 Aug 2024 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723046569; cv=none; b=TwWhGvtyyjkjIdaWmD9pU9q2zoT0AO9Sp3XhCQe7yUQvz+6tmy9CN0CNf38v/7xyJsbrMLlmRquBnnqoKlnwEdFXTYfNfInHnQCeLFXVUyL8Mdp/XHG99TUijf0DOs/srP0H3+t+E4ax7PFPkFvvm/HXuf1JBBCqTfGlsa/FdP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723046569; c=relaxed/simple;
	bh=yDztet0jee00Ipe/s5EJY6qHQwJ1DkD7Qxns7aI/l+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIJ8aTSxcE8ZPQi79Qc76yFgjjmXdSse42TchBZyCBiYHHeYabXOChGLSXlBL44digjChO4CKwp1iJ4euxXsumZ7uPBCooS+XPDtkmYq6UYnCVJlI2BVWNNmLh/WLVbQP9auZ/PY9Um7+gyadFWCGsWbYE/x8NRZprBiq99HgdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cd6iFxOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cd6iFxOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F43C4AF0B;
	Wed,  7 Aug 2024 16:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723046569;
	bh=yDztet0jee00Ipe/s5EJY6qHQwJ1DkD7Qxns7aI/l+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cd6iFxOGe0WX19SM/pZgOZqNZpQv32dDPiTYVXKQd8xy4xKCx7Pqv3OPg5sFPiCkR
	 8E59h9DHm7eAsGkKDy/+pOjinzlxp/Z53mFX6wsIpPpbLzzcLhQFbU725gcUuPbh9x
	 uPCWzZ1vVXA0bIHrQBnqIVwvasXWF7evCKUy+DRTIKN1IAtD/PZ0RTKdx9jUp0Z4JB
	 Q+ICJVGWoYJ47azH4uvK/ypRNRDzbpUjyRdGPh0xXOvxnuZc00w/THBVgtzbVtw2Q/
	 NqkoC6xvF2XRpspSQnIMcwg5T1iHg/4yu6tjUSYZ0x7OGgp22AJWoaMMDcPvmXaKUg
	 TMx33YT6KTkTA==
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
Subject: [PATCH 04/19] scsi: bnx2fc: Use kthread_create_on_cpu()
Date: Wed,  7 Aug 2024 18:02:10 +0200
Message-ID: <20240807160228.26206-5-frederic@kernel.org>
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

