Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB2F24BBFD
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 09:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758535021; cv=none; b=gLGtA1+Z9p758NS83ADV44bTYTwHXdQ5m1hY6fyHsoJtDW89ltYuv9DMGVTWIlvD9MwWJ7wBtOgVgwncjO6a7crIA610eTbkMQtBN7S9K/zMHhY7blcHxQWCHrgwOWx0aky9SneQfCWbe6m/HtRgOlAnFaCx3QSoPZZkJfazo3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758535021; c=relaxed/simple;
	bh=tDO0hPRvme8iHuqyt7ZFNSKFrNyDGRTjCtvzyRoCnZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=avLXScmRhn6oknKhbOgyj8hM6s2cnl362l5Zx0DnVUAl6Xf7sPaXBryQahyx97sghCzuw4QImGL01FG75tCLFsDrXofu7mohlUZdPWy9FwkI0QrfCZxptfb+GNu904K94REuwqVIDqewegwDf6uRMJ/stBCweF1IUWZPXZoxXv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NhmWyDnU; arc=none smtp.client-ip=209.85.215.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NhmWyDnU"
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-b4c29d2ea05so3823217a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758535020; x=1759139820;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dqvr9B3mi4PpG/G3vaseFnMu5ukojHGVH1fRTBIbHXI=;
        b=JalhV8fU/OY8/EUUG9lm9KlCkJGnLyU3B9tdz4SogsQwl7S2wsQInjA9QH8sTCvs7i
         YzlkdVZv1PP1VY+Bpz9mQNDBL3900f1q4WqrtYivl8cfpLNGs+HeLiKcnpAbYH60etuS
         W78kkUGH4953QMEZvE7vr8LYTRP7hOuMvIXiv7FaKLRtEi3KIzlJOgAgcd8a/ddw/6vy
         eaZHiRlghkPkWSddQJvT4Btz5mKdKcPN6CukLJqAsEAxpPI3/1xvpXr4VVpmNCLgXJRT
         1BD0Prbs/Pw7dIlfcvZtDJUaGDc/TovWuk+WmbPZKSL8Z40XdPAmHPmSoeEZooCJ3ont
         +5vA==
X-Gm-Message-State: AOJu0YxEFjKRPZqBZF/aUk1cMnxItxfRsJWtvVs3mJQ209XxoYfnqkRv
	tR8BHic+H7i2+UfNmDHXvXMonEe/CSh+6+YCKXCjbbBuyCHpa4f8JJsFk//JJkJNJZI5b/VU+9y
	cMCH3IqZW0JpksX5RXI/5NlcrY75+3ksdAG4G+fWUTtw+RsWSaQlJiJVkFUmhc5u4Byq9cTjaT5
	cbB7YyIdMavrTEc8hTN9wIG9c/z7ECyunkU20bDmyyXKnpMm5WnZkfpoSP1B87O0Q/E3aMeLMtZ
	N1IMJqG9NnQXKuE
X-Gm-Gg: ASbGnctQaNL5BHOI/8IGqoNcUj7uUM3goxvWd+keqEaVkocUxh1tFGMBT+FOZr5qCCe
	fAnhYMNEbfcszUqoDlnk9jd9mfeNnmq+abUotFfZkIabBGt8AdvrJbdI6mtBloFXEqnb8290wb1
	lEiLblML/GytvxdZLBARIxVADTEcsVrf6NjXgBBa9hdrfBVt6g4PIY9f45czLsblL0FYuUjK/Ix
	lbabiIY4xTe6rwqTcQMX2Z/DdkhSg4CMORMhtUQ1CPbcFfnp/xXtNZGyMx5urjYmJHRMUlSJOzr
	gcSwKOlxahTjne3iqzlug8ABfVtjURbqydMBWLa4F5+ERttjO58zvhgRg4RqcHJQZElbf0LTkzR
	MKPV7s1f3kgpBQE8wkPDtDIXgAh2eIWmYKRNabBAegO+J2y6XAD0uNC70eFL0cEDhVqBsrMHkd9
	YFdw==
X-Google-Smtp-Source: AGHT+IGtGAzhx6Y4EFFPYRBTlakGBSGpPGKC2RMRItj1oMrdf0T/QSt9pAFFRIEIXr9VAMuwcrLXwhi3/4cs
X-Received: by 2002:a17:90a:f945:b0:32e:6111:40ab with SMTP id 98e67ed59e1d1-3305c591a46mr18866363a91.3.1758535019677;
        Mon, 22 Sep 2025 02:56:59 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-119.dlp.protect.broadcom.com. [144.49.247.119])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-32ed6798910sm1094441a91.7.2025.09.22.02.56.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Sep 2025 02:56:59 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-77e12c8feb9so2806101b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1758535017; x=1759139817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dqvr9B3mi4PpG/G3vaseFnMu5ukojHGVH1fRTBIbHXI=;
        b=NhmWyDnUzAKC80iULv83tCmvbU9ukR7nhJUkktlevxcBF/1QuEIyXSsT9Ms4empM0R
         eknrVwoYslFEY037kLn1LeY0hIUBHMDftf3roFpoiiXp+lt03bN3oi3+wmG4ZhXazu6c
         c7+9jh1LCOXzg8i5BrmgB0v3h6x42krEg7RaU=
X-Received: by 2002:a05:6a00:bd13:b0:771:e5f3:8840 with SMTP id d2e1a72fcca58-77e36935457mr14461385b3a.13.1758535017488;
        Mon, 22 Sep 2025 02:56:57 -0700 (PDT)
X-Received: by 2002:a05:6a00:bd13:b0:771:e5f3:8840 with SMTP id d2e1a72fcca58-77e36935457mr14461366b3a.13.1758535016930;
        Mon, 22 Sep 2025 02:56:56 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f4594a76bsm1034584b3a.62.2025.09.22.02.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 02:56:56 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/4] mpt3sas: Few Enhancements and minor fixes
Date: Mon, 22 Sep 2025 15:21:09 +0530
Message-ID: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Few Enhancements and minor fixes of mpt3sas driver.

Ranjan Kumar (4):
  mpt3sas: Fix crash in transport port remove by using ioc_info()
  mpt3sas: suppress unnecessary IOCLogInfo on CONFIG_INVALID_PAGE
  mpt3sas: Add support for 22.5 Gbps SAS link rate
  mpt3sas: update driver version to 54.100.00.00

 drivers/scsi/mpt3sas/mpt3sas_base.c      |  8 +++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  4 ++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 11 ++++++-----
 3 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.47.3

