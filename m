Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7F521ADA6
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609081; cv=none; b=TYisb8qTrQ5ImJ0hB70aQl4AtzK+VdmkVPIV50wcEjPNmsCsZsuYf+IwiG4QHX9le+ewZN7XPtABYc3OzQpA2roTBcmz1IGui8yWopDtLtXD8djMw+mO4YXy2v5Q2nh2rS+s4SMs+UmWJjcz15h+tvKlmpVZvOdHfBOutMvzsuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609081; c=relaxed/simple;
	bh=cq3Xhf/r6ZPfvd4t32Y/fkPGn2McQMtUSOmw83M0JZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ngGIIluRlxpaWEpSp24Uv07St2YHBdfJi5FPBiZ+nadNZ6UItwgAM68O5IGU1j4jSqDtXuWpBdsZr4dhJbsvUL66B3cAOa1NmtvFxGvRzuHTXOZVJ9FD3Gk3vehRvRvqozUsXJAvwRJv1wY4azbQXnOQ2Sdokiday1TmcRTtW5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IHlWY+al; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHlWY+al"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7fd35b301bdso3329803a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745609079; x=1746213879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Xi0k/1jo5Gcy77coU4aLkwrQsZAmNIeCBCbjkf1s24=;
        b=IHlWY+alVjVlGQxvSQEi3deJ3eLu9LxTLZP0B2jJTbuvZ+z5fpydfra4W6i2Ejf+Yb
         IuX94LH4kmlV81g/Y1NG3nskl2o/RIuNjmpyXzn7nnFjpKaEGVBcSEnyO8pyYWZD3UJE
         349JrYmW1HNbiD2a+aDYN2X/HE2jtOmnmrL/rCHwMgV7hCMIgSTt8Zqg48p7inwCiJjV
         bGXN1EHPSEWzlFpN4ZSZ0QzwYypAtIr6zJspIodRN5B7z7tp4f4F+QfGkCpt/eUnYJVu
         Bnb8mB40ncP2VK73morwBxgJEtyWWwz0UAlT0oW1MrRjSzQcF5ZpsuVpvWwTRmDXCwss
         WBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609079; x=1746213879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Xi0k/1jo5Gcy77coU4aLkwrQsZAmNIeCBCbjkf1s24=;
        b=mthHO26XgL3x2mXGfeyw0zxNylo8se7y0E+vBBCWh068v+ho8iC6CvgueowcbDw/3c
         LK1/L3zUiMaaiD+LiwFPiCqfOtB/LbzBIDDEmftm0ySobemD58SLx/li3bBpzSSxjSNm
         n2sXSMwDsYNBwTM/i/LHaLR80neGWczH2HxlDK2/ouPGG8+xz9FG+3nCMqjiGTyvi2qL
         vKfI6C9tyQwr8PisQIZpwfWX+kzwz4TW+nBkkZEo0SknR4dDX4aTzBcnQKLKtj09XN+a
         DxOc7d9FjuP9/bdIj4gWrHfuNI9ws2Fd3r3SyMH4rPBFJMZyEi8Ph2z7+MmkIPq5+KjP
         T1Qg==
X-Gm-Message-State: AOJu0YxrpIBRcGU/t1KeYqsN5IwdgrP+Lg7zC+ek1q3XyExC2FiDNYZc
	MxWWqBPsH/IaKdfBs38HGRZk6bnTo5zQg1NxHhjWLtFQOqJAg/s02HD5DQ==
X-Gm-Gg: ASbGncuxvthMY+fjlfz0e8kG+ua47SQ14SdpeOz36UkLDkVBbnd7SKjOrIcwc+7uJkB
	IC1Ium/kG/cjJSCSanAIxCeGPVBFmlctOcy0GKzHsXPQ51T0LcznFIdBR7F1LKeIekb+/sEOT15
	1GwO+iyegWdrHEP7pSrwb62Bf6uVNggMQMYfirD0cNzlI9Tjxj6O/D8iBbHMfu+99SICdbnNXHt
	Qie7P0Px426sfI2qdCjh7h/ESN3MdbtaP+3PDiJUcxQojooz7Vs+tuN7nssp7WXFIsKYBvryG/S
	Y1UTcI8EnyofSfDcFsPpSTT/Gm+KGb9zVR47Z7ADzEoOoMdFOMgMb1lFwkOspGOCgRtCynO93yO
	h+KDD5VYAJMeFPLbMGRTUPnfgaA==
X-Google-Smtp-Source: AGHT+IHQFbu7Yhra7AOLprOhnDldJoTK7sMcIN0kXlwRNGu9p1HI8Q3QMSkK9iMToperTyFBRoLBKg==
X-Received: by 2002:a05:6a21:1515:b0:203:ad33:1ae3 with SMTP id adf61e73a8af0-2046a465ec0mr663041637.10.1745609078784;
        Fri, 25 Apr 2025 12:24:38 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a649sm3667513b3a.109.2025.04.25.12.24.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:24:38 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/8] lpfc: Notify fc transport of rport disappearance during PCI fcn reset
Date: Fri, 25 Apr 2025 12:48:00 -0700
Message-Id: <20250425194806.3585-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A PCI function reset implies a temporary disappearance of a fc_rport.  So,
call lpfc_scsi_dev_block, which sets all mapped fc_rports into the
temporary FC_PORTSTATE_BLOCKED state.  Once PCI function reset completes
and link reinitialized, the fc_rport is rediscovered and
FC_PORTSTATE_BLOCKED state is removed.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 90021653e59e..2400602a8561 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1907,6 +1907,9 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 	uint32_t intr_mode;
 	LPFC_MBOXQ_t *mboxq;
 
+	/* Notifying the transport that the targets are going offline. */
+	lpfc_scsi_dev_block(phba);
+
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
 	    LPFC_SLI_INTF_IF_TYPE_2) {
 		/*
-- 
2.38.0

