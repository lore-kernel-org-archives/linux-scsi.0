Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607D731AF1E
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 21:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768511056; cv=none; b=h/ZFNSz1+REKUi/1748SbHRPkrbKVvFTnDP2Ye4xRjrpd8HKx/63mcpPM1keq1EK98xA4u9RiBahfXozfrb/wpnV7YinF+wchPxqCzwh5Fldfvv9gvetfgrYcn7vmmTNRBEnnkdaFKwUYPig95CB2gx6dpyaIC/q54h0/5nQyJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768511056; c=relaxed/simple;
	bh=sSO8wCHgy03vVPlJKLtzChLDw1XIEpd5L1SP2g3G96E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AbSWp1NVKiAI02MFl8sX1EB6A9eXE+a3aPKqPMZtM1jjEuAg4uSiHOqjYhuX9ZC53EYGVx4thK40k72jeVpTudiTfeWnjUgaAta4/0rcPl8jW6C5yGzn/8OmY9841qkhWAgsuIX+WQDmJvaZhebapE6zSwpiire1mWPYTUUU6DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1D18U00M; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1D18U00M"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dsb7x3y9sz1XLwXB;
	Thu, 15 Jan 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1768511051; x=1771103052; bh=lIEhGV+dPAVsQhPJSkMqG8KXhjOG3wGEIQo
	ASqZXm68=; b=1D18U00Mx+UtmJRLJtvEJ7jbLYeWXtPt95saXPzYO/kFPuMFp8e
	4qfWXeNfF7DfCm0Uq8KDdipOg7pzxxCI7/RbXEZIpJaKP2I+Z9hJofKsyKzUOwRr
	JunothLEUIZgUdWfVbs4OSRHHJ7TJI6QRUTeSiMkcSF3ksPsSxHBPHkxVYDYQd3e
	FxyWpBHJsW9rxPiGevnDA6YAwdrpGcNmhbT/WS2PhDQol56W6pxpolSW5JX1TJZL
	9o+LWif4xW9/+gv006DlhKrlEBLn+ODKDEzd2jSEkevfcpyGhoQDUUgw5+WUgp6q
	TYu80vzG/3M+d0Dj5UHtWuUyD24X6F2it4Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NgC7L5T9iafd; Thu, 15 Jan 2026 21:04:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dsb7t5MPkz1XLyhS;
	Thu, 15 Jan 2026 21:04:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/5] Change the return type of the .queuecommand() callback
Date: Thu, 15 Jan 2026 13:03:36 -0800
Message-ID: <20260115210357.2501991-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Most but not all .queuecommand() implementations return a SCSI_MLQUEUE_*
constant. This affects code readability: in order to understand what happ=
ens
if a .queuecommand() function returns a value that is not a SCSI_MLQUEUE_=
*
constant, one has to read the scsi_dispatch_cmd() implementation and chec=
k
how other values are handled. Hence this patch series that changes the
return type of the .queuecommand() callback and also of the implementatio=
ns of
this callback.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
 * Included conversions for the SCSI drivers that use the DEF_SCSI_QCMD()=
 macro.
 * enum scsi_qc_status is now used in the DEF_SCSI_QCMD() implementation.
 * Declarations have been ordered from longest to shortest if a declarati=
on is
   modified.
 * The whitespace in front of "(* queuecommand)(struct Scsi_Host *," has =
been
   removed.
 * The patch description of patch 4/4 has been improved by mentioning tha=
t (at
   the time of this writing) only clang supports -Wimplicit-enum-enum-cas=
t.
 * Patches have been included that convert the aha152x, megaraid and
   megaraid_sas drivers.

