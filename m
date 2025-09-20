Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30F941B87C0;
	Sat, 20 Sep 2025 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.150.39.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758375768; cv=none; b=FlDDAG3VKs2x87pS05134tvTXvxfwcwJu2ZCv0DUaZRlo8aGyoK0db44DQdYFkySK7+b9r0NlIBI4l+7fLSeNEHePAxrj38YUdYWooLt1ZxrS7l5jdcpMtQni86I8HPiOFvdwWAHqUI7WCi2jmikJ28iQeKdCh3f1x6KS2Ufe0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758375768; c=relaxed/simple;
	bh=bxGLZ1KtmnTKgV48yxkrqLP1/cvNjp0TCVABJhWKa/0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NJXcyu28l7gyJlG7ju6FoxBYM9dqogRsRpNxcD31NU3Z8Q2G2Dc4cTl4Nlb3V2VZgwLbwcdMpgDS/e9GOt0jCY7uncT5MbcXl9+KvgczB5CnuppT63Ye2O/FAjuGFwbtsd3ZDV5w6ivVZzY2CFdhvjfePQdVf45p43k7FqlAU94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=129.150.39.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [218.12.20.76])
	by mtasvr (Coremail) with SMTP id _____wBnt7Axr85oZmxVAg--.716S3;
	Sat, 20 Sep 2025 21:42:11 +0800 (CST)
Received: from ubuntu.localdomain (unknown [218.12.20.76])
	by mail-app1 (Coremail) with SMTP id yy_KCgBHmdQrr85o_AlBAg--.18751S2;
	Sat, 20 Sep 2025 21:42:08 +0800 (CST)
From: Duoming Zhou <duoming@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	christophe.jaillet@wanadoo.fr,
	mingo@kernel.org,
	tglx@linutronix.de,
	linux@treblig.org,
	fourier.thomas@gmail.com,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] scsi: mvsas: Fix use-after-free bugs in mvs_work_queue
Date: Sat, 20 Sep 2025 21:42:01 +0800
Message-Id: <20250920134201.18428-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yy_KCgBHmdQrr85o_AlBAg--.18751S2
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAwcPAWjNsfsG7QAZsX
X-CM-DELIVERINFO: =?B?33xENgXKKxbFmtjJiESix3B1w3uoVhYI+vyen2ZzBEkOnu5chDpkB+ZdGnv/zQ0PbP
	CR17JWIj2S50sroAcAzxKp+F41Z092AV/gunfW8rDv1UV0ym2ldWluBcKk0DO6PF64/Voy
	8atT3b2U5oNC2n/zoSwhR/VnrddamsHADA/v/9FKmhbX+QqPOU3b+sWb/6rE0A==
X-Coremail-Antispam: 1Uk129KBj93XoW7Zw48ur1rGrW8ZryxAw4UKFX_yoW8WFyfpF
	WfG34UG3y7JF1UKwnFgFW0gF1Yga1kA34qkw4Ig3y7GFyrJry3Jr1fGayF9a4DArWkAw1a
	vrsIv3s7uF4UK3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvvb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0Y48IcxkI7V
	AKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I
	3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxV
	WUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8I
	cVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
	AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuY
	vjxU7xwIDUUUU

During the detaching of Marvell's SAS/SATA controller, the origin
code calls cancel_delayed_work() in mvs_free() to cancel the delayed
work item mwq->work_q. However, if mwq->work_q is already running,
the cancel_delayed_work() may fail to cancel it. This can lead to
use-after-free scenarios where mvs_free() frees the mvs_info while
mvs_work_queue() is still executing and attempts to access the
already-freed mvs_info.

A typical race condition is illustrated below:

CPU 0 (remove)            | CPU 1 (delayed work callback)
mvs_pci_remove()          |
  mvs_free()              | mvs_work_queue()
    cancel_delayed_work() |
      kfree(mvi)          |
                          |   mvi-> // UAF

Replace cancel_delayed_work() with cancel_delayed_work_sync() to
ensure that the delayed work item is properly canceled and any
executing delayed work item completes before the mvs_info is
deallocated.

This bug was found by static analysis.

Fixes: 20b09c2992fe ("[SCSI] mvsas: add support for 94xx; layout change; bug fixes")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/scsi/mvsas/mv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 2c72da6b8cf0..7f1ad305eee6 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -124,7 +124,7 @@ static void mvs_free(struct mvs_info *mvi)
 	if (mvi->shost)
 		scsi_host_put(mvi->shost);
 	list_for_each_entry(mwq, &mvi->wq_list, entry)
-		cancel_delayed_work(&mwq->work_q);
+		cancel_delayed_work_sync(&mwq->work_q);
 	kfree(mvi->rsvd_tags);
 	kfree(mvi);
 }
-- 
2.34.1

