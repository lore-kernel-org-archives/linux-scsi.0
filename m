Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758451;
	b=mAwkIv14hVpwdadeBJ2GV/+bjHBf5BGjRRLmfbLNB76Zsfy7THU3KhxTSvGy7503iR2v
	 JV+Bs19J8d+DHwhIbOx0RIyt7YWJp2Z4jMx/N7iEkO3CRRwMHTX1h2J8VcXsOhZEh7kp7
	 NVzBhcZfgV4ZmwDNmyVADvndD8tGvA0rPmrmVsFhLl39hLL8gRvOhNfxVFOnW32F4XVlp
	 LUmurAP56Kngw8/2wzhpCY7EhTWHu/F3iiy9gJhnWXUeXTJZvfH4ixQtdTU+YOhl1HF3l
	 6rCinQreZqNWvf7QtxmpRGMnQOAl1ZXdyPF086+4594lX3pv1SKxyYbUDScTiEfddMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758451;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=Nhg0ECqnd/TSkPVdjfPTJTbbsLpBK2aZkT7EzYu/sk4=;
	b=V0Q0EuM1MV5FGGOUo6HOfN4N4q0EP9F92CBhdx6d2MFSXaBkrlKlHkL12IJQy9A9+fE/
	 y3zC86+XsbB1qZzHgvkQh17UPlgCTT9RnAIwbIClaFds9b2R2Us6WXnsmoE9JVgh7gExy
	 XjSBbboNN5CRLR+B1WGAfIYXW46BiJHnlD2msG7I3lspvHcCcZEU16+cq3bym+49/KabQ
	 qNnKS6A8eP4tv1TC4sjK03hAtx9UySB9x0cKrmRcXp7gAH8HmjZIEQegQqyl2pj15ZuI6
	 /qAOaFd+J3RGos2mdXEBh7nwi56RsHNZTqfzZj03ZwMrvBXbtuaIisPTT1EqFRkGtog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4557B606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:14:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4557B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowACXvvjtlOpqWHQ+AA--.9642S2;
	Wed, 04 Nov 2026 10:14:05 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: lpfc: fix node reference leak when the CT response iocb is not queued
Date: Wed,  4 Nov 2026 02:14:14 +0000
Message-Id: <20261104021414.1468085-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowACXvvjtlOpqWHQ+AA--.9642S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWxtry8trW8Wr4rGw45KFg_yoW8Ww4Dpr
	WUW3W8urZ5JanFyr4UA3WqvFnYya1fKry2kFZFkan5ua95CFy7tay0qF48XFZ8AFWvkrZr
	Kr4vgrWjg3WUCrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvvb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
	ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
	IFyTuYvjxU2G-eUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAEBA2rqY+S5OgAAsL

lpfc_issue_ct_rsp() takes a reference on the target nodelist and hands
it to lpfc_issue_ct_rsp_cmp(), which drops it when the CT response iocb
completes.  If reading the host register fails before the iocb is
queued, the function jumps to issue_ct_rsp_exit with that reference
still held, so the nodelist is never freed.

Route this error path through the same cleanup as a failed iocb
submission, which drops the reference and clears job->dd_data before the
bsg_job_data is freed.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7354ae9ba8e5..8b7b3d26326b 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1543,7 +1543,7 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		if (lpfc_readl(phba->HCregaddr, &creg_val)) {
 			rc = -IOCB_ERROR;
-			goto issue_ct_rsp_exit;
+			goto issue_ct_rsp_put_ndlp;
 		}
 		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
 		writel(creg_val, phba->HCregaddr);
@@ -1562,7 +1562,8 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 		return 0; /* done for now */
 	}
 
-	/* iocb failed so cleanup */
+	/* iocb failed or the iocb was never submitted, so cleanup */
+issue_ct_rsp_put_ndlp:
 	job->dd_data = NULL;
 	lpfc_nlp_put(ndlp);
 
-- 
2.34.1

