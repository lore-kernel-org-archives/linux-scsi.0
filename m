Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891DC2EA15C
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929737; cv=none; b=X9QNjOTmZFEWhaAQaVnLRHNeC22EKgZuo9RiuJFHaOyfwKPsBmnjO0iPnLzptMX7eRWXP/bHjdLQJQ5ZWoA1OKrMu4qV4c/ed9cg/cdqsiJkzxDs9IMp6dSwBm154QJUPerpBwwEf7FBUUkMUEoPZD/KiWrW1JJ3sXsQWiytY/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929737; c=relaxed/simple;
	bh=Xw+G7ZtVaCvwPg3LY47HJZQyFROrt+Yv/jhesgnmv9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tf2PWu6UXnLeFCSuYFEH8Qh/ZkgE1E3F9MfphWDBi/3Cl+mZX7tOo9YCuByqA9CV7AMYgpuLQj55u/7P09c7yer3KnFdP0W63Hdhg32T6lWJaKoL4/ASNMa1Kk0bQV2Fg1QmVVHkySNIdZ4RxTi7TsiDIYBgSgFHQm2jMJNWRb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Th9TfG0v; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Th9TfG0v"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8947404b367so3312406d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929735; x=1771534535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Guxj2g55uGJ6nFTk7mINRabezBxQFUozTCTb5c3zvCo=;
        b=Th9TfG0vtTrkaWj+cJg2xXJJfDMS6fameJYmGO9cf6w97hLy9qv+E/UPx3xmhdZ/4P
         ZiQi5WMhNpxpCk+GSyISFZXfow6L5hg6eJTelwMQnBawiI74VHSs+ORTX1e5kAiVu1zr
         7zCfYUY0ZG5ugc4Q7RqzW9AeUt9/AhNcB5Vrb/qMsfeQclfw506YZwjRDPM2nN4Xvzb8
         M4k5Rxg07rk3DsgeICdfLkOqqmrisZ0C9gA/Dugffjhefe644PHBa8GeWdhAeBHOLTiM
         CkeCd/NM17lzTq8PDFb3Lquq0hSKYBcJi5+JS4FF0YDxU5XRLEAPEgPCYvFVfdRxX7Vj
         1Enw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929735; x=1771534535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Guxj2g55uGJ6nFTk7mINRabezBxQFUozTCTb5c3zvCo=;
        b=H2/CTx4YMeJp6TZ+rGdb2rSc1yTMTiIiEbxEpZeq8x99LtfyXljF9tg5wP4KJuAvHR
         T8BZSO1+SJkPD36RQbCVK74P/P7QCQIdOgBIF++R98vtl4dPMjXHCU6MWGsKp41T99kB
         yxCqBvTY3JmrzqGbN6n5T+5Y+SWHrleXC5z9lNICKOrKuOVXlWCjVMh7h6QAT+HRPvoi
         m6bideHlzvR5p84gLVbtyMn16jSxGrhOSoDAy/wO8pRlyl0Ts4WLJnz499w9kuEzApQQ
         yIE2FZmeaQ9r+FAaxmEx7xdJN3aodcspQxUNIIX7fFtdlGGyzbv09YCjp/CrO1CFuSl+
         rylA==
X-Gm-Message-State: AOJu0YxNQ+BGXdjfIxm8IGARLSpgnnljlaGxCXBx5ChKj7uo/AHpmkDi
	uzRIZjg4RGHGjrOnNWLa55H/CNnsdAyfKiAvlcR/b8E+hmZh7XmuMdz6IhjwltfD
X-Gm-Gg: AZuq6aL3bdE6optJ9dzS7aSHdukF0pI6pA4k9Ri+KLPrS8fOUpQ1LjP2D/DgyUi7oOG
	HtUlbchyIfaEGnL8YunUxgREzAMpi09rRBGB6g/XcvGk4GbnS7kh14PorbEUbfRgjTJkncCFuxj
	NUR+/WdDq4Zv3FCu0tN68YyG5iMCyJiwdoRzqAweeMHHNc7dVIDE8wzdpiD9mTHu0Gl8D/Vb23H
	Xc9r7YgU7yh56bQEGGmNCN8/NoI11dBvVjdIlfl4j/8xX+b1D5TdvkLnpUZCmCHfYGAF3Xhjffw
	hYpN3dOAH9LgIp+MN47lJZur+WezogoZKvIbndVLREkifjAOSABAU8bmiwtcRauFAISyHFaGavK
	VOv4N2k/tKugtf7rtqGXWZ3UZCUp/VhFL3qU0A29ErQL+5MwxrfNlPiCzQ0MIKJq95K0MToo/Eh
	bUEP9VPWPwBHM2OXDdO40OIcGFKi+dgIkA7L3cJ1Qfs7N//Yo6/YO0qAC+Rkvuwp8wqmrajxngN
	jQ0iFWtgX4=
X-Received: by 2002:a05:6214:1cc4:b0:894:7cd8:59b2 with SMTP id 6a1803df08f44-897347dce1emr7189306d6.58.1770929735295;
        Thu, 12 Feb 2026 12:55:35 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:34 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/13] lpfc: Reduce pointer chasing when accessing vmid_flag
Date: Thu, 12 Feb 2026 13:30:00 -0800
Message-Id: <20260212213008.149873-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For all FLOGI completions, the vport->phba->pport pointer is actually a
pointer to the original vport pointer because FLOGIs always complete on the
physical lpfc_vport object.  Thus, we can reduce the
vport->phba->pport->vmid_flag dereference to simply vport->vmid_flag.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 019851da8766..e5736b06c3dd 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1107,7 +1107,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		vport->vmid_flag = 0;
 	}
 	if (sp->cmn.priority_tagging)
-		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
+		vport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
 						  LPFC_VMID_TYPE_PRIO);
 
 	/*
-- 
2.38.0

