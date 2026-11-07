Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794068214;
	b=Av+VhIKlbc4femQCeC7890REcwQEox4RUV5hRiaTZQGc0nSwcX0Vr6/2e84nO/hcG7kM
	 QjoWqP7wojYRW7UYdgB640EH/Ghn1nzYLIkoGbilTfdfBvdNS0ha2kGQ7nLPADpdc1i/x
	 UAOPQfB0LIL5MaL0jaMrxqJi1vuGkGBE1JP0Uox+K5112lbe9RTPSJFlw63oTYZh7cSy3
	 dardQa8nLZ+vUXBQM6TlOTPnqf08vlEk/m1QZyz4Yo2T/yfLkkiIyEIEiwI2qlX2dLzaP
	 jFxCEcMHfdyR9XyWESSrDlfxNsOg4EBsj+VcH4j55jiwQrNIzlMgGFz+1Re3GSh//Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794068214;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=K4YnwhhJnc1W435Ar0gljAF3AGrQ4+jD6hnF5J5AmqM=;
	b=uKt6lSGDe4HwO2+P+25doglCoUbp9sD0hvRgBo0LP68QPnjFKpwjyquVGiJP9vaeC71l
	 gi+Fde/tLK9/jXDEMlA5Tb9TaKcnUwoJ9hBk8igob3RFIqB1RmemtJaWI+uFiPnge+IIo
	 m8l4m3oIKbPdAQ4Ae1NRYTIGTQHDlTqjmdHGEjjcWR4Dsn4ZXMQTGrE9itCnKIP8Qx5gG
	 RfZCE8fHYSPCSoZY/flZ+IbwOEAYqTPRzRpsS04XA5Ip15WivSLhCo+3yNLtOw2MZWX6l
	 6wvyPxeWBdTO+I9JigNCG4Uhn6qgIcleO6aOolmXeSVsZCGuJxc6/zzOPfScs9Fjlmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C788D606D3D1;
	Sat,  7 Nov 2026 16:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C788D606D3D1
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowADn9ZbtTu9qIJ6BAA--.24761S2;
	Sun, 08 Nov 2026 00:16:45 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Smart <james.smart@broadcom.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Nigel Kirkland <nigel.kirkland@broadcom.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: lpfc: Fix ndlp reference leak in lpfc_release_rpi()
Date: Sat,  7 Nov 2026 16:16:53 +0000
Message-Id: <20261107161655.2628796-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAEQnVQn7fpgpm5zY=8ne0G5M_KXWg4qjecMK6smk-q+_0j1PEw@mail.gmail.com>
References: <CAEQnVQn7fpgpm5zY=8ne0G5M_KXWg4qjecMK6smk-q+_0j1PEw@mail.gmail.com>
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
X-CM-TRANSID:rQCowADn9ZbtTu9qIJ6BAA--.24761S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFW7ZFy3tFW5uF4kWr4kJFb_yoW8Aw45p3
	95Ga4Yyr95GF1SkrW7Ar1xZas0kan7Jryqkayvk34xZrZ5Xry3tF4Yqa1rXryUJF48t3y7
	t3yDKa45WF15ZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9C1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8JVW8Jr1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_
	WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUDOz3UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRMEA2rvPcsZdAABsC

lpfc_release_rpi() only drops the node reference and frees the mailbox
memory it took when lpfc_sli_issue_mbox() returns MBX_NOT_FINISHED.  The
SLI-4 issue path can also return -EIO for a command it refuses to
submit, in which case the completion handler never runs and both the
reference and the mailbox are leaked.

Clean up whenever the command was not handed to the port.

The candidate came from a static analysis tool we run over the tree.
DeepSeek and GPT-6.1 Sol were used to audit the finding and to help
write the fix; I reviewed the result line by line and I am responsible
for it.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
Changes in v2:
 - Rebased on v7.4-rc1.
 - Reworded the comment above the check so that it does not depend on the
   SLI-4 return value.  The check itself is unchanged.
 - Sorry for the month it took me to answer the review.

 drivers/scsi/lpfc/lpfc_nportdisc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index fb8844c69491..fbe3c97723b2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1155,7 +1155,11 @@ lpfc_release_rpi(struct lpfc_hba *phba, struct lpfc_vport *vport,
 				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag);
 
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED) {
+		/* The completion handler frees the mailbox and drops the node
+		 * reference, and it only runs when the command was queued or
+		 * already completed.
+		 */
+		if (rc != MBX_SUCCESS && rc != MBX_BUSY) {
 			lpfc_nlp_put(ndlp);
 			mempool_free(pmb, phba->mbox_mem_pool);
 		}

