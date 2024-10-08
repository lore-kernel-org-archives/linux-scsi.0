Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752F1137C2A
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 20:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728420709; cv=none; b=orCSjE/ktuM6cCWExgEpxrCm7ffy+Ni6AeARZo/6jVjsuHp8AMQm7jXvI/rYi2XTOwI9NvbE/k3wi0AuJvyVFnzGMZCwOrhbI5X84BK9NISBE5Cx18xB2r3ONjtzB3jZC0UxcHY9cwEpyMGZEJkbZsf8EvbvUC7B0YFMcH/Qq0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728420709; c=relaxed/simple;
	bh=cr1HKgEw2DgYAXTsbrRbtiBLbGe+dTtds8R8uTfThSw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MJAU5flKe2mhHZyB2GKiLlj5rerch/t2WzlOC4HuXiLvIznSjwanfZ9EIltN5Oa3zYx0ymOGAJz0eUPAfYK5lv038iWwH3cJpwu+YysWHrIMh7S94xDg/tE07/iaywebgr85XrLzfe0zjc2JOwWy7Zc3zzogVTTywerbG5OuELw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XUZHIp2A; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XUZHIp2A"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XNSqk5Yl1zlgTWP;
	Tue,  8 Oct 2024 20:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1728420704; x=1731012705; bh=eCAF41kZM7Uz1xOl8LTLGiqQ/cmJCgFIDyv
	7cCsR2WE=; b=XUZHIp2AGFFGkexYMzW4wA38jrM2NbjpbQCFws8AQW+bTPAgGTY
	d77FAqJsqiGkLCkCljH1Xy1Pqs5zda8tlNKwlbJ7wrzZ0NjJl3MfLR0mu3MM3bJC
	HBGmGokuhG7A+ENBTWtoHbv9FPBcFFT3pzfvO4adzr1Ftb44nBnUt87jJbR6J/1q
	yq20EnrkHyHOYh1uIvh2W+gHwKNI8otOAspWxGmlqAsOOaHnsLVY2D8sDBJeW7s3
	QeXTFUnVnjZOx7ieyaOQ2ueepV8yFLTefQprdez4LwzS7pBjTcI65d5R9S8z72y0
	LNGvYOfrylYqA5gsQFXw3muWOh3NMiX0ndg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FfopkuKooP6H; Tue,  8 Oct 2024 20:51:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XNSqh2yBnzlgTWK;
	Tue,  8 Oct 2024 20:51:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/6] Replace the "slave_*" function names
Date: Tue,  8 Oct 2024 13:50:46 -0700
Message-ID: <20241008205139.3743722-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
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

Changes compared to v2:
 - Renamed sdev_prep() into sdev_init().
 - Dropped the patches again that remove SCSI LLD changelog files.

Changes compared to v1:
 - Switch to the names proposed by Matthew Wilcox.
 - Included a patch that renames .device_configure() into .sdev_configure=
().
 - Split off the documentation changes into a separate patch as requested=
 by
   Damien.
 - Added 5 patches that remove obsolete SCSI LLD changelog files.

