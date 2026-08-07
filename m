Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D3B2F30
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786143018; cv=none; b=dQiy5eYRdCCK3cKSwu9AMI7bvlrwJr27X2GLjvLsdreXnV4S9fSrFd54+kvYo+LZU55RT1sUZcN0q1A6gv5enYxW4zvb/iJ1BYZ1rvSQTkqLzggwFvq9Ftzkn8aT2Vkp8OA35wORSX2t0hdMS/eYI8kljiktvDy9dVnEDt8/qRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786143018; c=relaxed/simple;
	bh=gnZK5J0uE8gYv1Vzh9IT0ycsodbjfKEh5PnkOpxpDTc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=corEeqma9YD60m+IYJBQ4jbPBeVJtPqq+4OtEvRufIRiXTjI1INQuRGcMP4kftpYu7kPdqivpgQZOYdQtkpOyz8TdC72CiTc7eYYGggq45NI5OU6lRbHjlsFe/sLvRgIiKSgkS6qX96VKy7duxKvwsjLYK9bv8QXaCMf5QXu1bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2V1BvOsn; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2V1BvOsn"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hGzr847z9zlfwgW;
	Fri,  7 Aug 2026 22:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1786143012; x=1788735013; bh=F4J5tZ2Pn1o4T+PISjmC3nCCXCujZy8x/bP
	eQSlR/fc=; b=2V1BvOsnPeGThLCV5yg6BaEwiIyWycHr+UFAJds8IDRs+RQ2CWv
	wOzRwDicl1mk3JbW7g7y8sZ9m+AZNy7/i1Mgno8pS/l7aNAzluzgawOih0VZ7Ha+
	pUAM8Q9dRKOetfJ6xHhbNGiWuuvMdb3ZACruGFDquzzEB/49XgqPMdCk82DZtT1Y
	RB+0HdFKqOEoW5Itr8cHWo0Ce+T7oFao7iBct8Ug0gkOG2xRgyU1wv+2FheLcGOZ
	ofi2lpXCappQWzWMTj/75UPIRIg/kDlAqBeQoheiiQbwpmg748/f0xj+dSrkyKRV
	AlOoCCiyE4EorvZxI/qK2Hcnhbybx4Hr8/g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b2NpXR4zregd; Fri,  7 Aug 2026 22:50:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzr35Fzyzlfvq0;
	Fri,  7 Aug 2026 22:50:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 0/6] Enable context analysis in the SCSI core and UFS driver
Date: Fri,  7 Aug 2026 15:49:45 -0700
Message-ID: <cover.1786142946.git.bvanassche@acm.org>
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

Changes compared to v6:
 - Left out duplicate patch 2/6.

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
  ufs: core: Enable context analysis
  scsi: core: Pass the SCSI host pointer directly to scanning functions
  scsi: core: Add lock context annotations
  scsi: core: Protect host state changes with the host lock
  scsi: core: Enable context analysis

 drivers/scsi/Makefile                     | 22 ++++++++++
 drivers/scsi/device_handler/Makefile      |  3 ++
 drivers/scsi/hosts.c                      | 19 +++++----
 drivers/scsi/leapraid/leapraid_func.c     |  2 +-
 drivers/scsi/leapraid/leapraid_os.c       |  2 +-
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
 include/scsi/scsi_host.h                  | 24 ++++++++---
 17 files changed, 121 insertions(+), 52 deletions(-)

