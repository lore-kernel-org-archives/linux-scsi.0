Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A638F1991D2
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 20:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727591; cv=none; b=ffQFKfeUMqb2s1mPUr8SlKCjMIXOv7ED1X9nUHVeO+g4cqsydUJuoXjzEkgQif1z4fFzSKxgUFNgSI72h6p71SrQB4vHmIqfliVx9RVpZyGYDiWnaR9H3qNJBEcY25WLIpJVHdFJhnPFnAR0stCKEEArsy92IoCoZuSJVhIHuuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727591; c=relaxed/simple;
	bh=nQAvc38T/p/mRYlkiPEfb5h05pOZ6fX6VRv8vJCMG1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sOCzlk5Q++8oXuu3fLgudNOvlfAxcMwXIF00AioioY21KrYSBaFTpQyTJrmTYx496TrKnC4u7ckyM0JgUHfGPwAnUBYTB/43aDJsJNmcXbFOpa3Get+QasiVPLTtapXxujRSVx5xQf4u2zidiNMpRQeusHfnxHeLJwuqvhFqBoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g3HFEPiI; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g3HFEPiI"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XHXVY18C4z6ClY9Y;
	Mon, 30 Sep 2024 20:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1727727586; x=1730319587; bh=EAPW7fNzMiv8KckZwgQbUAj0kTMDX9cpOB9
	csDiUGS8=; b=g3HFEPiIFZg4Y+9Op5j/Vd1Ci9PfU78Q36gSUn/ZRsqZPzJogT6
	eg2tFzkx8ejxgOj7O2k+eC6DmVn9jYe1CjiMaMFc6ZYnMLR8WzCkrXvPUAyOWvML
	8Ho96S9bJHE9F8zR5LlSVPDuUxNwdvhNtIw3qLWF8ZymPPjpIkVx8g049+LMpCet
	7ISLtrdKcZLhMPnXk50p4O/m+rj1kya6LpXCIip2hMXIt3hZiibZxv0CdZX3l9rC
	EwHXZSVTQg8iT+RJXNQPQ5D2dzLe52gb8DIaLMyN/cn5cpmd2SaIuWrDF3ECSapW
	wqIfS8ap+rZ+jzCtBrZ+pzBsYY7d8L0sZrA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rU5BZ0rEt3Fp; Mon, 30 Sep 2024 20:19:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XHXVT75KVz6ClY9V;
	Mon, 30 Sep 2024 20:19:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Do not use "slave" in function names
Date: Mon, 30 Sep 2024 13:18:46 -0700
Message-ID: <20240930201937.2020129-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

There is agreement that the word "slave" should not be used in Linux kern=
el
source code. Hence this patch series that renames all SCSI functions that
have the word "slave" in their function name. Please consider this patch
series for the next merge window.

Thanks,

Bart.

