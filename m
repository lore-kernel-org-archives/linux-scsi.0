Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758476;
	b=HZZ1+DKedQq1k3bd7mpheUTBgLvVolRoa2ufPAn9kXiO1iEkfLJPQqB9nXpKt7klZmHV
	 u9LAqOm8uTCJ0Rudyx4HIiLP/rHUH9kn1epj918UE6VyENM4ay36QYKkMkCzFlUXOLv4T
	 CMtz2USvrAgY0i904C5pOmHc7IKg0C3LtkjYZi4k6XQddgQHahPWkv8jnNZAqXIPkMBSv
	 bPBXP4RcBuqqf9h75txU24C0JOYIFVGFz3pv576pA5Xk3UeM5HUstWnJtA09RaZiF9b2O
	 frSXxErEe5I1DunvnMt0KNedsZc2CQoeCT7q2yTKxMydbGKs0GHV3QCshLwb6cst7zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758476;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=Jj8CzUreLS5NHGDu/uGqA7xd3x8Il8bHdVd87LezRkg=;
	b=hmyIQGl3pMm/ei7pK1MlFr0fRNxV0OqRoOSlTNrhvfeGXziSVxrKyFyNUj5HM5BJ33j/
	 rzAJVUXEhaucNKc5uxI8lQZpMHfQbKL09SXeQlXSHyeCJO/Xk/iIw4HOU01LGn3X0OlbJ
	 550POb4ZLP8SbnqKcLYT/Kw0b1vxN18YEszSCk2wyGvP/3TcaQWIuVl0vbQ7RTosPKLoV
	 +0JQ1fazkuqTX3puU4g23bFasUaH3hQFSMVokLlg7BFhbyhc0Qz+hEFI3fjHgrmOxDWXl
	 J6oxVZviYg2xCi6wiGaAy1SZtis+n2Dvfu9iMuD0PtndoHAJjE8Z4FYx9X0eCm1zaZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4642606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:14:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4642606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowABXf_kHlepqYnU+AA--.27354S2;
	Wed, 04 Nov 2026 10:14:31 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: mvsas: put the Scsi_Host when host setup fails
Date: Wed,  4 Nov 2026 02:14:40 +0000
Message-Id: <20261104021440.1468339-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABXf_kHlepqYnU+AA--.27354S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kry8WFyxtFy8AF4kXw1kZrb_yoW8Gr1fpr
	WrG345CrW5Wr42kwnrGr1UXFyYganIyrWrKa1Iq343ur45AFyxtFZ7Wa1UZF90kFW8Ka15
	JF4Dt34kWF1UAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26rWY6Fy7McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
	6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxG
	rwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY
	6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU5EQ6tUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwEBA2rqZFi4FgACsU

mvs_pci_init() allocates the Scsi_Host with scsi_host_alloc() and, once
everything has been set up, hands it to mvs_pci_remove(), which ends up
dropping the allocation reference through mvs_free().

Probing can fail after the host has been added: scsi_add_host(),
sas_register_ha() and request_irq() all jump to err_out_shost on error,
where the host is removed with scsi_remove_host() but its reference is
never dropped. A failed probe therefore leaves the host allocated for
good.

Put the host after removing it.

Fixes: dd4969a892ea ("[SCSI] mvsas: split driver into multiple files")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mvsas/mv_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 5abc17a2e261..9210cb0bb2c1 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -571,6 +571,7 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	sas_unregister_ha(SHOST_TO_SAS_HA(shost));
 err_out_shost:
 	scsi_remove_host(mvi->shost);
+	scsi_host_put(shost);
 err_out_regions:
 	pci_release_regions(pdev);
 err_out_disable:
-- 
2.34.1

