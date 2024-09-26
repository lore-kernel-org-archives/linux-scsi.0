Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FEB1B07BF;
	Thu, 26 Sep 2024 22:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727390965; cv=none; b=LLF+1fLOdZi8paQofzIxaIWLiP/vf6IrpjDkLkYPJp4UkI/gkAN7QSMwqNfXiABYrBY24rvigLNOoczSjtb/ascr+/1CasPhVdFbnYH53CJ2N/S7f0sUV0FvZjY+r0si0vXilYS1jFTjH0hjUrLynheZCSj+f1UZgPCN51vOfYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727390965; c=relaxed/simple;
	bh=4yWGGyiLUE5LgminEo1+3BKAknZRJAj6SQQ4Ov4Yt6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lf26gn/AzLITM2H953HGO9zsxTUuUmbD0S9OYJcL2ztW2YSpVT/JgpABYoSVirMJf3YnHyeXMH8wzRVdzyWiP4gCQumfxDrTJrw6K9lFG8JPSCk/8IOyXDvy0tyEm1Dz0PtqvJv1k8AEJi0H9OlMfEIslGCYEA5UBGVvdydFAzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k564yRZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k564yRZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB30C4CED1;
	Thu, 26 Sep 2024 22:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727390965;
	bh=4yWGGyiLUE5LgminEo1+3BKAknZRJAj6SQQ4Ov4Yt6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k564yRZp8pOLJHoBbfm/GOdk2+Caaj7NNScqdhv/mPScQTthzq01ka8TAu7kEpL1n
	 Q0/UkRBBoC+BGKtg8+S4xroXlOOc5LjCUvtwXglhSiVAyHpl7QL2rnSxvk85hGrZ7+
	 yjs6fFuMhLz/oi6EdW1RqmT4Y2H5t6fyXa8Q4rae/mLsKyZMWTlIT3/lITiTin4s/b
	 gIqsiriOY21JwYw+99K2acb54RBMWSEvtuYQl6KHUiqgbVcHhmX3Ws2REz388v2Y1D
	 9JTpvXwG/AURaqzkzmaksZhL8ExMpD6roOHA8c4CUn7+FJtI5DVQji79/NN2ctqZkt
	 Q4uRPdzMxV82A==
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
Date: Fri, 27 Sep 2024 00:48:52 +0200
Message-ID: <20240926224910.11106-5-frederic@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240926224910.11106-1-frederic@kernel.org>
References: <20240926224910.11106-1-frederic@kernel.org>
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

