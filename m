Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8D02F49EA
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272974; cv=none; b=rhSJAKhCWDwv5YJfmElnRkN69BUzKM6kHUqwYtqlVZKTXbPa3qhsPNkeiJqFb+ZPiJHmERHUbFKvW3hkEqlef0EcuLjDG1G9rrAZ4aIXdar4ot2BJSUN4IyD585DSSIdBOee6Btxv+EYjQBW2NCbwN5fwD0b2r79M5/3WTLbBxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272974; c=relaxed/simple;
	bh=BsOfz8TtCgxYRTGO9WNUzi/DOUudNyyk3zZvxT7vFrY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Man4CvwJSn1VpMmPAkcC4o82hNyc6bAlvjYQyJWsEc00pKpOdkpErZB+J8dH57oTpxl91EfUM5HzMSjaT9MmMO7srhAeN1QpRuZpAObq8cHRlDnkzdXu3vb5Qmt6o6uyB0MnXQ6MjuHuVSyS6emrS1jn1pgX5PsR3QLehowOi1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XTJWDVkX; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTJWDVkX"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-748f5a4a423so356117b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272972; x=1750877772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=huD6awxZrg2gNeeS0bpA8rMQJLJG6cQFLqt3kuxgLw4=;
        b=XTJWDVkXi6NR4l2gv9X109X0CKCeItGUrOJNYIsyfTzw79JZQVaczfD3mCAEXb78WH
         F1ELkmgY7SvBJpJcaL6Q+hfF/S6EGT6NLXn9KDVEHX9fsjRHx4DZClK4CRToANiQMbPP
         kKvfi9dRkMvPZw8VEjhLKxvsFp3IN+kWxuFlGF85WKAALpqKQKpBkn2IzlCYhzYJPxdH
         xRd9eFwIWrc9AM34E46CCneyOuXaZuUTiSGgtW1fmT2DXr5USk1414mOpWznZOCn1O57
         pskao74mwR2uY+di7i7hcu4oxQxM9/9tQFfcKjCH10qnN3094dLIITCJ63HBRk8NhODL
         YkUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272972; x=1750877772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huD6awxZrg2gNeeS0bpA8rMQJLJG6cQFLqt3kuxgLw4=;
        b=mKA21JKv5ok3XGHwoyRXT0hX2+z2dmKyu5atL4d4PTtNpLJ0MCWjvOzgS7xHJn8C75
         TLwlg5seEEPVAa6TxEOpOKW76TWyMfvE44vHWlrm3hldTfWseNSuDeo93wAuuPdUMJE/
         UapWdn4nLfA4g51jDL/gmKsuPNkfQa+ovC3ycwuLbFv6SuyS8iqZEqcIB6VY38oedJ4K
         MWn4rQV2a+0W7c3g5MSurqSuMJVQgpWqGaTTTfS2Tvh2z8mDpu3tMJR9HKG+1+IfqATQ
         mfS59udJflQj5uuZ6tr1ccELhG4ME/Il615adzRdi14Q5WMDSHrPF4XizGgE1wkGsrsS
         gi3g==
X-Gm-Message-State: AOJu0Yy54F+FqEgMp00668IX+K/dZxU7RFEN6ujbKdKQNTf1bpU31nnw
	C7mZfyhLaAZNi/GH20jE+FgZv30ko0M3E9W7BiJxR54JVNv9RKQ2CJAngEUqDQ==
X-Gm-Gg: ASbGncuSTzzy+5njF2vSPX5QzDzWm3wn8ddF6tP11HHxkXKZAv+IZyEyCF0vVRWSYXV
	jNm6v+/Mcgt2UU/vFtFU/NBCmHEv4zI9j1CRXGv0B83tJPbddlSENF+QRfGdDQN7nbDsamXaonk
	iMAzbbcGu52LriscP/3z1znJl0VaSLo09uIRKORlNFSm/vRn3nqcnnarrkW68y7D62Uvv5n2FbX
	odbhsY8KDQyGwHrerjL4AzSGhslbkXhe6KhTLj+9NT02rWDjvrX10nPGeGjbz9ROrbL9yvCnbPy
	Sm39ugoUZCcwHktWasCAaqpCBHcbQnnNSbfegHodQXWaQQSmNouyiDP3kN73SHCYPtVEoOtPPjO
	6Gs1U4de94YJMRQx64zPtsSTUD12IAnUzcHMH6fqNg85nCKc=
X-Google-Smtp-Source: AGHT+IEYkHSawcKesmqNuqjCDZ76owvvfYg9Yk8ToHV9w9BrmLoFekDAA8NoOoo2YGG7fGdpAQDtLg==
X-Received: by 2002:a05:6a00:399e:b0:748:f8ae:bdd7 with SMTP id d2e1a72fcca58-748f8aebec6mr349368b3a.9.1750272972331;
        Wed, 18 Jun 2025 11:56:12 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:12 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/13] lpfc: Early return out of FDMI cmpl for locally rejected statuses
Date: Wed, 18 Jun 2025 12:21:30 -0700
Message-Id: <20250618192138.124116-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If an FDMI request completes with local reject status and the request is
not retryable, there's no need to parse an FDMI response payload.  Insert
an early return statement for such cases.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index a88099b6e713..6baf1916d827 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2229,21 +2229,6 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Look for a retryable error */
 		if (ulp_status == IOSTAT_LOCAL_REJECT) {
 			switch ((ulp_word4 & IOERR_PARAM_MASK)) {
-			case IOERR_SLI_ABORTED:
-			case IOERR_SLI_DOWN:
-				/* Driver aborted this IO.  No retry as error
-				 * is likely Offline->Online or some adapter
-				 * error.  Recovery will try again, but if port
-				 * is not active there's no point to continue
-				 * issuing follow up FDMI commands.
-				 */
-				if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE)) {
-					free_ndlp = cmdiocb->ndlp;
-					lpfc_ct_free_iocb(phba, cmdiocb);
-					lpfc_nlp_put(free_ndlp);
-					return;
-				}
-				break;
 			case IOERR_ABORT_IN_PROGRESS:
 			case IOERR_SEQUENCE_TIMEOUT:
 			case IOERR_ILLEGAL_FRAME:
@@ -2269,6 +2254,9 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(free_ndlp);
 
+	if (ulp_status != IOSTAT_SUCCESS)
+		return;
+
 	ndlp = lpfc_findnode_did(vport, FDMI_DID);
 	if (!ndlp)
 		return;
-- 
2.38.0

