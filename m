Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4171183CBB;
	Mon,  2 Sep 2024 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725298033; cv=none; b=ONYeRrVxh+1+i/Qv8zeQwEOFTJG1KsODrpU647xik4k6MOKF7SBdxFBYaCc3iZT+jLNjh2WWFxPqcJSejI3DrgM8FiHkRg3EwOdgcCYwkzsiojWF/c0mH2Sf+5nLztXGIMrfk/HguyLbSVAhWiThEL8l9uOFMSh4tQ1gXQS4cjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725298033; c=relaxed/simple;
	bh=bKwv7PTScplyThgl7fVwhkZHF0Z9uOyJYG3hZpnXuXY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=gXjOxrcJzBNeB19UVICfIcrDPzdDO22qTwBkz82BM2IDK8a5/Jsi7IYMb+UYpSaZD1eHbCdw7wpNO8MRiSlIAZr/JG5L2nsNCTrJTuzGZpSr9WUXrEqeWTqP7eDniznnnzv1scdQqlVjp7VC6qU4SkvMuiTsBi9k4rPU266HYVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KYXab5WC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KYXab5WC"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-42bbffe38e6so21782825e9.0;
        Mon, 02 Sep 2024 10:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725298030; x=1725902830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L4Xue4TSRIddUTjFb4xLBuFSp8O+ZsGp4epKVCdznvY=;
        b=KYXab5WCLQfm3w4u/hZrtupfTJF9EwcZDyL9RV/p5JQCm4v8PKujwNpY6E83A+PRAr
         dPEUiBU6AM29qqJ1Wdhv40OrPq4oBwuCvegOWWtDp/41+MH6JWC/BHc/pzjeR/sZntbz
         m404gGQ9jQCYgwu2MYoCOCiVo+QTSmNcRHzG6QvSh3O5GEJXC1JYCtnuZa1mkC+sarz3
         rohtRUbP3Q5frtQINKmEiGW0pnijjUqGYJ17PUCRZK9vOyKqO4m+OoMWWffWZKwDO8LM
         qLnZOrMvFCYnHEEIFJPq11Dr9PgwxGlQWwugwkQGWsEZjNKP14llfYzzGn7TY3yFFBeL
         alZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725298030; x=1725902830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L4Xue4TSRIddUTjFb4xLBuFSp8O+ZsGp4epKVCdznvY=;
        b=nyM4CS6pWSfbRR6S2qbPySbmftu+6XJKxFQ7MHF3vUdA7ffEv74JxbPeBtLhROZuUM
         UFR55UFt0nMLKjwmTEXq5ZNZbNm3CvyGM1l7PkrbY5GfnPSTRkMAbeUpagfW/J3V8NuW
         DNc2i+CdMjhWZ2Rbo6JAcqZ8QSVdjjX2NaE7IvKVkJqcduC9Nw5hdMtAIHP73CB0o5bV
         cuxQfw06me6rCsEsKajbX2YUxL1EAh6C3Y12VF+bYHlCz+4LxP63JzkJJQ5ygwdYpIlp
         9pC/BM7moOFVzVdnjDkFlzKv9bhWbiCcTwsBV9egQvSX0rrlj4qb2ZZaoQJDTRT4Atxw
         c08g==
X-Forwarded-Encrypted: i=1; AJvYcCUEFZWdzV/61wYuah/XD02nJsg4NGq7yicBzG6zbzyP9CX2cl6EjwcKn6Zvz9e3Yl+eeqbSclIVipOOMQ==@vger.kernel.org, AJvYcCVRF++Qe4F7nJmBnl2GhdGHhpE38HcsN1Xxd7XZkKDGO2Ikk6KAfcdqiBlZ/CxnS1c8KnHF5NKBggrCbIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw04DEbdPMa63nVHNvkQ2W+bco36Nr0PDiccxnxH/D/DRsBmkD
	3ujO/yDKL3kP02/8TaUq3HZtKGgF02Esx+vANeiuu5TBGwZzLWEBbQP1npDW
X-Google-Smtp-Source: AGHT+IE0Cq7vS54YOMDsAz35O1QxsQPrPpj+yty2reHAikKprAxZ3TI9wS5m0sg8FVR7g7OSULYFpA==
X-Received: by 2002:a5d:4a46:0:b0:374:c481:3f6 with SMTP id ffacd0b85a97d-374c4810438mr3766464f8f.8.1725298029759;
        Mon, 02 Sep 2024 10:27:09 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374bd0ce240sm7653214f8f.70.2024.09.02.10.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 10:27:09 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH][next][V2] scsi: mpt3sas: Remove trailing space after \n newline
Date: Mon,  2 Sep 2024 18:27:08 +0100
Message-Id: <20240902172708.369741-1-colin.i.king@gmail.com>
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
Remove it and join to split literal strings into one.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---

V2: join split literal strings into one as noted by Christophe Jaillet

---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 9a24f7776d64..ed5046593fda 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8898,9 +8898,8 @@ _base_check_ioc_facts_changes(struct MPT3SAS_ADAPTER *ioc)
 		    ioc->device_remove_in_progress, pd_handles_sz, GFP_KERNEL);
 		if (!device_remove_in_progress) {
 			ioc_info(ioc,
-			    "Unable to allocate the memory for "
-			    "device_remove_in_progress of sz: %d\n "
-			    , pd_handles_sz);
+			    "Unable to allocate the memory for device_remove_in_progress of sz: %d\n",
+			    pd_handles_sz);
 			return -ENOMEM;
 		}
 		memset(device_remove_in_progress +
-- 
2.39.2

