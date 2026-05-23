Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52473A48F3
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779546032; cv=none; b=DoA1GFhS6RN8/KSsbrtnqQ0xH8sPQCXNhDD+k72n+w40HbP+vZsieOAsa42oA7GYgO9LHrCFn8JN2PPpDeeDmHG4xSGAaiunuhQ15oVV1mgwpCe28hMA5dCIhLJdC7N8+SreMdhEXqxgoLbiRo+UQy713eLZG3Kk/ijgu1yVC80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779546032; c=relaxed/simple;
	bh=ZSJOPyr35RQeaOG8o276/ATgZ5oe2GoTrHwZqBpB974=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cim7yCq7bUbGKIxpZCxnmCUG8zWlWmook8C856xuxZ27ZX/PE2Wn+ysjhKtcSCNIZtJdY//NzgDlIuq9uHA8ei70nq06wzm4FyRVyiPkfa8tywZl45Mg8117/Ob68oNmE1HF+Zwx5IujI+Ec6ywWvRaHEQt7/RbR3Y6hUx3qeas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CXLbGmkO; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXLbGmkO"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45e6c2d9c5cso782643f8f.1
        for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 07:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779546029; x=1780150829; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cJbC1DfwDmQBxJxR3o/BLm0scMVdvZBlcSgmKQSeA/A=;
        b=CXLbGmkOy3RvnEWsKv5Up4xLiwoZUjehntIclPP9cI9e+xJO37fUAxOEi4TaXiFgXf
         Q5W0GqU0DvpQRgc1Kt234oBIpk9EWwei5bO1OJJHbjJ6igPdbP+cjqC/iM4qxcF3l8W0
         JODXzbPi5V+RIQ/D7BquQZGO/MKsvj8wWrQquShxCTbH398tNHFFTUuoX8M4rFN9XMrH
         zL/+1VyojR/5EG1Zhhs0RvjyxFewnikU5DTjI+2quRQlq84p7Goi+33YIPZo9Wgg6fbI
         pMA5YizJbOLn+c9nLdvCsQuioGhm2dcN3SMyWCIZtp7e+BltWj3ZwScXt9OfEHvGZY87
         Fyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779546029; x=1780150829;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cJbC1DfwDmQBxJxR3o/BLm0scMVdvZBlcSgmKQSeA/A=;
        b=MSMl70utNrDjrBYkC/+OVno/50pBb334t2QZoM7uNtM83TAh5KVueQUSxLdF0i1mtK
         rWAIEopneIw6yN5wVUvxjDa8G1tY7RiA0QyxJ2fSBPtke+yogtr0vfU6xnsg9EMO4aq/
         FBcwfTSgq4nzXLvbk1ch+7pMA6JE9w58J+n/b5/dAeW0EEO1Q/GbFm+7tiegbVx8rBYm
         EN5AudSDjjrRhwXiMQJx07MPNoooHYr9gQzKqFCImeGmWJnkgGK+ZxnNonMa8ZWA2/EU
         JNekaqbaD6/e1I1v8Kk7eMaehI8sHRFBaRs3nUskdu7yNBj/SVe0fIUWJgF13rVbCchI
         w6yw==
X-Forwarded-Encrypted: i=1; AFNElJ+J/ssPdOMvoX0U2MUPba87Pe0z2Jmyj3suzLB7ve3N+OLepTmPGpIM4PiRLI4z7K/SuMGhcBZdxzsK@vger.kernel.org
X-Gm-Message-State: AOJu0YyrxlW79M+MbHbygBuEvN2HHRk4yTxkcpoEGnWshpcMnJiYjUpY
	afpnz693GYIkSiRBQydMSN8FE7/ixGBWgp5UB5KEff7Gc9J+ru09NQA=
X-Gm-Gg: Acq92OEdvmVLpTUZAMUtKeh8UGnCPrGfKOX/lcocpToEnLqH8+KPVrubhOKAI2RycZp
	RNWtBDmz45mHrqV5emhW6m+PDucK8eKpWnvHJBf7TD+PEik4BydIB7u0Z+8uH8jbeKT+j/ot+Od
	pa2CPXaVj1W5c4NkUxv7e0raokwbfQIzyqKeu7LqxKAHNQuliz1GT7HWg8G5fsrJKYzGpyf1YQ3
	evlzgn/C0vDudeO/BUeUFAZWRU/aBv/YR+wyaN39KfxrAYepxJ2KGDwLvymTly67JC8nhicAAIy
	MgnS0Wyjteha95i639DyMpuAYunNwvoWEdTjp3ENrVvv7fbMFSCJiBURnqoHxjIREMb8Gtl9JJN
	SuT0rJPcbDjrnxowdn1YDtmwqako32fOc2R1Sr6W+C6IVNXg0trTCmjbSx+X9SgcyWO5UYzFQPa
	acP/U0XuZNdv8hwiqw1In3ZNO7b2mRRgoJue1urUYrfM7iEDgHGzLt1uBPUbKZ
X-Received: by 2002:a05:600c:8484:b0:48d:1021:e5d1 with SMTP id 5b1f17b1804b1-490428cde40mr57373075e9.3.1779546028962;
        Sat, 23 May 2026 07:20:28 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904561a33dsm113313025e9.11.2026.05.23.07.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 07:20:28 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: devinfo: drop "Promise"/"" entry from scsi_static_device_list
Date: Sat, 23 May 2026 16:20:27 +0200
Message-ID: <20260523142027.352969-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

"Promise" "" is too generic, and affects any device from this vendor,
regardless of its actual bugs. Applying BLIST_SPARSELUN globally is an
overbroad approach.

It was originally intended solely for "st_shasta" family of controllers
(SuperTrak EX8350/8300/16350/16300/EX12350/EX4350/EX24350), as established
in commit e0b2e597d5dd ([SCSI] stex: fix id mapping issue):
"   -- add an entry in scsi_devindo.c to force sequential lun scan
       (for st_shasta controllers)"

Removing this catch-all entry prevents unintended behavior on other 
Promise storage products that do not require this legacy workaround.


Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
All email addresses from @tw.promise.com or @promise.com, in the git
rep, no longer exist.
---
 drivers/scsi/scsi_devinfo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 3a9b691d7e72..5988d941e76b 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -216,7 +216,6 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
-	{"Promise", "", NULL, BLIST_SPARSELUN},
 	{"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
 	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
 	{"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},
-- 
2.54.0

