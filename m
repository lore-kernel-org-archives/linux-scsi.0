Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549DA3D47A6
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786142701; cv=none; b=stR4n3d62yHpiFd6FCSrklljxoDeFMgF7+2l6OulR5LILg1Wi1CLz6xtgfyCqtnF4c+3wIiO7qWkN/I1VfFAO2iUEXFxfC7/qvZIpozxQ/nY50wvoaTbHWZkJt6G0vdc91Snv/3BTWdKE4P5hmsdBV38K5Wae38VZycuhP/izHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786142701; c=relaxed/simple;
	bh=AYAW4iIMiL9QM13SuJ+KRhuB7OltJCGMFdOdsuOh2gI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gzf7XR62jIkKWMHDHSd8GiYBuXRwOtjcb7fBqMIUZ1kObuhVN6ZhVhKgzqndMV0B2fSQdtK6K5vSqBJDmpA64GLsyLi0nmzYOWmHImOAaCaHd8Kj7Tac5S9IkandcBKpbdgRjSbL5gmNH45QOIk8Ja9u5Btw71sB8/W7kppts48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZZ5fPApP; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZZ5fPApP"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hGzk34jHzz1XM6JR;
	Fri,  7 Aug 2026 22:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1786142695; x=1788734696; bh=GINkxb3KfvY1BUb9Vpeay/CiqYBbHEvrKSF
	MBt0yYvg=; b=ZZ5fPApPT6RhCtDfYmwF1EUbv0w+aKjEOjgTBfpjTTgg05o8xFL
	4BMflyvaWoC92uoCCHB44d8sSTp60nPoM5FxJqMINRr8md+YOd8KZ6bmWfYZRhw+
	7ZFz5W5pdukOLCKFebIU157ijMoOhAzJguAItjxuyvgCt5afAGk+wDWnUkYsQxDL
	HSHfOR769sr2a5nll1gEd9Tzea1BIHQ0z/+fcHJAKECorrZ7bbnQmqbxcalkS5W5
	3BqA74pe9+QHiLIGTrA0g8SjZldVNxqHXcu1LeZsHv20E/B6gzCAxpMqmkyA2BRK
	F6v5y3m7j51vi4QAA24GTIxajCyyzMAnwtw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iA26NzZvT_GX; Fri,  7 Aug 2026 22:44:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzjy2NMdz1XM4Tn;
	Fri,  7 Aug 2026 22:44:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 0/6] Enable context analysis in the SCSI core and UFS driver
Date: Fri,  7 Aug 2026 15:44:17 -0700
Message-ID: <cover.1786140825.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series enables context analysis for the SCSI core and the UFS
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

Changes compared to v5:
 - In patch 5/6, add __must_hold() to both the definition and the declara=
tion of
   scsi_host_set_state(). Use locking in scsi_get_host_state() instead of
   READ_ONCE(). Add #include <linux/cleanup.h>. Rename host_state into st=
ate.
 - In patch 6/6, refer to context analysis instead of compiler warnings.
 - Include changes for the leapraid driver.
 - Added several Reviewed-by tags.

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
  scsi: core: Enable context analysis

 drivers/scsi/Makefile                     | 22 ++++++++++
 drivers/scsi/device_handler/Makefile      |  3 ++
 drivers/scsi/hosts.c                      | 15 ++++---
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
 include/scsi/scsi_host.h                  | 25 ++++++++---
 15 files changed, 118 insertions(+), 48 deletions(-)

