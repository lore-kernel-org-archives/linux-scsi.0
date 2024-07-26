Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13561514F8
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 23:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722034804; cv=none; b=tV2s3jXyBimR/aealvTyM5Kje2mL9FEXI7PT1GzjuzR9rpF3LZMfYDCJA63Dd1PtJJsSrCf45c8VSysUvsSKewR51CqtaYVaeAeFOyQMze1HXf1YEis2LFohzbnwZ2R0phjJ3FAB0OgWsSiGkBWLRKStjmr8cTElVyWJ+Z81BdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722034804; c=relaxed/simple;
	bh=gTV1ckEZE0QwBd5mAQfb+2xvuMydgG8sNzQhZ7c4168=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hnuuCeVj2sw8e1E8WMfvmFlra+o+QVikGTzF/0kEwP3pkg6is2Fpk65EGtML4AuVmfJ2tfYMglyUjKEOzjIHTwx9cy7us1Mg2r1uZjYY1knFHPuHIORoQckttnWLXdV986jwQeRF+1IfsnRcg09KZwJxM5QtcOEF/mwQy/WbaKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgvMUkZp; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgvMUkZp"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70e9545d8b2so143014b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 16:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722034802; x=1722639602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIoxDRwduWTKxH7+VDIAP9AK6F0RiGBltWj+tE+qQfY=;
        b=JgvMUkZpWgD4ZP62YzfGoOOOObwfTXxqffaOyxwMx7F0pesi6L6W6Wa2M3DtfGC/ju
         TcFTx3HEfUA0imQYFwEh/a14j599wWW07HMV9ecoYiDHOZlg3aBnns/42atzcou8w8AS
         1q7Ktpc1IZ0j0jF5qW9jlbyKSqXgK87jmKi+N+pPCNgQvJFefKpKI828dqEJ/woERJT8
         mR3/hH2KhrQWiy/345cTtvjbds3j9AGALKj9mZRIoHtx87utFdKxvp4bC7qN6IatUmjN
         EYtLu1GIq/+1R3VVIG0ypd/r/eJ8hCu2Gp+NNOX/dcel/M7lIaChCwF/2PCnjKUf55Io
         ANPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722034802; x=1722639602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nIoxDRwduWTKxH7+VDIAP9AK6F0RiGBltWj+tE+qQfY=;
        b=nk6SH3BuT8Xk2dS5EQWVr9P5k6xNADTXi9diWtuAGOl3WOYUwpCYqgoWWXcHs5TXCk
         dyeRxhekGwz9qMI48gSviTdyI6CRGAQgFZqd6ZErldfGVNzYgqZeBvNsNiZy1yN9fPpW
         ITK02TKtDwVH9WSL4ESZSrmd5lb0Xz2oDFuorlOgHx8HqnBXOiZOefNO0GR8y0fPDh3C
         +A68pm8gsvGbggrLO+8fnbIDgpA9qPRUnEzGwrE+/2dfYUmdib128E3amepU9/va9NlJ
         vmPdVr8jn3Gv+04m8nC5AheZme6MXdF6lPqDt1nJru1i/IsviaU540gn0yjS49JRnt1D
         z++Q==
X-Gm-Message-State: AOJu0YxTmCmzqO1eDqshW5Zd3nsc3ZTJo5MnfHN+cAgBbqJ+VYYI1I5a
	C0aNm6+XTCoNOZ0J8J69g7p0iOBvEHC0BQEdbuaHzbgTblLO/R5jtfbZSQ==
X-Google-Smtp-Source: AGHT+IG7CMJez6iX9Rk02Dqqu7URZE+AtRCKravEXta9NQDhqU4QrA3sOAXMxRQ30uiySylrmWcfzg==
X-Received: by 2002:a05:6a00:8596:b0:70e:a06f:7057 with SMTP id d2e1a72fcca58-70eaca93f4amr4854912b3a.4.1722034801867;
        Fri, 26 Jul 2024 16:00:01 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8834b1sm3308540b3a.178.2024.07.26.16.00.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2024 16:00:01 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/8] lpfc: Remove redundant vport assignment when building an abort request
Date: Fri, 26 Jul 2024 16:15:06 -0700
Message-Id: <20240726231512.92867-3-justintee8345@gmail.com>
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

The lpfc_sli_issue_abort_iotag routine has a redundant assignment of
abtsiocbp->vport = vport;

The duplicate lines are from a previous refactoring, and this patch removes
the accidental redundancy.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 88debef2fb6d..d240bbded4c8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12473,8 +12473,6 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 				cmdiocb->iocb.ulpClass,
 				LPFC_WQE_CQ_ID_DEFAULT, ia, false);
 
-	abtsiocbp->vport = vport;
-
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abtsiocbp->hba_wqidx = cmdiocb->hba_wqidx;
 	if (cmdiocb->cmd_flag & LPFC_IO_FCP)
-- 
2.38.0

