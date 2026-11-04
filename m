Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758439;
	b=43biJLjUrMFUrQ85xo3rapa0ka4sxgSYcRLuR2i6b33PC0F0W64EbGGhjZKQK3ZPgVZG
	 B9QgAY1PIoLwhITOrzK2Y00UqTVf2YP/4OwtEa/8InWTCfr3XwPqdwAMma2CrM1vQGsIX
	 mjdbB762KKhQXS0F6LYl1FxGQo/RqSpoQ6z81HuDC0JWB9kC12YWGu2/gWgvROGlYQzE+
	 5tkTd/jyXesRFcHoqqHZSY8nAw6pOPy01V1xfVaEz/zvkPJeFRrTnsKsE45JS1hJxkTK1
	 sqqO+M7vpU7GJc8dzZ8I68RqQd4wvDqEGgSZP5GEfFb1oFSTQs2euCieHvjEmP17ZZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758439;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=6fxF1v/kNV1G7zMS99AnJKojlG0hQhFV5f4zlpmQ+YU=;
	b=5ToutZSkgpWoETi25lk12CZ0uFy4tznoz6rCxHzN/YIUFI/ExPsnHJslXFt3XEeo4Og8
	 R7t++baxtxZ3yy9FkaGxByEck1kJ8FFU9NIn+5A6fVQ4jJ5rfd36tZr/j97+ahxiM7tSZ
	 rTkgfoTKzhIYua39G08dmKb1HCaMNchZ93sOaGKu4hgn65hdvb1mHEcE2XfH1U/r5vBm5
	 UMpMG0bpUrcyIY8nJ1pQLN+Lq0/X8Rg2I8zqq5wShZuoy6StsUGSJJOO8GTUlKOAuflsu
	 vDTqsuUmICy/MmPKJJhByMgljwkd0YqAgXDEtCUEl1cVqtC/U85bj4P0z2C04aaOntQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705C4606A328
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 705C4606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowADnD_rflOpq03M+AA--.28995S2;
	Wed, 04 Nov 2026 10:13:51 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: lpfc: release the RLS node reference when the mailbox fails
Date: Wed,  4 Nov 2026 02:14:00 +0000
Message-Id: <20261104021400.1467797-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowADnD_rflOpq03M+AA--.28995S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1UXF17KrykGF1rJFWUurg_yoW8Jw15pF
	WUGayYy3s8J3W2kr17Zw1UZF90y3Z3trZ2ka1Iy3s5uF95XFy3ArWFv348XryDA3Wvga4U
	tasrKryUuFyDArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
	ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
	jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
	ZFpf9x07b5lk3UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwIBA2rqZFi3YQAAst

lpfc_els_rcv_rls() takes a reference on the ndlp before issuing the
MBX_READ_LNK_STAT mailbox command and hands it to
lpfc_els_rsp_rls_acc(), which is expected to drop it once the command
completes.  The callback drops the reference on the normal path, but
when the mailbox completes with a non-zero mbxStatus it frees the
mailbox and returns without calling lpfc_nlp_put().  A failed read link
status command therefore leaks a node reference and keeps the
corresponding rport alive forever.

Release the reference on the error path as well.

Fixes: 329f9bc735b4 ("[SCSI] lpfc 8.1.12 : Reference count node structures for node lifetime management")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/lpfc/lpfc_els.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 804aa7509b69..ef9c68d382a0 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8769,6 +8769,7 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	pmb->ctx_ndlp = NULL;
 
 	if (mb->mbxStatus) {
+		lpfc_nlp_put(ndlp);
 		mempool_free(pmb, phba->mbox_mem_pool);
 		return;
 	}
-- 
2.34.1

