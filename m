Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.187.6.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCBA3C37AF;
	Tue, 11 Aug 2026 02:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.187.6.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786416806; cv=none; b=PnzFBxDYaY5vOE07c3tf6qJ3N1pm4VHk1pkJFkFMJ8xTenWCOKxXANuivboPM3yAvpsLMBQ7gOp9JFbkPEiv19j63cJQbpvGGv15StMVVzICZuYYlFXyXa1j9e2KUyjd9bodcix0/vq3f/31i3c14CK1andgwEadwWzGim6NZgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786416806; c=relaxed/simple;
	bh=IhChvpFv9UABV+fFZzbhWEEGFrkVLPzcFML395lWAe8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t+J6rc1SyUTuCKVp3Ev62D7LPn8hwzA3zbarh3CSayQj1lM5vorn9dC2hwQRP0A5XJGohiny9Y/XzrHeoK+/yjwhaxHaxvHXId0azbsag/lURRd+4N4nN3PvmexJuD8JixarVKSsDjIhWeVDCXqebLCzXg9TyJXUQtaBSp1fY3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.187.6.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wDH4HyUjnpqe+eCAA--.130S3;
	Tue, 11 Aug 2026 10:53:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app2 (Coremail) with SMTP id zC_KCgDHEcaUjnpqKp3DAw--.65430S2;
	Tue, 11 Aug 2026 10:53:08 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH] scsi: mvsas: fix tasklet use-after-free in mvs_pci_remove
Date: Tue, 11 Aug 2026 02:52:12 +0000
Message-Id: <20260811025212.136883-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zC_KCgDHEcaUjnpqKp3DAw--.65430S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?aap9IQXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfncGSG+szpQCInt5Y8rbJUI3LA576NNjHV4wsL5n4+GcpL/ZK1QhJj+Z4zKh3/7XlRa6l
	7YIGVhHP30yT5/laYCOp9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoW7tr1DAr4ftw1UGr48XF1UurX_yoW8Ww17p3
	yfG3yjkrW8XF1j9w17C3yUZa45Jws7Cry2kFWqg34aqr1Y9Fy0qr1xGFW7ZFZ0yry8Ja12
	vFnYq3s5Wr95JabCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Gb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Tv3UUUUUU==

The tasklet is killed before the device IRQ is freed. The IRQ handler
schedules the tasklet, so an interrupt after tasklet_kill() can
reschedule it to run after its backing data has been freed, and the
tasklet re-enables the interrupt on exit. Move tasklet_kill() below
free_irq() and disable the interrupt again once it has drained.

This issue was found by an in-house static analysis tool.

Fixes: 6f8ac161b8b3 ("[SCSI] mvsas: Add support for interrupt tasklet")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/mvsas/mv_init.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -588,13 +588,14 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];

-#ifdef CONFIG_SCSI_MVSAS_TASKLET
-	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
-#endif
-
 	sas_unregister_ha(sha);
 	sas_remove_host(mvi->shost);

 	MVS_CHIP_DISP->interrupt_disable(mvi);
 	free_irq(mvi->pdev->irq, sha);
+#ifdef CONFIG_SCSI_MVSAS_TASKLET
+	/* drain after free_irq(): the tasklet re-enables the IRQ on exit */
+	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
+	MVS_CHIP_DISP->interrupt_disable(mvi);
+#endif
 	for (i = 0; i < core_nr; i++) {
 		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
 		mvs_free(mvi);
--
2.39.5

