Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C571CF5C6
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 14:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753452982; cv=none; b=ZI89LPVeW/gahR4mZNWKuYAmRAL1FH8w+lirwqKshLwawpa1Sz6xL4+u1iCfDysOXBUeRfv4nG+d/qzL8xjZmvwHifPx32ysFroxoUbpiKhutUe+O6Sk3d1Jg58HV9GnOsWq7PpUJDQe3Myt4he8UsmcZxhRXuvilUX45b6oxuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753452982; c=relaxed/simple;
	bh=Xip8jE5pNwtMgx7ORp3HsgqbQwAw/yGfdOPBmn7/ojQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GgRoBM7+6vo7twQotKrmvQuKPtM94+mL005WOi3kQvdlIT6t06LUMWZpY7w+08pJcnTBfSCBoZ+eZWupR+L3oSG6zd1MlMxbK+t4nekB534tXCIOXxsG6BCQJXPB3DxJtEK/07sFzo3/rVWNqsLaeW4F2k72oowhV46sPW5KiD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qa5fzeGC; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qa5fzeGC"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ae0b2ead33cso386786466b.0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 07:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753452978; x=1754057778; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zam/LW3oj60VYDi/BrVgQJFij9S3YsCyteAYO8PX1E=;
        b=qa5fzeGCaPC7T/LANLBabBtX9iOfWWLDcXhdXjjKv4h96ps0BDv05BoMs6+cHbr7YA
         9wjbMSLbv8YqFDk3BuXvRnNx9AaMwLKASd9oehza2BDJnfLX3iEMnOJ/YO5lfOU9HszQ
         /cylqojecTdDERHbC8v4pqhkUgKKP2oJ2NRg8ybd6p37z8GwzvahflWZ5jzzv0L+Nb13
         AnEsgrjsSqb+oHrLgKdhzMYc6c14cdaaFcodT14LHa7hddAyrnLgjU0QmnD11pBdSutv
         rARAB67OwXYOiVSNlfB91NVpb/5Adnocnf3cX/dV4y8hGlXaeW1VJaBkEKZZoqqOMB4S
         KK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753452978; x=1754057778;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/zam/LW3oj60VYDi/BrVgQJFij9S3YsCyteAYO8PX1E=;
        b=P6AZfCHqdouzgOzvGAxH3bLpWBWyxX7t7GYpPqTNAhF4R5jauyctuMteAhjEgqu25O
         QwllBU+yh6P0+Pn8GFLHD9VRvXmBVFJueQJM/RlSk5/cW+RuHHnEf7PxRlcFhKLQimnh
         qjROapB7rA5nUzgn5FI419uclOAIzrVgHc8siyUjJuEkYZlyIIIto2UNYdUEElhjlS7E
         fNNb1GH+wyunKAV9NsuNG3sxncn3Ouu0yNU58tQV1T2m26RfR8IK8qhNvYGnTl9iDwxY
         Vf9DWLtY2r3n0WNOWSNu+7wXInL6XoAgODYxmDYNDIjGATbtV4K9BbINkfTIOHsGhzpe
         wsvg==
X-Forwarded-Encrypted: i=1; AJvYcCXi2oesRWIusB0hEtjJDzSGCWRIbU5BMn0DAhF5c6HzffcRtstJvse9uFABdVdDAPsGqDt/P/8cqoUQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwDHw118BuP504aw05IgwXil7lAdFAV/uYrCxpMSi+IalVaj5E9
	rGAecQ3rzIA0e6Un//iPTFe74E9GE9WPkkkEtXvIwSgd/jIfAcptctmgijaBjGISYZI=
X-Gm-Gg: ASbGncvgGs77FJ5QD53ccEv66yPI+sPR+G+Lc8ny2CVP0LsPJQ36ZlUKCu5J3BMUsx2
	v4py6l+LvD5X7Jo7u/I9oKPwD0Sxyjr/vR0s6GOTNqws55SzOoCbauSst9vw0n4ZmzlnNVnLgK3
	2K+D4Yk546p2btltWq4Ei4Yypp8pUhuGCpop5DLwZmxqYOM1ng1huW/DopMfaII20tuLsea/9J+
	OJZOjiDp/uRoX1/CQo/+EusySFNWwvNjzCNZHlDc30VmuxBcMIngWnW9vUqBjV1py62/PfHrsSt
	5YSd7cln9xceAPKinsvacsNK1260qUjSQ1D9Oveyqcrru7JJVxp3xeVCww98n/v/ATmnVfedIPK
	idDV3u4yOfwOOwd0rfyEY9Vftd1riZPaKdp7mbnid7VlV8va6OnyxUv2G1mTvKb/RhZGDiPWO8s
	/KLutYuA==
