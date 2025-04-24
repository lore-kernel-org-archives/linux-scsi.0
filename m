Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E33CC4C98;
	Thu, 24 Apr 2025 03:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745463785; cv=none; b=ixlT7EbXVMw9jMACKmEb88gMB+RSQYUo11Aqns0GEZsoDIDtYS1WOOTq8H4u942KgjXpQ3vdAAUDUnUIsOIctV54Lu1+Q4ay2k+oBQq18AFNrApVDn7/DjJXAOmn7ZnajitnS6ejnTAI7AplE/5uwxBeRldJ4z7mhmnSfAvD+ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745463785; c=relaxed/simple;
	bh=Z0YXNe5rYgbPmG6bYossjR8CM6xq6SISqBgme+bhLpk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q8U8JRdmdx80tSb0djXLS4T2SvSz1cPnAH3GBjyqDviD7Etpq/4sE17ec6CDBfdkcsmSJE6wnM0Oy5/NPkDr2NmB2ivrqLsmJaXn4QUcBbhZtY7hImcNd68159declFk3P1Rs28qJ4C1MaExuKH1FhTaS2H+5COwDtc9RBFPCIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mnPJsIdZ; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mnPJsIdZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=0toDk
	9V+xP9lByzkIIQY0wA0XRMFcZypT43CrVAOWjY=; b=mnPJsIdZ8x+0dQx/pEKsg
	m9YiYKoRtigeXGFv7IVo6YebVM422S6G3HGBaY3SpMqyfN1gJsLLQfruLMhYh6ZB
	f2UaLnT1fw80xafa6xY0zT+dF2ZeBsT3vOO3FTDJNR5PV0FfHkFi4gRRhKpGn7F5
	MK3oEiKg7n+ViBZ3tzYKOo=
Received: from icess-ProLiant-DL380-Gen10.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDHCjPHqQlogffCBw--.173S4;
	Thu, 24 Apr 2025 11:02:33 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: linuxdrivers@attotech.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	stable@vger.kernel.org
Subject: [PATCH RESEND] scsi: esas2r: Add check for alloc_ordered_workqueue()
Date: Thu, 24 Apr 2025 11:02:27 +0800
Message-Id: <20250424030227.3505997-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHCjPHqQlogffCBw--.173S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr18GF13Gw1fJr1xCFyUWrg_yoWkJrX_ur
	ZFqr12yrsrCF48K348tFyaqrZYvr48Zw4ruF4Yqas3A3yxWr1YqrsxZrnxZwsrC345urWD
	Aws0qry8Zr17ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRX_-PUUUUUU==
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbBkAg5bmgJqXcO1AAAsq

Add check for the return value of alloc_ordered_workqueue()
in esas2r_init_adapter() to catch potential exception.

Fixes: 4cb1b41a5ee4 ("scsi: esas2r: Simplify an alloc_ordered_workqueue() invocation")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 04a07fe57be2..9c0225a1f208 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -313,6 +313,11 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 	esas2r_fw_event_off(a);
 	a->fw_event_q =
 		alloc_ordered_workqueue("esas2r/%d", WQ_MEM_RECLAIM, a->index);
+	if (!a->fw_event_q) {
+		esas2r_log(ESAS2R_LOG_CRIT, "failed to create work queue\n");
+		esas2r_kill_adapter(index);
+		return 0;
+	}
 
 	init_waitqueue_head(&a->buffered_ioctl_waiter);
 	init_waitqueue_head(&a->nvram_waiter);
-- 
2.25.1

