Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6837D1DE896
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045291; cv=none; b=rzcNaxnUeU3s7+7GpYKHLJfVAdgDYImoBfplW6QT0UWg913gNxUWGVXXL2RJoI53AK4e68vDJPj0TB9ryMHSPUz6Lwsjp08DDiqVeOem17biSClZXDnVYT/QKPAcVRCv5VHwwKyqOhxooqWvi1MvVRn6JvgEDwS2CEZ0ddhYWM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045291; c=relaxed/simple;
	bh=waWug8IGDncW3tQRpAj/rZzG1k05eTpQOA+4/LIMZQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hbn/s20fyhLjSx+8nsZPvGCdbGfV8OVJEAX6cZFtPZHyHs3JkiAjTU4IxCdrMjuq4VFDCFFyO1MxJ4Z0y1vsysTtCM1D+6VVhU8Vd6JRCVRUMVUcI7+gh9MlJrRTWrafyTgh2a70VD346Jsm6lAeii8/PD0elaHVtaFzbdbCJhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CzOdguQn; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CzOdguQn"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2165448243fso12789195ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045289; x=1734650089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/wJgB/y7ynxTAPTPS5AevrbCTm7/rtqAIAqpuaPalE=;
        b=CzOdguQn9BCsjBhDxUAaEOALdA83e4tx3oh8YtYXuQ65oS2fgkOXalxIU1IF4CahgC
         slRgGtZYZwxvLjN4JG0WOXur4pOYt4u9YOpb0/gKGHrvaQudtV5DEJPXgHER4kWLf9UF
         DWsJdIeySqeng05zcTvnq+EmSPYplGLkxKz9YaXsrJUH28+1FrIF0IvPr6YPfzJJLN3b
         5KLRI1It+kTfdjKZ+a9Vk+6xxw656zFELUNlxJnRt/Ie+/LMLD6d6GvndW/u2al0B3HO
         Uf+gNeRnYZFJSOl8Qnxy9mMZha2nosDwv2dIBva7pL2hEPsFidMRvCfmFheugr/ywow4
         ToVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045289; x=1734650089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/wJgB/y7ynxTAPTPS5AevrbCTm7/rtqAIAqpuaPalE=;
        b=tsJiRH3wc/DTWDQ3+D/xdl5WxLDB2xB7JVGKyeDXCrFx8+IZvFFDmKPTzhFBnn511V
         UFJD9Ko7vgk4lQzoj6bJFtizekKvJy3UGJEzgaot6mD6owhamSBbFd2td5XiYChdsjNH
         2JthWw5GA4esk0HhgP5dtKLuAQ/864ng5gNIfMeB6rABED/g0lhPWcPMg1gaiX84GAFS
         VyzVudoQz/HaOlBCRSIR9KO5qINoJOP08ovwwVfSTn0VWE4g+ljqpX9NRX4QpLuFrYuY
         puA2k7uFq3Kf8eS0rylWa66Ei/BVaQ/FH7uv0ybhlhudof3nZyIy24R0ETJ81NxGu2Q+
         kY1g==
X-Gm-Message-State: AOJu0YwBJbEw+zEVqbRMmyhG9ZglMhRSYoLnK/WQZeHhIse28POnETqY
	fF0Vi9wPwcIFFjSQ9itEXPG8Du37ct8B6p0kxOHdtcO1cDCn0dtqNpw+8w==
X-Gm-Gg: ASbGnctSDcEvM6LdAJcMf5UGtJkcFi1jft4D5SPJDBws6MbXzjnYbbOrsVNWRRtYLnQ
	ISDjefQ/bQOot42ArP85auDWcFcwGHvdI6lzuQsoNz7V9GA4jWhEca3c0ejR24WcFcrwxbxD7Rc
	e+MxXJX/KJn0g/e3+b0aiWbbeY027HScUevfIkhiS2ob9U5BJrTVdk+slhii/QAr4YV/TsTuS/u
	bZC3xxrUiNKM33otxdfDj8UA2hS0YtGuZrClJNeUMxRV3/JTqm1Fs5wue5pR8jD03slWVgqN5kW
	n4R7juPpMZUyJ9P7Csda4P0ZRY2L74nlpMtmnihvYw==
