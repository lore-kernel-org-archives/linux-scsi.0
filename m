Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90F73DA7C3
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 07:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779176585; cv=none; b=qUuPKC1dKqaW7b6z0Y/r3rxfrBTSo0b56v7r/U2T40yiR5jnVH+O5FP9Rhr89jXVibYjWGH1Y4uGx/4C1kMJ/i3LR5rVyXkr2dTmMstpVNTza96fOfh2P9nsvg13d818uZNjtUectzmMs9aNU2Q/KuF6X611AD0asWnBwZVlvFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779176585; c=relaxed/simple;
	bh=PqBOXKIcL2LFH254HZC8CVkLl+stNhZQ5ZbAKeES868=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XTRaDGizeykLkz9Qjtg0WvEx07iT4FnCgGMQmvHbOP/Q2fVubW37xd2ubW1oGss+viilXa3NuM6u+UsfapCpmhFsv5MSQLwAZYUazFf2jP7CH2FIgbKuTBwskisDiqr57sLmZ0DepHv3Yzo0u7sunNXE/1cREUiVxRaUydxnDeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=fcibrqSu; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="fcibrqSu"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-839dc688d6cso1310539b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 00:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1779176582; x=1779781382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g/tERIhcgTY407JXDkFbxFgApJOVjg4hy+8W+lvT7Ww=;
        b=fcibrqSuE6qyEsDuG9FMrvdHztLMUk42O/jagA/vo8hLB09lWyKo6ljvNwpjWK2an9
         xKlTUlMlYADUKa6xCE+KFseSaCPvD8pZxO12gPo8lKY9qfKp5/yqdKaVFG2M6LNr+6d4
         9KgShMzZy8gcMk/2iDVERHM5MbsYnxnew9wwwt6HqqbSXcKq56ztT3+pjGWUeo1qyfXi
         RonPNy0l1157I5JgY/5NYAj5v0EjvPHqTwHGgVFNL5zKXU3AxkLzBnweAWgLPaeNCkIR
         IU1KfRxcHEyU0ZFX8uZauyqxq3OL/NAeHURmmF/aLQAE+ZcW3NBxpsZfJFNhLfUFFyTs
         Q1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779176582; x=1779781382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/tERIhcgTY407JXDkFbxFgApJOVjg4hy+8W+lvT7Ww=;
        b=FD2HV3gsJEOfbFcqlcZ24IQvByJNx0AtrnejAZEQspuklhzIaXNjVvFXXkrFbG1WYM
         Y/e0Bx+aqUWwmhDBy+LB4lBwAZ2+8V9d6FFQ+8nISpwQgYx9dioHwe4G11SyvdIsu7e/
         uoEaFXZRf6QIAKduuwGlr/MG6CzgipF7wlVwZpSXVGK4A+J4nrsKKPNIKgwYdJcF1X7t
         tW3Maj8ulcUz/3fkGZvcFd2C35q3WN2wiV+6Jxkke0ds1n6gzkkuzEUY8oBgBqx2aQKI
         4cZu5gICNJcA5ZklnLmXvXsiJptuOMKw0RDBYoeFOSAngLJjprUjYsYC1gRtKIVr1S0j
         PyHQ==
X-Forwarded-Encrypted: i=1; AFNElJ8uZG/ZydCVl/9+ujdTCNtOCKdRGh4o2KKimx9RmllqgZkp/TfuKENu0dH1dZS4sKSg3q/diAGP8nzJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0EFyU9kn68H5gq8+9NTzJ3ubFQt780HhQjwxnJSnJB4/Xid6n
	D/9xrzTPbwpCYp7FF7NtvdKQEtmgtFcu1nHej0FMH2pyfLSV1XEGPO46vFV4T5MvniVCgrFqwYV
	h6/uz/ss=
X-Gm-Gg: Acq92OGMvZLu0VqOpGPW2QaA/crKedVIkjtB3RGfGGfoVr+e9y2Gp67UEekAryFOPUV
	FOjWu7Z+pjRN5jT+dUBCS5zgb0nky22XaGmlIu4wMELHQr/rJM2K9HiByyyRYKK6kUhzqgkizvJ
	gv9lkOzVSvQq3/ctbNduOLxIm6TlpKKEgWQPtxNbeFe4Uc8SNnAuW0cJgWkov4gCglbm20XMjPv
	0bGzNT//9Jxdbw3MijlSuLhDf+0vnqVbDR82Q7AFS7LsmEcGIkIX459eelMRkPbxZmhHnQd/8fI
	nF7sNsqvkWE/2FvedwKQtNXdmQ9Bpnzp9boNtKlw7ogjikMq9+SbRezkNCm8oQzUkvW/r7TqIkj
	dB36AORj1jtXQw0aF/wcTVrFCBoN+RaINbllDm6Bnmwlqo+5p81Jd76z/X8f6MOhmDIFxvObY1C
	DD/3ERGqE25lP7wIQZQfnrbkfSaPaonv56BSdhiwuK40ylS2TWXLIcWPCwm4wuVGC8FbkQWrLUl
	LhJkku1FCk1oR8MlGvadaZwgcXZN7S1CsnrAkrZpNY1r/sVzpBSMdOOzA==
X-Received: by 2002:a05:6a00:1908:b0:834:df57:9d67 with SMTP id d2e1a72fcca58-83f33cf0bddmr18987872b3a.32.1779176581994;
        Tue, 19 May 2026 00:43:01 -0700 (PDT)
Received: from localhost.localdomain ([103.158.43.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-83f19f7cc9asm21029127b3a.53.2026.05.19.00.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 00:43:01 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: justin.tee@broadcom.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsmart2021@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] scsi: lpfc: fix potential memory leak in lpfc_read_object()
Date: Tue, 19 May 2026 13:12:28 +0530
Message-ID: <20260519074230.110624-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory allocated for sge_array inside lpfc_sli4_config() which is
attached to mbox, is not freed in one of the error path in
lpfc_read_object(). Fix that by calling lpfc_sli4_mbox_cmd_free()
instead of directly freeing the mbox.

Fixes: 72df8a452883 ("scsi: lpfc: Add support for cm enablement buffer")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis.

 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d38fb374b379..fe7d9942ebd2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22302,7 +22302,7 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 		pcmd->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &pcmd->phys);
 	if (!pcmd || !pcmd->virt) {
 		kfree(pcmd);
-		mempool_free(mbox, phba->mbox_mem_pool);
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
 		return -ENOMEM;
 	}
 	memset((void *)pcmd->virt, 0, LPFC_BPL_SIZE);
-- 
2.43.0