X-Google-Smtp-Source: AGHT+IFX5GnNzDHfFClTllxEfxM5knR3JPoKqdSRHH8rDBPQpxv4Ttm+JHD8dxakGBd8eBWGd9ILPw==
X-Received: by 2002:a17:907:9623:b0:ae3:c777:6e5e with SMTP id a640c23a62f3a-af61df52d26mr252419366b.19.1753452978372;
        Fri, 25 Jul 2025 07:16:18 -0700 (PDT)
Received: from puffmais.c.googlers.com (8.239.204.35.bc.googleusercontent.com. [35.204.239.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47f85e60bsm278398966b.96.2025.07.25.07.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 07:16:17 -0700 (PDT)
From: =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Date: Fri, 25 Jul 2025 15:16:15 +0100
Subject: [PATCH v2 1/2] scsi: ufs: core: complete polled requests also from
 interrupt context
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250725-ufshcd-hardirq-v2-1-884c11e0b0df@linaro.org>
References: <20250725-ufshcd-hardirq-v2-0-884c11e0b0df@linaro.org>
In-Reply-To: <20250725-ufshcd-hardirq-v2-0-884c11e0b0df@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>, 
 Tudor Ambarus <tudor.ambarus@linaro.org>, 
 Will McVicker <willmcvicker@google.com>, 
 Manivannan Sadhasivam <mani@kernel.org>, kernel-team@android.com, 
 linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
X-Mailer: b4 0.14.2

When commit ee8c88cab4af ("scsi: ufs: core: Fix the polling
implementation") was added, the block layer did not support completing
polled requests from interrupt context.

This has changed since (presumably with commit b99182c501c3 ("bio: add
pcpu caching for non-polling bio_put")) and it is possible to complete
polled requests also from interrupt context.

Therefore, this commit here changes the code to also complete polled
requests from interrupt context, mostly reverting above referenced
commit as it is not necessary anymore. We do keep the fix to make
ufshcd_poll() return a positive number.

The change has been verified using:
    fio --name=randread --rw=randread --ioengine=pvsync2 --hipri=1 \
        --direct=1 --bs=4k --numjobs=8 --size=32m --runtime=30 \
        --time_based --end_fsync=1 --group_reporting --filename=/foo

which appears to have completed with no errors with this commit.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: André Draszik <andre.draszik@linaro.org>
---
 drivers/ufs/core/ufshcd.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 13f7e0469141619cfc5e180aa730171ff01b8fb1..d8e2eabacd3efbf07458e81cc4d15ba7f05d3913 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5613,26 +5613,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		ufshcd_compl_one_cqe(hba, tag, NULL);
 }
 
-/* Any value that is not an existing queue number is fine for this constant. */
-enum {
-	UFSHCD_POLL_FROM_INTERRUPT_CONTEXT = -1
-};
-
-static void ufshcd_clear_polled(struct ufs_hba *hba,
-				unsigned long *completed_reqs)
-{
-	int tag;
-
-	for_each_set_bit(tag, completed_reqs, hba->nutrs) {
-		struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
-
-		if (!cmd)
-			continue;
-		if (scsi_cmd_to_rq(cmd)->cmd_flags & REQ_POLLED)
-			__clear_bit(tag, completed_reqs);
-	}
-}
-
 /*
  * Return: > 0 if one or more commands have been completed or 0 if no
  * requests have been completed.
@@ -5656,10 +5636,6 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
 		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
 		  hba->outstanding_reqs);
-	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
-		/* Do not complete polled requests from interrupt context. */
-		ufshcd_clear_polled(hba, &completed_reqs);
-	}
 	hba->outstanding_reqs &= ~completed_reqs;
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
@@ -5747,7 +5723,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * Ignore the ufshcd_poll() return value and return IRQ_HANDLED since we
 	 * do not want polling to trigger spurious interrupt complaints.
 	 */
-	ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
+	ufshcd_poll(hba->host, 0);
 
 	return IRQ_HANDLED;
 }

-- 
2.50.1.487.gc89ff58d15-goog

