Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54395264615;
	Wed, 30 Jul 2025 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753886668; cv=none; b=KumPhw4ihJP5d5g7LjHxuvoAP+QZ+0UXCB2TopQwHYUSl/VRcKGVlS8L/Hjmx2BbGmcm2QcKLG+jqwU1pr4C5l1XQDUoH/O+XQ6QTFbkwhxhATnXGYzqfnFuXdVmnvs3b1KizxBHLkuZEWjANkDpyUDuMzMacEO0z1QbSBhl2s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753886668; c=relaxed/simple;
	bh=IC6kow1bk7hyOo9erkSZxLzJUYNJgeyJQUMdiRyNy0s=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=Mkymxe+1qe99mvkYDO417bH1ZwsVPAKq7MhdgFxNPWjklw3ZrjcQFvlVOuv2dT1n8Z+Mb6Yem4qbAfGi6SraZ0M6bdrmr4k7DwCKjVc8jMjnQnP1S0BZ25LE6hRL+2qoElRBbWaUWkRU9/NMvl0JyLGCar3AKrTBLNBxT922a1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=pu645gy1; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="pu645gy1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1753886664;
	bh=IC6kow1bk7hyOo9erkSZxLzJUYNJgeyJQUMdiRyNy0s=;
	h=Message-ID:Subject:From:To:Date:From;
	b=pu645gy18OKgw9yV8QxEB7a3NfImQ43WXNmYStm0n6ho/a8ItSd5hcg0vGeKekkAD
	 oedZpC+N8GK7t3AstAqTyJ+2MAb+iC5aSGKcpkcdb+cPnO2RYvlDnVx6WBRrmiNLa8
	 dtPU1RCwY9PEqw2S4SbEpV0ZSP45MiwHdsJJqtWY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id D95361C0093;
	Wed, 30 Jul 2025 10:44:23 -0400 (EDT)
Message-ID: <f50e46e97328c9416ad227a1919874f98d13843d.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 6.16+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Wed, 30 Jul 2025 10:44:23 -0400
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Smaller set of driver updates than usual (ufs, lpfc, mpi3mr).  The rest
(including the core file changes) are doc updates and some minor bug
fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alok Tiwari (1):
      scsi: fc_transport: docs: Add documentation for FC Remote Ports

Andr=C3=A9 Draszik (2):
      scsi: ufs: exynos: Fix programming of HCI_UTRL_NEXUS_TYPE
      scsi: mpt3sas: Drop unused variable in mpt3sas_send_mctp_passthru_req=
()

Ankit Dange (1):
      scsi: ibmvscsi_tgt: Fix typo in comment

Arnd Bergmann (1):
      scsi: qla2xxx: Avoid stack frame size warning in qla_dfs

Avri Altman (1):
      scsi: ufs: Clear ucd_rsp_ptr for UPIU requests once

Bagas Sanjaya (1):
      scsi: core: Fix kernel doc for scsi_track_queue_full()

Bao D. Nguyen (1):
      scsi: ufs: ufs-qcom: Update esi_vec_mask for HW major version >=3D 6

Bart Van Assche (2):
      scsi: core: Use scsi_cmd_priv() instead of open-coding it
      scsi: ufs: core: Improve return value documentation

Damien Le Moal (3):
      scsi: mpt3sas: Correctly handle ATA device errors
      scsi: mpi3mr: Correctly handle ATA device errors
      scsi: core: Remember if a device is an ATA device

Ewan D. Milne (2):
      scsi: scsi_transport_fc: Add comments to describe added 'rport' param=
eter
      scsi: scsi_transport_fc: Change to use per-rport devloss_work_q

Francisco Gutierrez (1):
      scsi: pm80xx: Free allocated tags after failure

Hannes Reinecke (1):
      scsi: fcoe: Remove fcoe_select_cpu()

Huan Tang (1):
      scsi: ufs: core: Add HID support

Justin Tee (13):
      scsi: lpfc: Copyright updates for 14.4.0.10 patches
      scsi: lpfc: Update lpfc version to 14.4.0.10
      scsi: lpfc: Modify end-of-life adapters' model descriptions
      scsi: lpfc: Revise CQ_CREATE_SET mailbox bitfield definitions
      scsi: lpfc: Move clearing of HBA_SETUP flag to before lpfc_sli4_queue=
_unset
      scsi: lpfc: Ensure HBA_SETUP flag is used only for SLI4 in dev_loss_t=
mo_callbk
      scsi: lpfc: Relocate clearing initial phba flags from link up to link=
 down hdlr
      scsi: lpfc: Simplify error handling for failed lpfc_get_sli4_paramete=
rs cmd
      scsi: lpfc: Early return out of FDMI cmpl for locally rejected status=
es
      scsi: lpfc: Skip RSCN processing when FC_UNLOADING flag is set
      scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport struc=
ture
      scsi: lpfc: Update debugfs trace ring initialization messages
      scsi: lpfc: Revise logging format for failed CT MIB requests

