Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793760826;
	b=VGpzxI43sYh9HKNfFG5bv3SgPBD3SZ/lcyVpiZGbWsfWWRaBlhxb07Fbq97Gi98ucd1a
	 T1CatP26ztum69dS7bt681PUCQtEPPMK16UvJ4rHhKVCRfo16oBPrs7VEzkAUmPIRwxzQ
	 ok/QVQnXb47FGqRDkrMaw/aEF44v0Oa7mIWPegr3iT1qLeJGZCmG3Im3XYJH2w0Oeh+ZO
	 cFJG99fsjboSZdE/jkJFcJwCcs6Fvu54S6rypa0UDqKwDSAB+A1pILmLB4MKK+TFLsYa9
	 iwdC0DxUCPfIB6nI6iPNYRumm8RPQh6DUyl6Z4pymCtq3Zty+FAOMslulxb5x9S5rNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793760826;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=4YJH+GPw8HudDz2iohgu7Qv0ds5bGh76uAwDDejUQbc=;
	b=hGX7WtJZO7BmIKBB6XSBFjtE/9gOA4RXmZhNvEJCWktpGHzHmXhMZptEErLkLayY0rmc
	 NH1vZqBmteuOn2W7utj8olAHJn7sykE8/u2j+Rv6BqVPyDpDSzUEWON28rbrEkC3ny72T
	 NfcucNNeeSZ9eZKbgxEgCTIiEohHM2NiHGPUNESB2u1PXa/sPk3rssdbSpx4TQ3WDdRiU
	 8zg918kKvxkc+J4f72p0ev394WDMJycBWZstpj6PfM5l6lrGMfP+PNSEgg5QpxwydiJA4
	 Xz4MBJtJK6cb57mdkFNJzZkfue0NuhVyv4L1sKrikj4pkF0q6y1nAXw5dGuNkSOkddg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEDF606D821
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAEDF606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowACXvvgynupqJOU+AA--.10143S2;
	Wed, 04 Nov 2026 10:53:39 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: lpfc: fix ndlp use-after-free in RLS accept callback
Date: Wed,  4 Nov 2026 02:53:48 +0000
Message-Id: <20261104025348.1527601-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowACXvvgynupqJOU+AA--.10143S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CFWrAw4UXFWUZFWkWw1xZrb_yoW8ZFyrpw
	s8JFWjkwn8JF47Krsagr48Zas0yw4xJrZakayqy34kur93WFy2yryjvry8XrWDZan7t3y2
	yw1qqFy7W3WDZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB0b7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26rWY6Fy7McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjcxG6xCI17CEII8vrVW3JVW8Jr1lc7CjxVAa
	w2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I
	0E14v26F4UJVW0obIYCTnIWIevJa73UjIFyTuYvjxUHubkDUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAEBA2rqY+TkUAAAs8

lpfc_els_rcv_rls() takes a reference on the ndlp for the pending
MBX_READ_LNK_STAT command.  lpfc_els_rsp_rls_acc() drops that
reference right after building the ACC IOCB, but then keeps
dereferencing ndlp in the trace message and takes a fresh reference
for the IOCB.

The node can be removed from the nodelist while the mailbox is
pending, so the put may be the last one and release ndlp through
lpfc_nlp_release().  The later ndlp->vport, ndlp->nlp_DID and
lpfc_nlp_get() calls then touch freed memory.

Move the put after the reference for the IOCB has been acquired, and
release it on the paths that bail out before that point.

Fixes: 12265f68ae92 ("[SCSI] lpfc 8.3.18: Add support of received ELS commands")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/lpfc/lpfc_els.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 804aa7509b69..0bd706b1520f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8778,10 +8778,8 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				     lpfc_max_els_tries, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_ACC);
 
-	/* Decrement the ndlp reference count from previous mbox command */
-	lpfc_nlp_put(ndlp);
-
 	if (!elsiocb) {
+		lpfc_nlp_put(ndlp);
 		mempool_free(pmb, phba->mbox_mem_pool);
 		return;
 	}
@@ -8821,10 +8819,14 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
+		lpfc_nlp_put(ndlp);
 		lpfc_els_free_iocb(phba, elsiocb);
 		return;
 	}
 
+	/* Decrement the ndlp reference count from previous mbox command */
+	lpfc_nlp_put(ndlp);
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
-- 
2.34.1

