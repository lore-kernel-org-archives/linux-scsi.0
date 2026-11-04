Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758427;
	b=Nc7g8gTmSdo440oYJXUoe5LTTHForDFRZOqafR09PQTjprrZeSJ26KbnIGRqCRHPInA9
	 lqYlsNATkP6AOdFA7ALBQSi1rLFU/oRhahsqs5QC8kcbJOF4hOIoyJ7+YiHTq7eVdHspU
	 qhR6Qo/BqYRwZX53P61x7qG6Zfpn+fcIiJ+TBZDql+D+X8bBB6mcytyf6N1f29aIXm8Tn
	 jDhLPCHdp+KKQ6d6Uy3LVCuBLa6xHEZL/nzcrkyxbT6lSyYoOy2XFXKJVTJqkjOt/Rw6B
	 VpMkqpViad89i3kFkcI6jzD9DcWhSbpeAlOyy1NYPXVaguGzcn+BzLFQ75xdC5bFD2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758427;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=Lat98MlW9V/3dchaeRxt7B7dFMVFf5uSkJ6djDbuPd8=;
	b=MY66by478FP2Mapd28rPec9ZM8OI6Vc10JDe2lWVUXiC2YtAaERGuZs6G8bST7niDnJw
	 6Bor3NEfsKu8YKPcdNjrjYOSflQG0w3EyD8GLqTHvfsnCQDEzmBg4u5reyBA7XW6WcpKY
	 av1Dvmp7EW4yavdovIczwKlNKhNdT/JYA0rhB1xZ7YdZjh6TPnHolRT4vopLvt0fKZ3pO
	 Zs2gERjkkuzIHZRsbD69H+vybfzRoCT7T9fBCfzyi8OgG0rs4jfPCz3F0+FY9EUzWXdZ0
	 2K9vtev3VPbaMbHMhBNuKGJRv0DQFWQYNzD7KYHj2lTwLhGYbnWJ1aTvN2xiFyYpQ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53C6606A326
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:13:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A53C6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAB3Zf_UlOpqYHM+AA--.9728S2;
	Wed, 04 Nov 2026 10:13:40 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: advansys: release the EISA host when probe fails
Date: Wed,  4 Nov 2026 02:13:49 +0000
Message-Id: <20261104021349.1467720-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowAB3Zf_UlOpqYHM+AA--.9728S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AryUtrW3Kw1fWw1UuF4rKrg_yoW8GF1rpF
	s5CrWYkay5trWIkrs8CF1xZa4rKa93Jry29FW0y3sxur1rJ34ktF4fuay0gryjyr1IgayU
	tFWDCr98uF1vk3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAMBA2rqY+S4wwAAsx

advansys_eisa_probe() allocates a Scsi_Host for each of the two possible
EISA chips. If the first chip is set up successfully and the second one
fails, the error path walks into free_data and kfree()s the first host.

kfree() is not the way to release a Scsi_Host: it bypasses
scsi_host_put() and also leaks the IRQ, the DMA buffers, the ioremap and
the I/O region handed to the host.

Tear the host down with advansys_release() and drop its I/O region, just
like advansys_eisa_remove() does.

Fixes: d361db483241 ("[SCSI] advansys: Sort out irq number mess")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/advansys.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e6fa05ffc024..0fda9e551ce1 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11372,8 +11372,15 @@ static int advansys_eisa_probe(struct device *dev)
 	return 0;
 
  free_data:
-	kfree(data->host[0]);
-	kfree(data->host[1]);
+	for (i = 0; i < 2; i++) {
+		struct Scsi_Host *shost = data->host[i];
+
+		if (!shost)
+			continue;
+		ioport = shost->io_port;
+		advansys_release(shost);
+		release_region(ioport, ASC_IOADR_GAP);
+	}
 	kfree(data);
  fail:
 	return err;
-- 
2.34.1

