Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07283363
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660505; cv=none; b=ZjqOvxfJ0nx/OJ8/axuQmaW23nwpFAWILmDP8MrynKNZxHjT220W9BMZChA/ll8LR3YlPufF4hVwzOrhLGDhZigyTS41XPZXiE9woqenwKAhMahoHeJma6xzis3y0O/zE7d+7W+tjkk6IwEWttr6d1Pm3yikUPymwicTxkEjP2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660505; c=relaxed/simple;
	bh=AC9HdCLQepSYxvoCytacu9ihASlLSFUOokrEkMF3VI0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T1Y7DO+He4wtTIjXPSJUAz6i9eguF5L/mbV4i+PB6w9CX7BZvze9Ndh4JXRK1LfXPm4lEwINGDam9NqoLuurgbAb5FtBa0SkaFtHDogVow+TjQCCuM4YHQqnMBRNOFYaUuV00JBoFAkxp97zX4Xli6ohecVLSg1ISoy8E06CEv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VLycpqXK; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLycpqXK"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-68155fca099so3303866d6.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660503; x=1707265303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xrYMQbBGouBKeVUjbH/ujGHtT8PpnV9jorOVqOvoImA=;
        b=VLycpqXKnvSrfhvGIY3Cxgkf0/rx6qW6LAcBpHrC1OaYEMfDhepGTwwvqI3Em76ode
         pohhj5CthZ/oCXC+H69hSUsZ8NbDVgMoCavjBq44XcMlHwOLKsjNWy+ruQKKlGPsiw1p
         KeugU1Qd4Q9BJeNZtrNx+MSeXWmAZQs7DxM58JShPJPkyRaFVNrXY0EmQ0GfmtydZ3iE
         zMlzeYY0cehrKRtAVEZhAMOr9IgRMuEFY94BzKwRIyCiS+8pA7/R0jyP0siQrR4Q9XX3
         80dMzMxd0bfGqQC4r7kUBfHO2HCUfgmqrFDFfWc5v8w1BJq2SJEiWyhbwW7z31SvqMen
         iY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660503; x=1707265303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xrYMQbBGouBKeVUjbH/ujGHtT8PpnV9jorOVqOvoImA=;
        b=uiy/dgv95VabxZcRLj8ybQowLU9a5LOMeuYAY7vIlXaAHULjDMkWGl2MdrNoP9Ko8r
         UPWA3jRGgyJVEsl5tvVcBzh9mlgFEWjJmlo8Y5zhFQ/cuPfRYvNO2WB1sbflPplEP0CE
         QulJLYXvx69lVGs6CiBh8zDMQYVDzx+E2N6vh1Cs9jZJWNEZO0S/Iln7dX3AeqGig4Sj
         p0YfbWtuvoSRVrKg6kBZBzPXtnf6vJ73sRWlUBHpYVm2szndI5uSgy9e7+nlKmW1xmfj
         KzwiJCX81ApK72mxpLgUDDPLbFNEMUYmNda46CHmzjBu30GaX6bUVlKSIksMoYI2pLn+
         P/Fg==
X-Gm-Message-State: AOJu0YxtzpfasFNsb4+XeibqVOtY6ICZSWNYIyT+ZwRKFEv2WZKYhMfo
	2prq8ErghfToUrTHL+qek1XJNgMFA/Ef8A4R//94NnClMIRNHKpaMoTVTCAP
X-Google-Smtp-Source: AGHT+IFUXMUYLVwx90wx2QAIufcbrsqwGajvmwiioagDMN/lEFR6DZ+Z4Jtos3L5qPwfZjeXUyG5bg==
X-Received: by 2002:a05:6214:528b:b0:685:6147:3607 with SMTP id kj11-20020a056214528b00b0068561473607mr184566qvb.2.1706660502802;
        Tue, 30 Jan 2024 16:21:42 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:42 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/17] lpfc: Fix possible memory leak in lpfc_rcv_padisc
Date: Tue, 30 Jan 2024 16:35:34 -0800
Message-Id: <20240131003549.147784-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The call to lpfc_sli4_resume_rpi in lpfc_rcv_padisc may return an
unsuccessful status.  In such cases, the elsiocb is not issued, the
completion is not called, and thus the elsiocb resource is leaked.

Check return value after calling lpfc_sli4_resume_rpi and conditionally
release the elsiocb resource.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index d9074929fbab..b147304b01fa 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -748,8 +748,10 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				/* Save the ELS cmd */
 				elsiocb->drvrTimeout = cmd;
 
-				lpfc_sli4_resume_rpi(ndlp,
-					lpfc_mbx_cmpl_resume_rpi, elsiocb);
+				if (lpfc_sli4_resume_rpi(ndlp,
+						lpfc_mbx_cmpl_resume_rpi,
+						elsiocb))
+					kfree(elsiocb);
 				goto out;
 			}
 		}
-- 
2.38.0

