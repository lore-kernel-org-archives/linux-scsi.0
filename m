Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F304781720
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 20:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727901337; cv=none; b=GDTN9ScdjZAVvz3fL4LHw+01faUgwavfdSmveHtZurWnPua1/WD9sdnGujx4iW8bcvFEjgyOk/TdaoYhVsISD5IfaQ2rkr0bQigbZefnBVwuQjQs51ZmHx5FGwWTPzGomps8lpe+c8WX/ZDrlRgiy8cieSZL2nHmYEjSSK1nfv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727901337; c=relaxed/simple;
	bh=5nWwdX8q9dzqx0TNZyyC/qwJ2yK47vwUNpkCUVI0arw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o/o5/N9WP6tzW3pPmRO8/YijcMnZaum6UrNIsVNnvz/7qZwWPji6sIEyjul/LMYiCB2W9B+N2JoQH6IKWESAcdVOL/JvgT3uMXN7U7lPUMwYdb5KRB165lIosHZz5rwQvrGPBfQHoX4UW8MSQLmNWtgi4IBv+dmHJzozQ3C8Jp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uDwhsx3C; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uDwhsx3C"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJmlq30FmzlgMWB;
	Wed,  2 Oct 2024 20:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1727901333; x=1730493334; bh=v4SGfWqevfFYq9omU+GAx/23iJXXEOAA+XC
	BJw9FUM4=; b=uDwhsx3C0/OCvhdIQOKt/DNBSiPq2JQon0sOd48RJyToV7kJtOw
	dtF0LYZKENDCKzziQpf9ZlolBfExKg/J+Bkfmdbd4bGrN5XaRxqCmyJdaYFkSPb1
	sq+UEqO8pUHSIjH22gYZk8aXRxB6u7MNJDBmFsmln1R8NpNGqHgn/5G5Fdi6qPB0
	UnqOlhEs9oQp5tz8uuoR9jFfqzMXya+zk+iLZkb5HZX9PJeJEsFIbw3mmyIT4taU
	uXUrxks88Rwdv8BR7LbvkooDg61LQYwcLrgAN0dCVrXD+j7M8Mqfu/7Wc96ms4zq
	UugDBxWTmBdY9dlG0EiFPvkLItWi86ueSOA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fK3rl3RxjBa9; Wed,  2 Oct 2024 20:35:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJmlm6VdwzlgMVy;
	Wed,  2 Oct 2024 20:35:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/11] Improve the "slave" function names
Date: Wed,  2 Oct 2024 13:33:52 -0700
Message-ID: <20241002203528.4104996-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

The text "slave_" in multiple function names does not make it clear what
the purpose of these functions is. Hence this patch series that renames a=
ll
SCSI functions that have the word "slave" in their function name. Please
consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
 - Switch to the names proposed by Matthew Wilcox.
 - Included a patch that renames .device_configure() into .sdev_configure=
().
 - Split off the documentation changes into a separate patch as requested=
 by
   Damien.
 - Added 5 patches that remove obsolete SCSI LLD changelog files.

