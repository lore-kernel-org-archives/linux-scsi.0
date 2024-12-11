Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067D61D95AA;
	Wed, 11 Dec 2024 15:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733931648; cv=none; b=DJxEAU60aYJB4scYkgeYPDt3IGReu3H2luSntA8dBjk3Nd7YoW5n8UqjXd+pX7dn9CZuLfOBPmLi6o+uyT9zZhDxFVC1JJTUBi7wVZlPL0cRoPNoa0g9VwJmHYp2RVSvfUlgTRkIIOyhJUi3KmV+wJXJFFzJ+Bh96zRMTOINOu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733931648; c=relaxed/simple;
	bh=4yWGGyiLUE5LgminEo1+3BKAknZRJAj6SQQ4Ov4Yt6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqMHX/QzgTzkz3u+6GSV48zP8nZK2pmCTWFz+YspN5YbvGvw4MwRcjWiagQtMBIAQe+/eCYb/57bMtniFmg7c3jqW3grVOFTwZwkI/0GuTYQ7AId/H2P1sB9TSJidJBPsJ+oqGJyKvfUn8jJ/6LbkmGGBYw9pP4PkEU3ThEfbxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErlILAdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErlILAdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401E1C4CED7;
	Wed, 11 Dec 2024 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733931647;
	bh=4yWGGyiLUE5LgminEo1+3BKAknZRJAj6SQQ4Ov4Yt6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErlILAdHdpKzRQEWd1brQRJ0ArES15hRgOLSBAthzpCpR/dr4hHoiXQ1U8BhJTpEr
	 eAB6Cria3MJZLZ026mdIRWy7XVx1vqtF6ExJd94umA9gcYcrlMs1VZDHVE/hva4qva
	 g89h5+mWb6SwpKgViZ/OHSJpE/XN6uJqnus0xkmmqrxQ2m72+miHEX9K0hXuzZOwAE
	 5neAr43OweoWOuw237wleqzU/MPMbVAg4Atth9fEk8u30LjDbZJ+hJmt9wgUgwhOyE
	 930Rodl7bzTfi+7tsBJrf4hywH90kWA9WrnAxLtKJQR3ItBgehSu8JuOW/YdHZzFrB
	 bHkm35ZDx3Ung==
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
Subject: [PATCH 03/19] scsi: bnx2fc: Use kthread_create_on_cpu()
Date: Wed, 11 Dec 2024 16:40:16 +0100
Message-ID: <20241211154035.75565-4-frederic@kernel.org>
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

