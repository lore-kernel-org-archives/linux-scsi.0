Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E709718FDC4;
	Wed,  5 Jun 2024 09:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579072; cv=none; b=YDbqudRmBbqClc5MpEOuJO05Hb1KkaK0n4D5+rWIExUj3Z2bNGqpZSRev6Yu4wZqPamOXZKspeQ/9/9L5PpOp5KGjPrbObx9xwhz9/yv+P44+F/mXf+pjkpuV+XgnzHWw6zfoysdzocxyLmLrC9Dv1YYWWRYXUUp4vT3fXwzpMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579072; c=relaxed/simple;
	bh=pMxUMl191c0/PG/P+rLKeQn8EAI2483T2RHmYGHHcKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MMNKRe5N5TUS5x87VBTd6Nemqh2uKOL9RTylmM1w3wWBq9frwMTE5M0gCfBUNaXIvVCvboWi6CaHOojyNF6FOkiqifT0PAOqgeJ/cXPqsfl9eAx3Oc6cZO0kVrmwRPPuFCBpt+USU+r/MN46oJlDLAFZ3DPMbCijDbj4gpOy29k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FnmuLER2; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FnmuLER2"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-6c5bcb8e8edso4066535a12.2;
        Wed, 05 Jun 2024 02:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717579070; x=1718183870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aqcyHeP6+d7Q5rGdMikjLoTNpmMTGK5vgU8vu0L1700=;
        b=FnmuLER2DrFRbkFXGjikW4vKUASwC1mg3oqgzPWVdVbi4mAU1tdc73P/Ps+NiQFTAO
         5K0K6T4i/ycJS9KsCmhLH5V4lcw4QcoZN/p5IG5Y6uF/DCITfW+r0x88zXGtbqGoI9Zg
         T8Rx/oDXc8TxRnxKjH/Aq6OXTwlGggAm9Jn2JhZ6vlPvMA64dkzJgdDWPsZu7pIgFGxd
         zo/lY7iYFFzI9pWKau+cryvz9KLRUNThlD0Ls60yfV87hgzaJVG1JrpV+ulZ8vVdGkVx
         QEaNOFA9JFgMuBG2o8csfWOTNJ3jKOntUjgVgfh72M2l2mX4cj32TgcXDuZGcIO8ec0f
         P/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717579070; x=1718183870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aqcyHeP6+d7Q5rGdMikjLoTNpmMTGK5vgU8vu0L1700=;
        b=b2u1O3tmUHibgKm3BJm0+4ATVRYYMNCLMQJK/koWi/szdDueU2ZKw2zT0AZ7RxMMNO
         htSd+tvx56aYGA3kTEn3Ch1M36Rot3DqeB6dSMtyCneK49kXSRycNedFf02KG/ZOp0Np
         slNAm6lbV0xlKvpTP+Cjy86We7kNABSu9mHkDInKKFj5ia2hBlvmqKwGYJvCTaaHmO4S
         W+qmUfnBIypy/9Z01K07XYg6Sw/JISkN37VpdCyxIEhWT3bGJlcXSwdFUlDsFwhatICo
         aciadMFF3MvLgfkT2sovKkUUUXZnzJUj7zpKpVwD+CSbqY40M0kxgb/Ozus3uSI6zDIL
         0a2A==
X-Forwarded-Encrypted: i=1; AJvYcCVJNHjvl7w049rlsKLwl84XXRO/n5FPvtA0IIiG9/E0nOtgPB/u6o8q5YuFdDjPbXI/+EgwRVPSBxKAXLMXOHH0EUkbu6r6JU/TqVoeQsO99Ul9PXvZ5xdlz5wxL1QSvEwSrV3z+zXw7g==
X-Gm-Message-State: AOJu0YwP6XdvZ5OgU0+7YDJmaE9e3fW48lk1aRrV9ml+q8ryihddVN7B
	ZC8m1L6ydypks5xBiGTR1xf65V0HMMO9WY8MUr++dnXbMXHjYfbu
X-Google-Smtp-Source: AGHT+IFwBnpigS8zdTpmmJXpHWyi1qsZY2sMMHV6dmnZiD38Zapxw5OiDYqkRkPD8FKDfgamoiA26w==
X-Received: by 2002:a05:6a20:3d87:b0:1af:6fe9:5039 with SMTP id adf61e73a8af0-1b2b73ade2fmr2408720637.1.1717579070168;
        Wed, 05 Jun 2024 02:17:50 -0700 (PDT)
Received: from localhost (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c2806cfa62sm964831a91.48.2024.06.05.02.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 02:17:49 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Wenchao Hao <haowenchao22@gmail.com>
Subject: [PATCH v5 2/3] scsi: scsi_error: Fix wrong statistic when print error info
Date: Wed,  5 Jun 2024 17:17:30 +0800
Message-Id: <20240605091731.3111195-3-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20240605091731.3111195-1-haowenchao22@gmail.com>
References: <20240605091731.3111195-1-haowenchao22@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

shost_for_each_device() would skip devices which is in progress of
removing, so commands of these devices would be ignored in
scsi_eh_prt_fail_stats().

Fix this issue by using shost_for_each_device_include_deleted()
to iterate devices in scsi_eh_prt_fail_stats().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 612489afe8d2..a61fd8af3b1f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -409,7 +409,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 	int cmd_cancel = 0;
 	int devices_failed = 0;
 
-	shost_for_each_device(sdev, shost) {
+	shost_for_each_device_include_deleted(sdev, shost) {
 		list_for_each_entry(scmd, work_q, eh_entry) {
 			if (scmd->device == sdev) {
 				++total_failures;
-- 
2.38.1

