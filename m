Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB11BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FDE060F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhJLXiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:10 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:35808 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbhJLXiJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:09 -0400
Received: by mail-pl1-f176.google.com with SMTP id w14so583290pll.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtfGmwg77xk5Af2lAWW2NB3ZwIQbap9dFvwjvJvlE6Y=;
        b=5+SnHF1butih7yk6PO29ut+8bcCnozsmsZy14CEqHrqOPMM1oFGeI8HIxyb9in+vAd
         7HllJwZxrmOkizJ8eL2AQg+9mEzQbtuyU6rnZuf+F9qf5XWKkdE2Su33mVOx1EgyOBod
         uJtQaOYCNcpCpjLBzBH/51Z3fTfumjdDWBuGVSbF6Qq2Fpd034/CCkz309ghEcVx4y52
         vsx4d1VNcnrPo0qweowViQU5lZh7pHBxq4nri7oCRKm0e+f1nM8csSLI2KIW/qFXV/Je
         zPTSWrGyMsR3Df1GMJ1Xy6wmUtlK1KSPCfEXTjL8ihYdfd20geFz/sND3XLIAAQ6NuIx
         dmaA==
X-Gm-Message-State: AOAM533/HDc/VsHaskabndwbkvh4hEWb8cr8Dy4NRzCemaT+rCvP5RPK
        dtsn/4/emsKVktrf5BZ/bCPuUlZ2v9I=
X-Google-Smtp-Source: ABdhPJz7TJP/9rfpiG84hnXjiFgI+eyFvtY/LuN48TTpUtx/iC/UkpVh8G55KB3STtg99hbGPyL58g==
X-Received: by 2002:a17:902:ec82:b0:13f:663c:87cc with SMTP id x2-20020a170902ec8200b0013f663c87ccmr807468plg.24.1634081766460;
        Tue, 12 Oct 2021 16:36:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 00/46] Register SCSI sysfs attributes earlier
Date:   Tue, 12 Oct 2021 16:35:12 -0700
Message-Id: <20211012233558.4066756-1-bvanassche@acm.org>
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

Changes compared to v3:
- Updated Acked-by / Reviewed-by tags.
- In the zfcp driver, restored the zfcp_sysfs_ prefix.
- Fixed a bug in the patch for the qla2xxx driver.