Bart Van Assche (5):
  scsi: aha152x: Return SCSI_MLQUEUE_HOST_BUSY instead of 0x2003
  scsi: megaraid: Return SCSI_MLQUEUE_HOST_BUSY instead of 1
  scsi: megaraid_sas: Return SCSI_MLQUEUE_HOST_BUSY instead of 1
  qla2xxx: Declare qla2xxx_mqueuecommand() static
  scsi: Change the return type of the .queuecommand() callback

 Documentation/scsi/scsi_mid_low_api.rst   |  3 ++-
 drivers/ata/libata-scsi.c                 |  8 +++++---
 drivers/ata/libata.h                      |  3 ++-
 drivers/firewire/sbp2.c                   |  7 ++++---
 drivers/infiniband/ulp/srp/ib_srp.c       |  3 ++-
 drivers/message/fusion/mptfc.c            |  7 ++++---
 drivers/message/fusion/mptsas.c           |  4 ++--
 drivers/message/fusion/mptscsih.c         |  3 +--
 drivers/message/fusion/mptscsih.h         |  2 +-
 drivers/message/fusion/mptspi.c           |  4 ++--
 drivers/s390/scsi/zfcp_scsi.c             |  4 ++--
 drivers/scsi/3w-9xxx.c                    |  2 +-
 drivers/scsi/3w-sas.c                     |  8 +++++---
 drivers/scsi/3w-xxxx.c                    |  2 +-
 drivers/scsi/53c700.c                     |  6 +++---
 drivers/scsi/BusLogic.c                   |  2 +-
 drivers/scsi/BusLogic.h                   |  2 +-
 drivers/scsi/NCR5380.c                    |  4 ++--
 drivers/scsi/a100u2w.c                    |  2 +-
 drivers/scsi/aacraid/linit.c              |  4 ++--
 drivers/scsi/advansys.c                   |  5 +++--
 drivers/scsi/aha152x.c                    |  8 ++++----
 drivers/scsi/aha1542.c                    |  3 ++-
 drivers/scsi/aha1740.c                    |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c        | 12 ++++++------
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |  4 ++--
 drivers/scsi/arcmsr/arcmsr_hba.c          |  5 +++--
 drivers/scsi/arm/acornscsi.c              |  2 +-
 drivers/scsi/arm/fas216.c                 |  8 ++++----
 drivers/scsi/arm/fas216.h                 | 11 +++++++----
 drivers/scsi/atp870u.c                    |  2 +-
 drivers/scsi/bfa/bfad_im.c                |  5 +++--
 drivers/scsi/bnx2fc/bnx2fc.h              |  3 ++-
 drivers/scsi/bnx2fc/bnx2fc_io.c           |  4 ++--
 drivers/scsi/csiostor/csio_scsi.c         |  4 ++--
 drivers/scsi/dc395x.c                     |  2 +-
 drivers/scsi/esas2r/esas2r.h              |  3 ++-
 drivers/scsi/esas2r/esas2r_main.c         |  3 ++-
 drivers/scsi/esp_scsi.c                   |  2 +-
 drivers/scsi/fdomain.c                    |  3 ++-
 drivers/scsi/fnic/fnic.h                  |  3 ++-
 drivers/scsi/fnic/fnic_scsi.c             |  3 ++-
 drivers/scsi/hpsa.c                       |  6 ++++--
 drivers/scsi/hptiop.c                     |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            |  3 ++-
 drivers/scsi/ibmvscsi/ibmvscsi.c          |  9 +++++----
 drivers/scsi/imm.c                        |  2 +-
 drivers/scsi/initio.c                     |  2 +-
 drivers/scsi/ipr.c                        |  4 ++--
 drivers/scsi/ips.c                        |  4 ++--
 drivers/scsi/libfc/fc_fcp.c               |  3 ++-
 drivers/scsi/libiscsi.c                   |  3 ++-
 drivers/scsi/libsas/sas_scsi_host.c       |  3 ++-
 drivers/scsi/lpfc/lpfc_scsi.c             |  8 ++++----
 drivers/scsi/mac53c94.c                   |  2 +-
 drivers/scsi/megaraid.c                   | 17 +++++++++--------
 drivers/scsi/megaraid.h                   |  6 ++++--
 drivers/scsi/megaraid/megaraid_mbox.c     | 22 ++++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_base.c |  4 ++--
 drivers/scsi/mesh.c                       |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  4 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  4 ++--
 drivers/scsi/mvumi.c                      |  4 ++--
 drivers/scsi/myrb.c                       | 12 ++++++------
 drivers/scsi/myrs.c                       |  4 ++--
 drivers/scsi/ncr53c8xx.c                  |  2 +-
 drivers/scsi/nsp32.c                      |  5 +++--
 drivers/scsi/pcmcia/nsp_cs.c              |  2 +-
 drivers/scsi/pcmcia/nsp_cs.h              |  3 ++-
 drivers/scsi/pcmcia/sym53c500_cs.c        |  2 +-
 drivers/scsi/pmcraid.c                    |  4 ++--
 drivers/scsi/ppa.c                        |  2 +-
 drivers/scsi/ps3rom.c                     |  2 +-
 drivers/scsi/qedf/qedf.h                  |  4 ++--
 drivers/scsi/qedf/qedf_io.c               |  4 ++--
 drivers/scsi/qla1280.c                    | 16 ++++++++--------
 drivers/scsi/qla2xxx/qla_os.c             | 13 +++++++------
 drivers/scsi/qla4xxx/ql4_os.c             |  6 ++++--
 drivers/scsi/qlogicfas408.c               |  2 +-
 drivers/scsi/qlogicfas408.h               |  3 ++-
 drivers/scsi/qlogicpti.c                  |  2 +-
 drivers/scsi/scsi_debug.c                 |  9 +++++----
 drivers/scsi/smartpqi/smartpqi_init.c     |  3 ++-
 drivers/scsi/snic/snic.h                  |  3 ++-
 drivers/scsi/snic/snic_scsi.c             |  4 ++--
 drivers/scsi/stex.c                       |  2 +-
 drivers/scsi/storvsc_drv.c                |  3 ++-
 drivers/scsi/sym53c8xx_2/sym_glue.c       |  2 +-
 drivers/scsi/virtio_scsi.c                |  4 ++--
 drivers/scsi/vmw_pvscsi.c                 |  2 +-
 drivers/scsi/wd33c93.c                    |  2 +-
 drivers/scsi/wd33c93.h                    |  3 ++-
 drivers/scsi/wd719x.c                     |  3 ++-
 drivers/scsi/xen-scsifront.c              |  4 ++--
 drivers/target/loopback/tcm_loop.c        |  3 ++-
 drivers/ufs/core/ufshcd.c                 |  7 ++++---
 drivers/usb/image/microtek.c              |  6 +++---
 drivers/usb/storage/scsiglue.c            |  2 +-
 drivers/usb/storage/uas.c                 |  2 +-
 include/linux/libata.h                    |  3 ++-
 include/scsi/libfc.h                      |  3 ++-
 include/scsi/libiscsi.h                   |  3 ++-
 include/scsi/libsas.h                     |  3 ++-
 include/scsi/scsi_host.h                  | 12 ++++++++----
 104 files changed, 261 insertions(+), 206 deletions(-)