X-Google-Smtp-Source: AGHT+IFzVqN6+Yptv1yOtDwYKyCT/NkdhYj/lAU1eoE44/3wUOt0vPjxDlooDLvuMraUY8yRhZGt4A==
X-Received: by 2002:a17:902:d503:b0:216:59ed:1a9c with SMTP id d9443c01a7336-21892a849bdmr6296485ad.55.1734045289452;
        Thu, 12 Dec 2024 15:14:49 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:49 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/10] lpfc: Add handling for LS_RJT reason explanation authentication required
Date: Thu, 12 Dec 2024 15:33:04 -0800
Message-Id: <20241212233309.71356-6-justintee8345@gmail.com>
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

When a LS_RJT is received with reason explanation authentication required,
current driver logic is to retry the PLOGI up to 48 times.  In the worse
case scenario, 48 retries can take longer than dev_loss_tmo and if there is
an RSCN received indicating an authentication requirement change, the
driver may miss processing it.  Fix by adding logic to specifically handle
reason explanation authentication required and set the max retry count to 8
times.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 26 ++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hw.h  |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 842b67e37f10..32e5e99ebbd4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4570,6 +4570,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int link_reset = 0, rc;
 	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
+	u8 rsn_code_exp = 0;
 
 
 	/* Note: cmd_dmabuf may be 0 for internal driver abort
@@ -4785,11 +4786,22 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			break;
 
 		case LSRJT_LOGICAL_BSY:
+			rsn_code_exp = stat.un.b.lsRjtRsnCodeExp;
 			if ((cmd == ELS_CMD_PLOGI) ||
 			    (cmd == ELS_CMD_PRLI) ||
 			    (cmd == ELS_CMD_NVMEPRLI)) {
 				delay = 1000;
 				maxretry = 48;
+
+				/* An authentication LS_RJT reason code
+				 * explanation means some error in the
+				 * security settings end-to-end.  Reduce
+				 * the retry count to allow lpfc to clear
+				 * RSCN mode and not race with dev_loss.
+				 */
+				if (cmd == ELS_CMD_PLOGI &&
+				    rsn_code_exp == LSEXP_AUTH_REQ)
+					maxretry = 8;
 			} else if (cmd == ELS_CMD_FDISC) {
 				/* FDISC retry policy */
 				maxretry = 48;
@@ -4818,6 +4830,20 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					      "0820 FLOGI (x%x). "
 					      "BBCredit Not Supported\n",
 					      stat.un.lsRjtError);
+			} else if (cmd == ELS_CMD_PLOGI) {
+				rsn_code_exp = stat.un.b.lsRjtRsnCodeExp;
+
+				/* An authentication LS_RJT reason code
+				 * explanation means some error in the
+				 * security settings end-to-end.  Reduce
+				 * the retry count to allow lpfc to clear
+				 * RSCN mode and not race with dev_loss.
+				 */
+				if (rsn_code_exp == LSEXP_AUTH_REQ) {
+					delay = 1000;
+					retry = 1;
+					maxretry = 8;
+				}
 			}
 			break;
 
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index d5c15742f7f2..71d3e60f4b20 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -724,6 +724,7 @@ struct ls_rjt {	/* Structure is in Big Endian format */
 #define LSEXP_OUT_OF_RESOURCE   0x29
 #define LSEXP_CANT_GIVE_DATA    0x2A
 #define LSEXP_REQ_UNSUPPORTED   0x2C
+#define LSEXP_AUTH_REQ          0x48
 #define LSEXP_NO_RSRC_ASSIGN    0x52
 			uint8_t vendorUnique;	/* FC Word 0, bit  0: 7 */
 		} b;
-- 
2.38.0

