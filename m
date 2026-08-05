Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1900A1A3029
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 21:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785965842; cv=none; b=I0QvYqq6tzGbb5A6z0sZQqegSKLqf8TDQWhBPFVqB8FDX+/RFxJuPFZxG8pwayifaNa8uwuYCkZ3TA9gR021NHZ2nBnEjB26m51VxfSiIwSCPUX9CwckdMw7pdgNtkmQpxT5dMZNLsGiT0R8KxgeXLwqA8zibK6Qi/EOajq/3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785965842; c=relaxed/simple;
	bh=TXvB/PkVh03fa7IgI7Xrg0rgDfqvrgRZNT9r4dyS4QA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gVCRF/RdVxWplLUYkIqte8HwXygl66toDi6WQ8hUN4SQrvSJrDfFk/aM0FE6m1bqcB9AJJQNNETfVgWang3SkImbXz2fYpXsu4tMe4PsrGB4o9OwdQCVfTZV/A4a7dxqGMPYF8WbGyNpwHjmCPBtpOT55MoMv4hIjNA92UoS9w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UtYwWDfg; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UtYwWDfg"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hFkJw4Vbyz1XM6JY;
	Wed,  5 Aug 2026 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1785965836; x=1788557837; bh=V+/4NtTf3GscGqpY1bN2I2G3BZgPZWMaBsS
	9pJam7ng=; b=UtYwWDfgOzFIi1M2rZ4Ok8q45WSL4Jd64l6U6NqM1qamTjYG4/V
	3qm3dL3h6bkW2/uxt2R5+u8LEC2HobiN1Ffc/PUbVeQdi+WT40HlhoXp4iJxYb9p
	v33F/g0u4o1i3U3399dLlagB3mhDn56/z+GM7npvIx68Y+NpU5ks/1Akam5Z7kF5
	N2Ng2XBaq4k1LXv+erADvWnsbug5/ik9Vx333IGe93xykkKk4jSRStig6fYQh6cD
	5ALFcEOmiKJS64F2U/kQUyaYwjMEoqx79TpYK+yyQtksy0NQlYbNvFiQ90Y/x8Vv
	Tm88uETn6627D2m8AvDkUEDyCGVYIcCAiEQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aGRC0stmIuNT; Wed,  5 Aug 2026 21:37:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hFkJq5Nh1z1XM4TB;
	Wed,  5 Aug 2026 21:37:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 0/6] Enable lock context analysis in the SCSI core and UFS driver
Date: Wed,  5 Aug 2026 14:36:47 -0700
Message-ID: <cover.1785965531.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series enables lock context analysis for the SCSI core and the=
 UFS
driver. The advantages are as follows:
 - The compiler (only Clang) verifies whether the lock and unlock calls m=
atch
   what has been declared via __must_hold(), __acquires() or __releases()=
.
   This is useful for catching locking bugs in error paths.
 - Support for __guarded_by() is enabled. If a member variable is annotat=
ed
   with __guarded_by(lock), the compiler will issue a warning if that mem=
ber
   variable is accessed without holding 'lock'.

Additionally, a patch is included that suppresses KCSAN complaints about =
SCSI
host state changes.

More information about lock context analysis is available in the cover le=
tter of
[PATCH v5 00/36] Compiler-Based Context- and Locking-Analysis
(https://lore.kernel.org/lkml/20251219154418.3592607-1-elver@google.com/)=
.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v4:
 - Added Reviewed-by tags to the UFS patches.
 - Made the title and the description of patch 3/6 more detailed.

Changes compared to v3:
 - Left out all changes except those for the SCSI core and the UFS driver=
.

Changes compared to v2:
 - Added patch "scsi: core: Pass the SCSI host pointer directly".
 - Corrected several annotations that had missing or extra ampersands (&)=
.
 - Reduced the number of __assume_ctx_lock() statements.

Changes compared to v1:
 - Split patch "Enable lock context analysis" into one patch per driver.

Bart Van Assche (6):
  ufs: core: Set task state before io_schedule_timeout()
  ufs: core: Enable lock context analysis
  scsi: core: Pass the SCSI host pointer directly to scanning functions
  scsi: core: Add lock context annotations
  scsi: core: Protect host state changes with the host lock
  scsi: core: Enable lock context analysis

 drivers/scsi/Makefile                     | 22 ++++++++++
 drivers/scsi/device_handler/Makefile      |  3 ++
 drivers/scsi/hosts.c                      | 18 ++++----
 drivers/scsi/megaraid/megaraid_sas_base.c |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c             |  6 +--
 drivers/scsi/scsi_lib.c                   |  3 +-
 drivers/scsi/scsi_scan.c                  | 52 ++++++++++++++---------
 drivers/scsi/scsi_sysfs.c                 |  7 +--
 drivers/ufs/core/Makefile                 |  2 +
 drivers/ufs/core/ufs-debugfs.c            |  8 +++-
 drivers/ufs/core/ufshcd.c                 | 15 +++++++
 drivers/ufs/host/Makefile                 |  2 +
 include/scsi/scsi_host.h                  | 23 +++++++---
 15 files changed, 117 insertions(+), 50 deletions(-)

