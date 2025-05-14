Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F6143169;
	Wed, 14 May 2025 06:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747205497; cv=none; b=pmOM9XgLC9eNwYmA86yqYr6ujwwBx4WWhWYIeh5tlplhs0MowFlV0POGhkBdRJfnddM9fzUE+JU06e5LsEc/mAI3VkwIHd0/+QkdIsAaYGRD1sWt4NsbQd0+Evjaa42I8mv2omOzVe9WEcV+xfA3LXTkkIILCJRZaLG/tUpt5BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747205497; c=relaxed/simple;
	bh=YBxUu4TioOt4F0fv6RAI3RhObBFewp3fW+Ad/gcp1wc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QvG/aUFV7aa9B0tDP67WHr7cWcJmHxfsTU1rDD6DGxzQI7kmXGRpVkuqy5HsIR9X9XCP3DbgQBcOlGD9sKrIct7Jk8qTAab1mb9CVVtbg57DBRAGnRFgAbSDK5NM5A8hfGntSmMmnjJ+ntqPGPmeIfBoN7JIGP9ANwOXlaxW8nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowAC3YT5rPSRovvn2FA--.56077S2;
	Wed, 14 May 2025 14:51:23 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	mingo@kernel.org,
	linux@treblig.org,
	tglx@linutronix.de
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] scsi: mvsas: Use to_delayed_work()
Date: Wed, 14 May 2025 14:50:41 +0800
Message-Id: <20250514065041.2514034-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAC3YT5rPSRovvn2FA--.56077S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw1xJF1kuFWxCFWxGF17KFg_yoW3Cwc_ur
	WvvF1Igr1Yyrn3Kr93ZrsIyryvyw1Iqw1vkFsY9ryrAayDZr1UZ3WUZr1UAryfur47AFy3
	CwnxWw43Cr1vyjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbsAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFylc2xSY4AK67AK6r47MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
	z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
	UI43ZEXa7VUj58n7UUUUU==
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Use to_delayed_work() instead of open-coding it.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/scsi/mvsas/mv_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 52ac10226cb0..9e48b8efc375 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1693,7 +1693,7 @@ static void mvs_phy_disconnected(struct mvs_phy *phy)
 
 static void mvs_work_queue(struct work_struct *work)
 {
-	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct delayed_work *dw = to_delayed_work(work);
 	struct mvs_wq *mwq = container_of(dw, struct mvs_wq, work_q);
 	struct mvs_info *mvi = mwq->mvi;
 	unsigned long flags;
-- 
2.25.1