Changes compared to v2:
- Use the ATTRIBUTE_GROUPS() macro where appropriate.

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
 drivers/ata/ata_piix.c                        |   8 +-
 drivers/ata/libahci.c                         |  52 ++-
 drivers/ata/libata-sata.c                     |  19 +-
 drivers/ata/libata-scsi.c                     |  15 +-
 drivers/ata/pata_macio.c                      |   2 +-
 drivers/ata/sata_mv.c                         |   2 +-
 drivers/ata/sata_nv.c                         |   4 +-
 drivers/ata/sata_sil24.c                      |   2 +-
 drivers/firewire/sbp2.c                       |   8 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |  51 +--
 drivers/message/fusion/mptfc.c                |   2 +-
 drivers/message/fusion/mptsas.c               |   2 +-
 drivers/message/fusion/mptscsih.c             |  36 +-
 drivers/message/fusion/mptscsih.h             |   2 +-
 drivers/message/fusion/mptspi.c               |   2 +-
 drivers/s390/scsi/zfcp_ext.h                  |   4 +-
 drivers/s390/scsi/zfcp_scsi.c                 |   4 +-
 drivers/s390/scsi/zfcp_sysfs.c                |  52 ++-
 drivers/scsi/3w-9xxx.c                        |   8 +-
 drivers/scsi/3w-sas.c                         |   8 +-
 drivers/scsi/3w-xxxx.c                        |   8 +-
 drivers/scsi/53c700.c                         |  12 +-
 drivers/scsi/aacraid/linit.c                  |  38 ++-
 drivers/scsi/arcmsr/arcmsr.h                  |   2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c             |  33 +-
 drivers/scsi/arcmsr/arcmsr_hba.c              |   2 +-
 drivers/scsi/be2iscsi/be_main.c               |  21 +-
 drivers/scsi/bfa/bfad_attr.c                  |  68 ++--
 drivers/scsi/bfa/bfad_im.c                    |   4 +-
 drivers/scsi/bfa/bfad_im.h                    |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c             |   8 +-
 drivers/scsi/bnx2i/bnx2i.h                    |   2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c              |   2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c              |  15 +-
 drivers/scsi/csiostor/csio_scsi.c             |  24 +-
 drivers/scsi/cxlflash/main.c                  |  40 ++-
 drivers/scsi/fnic/fnic.h                      |   2 +-
 drivers/scsi/fnic/fnic_attrs.c                |  17 +-
 drivers/scsi/fnic/fnic_main.c                 |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c        |   8 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c        |   8 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c        |  14 +-
 drivers/scsi/hosts.c                          |  14 +-
 drivers/scsi/hpsa.c                           |  44 +--
 drivers/scsi/hptiop.c                         |  10 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |  22 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  22 +-
 drivers/scsi/ipr.c                            |  38 ++-
 drivers/scsi/isci/init.c                      |   8 +-
 drivers/scsi/lpfc/lpfc_attr.c                 | 314 +++++++++---------
 drivers/scsi/lpfc/lpfc_crtn.h                 |   4 +-
 drivers/scsi/lpfc/lpfc_init.c                 |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                 |   4 +-
 drivers/scsi/megaraid/megaraid_mbox.c         |  15 +-
 drivers/scsi/megaraid/megaraid_sas_base.c     |  24 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h           |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c            |  84 +++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |   8 +-
 drivers/scsi/mvsas/mv_init.c                  |  12 +-
 drivers/scsi/myrb.c                           |  28 +-
 drivers/scsi/myrs.c                           |  40 ++-
 drivers/scsi/ncr53c8xx.c                      |  10 +-
 drivers/scsi/pcmcia/sym53c500_cs.c            |   8 +-
 drivers/scsi/pm8001/pm8001_ctl.c              |  64 ++--
 drivers/scsi/pm8001/pm8001_init.c             |   2 +-
 drivers/scsi/pm8001/pm8001_sas.h              |   2 +-
 drivers/scsi/pmcraid.c                        |  11 +-
 drivers/scsi/qedf/qedf.h                      |   2 +-
 drivers/scsi/qedf/qedf_attr.c                 |  15 +-
 drivers/scsi/qedf/qedf_main.c                 |   2 +-
 drivers/scsi/qedi/qedi_gbl.h                  |   2 +-
 drivers/scsi/qedi/qedi_iscsi.c                |   2 +-
 drivers/scsi/qedi/qedi_sysfs.c                |  15 +-
 drivers/scsi/qla2xxx/qla_attr.c               | 125 +++----
 drivers/scsi/qla2xxx/qla_gbl.h                |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                 |   5 +-
 drivers/scsi/qla4xxx/ql4_attr.c               |  41 ++-
 drivers/scsi/qla4xxx/ql4_glbl.h               |   3 +-
 drivers/scsi/qla4xxx/ql4_os.c                 |   2 +-
 drivers/scsi/scsi_priv.h                      |   2 +-
 drivers/scsi/scsi_sysfs.c                     |  53 +--
 drivers/scsi/smartpqi/smartpqi_init.c         |  46 +--
 drivers/scsi/snic/snic.h                      |   2 +-
 drivers/scsi/snic/snic_attrs.c                |  19 +-
 drivers/scsi/snic/snic_main.c                 |   2 +-
 .../staging/unisys/visorhba/visorhba_main.c   |   1 -
 drivers/usb/storage/scsiglue.c                |   8 +-
 include/linux/libata.h                        |   8 +-
 include/scsi/scsi_device.h                    |   6 +
 include/scsi/scsi_host.h                      |  15 +-
 91 files changed, 1029 insertions(+), 770 deletions(-)

