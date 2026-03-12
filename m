Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E82326B2DA
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350233; cv=none; b=ktgRzNH//3uaScLyNKHlgbbpYh49wgUqvp1y87rMv9P4NO6o0rxTw3nAz2bZJFO7p6oKpXw3EIn8XLJQ/XbeQbS1Kma6YgiEc9i1MhxB/LM78aNCtMzQ584Pem9kpoF4ElsfwibAESSX2D/OaOfZz2d90Q+YEvrx4X4UcvcBbO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350233; c=relaxed/simple;
	bh=fbC9vwTdZeHCwnljkliAGlmtyCDnphp40GxDnOFm/+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bsD428B45B1nuenGj0GW45pb5ch2r4GwE2L7lXGPDDnUW45rqT4Y7YejrINY4b65pvqK1yb3nu/94aZFg2P/vMi15NxCLRrNZNt6HwsvXA6vx2eHF5Y9TftJWV53PMrWJ+7mMV+HPrUZv/RWs60VLfmo85wHpMPvyTaJien0sQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Xjpj8eFX; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Xjpj8eFX"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0n34LfXzlfl5W;
	Thu, 12 Mar 2026 21:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1773350228; x=1775942229; bh=FtBSr5h2EvzkRvZ4TBBK1SIXgrmRng2N0kZ
	mBVIuuUU=; b=Xjpj8eFXaGASUNY0la1fmwyYjkvw25AXyJOB7QYGdbSuymUuJbs
	aWu+gW5WVASwxhQP7jic6RVssEKoCYkFQzIbq048LRG8y/+Ii0ELP4Uib8V9NetL
	GUEkNuD8jFzIhwg2KSShRlkYB4XwM8RXQhvuogbfNyOOtAcYa2qBUpho4BxE/Ofk
	cCFFaIYhMfn9KY9v/4q+b02w45TIS/5bhqSaVr0cAidra6pgFjQO7DTpK/0QtyPH
	DqTkvY4JwjeuVANlSZAzO/DgAo429AIa0OgcAJw6crvd0aDTOF2okFCk0ORIIlbI
	l+QZRv/StXZGPTpnR8rtfrlZCfqT05AvAng==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JuMgbbm-wKoh; Thu, 12 Mar 2026 21:17:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0mz3VMZzlfl7l;
	Thu, 12 Mar 2026 21:17:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/36] Enable lock context analysis for most SCSI drivers
Date: Thu, 12 Mar 2026 14:15:11 -0700
Message-ID: <20260312211636.3245119-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series enables lock context analysis for most SCSI drivers. Th=
e
advantages are as follows:
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

