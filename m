Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7732F1A2628;
	Mon,  2 Sep 2024 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725287810; cv=none; b=OGCILqa/adHhTyM+IMi0jUGSfscP/H20TIKcyjwZQoEAPPiS6TMDPhlO8TgY8/mX2qMlzGruhs7cJ0xelg0nCZEqWUxBQu1rZ3ZzG8bQEvI/eV1/nZSaWLCz9F3svwY1wD+DYOc3hPrXbiD2DaJR9lkab0HXWIpqTD0QokcstAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725287810; c=relaxed/simple;
	bh=BIu1gp7ELmdLK5gvwz21S3jiud6p7hlpKwn5gvH5GqU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=nrEwMfrvNYnd7dJZgJJRY0lA30Th46sp1EXhzJpMwUxkc2Vw3UR8qcM8xqHt7XH4EQ4xZ5PoHd4SzCn9LmGXJopwcPipKi+5zcSAFwK3P3uqt4Jprs1v+qN7Aug6uchDs1mxmrCsccykuyhZWxVBe3wGe7GvxAbhhc/gCmtkNRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHEhJ16C; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHEhJ16C"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-374bd0da617so1415696f8f.3;
        Mon, 02 Sep 2024 07:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725287807; x=1725892607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uKj0aNBV9tNuPPqySgNHYjfCzm2j8p/eHdpBLhs285E=;
        b=aHEhJ16C9gTJ91mlHNZappZ5TtnafZpU6XA6+F4C9OQazXnoGsNCROMTBRYgr2lfRX
         4KUsCvEzzAK+h2xhbnu1RB+JaA+aZPJeXcjn+aO/Ff231xZLVHl014LUJuCpfNT1XoD6
         1MdH741vpHRnwAH96PhvVyyt1t8dFFqjohH2lR2PYBOQKzvB94ZjUOqsIbULHhQDTgoQ
         Kgta+0zFX/nRkaYSYIPZdMBzH/IyDyvMgh0T5LQxgUY2CWxKTve0K8VCeUfg/HZ6N44s
         F/4kNEig1Xvjn3qyXnybMt4eiNrrHpIVRlDJJurpi3WEOYmojZGqvDYxekzs4lSDZ2F8
         pmzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725287807; x=1725892607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uKj0aNBV9tNuPPqySgNHYjfCzm2j8p/eHdpBLhs285E=;
        b=szyK9snE5K8fQi0ZBiVjb3u180gWJM3Dzzpl2lKzj5doc7ioBSZF4QmOMBIB5vJzYz
         gnzdJ/O2D1ezg/HnNkVNnXSUprfwUWnqR8hIK79T6DJK3pep7qf51/CTybxdQXep1uXr
         HV8AMflZQn/4WmyQ8fWEq2SbI1GJKsTlkJiB7aZ8ncy+eheJD76dfQV35nOPyispq5gc
         eJKucvSMiZSzPBnGQ/Ad27nIEegkCqCy1gBuYOn3NZbpa+B7l2LP6tAe6Nfi1THQW7yK
         4zHG/wo8niTokLuDlfFrsKKijWoMhxuJRLUJCgGGwwKGGNuUgI9goRgu0nv2/erkjDms
         wcrA==
X-Forwarded-Encrypted: i=1; AJvYcCVgxbK48v/Ehc2kWJtjW/DEKgXzaALy5R6oGvOkvaNRuoF6+ydQ2lXqMzNKjFaymKAqYKufW4NpnDV0sg==@vger.kernel.org, AJvYcCWTrG5HqJDGhL75X0i1VJLuK2jGRB6abMIfLGG05ubjORS987bqnN5Ye4o2OAmhjrB3m6tdtHwo+kIp/FY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw/3b0ZCI1Yf/GLrpZqYvXoajEDC9c7Q1K3PN7msaUFP2PmifS
	VC9dSD85Bt4pQkQs5yxDUoDCD7yP+eeTHRpPzLPv3N5RI0NGMLaQ
X-Google-Smtp-Source: AGHT+IGxKjADQajpimqWsGX6Hx5iZ4bM8fHT3rKlOIwBGUp5d5CCRbhx3kiTpC2iKxXB7+I1DTIcuw==
X-Received: by 2002:adf:e9cc:0:b0:368:3731:1613 with SMTP id ffacd0b85a97d-374bce97f9dmr4385949f8f.13.1725287806598;
        Mon, 02 Sep 2024 07:36:46 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374c29aa150sm5896170f8f.101.2024.09.02.07.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 07:36:46 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: mpt3sas: Remove trailing space after \n newline
Date: Mon,  2 Sep 2024 15:36:45 +0100
Message-Id: <20240902143645.309537-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space after a newline in an ioc_info message.
Remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 9a24f7776d64..ebe4cbbc16e4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8899,8 +8899,8 @@ _base_check_ioc_facts_changes(struct MPT3SAS_ADAPTER *ioc)
 		if (!device_remove_in_progress) {
 			ioc_info(ioc,
 			    "Unable to allocate the memory for "
-			    "device_remove_in_progress of sz: %d\n "
-			    , pd_handles_sz);
+			    "device_remove_in_progress of sz: %d\n",
+			    pd_handles_sz);
 			return -ENOMEM;
 		}
 		memset(device_remove_in_progress +
-- 
2.39.2

