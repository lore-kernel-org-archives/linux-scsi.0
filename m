Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371533B19CF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451625; cv=none; b=SQ4hra5eq0ebk+7GGevNodoKoW1Ho8iptcBN8G9C2Rd3qHUWtWQWhudbiO6XGLNgjFNiKTxjQhJ86Tr+heMEWD3MBgu6G7s+0ZpxZVAB+EGvreEEVRcFZ6L9MFlY4XmBjZPak0F6chIi/21VSAZtKRNrweYtJ1dk1vf9LSu2IRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451625; c=relaxed/simple;
	bh=SDjL1voIGmluqePagFwMhj/8tJB1CEISQT0dvrdSfpc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tlYnmZCPtEUScvOsCfkgJR/esjg8Il7px+tUCW9eNrNf8Pft0RyXUsK57Iw2nZV8pGIbykl7LDmDTnwy0/HZAX0NKDs2C/VKhMBUHw/nxFEy3zIz7aw9Jui3BuFpPuLAXzV7q0UfGYEvNmKQj4ny+SFtHj3zE9exCUZN/nPBnXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DrRAH3sE; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DrRAH3sE"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4874x37z1XM30k;
	Thu, 30 Jul 2026 22:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1785451617; x=1788043618; bh=wwUmd5EjKAybeOOZnV8oGssrrm/vdy1OdN8
	TO1OTSU0=; b=DrRAH3sEbGx6BrKwNNWn85pfSrAjhXCZR6Ox3Q9ASr2cZkbfaYx
	14ZFX0Ucks6BibT14c9l/y9741hQB6AcRh2UjEJWetCCoq5EouJpBpEjYhchUyPK
	z1CESG/IHv5XWYp9j9/lbf8GasDptqT96/SCxy+qaU+fTvI2Rf+Hs5uoi1RqeA3d
	iRtGfIDrw2pS2zmXes+wwBVEJ32CdYDuyy16EhcelMzAPNlR51pL8ESwr/jhhOC1
	V+78DnEBIRKEkjw36XgVBaOQF7xLnHohTxUPZnVjdbs7IzNebY1esIWy/iGB2dNP
	iBjloojtWlgn77eBqYmzCduNjPhupNe/57A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1mKcV0bJdDx3; Thu, 30 Jul 2026 22:46:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4806B0jz1XM4TB;
	Thu, 30 Jul 2026 22:46:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 00/57] Enable lock context analysis for the SCSI subsystem
Date: Thu, 30 Jul 2026 15:44:43 -0700
Message-ID: <cover.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

This patch series enables lock context analysis for all SCSI drivers and =
also
for the SCSI core. The advantages are as follows:
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

Changes compared to v2:
 - Added patch "scsi: core: Pass the SCSI host pointer directly".
 - Corrected several annotations that had missing or extra ampersands (&)=
.
 - Reduced the number of __assume_ctx_lock() statements.

Changes compared to v1:
 - Split patch "Enable lock context analysis" into one patch per driver.

