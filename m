Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C4C1C8FAC
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594377; cv=none; b=P0OmMd5W7bxP2Ln6Poc5rKSTetP+QEGLPsK6v+bTN3GcxVdVZF401f64bj1I5QErfTvL7z6ELEU74QQVMIfbDwHajk2ysP7iBoRYwo+Q4vyN21c1SS92aMT7bc1hSU95L/Jp7b5T6APLzFtNIkGXBrV69FLn7BQoF4sQqkdsmt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594377; c=relaxed/simple;
	bh=HETjeWSIE+mbVlhjmEFrZI9vC0g7DbF0FRTDqH9Y0D4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GG1eCFqi6foxy89t49Oww9Hy/XvViMcTJSft1tP8jUAd6V+fS8VsDS8Nd3BXPww9urfPSOVBCY0moqofpb7WaVMb58YJA60rea136ceX42z02SvA1AaoEbIl+ezilsAViGuc5Sw6lbB1xXM70bWpaBUTedFQj1orBHy2FT4FNKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MftaYAGM; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MftaYAGM"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-37a80cb5c94so533535ab.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 10:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594375; x=1720199175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGYcdO7kisSubyeq3w4oez0y3nBto0BXg7sI05A14qE=;
        b=MftaYAGMS7Jxo+e04VJuqNZlINTueN/J/CluI5DxVntzICfCCLFXntI7LXQif67jpx
         9nICvlUWDOKkX62BY3g4mDkyU1JATuCDt8DV988e6nvolwogUPax5qnyA9cFGBkmclfb
         KJP0jkfDglcPwaGtuuDTuDoKkYpgVO+bWRMuqJhcCS/BxeI3aO6U7Wxo9qzuAH8J6wFL
         e3Uuc3wEIdY3bMs1BBTfhIDbndhHzukr+6jy1xD5nbKpZoJ7SS4bHDAOKKAm8smYpxYb
         GnpofpQZTFGdfbn/0QxPM2PO0HJvkDE0d/8/2YHZ/+XPFqZrHyyhGqx7RNfUkZrMZy9v
         pKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594375; x=1720199175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGYcdO7kisSubyeq3w4oez0y3nBto0BXg7sI05A14qE=;
        b=PoMHBgJZxmugSGJqc9gP3aQ1FpYCDhaDZAz1Heij2c6FQ4/cFBYqAUzrKOZVAbAk0/
         Ay48pgHwvxwb4Uz+ADjCTuRrIg5CoYe75oDQZpGhcXhP0YwcSRyzUk9zHn2/noFjS436
         n/6u1EDePUoxWwgVTUTDGAjFkcind1RqZ1rhpIfsyyYWN6hY8nB97bhZoLYJI4YSWwM/
         dSLgiGU2v6HgTl6zJ0WPBUpN9++ZPhDaVMJYI7G5E1sDMmTsG4Tgjc2/GotIuJGiOwEw
         qzaAP1SbVPgD9XM+l1dZVF3T9/Q6HbXu4XGv2rQzUmywjHGhlsKmkU9M0dafe9xBewmM
         NKWQ==
X-Gm-Message-State: AOJu0Yxhrc/xIhb58/1imvhJiQLoJJSHlDR/kY55Mr0yOOikNl4BQ5gf
	p0/L/pFCpBzOtfH1SO34+XfXstSN/AnFRNctbZDZB522l96o5/m0r8bC0g==
X-Google-Smtp-Source: AGHT+IGnVdbyoSbRwrqyAuWyZObdZtSTFceACiHsSzsqfAxHlMONF+Cm0CWHs7hltoQUg2GpWaFGbw==
X-Received: by 2002:a05:6e02:4b2:b0:379:2b4d:d5de with SMTP id e9e14a558f8ab-3792b4dd9cdmr68060315ab.2.1719594375431;
        Fri, 28 Jun 2024 10:06:15 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb8ef1sm1524623a12.40.2024.06.28.10.06.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:06:15 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/8] lpfc: Relax PRLI issue conditions after GID_FT response
Date: Fri, 28 Jun 2024 10:20:06 -0700
Message-Id: <20240628172011.25921-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240628172011.25921-1-justintee8345@gmail.com>
References: <20240628172011.25921-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If previously in REG_LOGIN_ISSUE state, then remove the requirement that
PLOGI must have been received from the remote port before issuing a PRLI.
After GID_FT completes, it does not matter whether the driver itself sent a
PLOGI or received one.  The fact that we're in REG_LOGIN_ISSUE state simply
means that the next state should be issuing the PRLI to continue discovery
of the remote port.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 376d0f958b72..2dedd1493e5b 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1553,22 +1553,14 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			if (ndlp->nlp_state == NLP_STE_REG_LOGIN_ISSUE &&
 			    ndlp->nlp_fc4_type) {
 				ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
-				/* This is a fabric topology so if discovery
-				 * started with an unsolicited PLOGI, don't
-				 * send a PRLI.  Targets don't issue PLOGI or
-				 * PRLI when acting as a target. Likely this is
-				 * an initiator function.
-				 */
-				if (!(ndlp->nlp_flag & NLP_RCV_PLOGI)) {
-					lpfc_nlp_set_state(vport, ndlp,
-							   NLP_STE_PRLI_ISSUE);
-					lpfc_issue_els_prli(vport, ndlp, 0);
-				}
+				lpfc_nlp_set_state(vport, ndlp,
+						   NLP_STE_PRLI_ISSUE);
+				lpfc_issue_els_prli(vport, ndlp, 0);
 			} else if (!ndlp->nlp_fc4_type) {
 				/* If fc4 type is still unknown, then LOGO */
 				lpfc_printf_vlog(vport, KERN_INFO,
 						 LOG_DISCOVERY | LOG_NODE,
-						 "6443 Sending LOGO ndlp x%px,"
+						 "6443 Sending LOGO ndlp x%px, "
 						 "DID x%06x with fc4_type: "
 						 "x%08x, state: %d\n",
 						 ndlp, did, ndlp->nlp_fc4_type,
-- 
2.38.0

