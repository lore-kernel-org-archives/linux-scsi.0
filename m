Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A4816A949;
	Mon, 16 Sep 2024 22:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726526985; cv=none; b=k/cTj8cLcjoAYrr6+GohIP7HrBjM0a9AaeTEfDT5b0l1XOfWd1UWlW8lOWVNNG3titPW/7Q4cYwTCcqIZrwhQ3hwPB3vvx+nmfFpqSoIJhSrjDasgPXLMX90RFuq+GEytAIMTnJIzTSI95NYpXDqI26jRUrlWtV5qdv5mjr0SuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726526985; c=relaxed/simple;
	bh=cdyOFZ56rRxPsoxfyH8Hg6jYWPKMlf0Eg+/EbRKiEBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NszvkMcyC6mGpe+jCSOolX/r1tgL0yxXeYNmXadXL78HfMSciJM4jafM2G+lbr484VZv4KD3wKJJno9jO99s4L7pC1pc1iJ44Vp+19CasJ9m+ovc/PeeA9EeSTWJaXT5Iop4UblE0DNXqYKgTPJjhvrkecNWuzupzLhh4PwMLvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhbkAqjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhbkAqjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE7FC4CECD;
	Mon, 16 Sep 2024 22:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726526984;
	bh=cdyOFZ56rRxPsoxfyH8Hg6jYWPKMlf0Eg+/EbRKiEBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhbkAqjUCBfYUyFOBkoUh/V1dg7EhwkBohNbuqnZxRC04cARGGh+oA+I97cuaxJBd
	 pUt/n3YlqvIQouasX0w1k8sPdVAp8uNwAnFzR+apwXU0Jv5GTmsn8rfq7Hl6PU8nQk
	 cjUaPEm5AOTJpojnHFmdi04cyw/K6z8YsOutDxVVAmO9erNlQO2SfZLY2d1LMAa0bk
	 OpAiE70Mj0njik3Oqc3LKSU9dH3Ig/uovJNaJeP9+l92PJycuyQv0EG9NqOxiDFZOs
	 EKyFHoaOVu3nOuIcfGdiBw3586YG3Oa5iHrm4aKYXRgaql9+5aFlyCVw2SvNDmxdwG
	 O0/VSFL3hxXTQ==
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
Date: Tue, 17 Sep 2024 00:49:08 +0200
Message-ID: <20240916224925.20540-5-frederic@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916224925.20540-1-frederic@kernel.org>
References: <20240916224925.20540-1-frederic@kernel.org>
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
2.46.0

