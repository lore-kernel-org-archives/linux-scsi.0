Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58C119992C
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 08:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205828; cv=none; b=V1DiyXlEbOC6gzQFYgO7Bz+8RekjO4uMQ5vFsyvJEv/pC6qaS0MWve7qABgNb9Xq8rfUVIlLpuRiiJG1nvqBtSaaTm1UR7Rnl4+zsYoL85azyo4SjFyRZpKMhFF7ZuJfNtoG/bP5sfZU+rG4cnBIUA2aeTdicH8u262rTRl/kbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205828; c=relaxed/simple;
	bh=VxOjVB/GG5P/Apt6S+m6z8wlrwHU67JqChbhioNwaEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hVPmIXf+lXbBVgsxKCRHxo93wE/1Xzj2mvPq2aKiqgSOvMd98zK6DexinBNczmaSLFSlILc5YOwICocb9X1Ci7ab7J0dvSHO0p5YFlQMCCqBnSTFH1jMDEfKf4xZ8AVjd/Q4l9kjFv2eOiATXbqxJ69Lu1xE9ZSLPi2cSAxfZn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fVVRCS90; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fVVRCS90"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2a0c20ee83dso55261295ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768205826; x=1768810626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/SvZrJlM/w161kJ65PxkKtlDEMKczQi4fLklNLv1ma4=;
        b=TkwOmqcT/Xd4F8SOmfrB4aqxKxCWRwYnE2QnmUJXr2vvD7r7oitS6gv2UHVLCkN4Qf
         evNVjMxWEcA/NF5c0PiIxhKO5J0q+MTsLFHtaWePyzf3A/ulMraGCxb0etHLHUiJxq8A
         uI4XfjKFWxpUKcaN02lBd/4l9CnGDi5agdKVqcg2g0rwSRftJ88UPetoye0Njj5VvJEO
         rTPQUJSsaDpvWfozH66JC16aLDFRfw3JerVSSsUGbT/YSMN9MvlburOkiABv1IcmPZXt
         eLD9XuRi0zTwzy4N5hMVBhOI3FqMhd2bQRlwEHiArIWcVACwwr3ruxQHuQCZuVWrIzEn
         UHGA==
X-Gm-Message-State: AOJu0YxB5iPwZjD6+2p65SKKY/VcZlcnYn11EcY3Bs/solb5XiTexAc/
	vZOkE+jD0ubFCROEggC8uoLduP+f1Ovky9XK63OXC3T65x+5wqP4hPA+vOp0PpkunpitKqtXwcq
	yJO7vsxLvYRW8aFNF9cnOr8So46lZ905y2zNdBSXGsk3Tu592BK9pfOb55cvFeH8UBuYf7K1mbv
	tEB919xDXRr+lrt5VGb9AFCGHBPjsjMzKhmwnE1xvZL6xQlc/gYi3jRgKWcOtblIkUx8EzQ+Nv9
	ka8O59o8O6Wv0Gr
X-Gm-Gg: AY/fxX7EhFyXN1KlM0vCEdja23hUzN4MUt/jdq28SxlCs0ZRbW1TUw0D0/ZTBtCK3ux
	1CqumHDf5YI511eUhQdPdNgXvgQIagGh4rVJVWMgHaSegHHoKPQWeISi0FfeSsLNR3As5OrqY1o
	JzeFRxYt/dIojartgpP5DI6LWj956QOhnl24uNeY+rbgB/DmKx+bXO2TImr2bnG6EJCesu/gwa3
	mTW5bUEaUQB8eDjinwDCjYGPdL+aKifZV3wrttRJItZ5oiW3xpVnLAcpi7J5KF4ts54XXG+3pWp
	iyUs2/CV9HolrNx20CavuWboX9YRhzno2vCr9wyfCaxozkjkC9MErz5/7MFYhLAMrqpFH3j/iml
	1Muv0TgKJsVOC3XbRZWOW93OCRS5/xJdo+XC2kEGg/GR4R4zLZMwt46leK5fT8LHp8uJIZ58Ywo
	igMfUbkP8Boqm8u4e6KLUpw8fN4IypFgyCumK72KcC5g==
X-Google-Smtp-Source: AGHT+IFqzGH0AzSRFXyWKZ+iPVBl1voWH6cKkOAp4lt1S7+sXfEjNw7YI2NdJj5/3xtMjldSMzmA0c5BeENF
X-Received: by 2002:a17:903:234a:b0:2a0:b066:3f55 with SMTP id d9443c01a7336-2a3ee4151fbmr160654735ad.10.1768205825891;
        Mon, 12 Jan 2026 00:17:05 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-81ee9bac329sm896068b3a.7.2026.01.12.00.17.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:17:05 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c704d5d15so1274790a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768205824; x=1768810624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/SvZrJlM/w161kJ65PxkKtlDEMKczQi4fLklNLv1ma4=;
        b=fVVRCS90thFiYoJK6xHx4rb2cW8hMudjsmj+zkGlxQ4gRf0w406wNLgbG8IT0wK1C8
         fbhsmozGi2pM4SWooTRm6pbT68LeWpTw/G5oOM3bY1aTVOtkPtEUmnTiGDAn/gnPiNjr
         ZPMARgPtQfrjXP/w5EK4oyRrMNQnPCzpzttRw=
X-Received: by 2002:a17:90a:e7c9:b0:349:9d63:8511 with SMTP id 98e67ed59e1d1-34f68c62198mr14082939a91.25.1768205823767;
        Mon, 12 Jan 2026 00:17:03 -0800 (PST)
X-Received: by 2002:a17:90a:e7c9:b0:349:9d63:8511 with SMTP id 98e67ed59e1d1-34f68c62198mr14082913a91.25.1768205823264;
        Mon, 12 Jan 2026 00:17:03 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5f8b1526sm16808659a91.14.2026.01.12.00.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:17:02 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/7] mpi3mr: Enhancements for mpi3mr
Date: Mon, 12 Jan 2026 13:40:30 +0530
Message-ID: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Enhancements for mpi3mr driver

Ranjan Kumar (7):
  mpi3mr: Add module parameter to control threaded IRQ polling
  mpi3mr: Rename log data save helper to reflect threaded/BH context
  mpi3mr: Avoid redundant diag-fault resets
  mpi3mr: Use negotiated link rate from DevicePage0
  mpi3mr: Update MPI Headers to revision 39
  mpi3mr: Record and report controller firmware faults
  mpi3mr: Driver version update to 8.17.0.3.50

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  92 +++++++++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     | 102 +++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |   9 +-
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h      |   6 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   4 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  16 +++-
 drivers/scsi/mpi3mr/mpi3mr_app.c          |  28 +++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 109 +++++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  96 ++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_transport.c    |  30 +++---
 13 files changed, 459 insertions(+), 39 deletions(-)

-- 
2.47.3

