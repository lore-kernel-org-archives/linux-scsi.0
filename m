Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794470414;
	b=a0nq+s+E/gTCWAopDTmLxqpXMlc4kLBQpfiG16bFHEq4h8Xi8eOnZ9XiK46ofmJfZV5S
	 KgEWLGn644kycJRzj2w2xD5eRBVNIJVJWI+Ujtptq2uW1xWdo5NI0pt5LTH2oT177c/A9
	 biClZVrs2tFmDY3spFqZDil4L9st31sBj1wqi53ryYa6kHG9OPa107QrROizgpGYDapeB
	 NfAluTMAOKSgiFg3BortjeFJm2ExrS/JGLIeqAv2QflL22sFsMN1C8AlEa5te9ap57c4L
	 Bp10NsJLMY8x3L7BGjBe2Ep7L5mhCqPx6IP4DZNXOKN3ffJ5mTUOMb7opz8GRDpAZGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470414;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=M5xvtH2FwKnV/bNu8hkgSYArlf9uhRAtbT+slgnh5EI=;
	b=fFmy/lkk3LgmpD7NqvlNddnWxBNkGQOE59Cg9VpEZIPKsW16lMi//jWSD1PaaJ1gATbU
	 TIMrsTqyAfkRCWj7gv2ZheCRPulRHnxp+S3HLsz9pMJIcMZCD/25fkVvJlPAUBlsyBFoZ
	 IygaTx6XANchJu+de+3ROQfyxFHJBGlLAcYgRl6pBs6qCoZ80dT2tPwGHu6dTjLKZKOx/
	 L0tVaugoFeyaQZ7ueQP/LYnGJATQFk9cIQXd/ETnObvbW13RG/0akHsVS9zsAh33jP/1y
	 5lHhmNwFA+DdPkA9lA45JRRoOVfQNKX+vTTHcJRQ5BlnkGKSviO825j+UPqImipFmYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=KHgM79tV;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754E0606A886
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 08:00:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 754E0606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=KHgM79tV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=M5
	xvtH2FwKnV/bNu8hkgSYArlf9uhRAtbT+slgnh5EI=; b=KHgM79tVH8YJrjFwAI
	O7zVZCp+vs4cK3eu7Ylq6mGmUgFe/bG/EI5ZnrE+v5T4x7G6f7hMCp8i1J48a00i
	+XmSKajTARbHmenCGujklVcDFzspw8dSSKTzpa8iv1E759gcpzBvyV2fOfVEhI4K
	toMxOB+rymvG8DoPwwzjwggFc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgB3ppvXcfVqYQ7NFQ--.53224S4;
	Thu, 12 Nov 2026 15:59:20 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] scsi: lpfc: Free the SFP mailbox unless the wait timed out
Date: Thu, 12 Nov 2026 15:59:19 +0800
Message-Id: <20261112075919.1247605-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261112075919.1247605-1-yangxiuwei@kylinos.cn>
References: <20261112075919.1247605-1-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:QCgvCgB3ppvXcfVqYQ7NFQ--.53224S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFW5AF1fCry7KrWkZF1DJrb_yoW8Ww47pF
	43ZFnFqrWkGFWUGryYvr4DGwn09ayxZrZFka9rK3Wxur48CF90yrW5Jw18WryUAF48tFW5
	Xa18C347Ga15ZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jGuWdUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RmqO2r1cdnsrAAA3W

lpfc_get_sfp_info_wait() frees the mailbox only when LPFC_MBX_WAKE is
set. That bit stays clear when lpfc_sli_issue_mbox_wait() returns
MBX_NOT_FINISHED.

Free the mailbox for any return other than MBX_TIMEOUT. Check
MBX_NOT_FINISHED on both waits.

Fixes: ede596b1434b ("scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/lpfc/lpfc_els.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 804aa7509b69..871b78eff8ba 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7411,11 +7411,7 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 	}
 	mbox->vport = phba->pport;
 	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
-	if (rc == MBX_NOT_FINISHED) {
-		rc = 1;
-		goto error;
-	}
-	if (rc == MBX_TIMEOUT)
+	if (rc == MBX_NOT_FINISHED || rc == MBX_TIMEOUT)
 		goto error;
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		mp = mbox->ctx_buf;
@@ -7470,8 +7466,7 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 	}
 
 	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
-
-	if (rc == MBX_TIMEOUT)
+	if (rc == MBX_NOT_FINISHED || rc == MBX_TIMEOUT)
 		goto error;
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe)) {
 		rc = 1;
@@ -7483,7 +7478,7 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 			     DMP_SFF_PAGE_A2_SIZE);
 
 error:
-	if (mbox->mbox_flag & LPFC_MBX_WAKE) {
+	if (rc != MBX_TIMEOUT) {
 		mbox->ctx_buf = mpsave;
 		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
 	}
-- 
2.25.1

