Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB9B1CCB27
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412938; cv=none; b=k7oVdl6P83MV314MM/fTFXNvQRIZ+04XI4lpamp2B85OEUWl7wgwiymuVYED5m+7+YTABTEljZPuZzw9P6xM5hNMcQ2e9sujdm7dodSwpvp7hZ+W+dE4i+dVArbyiuvbmtsmy+aXLbBnDpKQFyOGtI41Y7wiL6wHBNUDsvDOvLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412938; c=relaxed/simple;
	bh=y+ZbQbBOV/tQ9hweDCB9emyt7ui6zT7Q6+cAZ0ntk8I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ADkmEgATO6V4JKS7wL8QLE0cGCL2dkICSQfdQvr1JRwNys3JYvxOXiJr9anGFqRgUh+dgHX8V6JQBaVkj599+0ZkRyXgenplAf8KZucPdOjn8jox5NtKznOORkg/RTenPLeMWOXECBIva/VMx40hFz6iCv/iPSm48ujVwhS4MsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LIHt8rH0; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIHt8rH0"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20cb47387ceso14296515ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412931; x=1731017731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Aj5S7yd3e77a4p/mMnfUPvsEG0zVaT6LiC7c1KiSB4=;
        b=LIHt8rH0NFOHZNa5IIhATyeMCDMsXb16ryeC/dKr6j3s/XZCBCr/HJNNe67xbPKRzD
         iA2RIotnkDNWbzd5oeCFAUlgpocsSyMwRMOtBs9ZEHHhWeR05dhcTx6mCnGI4uWYeAo+
         TYic4xUPW5XKg78GnqMfmK6ZCWVJmgnOUmM+64ejmqZOTPzT6zL3KeYvLrCOFuJGU+Fv
         b0hVvD6JWNoDxmp8oVpHfs3/IR8htynMll9ONYZs9/BnLxNJwGs4uATOAmxzTgjQZdFl
         0ccQU47ktR5Pzj5kV7qvouAthe4FiQMATlsx5CzFlMIxlPD0tVIE477coy8Kfkg4fE9I
         Fhow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412931; x=1731017731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Aj5S7yd3e77a4p/mMnfUPvsEG0zVaT6LiC7c1KiSB4=;
        b=HctVcxfLT+2euClUSgAc6zXIylevQTjzQq67M1XbR3SL2KhXrdK/ZqjqyKJR7ATbY5
         Kit3HrqPnKdJHhjetcmeXoVMuonNip0G6dNYtOAbVWjuj+KPxrM2inyS1jqhl/96L1vV
         RGYrUVo3/yCQv23URkkE6+dx/JiIruq4V2bnLApxaPfJRVuUKZ7jimi7kqfQfu9JoaKQ
         liXJIxAXVj45EHmC4hD8DXpn4gkpVlU5Oh1f2xetnY5oIC/BHQHa7zkiwldjjaS/ovRk
         AUzdJC8O8iQJoaOoHS84+NObxKFd7RzGKmisVYZL57k3faVH0BqlNifHQMgONpXRTDMA
         mraA==
X-Gm-Message-State: AOJu0YwnU7uSLVEx4pm3+FnMsefSb9nupCZS2aClRS1KR78Zn/0VrobB
	bplhsgNt9pB7JIqAztLPgjknNRhOgA00HMR73vlYcIwOQ0V/xanzcXXrhg==
X-Google-Smtp-Source: AGHT+IF3H+4hr+SjBcH/JsTXCKj3Gzt416r1QJSguQa48KhEDHUtLBoj4hAyTJLL8TNn2EQ/67Exww==
X-Received: by 2002:a17:902:ccc8:b0:20c:c9f6:9636 with SMTP id d9443c01a7336-210c6ce56b9mr336488805ad.59.1730412931435;
        Thu, 31 Oct 2024 15:15:31 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:31 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/11] lpfc: Check SLI_ACTIVE flag in FDMI cmpl before submitting follow up FDMI
Date: Thu, 31 Oct 2024 15:32:13 -0700
Message-Id: <20241031223219.152342-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The lpfc_cmpl_ct_disc_fdmi routine has incorrect logic that treats an FDMI
completion with error LOCAL_REJECT/SLI_ABORTED as a success status.  Under
the erroneous assumption of successful completion, the routine proceeds to
issue follow up FDMI commands, which may never complete if the HBA is in
an errata state as indicated by the errored completion status.  Fix by
freeing FDMI cmd resources and early return when the LPFC_SLI_ACTIVE flag
is not set and a LOCAL_REJECT/SLI_ABORTED or SLI_DOWN status is received.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 134bc96dd134..ce3a1f42713d 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2226,6 +2226,11 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		ulp_status, ulp_word4, latt);
 
 	if (latt || ulp_status) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_DISCOVERY,
+				 "0229 FDMI cmd %04x failed, latt = %d "
+				 "ulp_status: (x%x/x%x), sli_flag x%x\n",
+				 be16_to_cpu(fdmi_cmd), latt, ulp_status,
+				 ulp_word4, phba->sli.sli_flag);
 
 		/* Look for a retryable error */
 		if (ulp_status == IOSTAT_LOCAL_REJECT) {
@@ -2234,8 +2239,16 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			case IOERR_SLI_DOWN:
 				/* Driver aborted this IO.  No retry as error
 				 * is likely Offline->Online or some adapter
-				 * error.  Recovery will try again.
+				 * error.  Recovery will try again, but if port
+				 * is not active there's no point to continue
+				 * issuing follow up FDMI commands.
 				 */
+				if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE)) {
+					free_ndlp = cmdiocb->ndlp;
+					lpfc_ct_free_iocb(phba, cmdiocb);
+					lpfc_nlp_put(free_ndlp);
+					return;
+				}
 				break;
 			case IOERR_ABORT_IN_PROGRESS:
 			case IOERR_SEQUENCE_TIMEOUT:
@@ -2256,12 +2269,6 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				break;
 			}
 		}
-
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "0229 FDMI cmd %04x latt = %d "
-				 "ulp_status: x%x, rid x%x\n",
-				 be16_to_cpu(fdmi_cmd), latt, ulp_status,
-				 ulp_word4);
 	}
 
 	free_ndlp = cmdiocb->ndlp;
-- 
2.38.0

