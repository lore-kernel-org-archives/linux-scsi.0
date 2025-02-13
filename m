Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F44281AC8
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 01:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739410822; cv=none; b=A1OFzGzmrLdavH8kKI8YaV6Bj/Ux4BEUpOrAsm6PlRPV5TWSMHK9T5brz/O9yQLkfLnVSCmQmE5c39H7dyPG7fjA1AKOp1xkgtEAjk8qM2Hs3spzcd1usF5QwedKwtmihQDXKbdkRPCvu53gvHxH02boGS4UfMjc9vHhsXRC/Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739410822; c=relaxed/simple;
	bh=iy9RHMqnxkGfEl4Ur6NFhcahynw0mLy0TA+nhJo/k5M=;
	h=From:To:Cc:Subject:Date:Message-Id; b=kQtsgzOxgzeddbYnWBvTtin/aK7gkZyPgDIMLibACWj8lm2N4wkNrUauwPkzInn0Y4ih8cAiIENSqTI+htyQqtvuHJOXYjuVYtpoSxo/MmQm7MUdavYEL3Tceq2Jlq/8xlCvuifQJjL6pt/f9HjHtq/wZmvHnVVjxaVh/VGIlEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gWXxrcTD; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gWXxrcTD"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2fa3e20952fso766031a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 17:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1739410819; x=1740015619; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPPJc7MuDoFLVHyach6yxeKZjENf/miTuHCPtmtOOc8=;
        b=gWXxrcTDf+pCHw+GFPnl3R58EqKNpX6WY6L+KL/9o+e9KRNAq2jT8kujm5iZEAs5og
         hbPp72z9VP4ObE5anbRKpGqzYXimVh8J40vI20Dva9RUSYE3qcYX/qum1wU+9slyPoM3
         QbBK1A5CeO9vbBAtclAnwtSJbtM5KePttmij0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739410819; x=1740015619;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPPJc7MuDoFLVHyach6yxeKZjENf/miTuHCPtmtOOc8=;
        b=wQwK6flx5tzmIDlVtg56jiYj3JgEJIeJPJYacx1h20fMV3lO0qNXlneEV7Hz8gjiog
         fod/mx/NEJ4us/lN/89WvpoK2mN3aTNzo+vdyT39zXE3IjImWTci5oQJVj2a9nqHM4eJ
         tRSqYS6Yh7oy7nHTq5P3vy3ZpJye/zVloGfuIJkYsBisKaxAjShZKT8LgZsJWniapnN0
         RyHjWC1rTQbK91XLi4cO60HCtT866QrR78SEfUyWt2FYg8MrC1hLKFR9lD1IaLYYmMIF
         Cfy5uZpcWJD5o+DrjlILwVljHZ3QKOL0uezUkqQtQpLcqGUEhU/WjpzKgZFC0kprcAET
         ROLw==
X-Gm-Message-State: AOJu0Yyp1UJaIlxUYIvJQAjA028BAMFWPQNIiR72I+lcGgSmQyhT9ZHe
	KsFX83xidJVRHyCOioJ37RyeXdqWLxmLUc9zHBiWW77uSYZjg4mVbW3CGRfZJNLVxlb5FVdyCWS
	SG9fGXlrpCdJ7ta4QZrOBnp6g+5SypSmz1oZn7iTOb6OS3YCvbZRlIrg3FKblRvC0DAMe/waCZV
	5cp86JiTBBr0oei23Wk4OAKPjLThOCE/twgEsV1i5Nr4J1jluWd5CzqDZZVb1fD1av
X-Gm-Gg: ASbGncvhIh0R5DLc2qwHEaZvtZ5AYrVUn48YyywtnuEapAkjU+xQaeY6/I2NOc+TZlM
	Odtoice95cAps/OoAHEb0FvHhWlymU1VSZsD/Hko4HKI9SHJYHKuX6X8pWqTKF5Ko+cVuoZluaA
	ANhmIF/M1lhLmvNv16vEFgfMU3YGYUNpAMHToPBxmbcv4RtEwJ8WVdz0d0Bazepa2t1QrdSyoqk
	eZoTaUCLOnKYLFVOQGWZOx7+JuT+xnhOXT9vE2x/W7TssD3qweDdgKF48+ruUJwpAL8UMvQbOCj
	3ZuVNkDGIwgzzrSq97yv03R4bjqX9VRIbvLqMSB31MPczxtD5QmigeaB/YQhjTNRZtcwoUEoscL
	cVNF9gTp25v1ItvMTyOBjxOc=
X-Google-Smtp-Source: AGHT+IHO2hNVsPpZCBaAiB0fZaYVv1M0X3wnxvnZUDdoz0pjtmlR7vvVQtsk0nRBq7UutwSwtA14jg==
X-Received: by 2002:a05:6a00:3e0b:b0:730:9946:5972 with SMTP id d2e1a72fcca58-7322c374050mr7754243b3a.1.1739410818819;
        Wed, 12 Feb 2025 17:40:18 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73242761714sm106145b3a.133.2025.02.12.17.40.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Feb 2025 17:40:18 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	sumit.saxena@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 0/5] mpt3sas driver udpates
Date: Wed, 12 Feb 2025 17:26:51 -0800
Message-Id: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

This patch series adds support for the MCTP passthrough function over the
MPI interface for management commands.
Also fix issue related to task management handling during IOCTL timeout.

Shivasharan S (5):
  mpt3sas: Update MPI headers to 02.00.62 version
  mpt3sas: Add support for MCTP Passthrough IOCTLs
  mpt3sas: Report driver capability as part of IOCINFO command
  mpt3sas: Send a diag reset if target reset fails
  mpt3sas: update driver version to 52.100.00.00

 drivers/scsi/mpt3sas/mpi/mpi2.h      |   9 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h |   5 +
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  |  54 ++++++
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  11 ++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 279 ++++++++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h   |  49 ++++-
 7 files changed, 405 insertions(+), 6 deletions(-)

-- 
2.43.0

