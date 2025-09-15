Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCB423814D
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957949; cv=none; b=eZKJ4s+7jvAEVN7f13xgZIT6PIJv9DZ9D4iukmtUf8e1axjttITnnEfuEmE4QVwVcaL2h72kXLUu9Agsj8Zlf7GaMccx6gXYpY8DDPqZPmwvtc2tsTprqItZjJnAo9VPVC3C9qv9xLxUsKVBVedp6xS6MuFsbsxOdr9jnaMIlxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957949; c=relaxed/simple;
	bh=dbHoxdzD266X/aA+ZbpwfmlAaGfniNBfdBVX8B0VCWE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bN46X3jMZS60EIkukF6ZYqNqnaTL6NjMQBCv9O0HYLQa8mQolPcEDlTWP85O/WEIq1D0KZMFvCEGHgk/S2uV5mmYAfUhzeKBuZGWfigmP1bPkF8XRsGD4+DGrq4qdrVNiRyXvDYiqWK6FooFLXrIQB4tQjsBCl82Xv3cwk7xWuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YykRw1DA; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YykRw1DA"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-76e2efbd84cso32359986d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957947; x=1758562747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDkGnionTvp5Ps4CrG8ots/NTrUw9ttRt2mnvS/1zpc=;
        b=YykRw1DA+VprGnjZeGTutikw963Sdk44szk8m3cgLmzvyfE59MyM93+Nyf4rizr+mQ
         mOSdIY9rdPFaUH+dUo9+bu/tyRTzhf+Is/SCou18pIPCPT4ZVQNlsVVIPDrA4Jnmj7Ws
         ZK4I2EfxltNPs6bINMqNpPOWEqnlC+SffnEiSqyCsF0gr3XCh6vmiODzThR8o+OqCok5
         heV0SMXQl3PpDVcgyI5Qbvgbt/Rvlu8Y0hdNovB4Xz1nZZKWFA/RMs5/axXNMVmvy1u1
         569euI00kgk9o4PG0UAF+04jqAqkLnljaHD4A7cSfFHXI/HqEV5tUPvKYiKIpniqHdiW
         qwIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957947; x=1758562747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZDkGnionTvp5Ps4CrG8ots/NTrUw9ttRt2mnvS/1zpc=;
        b=bmxvX92bUyh32vs4Cu4o7Fx5Smvv6svZTrmUj6yhaCJH1/X/YfSIzLvZqH3ROhBtOa
         CIKoGMxIOT4BT+NL/hqz0+mDKGjnWHfaxqIvQIj5C2DoibmScmABvgCLBG96VvIDwXw1
         Qz82LL3BBcuxb+fYbFPRhzuEYc+Z9Ce+X4TKN0+awq/2lZncDq4YMzqj0MM2IhZNT03G
         hRR9OGGn2QEAe4E5przTfmVIAZlIN0rM/IfJ0OATeCy3YsVOub+dq+xIyPnSujOQFCAI
         hwgCrFPL722f2kIAfcc1zVHAMNiRDUgVU4ykmsiPRnrbT1turgNZqyvm1jV2fdjeYtAk
         Y55w==
X-Gm-Message-State: AOJu0YzPULOo7LrA2dNl0VqgzcfN9wqGLRUpb7eCGfuUN0ze0S1fYGUY
	eBOxwPwQZZ6zlb8mQqNT1wBEyMuE7nTq/cxKNrfiBwqyr1RWEnN8j9j1ReN7+Q==
X-Gm-Gg: ASbGncvpaJoCwDLEsQWU2a7+16l7bzQjlzai6qYGochbtrfHsIMYVZ935Y0p/i8cGOR
	p2WbNNFEYMr5c72KQG6JSkxqIc40I/cRuvK0KBSmNSGBQJb3up8z/itFfNyYkbnbaX8e5qdVs1v
	Cpe82MPJsO4DxvNXkWDANaZRABdYSDrh1dbSX9vajHx9u61WcubXQrpcyiMY8jSOTSKAEPxdVMR
	FQnx6OSwkkT1TsM+SCLfbYbiIE1+Te1dOzmOfn/gDI5N239pVTeeW0I42KcY247Ddl9lnW0OnHl
	f4XVZLII6/yCAUh2NSFLLsP4kqHNGkhNT4ULpnuirtWoSYIJd8XXCjYSIrRjTMkZlZJCxVZAYpU
	ivPt86oT82Tnc3cPePllT271Pb5gfoHxPRUKUeZoUuMTC3k8CSqhskR4P+G3BeaeNvcI42jrmug
	KirvbZGE0=
X-Google-Smtp-Source: AGHT+IGoNGDYaYIeUgBG6Z+LLP6js1UeYIa4sGn1+Vq9XXBjIf6s04DEU/hDnx7bzPU9fkm0FS3o9Q==
X-Received: by 2002:a05:6214:c29:b0:788:82e0:3ab with SMTP id 6a1803df08f44-78882e004c3mr28728906d6.17.1757957946983;
        Mon, 15 Sep 2025 10:39:06 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:06 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/14] Update lpfc to revision 14.4.0.11
Date: Mon, 15 Sep 2025 11:07:57 -0700
Message-Id: <20250915180811.137530-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.11

This patch set contains clean up of unused members in various structs, bug
fixes related to discovery and resource allocation, and updates to handling
of debugfs entries.

The patches were cut against Martin's 6.18/scsi-queue tree.

Justin Tee (14):
  lpfc: Remove unused member variables in struct lpfc_hba and lpfc_vport
  lpfc: Abort outstanding ELS WQEs regardless if rmmod is in progress
  lpfc: Clean up allocated queues when queue setup mbox commands fail
  lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in
    lpfc_cleanup
  lpfc: Decrement ndlp kref after FDISC retries exhausted
  lpfc: Check return status of lpfc_reset_flush_io_context during
    TGT_RESET
  lpfc: Ensure PLOGI_ACC is sent prior to PRLI in Point to Point
    topology
  lpfc: Define size of debugfs entry for xri rebalancing
  lpfc: Fix memory leak when nvmeio_trc debugfs entry is used
  lpfc: Use switch case statements in DIF debugfs handlers
  lpfc: Clean up extraneous phba dentries
  lpfc: Convert debugfs directory counts from atomic to unsigned int
  lpfc: Update lpfc version to 14.4.0.11
  lpfc: Copyright updates for 14.4.0.11 patches

 drivers/scsi/lpfc/lpfc.h           |  52 +--
 drivers/scsi/lpfc/lpfc_debugfs.c   | 633 ++++++++++-------------------
 drivers/scsi/lpfc/lpfc_debugfs.h   |   5 +-
 drivers/scsi/lpfc/lpfc_els.c       |  21 +-
 drivers/scsi/lpfc/lpfc_hw.h        |   3 +-
 drivers/scsi/lpfc/lpfc_init.c      |   7 -
 drivers/scsi/lpfc/lpfc_nportdisc.c |  25 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  14 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  19 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 10 files changed, 274 insertions(+), 507 deletions(-)

-- 
2.38.0

