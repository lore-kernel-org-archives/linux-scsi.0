Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAF3383C84;
	Thu, 17 Sep 2026 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789656508; cv=none; b=aVq3g38zuQH+Z9TJqRjaQrJ3Lz20mLDbXlda5IvjPnBxoEZDoa0i9Ehpn6L64oMhPg9VKIj6cCDSZxBoNe0Zk4AW+RWC6IC9FXReah0dG2dBtf6IPlUIvzs2tnSDH7V1nwiQChGi0JjV14fJZ+NYpwAHAOM7mjD1jWm9ltYDO1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789656508; c=relaxed/simple;
	bh=GK2EfBvMOdcJf/xmeiZ4Sd8HKokeIsR6s6UF7yHX8jQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n3OBEiggRIyF8C3UdMcwuEqOFzAnu+ux9pw9mrS1OBTmKewGo2eTEUD/fQ4D0rQB+lei54YqCDN3z/llbu9y2i9rjAdsAUjmse8L/A3PiU4kzPmTFQeYKfaU5ovsfoydHN5QDk4tZeGjphWAnW0Ht2VsQDGx4xlgFWVvXduKwS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACH8z2e_atqYNOCCA--.5112S2;
	Thu, 17 Sep 2026 22:47:58 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: dick.kennedy@broadcom.com,
	james.smart@broadcom.com,
	justin.tee@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	paul.ely@broadcom.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix ndlp reference leak in lpfc_release_rpi()
Date: Thu, 17 Sep 2026 14:47:58 +0000
Message-Id: <20260917144758.2157707-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACH8z2e_atqYNOCCA--.5112S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFW5uFW8CFWUKFyDKrWkCrg_yoW8Gw4rpa
	1kKa45ArykGFn2krsrtr1UZas0v3WxJ39Fkayqy34xurs5XFy3tr4Yqan8XryUJF1IgrW2
	q3srJry5W3WUAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VAI37AI020EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMx
	AIw28IcVCjz48v1sIEY20_Gr43Wr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
	0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x
	07bbXocUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgMNA2qr888XkwAAsy

lpfc_release_rpi() only drops the node reference and frees the mailbox
memory it took when lpfc_sli_issue_mbox() returns MBX_NOT_FINISHED.  The
SLI-4 issue path can also return -EIO without submitting the command, in
which case the completion handler never runs and both are leaked.

Clean up whenever the command was not handed to the port.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 9c449055a55e..055f44ec7b94 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1142,7 +1142,13 @@ lpfc_release_rpi(struct lpfc_hba *phba, struct lpfc_vport *vport,
 				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag);
 
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED) {
+
+		/* Only a queued or completed command is handed to the
+		 * port; other results, such as the -EIO returned by the
+		 * SLI-4 path when it cannot submit a non-polled command,
+		 * leave the mailbox and the node reference to the caller.
+		 */
+		if (rc != MBX_SUCCESS && rc != MBX_BUSY) {
 			lpfc_nlp_put(ndlp);
 			mempool_free(pmb, phba->mbox_mem_pool);
 		}
-- 
2.34.1