Kassey Li (1):
      scsi: trace: Show rtn in string for scsi_dispatch_cmd_error()

Nitin Rawat (2):
      scsi: ufs: ufs-qcom: Enable QUnipro Internal Clock Gating
      scsi: ufs: core: Add ufshcd_dme_rmw() to modify DME attributes

Randy Dunlap (1):
      scsi: mpi3mr: Fix kernel-doc issues in mpi3mr_app.c

Ranjan Kumar (4):
      scsi: mpi3mr: Update driver version to 8.14.0.5.50
      scsi: mpi3mr: Serialize admin queue BAR writes on 32-bit systems
      scsi: mpi3mr: Drop unnecessary volatile from __iomem pointers
      scsi: mpi3mr: Fix race between config read submit and interrupt compl=
etion

Salomon Dushimirimana (1):
      scsi: pm80xx: Add controller SCSI host fatal error uevents

Showrya M N (1):
      scsi: libiscsi: Initialize iscsi_conn->dd_data only if memory is allo=
cated

Thomas Fourier (4):
      scsi: isci: Fix dma_unmap_sg() nents value
      scsi: mvsas: Fix dma_unmap_sg() nents value
      scsi: elx: efct: Fix dma_unmap_sg() nents value
      scsi: ibmvscsi_tgt: Fix dma_unmap_sg() nents value

Thomas Wei=C3=9Fschuh (1):
      scsi: Don't use %pK through printk()

Xose Vazquez Perez (1):
      scsi: qla2xxx: Remove firmware URL

jackysliu (1):
      scsi: bfa: Double-free fix

mrigendrachaubey (1):
      scsi: scsi_devinfo: Remove redundant 'found'

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs |  83 +++++++++++++
 Documentation/scsi/scsi_fc_transport.rst   |  35 +++++-
 drivers/scsi/bfa/bfad_im.c                 |   1 +
 drivers/scsi/elx/efct/efct_lio.c           |   2 +-
 drivers/scsi/fcoe/fcoe.c                   |  22 +---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c     |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c     |   6 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c   |   2 +-
 drivers/scsi/ibmvscsi_tgt/libsrp.c         |   6 +-
 drivers/scsi/isci/request.c                |   2 +-
 drivers/scsi/libiscsi.c                    |   3 +-
 drivers/scsi/lpfc/lpfc_ct.c                |  28 ++---
 drivers/scsi/lpfc/lpfc_debugfs.c           |  20 +--
 drivers/scsi/lpfc/lpfc_els.c               |  11 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c           |  11 +-
 drivers/scsi/lpfc/lpfc_hw4.h               |  20 +--
 drivers/scsi/lpfc/lpfc_init.c              |  84 +++++++------
 drivers/scsi/lpfc/lpfc_scsi.c              |   9 +-
 drivers/scsi/lpfc/lpfc_sli.c               |  14 +--
 drivers/scsi/lpfc/lpfc_sli4.h              |   4 +-
 drivers/scsi/lpfc/lpfc_version.h           |   2 +-
 drivers/scsi/mpi3mr/mpi3mr.h               |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c           |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c            |  17 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c            |  22 +++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c         |   3 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c       |  19 +++
 drivers/scsi/mvsas/mv_sas.c                |   4 +-
 drivers/scsi/pm8001/pm8001_sas.h           |  10 ++
 drivers/scsi/pm8001/pm80xx_hwi.c           |  60 ++++++++-
 drivers/scsi/qla2xxx/Kconfig               |   6 +-
 drivers/scsi/qla2xxx/qla_dfs.c             |  20 +--
 drivers/scsi/qla2xxx/qla_gbl.h             |   1 +
 drivers/scsi/qla2xxx/qla_init.c            |   4 -
 drivers/scsi/qla2xxx/qla_mbx.c             |  48 ++++++++
 drivers/scsi/scsi.c                        |  15 +--
 drivers/scsi/scsi_debug.c                  |   2 +-
 drivers/scsi/scsi_devinfo.c                |  11 +-
 drivers/scsi/scsi_lib.c                    |   2 +-
 drivers/scsi/scsi_scan.c                   |   3 +-
 drivers/scsi/scsi_transport_fc.c           |  72 ++++++-----
 drivers/scsi/sd.c                          |  13 +-
 drivers/ufs/core/ufs-sysfs.c               | 190 +++++++++++++++++++++++++=
++++
 drivers/ufs/core/ufshcd.c                  |  71 +++++++++--
 drivers/ufs/host/ufs-exynos.c              |   4 +-
 drivers/ufs/host/ufs-qcom.c                |  24 +++-
 drivers/ufs/host/ufs-qcom.h                |   9 ++
 include/scsi/scsi_device.h                 |   5 +
 include/scsi/scsi_transport_fc.h           |   5 +-
 include/trace/events/scsi.h                |  13 +-
 include/ufs/ufs.h                          |  26 ++++
 include/ufs/ufshcd.h                       |   1 +
 52 files changed, 816 insertions(+), 255 deletions(-)

Regards,

James