Bart Van Assche (57):
  PCI: Convert to_pci_dev() into an inline function
  scsi: scsi_debug: Prepare for enabling lock context analysis
  scsi: sg: Prepare for enabling lock context analysis
  scsi: st: Prepare for enabling lock context analysis
  scsi: BusLogic: Introduce two local variables
  scsi: BusLogic: Prepare for enabling lock context analysis
  scsi: NCR5380: Prepare for enabling lock context analysis
  scsi: aacraid: Prepare for enabling lock context analysis
  scsi: aic7xxx: Enable lock context analysis
  scsi: aha152x: Prepare for enabling lock context analysis
  scsi: aic7xxx: Prepare for enabling lock context analysis
  scsi: aic94xx: Enable lock context analysis
  scsi: arcmsr: Enable lock context analysis
  scsi: arm: Enable lock context analysis
  scsi: be2iscsi: Prepare for enabling lock context analysis
  scsi: be2iscsi: Enable lock context analysis
  scsi: cxgbi: Enable lock context analysis
  scsi: bfa: Enable lock context analysis
  scsi: bnx2fc: Enable lock context analysis
  scsi: bnx2i: Introduce a local variable
  scsi: bnx2i: Enable lock context analysis
  scsi: csiostor: Enable lock context analysis
  scsi: elx: Enable lock context analysis
  scsi: esas2r: Enable lock context analysis
  scsi: fcoe: Enable lock context analysis
  scsi: fnic: Enable lock context analysis
  scsi: hisi_sas: Enable lock context analysis
  scsi: hpsa: Prepare for enabling lock context analysis
  scsi: ibmvscsi: Enable lock context analysis
  scsi: ibmvscsi_tgt: Enable lock context analysis
  scsi: ipr: Prepare for enabling lock context analysis
  scsi: ips: Prepare for enabling lock context analysis
  scsi: isci: Enable lock context analysis
  scsi: libfc: Enable lock context analysis
  scsi: libiscsi: Prepare for enabling lock context analysis
  scsi: libsas: Prepare for enabling lock context analysis
  scsi: libsas: Enable lock context analysis
  scsi: lpfc: Prepare for enabling lock context analysis
  scsi: megaraid_sas: Prepare for enabling lock context analysis
  scsi: megaraid: Enable lock context analysis
  scsi: mpt3sas: Enable lock context analysis
  scsi: mvsas: Enable lock context analysis
  scsi: pcmcia: Enable lock context analysis
  scsi: pm8001: Enable lock context analysis
  scsi: qedf: Enable lock context analysis
  scsi: qedi: Enable lock context analysis
  scsi: qla1280: Prepare for enabling lock context analysis
  scsi: qla2xxx: Enable lock context analysis
  scsi: qla4xxx: Enable lock context analysis
  scsi: ufs: Enable lock context analysis
  scsi: iSCSI transport: Prepare for enabling lock context analysis
  scsi: smartpqi: Enable lock context analysis
  scsi: snic: Enable lock context analysis
  scsi: sym53c8xx_2: Enable lock context analysis
  scsi: core: Pass the SCSI host pointer directly
  scsi: core: Enable lock context analysis
  scsi: core: Protect host state changes with the host lock

 drivers/scsi/BusLogic.c                     | 19 +++---
 drivers/scsi/BusLogic.h                     |  3 +-
 drivers/scsi/Makefile                       |  1 +
 drivers/scsi/NCR5380.c                      |  4 +-
 drivers/scsi/aacraid/Makefile               |  2 +
 drivers/scsi/aacraid/commctrl.c             |  1 +
 drivers/scsi/aacraid/commsup.c              |  3 +
 drivers/scsi/aha152x.c                      |  1 +
 drivers/scsi/aic7xxx/Makefile               |  2 +
 drivers/scsi/aic7xxx/aic79xx_osm.h          |  2 +
 drivers/scsi/aic7xxx/aic7xxx_osm.h          |  2 +
 drivers/scsi/aic94xx/Makefile               |  2 +
 drivers/scsi/arcmsr/Makefile                |  2 +
 drivers/scsi/arm/Makefile                   |  2 +
 drivers/scsi/be2iscsi/Makefile              |  2 +
 drivers/scsi/be2iscsi/be_main.c             |  4 ++
 drivers/scsi/bfa/Makefile                   |  3 +
 drivers/scsi/bnx2fc/Makefile                |  3 +
 drivers/scsi/bnx2fc/bnx2fc.h                |  5 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c            |  2 +
 drivers/scsi/bnx2fc/bnx2fc_hwi.c            |  3 +
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  6 +-
 drivers/scsi/bnx2i/Makefile                 |  3 +
 drivers/scsi/bnx2i/bnx2i_hwi.c              | 14 ++++-
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |  1 +
 drivers/scsi/csiostor/Makefile              |  2 +
 drivers/scsi/csiostor/csio_hw.c             | 12 ++++
 drivers/scsi/csiostor/csio_lnode.c          |  3 +
 drivers/scsi/csiostor/csio_rnode.c          |  6 ++
 drivers/scsi/csiostor/csio_scsi.c           |  6 ++
 drivers/scsi/cxgbi/Makefile                 |  3 +
 drivers/scsi/device_handler/Makefile        |  3 +
 drivers/scsi/elx/Makefile                   |  1 +
 drivers/scsi/esas2r/Makefile                |  3 +
 drivers/scsi/fcoe/Makefile                  |  3 +
 drivers/scsi/fnic/Makefile                  |  3 +
 drivers/scsi/fnic/fdls_disc.c               | 52 +++++++++++++++-
 drivers/scsi/fnic/fip.c                     |  2 +
 drivers/scsi/fnic/fnic_fcs.c                |  6 ++
 drivers/scsi/fnic/fnic_scsi.c               |  4 ++
 drivers/scsi/hisi_sas/Makefile              |  3 +
 drivers/scsi/hosts.c                        | 13 ++--
 drivers/scsi/hpsa.c                         |  2 +-
 drivers/scsi/ibmvscsi/Makefile              |  3 +
 drivers/scsi/ibmvscsi_tgt/Makefile          |  3 +
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c    |  7 +++
 drivers/scsi/ipr.c                          | 11 ++++
 drivers/scsi/ips.c                          |  1 +
 drivers/scsi/isci/Makefile                  |  3 +
 drivers/scsi/libfc/Makefile                 |  2 +
 drivers/scsi/libfc/fc_disc.c                |  6 +-
 drivers/scsi/libfc/fc_exch.c                |  6 ++
 drivers/scsi/libfc/fc_fcp.c                 |  4 ++
 drivers/scsi/libiscsi.c                     | 19 +++++-
 drivers/scsi/libsas/Makefile                |  2 +
 drivers/scsi/libsas/sas_ata.c               |  2 +-
 drivers/scsi/lpfc/lpfc_els.c                |  2 +
 drivers/scsi/lpfc/lpfc_nportdisc.c          |  1 +
 drivers/scsi/lpfc/lpfc_scsi.c               |  1 +
 drivers/scsi/lpfc/lpfc_sli.c                |  2 +
 drivers/scsi/megaraid/Makefile              |  3 +
 drivers/scsi/megaraid/megaraid_sas.h        |  9 ++-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 17 ++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 +
 drivers/scsi/mpt3sas/Makefile               |  3 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  2 +-
 drivers/scsi/mvsas/Makefile                 |  2 +
 drivers/scsi/mvsas/mv_sas.c                 |  7 +++
 drivers/scsi/pcmcia/Makefile                |  2 +
 drivers/scsi/pm8001/Makefile                |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.c            |  2 +
 drivers/scsi/qedf/Makefile                  |  3 +
 drivers/scsi/qedi/Makefile                  |  3 +
 drivers/scsi/qedi/qedi_fw.c                 |  1 +
 drivers/scsi/qla1280.c                      | 18 ++++++
 drivers/scsi/qla2xxx/Makefile               |  3 +
 drivers/scsi/qla2xxx/qla_nx.c               |  2 +
 drivers/scsi/qla2xxx/qla_target.c           | 29 +++++----
 drivers/scsi/qla2xxx/qla_tmpl.c             |  1 +
 drivers/scsi/qla4xxx/Makefile               |  3 +
 drivers/scsi/qla4xxx/ql4_nx.c               |  2 +
 drivers/scsi/qla4xxx/ql4_os.c               |  6 +-
 drivers/scsi/scsi_debug.c                   | 65 +++++++++-----------
 drivers/scsi/scsi_lib.c                     |  3 +-
 drivers/scsi/scsi_scan.c                    | 51 +++++++++-------
 drivers/scsi/scsi_sysfs.c                   |  7 ++-
 drivers/scsi/scsi_transport_iscsi.c         |  1 +
 drivers/scsi/sg.c                           |  1 +
 drivers/scsi/smartpqi/Makefile              |  3 +
 drivers/scsi/smartpqi/smartpqi_init.c       | 67 +++++++++++++++++----
 drivers/scsi/snic/Makefile                  |  3 +
 drivers/scsi/st.c                           |  1 +
 drivers/scsi/sym53c8xx_2/Makefile           |  2 +
 drivers/ufs/core/Makefile                   |  2 +
 drivers/ufs/core/ufs-debugfs.c              |  8 ++-
 drivers/ufs/core/ufshcd.c                   | 14 +++++
 drivers/ufs/host/Makefile                   |  2 +
 include/linux/pci.h                         |  5 +-
 include/scsi/libiscsi.h                     |  5 +-
 include/scsi/scsi_host.h                    | 25 +++++---
 100 files changed, 543 insertions(+), 137 deletions(-)

