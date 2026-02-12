Received: from mail-qv1-f68.google.com (mail-qv1-f68.google.com [209.85.219.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFD42EA15C
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929741; cv=none; b=OQPivu+iA4DiJL33UN5/rRbwyMqzAKPxB5Dk9IxTybA+8R1kAXY0sY823TncRPvA5108sTuI5fpvJpgz+g6vdo5LIct4PMXyelfwGqeS+kJl/giK5nMJf4Yd/cy9WyW0kMEMpcqxbhyu0V3l+ddojyDP/Cp+w5l5510Hxs6/xFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929741; c=relaxed/simple;
	bh=+09o8wuZDMTXJzzcsToAmzXfZzXlAw5b4t1KqF+xHMQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mu61wobdgL5f9RHrD2+XZGJZsWKFASQ8LLym95dyhiRh+pc6MJ0tuJTMGzYbZn62gtYIakjPiuCnrn8+WUkoMGKqPdeVd28SsJhGQpzCXu7RGJtUiBCQQX5fjc+Hi8/WP8YX6yzlRXOljntLg2D96i467qT+S7SN7A2TPZNH3Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pv62vOyv; arc=none smtp.client-ip=209.85.219.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pv62vOyv"
Received: by mail-qv1-f68.google.com with SMTP id 6a1803df08f44-896f95e07f5so2584576d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929739; x=1771534539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LsjiHM07DRXibnhWr9+GGDCzHrx7QqkKHA/sj0YPAUQ=;
        b=Pv62vOyvyqIv0yrMiRjtl0iG7RKArlYAicOD57aHRtdB9k+ntHjWxvnPdympNPk7yZ
         F6Q+pZmQ6iXisCcAXLeM8CNAhfg+FMTa82qCileYSwv8X7vTBkMDZvSsKMYB2IPe4NVC
         gkALjNXNfPUMRgn3BNArQc6T+btCerXE35BDDjRiNi2wDBV+DF4vDy1nbd33QaWrX/7Q
         ox4pn0mdV9Uy1UfEFXh/OPbXKJR0uWYPpI0dYSPBgwrc3HZ8THVPhCd/SdMGm7XcDoJP
         bo06jM8hXDhLiuGetvvN4cO5wtLY9qneWwRdyOq+DadLnSVLYwEBQT1pbZS3HHClw14W
         JStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929739; x=1771534539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LsjiHM07DRXibnhWr9+GGDCzHrx7QqkKHA/sj0YPAUQ=;
        b=FzkGViQy6Hd8F+vX4uFV7PAuRhRBz1f7TemDpnuAWwuImrmQYLLKpu5kR1PmW8Z3fk
         vQtymaG/ZQINMPhLIg1Db6m3tycRYhFv3A/8SodCY/AcXWy4wfcLsd8S4/loS+pGK+Ri
         hs/tkSgxfKwza4cwjsU2WAZwO8wHIAQ4vqPydCccqyXtcOIVLDpCKpI2SxqVWQ5m4ASD
         nVlAr3NwnE5KInKYQtRVYbiCiwRYWm6vgW4jGMwTOEvlHjP+PgNS8XTDrH/hF0g+mRCz
         cHT//nAECFoRjBH3EdSvfPOq6Bd/ivXAD0Zyfp2/DgHulEVDTaM/U6eTonWCSC/RQhlp
         Ez9A==
X-Gm-Message-State: AOJu0YyO24MbdKdEkjcnt4nUqFVreIChmFTYBAcdndS7NREXZ/DDNJTR
	fhT1SXOK4uZyHfCX9RCkP1kkX2DZhD0oBbxytob+VrORxI11jhsuWSnSm6GJhNecRIs=
X-Gm-Gg: AZuq6aLyKbbfsIclPjt7Akj71QZmiIlmfKZvvft4QFCX4EfKnN7gTi074/F032HrK40
	sAbLo11ZceLDJGNzgOejt0diCaP/52TV7q9lKAjL6nqSh9YxZz48lBGdxWu60mZeUDhTvgVCmjA
	JqjoNuzStatgTYJH4v7vYt4IbYOLrdwKycWSpgBCaH+hYdC4pn8QbQC6tu83l3onwqPVU/Hlxsc
	Ut2btsnVTmK5Upxtacf2Z+9FGemp6sMNz6nPY3C7slkC6LqqY9EsuW/1AU7GNo+ODxdGO/6gtbd
	loyoKmrE/AzRqhu90mb+pwB5kDTt4/BYow/QSu3sP9PAYlccG/zPCTnZU4WVVbxhDkLEkfi2b10
	M0CXdcpO3mjLJAknmVdGKrANVqLt1znmY5BXicyC/UAZ4jL/qs2TSWkyF9fQbuaYylx6JpU+ed6
	rMvmQRFd1asjEHJwlirmSejicE2A2UEvaPpAdEVup46w8XQ1J6aoFYaxL6ibjPc/nDByyWJ7fLy
	SDowvIruf4=
X-Received: by 2002:a05:6214:2685:b0:888:fc28:7d0a with SMTP id 6a1803df08f44-897349802ffmr6549296d6.51.1770929738590;
        Thu, 12 Feb 2026 12:55:38 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:38 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/13] lpfc: Cleanup error exit paths in lpfc_fdmi_cmd and associated messages
Date: Thu, 12 Feb 2026 13:30:02 -0800
Message-Id: <20260212213008.149873-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Error labels in lpfc_fdmi_cmd accidentally return success status and can
potentially leak memory.  Change error exit path status to return a
non-zero value using a common exit path for failure cases. The error path
also frees allocated memory and provides logging.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index d3caac394291..501a320e99f4 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -2427,13 +2427,14 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 			/* CGN is only for the physical port, no vports */
 			if (lpfc_fdmi_cmd(vport, ndlp, cmd,
-					  LPFC_FDMI_VENDOR_ATTR_mi) == 0)
+					  LPFC_FDMI_VENDOR_ATTR_mi) == 0) {
 				phba->link_flag |= LS_CT_VEN_RPA;
-			lpfc_printf_log(phba, KERN_INFO,
+				lpfc_printf_log(phba, KERN_INFO,
 					LOG_DISCOVERY | LOG_ELS,
 					"6458 Send MI FDMI:%x Flag x%x\n",
 					phba->sli4_hba.pc_sli4_params.mi_ver,
 					phba->link_flag);
+			}
 		} else {
 			lpfc_printf_log(phba, KERN_INFO,
 					LOG_DISCOVERY | LOG_ELS,
@@ -3214,7 +3215,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		     struct lpfc_iocbq *rspiocb);
 
 	if (!ndlp)
-		return 0;
+		goto fdmi_cmd_exit;
 
 	cmpl = lpfc_cmpl_ct_disc_fdmi; /* called from discovery */
 
@@ -3320,7 +3321,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (vport->port_type != LPFC_PHYSICAL_PORT) {
 			ndlp = lpfc_findnode_did(phba->pport, FDMI_DID);
 			if (!ndlp)
-				return 0;
+				goto fdmi_cmd_free_rspvirt;
 		}
 		fallthrough;
 	case SLI_MGMT_RPA:
@@ -3396,7 +3397,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (vport->port_type != LPFC_PHYSICAL_PORT) {
 			ndlp = lpfc_findnode_did(phba->pport, FDMI_DID);
 			if (!ndlp)
-				return 0;
+				goto fdmi_cmd_free_rspvirt;
 		}
 		fallthrough;
 	case SLI_MGMT_DPA:
-- 
2.38.0

