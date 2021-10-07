Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBF6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EA5261074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhJGUb3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:29 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:52220 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhJGUb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:29 -0400
Received: by mail-pj1-f42.google.com with SMTP id kk10so5814104pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NHBwleqV/cb9wHyE50PCvjqBZEEf14kyXnzaawYYAAs=;
        b=uu/0KAUsiMV3tovjAGzCuGTpG/OA11v/ev4fZ59XZ4DVKzJdYDS4m6ZcJmaT+J3awZ
         tXqJkA9Wi3+NfW2FaXl+dZwmMJ2fM/r3O3S4S5HluDxRs1NIQtD6fiGXw06hUDzoIC9Y
         TjQNrgrUrE8GpHntsIkMMMiw924uW9pYooUmK+ja4VuzHDd3rHiZqTaSBD/rE3pDFQ0W
         ZV8yH67hQ8HA5V5hP5KUc1IxD5WhFKzlxZ9LS0Lep+4IkLgWPssZrcrohcm72vaz+9Yo
         ip09aiX/i60B2fmJ0NQXEZbtDBgUkiQqSWLCXrW4J2GKFZ+EUJREIYtcLkZqUXWMiCc4
         rbrw==
X-Gm-Message-State: AOAM5318sA6jgAbHhQ+MQDZsr8d4vJan2WF+jkl2ZJeNvfzJg0XH9mGy
        s0ph/P4vMqavNxmF2ORD4Jg=
X-Google-Smtp-Source: ABdhPJwzDwYW75FI4XbPzTFE30QuRDZyI2ZQwUtXnNfByRvk79hYHaWHSTRKHJjE8CruD1fCF7Sveg==
X-Received: by 2002:a17:90a:4207:: with SMTP id o7mr7150093pjg.192.1633638574735;
        Thu, 07 Oct 2021 13:29:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 00/88] Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:27:55 -0700
Message-Id: <20211007202923.2174984-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series increases IOPS by 5% on my test setup in a single-threaded
test with queue depth 1 on top of the scsi_debug driver. Please consider this
patch series for kernel v5.16.

Thanks,

Bart.

Changes compared to v2:
- Removed a WARN_ON() statement from patch 1.
- Added a patch to fix a compiler warning in drivers/scsi/ncr53c8xx.c.
- Added three patches that remove the second argument of the
  queuecommand_lck() functions.
- Added more Reviewed-by / Acked-by tags.

Changes compared to v1:
- Inserted the SUBMITTED_BY_ prefix in front of the enumeration constants
  introduced in patch 1.
- Reworked the fas216 patch such that the scsi_done pointer is preserved.
- Moved some SCSI core changes from the start of this series to the end to
  improve bisectability of this series.
- Added explicit initialization of the new "submitter" member variable instead
  of relying on implicit initialization.
- Added Reviewed-by/Acked-by tags.

