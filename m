Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A78417588
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 19:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356796; cv=none; b=NO7OmTzt5RC45sUcITgjNooDrl7wnJC+DTkiIKziYLiWkUIsjyURtb42eVTnPfvTfaHoXRx3xXVm3sCPLV4n7CliaG3A1jC6HqHAJOJzmENtk9IOYQrdI0kzC/xm1vRTJJLDUZFRsz/pQvLmQSNJalxzSg7tJDWvcRPO+GV2pZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356796; c=relaxed/simple;
	bh=nhVVotkjEidO4CY+SZ9H4P3QGraIgrfjAdA9kvwfBx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BZ3Ii0DFpAPNexdAPNflSb7WShfHEcwOp1WpFOVKKnTNIZmK2/X41P3Vial6KFzxlxR+QSN35dqajSxxKF5AI5b9IebYPdFaEQb318nZZiSavOrKXCCYKCMF/XZybnLM5n1YFiv/fOpX7aQ8Huhxqv904NrHQg3JLwobKwqp3HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=G4N/JgN+; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="G4N/JgN+"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYvZ2ssjz6ClY9K;
	Thu, 22 Aug 2024 19:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1724356791; x=1726948792; bh=4x2n0gWdMV04aRUL5bF8MYt61K8wnuYHRkY
	kGktryQY=; b=G4N/JgN+rnsyZZG2F/9EMM/YMbzFP4ZzJxn4vaT4BIFk5DluNY3
	zKgYSvGE6vVu05fMOpPXvPyJ++6a1S2+Dweqk+ooJJGaLdK0NRbZavwmT5ITzpsX
	3eopyHbdxm/Z7fuSzQWLkFUgdWWQ41xSN2oqXOhJG/RuTJjqIb6ZTbYhgcq05kzu
	lN+n2oyhX+asO+e0A5e/Hb0GIX1UQdHaLRoWv/lgelyc2HWf2R+re/6jM8NoDJcN
	JoADuIXpEEVCnp8SIbKURfurNtmBdL24csiB+5bvBRLy57vPEWB7hwv7auY9g2/A
	E0bgr+7QsSGes3MfSg+7T+8cdhSYOrL9+Xw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VXrBKQnX_6DI; Thu, 22 Aug 2024 19:59:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYvW4bVVz6ClY9J;
	Thu, 22 Aug 2024 19:59:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 00/18] Simplify multiple create*_workqueue() invocations
Date: Thu, 22 Aug 2024 12:59:04 -0700
Message-ID: <20240822195944.654691-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Multiple SCSI drivers use snprintf() to format a workqueue name before
invoking one of the create*_workqueue() macros. This patch series
simplifies such code by passing the format string and arguments to
alloc_workqueue(). Additionally, the structure members that are only used
as a temporary buffer for formatting workqueue names are removed. Please
consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v2:
 - Added more Reviewed-by tags.

Changes compared to v1:
 - Added several Reviewed-by tags.

Bart Van Assche (18):
  scsi: Expand all create*_workqueue() invocations
  scsi: mptfusion: Simplify the alloc*_workqueue() invocations
  scsi: be2iscsi: Simplify an alloc_workqueue() invocation
  scsi: bfa: Simplify an alloc_ordered_workqueue() invocation
  scsi: esas2r: Simplify an alloc_ordered_workqueue() invocation
  scsi: fcoe: Simplify alloc_ordered_workqueue() invocations
  scsi: ibmvscsi_tgt: Simplify an alloc_workqueue() invocation
  scsi: mpi3mr: Simplify an alloc_ordered_workqueue() invocation
  scsi: mpt3sas: Simplify an alloc_ordered_workqueue() invocation
  scsi: myrb: Simplify an alloc_ordered_workqueue() invocation
  scsi: myrs: Simplify an alloc_ordered_workqueue() invocation
  scsi: qedf: Simplify alloc_workqueue() invocations
  scsi: qedi: Simplify an alloc_workqueue() invocation
  scsi: snic: Simplify alloc_workqueue() invocations
  scsi: scsi_transport_fc: Simplify alloc_workqueue() invocations
  scsi: stex: Simplify an alloc_ordered_workqueue() invocation
  scsi: ufs: Simplify alloc*_workqueue() invocation
  scsi: core: Simplify an alloc_workqueue() invocation

 drivers/message/fusion/mptbase.c            | 10 +++-------
 drivers/message/fusion/mptbase.h            |  3 ---
 drivers/message/fusion/mptfc.c              |  7 ++-----
 drivers/scsi/be2iscsi/be_main.c             |  6 ++----
 drivers/scsi/bfa/bfad_im.c                  |  5 ++---
 drivers/scsi/bfa/bfad_im.h                  |  1 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  3 ++-
 drivers/scsi/elx/efct/efct_lio.c            |  3 ++-
 drivers/scsi/esas2r/esas2r.h                |  1 -
 drivers/scsi/esas2r/esas2r_init.c           |  5 ++---
 drivers/scsi/fcoe/fcoe_sysfs.c              | 18 +++++------------
 drivers/scsi/fnic/fnic_main.c               |  6 ++++--
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  3 ++-
 drivers/scsi/hosts.c                        |  9 ++++-----
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c    |  5 ++---
 drivers/scsi/libfc/fc_exch.c                |  3 ++-
 drivers/scsi/libfc/fc_rport.c               |  3 ++-
 drivers/scsi/libsas/sas_init.c              |  4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  4 ++--
 drivers/scsi/mpi3mr/mpi3mr.h                |  2 --
 drivers/scsi/mpi3mr/mpi3mr_fw.c             |  4 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c             |  4 +---
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  4 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  4 +---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  4 +---
 drivers/scsi/myrb.c                         |  5 ++---
 drivers/scsi/myrb.h                         |  1 -
 drivers/scsi/myrs.c                         |  5 ++---
 drivers/scsi/myrs.h                         |  1 -
 drivers/scsi/qedf/qedf_main.c               | 20 +++++++++----------
 drivers/scsi/qedi/qedi_main.c               |  8 +++++---
 drivers/scsi/qla2xxx/qla_os.c               |  6 ++++--
 drivers/scsi/qla4xxx/ql4_os.c               |  2 +-
 drivers/scsi/scsi_transport_fc.c            | 11 +++--------
 drivers/scsi/snic/snic_main.c               |  8 ++++----
 drivers/scsi/stex.c                         |  6 ++----
 drivers/scsi/vmw_pvscsi.c                   |  3 ++-
 drivers/ufs/core/ufshcd.c                   | 22 +++++++--------------
 include/scsi/fcoe_sysfs.h                   |  2 --
 include/scsi/scsi_host.h                    |  1 -
 include/scsi/scsi_transport_fc.h            |  6 ------
 42 files changed, 90 insertions(+), 142 deletions(-)

