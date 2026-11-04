Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758454;
	b=oRdtQKWTY41N9YQPBIJXTftGouRCVxMLpCxROsrf9VTXwjHNj7hxW969unaQN2iDp3GX
	 pMH9Yr65ko3GlouHDw3JnacVMX8cJ6WxjzalDBJ1p/C89yWnL6h/5w6NQ7eckCtt+sk7U
	 S8UXPZg7mLJgZRGGLxMdBGSp85VfPTixht/MFsE+pStgisRpRAefOT++EKp8MDlkblqOg
	 lT5alX3Yt/eFkvJDxNsQjsI5nJPLNHIE7PCnbD0cUCxkq6XJta/e2PlBFqG1B8x0+h7pO
	 EIxqj6gPAhW7YckGI7tU41FOcGxz8CgpqL1ditlwmcPJ3tlQfIHQQCES6zQev0I7mKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758454;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=L86a6ccdaiHA7FEEHEBF2tN91BBdbJa1RoWRfJjUMMU=;
	b=r2j1NDqH6DrGcHJ+yPAliKHuIR2ruyLBTuG9xqntS9VYQGVzlA+/AdmzOj4lhrIA7iOF
	 m3QewMX7g47Ren87Cs4KNRnhRjLlVX+PlbQpX15IJxSw7T3Rz4v2lHOGRHhG0OOjXavsW
	 iztqvjswO9JaSs8iGq0wM+BWgxlWzzr1eJsFfmjwYsmorfuZWSI3Q9krM0xtqsg7qGusy
	 ybQ0pFERQYsa7L8gF9IIKdnwqOj3CC0T+gcEN7HUD78sU7BvmAvn0lojkxipc7q5uKDQd
	 UZ9VOzNe/EwK5vqYp9meSSrFjnvvCkHt+Vh/prIkq4AApfSPe44Q0Na0cSN1+PNJoOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2095606A328
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2095606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowABnVf_ylOpqlnQ+AA--.27162S2;
	Wed, 04 Nov 2026 10:14:10 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Hannes Reinecke <hare@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: myrb: unregister the SCSI host on remove
Date: Wed,  4 Nov 2026 02:14:19 +0000
Message-Id: <20261104021419.1468133-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowABnVf_ylOpqlnQ+AA--.27162S2
X-Coremail-Antispam: 1UD129KBjvJXoWrKryUWFykKw1rtFyDKryUWrg_yoW8Jr4xpr
	4rWa98CrWUJFW8Kw4UX3W7AFyYqa1fArZ8ua97Z3s5XF4rAryIga4qga4UXFyFyr4kKrsr
	JF10q34ruF1UAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkab7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
	6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxG
	rwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr
	1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvE
	x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07be3ktUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRQBA2rqY-m3oAAAsS

scsi_add_host() takes a reference on the host device that is only
dropped by scsi_remove_host() when the host and its children are
unregistered.  myrb_remove() goes straight to myrb_cleanup(), which only
drops the reference taken by scsi_host_alloc(), so the host stays
registered after the PCI device is removed and the memory behind it is
leaked.

Call scsi_remove_host() before tearing the controller down so that no
new commands are queued and the host is unregistered.

Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/myrb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 95df6e5345f7..e43d86f139c1 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -3496,6 +3496,7 @@ static void myrb_remove(struct pci_dev *pdev)
 {
 	struct myrb_hba *cb = pci_get_drvdata(pdev);
 
+	scsi_remove_host(cb->host);
 	shost_printk(KERN_NOTICE, cb->host, "Flushing Cache...");
 	myrb_exec_type3(cb, MYRB_CMD_FLUSH, 0);
 	myrb_cleanup(cb);
-- 
2.34.1

