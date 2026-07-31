Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6335538239E
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 21:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534764; cv=none; b=CWvg7A0D8B1c0Dzj9Z1qwLGexuTpM28C0hyY23FUaz1/JL7E9SBm5cWtVsP6E8H6RyGf+47vwUA1tNedCVISwJK0YJhlpFIii4m3u5R62WCmpMuP6tB0Zi26/x6vSkgA1e7iu70GuNPbUOWqDT2fER+GBJsBdXQUsjNps3rEnQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534764; c=relaxed/simple;
	bh=4gppN+HeYH3qp3qDUQAcfZvdXmfVE+P/YvSkDQueVO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EAqlHApTfFLupBSDnTZYohexjo+cSpRZ42B5hkSqxO4CveLVGiNa4qy0Rt9MYhTB3Qd+3o5ZPe4ALWlgSPF4BQgiV5LG/qBUVFUGQsYkFTeuRQTj6IxWHxUrjicMkgHF/qXkCyPlkwIqNFiOPEL+dQvs43OWz0tj4cfud79eGpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=h3tN463s; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="h3tN463s"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hBftx5mmYzlfpMK;
	Fri, 31 Jul 2026 21:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1785534759; x=1788126760; bh=8OezYVp0XB1SKFdz+PeqhBMnQUhXFNEh84r
	j49XjYco=; b=h3tN463sbsaXVybwa13lpn9Ojcsnm+LneQ4HvkaqWTDMiEHDItm
	0wrLmHozUTvrUgar/yCj44TE4zrtVsYlDH6vSpG+WOgLdHOSNM5uAyVkM4T5Og+U
	SVjyJNz1ljsgOEPcF83set0M3OC0BJ8IV4VPvbwWqU3KqB+TLEpIuy587DIq/30T
	MnF38bPfRG+knQhNr49stRYTWpSSqptK52A8rsHYF2PnLcM4AfwrG8QDv5UDW/Xi
	Sa417Ous9GejcP29Lg36y9CigC7viB4jeUtFFzN4w6zMZtXPo+zjH4uN+CywYNGg
	M5DIk0uON6N36lDc/t60fX4ub+nTjkSBpVw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 60ka0SC9uF3R; Fri, 31 Jul 2026 21:52:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hBftt15HMzlfvq2;
	Fri, 31 Jul 2026 21:52:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/6] Enable lock context analysis in the SCSI core and UFS driver
Date: Fri, 31 Jul 2026 14:52:05 -0700
Message-ID: <cover.1785534655.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
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
  scsi: core: Pass the SCSI host pointer directly
  scsi: core: Add lock context annotations
  scsi: core: Protect host state changes with the host lock
  scsi: core: Enable lock context analysis

 drivers/scsi/Makefile                     | 22 ++++++++++
 drivers/scsi/device_handler/Makefile      |  3 ++
 drivers/scsi/hosts.c                      | 16 ++++---
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
 15 files changed, 116 insertions(+), 49 deletions(-)

