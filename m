Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9213122097
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412928; cv=none; b=Q+CA4MRgCfFGiNTn5TOM5oOEmwTuMjJi61vMBDCWDgp9vKXP8Fux+9F9PCus+NrSaFbMxdOq4RloiFJTjrPTdTfGrceNWuJwY4I3GUf+kSBReD6nOYWJmp4Kj1mZ+YnD/iorBj65un8TpqwT11NkplU1CgivfU+YFDFa5uCByNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412928; c=relaxed/simple;
	bh=BNFvgmDJXMCM3fgJPesUV6WKJAyXZOTZj5VQoZvQYq4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j+924RBw98GZSMTvqQvQ2tagq6+Om41PMJGg1DSw2W3dW90JlchxTTfhPmLUNdfmVECpUx9NuSNsvcwsOtzcpdBtrzw2xi6LxYOQNQK5SyNvHxdzdLzYPGmU28DuFWJxhc+kq6O2M02o4Kj3EB6vKBgL7kMuLxqghiFCMugoJew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bN98T1XX; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bN98T1XX"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7ea8c4ce232so1232301a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412922; x=1731017722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4HbRns5bjxF9rNRA7bRvKAVUX71FMcyZTuj4TptOT1w=;
        b=bN98T1XXqam5N1CzY/9q4MoCgCdsU/U0cN+f0XmluP7J5WTdBDFUFM0kgJSphA+QrZ
         sthvjkvRyZMijdUPv6UMpNZcPZolYhh6c21xnIwe7vX1XaG1hltbkjitpTrBfG9rSJWw
         Jck2xJS9NuhdAoksJ1hA38RFnlm1pIrhN1Xvsa3OTiLnVacezdleQwrifoBzP0Rcew2F
         PlXWhHibuKhv919CzKDRizvhsEaKULqOm499e3x2n+5eypfb4SZWcpdf/6eJwd/QI+CD
         Xpe0YsVGKGilbN9IeBH/QuqN5QV8xlja9Bme2jbG2hXTf3C9OSPrZfmtP7sxSOUjNdVz
         98Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412922; x=1731017722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4HbRns5bjxF9rNRA7bRvKAVUX71FMcyZTuj4TptOT1w=;
        b=dkgKqwxrtzTiQ2wI187FpiEMd9768hxPqlrwmTM5KU3XRUvHucjNUfqsYUb3U77+Oh
         gId3CxyERO3ef+bpxm82Iaj7sArB71d0Q2TwskwWR/xitQyU2/FGFku8hwgLxygBzSNz
         XQN+Yz9xvfvb6MG/0X0GnYdQSMs0jOJnLWllXmeTumm4DwdTNfULvQ0SAJ5cL2q2ccvv
         BK3lQqy5aBIzaSK23PAfKGSXOKK3UYJWHcyAdxH6swpJgNWbanWFs1tkr8iOjSFLNb6w
         2+/g0GoACbvRkXvOtIL1MeAWoo6YePIszwofIa4GyVEzHS99+BzoLhYVXuJWgJL3zYCr
         +9Ow==
X-Gm-Message-State: AOJu0YxhW0jKRNwto90N3t8enw2qBFf74AzdYC0j57uWNMliH7GtwzNA
	snkv3EbzfW79YBfOtIaWXRdqxKV2JeKhLp0zDDF25AQvksbIsApfpdMWGQ==
X-Google-Smtp-Source: AGHT+IFK6EG5D/RAsRZfFfJ+VwhW4jpeAcqavXIH17c1kxYxbeTa/9gjpw3iptaUbPzmWOJ6J+b8OA==
X-Received: by 2002:a17:90b:38d0:b0:2e2:a029:3b4b with SMTP id 98e67ed59e1d1-2e94c51c364mr1958442a91.28.1730412921613;
        Thu, 31 Oct 2024 15:15:21 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:21 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/11] Update lpfc to revision 14.4.0.6
Date: Thu, 31 Oct 2024 15:32:08 -0700
Message-Id: <20241031223219.152342-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.6

This patch set contains bug fixes related to congestion handling,
accounting for internal remoteport objects, resource release during HBA
unload and reset, and clean up regarding the abuse of a global spinlock.

The patches were cut against Martin's 6.13/scsi-queue tree.

Justin Tee (11):
  lpfc: Modify cgn warning signal calculation based on EDC response
  lpfc: Check devloss callbk done flag for potential stale ndlp ptrs
  lpfc: Call lpfc_sli4_queue_unset in restart and rmmod paths
  lpfc: Update lpfc_els_flush_cmd to check for SLI_ACTIVE before BSG
    flag
  lpfc: Check SLI_ACTIVE flag in FDMI cmpl before submitting follow up
    FDMI
  lpfc: Add cleanup of nvmels_wq after HBA reset
  lpfc: Prevent ndlp reference count underflow in dev_loss_tmo callback
  lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure
  lpfc: Change lpfc_nodelist nlp_flag member into a bitmask
  lpfc: Update lpfc version to 14.4.0.6
  lpfc: Copyright updates for 14.4.0.6 patches

 drivers/scsi/lpfc/lpfc_bsg.c       |   6 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   5 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  39 +--
 drivers/scsi/lpfc/lpfc_debugfs.c   |   4 +-
 drivers/scsi/lpfc/lpfc_disc.h      |  62 ++--
 drivers/scsi/lpfc/lpfc_els.c       | 459 ++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 311 ++++++++-----------
 drivers/scsi/lpfc/lpfc_init.c      |  61 ++--
 drivers/scsi/lpfc/lpfc_nportdisc.c | 329 +++++++++------------
 drivers/scsi/lpfc/lpfc_nvme.c      |  60 +++-
 drivers/scsi/lpfc/lpfc_nvmet.c     |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |   8 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 125 ++++----
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   6 +-
 15 files changed, 665 insertions(+), 814 deletions(-)

-- 
2.38.0

