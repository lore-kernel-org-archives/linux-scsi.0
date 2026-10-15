Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1AE2BEC45
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792023545; cv=none; b=CaxR3nbyLe0ANiQYKLP33JAKYWAVHfCGfP0N/bYlp7UGstj85sKZvEn91TIlDI1YJV6tqS64iXeAN0ztM4u+YOvDkZMIzuM1c4tv7sZSEVRR9+qRgrl00gOzhn42OcgRmDsu0gNH0raBK6C6P1Q7VRin6Xb3W9xFGHEHUUWTEYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792023545; c=relaxed/simple;
	bh=151ud4TxhR/44w+dF/Fo4X7IqdSZUdFRW4YkmG37VQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oGNCFzzE1gFbs53vuD5JiRaxQAmaTdKJGZstKKYhhxAmjdl/Rdj2gsZ9Hbe/YVKRb8Ebfk04BJ3u9KKO+gznqDX/yMgSDnzCS+kBKRVDuuBShd//JhYYN0RzgoD3QXtbBTBUWEiikdKYKiIRBY4gQuxz2jEMmSrdAyvTynzEA4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ChsL1DNy; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ChsL1DNy"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb92868263so3244718a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792023543; x=1792628343; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LQ467coIVi/icwn1gSoRQaLRewsTqMBzIfV1t0inAFU=;
        b=ChsL1DNyKGmxx/rA/2b0H0C/q8tFBNpLGv0VorcfN/5r93/NMKAg1ydeBdIqoIItnB
         1fclyM6Wr4eVcg8dTAYdW2WmoO0fwBflHAG6qH42QiNPSxQ4hra9GT31EslMToprm1nI
         5LmdiFP4AEdvUxyAlt7NX/yFy4i7Yn0fY8Ku7g37Zd0PxJORVBqOuGCl4D9lLookK+q7
         F/vHN6q86L4UNuHVo5w/dJtrPbw8FnnzpfmEM0y/8cyu6L43ftmC7qC2rsfe9rBt/SHT
         jLuEGQa4I56sBhraKV6t4HQCqmbp+CXTXWxyVDk2GFunYK6s32PUkrfCuWAUc7DvZsHJ
         uOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792023543; x=1792628343;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LQ467coIVi/icwn1gSoRQaLRewsTqMBzIfV1t0inAFU=;
        b=r8Gj/ARdYWlQ2aDBJd4xWd3ZSn2PiWx6e756eVjsiepOf9LnJ3Gg57roW2wfwYP2nw
         ZQ40RjUjyWyX0z8MFlT9ySqlPRLKVj7s72LCDLhIrgVlmAX3rJeLjtv9yJIlKvfE1acu
         49bhR74Yqjjws0e947RBr1jBUYp0XLT6pHP2op4fP0hJMoMk7w62bKSY+kWUjFindr7/
         9DgwpYwuiKNIyl6dvm/bz2C3OxQGxHzUqOVB8EC3GR8u4sXuIZJI/lkOomzz0nGL7T8e
         DaAGi0mpTgcKOh89xAE7+NUuClbVP7hMnGsjYSQJvrK8j90bo0DCRxsocXw9uOaEBoIW
         oZOA==
X-Forwarded-Encrypted: i=1; AKwUvBxGJRDpMfaKMBa/XgKTOhjoVnqrpWQ9mfLT6d+BKgAP3PDkK50G9oivQ2U9snB74H3QfzfvG1f2egD7@vger.kernel.org
X-Gm-Message-State: AFq9FYLTKlVIPK0GM9cSk24oEqOUBLSemuuM+EZumXXCLTdI3JSZZazL
	crDqF8uK1f9s049JvJwu0FYCHH1KaeLOf2MDZ23xS30API+6+3Aw4y5E1P07WQr1j9c9EaITOZF
	153Du2rBB/7Bem+/PUJVYCA==
X-Received: from pga17.prod.google.com ([2002:a05:6a02:4f91:b0:cc7:e64a:83f5])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:468a:b0:3dd:ff70:1426 with SMTP id adf61e73a8af0-3e16bb09ae2mr13677428637.3.1792023543278;
 Wed, 14 Oct 2026 17:19:03 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:18:53 +0800
In-Reply-To: <20261015001855.3450573-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261015001855.3450573-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015001855.3450573-4-stanleyjhu@google.com>
Subject: [PATCH v2 3/5] scsi: ufs: bsg: Validate request_len before accessing request
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufs_bsg_request() and ufs_bsg_exec_advanced_rpmb_req() read the
request buffer without checking job->request_len, which userspace
controls. A short request causes an out-of-bounds read. Found by
syzkaller.

Reject requests shorter than the structure each path reads.

Fixes: 64d4864714c2 ("scsi: ufs: bsg: Remove unnecessary length checkup")
Fixes: 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
Changes in v2:
- Complete the job on the early -EINVAL return through out_complete
  (added in patch 1). Kept Bean's Reviewed-by; Bean, please let me
  know if you would like to look again.

 drivers/ufs/core/ufs_bsg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 545ef7b79ceb..0db830e54ef0 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -73,6 +73,9 @@ static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_hba *hba, struct bsg_job *j
 	if (hba->ufs_version < ufshci_version(4, 0) || !hba->dev_info.b_advanced_rpmb_en)
 		return -EINVAL;
 
+	if (job->request_len < sizeof(*rpmb_request))
+		return -EINVAL;
+
 	if (rpmb_request->ehs_req.length != 2 || rpmb_request->ehs_req.ehs_type != 1)
 		return -EINVAL;
 
@@ -142,6 +145,11 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 	memset(job->reply, 0, job->reply_len);
 
+	if (job->request_len < sizeof(*bsg_request)) {
+		ret = -EINVAL;
+		goto out_complete;
+	}
+
 	ufshcd_rpm_get_sync(hba);
 
 	msgcode = bsg_request->msgcode;
@@ -194,6 +202,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 out:
 	ufshcd_rpm_put_sync(hba);
 	kfree(buff);
+out_complete:
 	bsg_reply->result = ret;
 	if (ret == 0)
 		job->reply_len = rpmb ? sizeof(struct ufs_rpmb_reply) :
-- 
2.56.0.385.gd3acb90ef8-goog

