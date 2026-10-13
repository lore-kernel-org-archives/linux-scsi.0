Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5CA42A168
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887363; cv=none; b=Ddru5ZfQ1roWrU2PG1cob/tWrpzTR8ysdHaQBdM/1oGColkuyvx3Se2+srupD0XWFVvEDIFWj8QVvK6xY96Mga8NQgdOW/v7hOlH5bVJgBSuFc968cROt+RDZMdYgyDFUeMNah0H/agYY8/s4YwiQn5l9P/MtOsI4Qqe0Xh1m20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887363; c=relaxed/simple;
	bh=x6lJXlnw+7kScGp+KyssmQC0Hf4Uca7kpbxm6mYDoZw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sNRqRNPj31Eh/ygCGGtTZpNYCA2DCB2d67CixiSJB3AfxYvVtWFoCS8trlyfvT8PKB25/xm6EHn95TGK0Vk/rZmfw5M5YQwrNvkztP6piSn0Y+I+ZM4RJL/5TVMzwJpqizSrgWEpVjGm6ezsJI60BZxV47sjbgOQl1ML9M3dZLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=icUNwOJD; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="icUNwOJD"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e60bb65626so30451725ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 03:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791887362; x=1792492162; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rjHP0ikJt34WZ/clkFc39YeDIx8IXxXSFzB3iNtX7ts=;
        b=icUNwOJD7N8eie3CRf7qB2s49zgTClW++D4bV2Agy7y9ZHoiVsTtOSfRc3UOt0MhH1
         JdRcvnt1PXbPqoQsZQIOZOqXpcjp4pv1OZ0M9pVfVC7R95cB4vHstnAUaYF/qf/FNLxD
         NTF22CEYCLTus3164iJs+hQSDyXIkl/od4tu4B+SWA+Fwn/6Tl85giKX3EEDedBWohIq
         fuGxpqm+BkkdY9bBg10EkmfPz3bzAIZrsKKF0LxV66GELJ0FdJtlt+6Da32eWQ/C37+n
         wf55cahQ66pTGSHLQw1zsA1uMct/ZbnJlTIeHUUFXhDaFA/IYSKDJmqTd/ifH1UvSkBt
         LbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791887362; x=1792492162;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rjHP0ikJt34WZ/clkFc39YeDIx8IXxXSFzB3iNtX7ts=;
        b=ugw85gLH7p+24Nd4N0ZXmVn0wGomAhwFkW3uf1Rm1+e+/z56Rknfs9pnCCp82Mwpwx
         D37jQzfOvwdWEGdZpC9Sfql+a4hCG0bM6pAPnZ6KEYYWXvp5VAwLRhfHuhv1nRhBNvvN
         bmr0UBsPU5xxgCNmdrJM4eJbHM3G0BpjO34N5z1Dl3c4Z9hjS2FL2oK/H395XwbN8pKf
         3jR+OU7EPKBI4cCdoVdsMr+jyVc2eD8PmBD2rQoxt1XFsjOM5Zj954n4uRmUlhMapw6v
         3DdU6OOt7JGUtQFQnXzavZe//NZskIHM1gmHVkCrNQjeLhMagFlI29bfGJUnfK/b3N6y
         9Tqw==
X-Forwarded-Encrypted: i=1; AKwUvBzcQD5mUSMyAM6Pb/xBNuZZQsF2+faNammIJunz/ZVG2Jn8tygsoxlhd56FXf3ujNdWwMMku+wmz8Kq@vger.kernel.org
X-Gm-Message-State: AFq9FYJItb248uaenDcnug0Q8Kwepb14M8fwx6Na9j4Bu1xOsT3V+cR3
	yvVw5DW1WJEJyY2oTOgHetkG/pv9x9bEcGSAaHinvPw9NfOqAbEwNnkF2kFjFqaVVRlHA9Of3Ry
	E4Uf7u6pLihd+kKxClhNe0A==
X-Received: from plei20.prod.google.com ([2002:a17:902:e494:b0:2e2:cb09:d4a2])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d4d1:b0:2e4:905f:5a3a with SMTP id d9443c01a7336-2e8428359eamr73415145ad.2.1791887361273;
 Tue, 13 Oct 2026 03:29:21 -0700 (PDT)
Date: Tue, 13 Oct 2026 18:29:13 +0800
In-Reply-To: <20261013102913.948718-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261013102913.948718-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013102913.948718-4-stanleyjhu@google.com>
Subject: [PATCH 3/3] scsi: ufs: core: Clear stale UIC result byte before peer
 DME retries
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: powenkao@google.com, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Peer DME get and set retry a failed attempt with the same struct
uic_command. UIC completion ORs the ConfigResultCode into
argument2[7:0], and nothing clears it before the next attempt. Once an
attempt fails, every retry keeps reporting that error code, even when
the device returns success, so a transient failure becomes a hard
failure after three retries. Each such retry also triggers the
WARN_ON_ONCE() in ufshcd_dispatch_uic_cmd().

Clear the result byte before each attempt.

Fixes: 64238fbd15ea ("scsi: ufs: add retries to dme_peer get and set attribute")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcc2512bf34b..9adb3b576e28 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4398,6 +4398,7 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 	int retries = UFS_UIC_COMMAND_RETRIES;
 
 	do {
+		uic_cmd.argument2 &= ~MASK_UIC_COMMAND_RESULT;
 		/* for peer attributes we retry upon failure */
 		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
 		if (ret)
@@ -4465,6 +4466,7 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 	}
 
 	do {
+		uic_cmd.argument2 &= ~MASK_UIC_COMMAND_RESULT;
 		/* for peer attributes we retry upon failure */
 		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
 		if (ret)
-- 
2.56.0.385.gd3acb90ef8-goog

