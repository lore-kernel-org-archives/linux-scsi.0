Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BFE1EEA3B
	for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2025 14:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740061800; cv=none; b=MmeVx0l+5iVUaR2YXy3m6qpzrfD2VtwkSePojuNs2P1Lx4SKKalb1zVr19V7EERGY9P0UBKlhSIr695z8WasGFUF0yvxJoldhzG5oY3sy9QCQKyR9hfvEr6Bsqjv7u7756ZGkOHTLr0KsmVt2Ng4LwFnZcTj21kpFfPNH9poRbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740061800; c=relaxed/simple;
	bh=gin2SqZRNDcfENnJaBcUw66JrrQC6hcTjdC28H/Hhmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wza0w1n+Ni4wMbOOdV/2q9Qd6Lpeum342kIEEiHR3baEIX2bZvlACb3+Ee+yjdnsstTPstOMfNliBl91d/Oy12IRRGaDF8buVSAjlwJm4NTxNgbjRhOkolj3x9XyaIxiQLfsWOyrI2xpjJVkScCmyPdsrVz1AU2Ju3y36Q3KB0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=R45uh5Ev; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="R45uh5Ev"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-220c8eb195aso20434815ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2025 06:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1740061798; x=1740666598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jk5qI87dcQvxdeztIev2rNoOe6Fg3OEwOrewNYiXL5M=;
        b=R45uh5EvtS05yDyWl/gOg9IXPmAkUp9GYUfDByOPf0UVrg+QiDtwq1qqocIHNYYZpa
         6bymy9VyZE1myLyY2UeOnt4KMG2yrRi5HvuTzngp5JihLUgULGq3iGDbSd5+FiAgIzdY
         TRmWK7YUnmBsyFdx9ZmvFgzlnHIBYJpqqTPCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740061798; x=1740666598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jk5qI87dcQvxdeztIev2rNoOe6Fg3OEwOrewNYiXL5M=;
        b=VRl7mwkfEPEJNT0IUTMA/sb+BTT6/UhEMph+mtP/KCXD7tlkFxAUWmgTA2Lfx2FYFE
         RJVYfgJlJLcMof0chSv79+3Zykd2qEUTWM/NGCKqi5gvZAcTgHGBqfVJkzTxjILvz2X8
         M4CgtMGMA1Xi8DWmoCKKKcAjVvcLDwkwKdvjwB6JuL5ZJZSa4DW0ihkNAnP257kLo596
         F+6uPAzgYPfVQ+fbvmuA3DVL8QXsEQOlts3CODokJ5V8tR88O7Lzfk4wg+8aDm9IfO08
         1KoZur94lZYnpHy141yyYaQ9EoncK1Pm3S8a+QXeMrsNoLSyQ63boR3rlrGhPEWxZ3Ag
         a1Kw==
X-Gm-Message-State: AOJu0YxKiKUhIzCeu3KCKW4VRC/Se1Y4r2fkrzi2JF2ki0cAJ5VHxVfI
	b5cAO355QcDx2cB1knbZ6+yXbQtXTwZUrAGLW0BLlZxEAVKZ2oKkUkbIgS3KZiAnSYhs2j5ewzb
	HT57Nd+q+eyhT3Sl48+FLW1RTtoJ4eeIADBcqIoTkZCTM97xtbahZWvsLGusNQV3UOX3Jt4YmSP
	mxUcLNXLFma4+SdSdM307qInBZq1Jq/8e33T1BudDEilRtCg==
X-Gm-Gg: ASbGncs29bmkowR8Ezp0rjqEjHo09hcobHeHdjzg2Q4Nu3j+mWBG5r5JTPfWD/xOGHQ
	DTGtilynHgJStb6aaL6T4RvE3DQjEGReS1kI4R30g88yNBEn5cz/oPDwA3DZgBhZDi+paRdPqm0
	I7cwUeAnKqVVIAx1rqV7vluSC4MFFM/xo39dKPx5rMbzDL3eTO9tx9oXQwepnt4+Pvztph2/xfV
	JqYUcQgF6F3vL054oRzZg9lxn4s3sOcLLYGVGmUuisFoMRHU8Z3HgWiohCsXWM4BMixEL7yXVPx
	/ZUYI3AmRkCXMKXWNCmJvxKSoAEj5r3MX0l5xdPIoPCqe2CGrtbII2nb5x8=
X-Google-Smtp-Source: AGHT+IEs9aeiAS1J1OW7i8JF4hidQe5vGPrPCZb3vLCdfLTjwVMdYtUYRuaqfniop/OekzY8oMUsTg==
X-Received: by 2002:a17:902:ce0d:b0:221:7955:64c3 with SMTP id d9443c01a7336-2217955662amr100783685ad.23.1740061798101;
        Thu, 20 Feb 2025 06:29:58 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d47ba84fsm122551805ad.0.2025.02.20.06.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 06:29:57 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/4] mpi3mr: Update timestamp only for supervisor IOCs
Date: Thu, 20 Feb 2025 19:55:26 +0530
Message-Id: <20250220142528.20837-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
References: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driver is issuing the time stamp update command periodically
even it is failed with supervisor only IOC Status and as a result
this command will be failed always on that function. Instead check
the Non-Supervisor capability bit reported by IOC as part of IOC Facts.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 7796fdce03c8..f83d5c9f29a2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2757,7 +2757,10 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		return;
 	}
 
-	if (mrioc->ts_update_counter++ >= mrioc->ts_update_interval) {
+	if (!(mrioc->facts.ioc_capabilities &
+		MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC) &&
+		(mrioc->ts_update_counter++ >= mrioc->ts_update_interval)) {
+
 		mrioc->ts_update_counter = 0;
 		mpi3mr_sync_timestamp(mrioc);
 	}
-- 
2.31.1

