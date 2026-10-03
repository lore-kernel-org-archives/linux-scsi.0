Received: from fraori-sdnproxy-3.icoremail.net (fraori-sdnproxy-3.icoremail.net [132.226.202.154])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B141A48C8AE;
	Sat,  3 Oct 2026 16:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=132.226.202.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045483; cv=none; b=kbvdixh2sTKaTWUjiBl2rMAadcv+42viSgeuwuWqqNxs9NR198uwk9ER8BSRJhyP7vtaXgfap6gG+Dxr6sWEy8htAtHE3w6N9GGuC+R9WIIlxVOxmicxdvpJcttQqCUECPvuiEDuqUt+2GjoJXYAJOdFAmghq5tFiXvTOFmmOVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045483; c=relaxed/simple;
	bh=h1muT0Oof54z4gNYKese5yy/Bn31JeDCsEvrXb6mZf8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gg/Wh7efn9NaWBFJWEvmEGIIOA8KdShgcZQt7OY8L5MMEaHK490czn4nk6Tct3EFLyovT7YuaLZkE46GQDayxnKC16Sav1euaFUexgHrBI4lh16938+oP7U3UGJpB/n47+p9FXmNv18+h3RAH1rtU5EHBW19HVZENLkbQXrwQgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=132.226.202.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wD3SGRcL8Fqz79VAQ--.14292S3;
	Sun, 04 Oct 2026 00:37:49 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app3 (Coremail) with UTF8SMTPA id zS_KCgDHiaVbL8Fq33g9AA--.13836S2;
	Sun, 04 Oct 2026 00:37:48 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>,
	stable@vger.kernel.org,
	Song Li <songl@zju.edu.cn>
Subject: [PATCH] scsi: ipr: Fix use-after-free in __ipr_remove()
Date: Sat,  3 Oct 2026 16:36:52 +0000
Message-Id: <20261003163652.187399-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgDHiaVbL8Fq33g9AA--.13836S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?cywzawXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnbfYAegEspJ+qccDMUwRuttRH+UVATiXC0vLd3HNj7ON/KBO/pYz7NXR6PMM5oc0Vttd
	2CqvsQAj/JedJodnkLmp9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoW7trWxJF43AFykZrWUAFyfZrc_yoW8Cr13pr
	sxJrW5uay8GF12ka1DA3ySvF15Cw4xWayjgFW7W3y3ua15AFW3Ka4akFyjvFWUAr4kAFsr
	tFZIy3yrur4DCFcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9mb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r1j6r4UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
	kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
	6r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
	Ij64vIr41lF7xvr2IYc2Ij64vIr40E4x8a64kEw24l42xK82IYc2Ij64vIr41l4I8I3I0E
	4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
	WUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
	Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4U
	YxBIdaVFxhVjvjDU0xZFpf9x07jnKsUUUUUU=

__ipr_remove() flushes ioa_cfg->work_q and reset_work_q but never
drains scsi_add_work_q. Whenever scanning is enabled, ipr_worker_thread()
queues that work, so ipr_add_remove_thread() can still be pending or
running while __ipr_remove() proceeds to ipr_free_all_resources(), which
drops the last reference to the SCSI host via scsi_host_put() and frees
ioa_cfg. ipr_add_remove_thread() then dereferences the freed ioa_cfg,
including ioa_cfg->host->host_lock and ioa_cfg->used_res_q.

Fix this by cancelling scsi_add_work_q with cancel_work_sync() after the
existing flushes and before any resource is freed. ipr_worker_thread() is
the only scheduler of this work and reset completion can re-queue work_q,
so both flushes must precede the cancel.

The cancel is safe: ipr_add_remove_thread() never re-queues itself or
work_q, and __ipr_remove() holds no lock at that point.

This issue was found by an in-house static analysis tool.

Fixes: 318ddb34b205 ("scsi: ipr: System hung while dlpar adding primary ipr adapter back")
Cc: stable@vger.kernel.org
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/ipr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d207e5e..be2e46b 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9700,6 +9700,7 @@ static void __ipr_remove(struct pci_dev *pdev)
 	flush_work(&ioa_cfg->work_q);
 	if (ioa_cfg->reset_work_q)
 		flush_workqueue(ioa_cfg->reset_work_q);
+	cancel_work_sync(&ioa_cfg->scsi_add_work_q);
 	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 

