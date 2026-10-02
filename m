Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBB751475A
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2026 18:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790965336; cv=none; b=ggTLQLGn10OY8OPtIzxBHjQlEHp6kQwvhifDmidapORIOFqMTG00v/6T45Uhrf+kPGrxcdfKSc5QAXHA7wswTsmocL3G3Tnk5u36HjLQ10LORCrcar8WpVAwsHEHHouWyz0baSjO3kfXpkKBm4FY4UVIyN3CzywBDyOwiV1HP8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790965336; c=relaxed/simple;
	bh=z86LkUIJGncZohMq8pzvcEsnCClHce9tf8FWlbSTuX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzR5G5eq+6100NM2nCgxAHSg5MK6tlQcFy2KDisY67PMJxNc/TWNZcjUI+c8JLWhMjXS1natR82zLjf/NILKeWc/3bFx5BpfC6XVbn98IwM+kxV7a9MitTW68NFzJ2hLaKNrLdrj4a6EBndzH06FyaVimIwTx+NaYUc5/D7x0gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=VsMHuiya; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="VsMHuiya"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33c24422d4dso9748702eec.2
        for <linux-scsi@vger.kernel.org>; Fri, 02 Oct 2026 11:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790965334; x=1791570134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5olT9qPfC8fFiGwrdNseOTZzDzg1Nv427aOzA6C50hI=;
        b=VsMHuiyaEAOJUTqaNTVU025UeVnNurYe5Vo7c0aF6EwduRZVSNq8wrfIey1a2p9KPw
         cX8miMZ5zDafK235NwUkRVxPZJCQLfejYdSe+hDyf+5jcj7Cz3UIOOqOnlHfrsc84r+n
         73zr6BxtyebL4fayFDcoPrsrgc+LN2mayJZvn9Ar8bOsyVjt4ipjx1NbZ3EQ+sRA3eBG
         2EUqpkCyJuMQdRdTBoPJVRjfFRtwUvcEnrTLo5dBBVazSsvQhb7J0MVCwsPcB0CodWhg
         /cbx5Y4/LIyWEQ8R5Dl6dob7/MJms3/H35Nw4/Smmpe7RZBxUfmrdkYNqwkdCKYXi5Yo
         QQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790965334; x=1791570134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5olT9qPfC8fFiGwrdNseOTZzDzg1Nv427aOzA6C50hI=;
        b=TcQybcmLxFq9DDCaYabhlrzvvcKite/Yv2lcp7UDBcJA1MGP7IovpjWGJqUFB3lXu9
         4D8BNhn84qZvtw9mWsRmGcZ68AlX2IEfgyo7HgZY4P84hy696UY2xs4YRjLsFb/fMMex
         UbQp/nd6wA8JZ1Vlkp7mR4ZJ4Sa5/9YZLeSlaG55fEKqDy2zXyZMjNnMC46jg459x67A
         VeRrRn5qE7ll9u53usOyVe1ifbDCV1tdbPPjLEglhablQ1SGWO9G0oJ6AKp8bPBDLOR6
         JDx86+Efqx7ZWwcYBicPCBVrqsaBzQB2ifsgbo65Oa6tqW6VxC8UMS4038c3XM0iEseQ
         yHSw==
X-Forwarded-Encrypted: i=1; AKwUvBxUQbU/yI1lYYUi/ed7tvgQv0Un1US/HUIcg7IVpK8BsB5fph4ElUeAga4WmRsgf5FEEhu7W17CJBxb@vger.kernel.org
X-Gm-Message-State: AFq9FYKNN/c5MZoeMjOJFwhwjwbwWd+AEuZcO2ylRaCJ3/F46FYGYXhs
	GIXH4IBNVCyTqmk0f8E177y44PV95ccsHdM8zqaP7LSr0Ms/denTdInqh/JcQfgrPI8=
