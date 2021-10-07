Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5CFC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA69610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhJGVUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:20:55 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:39684 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbhJGVUz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:20:55 -0400
Received: by mail-pj1-f49.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso7430247pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HpUoZ8YGYZCcc4PTz0iGAzdpSy60JKgc/r67Lfn/QuY=;
        b=ZNcFAkWdHRLmivjVE5p0VKP29oX5Pni2s8bJFKfyj22qwdrNbC9UEkm3gle6IDLYE3
         RNF9qGKR2dsHa7GHaPdBafqafJ6tIlqoG3bleK8fhA/+8NTUiai9x/53CvQZMKhAGQBq
         CMvNjdIXIox/eMK7+Oa9GeHQX4ob8FmSjq2URSWo6iDycShQg+4kLm0SmtfxXn8X6SyY
         O0Z2n8VIFYxXOGb58mAcQU88ykabvfP1EROu/ASc+YfAR/1GkTTyoRL6q0pIOes0qFbF
         XpVjfce8ht/xOrW4bh0Wmt2ovKfQ2pILm3Uf0e89fE66axMa5C6oeXvVp2CeqHLQPjnm
         duvg==
X-Gm-Message-State: AOAM530sd2RTcL9j7tq18JX7EiFVymneVPXKDy2YGO4/ciALHNHM2+V5
        6j4F6LDPHHWJjTLgStM5K3M=
X-Google-Smtp-Source: ABdhPJwKMk/GEkZEgNfEIPZMiFuDp3cElaQXOITISNw8Rdrtk68JpPqaqYEviaaAyu9pTCrp4Nuopg==
X-Received: by 2002:a17:90b:17d0:: with SMTP id me16mr8115444pjb.152.1633641540797;
        Thu, 07 Oct 2021 14:19:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:18:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/46] Register SCSI sysfs attributes earlier
Date:   Thu,  7 Oct 2021 14:18:06 -0700
Message-Id: <20211007211852.256007-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

For certain user space software, e.g. udev, it is important that sysfs
attributes are registered before the KOBJ_ADD uevent is emitted. Hence
this patch series that removes the device_create_file() and
sysfs_create_groups() calls from the SCSI core. Please consider this
patch series for kernel v5.16.

Thanks,

Bart.

Changes compared to v1:
- Switched from struct attribute ** to struct attribute_group **.
- Added comments that explain how the size of the new arrays have been chosen.
- Cleaned up the code in the qla2xxx driver that modifies a struct
  device_attribute array by introducing an .is_visible() callback.
- Split this patch series into one patch per driver.

