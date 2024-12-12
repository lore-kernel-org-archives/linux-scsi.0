Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0BE1AC891
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045278; cv=none; b=XHoK6V1FP+etU1XmwS4ruUpVhIynSydFy7knURNnIHoHXZPNvvs/rc3JSAukY1HT5UtD8CUXzDxUuvSb9dbu/BrRhNtYzf9wsWopibLlnuFQTPlUXI7z0mtRXaVDVzBz1BxwoRXZK1a1gIhrrw4rtaefo//AMr1s7Ne80eAydls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045278; c=relaxed/simple;
	bh=SM9cVzSbdQjrv6P+IxglD8mr2WIrhPSPjGBe9JGuYVM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RBPUi8No+Ysloqsibrwob01NRBciGO+mfpEu6u0BYkm0wVwa7yN/K0ZE8ClRLjtAlohRbRkye532Q17+EqZPnRJNbRQI5YohFAOhvMXAScwdoAYaoQvkZtJJErsalH64e4cYQp728Vn2Z0mf8FTRzE4m6/QLEoycyL9k3abDyqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kv8adGZg; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kv8adGZg"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21654fdd5daso10429465ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045276; x=1734650076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lu+THFnITDnPTu1bIprypbSzRE6k/8FC4X/HummEiVs=;
        b=Kv8adGZg6foK4NLcGvhCo1LbL9pYRxpsVoftzfHMEHlMsMGbM3V5GsBV3hl5Yq7/MY
         Fo4WpQrxM7YBRN4rrnjyeU57vWBtvsA/9rLEL5RfoJdgbIpcqJKd5yGQY/cxPtnoNtjk
         2DgZxK5DQc5PHNYMNPI4sp9f+HiKHQj2rTuyb6EZi6pvVA75PzXg1KE9SJum4hLQgtbq
         VLjXw386/NgaGOkfC9PUpHmuwIE6/RqW83A6gRAjDzf6mNWhrexYeRLObL+WJhPsmFsE
         /UnIEMxwyMUFIJ2GZSG8DGtLxcDI4zD0EoEfLrjDds0AaW9MevXfZ5WmHTVWFU4V57lG
         CaGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045276; x=1734650076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lu+THFnITDnPTu1bIprypbSzRE6k/8FC4X/HummEiVs=;
        b=DJYDSTJ5iJBMnE8FOdWrUlyx5yChK8cMdJ0YCdnLxL/x2nK0EXQRJM4AEqntMEvCYV
         sRrTChoh8SbXFxHIcoxT9mvXvygxtHXg/FOYi0J2ST9+vpQjt7DckUe58621ATJSYtKF
         8zUDFk87U6IDEVu8dYitBpKJJglAFlUQ0Zwg257K1jhePrtnb+nHmAEue69KYMaPiAFG
         5eIpZKLZvFttxNy4RIjrCM7fDGN6ua2QF5CRppP9VIqtnAlimkKfulwVVJ8HR9PeVjP9
         dvpPaxyUDZ04Ysn54ygaQXA6x9E8kRCSCtKq9CHRGrfEJcJv0B04RuP2QOYQiHyYE+qL
         VzHQ==
X-Gm-Message-State: AOJu0Yz6Z3Tn3aXcP3AZtSa1C51wUFtN+MHTqqUQJlckW13nm+32zjlH
	BsoQm1xMHhf13RuWUXcjqIlE7wHxw4Tl5O0iPHtJHxL5Z08ePCD7ENYNlw==
X-Gm-Gg: ASbGncs3gml/CvLWE5CDklPWpaO6hRJyZxcNJgnQtI0VU/wU17Wv0kvi5CB4Yq7wxjl
	3fwDs4OzNCYRUhTlNjn48KwRkLXkiru/47LyKCI5quMobeX5Jl+EvCnPdyo3pVtkMUrL/lydZ1T
	GHq203KJKyKjp2jQ6GHCLmzWIlccsUiviIcNl/7FzTrlZpPU4S1LJuhXFiFZMYt2b1qL2MWHPlQ
	vZNt0ypAkFAvF4lSFL7PvTcvNX0hJFj3vjwxI/V1f18uirZoiyVtsrEkfeeODfIsmbinV9qeSc3
	L4xXj9Vy0mKnMrVXqh3IDIB/M7nNedQdRwepyqUoPw==
X-Google-Smtp-Source: AGHT+IHUx+UhNdrR2MYvqgV6jlVIrJqu3yRnyMLpfby7VLE+ZxiONo4mr3WS+R4liexTzfIGEBUSPA==
X-Received: by 2002:a17:902:da84:b0:216:6a4a:9a39 with SMTP id d9443c01a7336-21892a86816mr6725375ad.56.1734045276479;
        Thu, 12 Dec 2024 15:14:36 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:36 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/10] Update lpfc to revision 14.4.0.7
Date: Thu, 12 Dec 2024 15:32:59 -0800
Message-Id: <20241212233309.71356-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.7

This patch set contains fixes related to smatch, clean up of obsolete code
and global spinlocks, changes to ADISC and LS_RJT handling, and support for
large fw object reads used in proprietary applications.

The patches were cut against Martin's 6.14/scsi-queue tree.

Justin Tee (10):
  lpfc: Redefine incorrect type in lpfc_create_device_data
  lpfc: Restrict the REG_FCFI MAM field to FCoE adapters only
  lpfc: Delete NLP_TARGET_REMOVE flag due to obsolete usage
  lpfc: Modify handling of ADISC based on ndlp state and RPI
    registration
  lpfc: Add handling for LS_RJT reason explanation authentication
    required
  lpfc: Change lpfc_nodelist save_flags member into a bitmask
  lpfc: Update definition of firmware configuration mbox cmds
  lpfc: Add support for large fw object application layer reads
  lpfc: Update lpfc version to 14.4.0.7
  lpfc: Copyright updates for 14.4.0.7 patches

 drivers/scsi/lpfc/lpfc_bsg.c       | 210 +++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_bsg.h       |  19 ++-
 drivers/scsi/lpfc/lpfc_ct.c        |   6 +-
 drivers/scsi/lpfc/lpfc_disc.h      |  11 +-
 drivers/scsi/lpfc/lpfc_els.c       |  55 ++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  13 +-
 drivers/scsi/lpfc/lpfc_hw.h        |   3 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |  85 ++++--------
 drivers/scsi/lpfc/lpfc_init.c      |  11 +-
 drivers/scsi/lpfc/lpfc_mbox.c      |   6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  53 ++++----
 drivers/scsi/lpfc/lpfc_scsi.c      |  27 ++--
 drivers/scsi/lpfc/lpfc_sli4.h      |   2 -
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |  22 +--
 15 files changed, 351 insertions(+), 174 deletions(-)

-- 
2.38.0

