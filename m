Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF9D347C7
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599048; cv=none; b=hYzF2S62HPfjEJlm4GcaugLbMKiZZNq7wf6kfyNJbxAh+R/g5p8aCPXJU6C9McKKAtR3XBPWQxWZcVnKZcl8T7KZ1xxM4hQaCM5m2UruvoN0GV+YR4TJhIiqCO6u7uc6ySA8Y7R452yNrN3ajHQZt2vCmQowc8MHFUYr2ALRHrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599048; c=relaxed/simple;
	bh=XDJSA9ARqSXKjDURqUbtMPI2B17diU6ylGKvLmSJAVw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V7Vj+tUB7TV0EywpCq2OdJWQhwLVzH7X0WFQRjOR7X9F25+Umd9r+8uCHlXnlZVwTnmpf2xOAuislCw30MVKhB4tEackX5yNEtubsfdF468FxRa6RMAFddaAiov7ozOl8NcGl0e2b9YprmPNZtHe2f8P0wAMVLA2PedyWPh8bbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQV2duQk; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQV2duQk"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-91563abd6a9so49982585a.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599046; x=1781203846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dmCG1d3AlAtiNH3LEYA0GcaDkoTjkg6k8fP4s7NLwiE=;
        b=JQV2duQkSYT0CKTeKXf00ad9vTAT0IL78l4EYG3RKkHioBaEBLlHzmU4nP6+AHa2ES
         ljbVnILevREEBTI1+0/ZYQx8IUIAeHN5bu9gMRSf4REhGYx9AbL2vSusj7GIb1gdD0a5
         53F3x/wo7tMB6kGvzsqSpY2o3UTOQNZfK/aHDVbBLOKBSk5go7adCZP46Dy2MvR7uo0o
         C09xgAq8ioqpwU35jjHY1rbxWguz62F5qO6SdtvcxRdqrYy3NtXX/l5+5dBJ/C+21SeO
         lgCz2nMjSEhqzVmCx2bbIBu+JdO56vxoTvFRVT0tEl7dBpL0Lw3KYBk8S011q2dU/nF0
         Uesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599046; x=1781203846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dmCG1d3AlAtiNH3LEYA0GcaDkoTjkg6k8fP4s7NLwiE=;
        b=b6n5Ib9JgTg1Mp7CJPHY3oRnu4RqeqpGAJ7IhJWCRZnfu5O+qCS94Ym8SaZqYifeCp
         0fbzE65jJS1A1+czaUNGcytcW3XpKWeJGHE6NayKedLDTNxYBm4gLSrmHkvzJ1/CYadr
         zNbz9gd15ZUTHtQ+Kf1FUM58bJEsVSvlZqZZu5y7bamdFohzwyfAeskNL9NiOxn7gJQx
         zOVtUTFX5arcr4vVdTp8S8NEPZvhE6+rFSK7gr1rTLOMyttmrcot1X0fin3iXpQJyG5J
         LcmOVunozlRGdF5agS5f/Zl2L7KJTTXr6TZMP5i/GMYr8PB/RAbbmBYT1j8gdgOKEF7Q
         jfpQ==
X-Gm-Message-State: AOJu0YzzZrb9vHprf7hqO2RbJRhcXknwFnKayOJUjuo04wjZoLukmWST
	lUH2R2CqeMAv1zVQQpNwsjWTkXSBRLc4b2CWbqn35Rub7mRN73SMhWXWzDQX8S6x
X-Gm-Gg: Acq92OF6yZ6dXoG+dV2sNFstFvmTqOt3/U0a+7RGzbSRmhp/NOm7pIDn7TknCRQGeDi
	F1nkNhMseKIvPy3btxYqBNOgjsExuChS9hpD0meKC1Ty38v86VRqufYRimRzNAd03Er8C3mHgJ9
	RJkSi7ROuJX1xI0mq80zxqIkyE0gjmObzeD8wGilvmBU77rJFDQiybnGlvnnhE0V9oN+jSy6cB/
	wr8dThHGB8Fb8O/OvQLVhiAMhv9zmxx1fcy4apkjN8gJcCJ8FBhLVntE7G8dlfEd79yCThSGINn
	JBQjYoOe8UMyY4Dk8+TmkKLKEMEzGhq7pphWizhJlbE4lMCe3FHHQNatpUfiHDmL7XHYV7464wN
	ebYyaPucVkebV8eSd24Z2dInrknh5/p3rVcA3hlL4FncUVx5dD8qK8GPBBi8CLZA0gvApgYGQTs
	PJJsy+y/p3TaDHMh2Pna5+Rl+c5YdjiSmMoFUiC2HVMJYBbf60WTyV6gs4CqHYxGdU87ctWcnXU
	an1uycXslHw2tBs01FLxZVK8m67QZTd5GEDoQfYwoJEtj4NVHjh+w==
X-Received: by 2002:a05:620a:3190:b0:915:7d5d:bbc2 with SMTP id af79cd13be357-915a9d61ac8mr74417085a.37.1780599046439;
        Thu, 04 Jun 2026 11:50:46 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.50.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:50:46 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/14] lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
Date: Thu,  4 Jun 2026 12:29:24 -0700
Message-Id: <20260604192937.65605-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260604192937.65605-1-justintee8345@gmail.com>
References: <20260604192937.65605-1-justintee8345@gmail.com>
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

