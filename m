Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700EB1AC891
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045286; cv=none; b=o24k61moq69KCMx+pqLEY8xN72iFGzCX7OY28yv/ViDy32Um7AKqOG504+DlYOXgA6NnmbsooAaGqXqrr5No5DIwKyWQ3vb/KWf9OI++3XnQlWyI0bzAbCFXQDbSOlgnm/ts2FFFSNLdg0MsE1zgJHP0BgL8a0pDiVLIoNx0Ups=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045286; c=relaxed/simple;
	bh=QZlbgphKUCDE4lwWBxXQr7bh39j0yqOT06VHz9LByOw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eP3PqAx3/tTMnX4FBI8SIqKX9q9TlJSNINUa4ShYni4Yz1Ss653wF50yFTP1UnYIlwWjz97yiOl7puB2MrW8Mp7giqTzOlt04CvVGatKpspXBV7yx6nJ7Lsh097fTZsjuuBS1B41cKBLz0l7pYpT8RnbAQIA/pU2oG1P5kS9Zsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iV8NQ343; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iV8NQ343"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-216395e151bso7824035ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045284; x=1734650084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BfUlV5Au1B6a5Kic7bUZWej6b7ILHa5XUrJrlRhG+p8=;
        b=iV8NQ343ov8uq4lsSPNHLkyTImfpQR1KbE8oVCeqzHGB6UxHlIKiuXdYE2YjiZpHi8
         Fncu1o/Mp+veLHOvAet8Rbei5vFICCkZ/+EH7U7EQgtI8AvF56acVBrObBzXlxipdqUA
         tD296iasQk9zLK+rwB2wUk7YHNbrd5MBe0OlzgyhqGJZ7HdEt8goX6sAV0JUQV0+1B+f
         jfnSl6cGX7qiC0jKctAeA/WWpy0x1I8i7eoJ8z3W8qutrxKKgD5s+ItaS6sPfr952CNJ
         mw5Nv+dJ6nRzkPAQ+SY/8VAU4VU/zgjFtB+WSpuqTr+eacrjuyVN1V/+/Xd4B56ymc/z
         g5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045284; x=1734650084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BfUlV5Au1B6a5Kic7bUZWej6b7ILHa5XUrJrlRhG+p8=;
        b=Vg273qX6gknDiitkXESOIy+pOvE2VlUWm6/zHBC6tR5SDfQ/Z7dZ3xL0RM8gc1RihY
         l++DJ3jcni30PFMA25QYgJjnqMFFsQj3vaAmngTrV9WpMBKQ7McJPf3vseSOdNlmoUco
         UWVGpN1kp0vbnjRSDQQ3U5TAeJl/HcTWtGsI1obXfnxupOa10HFAGVZi1O+STEBDt0cW
         sBW6MRS3SzpZw1EJgPYqa40f9UhMwIgNsCi4krA2lchVfTNuk9dB8zTGr6R8pEm2yayO
         wrnw9ih6RGMlad2oGTLjT6h9zXzLpnYBezXv1aPzomXYF0WP3wNxuQLBhk8XKp9A3RiM
         hI8Q==
X-Gm-Message-State: AOJu0YxbbGjnjEyWht/EOLgEst7GywvdBfIgNzdNCaYSwakJBhdbfl/c
	DkPVtpI4Ge4CRBcyej0zfOvc+3BYBe1x3/9IlAj+hAz/pA0WWGXbTNgJNg==
X-Gm-Gg: ASbGnctrs8J0viItFMA4F5+ronD5uqg/PQCUBoocw6Vq5zWODrwj9Ezny0qfd8b9YEP
	5oiajKvP5Pj2lVJZVu1w+3fFy4cRX/X8iQjHOIiFQ9Zn6SmOEa0k3f4+0u6Uk7chpkkyvN4CZic
	IVvLzowrUesMe0JCyLEhibNCMtdF8sJga6iizBCPHI4mE//uNb/KWZ3UUmi1H+ugEMvcKOO2jwP
	kj2EGu43pyWnPOq+p60vRT1mVWJ3xjpAmhysv/yeVQAOnZkyQYixWH+aZ32tartcJ7oSK9TsBtG
	+hEab2queXdGPeoqdWe9esDX5QrZOlhLLHlBCv7pTg==
X-Google-Smtp-Source: AGHT+IEfkMyLJcX+sGEh2y4vSLxf1FqtXz9TAhUvL99Mr+Ov66+JCLYw8peU0+cb4mltbmkHkkcJbA==
X-Received: by 2002:a17:902:db02:b0:216:3440:3d21 with SMTP id d9443c01a7336-2178c874e19mr78954985ad.26.1734045284521;
        Thu, 12 Dec 2024 15:14:44 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:44 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/10] lpfc: Restrict the REG_FCFI MAM field to FCoE adapters only
Date: Thu, 12 Dec 2024 15:33:01 -0800
Message-Id: <20241212233309.71356-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Qualify setting the REG_FCFI MAM field to FCoE adapters only by keying
off HBA_FCOE_MODE phba->hba_flag.  The field is not applicable to FC
adapters.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index e98f1c2b2220..fb6dbcb86c09 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2524,8 +2524,10 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 		bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
 
 		/* addr mode is bit wise inverted value of fcf addr_mode */
-		bf_set(lpfc_reg_fcfi_mam, reg_fcfi,
-		       (~phba->fcf.addr_mode) & 0x3);
+		if (test_bit(HBA_FCOE_MODE, &phba->hba_flag)) {
+			bf_set(lpfc_reg_fcfi_mam, reg_fcfi,
+			       (~phba->fcf.addr_mode) & 0x3);
+		}
 	} else {
 		/* This is ONLY for NVMET MRQ == 1 */
 		if (phba->cfg_nvmet_mrq != 1)
-- 
2.38.0

