Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B6F29C328
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 06:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765436154; cv=none; b=kEmUTimbpOOIrNUnOzwuAzcemC5xOkP1EPHtYnbiBqyaIZtSiu4+qQeIoArA5+bCLo3cckKSg3KtJeNHeWGMRIRcItW2jguyhPafD7lhA0fF4vFqrnggn3GPjYJs06jDKlvp5NaYFLPPrYYxRAyrBl9F2kyB4S4EFlpa+uXiUJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765436154; c=relaxed/simple;
	bh=Mkjb8FmlHofdZ4LQA/AqsxtCw5U0GijjUPoZvOhitVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTuGc23dn1LmvPdng7Fqj7H7b4vubtqrWRX4RqdknMZ6Erh7de4LISoXAY2zBdDTBEkK3eYffDF9xPJA1rmUzxYwlYjTVvZOwVRg6xCh42lwTSjvkSWqrTqxTlJBrnMh5qBpDuxH4/Nbe/iivoPJGf2DLUSYqSQPkiwUPbGJ7DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fG83HXOn; arc=none smtp.client-ip=209.85.210.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fG83HXOn"
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-7f0db5700b2so544171b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 22:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765436153; x=1766040953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yf88xxHSv/EseHBXYTUsvbNHLGypn/BpxJ84JD2iEf8=;
        b=fG83HXOnlLEol5/waXylh0nh9R287RMcctnpamPfaWZuqRoHRs5Z7qdQZMjqzvUP8m
         sp6Am1pSgihGDxcjoMyiKXSo1aseRiChNLwXk+1gTHthlwJteKbinYZCCQP0zehu8cXi
         HoabBAFgzlb78wZ19QAr+YoevSxV9V0smL0CqmTQuULw+x/KlQx4YVxydvE5209CVSsw
         0cYkR+C5vNecfDwmZqJMRw+eFmxRoolazYRrtRkHdeiJ5p7pHl1o9WV3KznRyHo8thYU
         sHDRGlfIQSjGoT7on3fXFj785UBApMtILMo4Xnl8H0ARPjJOV/duS6wf6pR0L/Z2V0zZ
         CPBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765436153; x=1766040953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yf88xxHSv/EseHBXYTUsvbNHLGypn/BpxJ84JD2iEf8=;
        b=dSzwT13rMaPhrAECUA0sGwDDFFrAfW6NPjeZPfun57luP7eubNVOJjfhX1dcQqi6rE
         pPAbAa3E+rxAhvqN5Ot91ssNs+jJxRthakKxmJZ5Qzh8agJLPcpAh+GEL9d+aps30h2w
         O2e9cMS5/e3kNBf9n1TWCXIoubZkE4mP62+T/ZOuBw6ZbtaDT2/tnQCXqpl+TQBneZmZ
         tHydHHMmrMgm4AZF/EbcTjScPg5QzWcIuphW9+9vpbl+Lt94jAq9hI/7p0fRWFMYoART
         i2QwftN8Xjep2hWHBGAuP6tJnHR798apKoCshi+2XlWEj1PBKifQOHLinNYwAjkA13bO
         wvYw==
X-Gm-Message-State: AOJu0Yx3eTJST4/jR80+R7p2KMYo8xGBRl8xC1M+982JIjAd9hXOyl6W
	ACZuQG8EGyksVuWi+7OOezTCC2se0IwLe5CAX4LH4S7AkdyJjuESdliuwwrtpdTENe46PA==
X-Gm-Gg: AY/fxX7nnJqQPV3KoQd8GMxiN7uW1nFlGwPJ08qGnxPS1vuszhqZAsD+iEL+/EbVz+z
	5xwHyW4cqjG48nrT7L5MxW9YzupRtY0arABuyvTWgcaDLN2YD7N1atp4MzmrjpIg8X6oXY2OFGM
	ZAfCkH2WrK0fKifpDKrSR4QRT17DJNF12bvj4ZSBqBw4rxNJ20Y3mHVWkinqiGuUcoouZldVsto
	XEimwMwr5VoIC361WHRadwNX/QqUjsWa0DbUBpQQbzkmjHPkA0B5VWwNeYw+ncI94YEW04FTmgk
	fDc5GJ/s9orkt+o94jDq66/omcbbYngiKAt8RGDEJW0oDgfj7t9BDNZwTfwtnfrtFY/UhoYnRiJ
	NRJrYHYIufz6+9uYbYPtJlpVi7HtPNl9TDfPyU8RdiOohG3wpr5shHMrlU/sUMNJz3ZE1MYECJs
	UeRn7JQNeW9y7yFvLygxc1VTlyxE9VYPMfj1maSwKUTrRn6fz7DMNKhzmSN7UMyfmu+2RRYf6Hf
	jrj
X-Google-Smtp-Source: AGHT+IFy7wmpCIQJPvW1iCzLXhF/L1hSYP2+uAHPRvBZ51TWxjUAgndho8o6ozOGcKEjdHX9WfCUDQ==
X-Received: by 2002:a05:7022:2521:b0:11b:8161:5cfc with SMTP id a92af1059eb24-11f296dbf4emr4845620c88.36.1765436152521;
        Wed, 10 Dec 2025 22:55:52 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2ffac2sm5355997c88.11.2025.12.10.22.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 22:55:52 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH v2 2/2] scsi: sym53c8xx_2: remove empty sym_init_tcb function
Date: Wed, 10 Dec 2025 22:55:31 -0800
Message-ID: <20251211065538.146629-2-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251211065538.146629-1-enelsonmoore@gmail.com>
References: <20251211014246.38423-2-enelsonmoore@gmail.com>
 <20251211065538.146629-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 38747ece8c94..426608324af8 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4906,14 +4906,6 @@ static struct sym_ccb *sym_ccb_from_dsa(struct sym_hcb *np, u32 dsa)
 	return cp;
 }
 
-/*
- *  Target control block initialisation.
- *  Nothing important to do at the moment.
- */
-static void sym_init_tcb (struct sym_hcb *np, u_char tn)
-{
-}
-
 /*
  *  Lun control block allocation and initialization.
  */
@@ -4922,11 +4914,6 @@ struct sym_lcb *sym_alloc_lcb (struct sym_hcb *np, u_char tn, u_char ln)
 	struct sym_tcb *tp = &np->target[tn];
 	struct sym_lcb *lp = NULL;
 
-	/*
-	 *  Initialize the target control block if not yet.
-	 */
-	sym_init_tcb (np, tn);
-
 	/*
 	 *  Allocate the LCB bus address array.
 	 *  Compute the bus address of this table.
-- 
2.43.0

