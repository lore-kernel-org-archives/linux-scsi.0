Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3C63806B0
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681506; cv=none; b=ZDhThhPZl8Fe2guch46WBwOn5OY3nyhwkcFCrZwLXhz5NnBan3E+WDFKUb1fsrcxffbBfY26DMweSGB5W5iuO2T2FfQgUD665qUXw+cWnfRHazOAYuWD2gZwsoEC7qJfZQftlfcKbPRrPTznIhzF3twaGpC56VzPbxj5VU+3v3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681506; c=relaxed/simple;
	bh=XDJSA9ARqSXKjDURqUbtMPI2B17diU6ylGKvLmSJAVw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MmTf+Z1d5RHlUBXuxVDxI+DSf8moNWqspZZ9bxfxwol4HxjMSqY/lTjxzkccM+5MhzIIAVVx+IpUhBzjQaU8y0fCVSn9JqVxNIUr2hjMkUyUQuW+ZmGynVMkg7P6r8lhE8841m/6i/NQaqPfXXOGGrdhkBJKOYu+KfHSnv2FjF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LuMo8pBH; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LuMo8pBH"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5174a3d9598so19542271cf.3
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681495; x=1781286295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dmCG1d3AlAtiNH3LEYA0GcaDkoTjkg6k8fP4s7NLwiE=;
        b=LuMo8pBHkeHe96Ml2yH/A+Eij2tHU9zKBlJ1cBCp/FHrCKvZZjvTNr16nu6cbsTPmf
         6SQ3hluSP23+dfzgTaYwuwNazxqIOCzyxQ3L3I3yHs69rO02BqrZmqMpEaECMv/L11Pt
         YOtb/f9h9wiJUmhbXVryoGofURhtJyd1EGqlEoaGkQyU7NuOLoe7Eg3QkpP48EUPL95m
         UHboqDdasbEwAWfX76G9W2JBV4Lem3vt+C4EfQubb6SoI2dmL0Kb35wulstbtW6yUUKo
         GglkFOoHTSxOVSrucra7Fr29k93uTRhGT8YmYgDoadnk3AvKWnRY4HzfXE3CScxNNj18
         r/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681495; x=1781286295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dmCG1d3AlAtiNH3LEYA0GcaDkoTjkg6k8fP4s7NLwiE=;
        b=CgO4XE893DWCqPO1iIkwRzhoHY2ul4JMfOZcA7/5ygQXTcH+TVrOOaM91G01nXuASV
         QKFlpPHf134bEIr5Hl574ArCIyBMvc+tSYWWgnH5/xSNmi1QCXUbXbAT2pM7HkQm4jpv
         tXw+z+csbTXWiVkvV7fMKZW/j3gsT4Nw1E6U6qAHIBVSmzGoRTFHHpLqM+ebmyZryz+w
         K+Rn2oXhEHrEkoXxzFCHpU3qFiwg7+bQt/qz6sR5E2zjFw8XZuukY0j/zLCcf7X30mao
         cutt1pGHIXktqZWn6lfy+1DC/fI4TBlkRl/KYUEhcU0kTd3AtySS3F1cqNeh8BfmQySs
         TCLQ==
X-Gm-Message-State: AOJu0Yw/btizc6ucU5Ut9nRPJwE+j0TRFXGlNvNJhV0PvLOR3R/qKJ0T
	TMMInIOVXgXi42bHWR0FHgXf6Fi/Rkhs19Hi9CC1hyRrb4td7UNmY3FIKiRGSGnc
X-Gm-Gg: Acq92OEIzHFmCWDTdAwQZhaWjP6kgEHJiPqCwiJ/XEx8Qvy/NBzBtFqnMV33u5nAixa
	gA1YbiDdRz/G5gGgx/K030xfoEZRxGAfkMh7LgpMpg1aAanPUNPITXvr+rjyq/2e6DVVh8GYntE
	VX+NMqjMafPLaaa8EmvJp9uvYnRZtv7P/z8vgtdbYO3jKyncAX0gDarZPa0z5WJ5oGLLVUqLdBc
	kh9XZwJZpdp/D4ukuPpgBm6UuBANqTSIah8G7jmlTzkK/UOzVdZAJHo3dlhNMWxY3Uh0dA+nNM8
	4kuYMBNCOyabObXh6b0Xt7apTy1Oa2+fUzSHgu4PGcmu7gtExLyRkr76DtwdhNQZL0YRKpf8HQJ
	FAS7wswQZiWGI1DIAii1+lvu9n0JAn8EZs5omPkkwQhipRZp/iOxPR/uUcq4xvBDvQNv2KlskWh
	46L+NUo9pWfLlfgFwnwLpPSMCy6K3CNZ86tUJUQkULCQKfs3GYe1CqmqNhrc2aywQJogASskIBK
	TNbyXyyxw6qLUf4jcI72mKIhT3qZ0p9HtN5f9G3antmBEbH04q0Ax0aT1xiFMHg
X-Received: by 2002:ac8:59d6:0:b0:50b:38c1:c6a with SMTP id d75a77b69052e-517959fdda5mr66006841cf.19.1780681494607;
        Fri, 05 Jun 2026 10:44:54 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.44.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:44:54 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 01/14] lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
Date: Fri,  5 Jun 2026 11:23:23 -0700
Message-Id: <20260605182336.134919-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In lpfc_cmpl_ct_cmd_vmid, there is an early call to lpfc_ct_free_iocb when
cmd is SLI_CTAS_DALLAPP_ID.  Within lpfc_ct_free_iocb the
cmdiocb->rsp_dmabuf will be freed.  This means any ctrsp ptr dereference
for SLI_CT_RESPONSE_FS_RJT or even ctrsp->ReasonCode and ctrsp->Explanation
when handling a CT LS_RJT response is a use-after-free.

Remove the early lpfc_ct_free_iocb call for SLI_CTAS_DALLAPP_ID.  There
already is a free_res label that calls lpfc_ct_free_iocb so there doesn't
need to be an early lpfc_ct_free_iocb at the start of
lpfc_cmpl_ct_cmd_vmid.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c7853e7fe071..e14170550e69 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3595,8 +3595,6 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int i;
 
 	cmd = be16_to_cpu(ctcmd->CommandResponse.bits.CmdRsp);
-	if (cmd == SLI_CTAS_DALLAPP_ID)
-		lpfc_ct_free_iocb(phba, cmdiocb);
 
 	if (lpfc_els_chk_latt(vport) || get_job_ulpstatus(phba, rspiocb)) {
 		if (cmd != SLI_CTAS_DALLAPP_ID)
-- 
2.38.0

