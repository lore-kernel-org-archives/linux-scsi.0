Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758424;
	b=maYUeUwzo0LLzbw9uZafZRntndnlPdG7atigimhM16lQDI+6Ohk2qO8k2eJMuWQgJ9zD
	 hiJEEnZV1MXGpPfyjlS5imDGdXDpDppvYRlQn4RGbyoqukXWldTXitttNGp76l9idShD/
	 bPyWUjp35UZ6+s+5S1M6hzA1RkDzvdNy0UVzbnOD6kngESM1E1Ubepbf5iQDxWglZt3Gx
	 0OSMA4F/qW01uyExhbacoOhDkbkveQsk4DS83nvTquDRdmfokpB1Zexcnou5IXVcPrRmc
	 +ClSbjQDbg9K6/A8/xTQQK+kxwgtH7XxZuQSRZD4Tz9Kbqyh9PBtA81JRfyhh1L2zzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758424;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=pi4Xz5fobJJSzl7MrHyJf0G66H2lu7cnO9U03j+2M98=;
	b=TOyNO4jwedyuT6XB1C7vEC3QTNYp/Ugf5qbTPVuOAHLBhOtrSSWuxBJdLIk923w+Bn5Z
	 IjGkaPT0fgNE8MCzWqo5g5xZxLJ/IRWtlC6RvOF2ripXSitaZaiPINXQmpaMkfs/EVLyB
	 5wNpMFTyF8SQwEfRMmKuXY/fGuLAwdSOeKMqxKdP/fIeOHSc3Bxe4DrMZA77d/mvd/LvW
	 K8UvVr2kOhQpDt7WpksaPOXgkG6GpsI7oeGxoofTNCP3v+ibnTtk8OqXMYbfGisAm94JJ
	 r/pfMh/GKHHT6aGZabxyqR3kRcBVNrU3in4XC+eM5iJf9VI3QT3HizrJa2Zymn3Mj4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E72606A328;
	Wed,  4 Nov 2026 02:13:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21E72606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowACXwvzSlOpqRXM+AA--.4833S2;
	Wed, 04 Nov 2026 10:13:38 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] scsi: efct: release the Scsi_Host on vport creation failure
Date: Wed,  4 Nov 2026 02:13:47 +0000
Message-Id: <20261104021347.1467701-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowACXwvzSlOpqRXM+AA--.4833S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr1kKr1DKw1xJw13Kw4rKrg_yoW8Jw43pa
	9Fg3y5urWUGr4UKr47Gr4rXF1Fva1xt3yDGaykK3y3u395Xryftan8KayruFy5Cr4kK345
	tF4Dta48Xw4kAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvSb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
	0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI
	8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
	xVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI
	8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280
	aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43
	ZEXa7IU5gZ2DUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgYBA2rqY4K6JQAAs8

efct_scsi_new_vport() allocates the Scsi_Host with scsi_host_alloc(),
which leaves the caller owning a reference.  On success the reference is
transferred to vport->shost and dropped later by efct_scsi_del_vport(),
but when scsi_add_host_with_dma() fails the function returns NULL
without releasing it.  scsi_add_host_with_dma() only rolls back the
references it took itself, so the host and its resources are leaked
whenever adding the host fails.

Drop the reference before returning.

Fixes: 32ddbad5b61e ("scsi: elx: efct: Transport class host interface support")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/elx/efct/efct_xport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index 9dcaef6fc188..88e7ebbbb8f8 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -930,6 +930,7 @@ efct_scsi_new_vport(struct efct *efct, struct device *dev)
 	error = scsi_add_host_with_dma(shost, dev, &efct->pci->dev);
 	if (error) {
 		efc_log_debug(efct, "failed scsi_add_host_with_dma\n");
+		scsi_host_put(shost);
 		return NULL;
 	}
 
-- 
2.34.1

