Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6CE1DDC3A
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 23:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280712; cv=none; b=LB3FknSUYNio6V40rGfARu6I2gvn+nnz1HH71HuO7dIydqi4DX3g1Kt8nOoAgn9G8SHwx08k0dYAaGMMUlUWZdy1ncdU4MeVPQ3oV6mkWtxRW6qk8hJE6p6N42cKd/lAD9pm8qf4DffX6H3P1h5PDzyNjia6L8FMNCKuskpxKQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280712; c=relaxed/simple;
	bh=+Vn49Tj1brt4cIAdNU6UVZAET3EJdVGNX0mKf8QA0Sk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=poeyEzTXcT4jhSekWUMc8ZOkSf1iT6+FTUXt4dsiTbPrmDO2YtUNhDVSrEowEzqkHBdgJW5BiL2sPQXJJEl1bvP9WkhAEg+Hlz8lMbOjB0SW8iiP9D7vhzIwinCkdlvkVAC+KL6kA08hSshCx8cVh1AolzlUZVhVw7Y34Lhlo94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XcIcFDQa; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XcIcFDQa"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5f2e370bb3aso391688eaf.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 15:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738280710; x=1738885510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kp0yN7qFud0xlqpM6S3vYIiayDRxeWsB+4ws/z2F1Zc=;
        b=XcIcFDQaEs7TXNOU6nus9tnyRnuaEiOxqDXRxOoZqasLcaFgXek9WLyDhfFXK9LZDF
         KuRKPaGlyW+UPBalSqZdevOctE4TeEJTgRBnKqwPqkwl51ZtB6T+oUFjjBzphNAz+vbY
         pH+aXq/z5bfdMbWHIgrXJsfjTP8LhvcFEbiwbAiPzLeY6KDfw882qB6+ZghuwRGuV/vW
         YmIxKpgml4sgS8mrvz7wviakes9XZpYcsopjcx3jUiCdN63YaUVm/1gR1Mx2cEwUfazu
         b2krOqLSlEgBZfHIEmX5Ohg/LZyyMi21nfdBtebyLqwT5MYlqSYwqSzvF4JWJxm05NoP
         HB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738280710; x=1738885510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kp0yN7qFud0xlqpM6S3vYIiayDRxeWsB+4ws/z2F1Zc=;
        b=qi3xc+LAJzDeWvMm5iIuTg3Q3BBZq/Bd5tD2BhusMbQ3XRsxYHf7RMy0PKMrWfjoGt
         J22oiVGeBtCLILG/KPQvHCFWKu/LmxW3whpj2s/ixzqAgrB4HBb8lOzpNlYo2zeZMlKT
         +hmdSHLL1zzufSv9VxuN+gIFQEg6Vqc/JwwsMXwi5Jz+84kZ7hPWmd//fgPF/9IZDXn8
         afQvYJt+UWx4kqe+ax/XtmZAhp8WGbmxm8vUz9Rwf0uXbxt6CI+PIT+211odGn+WEHbj
         1xGkK9Mo05fi1YevEoG9oJAGHdV8IA6g/3VCxvGBsHctz1bEtYj33juwqp9x1TGKczO2
         /feg==
X-Gm-Message-State: AOJu0YwU6CHlYm2SlQbMKtIQvVsTXdSuw0LR3PZ/d2hIpxNPDnna5k7m
	0UNzKGP4ww9CEUds4CEJzowwXfLe+TJRLuMBmBwuhFg6/lAxNhHZ2uuB8w==
X-Gm-Gg: ASbGnctdq8fNHhlIiwNK8f/cMZYUcG3NJhr5rnIJdqFfSadsM5/jK65M3csBfhPotB4
	YcxivrmFrCOv+KbFzej3nj0Ni5xYdhdwObb/prnzfSg/PLvk+Zr+zxeICJaf5lJsziAROABfIxJ
	VnkRcS4ctUBMIgcrmTganbx62hryjFZUthx1WeOTz7K0NYJjSCenE1TFH2N52kAwprRQb5ffmny
	wTy9WnwMrPY9/9uE41fVRtzpZcjZVSWhWeI3eUcqPbiO//rxGZVia4M8MxCzy9JqKCZZ8oc/KdY
	G1X2hqdV2TwZFJN4oF0lGA1ACajkYZ8Wfo5dMCmxlqNIrf3q/ocnuDKAKVIDrUBC5f+kLTdLM3Y
	P
X-Google-Smtp-Source: AGHT+IF471iU8f94HQ/r20rWrzKMgJIklM6ve9S753jTN1nnP7ik+mw492f+JpeVoKFtpKRK9gZpaw==
X-Received: by 2002:a05:6820:2685:b0:5fa:23f9:a256 with SMTP id 006d021491bc7-5fc003677f8mr6312139eaf.5.1738280703276;
        Thu, 30 Jan 2025 15:45:03 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fc105d8a22sm517609eaf.37.2025.01.30.15.45.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2025 15:45:02 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/6] lpfc: Free phba irq in lpfc_sli4_enable_msi when pci_irq_vector fails
Date: Thu, 30 Jan 2025 16:05:20 -0800
Message-Id: <20250131000524.163662-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250131000524.163662-1-justintee8345@gmail.com>
References: <20250131000524.163662-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix smatch warning regarding missed calls to free_irq.  Free the phba irq
in the failed pci_irq_vector cases.

lpfc_init.c: lpfc_sli4_enable_msi() warn: 'phba->pcidev->irq' from
             request_irq() not released.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b94624789771..07b614bc9a6b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13170,6 +13170,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	eqhdl = lpfc_get_eq_hdl(0);
 	rc = pci_irq_vector(phba->pcidev, 0);
 	if (rc < 0) {
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0496 MSI pci_irq_vec failed (%d)\n", rc);
@@ -13250,6 +13251,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			eqhdl = lpfc_get_eq_hdl(0);
 			retval = pci_irq_vector(phba->pcidev, 0);
 			if (retval < 0) {
+				free_irq(phba->pcidev->irq, phba);
 				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0502 INTR pci_irq_vec failed (%d)\n",
 					 retval);
-- 
2.38.0

