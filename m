Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFE81B1436;
	Thu, 26 Sep 2024 22:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727390972; cv=none; b=tzM1JkT7CfGlJVH4nkwGMufAPhHY24Es9TjQI3ZLqZyQyScEp/51+xUoVnpZSPjq0wWtGwMIblkamWKfJ86sGfk4TMLHhRgMauH3V+C1EYJ3wxvq+5FTS0vGILVrLJcpBiOujxHSXrT7E9wzRSF4FKN5LSENhvqi+ilGDmUvSXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727390972; c=relaxed/simple;
	bh=5gm2IlkjuHTv5aCOZyyCN0NSeTSEuIS/Liq2NVx+RNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukIn9MV3Q+WChj/73PAzqUMpReu6QpJwWWRyLs3iAKQSICXwcOE0Cdhh+16lXlEDxP3zZjdkF+LqJkf5kkW5kepSUpfKSq6AYURZUE33Lt5AlZHPms1cIyRpa+jiL0jlaijMmQ+ffY/vikUcUleRyUFLK+JTHIZ5muNgT3gsS7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsPooocQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsPooocQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4093BC4CECE;
	Thu, 26 Sep 2024 22:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727390970;
	bh=5gm2IlkjuHTv5aCOZyyCN0NSeTSEuIS/Liq2NVx+RNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsPooocQwt6AD8CjWHTD1VqXF5cvd1y5cvFsThSUgXIJCfXz9YWinQqcGbR4R+dvJ
	 2oCDFGGPInTDzYMwAV1CSWmKPKa2TVB24H73pIVQfK+nNkSYqgJSwdBKCNnImexAyv
	 Z8f4UhBLpTR4YhmCah+PiC6wmo5pfR2GrXeQoHC/X2YNgMq6wj6w1G0Rd8f5y+DOYn
	 J92vGX7gLWj27Kh0wRf6CH6oAybPa8FsvvncfoYCQ9GumuzPoC0/3eFcEo+Yuiy/4q
	 PoDjTE89r79OjbiG0O1UpdzHuUPE0zFlnIIHWlFGnZpaUmFxtyn76HkrRRQ10rktpq
	 Ak2+2K498ZSug==
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
Subject: [PATCH 06/20] scsi: qedi: Use kthread_create_on_cpu()
Date: Fri, 27 Sep 2024 00:48:54 +0200
Message-ID: <20240926224910.11106-7-frederic@kernel.org>
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