X-Gm-Gg: AYBFou1nR68i4glnyzeIDJmHmVrSBujQ2gdmOB4GrenJMfCZMfmGaeIysxDR0E2CByY
	JoYRyFQehMi29jABff0SrKrnVtOJGH3qMRYCxzKnExXDQ4Ffm8WeVCyDX26ZQXkE57QPm1FhDWd
	AtEt7gdTXzw9ozwGYzNYz9Qmz7YEP6pRJErxoUvEVm38OPAX1kTMua1i/2K3ChGSvgbAxetWHFK
	3vcWR0Q8nrdtjfuVMrd6PKTndQ2X83CiDOYC+bjjSYYCja3FThpOpRFtUYHQGJWscra5ucZYLt2
	/sSLX3Z8vg/VulkcvaxaXIs92e0jrxpN0DnrmX+pwGRla8yIRbxBjhn7E31VP6kXsqzQaRTS9dc
	5JdkV0T1nZep6/xnzLGLbPwIXl8iHIjPUyd3wWLxrdVNCOmTzNhjIIeXM4n+oTcNSUxx79m5HqO
	4jesHfIGagHK0CTLN8YXs25s49FfA/1N3yXqPxmcFwEFYDGkfC9BO4M6IupFadbmOoVobzd9STM
	B+FKRyv3lYKoZdEbPubCCszWkveFf1ZjtP4QYCrg53FFMh2kZWdqX1ZMFok6mL6xN5zvPs=
X-Received: by 2002:a05:7300:6aa1:b0:33b:d89e:9fb2 with SMTP id 5a478bee46e88-34f14f2c2e3mr3858384eec.4.1790965333683;
        Fri, 02 Oct 2026 11:22:13 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:bcf9:6140:24a9:d1e7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c2d1sm10551449eec.4.2026.10.02.11.22.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 02 Oct 2026 11:22:13 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Paul Ely <paul.ely@broadcom.com>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	James Bottomley <jejb@linux.ibm.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Martin Petersen <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Artem Dinaburg <artem@trailofbits.com>
Subject: [PATCH 6.6.y v2 2/2] scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
Date: Fri,  2 Oct 2026 14:22:03 -0400
Message-ID: <20261002182205.11550-3-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002182205.11550-1-artem@trailofbits.com>
References: <20261002182205.11550-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit ede596b1434b57c0b3fd5c02b326efe5c54f6e48 ]

The MBX_TIMEOUT return code is not handled in lpfc_get_sfp_info and the
routine unconditionally frees submitted mailbox commands regardless of
return status.  The issue is that for MBX_TIMEOUT cases, when firmware
returns SFP information at a later time, that same mailbox memory region
references previously freed memory in its cmpl routine.

Fix by adding checks for the MBX_TIMEOUT return code.  During mailbox
resource cleanup, check the mbox flag to make sure that the wait did not
timeout.  If the MBOX_WAKE flag is not set, then do not free the resources
because it will be freed when firmware completes the mailbox at a later
time in its cmpl routine.

Also, increase the timeout from 30 to 60 seconds to accommodate boot
scripts requiring longer timeouts.

[ Backport to 6.6.y: depend on the preceding ext_buf split from upstream
  commit 115d137aa918 ("scsi: lpfc: Define lpfc_dmabuf type for ctx_buf
  ptr") so an SLI3 late completion copies its payload separately from the
  DMA descriptor. Retain the 6.6.y ctx_ndlp assignments. ]

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240628172011.25921-6-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8ef571498d846..aae08ad0f332b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7309,13 +7309,13 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 	}
 	mbox->vport = phba->pport;
 	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
-
-	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
 	if (rc == MBX_NOT_FINISHED) {
 		rc = 1;
 		goto error;
 	}
-
+	if (rc == MBX_TIMEOUT)
+		goto error;
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
 	else
@@ -7369,7 +7369,10 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 	}
 
 	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
-	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
+
+	if (rc == MBX_TIMEOUT)
+		goto error;
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe)) {
 		rc = 1;
 		goto error;
@@ -7380,8 +7383,10 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 			     DMP_SFF_PAGE_A2_SIZE);
 
 error:
-	mbox->ctx_buf = mpsave;
-	lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	if (mbox->mbox_flag & LPFC_MBX_WAKE) {
+		mbox->ctx_buf = mpsave;
+		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	}
 
 	return rc;
 
-- 
2.39.5

