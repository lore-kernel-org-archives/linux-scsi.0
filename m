Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1213AAF70
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360946; cv=none; b=NvaZt/bUAbWeuZWTbRqVblVAv7I4xlL3qs7F6WutRpyolWjG6CoaAv6xL+D65XiDFXcZDk1itB4VVsDmoL5nruQ6zufo8hRzpQ4K4lB2Ntoe0p0LJ6jlZUQSatLOOHa4HuMLBQujIXHp5SidPl/I/iRIrWmHi9FZS8Gd03e/8dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360946; c=relaxed/simple;
	bh=Irhs7oSWJ7Nte/xsGKyzGnRZRvtEN8sJnEEZ0EjUXzY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oC1xT2hwfj3dWg3ZIaXme7mV7w7/uaIan2oEbuaFoer2TGn7dLaCmkxIeJb7OznwZdpzoNIocgANgyWvt8Gxoc5d2bD1/Sbd1YV4II4eaF+ioZxVwah/1kH852T13Bg7DZwiUXPDdLN5JADBWBXWZYokO8kUBp153oar3HiXOWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AUJpWopz; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AUJpWopz"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzk65fb5z1XM5kY;
	Fri, 25 Sep 2026 18:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1790360937; x=1792952938; bh=DRir2IILfaUSw/Fi4xCp2p9VRplDt84Usqg
	xkgkpbz4=; b=AUJpWopzNYkgp/XpaINoeJQCF9RD/U/7I/ZV8CnoHln+5Cx4VpW
	aeeMIlp9IVlRAHjbjeDEWkEn3ggZVdM7bHUHC0MX+yf6muj+lZfG9xWFF8bd69WZ
	nTSwbpjdDVTK6+1eluVtwZNbwyBnGBPaaF96AOOxhGl31CETKUC411y0Z6pjBeoI
	pCmQm66jJH/5R942cnhg78styebEFFik1gDu/ewz7ih1xtpqmVzGFf3tPGpS4Uix
	eIpINAztU9N3tqGCcCWuZIg3OlhGVjWqHe498ZGJDLzqA4vcpLDQyLdW6MGBLByy
	adFifCmhQS1xrQ50/AeGuGgsZj95aDaB7bQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WcctjAX8PQJA; Fri, 25 Sep 2026 18:28:57 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzk06JVDz1XM4Sx;
	Fri, 25 Sep 2026 18:28:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 00/54] scsi: Enable context analysis for most drivers
Date: Fri, 25 Sep 2026 11:25:38 -0700
Message-ID: <cover.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

This patch series enables lock context analysis for all SCSI drivers in t=
he
drivers/scsi/ directory except scsi_debug. The advantages are as follows:
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

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v3:
 - Dropped the SCSI core and UFS patches (merged upstream in Linux 7.3).
 - Replaced __no_context_analysis with __context_unsafe(/*reason*/) acros=
s
   drivers with conditional locking (aacraid, ips, libfc, lpfc, mvsas, qe=
di,
   qla2xxx, qla4xxx).
 - Passed struct pointers directly to functions called with locks held in=
stead
   of dereferencing or using __assume_ctx_lock():
   * BusLogic: Pass struct Scsi_Host * directly to multiple functions.
   * libiscsi: Pass struct iscsi_session * directly to functions requirin=
g
     session locks and update callers in be2iscsi, bnx2i, cxgbi, libiscsi=
,
     libiscsi_tcp, qedi, qla4xxx, and iser.
   * bnx2fc: Pass tgt directly to several functions.
   * csiostor: Pass struct csio_hw * directly to cleanup and abort functi=
ons.
   * fnic: Pass struct fnic_iport_s * and struct fnic * directly.
   * ipr: Pass struct Scsi_Host * directly to error handling functions.
   * qla1280: Pass struct Scsi_Host * directly to wait/error functions.
   * NCR5380: Pass struct NCR5380_hostdata * directly to NCR5380_select()
     and NCR5380_information_transfer().
   * fcoe: Pass struct fcoe_ctlr * directly to functions called with lock=
s
     held.
 - scsi: ipr: Added patch to simplify ipr_eh_abort() by deriving the host
   pointer once (detected by Sashiko).
 - scsi: smartpqi: Fixed missing ampersands (&ctrl_info->...), documented
   locking requirements with __acquires(), __releases(), and __cond_relea=
ses(),
   and suppressed complaints with __acquire() where mutex usage is irregu=
lar.
 - scsi: cxgbi: Added __assume_ctx_lock(&conn->session->back_lock) with a
   TODO comment documenting missing locking around iscsi_itt_to_ctask().
 - scsi: libfc: Added __must_hold annotations for discovery and FCP funct=
ions.
 - scsi: ibmvscsi_tgt: Added __must_hold(&vscsi->intr_lock) annotations.
 - scsi: pm8001: Added Acked-by from Jack Wang.
 - Consolidated preparation and enabling patches for aic7xxx, be2iscsi, a=
