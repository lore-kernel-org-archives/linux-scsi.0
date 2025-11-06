Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA30222594
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467340; cv=none; b=hgdSnycaMpgGYQ7DMLWHahhfygm0IzPqrbEXUJFPHWYFslYImvbNLy06wGFn+3pkZrf7wL1t2Z+rJKXJnvuNQzXhGGA0V3gq07F1T1LKlcFb58nxRC1N5OB1nydX2Tx3WoSJi4M8Q1dcmLNMlIBBUmXmiIyKCpMtfkfsAwVnVLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467340; c=relaxed/simple;
	bh=lJlIk55Uim2hPyW6U9etA3WYtvnrrRQIBOJxA5+yudQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Hr2U7wOC5+XujhVWtAf3pIIwaRAFqM3lMAXvf+BJ4526kWVmb2mNkF/WpZ25OSdoX1gQ0zztbI+n7r6epnskINhZxCK4jPODLrAzQ+Zs56HkzevLzrxF8TmG+Emqv9noGTXY74v1uoYDS4mTdAeIXQf+NEp9YW6HC4EHoR9jvCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W11l5KSC; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W11l5KSC"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33db8fde85cso128872a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467338; x=1763072138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xIpAwWwEklHO2Eg5GDsJHID5J3/lvSFxJF+0kwVTCcY=;
        b=W11l5KSCSCCt9RxgKfqhw8tnDCnN5bV2nPx2bCBeim7YR1GYE8RcuWjgiET36dhTXU
         +i5g1dIU2QtwLKnE69MORk2r8aq+gXatNzZtPChQI1PvliYi2EB1yjbxUNYKD3+Oauh0
         EMiroCF23BS5Y5SqMz7urLz+LcqTyCGPfawELo+Rxwb/N4XE1gmUu2chO/dzf/Y8AnHs
         yk2eX3Sd91Th6ym9hR1BXziSP0Eqjjt5xxuVp7R+i8+FCJnVgLEmRCc7on6l1OX6nwTF
         kVe+YHFND/ttkhl+T1k9QBzmPZzFlUMf2WZOqmmJsKYTxQzeu6Gg7O15zLQwEF1hNH/D
         oqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467338; x=1763072138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xIpAwWwEklHO2Eg5GDsJHID5J3/lvSFxJF+0kwVTCcY=;
        b=hXHgoC2OSMv/03tQ/oVxiWmPeAY4suAvoJsBJui4xBf2JPDNw5PtPlMZyEdlVm2HoA
         N3Sh60fBM+YzfIgYtg6E7T6ch9At9sr/8Xx5zlQlEYvsUB8a7gHofc7UlEemag30VBAY
         HORvn9c65KfcHPImWsLvSq8PyYrNndRxEvVMWAK9+nHAM8rstOUMfvBgPYKXuBZi1Hkm
         bX1v2sIbJITRR39K9hKS096PGxttVLKeiBMJPWzVJGIksENCTTYA1s+aqVjmH8W6F/mv
         SQGMZ38EcxyW+ycNwEawt1/5zE5RLpLS0mbJk5DcxU4ltNN1Hgj6PXZF3DlsDNx5Fdx6
         fPLA==
X-Gm-Message-State: AOJu0Yz0w94gFvrJyir+1JTbRYGKR2OLHAmNspoGcb7oZX9j7aql1wxh
	EHrYDdRCKaBKJQj9IoimoCQukOqbld7b93YnQvDx9GbuaGkSbwR7ciFsdjXnPY7K
X-Gm-Gg: ASbGncsOzqnRE2xPvxwG6FTz7UKPNEuTUCaiPxfzrKX0HP5GsL4NAt/75DilPlfSsZ6
	l3GF924S1BisJlD9OsJehn++sznl+BbJpAC0zyS0XCJJAGbGt8BpeHUcYZKMLslTbRCTk90ATPF
	TxiMDib3pRaHNZHaOa4seR0z/5F5N8dx80Fnldkgd0cCdS+56uEqBK16lYw1qZ2sxRzNada0/bn
	kxP4zUX5xtoyXaf2KbgZZ/KShGUB/vAVNpVdE95J56xeR3GbryzPUFeMJ0vhmfuinFqBAvSP5Wm
	AQsvfezMHkxst9weBl+asXckHO6tx3mh9gngFY2VcSKQI2b5fbYboR2lsFUZM6fj2CPCxHbWFAS
	syD1QpxWeKiXxuz2Zeq4upZYVVokbHcqyq9ToV1oRDfgd51yFpiy9uqoKO8DqCbh5ZaEMneLXGq
	evoqrJqa51NZvFbYLP7fJperIIsgrzQIz8Y/pFkfg/tuBBkIU7Epst7pOGq56V
X-Google-Smtp-Source: AGHT+IFjs0Xv7JxXVpyr7N6xGDV4JL36VgV/cWnInwps2dA4DEYn49ElJg3NpgCv5zdDNhiP7EDyGA==
X-Received: by 2002:a17:90b:2250:b0:32d:e780:e9d5 with SMTP id 98e67ed59e1d1-3434c55b259mr721727a91.22.1762467338479;
        Thu, 06 Nov 2025 14:15:38 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:38 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 00/10] Update lpfc to revision 14.4.0.12
Date: Thu,  6 Nov 2025 14:46:29 -0800
Message-Id: <20251106224639.139176-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.12

This patch set contains updates to log messaging, revision of outdated
comment descriptions, fixes to kref accounting, support for BB credit
recovery in point-to-point mode, and introduction of registering unique
platform name identifiers with fabrics.

The patches were cut against Martin's 6.19/scsi-queue tree.

Justin Tee (10):
  lpfc: Update various NPIV diagnostic log messaging
  lpfc: Revise discovery related function headers and comments
  lpfc: Remove redundant NULL ptr assignment in lpfc_els_free_iocb
  lpfc: Ensure unregistration of rpis for received PLOGIs
  lpfc: Fix leaked ndlp krefs when in point-to-point topology
  lpfc: Modify kref handling for Fabric Controller ndlps
  lpfc: Fix reusing an ndlp that is marked NLP_DROPPED during FLOGI
  lpfc: Allow support for BB credit recovery in point-to-point topology
  lpfc: Add capability to register Platform Name ID to fabric
  lpfc: Update lpfc version to 14.4.0.12

 drivers/scsi/lpfc/lpfc.h           |   4 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  36 +++++
 drivers/scsi/lpfc/lpfc_disc.h      |   3 +-
 drivers/scsi/lpfc/lpfc_els.c       | 249 ++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   6 +-
 drivers/scsi/lpfc/lpfc_hw.h        |  25 ++-
 drivers/scsi/lpfc/lpfc_init.c      |  12 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  21 +--
 drivers/scsi/lpfc/lpfc_sli.c       |  79 ++++++++-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 10 files changed, 327 insertions(+), 110 deletions(-)

-- 
2.38.0

