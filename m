Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA3033123D
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 06:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769150563; cv=none; b=Ar4fcFDHgaT/ujIikWi5JXzDDEh+ayalr31Xc7h89pWWxPbbmM+YU51BSU3RODiycRTK8VK0VbvzumqsXlQpzcTapcV/e9dOkhi8DAiMHYdRCY+nlUv0OcHLv15YFuiNaPRjRrAKGBlI5EZxZlfw7hCi4SW8xe/ISU5eF3m5hN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769150563; c=relaxed/simple;
	bh=v8zDSFJswmF+/AGepbHNQWVPx503rLiLvIUD+27gUQ4=;
	h=Date:Mime-Version:Message-ID:Subject:From:Cc:Content-Type; b=rhLLQMnbf0P4OUaOH9qZ6BBPweqTJhM905PuuA5Ms1XFqeuznjV8nBJh7o8SuntCrDvWRQxnhOWvL1JZRThdDUfAKrA5ZWJYlmKpLY8vL7px1IXcFRk6I+xAlomLtba+vT1DX3zHxQTKAneuJ2PkghnIGAA6t7ZxzsfFCa1Q59o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A3Tww0x8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A3Tww0x8"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a08cbeb87eso19931915ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 22:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769150561; x=1769755361; darn=vger.kernel.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aJum4he8XKCfmJ0Ge6gMPtssceqijPUErFm860v49vU=;
        b=A3Tww0x8jCQscFVSLWRvdXewasaSpoPgHfhZfZRwykHIjy6CVFliv+F86PLyeJoFuu
         eeBKZ9QGEpN577L8G2RtJqZalnDiw986jv549lyCNbzi7uLAdKneJ9N0gOk1DjPf/VJj
         AEXTziyLJrzr/qPgY61dxFLz538lVE4YX+uK4X0eTOlzyLiX3Jx1OR8B2pIqaYh/DCCZ
         ezPCRwOzZ1NMxkOaTEKd4/bjAtU5ZGd3yWwHcKhLQ7aD9ONIAA6qQNDyVkUVi5+wabSw
         o9uzsC6v/uGHfXNZV7PU22Dd0ByTYhMCe/mEpSP0oX6blmp7Wb3iSd/04qz8MjoO80UN
         +e5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769150561; x=1769755361;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aJum4he8XKCfmJ0Ge6gMPtssceqijPUErFm860v49vU=;
        b=ejeOiKZ3KM27a8nwQVstVu8wfkMZyj9ISDqnWfcfhW+M1nUaafE0mVWBqJOgTB79AV
         6U3XA1oVmexUJ5tdN2uFsooaiMp/LRp/+SSNgaRS7xuci/vzQSM1XkGcqTEj6QM0NCQD
         Ul6X86+zYCu912/fqmofePWenKQGtYkKfgLdHw3wfv/yZwTdM5bZBOZ8zS3SsBaCs+sU
         cov3fmz4DIFKNS6BF79SU54gScNKZbxdpRE12MFQtzvmXRh9T8A2oAgA40sb/+GySeHo
         WJGOSKo6eGhg3CpyLFT7ZAJp1bcAy4ZPsHEDI5u+JYVebmsJY8TFncxVUg/swpYYH9qx
         jeaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHMa9zyj9mD8Lnx7OE7n/rxPc/y6MSjmlMCxcVy8yTPnwaTW0fs1lDfDsYPmOH0iFmQMwfWWR9AMr9@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8wimZ7gf99hY/MrCUU4Jn7SKw3aePWs/VA9bNhugLA8Ho0Vyg
	yZXHsCVL+CgNaLZgsngKj/GobMteUyMkH+Mc9zEklQAfR6YrbBdgs4uaF4nkLSNQxsDxNrYN1XE
	RcPw0UQAVys4NBg==
X-Received: from pluo13.prod.google.com ([2002:a17:903:4b0d:b0:2a7:5e40:dcf0])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f681:b0:2a0:8be7:e3d0 with SMTP id d9443c01a7336-2a7fe44aa95mr15382595ad.10.1769150561197;
 Thu, 22 Jan 2026 22:42:41 -0800 (PST)
Date: Fri, 23 Jan 2026 04:54:51 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123045504.3507948-1-powenkao@google.com>
Subject: [PATCH 1/1] scsi: ufs: core: Schedule EH on WLUN resume failure
From: Po-Wen Kao <powenkao@google.com>
Cc: Brian Kao <powenkao@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

On WLUN resume failed, core driver leaves wlun dev in error runtime
PM state without taking further action. To ensure the driver can recover
from such errors, this patch schedules the error handler to perform
a full reset when error occurs during WLUN resume.

Signed-off-by: Brian Kao <powenkao@google.com>
---
 drivers/ufs/core/ufshcd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 057678f4c50a..ac4db8484ee5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10236,6 +10236,15 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
 	hba->pm_op_in_progress = false;
+
+	if (ret) {
+		/* ufshcd_reset_and_restore() might set host to UFSHCD_STATE_ERROR */
+		scoped_guard(spinlock_irqsave, hba->host->host_lock)
+			hba->ufshcd_state = UFSHCD_STATE_RESET;
+
+		ufshcd_force_error_recovery(hba);
+	}
+
 	return ret;
 }
 

base-commit: a9e03ec01ef2633288fd1b506980f54ae41c5a85
-- 
2.52.0.457.g6b5491de43-goog