Bart Van Assche (11):
  scsi: arcmsr: Remove the changelog
  scsi: ips: Remove the changelog
  scsi: lpfc: Remove the changelog
  scsi: ncr53c8xx: Remove the changelog
  scsi: sym53c8xx: Remove the changelog
  scsi: Rename .slave_alloc() and .slave_destroy()
  scsi: core: Rename .slave_alloc() and .slave_destroy() in the
    documentation
  scsi: Rename .device_configure() into .sdev_configure()
  scsi: Convert SCSI drivers to .sdev_configure()
  scsi: core: Remove the .slave_configure() method
  scsi: core: Update .slave_configure() references in the documentation

 Documentation/scsi/ChangeLog.arcmsr       |  118 --
 Documentation/scsi/ChangeLog.ips          |  122 --
 Documentation/scsi/ChangeLog.lpfc         | 1865 ---------------------
 Documentation/scsi/ChangeLog.ncr53c8xx    |  495 ------
 Documentation/scsi/ChangeLog.sym53c8xx    |  593 -------
 Documentation/scsi/ChangeLog.sym53c8xx_2  |  144 --
 Documentation/scsi/scsi_mid_low_api.rst   |   78 +-
 drivers/ata/ahci.h                        |    2 +-
 drivers/ata/libata-sata.c                 |    8 +-
 drivers/ata/libata-scsi.c                 |   19 +-
 drivers/ata/pata_macio.c                  |    8 +-
 drivers/ata/sata_mv.c                     |    2 +-
 drivers/ata/sata_nv.c                     |   24 +-
 drivers/ata/sata_sil24.c                  |    2 +-
 drivers/firewire/sbp2.c                   |   10 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |    5 +-
 drivers/message/fusion/mptfc.c            |   14 +-
 drivers/message/fusion/mptsas.c           |   14 +-
 drivers/message/fusion/mptscsih.c         |   10 +-
 drivers/message/fusion/mptscsih.h         |    5 +-
 drivers/message/fusion/mptspi.c           |   19 +-
 drivers/s390/scsi/zfcp_scsi.c             |   15 +-
 drivers/s390/scsi/zfcp_sysfs.c            |    2 +-
 drivers/s390/scsi/zfcp_unit.c             |    2 +-
 drivers/scsi/3w-9xxx.c                    |    7 +-
 drivers/scsi/3w-sas.c                     |    7 +-
 drivers/scsi/3w-xxxx.c                    |    8 +-
 drivers/scsi/53c700.c                     |   19 +-
 drivers/scsi/BusLogic.c                   |    7 +-
 drivers/scsi/BusLogic.h                   |    3 +-
 drivers/scsi/aacraid/linit.c              |    8 +-
 drivers/scsi/advansys.c                   |   23 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c        |    8 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |    8 +-
 drivers/scsi/arcmsr/arcmsr_hba.c          |    8 +-
 drivers/scsi/bfa/bfad_im.c                |   26 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |    7 +-
 drivers/scsi/csiostor/csio_scsi.c         |   18 +-
 drivers/scsi/dc395x.c                     |   12 +-
 drivers/scsi/esp_scsi.c                   |   14 +-
 drivers/scsi/fcoe/fcoe.c                  |    2 +-
 drivers/scsi/fnic/fnic_main.c             |    4 +-
 drivers/scsi/hisi_sas/hisi_sas.h          |    5 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c     |   13 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |   10 +-
 drivers/scsi/hpsa.c                       |   20 +-
 drivers/scsi/hptiop.c                     |    6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            |   13 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c          |    8 +-
 drivers/scsi/ipr.c                        |   20 +-
 drivers/scsi/ips.c                        |    6 +-
 drivers/scsi/ips.h                        |    3 +-
 drivers/scsi/iscsi_tcp.c                  |    6 +-
 drivers/scsi/libfc/fc_fcp.c               |    6 +-
 drivers/scsi/libsas/sas_scsi_host.c       |   11 +-
 drivers/scsi/lpfc/lpfc_scsi.c             |   37 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |   14 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |   20 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |   24 +-
 drivers/scsi/mvumi.c                      |    5 +-
 drivers/scsi/myrb.c                       |   21 +-
 drivers/scsi/myrs.c                       |   13 +-
 drivers/scsi/ncr53c8xx.c                  |    9 +-
 drivers/scsi/pmcraid.c                    |   22 +-
 drivers/scsi/ps3rom.c                     |    5 +-
 drivers/scsi/qedf/qedf_main.c             |    5 +-
 drivers/scsi/qla1280.c                    |    6 +-
 drivers/scsi/qla2xxx/qla_os.c             |   12 +-
 drivers/scsi/qla4xxx/ql4_os.c             |    6 +-
 drivers/scsi/qlogicpti.c                  |    5 +-
 drivers/scsi/scsi_debug.c                 |   19 +-
 drivers/scsi/scsi_scan.c                  |   22 +-
 drivers/scsi/scsi_sysfs.c                 |    4 +-
 drivers/scsi/smartpqi/smartpqi_init.c     |   13 +-
 drivers/scsi/snic/snic_main.c             |   12 +-
 drivers/scsi/stex.c                       |    4 +-
 drivers/scsi/storvsc_drv.c                |    7 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       |   15 +-
 drivers/scsi/virtio_scsi.c                |    2 +-
 drivers/scsi/xen-scsifront.c              |   11 +-
 drivers/staging/rts5208/rtsx.c            |    8 +-
 drivers/ufs/core/ufshcd.c                 |   20 +-
 drivers/usb/image/microtek.c              |    4 +-
 drivers/usb/storage/scsiglue.c            |   10 +-
 drivers/usb/storage/uas.c                 |   10 +-
 include/linux/libata.h                    |   19 +-
 include/scsi/libfc.h                      |    2 +-
 include/scsi/libsas.h                     |    9 +-
 include/scsi/scsi_device.h                |    4 +-
 include/scsi/scsi_host.h                  |   24 +-
 92 files changed, 507 insertions(+), 3816 deletions(-)
 delete mode 100644 Documentation/scsi/ChangeLog.arcmsr
 delete mode 100644 Documentation/scsi/ChangeLog.ips
 delete mode 100644 Documentation/scsi/ChangeLog.lpfc
 delete mode 100644 Documentation/scsi/ChangeLog.ncr53c8xx
 delete mode 100644 Documentation/scsi/ChangeLog.sym53c8xx
 delete mode 100644 Documentation/scsi/ChangeLog.sym53c8xx_2

