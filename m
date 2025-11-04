Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257361F91E3;
	Tue,  4 Nov 2025 09:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762249776; cv=none; b=Q3zEsWJeGoaasyNqGCPvIwRhpRuJsxTSzVDgXEXfXTHPg7ORCZ0tcguOB3A/v1pEv95Z1zMhSymN8xuDs5V5NqgidsCeYTQ8/6LdHomaJWTvHZJ4pGDCOZn8TtlZlLVVRKUcRgtnw7fXjzjcmWA8fL77Qz5pXNiwwAqem2f+KV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762249776; c=relaxed/simple;
	bh=BEakhbw4PgPL9J2903BKCiKGbRX/YRTlFqyG1KPAiEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=afvsOjY9iHb8Rb3ZtgShfR2Mm4KWk7DSQzW6ZpHz/EMbSJm0OT2r5VzZYcEu/SlpOjGpu7VDacpTvXFYve53pDEShg4qJLDxBduc27BPcBBpNWsL8letHuERpY/Ktjrzs/0XaQQiOnYXC+m792l36ytwijxOiwO4mE0/1uvwGGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-03 (Coremail) with SMTP id rQCowAAXlewhzAlpjVhqAQ--.29785S2;
	Tue, 04 Nov 2025 17:49:23 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] scsi: stex: fix reboot_notifier leak in probe error path
Date: Tue,  4 Nov 2025 17:48:47 +0800
Message-ID: <20251104094847.270-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAXlewhzAlpjVhqAQ--.29785S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKw47tw4kCryftF43AFyUtrb_yoWftFbEvF
	40q342grs09rsakrn8Cr43ZrZ29r1jgrsYgF40qFyFk340vFs8WrWq9rn0yrWUWr4jqFyD
	Jw1qqr1S9w1xKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjO6pDUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwwQA2kJy80BBwAAs4

In stex_probe(), register_reboot_notifier() is called at the beginning,
but if any subsequent initialization step fails, the function returns
without unregistering the notifier, resulting in a resource leak.

Add unregister_reboot_notifier() in the out_disable error path to ensure
proper cleanup on all failure paths.

Fixes: 61b745fa63db ("scsi: stex: Add S6 support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/scsi/stex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 63ed7f9aaa93..34a557297fef 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1844,6 +1844,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 out_scsi_host_put:
 	scsi_host_put(host);
 out_disable:
+	unregister_reboot_notifier(&stex_notifier);
 	pci_disable_device(pdev);
 
 	return err;
-- 
2.50.1.windows.1

