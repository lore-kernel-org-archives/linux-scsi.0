Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB924A23;
	Thu, 17 Sep 2026 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789656234; cv=none; b=qR2U9ABJw7VYQZU/KaDmUbsrIe4cjyrE96Tjiwk0JQie8Vf4aqzQGfZaqnDykGqLo6mDc29xwC6jl+OeVvrQoBkDLuFUOysWOX9xG5mTBmaY4gKd+CmXmxueFyG2nmXJGT5rUDMChYzBjujiAuuikdi2ahwHaLxCT+mbL+TaxhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789656234; c=relaxed/simple;
	bh=5xodUoxMSS/jiuopHLp6GL1I2BB2SaqJ36UWAGU7mW0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OjFZjoDVvJYzYnpLq0q8yrz2topCg1c+eejUsKAdqvIqseOrOEm7CVGnZtozsdWbwp+/h3rzC5IDNHMHRtt8w7qwI+0mKEnyJft/ODYCIcuFj5tR4HnZz5TGAJlE2iyTKokSGtbdEFKGBpxMX37lLQlRJegzwuyX1evCZxzI0GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAAHKkOR_Ktq7b+CCA--.45544S2;
	Thu, 17 Sep 2026 22:43:30 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: James.Bottomley@suse.de,
	alex.iannicelli@emulex.com,
	james.smart@emulex.com,
	justin.tee@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	paul.ely@broadcom.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix use-after-free in lpfc_els_rsp_rls_acc()
Date: Thu, 17 Sep 2026 14:43:30 +0000
Message-Id: <20260917144330.2157527-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAHKkOR_Ktq7b+CCA--.45544S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFyrKr4fKFy7Kw48WFWfKrg_yoW8WrWDpw
	4rJF4akwn5JF47tr4xGr1jgas0y3Z7trZakay7t348uF93GFyak348ZrykXryDZan7XrWI
	ywnFgF1Uua4UZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPvb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
	0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7
	v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0E0s8F02x267IIx4CEVc8vx2IErcIFxwAC
	I402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrw
	CF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E
	5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtV
	W8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY
	1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW0oVCq3bIYCTnIWIevJa73UjIFyTuY
	vjxUFBT5DUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgcNA2qr888VBwAAsg

lpfc_els_rsp_rls_acc() drops the ndlp reference held for the
MBX_READ_LNK_STAT mailbox command before it logs the ACC response and
before it takes the reference that keeps the node alive while the
response is being sent.  If that was the last reference, ndlp is freed
and the log message and lpfc_nlp_get() below touch released memory.

Take the reference for the ACC iocb before dropping the mailbox one.

Fixes: 12265f68ae92 ("[SCSI] lpfc 8.3.18: Add support of received ELS commands")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/lpfc/lpfc_els.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4e3fe89283e4..bdf8fe3e77a5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8782,11 +8782,9 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				     lpfc_max_els_tries, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_ACC);
 
-	/* Decrement the ndlp reference count from previous mbox command */
-	lpfc_nlp_put(ndlp);
-
 	if (!elsiocb) {
 		mempool_free(pmb, phba->mbox_mem_pool);
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
@@ -8824,6 +8822,10 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
+
+	/* Decrement the ndlp reference count from previous mbox command */
+	lpfc_nlp_put(ndlp);
+
 	if (!elsiocb->ndlp) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return;
-- 
2.34.1