Bart Van Assche (88):
  scsi: core: Use a structure member to track the SCSI command submitter
  scsi: core: Rename scsi_mq_done() into scsi_done() and export it
  ata: Call scsi_done() directly
  firewire: sbp2: Call scsi_done() directly
  ib_srp: Call scsi_done() directly
  message: fusion: Call scsi_done() directly
  zfcp_scsi: Call scsi_done() directly
  3w-9xxx: Call scsi_done() directly
  3w-sas: Call scsi_done() directly
  3w-xxxx: Call scsi_done() directly
  53c700: Call scsi_done() directly
  BusLogic: Call scsi_done() directly
  NCR5380: Call scsi_done() directly
  a100u2w: Call scsi_done() directly
  aacraid: Introduce aac_scsi_done()
  aacraid: Call scsi_done() directly
  acornscsi: Call scsi_done() directly
  advansys: Call scsi_done() directly
  aha152x: Call scsi_done() directly
  aha1542: Call scsi_done() directly
  aic7xxx: Call scsi_done() directly
  arcmsr: Call scsi_done() directly
  atp870u: Call scsi_done() directly
  bfa: Call scsi_done() directly
  bnx2fc: Call scsi_done() directly
  csiostor: Call scsi_done() directly
  cxlflash: Call scsi_done() directly
  dc395x: Call scsi_done() directly
  dpt_i2o: Call scsi_done() directly
  esas2r: Call scsi_done() directly
  esp_scsi: Call scsi_done() directly
  fas216: Introduce struct fas216_cmd_priv
  fas216: Stop using scsi_cmnd.scsi_done
  fdomain: Call scsi_done() directly
  fnic: Call scsi_done() directly
  hpsa: Call scsi_done() directly
  hptiop: Call scsi_done() directly
  ibmvscsi: Call scsi_done() directly
  imm: Call scsi_done() directly
  initio: Call scsi_done() directly
  ipr: Call scsi_done() directly
  ips: Call scsi_done() directly
  libfc: Call scsi_done() directly
  libiscsi: Call scsi_done() directly
  libsas: Call scsi_done() directly
  lpfc: Call scsi_done() directly
  mac53c94: Call scsi_done() directly
  megaraid: Call scsi_done() directly
  megaraid: Call scsi_done() directly
  mesh: Call scsi_done() directly
  mpi3mr: Call scsi_done() directly
  mpt3sas: Call scsi_done() directly
  mvumi: Call scsi_done() directly
  myrb: Call scsi_done() directly
  myrs: Call scsi_done() directly
  ncr53c8xx: Remove unused code
  ncr53c8xx: Call scsi_done() directly
  nsp32: Call scsi_done() directly
  pcmcia: Call scsi_done() directly
  pmcraid: Call scsi_done() directly
  ppa: Call scsi_done() directly
  ps3rom: Call scsi_done() directly
  qedf: Call scsi_done() directly
  qla1280: Call scsi_done() directly
  qla2xxx: Call scsi_done() directly
  qla4xxx: Call scsi_done() directly
  qlogicfas408: Call scsi_done() directly
  qlogicpti: Call scsi_done() directly
  scsi_debug: Call scsi_done() directly
  smartpqi: Call scsi_done() directly
  snic: Call scsi_done() directly
  stex: Call scsi_done() directly
  storvsc_drv: Call scsi_done() directly
  sym53c8xx_2: Call scsi_done() directly
  ufs: Call scsi_done() directly
  virtio_scsi: Call scsi_done() directly
  vmw_pvscsi: Call scsi_done() directly
  wd33c93: Call scsi_done() directly
  wd719x: Call scsi_done() directly
  xen-scsifront: Call scsi_done() directly
  staging: rts5208: Call scsi_done() directly
  staging: unisys: visorhba: Call scsi_done() directly
  target/tcm_loop: Call scsi_done() directly
  usb: Call scsi_done() directly
  scsi: core: Call scsi_done directly
  isci: Remove a declaration
  fas216: Introduce the function fas216_queue_command_internal()
  scsi: Remove the 'done' argument from SCSI queuecommand_lck functions

 drivers/ata/libata-sata.c                     |   2 +-
 drivers/ata/libata-scsi.c                     |  14 +-
 drivers/firewire/sbp2.c                       |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |   8 +-
 drivers/message/fusion/mptfc.c                |   6 +-
 drivers/message/fusion/mptsas.c               |   2 +-
 drivers/message/fusion/mptscsih.c             |  10 +-
 drivers/message/fusion/mptspi.c               |   4 +-
 drivers/s390/scsi/zfcp_fsf.c                  |   2 +-
 drivers/s390/scsi/zfcp_scsi.c                 |   4 +-
 drivers/scsi/3w-9xxx.c                        |  10 +-
 drivers/scsi/3w-sas.c                         |  10 +-
 drivers/scsi/3w-xxxx.c                        |  16 +--
 drivers/scsi/53c700.c                         |   8 +-
 drivers/scsi/BusLogic.c                       |  13 +-
 drivers/scsi/NCR5380.c                        |  12 +-
 drivers/scsi/a100u2w.c                        |   5 +-
 drivers/scsi/aacraid/aachba.c                 |  53 +++++---
 drivers/scsi/advansys.c                       |   6 +-
 drivers/scsi/aha152x.c                        |  29 +++--
 drivers/scsi/aha1542.c                        |  10 +-
 drivers/scsi/aha1740.c                        |   4 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c            |   6 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c            |   6 +-
 drivers/scsi/arcmsr/arcmsr_hba.c              |  20 ++-
 drivers/scsi/arm/acornscsi.c                  |  20 +--
 drivers/scsi/arm/arxescsi.c                   |   1 +
 drivers/scsi/arm/cumana_2.c                   |   1 +
 drivers/scsi/arm/eesox.c                      |   1 +
 drivers/scsi/arm/fas216.c                     |  26 ++--
 drivers/scsi/arm/fas216.h                     |  10 ++
 drivers/scsi/arm/powertec.c                   |   2 +-
 drivers/scsi/atp870u.c                        |  17 +--
 drivers/scsi/bfa/bfad_im.c                    |  12 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c               |   8 +-
 drivers/scsi/csiostor/csio_scsi.c             |   8 +-
 drivers/scsi/cxlflash/main.c                  |   6 +-
 drivers/scsi/dc395x.c                         |  11 +-
 drivers/scsi/dpt_i2o.c                        |  13 +-
 drivers/scsi/esas2r/esas2r_main.c             |   8 +-
 drivers/scsi/esp_scsi.c                       |  12 +-
 drivers/scsi/fdomain.c                        |   2 +-
 drivers/scsi/fnic/fnic_scsi.c                 | 122 ++++++++----------
 drivers/scsi/hosts.c                          |   2 +-
 drivers/scsi/hpsa.c                           |  12 +-
 drivers/scsi/hptiop.c                         |  10 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |   8 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |   4 +-
 drivers/scsi/imm.c                            |   6 +-
 drivers/scsi/initio.c                         |   7 +-
 drivers/scsi/ipr.c                            |  10 +-
 drivers/scsi/ips.c                            |  31 +++--
 drivers/scsi/isci/task.h                      |   4 -
 drivers/scsi/libfc/fc_fcp.c                   |   6 +-
 drivers/scsi/libiscsi.c                       |   4 +-
 drivers/scsi/libsas/sas_scsi_host.c           |   4 +-
 drivers/scsi/lpfc/lpfc_scsi.c                 |   8 +-
 drivers/scsi/mac53c94.c                       |   6 +-
 drivers/scsi/megaraid.c                       |  24 ++--
 drivers/scsi/megaraid/megaraid_mbox.c         |  13 +-
 drivers/scsi/megaraid/megaraid_sas_base.c     |  16 +--
 drivers/scsi/megaraid/megaraid_sas_fusion.c   |   6 +-
 drivers/scsi/mesh.c                           |  18 +--
 drivers/scsi/mpi3mr/mpi3mr_os.c               |  26 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |  18 +--
 drivers/scsi/mvumi.c                          |   4 +-
 drivers/scsi/myrb.c                           |  32 ++---
 drivers/scsi/myrs.c                           |  10 +-
 drivers/scsi/ncr53c8xx.c                      |  29 +----
 drivers/scsi/nsp32.c                          |   7 +-
 drivers/scsi/pcmcia/nsp_cs.c                  |   7 +-
 drivers/scsi/pcmcia/sym53c500_cs.c            |   6 +-
 drivers/scsi/pmcraid.c                        |  16 +--
 drivers/scsi/ppa.c                            |   6 +-
 drivers/scsi/ps3rom.c                         |   8 +-
 drivers/scsi/qedf/qedf_io.c                   |  19 +--
 drivers/scsi/qla1280.c                        |   8 +-
 drivers/scsi/qla2xxx/qla_os.c                 |   8 +-
 drivers/scsi/qla4xxx/ql4_os.c                 |   4 +-
 drivers/scsi/qlogicfas408.c                   |   7 +-
 drivers/scsi/qlogicpti.c                      |   7 +-
 drivers/scsi/scsi_debug.c                     |   8 +-
 drivers/scsi/scsi_error.c                     |  17 +--
 drivers/scsi/scsi_lib.c                       |  16 ++-
 drivers/scsi/scsi_priv.h                      |   1 +
 drivers/scsi/smartpqi/smartpqi_init.c         |   2 +-
 drivers/scsi/snic/snic_scsi.c                 |  33 ++---
 drivers/scsi/stex.c                           |  10 +-
 drivers/scsi/storvsc_drv.c                    |   4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c           |   6 +-
 drivers/scsi/ufs/ufshcd.c                     |   6 +-
 drivers/scsi/virtio_scsi.c                    |   7 +-
 drivers/scsi/vmw_pvscsi.c                     |   9 +-
 drivers/scsi/wd33c93.c                        |  18 +--
 drivers/scsi/wd719x.c                         |   4 +-
 drivers/scsi/xen-scsifront.c                  |   4 +-
 drivers/staging/rts5208/rtsx.c                |   9 +-
 .../staging/unisys/visorhba/visorhba_main.c   |  19 ++-
 drivers/target/loopback/tcm_loop.c            |   4 +-
 drivers/usb/image/microtek.c                  |   5 +-
 drivers/usb/storage/scsiglue.c                |   5 +-
 drivers/usb/storage/uas.c                     |  13 +-
 drivers/usb/storage/usb.c                     |   4 +-
 include/scsi/scsi_cmnd.h                      |  13 +-
 include/scsi/scsi_host.h                      |   2 +-
 105 files changed, 531 insertions(+), 651 deletions(-)

