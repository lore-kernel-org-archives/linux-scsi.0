Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFBF519907;
	Thu, 17 Sep 2026 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789656127; cv=none; b=QsTmvYQc2hEs0uL/ZKllrznmP2bq1NUZUwsjjCFLVSj21KsvYblrjJl2xwd/XnIkVMLxTCRUS/VkG7rDX30FQmIi52WwBbAp0XrQdP6CG7xBUFnWq5PXXFYYv5GcXWqiCYkhiCBuKQxJ3JPxS0XFMZ50Htsz/ZZrohR0CPmJCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789656127; c=relaxed/simple;
	bh=L930Mfkz+kif9m+OicriBXL1vAqKskwt+Rbk9Pred4E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AFyJI3fLb9+Zu+ZlH5jCXA9kcCinukytrdBXH4xuAqdDH3U8+DYm+WdadXS0TE1sOP4lW11vbBRf+k0dDaAv+HTp0duUJd6dm++5IoJPQFgZhrGwA/xeXIt6Of/DlJR3e7kP0K3b+n0/Et/D90UUEwEydUuY0sbDipLRTM4qbsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowADnF0Io_KtqB7mCCA--.5021S2;
	Thu, 17 Sep 2026 22:41:45 +0800 (CST)
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
Subject: [PATCH] scsi: lpfc: Fix ndlp reference leak in lpfc_issue_ct_rsp()
Date: Thu, 17 Sep 2026 14:41:44 +0000
Message-Id: <20260917144144.2157444-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADnF0Io_KtqB7mCCA--.5021S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr4DXw1DAr4UuF48AF4fXwb_yoWkXwb_ur
	40yr4xJ3ykCF1kG3WUAr17A39Fka1jq3Z7CrnFv3yfu3yIvF1j9r98Ar45uw17uwsxWwnx
	Ga10qr9Yy343ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbgxYjsxI4VWDJwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
	s7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4
	kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VAI37AI020EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMx
	AIw28IcVCjz48v1sIEY20_Gr43Wr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
	0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x
	07UC38nUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAMNA2qr9nANwgAAsJ

lpfc_issue_ct_rsp() stores the reference returned by lpfc_nlp_get() in
dd_data so that the completion handler can drop it, but when lpfc_readl()
fails the function bails out to issue_ct_rsp_exit and frees dd_data
without dropping that reference, leaking the node.

Release the node on that error path too.

Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7406dfa60016..f9e9896c348b 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1545,6 +1545,7 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		if (lpfc_readl(phba->HCregaddr, &creg_val)) {
 			rc = -IOCB_ERROR;
+			lpfc_nlp_put(dd_data->context_un.iocb.ndlp);
 			goto issue_ct_rsp_exit;
 		}
 		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
-- 
2.34.1