Bart Van Assche (46):
  scsi: core: Register sysfs attributes earlier
  ata: Switch to attribute groups
  firewire: sbp2: Switch to attribute groups
  RDMA/srp: Switch to attribute groups
  scsi: message: fusion: Switch to attribute groups
  scsi: zfcp: Switch to attribute groups
  scsi: 3w-9xxx: Switch to attribute groups
  scsi: 3w-sas: Switch to attribute groups
  scsi: 3w-xxxx: Switch to attribute groups
  scsi: 53c700: Switch to attribute groups
  scsi: aacraid: Switch to attribute groups
  scsi: arcmsr: Switch to attribute groups
  scsi: be2iscsi: Switch to attribute groups
  scsi: bfa: Switch to attribute groups
  scsi: bnx2fc: Switch to attribute groups
  scsi: bnx2i: Switch to attribute groups
  scsi: csiostor: Switch to attribute groups
  scsi: cxlflash: Switch to attribute groups
  scsi: fnic: Switch to attribute groups
  scsi: hisi_sas: Switch to attribute groups
  scsi: hpsa: Switch to attribute groups
  scsi: hptiop: Switch to attribute groups
  scsi: ibmvscsi: Switch to attribute groups
  scsi: ibmvfc: Switch to attribute groups
  scsi: ipr: Switch to attribute groups
  scsi: isci: Switch to attribute groups
  scsi: lpfc: Switch to attribute groups
  scsi: megaraid: Switch to attribute groups
  scsi: mpt3sas: Switch to attribute groups
  scsi: mvsas: Switch to attribute groups
  scsi: myrb: Switch to attribute groups
  scsi: myrs: Switch to attribute groups
  scsi: ncr53c8xx: Switch to attribute groups
  scsi: sym53c500_cs: Switch to attribute groups
  scsi: pm8001: Switch to attribute groups
  scsi: pmcraid: Switch to attribute groups
  scsi: qedf: Switch to attribute groups
  scsi: qedi: Switch to attribute groups
  scsi: qla2xxx: Remove a declaration
  scsi: qla2xxx: Switch to attribute groups
  scsi: qla4xxx: Switch to attribute groups
  scsi: smartpqi: Switch to attribute groups
  scsi: snic: Switch to attribute groups
  scsi: unisys: Remove the shost_attrs member
  scsi: usb: Switch to attribute groups
  scsi: core: Remove two host template members that are no longer used

 drivers/ata/ahci.h                            |   8 +-
 drivers/ata/ata_piix.c                        |  15 +-
 drivers/ata/libahci.c                         |  52 ++-
 drivers/ata/libata-sata.c                     |  19 +-
 drivers/ata/libata-scsi.c                     |  15 +-
 drivers/ata/pata_macio.c                      |   2 +-
 drivers/ata/sata_mv.c                         |   2 +-
 drivers/ata/sata_nv.c                         |   4 +-
 drivers/ata/sata_sil24.c                      |   2 +-
 drivers/firewire/sbp2.c                       |  15 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |  58 ++--
 drivers/message/fusion/mptfc.c                |   2 +-
 drivers/message/fusion/mptsas.c               |   2 +-
 drivers/message/fusion/mptscsih.c             |  36 +-
 drivers/message/fusion/mptscsih.h             |   2 +-
 drivers/message/fusion/mptspi.c               |   2 +-
 drivers/s390/scsi/zfcp_ext.h                  |   4 +-
 drivers/s390/scsi/zfcp_scsi.c                 |   4 +-
 drivers/s390/scsi/zfcp_sysfs.c                |  52 ++-
 drivers/scsi/3w-9xxx.c                        |  15 +-
 drivers/scsi/3w-sas.c                         |  15 +-
 drivers/scsi/3w-xxxx.c                        |  15 +-
 drivers/scsi/53c700.c                         |  19 +-
 drivers/scsi/aacraid/linit.c                  |  52 ++-
 drivers/scsi/arcmsr/arcmsr.h                  |   2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c             |  33 +-
 drivers/scsi/arcmsr/arcmsr_hba.c              |   2 +-
 drivers/scsi/be2iscsi/be_main.c               |  28 +-
 drivers/scsi/bfa/bfad_attr.c                  |  68 ++--
 drivers/scsi/bfa/bfad_im.c                    |   4 +-
 drivers/scsi/bfa/bfad_im.h                    |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c             |  15 +-
 drivers/scsi/bnx2i/bnx2i.h                    |   2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c              |   2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c              |  15 +-
 drivers/scsi/csiostor/csio_scsi.c             |  38 ++-
 drivers/scsi/cxlflash/main.c                  |  54 ++-
 drivers/scsi/fnic/fnic.h                      |   2 +-
 drivers/scsi/fnic/fnic_attrs.c                |  17 +-
 drivers/scsi/fnic/fnic_main.c                 |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c        |  15 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c        |  15 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c        |  21 +-
 drivers/scsi/hosts.c                          |  14 +-
 drivers/scsi/hpsa.c                           |  58 ++--
 drivers/scsi/hptiop.c                         |  17 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |  29 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  29 +-
 drivers/scsi/ipr.c                            |  52 ++-
 drivers/scsi/isci/init.c                      |  15 +-
 drivers/scsi/lpfc/lpfc_attr.c                 | 314 +++++++++---------
 drivers/scsi/lpfc/lpfc_crtn.h                 |   4 +-
 drivers/scsi/lpfc/lpfc_init.c                 |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                 |   4 +-
 drivers/scsi/megaraid/megaraid_mbox.c         |  29 +-
 drivers/scsi/megaraid/megaraid_sas_base.c     |  31 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h           |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c            |  84 +++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |   8 +-
 drivers/scsi/mvsas/mv_init.c                  |  19 +-
 drivers/scsi/myrb.c                           |  42 ++-
 drivers/scsi/myrs.c                           |  54 ++-
 drivers/scsi/ncr53c8xx.c                      |  17 +-
 drivers/scsi/pcmcia/sym53c500_cs.c            |  15 +-
 drivers/scsi/pm8001/pm8001_ctl.c              |  64 ++--
 drivers/scsi/pm8001/pm8001_init.c             |   2 +-
 drivers/scsi/pm8001/pm8001_sas.h              |   2 +-
 drivers/scsi/pmcraid.c                        |  18 +-
 drivers/scsi/qedf/qedf.h                      |   2 +-
 drivers/scsi/qedf/qedf_attr.c                 |  15 +-
 drivers/scsi/qedf/qedf_main.c                 |   2 +-
 drivers/scsi/qedi/qedi_gbl.h                  |   2 +-
 drivers/scsi/qedi/qedi_iscsi.c                |   2 +-
 drivers/scsi/qedi/qedi_sysfs.c                |  15 +-
 drivers/scsi/qla2xxx/qla_attr.c               | 118 +++----
 drivers/scsi/qla2xxx/qla_gbl.h                |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                 |   5 +-
 drivers/scsi/qla4xxx/ql4_attr.c               |  41 ++-
 drivers/scsi/qla4xxx/ql4_glbl.h               |   3 +-
 drivers/scsi/qla4xxx/ql4_os.c                 |   2 +-
 drivers/scsi/scsi_priv.h                      |   2 +-
 drivers/scsi/scsi_sysfs.c                     |  53 +--
 drivers/scsi/smartpqi/smartpqi_init.c         |  60 ++--
 drivers/scsi/snic/snic.h                      |   2 +-
 drivers/scsi/snic/snic_attrs.c                |  19 +-
 drivers/scsi/snic/snic_main.c                 |   2 +-
 .../staging/unisys/visorhba/visorhba_main.c   |   1 -
 drivers/usb/storage/scsiglue.c                |  15 +-
 include/linux/libata.h                        |   8 +-
 include/scsi/scsi_device.h                    |   6 +
 include/scsi/scsi_host.h                      |  15 +-
 91 files changed, 1305 insertions(+), 767 deletions(-)

