Received: from mail-dl1-f97.google.com (mail-dl1-f97.google.com [74.125.82.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FC17FBAC
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 06:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768544033; cv=none; b=CJgcRW+I29LU4XtLUrgVx4pJu4XsIoY9EYEokIv3FAted7WXhejyktz1ktfVVjij5sMaleKEpPTdEZpNebZHXawwNYArHpVp2C9lvo9AxrZfVblvsIqZFn9TIBucuPlaj2TQGaSlY2hN+Sc6Nd8pxjAa56fsUupRnEQETHulX2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768544033; c=relaxed/simple;
	bh=RZda3ul3DAxXj5dQd4QHhR/lHrA7oASq5YP1/LdN2Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MP7nYwQEi0IDtEZVRCw1KTupx9mKnLZl0pvAN35/vRg7+y5WdHdcABVpFzHg1kB+Rq5QA6M8KbMYL6hl2XlSKvjxJ1lTtP+YkdeWS/aJ9KjFrIanMviWsZHv7+txdRmtO3uB4aj4Vouq/NBAJxLwHw/O+SO8ZUOZ0ftgIY2q4rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JWF1zFjl; arc=none smtp.client-ip=74.125.82.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JWF1zFjl"
Received: by mail-dl1-f97.google.com with SMTP id a92af1059eb24-1233bb90317so1492403c88.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:13:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768544031; x=1769148831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pYmuiOTt0CsdzGXeNIF5rNaO/jwx9pviJvHQYt6MGcg=;
        b=wGLJtsLMccjcQkGjg27fs6xFN94QWwSP+k70YSjAKsJ+xjEF+4G+6RPOqBzthlMQ+K
         NPhPAHq/inQdIUdUflBGmVnjCuzKlRIvIwuJlMKzZOjyXHropGFchSvebEablUbxtKts
         DIDglRqG9xq22kGWsiEkTUQCASXDir5TSJVYLOW7B8RZcQQi7KfFZcK7R/Oh+3+1LNLa
         JgXTe+7IfHZfviLDo6LG3qdd4QBfh4kmBuPok09gy8xjpDMVHW5tB4F20QDK1Ng9O+0n
         +7RpMbUdBoqsk71XLMOcYSh5t9KSAH/uu7/kAKcOxHANLzTvQs++n+SA4zwqZ4Xnc4ig
         +h5A==
X-Gm-Message-State: AOJu0YxF1o+S/VPz5QDSY/5cDxEIHVSBbVCidh8njYDhnNRKuPf0Frev
	l6NnSZXrMTiKYsmkDS+baff0qZd4OmDzd5/uYN6J8RTpegP5yiojupf7tRA+SIwbIKjLOCsQZcY
	omLfPlqdqt0iXhJpYVvrLDzDX6dAiPsebdWvPfDohSKX6vlGDlobBwPWthmSsmoStwL2nBuLCj0
	IxOxPdGFV2M3O9I/422M6Y3wfnYBZPcF+eZxwQIf8ASu9/Z1RaIWfbktgl6KqxaavOYE14gBtQj
	NUQuxqtowuUPvYa
X-Gm-Gg: AY/fxX5T28Rt8g8jklazSgAcOw/vd7NVjTV1DYsq37jrgz2Tf02R2JV47KpYR6VjXkj
	ynzwUF5Q7eeLiaVOcOtSvU0O+p4W3x8ZE+Pekr7T4tTU3+CgSzKZf0fsEvMWgGvhanqDELfFTJ3
	QXiLSONBj8SOg+bvvgAK+APJtKojWzdcGfQq5FHmJAjq6HKzEgie8fS7R5aRqo0ixiLz0tVBgFt
	DVttDaCfv0EDqgwCmiEmqOdUFG668aPFWdFCe36EL+LwRUaN9joPmfgRjZawgHp4I8MK43i/hvB
	sHl7enoYkzoyveahXBwik2ONKFKB3J4Kua3n5ZfaLr/DbEW4IPlMsAkOy3RiRBFPeHcJ6KBRaLp
	CHv+KuTfybyMgKw7jHNOUSqUqAcMgpJQlx9QJ1O3ttGC1xOJgLwBjXblsHyGohKpsbxp8Wi8zfD
	ZZtBJTisotW69mL4qVK3en2j5RNsoAVTsvlfk0lgTRW5mM/QQ=
X-Received: by 2002:a05:7022:2381:b0:11a:4ffb:984f with SMTP id a92af1059eb24-1244ac400cbmr1804066c88.11.1768544030853;
        Thu, 15 Jan 2026 22:13:50 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-1244aec712esm325573c88.5.2026.01.15.22.13.50
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 22:13:50 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29f1450189eso14825635ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768544029; x=1769148829; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pYmuiOTt0CsdzGXeNIF5rNaO/jwx9pviJvHQYt6MGcg=;
        b=JWF1zFjlJ5gzvh9lzWTdnpYfo3sC1eDyWzE0YQMI/9Erba/4zXfotcEOT7s+g2Y+iw
         TKPg/l/rfy5oIdKZ+LIH+f7uRoWNFkPfgOjclBoGy2Zfm0X0Qo8WRUuaJQFHH84mR2OP
         U1m8FKfRRFh3Z80IHLkpeAxlTi3XO1RF3VP9k=
X-Received: by 2002:a17:903:2f83:b0:29f:175b:1ec7 with SMTP id d9443c01a7336-2a7177daed3mr21028475ad.16.1768544028681;
        Thu, 15 Jan 2026 22:13:48 -0800 (PST)
X-Received: by 2002:a17:903:2f83:b0:29f:175b:1ec7 with SMTP id d9443c01a7336-2a7177daed3mr21028225ad.16.1768544028170;
        Thu, 15 Jan 2026 22:13:48 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941bd9bsm10231315ad.93.2026.01.15.22.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 22:13:47 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 0/8] mpi3mr: Enhancements for mpi3mr
Date: Fri, 16 Jan 2026 11:37:11 +0530
Message-ID: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
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

Changes since v1:
- Fixed test robot build warning
- Fixed W=1 warning
- Addressed review comments from Damien Le Moal

Ranjan Kumar (8):
  mpi3mr: Add module parameter to control threaded IRQ polling
  mpi3mr: Rename log data save helper to reflect threaded/BH context
  mpi3mr: Avoid redundant diag-fault resets
  mpi3mr: Use negotiated link rate from DevicePage0
  mpi3mr: Update MPI Headers to revision 39
  mpi3mr: Record and report controller firmware faults
  mpi3mr: Fixed the W=1 compilation warning
  mpi3mr: Driver version update to 8.17.0.3.50

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  92 ++++++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     | 102 ++++++++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |   1 +
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h      |   6 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   4 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  16 ++-
 drivers/scsi/mpi3mr/mpi3mr_app.c          |  28 ++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 131 ++++++++++++++++++++--
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 102 ++++++++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_transport.c    |  30 +++--
 13 files changed, 478 insertions(+), 40 deletions(-)

-- 
2.47.3

