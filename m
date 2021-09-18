Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3D8C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D247460F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242143AbhIRAHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:37 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:43841 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhIRAHh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:37 -0400
Received: by mail-pj1-f47.google.com with SMTP id k23-20020a17090a591700b001976d2db364so8535190pji.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7a5ptRA02krKhPiOkoqLPRYJsODmkxShAn3azRmR8Gg=;
        b=znuGGjyaey46G0RCPGC1gxSl+S1zK/pgb5IvOZT36J63gL/BAw+ASEg4fpBEomAg9m
         O01ioDWRUnCD19ZyY+wjJT9ZBmMkYIdBNWpifjyQwMVBJh6Z0sS5+DwpmN4dk6LFuGyG
         ZlQFDSqpbKIvabcFYqxNCrgc+YiIAvQ+Nr31kz5ZRFSybWC8/doFv5GTq7Osig9Rg36v
         +TXYZYXuPH5NFHjlLFb/YU8ttdvYUyIBEDMy+SiL1p+4yzrNAWQTNTJN8ZLVYRQV6bAX
         uWC6zcl3CSZHWoWzvhHL073ZwsHitZt2a3CiH88mYhhr8UkpO6jFbp1Szfr9bdJMEBsa
         AOfw==
X-Gm-Message-State: AOAM533k09HTl816cDzq2FdK7oL9XSlzsA4ba5RQ7WiVi2om0ktB5yyO
        NSQTXNSTPwZh0jNR79wCOCnvMYIlKyM=
X-Google-Smtp-Source: ABdhPJzSignkTkYdpKxiO7e9L8nzlQH49phMtpnYm23UTG/BkG9L08vAQDVPI5D2OIJKFmH3Dm5+sA==
X-Received: by 2002:a17:90b:46cd:: with SMTP id jx13mr15287792pjb.122.1631923574231;
        Fri, 17 Sep 2021 17:06:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/84] Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:43 -0700
Message-Id: <20210918000607.450448-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
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