More information about lock context analysis is available in the cover le=
tter of
[PATCH v5 00/36] Compiler-Based Context- and Locking-Analysis
(https://lore.kernel.org/lkml/20251219154418.3592607-1-elver@google.com/)=
.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (36):
  scsi: core: Prepare for enabling lock context analysis
  scsi: scsi_debug: Prepare for enabling lock context analysis
  scsi: sg: Prepare for enabling lock context analysis
  scsi: st: Prepare for enabling lock context analysis
  scsi: BusLogic: Introduce a local variable
  scsi: BusLogic: Prepare for enabling lock context analysis
  scsi: NCR5380: Prepare for enabling lock context analysis
  scsi: aacraid: Prepare for enabling lock context analysis
  scsi: aha152x: Prepare for enabling lock context analysis
  scsi: aic7xxx: Prepare for enabling lock context analysis
  scsi: be2iscsi: Prepare for enabling lock context analysis
  scsi: bnx2fc: Prepare for enabling lock context analysis
  scsi: bnx2i: Introduce a local variable
  scsi: bnx2i: Prepare for enabling lock context analysis
  scsi: csiostor: Prepare for enabling lock context analysis
  scsi: fnic: Prepare for enabling lock context analysis
  scsi: hpsa: Prepare for enabling lock context analysis
  scsi: ibmvscsi_tgt: Prepare for enabling lock context analysis
  scsi: ipr: Prepare for enabling lock context analysis
  scsi: ips: Prepare for enabling lock context analysis
  scsi: libfc: Prepare for enabling lock context analysis
  scsi: libiscsi: Prepare for enabling lock context analysis
  scsi: libsas: Prepare for enabling lock context analysis
  scsi: lpfc: Prepare for enabling lock context analysis
  scsi: megaraid_sas: Prepare for enabling lock context analysis
  scsi: mvsas: Prepare for enabling lock context analysis
  scsi: pm8001: Prepare for enabling lock context analysis
  scsi: qedi: Prepare for enabling lock context analysis
  scsi: qla1280: Prepare for enabling lock context analysis
  scsi: qla2xxx: Prepare for enabling lock context analysis
  scsi: qla4xxx: Prepare for enabling lock context analysis
  scsi: ufs: Prepare for enabling lock context analysis
  scsi: iSCSI transport: Prepare for enabling lock context analysis
  scsi: smartpqi: Prepare for enabling lock context analysis
  scsi: Enable lock context analysis
  scsi: core: Protect host state changes with the host lock

 drivers/scsi/BusLogic.c                     | 11 +++--
 drivers/scsi/Makefile                       |  1 +
 drivers/scsi/NCR5380.c                      |  4 +-
 drivers/scsi/aacraid/Makefile               |  2 +
 drivers/scsi/aacraid/commctrl.c             |  1 +
 drivers/scsi/aacraid/commsup.c              |  3 ++
 drivers/scsi/aha152x.c                      |  1 +
 drivers/scsi/aic7xxx/Makefile               |  2 +
 drivers/scsi/aic7xxx/aic79xx_osm.h          |  2 +
 drivers/scsi/aic7xxx/aic7xxx_osm.h          |  2 +
 drivers/scsi/aic7xxx/aicasm/Makefile        |  3 ++
 drivers/scsi/aic94xx/Makefile               |  2 +
 drivers/scsi/arcmsr/Makefile                |  2 +
 drivers/scsi/arm/Makefile                   |  2 +
 drivers/scsi/be2iscsi/Makefile              |  2 +
 drivers/scsi/be2iscsi/be_main.c             |  4 ++
 drivers/scsi/bfa/Makefile                   |  3 ++
 drivers/scsi/bnx2fc/Makefile                |  3 ++
 drivers/scsi/bnx2fc/bnx2fc.h                |  5 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c            |  2 +
 drivers/scsi/bnx2fc/bnx2fc_hwi.c            |  3 ++
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  6 ++-
 drivers/scsi/bnx2i/Makefile                 |  3 ++
 drivers/scsi/bnx2i/bnx2i_hwi.c              | 14 ++++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |  1 +
 drivers/scsi/csiostor/Makefile              |  2 +
 drivers/scsi/csiostor/csio_hw.c             | 12 +++++
 drivers/scsi/csiostor/csio_lnode.c          |  3 ++
 drivers/scsi/csiostor/csio_rnode.c          |  6 +++
 drivers/scsi/csiostor/csio_scsi.c           |  6 +++
 drivers/scsi/cxgbi/Makefile                 |  3 ++
 drivers/scsi/device_handler/Makefile        |  3 ++
 drivers/scsi/elx/Makefile                   |  1 +
 drivers/scsi/esas2r/Makefile                |  3 ++
 drivers/scsi/fcoe/Makefile                  |  3 ++
 drivers/scsi/fnic/Makefile                  |  3 ++
 drivers/scsi/fnic/fdls_disc.c               | 52 ++++++++++++++++++++-
 drivers/scsi/fnic/fip.c                     |  2 +
 drivers/scsi/fnic/fnic_fcs.c                |  6 +++
 drivers/scsi/fnic/fnic_scsi.c               |  4 ++
 drivers/scsi/hisi_sas/Makefile              |  3 ++
 drivers/scsi/hosts.c                        | 13 ++++--
 drivers/scsi/hpsa.c                         |  2 +-
 drivers/scsi/ibmvscsi/Makefile              |  3 ++
 drivers/scsi/ibmvscsi_tgt/Makefile          |  3 ++
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c    |  7 +++
 drivers/scsi/ipr.c                          | 11 +++++
 drivers/scsi/ips.c                          |  1 +
 drivers/scsi/isci/Makefile                  |  3 ++
 drivers/scsi/libfc/Makefile                 |  2 +
 drivers/scsi/libfc/fc_disc.c                |  6 ++-
 drivers/scsi/libfc/fc_exch.c                |  6 +++
 drivers/scsi/libfc/fc_fcp.c                 |  4 ++
 drivers/scsi/libiscsi.c                     | 19 +++++++-
 drivers/scsi/libsas/Makefile                |  2 +
 drivers/scsi/libsas/sas_ata.c               |  2 +-
 drivers/scsi/lpfc/lpfc_els.c                |  2 +
 drivers/scsi/lpfc/lpfc_nportdisc.c          |  1 +
 drivers/scsi/lpfc/lpfc_scsi.c               |  1 +
 drivers/scsi/lpfc/lpfc_sli.c                |  2 +
 drivers/scsi/megaraid/Makefile              |  3 ++
 drivers/scsi/megaraid/megaraid_sas.h        |  9 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 17 +++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 +
 drivers/scsi/mpt3sas/Makefile               |  3 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  2 +-
 drivers/scsi/mvsas/Makefile                 |  2 +
 drivers/scsi/mvsas/mv_sas.c                 |  7 +++
 drivers/scsi/pcmcia/Makefile                |  2 +
 drivers/scsi/pm8001/Makefile                |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.c            |  2 +
 drivers/scsi/qedf/Makefile                  |  3 ++
 drivers/scsi/qedi/Makefile                  |  3 ++
 drivers/scsi/qedi/qedi_fw.c                 |  1 +
 drivers/scsi/qla1280.c                      | 18 +++++++
 drivers/scsi/qla2xxx/Makefile               |  3 ++
 drivers/scsi/qla2xxx/qla_nx.c               |  2 +
 drivers/scsi/qla2xxx/qla_target.c           | 29 +++++++-----
 drivers/scsi/qla2xxx/qla_tmpl.c             |  1 +
 drivers/scsi/qla4xxx/Makefile               |  3 ++
 drivers/scsi/qla4xxx/ql4_nx.c               |  2 +
 drivers/scsi/qla4xxx/ql4_os.c               |  6 +--
 drivers/scsi/scsi_debug.c                   | 16 +++++++
 drivers/scsi/scsi_lib.c                     |  3 +-
 drivers/scsi/scsi_scan.c                    | 12 +++++
 drivers/scsi/scsi_sysfs.c                   |  7 +--
 drivers/scsi/scsi_transport_iscsi.c         |  1 +
 drivers/scsi/sg.c                           |  1 +
 drivers/scsi/smartpqi/Makefile              |  3 ++
 drivers/scsi/smartpqi/smartpqi_init.c       | 18 +++++++
 drivers/scsi/snic/Makefile                  |  3 ++
 drivers/scsi/st.c                           |  1 +
 drivers/scsi/sym53c8xx_2/Makefile           |  2 +
 drivers/ufs/Makefile                        |  2 +
 drivers/ufs/core/Makefile                   |  2 +
 drivers/ufs/core/ufs-debugfs.c              |  8 +++-
 drivers/ufs/core/ufshcd.c                   | 10 ++++
 drivers/ufs/host/Makefile                   |  2 +
 include/scsi/libiscsi.h                     |  5 +-
 include/scsi/scsi_host.h                    | 25 +++++++---
 100 files changed, 466 insertions(+), 62 deletions(-)