nd
   bnx2i.
 - Moved the scsi_debug changes into a separate patch series.
 - Dropped megaraid / megaraid_sas patches from this series. These will b=
e
   reposted later.
 - Added patch "scsi: drivers: Enable lock context analysis" as the final=
 patch
   to enable CONTEXT_ANALYSIS :=3D y in drivers/scsi/Makefile (excluding
   scsi_debug).

Changes compared to v2:
 - Added patch "scsi: core: Pass the SCSI host pointer directly".
 - Corrected several annotations that had missing or extra ampersands (&)=
.
 - Reduced the number of __assume_ctx_lock() statements.

Changes compared to v1:
 - Split patch "Enable lock context analysis" into one patch per driver.


Bart Van Assche (54):
  PCI: Convert to_pci_dev() into an inline function
  scsi: sg: Prepare for enabling lock context analysis
  scsi: st: Prepare for enabling lock context analysis
  scsi: BusLogic: Pass the host pointer directly to several functions
  scsi: BusLogic: Prepare for enabling lock context analysis
  scsi: NCR5380: Prepare for enabling lock context analysis
  scsi: aacraid: Enable lock context analysis
  scsi: aha152x: Prepare for enabling lock context analysis
  scsi: aic7xxx: Enable lock context analysis
  scsi: aic94xx: Enable lock context analysis
  scsi: arcmsr: Enable lock context analysis
  scsi: libiscsi: Pass the session pointer directly to several functions
  scsi: libiscsi: Prepare for enabling lock context analysis
  scsi: be2iscsi: Enable lock context analysis
  scsi: cxgbi: Enable lock context analysis
  scsi: bfa: Enable lock context analysis
  scsi: bnx2fc: Pass tgt directly to several functions
  scsi: bnx2fc: Enable lock context analysis
  scsi: bnx2i: Enable lock context analysis
  scsi: csiostor: Pass the hw pointer directly to several functions
  scsi: csiostor: Enable lock context analysis
  scsi: elx: Enable lock context analysis
  scsi: esas2r: Enable lock context analysis
  scsi: fcoe: Enable lock context analysis
  scsi: fnic: Pass pointers directly to several functions
  scsi: fnic: Enable lock context analysis
  scsi: hisi_sas: Enable lock context analysis
  scsi: hpsa: Prepare for enabling lock context analysis
  scsi: ibmvscsi: Enable lock context analysis
  scsi: ibmvscsi_tgt: Enable lock context analysis
  scsi: ipr: Simplify ipr_eh_abort()
  scsi: ipr: Pass the host pointer directly to several functions
  scsi: ipr: Prepare for enabling lock context analysis
  scsi: ips: Prepare for enabling lock context analysis
  scsi: isci: Enable lock context analysis
  scsi: libfc: Enable lock context analysis
  scsi: libsas: Prepare for enabling lock context analysis
  scsi: libsas: Enable lock context analysis
  scsi: lpfc: Prepare for enabling lock context analysis
  scsi: mpt3sas: Enable lock context analysis
  scsi: mvsas: Enable lock context analysis
  scsi: pcmcia: Enable lock context analysis
  scsi: pm8001: Enable lock context analysis
  scsi: qedf: Enable lock context analysis
  scsi: qedi: Enable lock context analysis
  scsi: qla1280: Pass the host pointer directly to several functions
  scsi: qla1280: Prepare for enabling lock context analysis
  scsi: qla2xxx: Enable lock context analysis
  scsi: qla4xxx: Enable lock context analysis
  scsi: iSCSI transport: Prepare for enabling lock context analysis
  scsi: smartpqi: Enable lock context analysis
  scsi: snic: Enable lock context analysis
  scsi: sym53c8xx_2: Enable lock context analysis
  scsi: drivers: Enable lock context analysis

 drivers/infiniband/ulp/iser/iser_initiator.c |   3 +-
 drivers/scsi/BusLogic.c                      |  99 ++++---
 drivers/scsi/BusLogic.h                      |   3 +-
 drivers/scsi/Makefile                        |  25 +-
 drivers/scsi/NCR5380.c                       |  19 +-
 drivers/scsi/NCR5380.h                       |   5 +-
 drivers/scsi/aacraid/Makefile                |   2 +
 drivers/scsi/aacraid/commctrl.c              |   1 +
 drivers/scsi/aacraid/commsup.c               |   3 +
 drivers/scsi/aha152x.c                       |   4 +-
 drivers/scsi/aic7xxx/Makefile                |   2 +
 drivers/scsi/aic7xxx/aic79xx_osm.h           |   2 +
 drivers/scsi/aic7xxx/aic7xxx_osm.h           |   2 +
 drivers/scsi/aic94xx/Makefile                |   2 +
 drivers/scsi/arcmsr/Makefile                 |   2 +
 drivers/scsi/be2iscsi/Makefile               |   2 +
 drivers/scsi/be2iscsi/be_main.c              |  18 +-
 drivers/scsi/bfa/Makefile                    |   3 +
 drivers/scsi/bnx2fc/Makefile                 |   3 +
 drivers/scsi/bnx2fc/bnx2fc.h                 |   9 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c             |  27 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c             |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c              |  15 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c             |   2 +-
 drivers/scsi/bnx2i/Makefile                  |   3 +
 drivers/scsi/bnx2i/bnx2i_hwi.c               |  45 ++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c             |   1 +
 drivers/scsi/csiostor/Makefile               |   2 +
 drivers/scsi/csiostor/csio_attr.c            |   4 +-
 drivers/scsi/csiostor/csio_hw.c              |  20 +-
 drivers/scsi/csiostor/csio_lnode.c           |   3 +
 drivers/scsi/csiostor/csio_rnode.c           |   9 +-
 drivers/scsi/csiostor/csio_scsi.c            |  42 +--
 drivers/scsi/csiostor/csio_scsi.h            |   7 +-
 drivers/scsi/cxgbi/Makefile                  |   3 +
 drivers/scsi/cxgbi/libcxgbi.c                |  13 +-
 drivers/scsi/elx/Makefile                    |   1 +
 drivers/scsi/esas2r/Makefile                 |   3 +
 drivers/scsi/fcoe/Makefile                   |   3 +
 drivers/scsi/fcoe/fcoe_ctlr.c                |  50 +++-
 drivers/scsi/fnic/Makefile                   |   3 +
 drivers/scsi/fnic/fdls_disc.c                |  57 +++-
 drivers/scsi/fnic/fip.c                      |   2 +
 drivers/scsi/fnic/fnic_fcs.c                 |  21 +-
 drivers/scsi/fnic/fnic_fdls.h                |   7 +-
 drivers/scsi/fnic/fnic_scsi.c                |   4 +
 drivers/scsi/hisi_sas/Makefile               |   3 +
 drivers/scsi/hpsa.c                          |   2 +-
 drivers/scsi/ibmvscsi/Makefile               |   3 +
 drivers/scsi/ibmvscsi_tgt/Makefile           |   3 +
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  34 ++-
 drivers/scsi/ipr.c                           |  46 ++--
 drivers/scsi/ips.c                           |   1 +
 drivers/scsi/isci/Makefile                   |   3 +
 drivers/scsi/libfc/Makefile                  |   2 +
 drivers/scsi/libfc/fc_disc.c                 |   7 +-
 drivers/scsi/libfc/fc_exch.c                 |   6 +
 drivers/scsi/libfc/fc_fcp.c                  |  17 +-
 drivers/scsi/libiscsi.c                      | 258 +++++++++++--------
 drivers/scsi/libiscsi_tcp.c                  |  17 +-
 drivers/scsi/libsas/Makefile                 |   2 +
 drivers/scsi/libsas/sas_ata.c                |   2 +-
 drivers/scsi/lpfc/lpfc_els.c                 |   2 +
 drivers/scsi/lpfc/lpfc_nportdisc.c           |   1 +
 drivers/scsi/lpfc/lpfc_scsi.c                |   1 +
 drivers/scsi/lpfc/lpfc_sli.c                 |   2 +
 drivers/scsi/mpt3sas/Makefile                |   3 +
 drivers/scsi/mvsas/Makefile                  |   2 +
 drivers/scsi/mvsas/mv_sas.c                  |   7 +
 drivers/scsi/pcmcia/Makefile                 |   2 +
 drivers/scsi/pm8001/Makefile                 |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c             |   2 +
 drivers/scsi/qedf/Makefile                   |   3 +
 drivers/scsi/qedi/Makefile                   |   3 +
 drivers/scsi/qedi/qedi_fw.c                  |  35 +--
 drivers/scsi/qla1280.c                       |  57 ++--
 drivers/scsi/qla2xxx/Makefile                |   3 +
 drivers/scsi/qla2xxx/qla_nx.c                |   2 +
 drivers/scsi/qla2xxx/qla_target.c            |  29 ++-
 drivers/scsi/qla2xxx/qla_tmpl.c              |   1 +
 drivers/scsi/qla4xxx/Makefile                |   3 +
 drivers/scsi/qla4xxx/ql4_isr.c               |   8 +-
 drivers/scsi/qla4xxx/ql4_nx.c                |   2 +
 drivers/scsi/scsi_transport_iscsi.c          |   1 +
 drivers/scsi/sg.c                            |   1 +
 drivers/scsi/smartpqi/Makefile               |   3 +
 drivers/scsi/smartpqi/smartpqi_init.c        |  67 ++++-
 drivers/scsi/snic/Makefile                   |   3 +
 drivers/scsi/st.c                            |   1 +
 drivers/scsi/sym53c8xx_2/Makefile            |   2 +
 include/linux/pci.h                          |   5 +-
 include/scsi/libiscsi.h                      |  23 +-
 92 files changed, 834 insertions(+), 405 deletions(-)