Bart Van Assche (6):
  scsi: Rename .slave_alloc() and .slave_destroy()
  scsi: core: Rename .slave_alloc() and .slave_destroy() in the
    documentation
  scsi: Rename .device_configure() into .sdev_configure()
  scsi: Convert SCSI drivers to .sdev_configure()
  scsi: core: Remove the .slave_configure() method
  scsi: core: Update .slave_configure() references in the documentation

 Documentation/scsi/scsi_mid_low_api.rst   | 78 +++++++++++------------
 drivers/ata/ahci.h                        |  2 +-
 drivers/ata/libata-sata.c                 |  8 +--
 drivers/ata/libata-scsi.c                 | 19 +++---
 drivers/ata/pata_macio.c                  |  8 +--
 drivers/ata/sata_mv.c                     |  2 +-
 drivers/ata/sata_nv.c                     | 24 +++----
 drivers/ata/sata_sil24.c                  |  2 +-
 drivers/firewire/sbp2.c                   | 10 +--
 drivers/infiniband/ulp/srp/ib_srp.c       |  5 +-
 drivers/message/fusion/mptfc.c            | 14 ++--
 drivers/message/fusion/mptsas.c           | 14 ++--
 drivers/message/fusion/mptscsih.c         | 10 +--
 drivers/message/fusion/mptscsih.h         |  5 +-
 drivers/message/fusion/mptspi.c           | 19 +++---
 drivers/s390/scsi/zfcp_scsi.c             | 15 +++--
 drivers/s390/scsi/zfcp_sysfs.c            |  2 +-
 drivers/s390/scsi/zfcp_unit.c             |  2 +-
 drivers/scsi/3w-9xxx.c                    |  7 +-
 drivers/scsi/3w-sas.c                     |  7 +-
 drivers/scsi/3w-xxxx.c                    |  8 +--
 drivers/scsi/53c700.c                     | 19 +++---
 drivers/scsi/BusLogic.c                   |  7 +-
 drivers/scsi/BusLogic.h                   |  3 +-
 drivers/scsi/aacraid/linit.c              |  8 ++-
 drivers/scsi/advansys.c                   | 23 +++----
 drivers/scsi/aic7xxx/aic79xx_osm.c        |  8 +--
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |  8 +--
 drivers/scsi/arcmsr/arcmsr_hba.c          |  8 ++-
 drivers/scsi/bfa/bfad_im.c                | 26 ++++----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |  7 +-
 drivers/scsi/csiostor/csio_scsi.c         | 18 +++---
 drivers/scsi/dc395x.c                     | 12 ++--
 drivers/scsi/esp_scsi.c                   | 14 ++--
 drivers/scsi/fcoe/fcoe.c                  |  2 +-
 drivers/scsi/fnic/fnic_main.c             |  4 +-
 drivers/scsi/hisi_sas/hisi_sas.h          |  5 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c     | 13 ++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 10 +--
 drivers/scsi/hpsa.c                       | 20 +++---
 drivers/scsi/hptiop.c                     |  6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            | 14 ++--
 drivers/scsi/ibmvscsi/ibmvscsi.c          |  8 ++-
 drivers/scsi/ipr.c                        | 20 +++---
 drivers/scsi/ips.c                        |  6 +-
 drivers/scsi/ips.h                        |  3 +-
 drivers/scsi/iscsi_tcp.c                  |  6 +-
 drivers/scsi/libfc/fc_fcp.c               |  6 +-
 drivers/scsi/libsas/sas_scsi_host.c       | 11 ++--
 drivers/scsi/lpfc/lpfc_scsi.c             | 37 ++++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c | 14 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 20 +++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 24 +++----
 drivers/scsi/mvumi.c                      |  5 +-
 drivers/scsi/myrb.c                       | 21 +++---
 drivers/scsi/myrs.c                       | 13 ++--
 drivers/scsi/ncr53c8xx.c                  |  9 +--
 drivers/scsi/pmcraid.c                    | 22 +++----
 drivers/scsi/ps3rom.c                     |  5 +-
 drivers/scsi/qedf/qedf_main.c             |  5 +-
 drivers/scsi/qla1280.c                    |  6 +-
 drivers/scsi/qla2xxx/qla_os.c             | 12 ++--
 drivers/scsi/qla4xxx/ql4_os.c             |  6 +-
 drivers/scsi/qlogicpti.c                  |  5 +-
 drivers/scsi/scsi_debug.c                 | 19 +++---
 drivers/scsi/scsi_scan.c                  | 22 +++----
 drivers/scsi/scsi_sysfs.c                 |  4 +-
 drivers/scsi/smartpqi/smartpqi_init.c     | 13 ++--
 drivers/scsi/snic/snic_main.c             | 12 ++--
 drivers/scsi/stex.c                       |  4 +-
 drivers/scsi/storvsc_drv.c                |  7 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       | 15 +++--
 drivers/scsi/virtio_scsi.c                |  2 +-
 drivers/scsi/xen-scsifront.c              | 11 ++--
 drivers/staging/rts5208/rtsx.c            |  8 +--
 drivers/ufs/core/ufshcd.c                 | 20 +++---
 drivers/usb/image/microtek.c              |  4 +-
 drivers/usb/storage/scsiglue.c            | 10 +--
 drivers/usb/storage/uas.c                 | 10 +--
 include/linux/libata.h                    | 19 +++---
 include/scsi/libfc.h                      |  2 +-
 include/scsi/libsas.h                     |  9 ++-
 include/scsi/scsi_device.h                |  4 +-
 include/scsi/scsi_host.h                  | 24 +++----
 86 files changed, 508 insertions(+), 479 deletions(-)