Bart Van Assche (84):
  scsi: core: Use a member variable to track the SCSI command submitter
  scsi: core: Rename scsi_mq_done() into scsi_done() and export it
  scsi: core: Call scsi_done directly
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
  fas216: Call scsi_done() directly
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
  scsi_lib: Call scsi_done() directly

 drivers/ata/libata-sata.c                     |   2 +-
 drivers/ata/libata-scsi.c                     |  14 +--
 drivers/firewire/sbp2.c                       |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |   8 +-
 drivers/message/fusion/mptfc.c                |   6 +-
 drivers/message/fusion/mptsas.c               |   2 +-
 drivers/message/fusion/mptscsih.c             |  10 +-
 drivers/message/fusion/mptspi.c               |   4 +-
 drivers/s390/scsi/zfcp_fsf.c                  |   2 +-
 drivers/s390/scsi/zfcp_scsi.c                 |   4 +-
 drivers/scsi/3w-9xxx.c                        |   7 +-
 drivers/scsi/3w-sas.c                         |   7 +-
 drivers/scsi/3w-xxxx.c                        |  13 +-
 drivers/scsi/53c700.c                         |   5 +-
 drivers/scsi/BusLogic.c                       |   9 +-
 drivers/scsi/NCR5380.c                        |  12 +-
 drivers/scsi/a100u2w.c                        |   3 +-
 drivers/scsi/aacraid/aachba.c                 |  53 ++++----
 drivers/scsi/advansys.c                       |   3 +-
 drivers/scsi/aha152x.c                        |  27 ++--
 drivers/scsi/aha1542.c                        |  10 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c            |   3 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c            |   3 +-
 drivers/scsi/arcmsr/arcmsr_hba.c              |  17 ++-
 drivers/scsi/arm/acornscsi.c                  |   6 +-
 drivers/scsi/arm/fas216.c                     |  13 +-
 drivers/scsi/atp870u.c                        |  13 +-
 drivers/scsi/bfa/bfad_im.c                    |   8 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c               |   8 +-
 drivers/scsi/csiostor/csio_scsi.c             |   8 +-
 drivers/scsi/cxlflash/main.c                  |   6 +-
 drivers/scsi/dc395x.c                         |   8 +-
 drivers/scsi/dpt_i2o.c                        |  11 +-
 drivers/scsi/esas2r/esas2r_main.c             |   8 +-
 drivers/scsi/esp_scsi.c                       |  10 +-
 drivers/scsi/fdomain.c                        |   2 +-
 drivers/scsi/fnic/fnic_scsi.c                 | 119 ++++++++----------
 drivers/scsi/hosts.c                          |   2 +-
 drivers/scsi/hpsa.c                           |  12 +-
 drivers/scsi/hptiop.c                         |   7 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |   8 +-
 drivers/scsi/imm.c                            |   3 +-
 drivers/scsi/initio.c                         |   4 +-
 drivers/scsi/ipr.c                            |  10 +-
 drivers/scsi/ips.c                            |  28 ++---
 drivers/scsi/libfc/fc_fcp.c                   |   6 +-
 drivers/scsi/libiscsi.c                       |   4 +-
 drivers/scsi/libsas/sas_scsi_host.c           |   4 +-
 drivers/scsi/lpfc/lpfc_scsi.c                 |   8 +-
 drivers/scsi/mac53c94.c                       |   3 +-
 drivers/scsi/megaraid.c                       |  21 ++--
 drivers/scsi/megaraid/megaraid_mbox.c         |   9 +-
 drivers/scsi/megaraid/megaraid_sas_base.c     |  16 +--
 drivers/scsi/megaraid/megaraid_sas_fusion.c   |   6 +-
 drivers/scsi/mesh.c                           |  16 +--
 drivers/scsi/mpi3mr/mpi3mr_os.c               |  26 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |  18 +--
 drivers/scsi/mvumi.c                          |   4 +-
 drivers/scsi/myrb.c                           |  32 ++---
 drivers/scsi/myrs.c                           |  10 +-
 drivers/scsi/ncr53c8xx.c                      |   3 +-
 drivers/scsi/nsp32.c                          |   3 +-
 drivers/scsi/pcmcia/nsp_cs.c                  |   4 +-
 drivers/scsi/pcmcia/sym53c500_cs.c            |   3 +-
 drivers/scsi/pmcraid.c                        |  11 +-
 drivers/scsi/ppa.c                            |   3 +-
 drivers/scsi/ps3rom.c                         |   5 +-
 drivers/scsi/qedf/qedf_io.c                   |  19 +--
 drivers/scsi/qla1280.c                        |   5 +-
 drivers/scsi/qla2xxx/qla_os.c                 |   8 +-
 drivers/scsi/qla4xxx/ql4_os.c                 |   4 +-
 drivers/scsi/qlogicfas408.c                   |   3 +-
 drivers/scsi/qlogicpti.c                      |   4 +-
 drivers/scsi/scsi_debug.c                     |   8 +-
 drivers/scsi/scsi_error.c                     |  18 ++-
 drivers/scsi/scsi_lib.c                       |  15 ++-
 drivers/scsi/scsi_priv.h                      |   1 +
 drivers/scsi/smartpqi/smartpqi_init.c         |   2 +-
 drivers/scsi/snic/snic_scsi.c                 |  33 +++--
 drivers/scsi/stex.c                           |   6 +-
 drivers/scsi/storvsc_drv.c                    |   4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c           |   3 +-
 drivers/scsi/ufs/ufshcd.c                     |   6 +-
 drivers/scsi/virtio_scsi.c                    |   7 +-
 drivers/scsi/vmw_pvscsi.c                     |   7 +-
 drivers/scsi/wd33c93.c                        |  14 +--
 drivers/scsi/wd719x.c                         |   4 +-
 drivers/scsi/xen-scsifront.c                  |   4 +-
 drivers/staging/rts5208/rtsx.c                |   5 +-
 .../staging/unisys/visorhba/visorhba_main.c   |  14 +--
 drivers/target/loopback/tcm_loop.c            |   4 +-
 drivers/usb/storage/scsiglue.c                |   1 -
 drivers/usb/storage/uas.c                     |  10 +-
 drivers/usb/storage/usb.c                     |   4 +-
 include/scsi/scsi_cmnd.h                      |  13 +-
 include/scsi/scsi_host.h                      |   2 +-
 96 files changed, 436 insertions(+), 527 deletions(-)

