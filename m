Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E82BAE2
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 23:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722034807; cv=none; b=pOyBbUaZSQGDil1ETTh4nEkfSEzJuu/9zf6BOmR+h0JxjAbWuTBs0CPlprollenqFFyPIrEs5oNrD5s6K0agq5CHZTRSdbfweNQvAEhPZvrUH1E805wW2lybCuqPbO86P9S78ssirBHDAxNOI13qEjlYVqJQvtXI8ONvV9XzInU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722034807; c=relaxed/simple;
	bh=KTvQTCs5FRJ9N6wykTchg0wPASaDTlQh/X0EIebEh6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N4aqxzZjP9PKXa7LyWdaKHIOLqqzcrD0LcV/vsDa/T1kYQMFeqPRY9qSg6Eo1Kw3iGRfCTzCddWpeM9fgFFwmuFX2/KaW4m+h8eLt60AsMROroNNbSXM3kMiP7HNfBdjvpkBM115WMsfVnXuJKrQWHSBpUxDvroEohj6UvANgwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qkyb2MjN; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qkyb2MjN"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3db10d8830aso169967b6e.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 16:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722034805; x=1722639605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUx43Ks49fCSXSh8Vm3DV/SnJp+l7FEdN9Tv2732TjI=;
        b=Qkyb2MjNhb42sh+6RqipA7azChFf1i6x6JhVKQmrVpTq+UGLcwkDhfUSCJfxwRZAHW
         JZn1V36ANO87uLCwjGHHLtdLeNH29xNg0VjR47GqlHfndk+wUHEtwAEMhpAKcc/zL2b8
         phf/QUGV0MIxYHCEAmClBoV8X1AxpQ4NtbTB3mnoP7/DxybGUDGetJJlz3lVIESI5F3G
         BAPWjBnapj2PkjYx6ck6SmUNbZFwnVyvSwOdXvTEb99/+1emOoFzgt273V9WQX3Ovqh3
         KnfHms869yTX3hy3PixrYZDWRfxw1hN25cwN88Hf52WwD3AheW5sPFZ3RWsb4rr92o0L
         +Oaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722034805; x=1722639605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FUx43Ks49fCSXSh8Vm3DV/SnJp+l7FEdN9Tv2732TjI=;
        b=iIiLzCyQ8eVlWGzCneU+9FNvW58SpFhCtiYqEsS51uW3v/ZstP1FbMFFfV17GHRbBE
         X5GchziNmoAN1XHEaZUcCkmh/dOZughf88kK+mlrZT0+j08qzcI/nUbhUHLSiTq7S0Rx
         H9crc9h86EPFf/ddrpy74bs9OxBoMGL50VAt0pZQn/RdXCv6GnmNfB8t4lFuUzzBE/rw
         n6Zypl92yvuB6mV8KyYZElmY6q8DqacjV8h5IdRmjz2S7KF9lzIkiFWwjlv1qmoSB/bT
         fu4UarSjUsMp9WvbxDGGI++MQN6QVMGa8evg6CxhrLnRXokUAbtmRMQufcJLxcmzxI75
         agTw==
X-Gm-Message-State: AOJu0YwBsGiOx6OFpjW7PVNS/sdr/KmlO5/63PwsrDCQRF8SQSNMmbnl
	NprkHep7a5izLMfeq44rG+Kg4w53zpuXSek3octjO7HywlH1IR5oEYctEQ==
X-Google-Smtp-Source: AGHT+IEBgeIMoRlipOld+iXLYz/jodT4/iT7j9iGH937arUrIZpmf16N4ZdvJ/CyzjA2Sj2kNIuxxQ==
X-Received: by 2002:a05:6871:e2d0:b0:261:934:873d with SMTP id 586e51a60fabf-264be1e0f03mr4669651fac.5.1722034804863;
        Fri, 26 Jul 2024 16:00:04 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8834b1sm3308540b3a.178.2024.07.26.16.00.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2024 16:00:04 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/8] lpfc: Fix unintentional double clearing of vmid_flag
Date: Fri, 26 Jul 2024 16:15:08 -0700
Message-Id: <20240726231512.92867-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240726231512.92867-1-justintee8345@gmail.com>
References: <20240726231512.92867-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vport->vmid_flag is unintentionally cleared twice after an issue_lip
via the lpfc_reinit_vmid routine.

The first call to lpfc_reinit_vmid is in lpfc_cmpl_els_flogi.  Then
lpfc_cmpl_els_flogi_fabric calls lpfc_register_new_vport, which calls
lpfc_cmpl_reg_new_vport when the mbox command completes and calls
lpfc_reinit_vmid a second time.

Fix by moving the vmid_flag clear outside of the lpfc_reinit_vmid routine
so that vmid_flag is only cleared once upon FLOGI completion.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c  | 4 +++-
 drivers/scsi/lpfc/lpfc_vmid.c | 1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 50c0c0c91fdc..6d49e23f6a62 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1099,8 +1099,10 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 sp->cmn.priority_tagging, kref_read(&ndlp->kref));
 
 	/* reinitialize the VMID datastructure before returning */
-	if (lpfc_is_vmid_enabled(phba))
+	if (lpfc_is_vmid_enabled(phba)) {
 		lpfc_reinit_vmid(vport);
+		vport->vmid_flag = 0;
+	}
 	if (sp->cmn.priority_tagging)
 		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
 						  LPFC_VMID_TYPE_PRIO);
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index 773e02ae20c3..cf8ba840d0ea 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -321,6 +321,5 @@ lpfc_reinit_vmid(struct lpfc_vport *vport)
 	if (!hash_empty(vport->hash_table))
 		hash_for_each_safe(vport->hash_table, bucket, tmp, cur, hnode)
 			hash_del(&cur->hnode);
-	vport->vmid_flag = 0;
 	write_unlock(&vport->vmid_lock);
 }
-- 
2.38.0

