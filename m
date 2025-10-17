Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0817013B58B;
	Fri, 17 Oct 2025 07:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760687744; cv=none; b=jp0qruIradUL1F39VRwV3YpJd8ZlRTtlPNbDOxu6k3EpchyTGuJLppLij/FONZM4PycAjZC1lWODP8BrXYJJVr6JWtAcRDB7GnG5p+xBG0JTAYR4Yi972WvEPCMj4WtRBgYHi7UIJHds3dvh72sBwlGwmTfho/A9UtXWOYSmyaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760687744; c=relaxed/simple;
	bh=2fz1S3Kzkgsjs1DYhI+q0hi82bc7Ka676ydtOGJ+ZaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BYJygW5HjYJFcGuThgaghTeEqQ/cB5484znTSYNxhCzXFdwpe3RBzDfxvmo3G7VwECwKjS1vRNm2BOVnnAqc6ZcSm5JXx5CjPdiiyhZF6aycB/vkAyQIJYS4X3oCozvBtcn1oK6XKNC+VzPQwhRcbcu+B5yksR8CWO5TQcOnQv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=hHX7cuNv; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="hHX7cuNv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Mn
	u2oNtIWCNdbYeygyyRsLrXV5t1jA6LgAK0JbxNW/I=; b=hHX7cuNvsAtO+FBoJp
	Otog39NnON2BGdtVXRoZ/rEXJIQ6VFrtd21OprAVi+Ml4lIG6HHHYpNAwD+32niA
	mCpJmtLRz/QWqsM+CkG8LBzlEQaD893YUojB6GFvfNnb3mxBfQnSJwVMvi6tra4s
	OFMnvZljqwuQIKuGIbX0fZaMI=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDHDxpc9vFoBuN0Aw--.52908S2;
	Fri, 17 Oct 2025 15:55:10 +0800 (CST)
From: liuqiangneo@163.com
To: satishkh@cisco.com,
	sebaddel@cisco.com,
	kartilak@cisco.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH] scsi:fnic: Self-assignment of intr_time_type has no effect
Date: Fri, 17 Oct 2025 15:55:03 +0800
Message-ID: <20251017075504.143491-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHDxpc9vFoBuN0Aw--.52908S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrury7GryUKw15Kw43tr4xWFg_yoW3XrX_Wr
	WjqF1xArWFkFs5Ga1aq3y8XFWav3WUWwn29F1YgFyfA3y3ZFs5J34vqrnrZwn8Aa1UJFZx
	WayUtr1FyryDtjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8LvtJUUUUU==
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/1tbiXw-pYWjx8LOOpwAAsr

From: Qiang Liu <liuqiang@kylinos.cn>

Remove the self-assignment statement of the intr_time_type variable

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 drivers/scsi/fnic/fnic_res.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
index 763475587b7f..9801e5fbb0dd 100644
--- a/drivers/scsi/fnic/fnic_res.c
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -134,7 +134,6 @@ int fnic_get_vnic_config(struct fnic *fnic)
 			    c->luns_per_tgt));
 
 	c->intr_timer = min_t(u16, VNIC_INTR_TIMER_MAX, c->intr_timer);
-	c->intr_timer_type = c->intr_timer_type;
 
 	/* for older firmware, GET_CONFIG will not return anything */
 	if (c->wq_copy_count == 0)
-- 
2.43.0

