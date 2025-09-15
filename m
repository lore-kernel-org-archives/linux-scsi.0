Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D726129B205
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957955; cv=none; b=UQlo8XzDv5vqDcCuXwY3Qe+2qLexjg5AMyAL0BeurEdtPn8eCxhTTLym4RxcAQOBcigOWcMYyYT8LpELYDs+J3Wl/6/1l4urL5z8oW8dHrHVEBfjABnV1O/T4xgOK8QrlZZ3NQYJyHuL5+5B1ud/Vit0oZ9D9phbil1hllzdrKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957955; c=relaxed/simple;
	bh=UKBBM8qLHHuhXffrlv6rGqYGVQou3IPKX9kgHyQq1Es=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AIIj3zK0+IrmYi7/6TJgZjzNhB3xaMppdvuVGayD6M63Mvd5o61wyQfDlx3JPs3kmh1IO/49zIVpDI041RCybksdCkk7Eo3k/gT9UpAhX/fmvfm3ArZEdpJmOlj4PiU482Vc+No+CS1XsoVzJSr5qfacNolG4hbTlz5Vxy/8FQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PH2+qgaD; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PH2+qgaD"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-781fbbad816so9371326d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957953; x=1758562753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZwPnw3+g/4EjVrbqkjVnH6FOI3uhG0VVfKtzjzxAJT8=;
        b=PH2+qgaDwLyniSJZHWfxEt8zsaaNmmaUCX/n5O6uOdjtvRZIG+K1axvC6iBpLvsqr8
         ob6U4X/sPCWyZ7o0brrEJbfFPRU7zeLfJVM2uMQqMvP1SBais2FKYKsNta5oQqgXgCpX
         xY58WSmIylvPMw6Z/wq681DDiBHQaBafYfcpfBmljrVVOAzdvbrUKCJxIRggiqKv1kCA
         AmlCO9V+5jvw+mQexiFE5CTIp/W1U92n37tp/KZljbkWJFurIjW9vUvZwv68L8RwHp2p
         JutLEWb0xeCcn2YQY5/gd/3IKcVWw03Fz4DwPnJmsXd/mDQM7+JDoAmV2jqDOpIFMCSA
         41qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957953; x=1758562753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZwPnw3+g/4EjVrbqkjVnH6FOI3uhG0VVfKtzjzxAJT8=;
        b=Kse9vbIkG3zsfG/PWVcki4FqfMeROu9UgFpDNa827U+QXpuUaSL1F3wRlUQaBCmVO2
         EtPykfns6+dP9KQZohVDM2sUNYi12YdSp8EsKQQTG5BvjfZ5/WEO1CnIvzEC04+4NQTn
         ibqjPqoVbJ26gWYFdLTbqHIR9pvaDQtcaRPPkkjriPF1b/8TxJZNy54/N9ylPogMZJ2g
         fxSkB3d+0PUEzBPe7H+K45fL50wyK3jtErORAKmjwD08tn+DW0IUMpd0CzNqeKK3NBrI
         IJjEIMPnGk0flCDFvWLrfYF9jN+5kAtPifNcE10+o6bEN0BNBW+ruikWbEh0cDxLUYPQ
         +/Ug==
X-Gm-Message-State: AOJu0YzfMqE0Nz2Mfs2fEkvDU3OJu+ViRYeXyJGoaAMkswJe1kmkfdya
	Daw3ENeuk5oNJCnwFTHVZV4eSOHpwUgGRypTAs+zd3bX4+8+Ffy9jkEMLlTKAA==
X-Gm-Gg: ASbGncv5G7ilhIjt8CjcTkiybcdZf3uJWKRyBEUDD711wHWYwCUcGiHWeYfpBRx9knv
	1w8Gf7F8T5yqwuz8od0Eya6hN9K0J2UcoTG8tkGVNvuq7xgCLpN+qR9FErpTkw5vVkCHOQbNQEf
	PzLBWu42RXR117TwXSkM7tghpSKGmpDJxpmyJUnAfZ0ibzgGJjC/bZMPEmwWRMHMHdfP0KePtLo
	tSKp1jmvSvUINPw1IzbJz0euvl0HUdHwrBiHvCXQ2izNi1eAHvcuRcWOXglNAaU9NQpMfC0/8QZ
	VnHT9g6eFftS2T+/D9vIu6T9zKiYcmZud74/ERPXPzywoforlvc/if9IKZySpDwkBrVtsxR2RUH
	DS4/Chu4XFNDA+DBmWiSm8HSCQBay5XkvHPQSd7DfZW1asZzZYLZn+9BHjrDeKjGdeDauO8iOGl
	Jyb+Gjduw=
X-Google-Smtp-Source: AGHT+IGgZmzBUV/amNGnEGa7luDWILgf+KGTuionLoH5KD9j6k2QtY8yO9ArqOKUyuKX55y0EfRzFA==
X-Received: by 2002:a05:6214:2422:b0:781:55c8:eaf9 with SMTP id 6a1803df08f44-78155c8ed34mr62480326d6.38.1757957952579;
        Mon, 15 Sep 2025 10:39:12 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:12 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/14] lpfc: Abort outstanding ELS WQEs regardless if rmmod is in progress
Date: Mon, 15 Sep 2025 11:07:59 -0700
Message-Id: <20250915180811.137530-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driver rmmod may take a long time when in a very large SAN environment.
This is because outstanding ELS WQEs may end up taking E_D_TOV seconds to
complete causing long delays.  Speed this up by issuing aborts with the
ia bit set so that outstanding ELS WQEs complete faster.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a8fbdf7119d8..f84dca848bf0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12439,19 +12439,11 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	}
 
 	/*
-	 * If we're unloading, don't abort iocb on the ELS ring, but change
-	 * the callback so that nothing happens when it finishes.
+	 * Always abort the outstanding WQE and set the IA bit correctly
+	 * for the context.  This is necessary for correctly removing
+	 * outstanding ndlp reference counts when the CQE completes with
+	 * the XB bit set.
 	 */
-	if (test_bit(FC_UNLOADING, &vport->load_flag) &&
-	    pring->ringno == LPFC_ELS_RING) {
-		if (cmdiocb->cmd_flag & LPFC_IO_FABRIC)
-			cmdiocb->fabric_cmd_cmpl = lpfc_ignore_els_cmpl;
-		else
-			cmdiocb->cmd_cmpl = lpfc_ignore_els_cmpl;
-		return retval;
-	}
-
-	/* issue ABTS for this IOCB based on iotag */
 	abtsiocbp = __lpfc_sli_get_iocbq(phba);
 	if (abtsiocbp == NULL)
 		return IOCB_NORESOURCE;
-- 
2.38.0

