Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B034513D510;
	Fri, 23 Aug 2024 07:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724399972; cv=none; b=b3oQaOUAhhIA5JAVT0E/ISNpmCZAhjQxLs1ft1478IQurIpicyY++FaN8+MDH2pXMnBE3MzJFPe3gQrB0/RYMZkDROKfHDhxgg3Y1im283iY/H1odG7bQMU6883t0QMg5Z2/7WsA9mEzFYQSKHI7MvxXH+rca9O2mblXwPbENgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724399972; c=relaxed/simple;
	bh=ur5OC6e9YciVzUXmIhvFwdnkc0lkUjK01z5Kmf8YGC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J/sxrOMmX/GOgsP2XExf/cjHFMEpNPNswyTuWT3jfIv7fEalJUDPLw+qpK+wHFOguZJEDtMqfXR+wxSk/dI/0XpeieC6u8eDKyplqkOButROC38RDgfQzNd1zNSuPFkuCemTPR2BD98YRL5Sde3gnTq05wz8/6ye2bKHeJmoqzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=apGQ90Nd; arc=none smtp.client-ip=80.12.242.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="apGQ90Nd"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id hPCOsz6rViKc3hPCPsfnwS; Fri, 23 Aug 2024 09:59:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1724399967;
	bh=188CPv4FKDd4oUDmt62qF9vuy73ewf5lgadUwmEi0x8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=apGQ90NdGyBvtEPs1p8Kti8oACBRKMQPiQU7pWwut3EsAhMz2czVHY/x3pMH6nquK
	 QFK7OqVgXCsN1VMbfrh3HjR+DEtoSmeLvv2/r05aDMT0DVgbANkr3Ew0xJaijkQjrr
	 KAhb1kmi+aY4bGACGNtwboe4tHD2HEHwGT7xOXsx09aRjCpanasSmfj1MILuIGHdhE
	 ea31Gor4LOeFf6xAie45rT0syVEQ9cuT2apv40BuL3FxpXd4b3JF1foTTYgkO/OtnX
	 +1De3Qk4kBCEccjlX9/iylEc77JR0jtf7OUmBf/qDXxsZAYyxj9X0Jr5F2SRIEqBKo
	 hmVv5KnR/X5cQ==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 23 Aug 2024 09:59:27 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: bnx2fc: Remove some unused fields in struct bnx2fc_rport
Date: Fri, 23 Aug 2024 09:59:05 +0200
Message-ID: <42e20b159f3bbb12da7796463a521ca051bd5274.1724399924.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some fields are unused in struct bnx2fc_rport.
Remove them in order to save 96 bytes on a x86_64.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 drivers/scsi/bnx2fc/bnx2fc.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 7e74f77da14f..6d47a4d8eed6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -358,18 +358,12 @@ struct bnx2fc_rport {
 	dma_addr_t lcq_dma;
 	u32 lcq_mem_size;
 
-	void *ofld_req[4];
-	dma_addr_t ofld_req_dma[4];
-	void *enbl_req;
-	dma_addr_t enbl_req_dma;
-
 	spinlock_t tgt_lock;
 	spinlock_t cq_lock;
 	atomic_t num_active_ios;
 	u32 flush_in_prog;
 	unsigned long timestamp;
 	unsigned long retry_delay_timestamp;
-	struct list_head free_task_list;
 	struct bnx2fc_cmd *pending_queue[BNX2FC_SQ_WQES_MAX+1];
 	struct list_head active_cmd_queue;
 	struct list_head els_queue;
-- 
2.46.0