Bart Van Assche (4):
  scsi: Rename .slave_alloc() and .slave_destroy()
  scsi: Convert SCSI drivers to .device_configure()
  scsi: core: Remove .slave_configure()
  scsi: core: Update .slave_configure() references in the documentation

 Documentation/scsi/scsi_mid_low_api.rst     | 79 +++++++++++----------
 drivers/ata/libata-scsi.c                   | 12 ++--
 drivers/firewire/sbp2.c                     |  4 +-
 drivers/infiniband/ulp/srp/ib_srp.c         |  5 +-
 drivers/message/fusion/mptfc.c              | 14 ++--
 drivers/message/fusion/mptsas.c             | 14 ++--
 drivers/message/fusion/mptscsih.c           | 10 +--
 drivers/message/fusion/mptscsih.h           |  5 +-
 drivers/message/fusion/mptspi.c             | 19 ++---
 drivers/net/ethernet/allwinner/sun4i-emac.c |  4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c   | 12 ++--
 drivers/s390/scsi/zfcp_scsi.c               | 15 ++--
 drivers/s390/scsi/zfcp_sysfs.c              |  2 +-
 drivers/s390/scsi/zfcp_unit.c               |  2 +-
 drivers/scsi/3w-9xxx.c                      |  7 +-
 drivers/scsi/3w-sas.c                       |  7 +-
 drivers/scsi/3w-xxxx.c                      |  9 +--
 drivers/scsi/53c700.c                       | 19 ++---
 drivers/scsi/BusLogic.c                     |  7 +-
 drivers/scsi/BusLogic.h                     |  3 +-
 drivers/scsi/aacraid/linit.c                |  8 ++-
 drivers/scsi/advansys.c                     | 23 +++---
 drivers/scsi/aic7xxx/aic79xx_osm.c          |  8 +--
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |  8 +--
 drivers/scsi/arcmsr/arcmsr_hba.c            |  8 ++-
 drivers/scsi/bfa/bfad_im.c                  | 26 +++----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |  7 +-
 drivers/scsi/csiostor/csio_scsi.c           | 18 ++---
 drivers/scsi/dc395x.c                       | 12 ++--
 drivers/scsi/esp_scsi.c                     | 15 ++--
 drivers/scsi/fcoe/fcoe.c                    |  2 +-
 drivers/scsi/fnic/fnic_main.c               |  4 +-
 drivers/scsi/hisi_sas/hisi_sas.h            |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  6 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c      |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  2 +-
 drivers/scsi/hpsa.c                         | 20 +++---
 drivers/scsi/ibmvscsi/ibmvfc.c              | 13 ++--
 drivers/scsi/ibmvscsi/ibmvscsi.c            |  8 ++-
 drivers/scsi/ipr.c                          | 12 ++--
 drivers/scsi/ips.c                          |  6 +-
 drivers/scsi/ips.h                          |  3 +-
 drivers/scsi/libfc/fc_fcp.c                 |  6 +-
 drivers/scsi/libsas/sas_scsi_host.c         |  4 +-
 drivers/scsi/lpfc/lpfc_scsi.c               | 37 ++++++----
 drivers/scsi/megaraid/megaraid_sas_base.c   |  8 +--
 drivers/scsi/mpi3mr/mpi3mr_os.c             | 12 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 16 ++---
 drivers/scsi/mvumi.c                        |  5 +-
 drivers/scsi/myrb.c                         | 21 +++---
 drivers/scsi/myrs.c                         | 13 ++--
 drivers/scsi/ncr53c8xx.c                    |  9 +--
 drivers/scsi/pmcraid.c                      | 14 ++--
 drivers/scsi/ps3rom.c                       |  5 +-
 drivers/scsi/qedf/qedf_main.c               |  5 +-
 drivers/scsi/qla1280.c                      |  6 +-
 drivers/scsi/qla2xxx/qla_os.c               | 12 ++--
 drivers/scsi/qla4xxx/ql4_os.c               |  6 +-
 drivers/scsi/qlogicpti.c                    |  5 +-
 drivers/scsi/scsi_debug.c                   | 19 ++---
 drivers/scsi/scsi_scan.c                    | 14 ++--
 drivers/scsi/scsi_sysfs.c                   |  4 +-
 drivers/scsi/smartpqi/smartpqi_init.c       | 13 ++--
 drivers/scsi/snic/snic_main.c               | 12 ++--
 drivers/scsi/stex.c                         |  4 +-
 drivers/scsi/storvsc_drv.c                  |  7 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         | 15 ++--
 drivers/scsi/virtio_scsi.c                  |  2 +-
 drivers/scsi/xen-scsifront.c                | 11 +--
 drivers/staging/rts5208/rtsx.c              |  8 +--
 drivers/ufs/core/ufshcd.c                   | 12 ++--
 drivers/usb/image/microtek.c                |  4 +-
 drivers/usb/storage/scsiglue.c              |  6 +-
 drivers/usb/storage/uas.c                   |  4 +-
 include/linux/libata.h                      |  8 +--
 include/scsi/libfc.h                        |  2 +-
 include/scsi/libsas.h                       |  4 +-
 include/scsi/scsi_device.h                  |  4 +-
 include/scsi/scsi_host.h                    | 22 +++---
 80 files changed, 430 insertions(+), 393 deletions(-)

