Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758448;
	b=gm3lkA4KiW7vxeI3zKBbJqIBzih1EsA6fY+RtgRtFjG32Wn5SrkOgLm70mH5PunIT5ip
	 zjx5CZa9L9LUpuWZeCAr2mFxA2qFCeCCgSiG/V2vn8IwQFT93XsI79qvcsAXWnb8WxeJr
	 plcrEkq3tA28QiVIJ13g2WUFOOdusKnCk7BkSqxZ88YIDX9/17Qq4kbDyjzPH4AhG4Hj7
	 BdTVik8Vcq4ECtgzjM/aS/xKVBq6Exo/s/8Kzopa+Pd7Q9e/y2fth506NIMOc0Sfi5dbs
	 b9D4TokfDOgNar+B3Z0jzEHNtBC9wXysTuhlnzZn/NP48qfrw82UVysnYxv56X4Rjkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758448;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=8/wENszwVTerEBWGoAA15O8YOYTpYlOlXBukAart7y4=;
	b=DH87Ig/168PemCsPZsaLWmdkC/TtC5Yr/g76mheOQQL9D1fC9OGqeeM3CtHEaFgJrOiB
	 EW2J5WdWWJf3WY+RrsiZef0/5Ma9JOqS1jpOfJmkwc+S6sStKePLwbeZ8fPw0LHZk3lZ4
	 EZIhscYZ7DUH+EeowE67zh/YQy83ezj6JXyj+Y7csd7mYo/l95aOiIgbbsuX4YwU4mxim
	 WGBfGY0FnVhKDTVepfH3zHpaRg4l4fH4BIFioYrS1kVua5kmspcTfAbMkmW9nR+bvBxEp
	 m0XGI0IAcsoqaFQkLdfg5fRrD/ZBz/1PP3Ac95JWFwmSTo70Uh7hHYWMk15d13e50uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0CD606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA0CD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowABXf_nqlOpqPnQ+AA--.27349S2;
	Wed, 04 Nov 2026 10:14:02 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: pm8001: unwind the probe on ccb tag allocation failure
Date: Wed,  4 Nov 2026 02:14:11 +0000
Message-Id: <20261104021411.1467970-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowABXf_nqlOpqPnQ+AA--.27349S2
X-Coremail-Antispam: 1UD129KBjvJXoW7XrW7uw1fKFy8Jr43CF1xXwb_yoW8JrW7pr
	WUGryjkrW5Xr4jkFsxZF1UX3Wqya93GrW7CFWUX340gr4Y9rW8JFyxAFWavFy7trWkGFs8
	tr1kJrnrWFWDArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkSb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
	ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
	aVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
	18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
	r41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY
	6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUqZYwUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwQBA2rqZFi3nAAAsW

pm8001_init_ccb_tag() is called after the Scsi_Host, the sas_ha and the
driver's private data have been allocated, and after the PCI regions
have been requested.  When it fails, pm8001_pci_probe() jumps to
err_out_enable, which only returns the error: the Scsi_Host, sas_ha and
private data are leaked, the PCI regions stay requested and the device
stays enabled.

Jump to err_out_ha_free instead, which releases all of those resources.

Fixes: 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding I/O supported to 1024")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/pm8001/pm8001_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 5af81c73a8f8..389649b36aab 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1178,7 +1178,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 	rc = pm8001_init_ccb_tag(pm8001_ha);
 	if (rc)
-		goto err_out_enable;
+		goto err_out_ha_free;
 
 
 	PM8001_CHIP_DISP->chip_post_init(pm8001_ha);
-- 
2.34.1

