Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1989C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C556109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhDTAJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:23 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:42714 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhDTAJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:22 -0400
Received: by mail-pg1-f180.google.com with SMTP id m12so4672340pgr.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y9HkHXwHL8iVlJKKxeeibHDrCWWbMJS6pbuRzdgO/0Y=;
        b=h2zf68+P2aiLN0bz7MrXnbwif/k4/595ck3pV673ZTZqT+rYcmTmFhrcW39YDS4jYe
         vSVFYo3pjr0ERYaXhOWasmbWhJZmolLKzgJqf5ZuWMQzG9H5mwSsglaWq4lAoEuI0hkK
         F3bqwnP0OI5ZcAZxAcEyWHYu4u/cWYWvZoyvBlVlJzIyxeo0xlFbm0118OHNSI8km9n8
         OFi6/T1RL6hrQPa9DifQoMpsNcOmdkdko6thPLs8J0n7W/zPSZy621le9zywtQWXTvA6
         VhSOEgucsswvlaH/8yCkusFTbJy2FPs4alLjpz+ZY31HP+TF2884kXO5jrFo7cUVoEl6
         RfXQ==
X-Gm-Message-State: AOAM533ZMSnwAFYwLDZqJhOODEzELbDVOpvqhkuh2tLOmVN4RMKDZ5fB
        yz2gx70QMsOaPmQ1uBPXnEE=
X-Google-Smtp-Source: ABdhPJysudM61K4S3Xn2z6c/UrTLrxLMiGbbTszn30rsP7WccGPRrCWUDRJwh+P86dnSalC3JcfuCw==
X-Received: by 2002:a62:9a11:0:b029:25c:908b:5284 with SMTP id o17-20020a629a110000b029025c908b5284mr11875852pfe.6.1618877331653;
        Mon, 19 Apr 2021 17:08:51 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:08:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 000/117] Make better use of static type checking
Date:   Mon, 19 Apr 2021 17:06:48 -0700
Message-Id: <20210420000845.25873-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Martin,

This patch series improves static checking inside the SCSI subsystem as
follows:
- Introduce enumeration types for the SCSI status, message, host and driver
  bytes.
- Change 'int' into 'union scsi_status' in case of SCSI results. This helps
  the compiler and humans to tell the difference between a scalar and a SCSI
  result.

This patch series is long because it touches all SCSI drivers and because it
has been split into one patch per SCSI driver.

This patch series introduces a backwards-incompatible change in the API
between SCSI core and drivers. A possible strategy is to postpone the patch
that removes backwards compatibility to a later kernel version.

Please consider this patch series for kernel version v5.14.

Thanks,

Bart.

Bart Van Assche (117):
  libsas: Introduce more SAM status code aliases in enum exec_status
  Introduce enums for the SAM, message, host and driver status codes
  Change the type of the second argument of
    scsi_host_complete_all_commands()
  libiscsi: Use the host_status enum
  libsas: Use the host_status and sam_status enums
  target: Use enum sam_status instead of u8
  lpfc: Reformat four comparisons
  fc: Add a compile-time structure size check
  iscsi: Add a compile-time structure size check
  ufs: Add a compile-time structure size check
  Introduce the scsi_status union
  block: Convert SCSI and bsg code to the scsi_status union
  core: Convert to the scsi_status union
  ch: Pass union scsi_status to driver_byte()
  sd: Convert to the scsi_status union
  sr: Convert to the scsi_status union
  st: Convert to the scsi_status union
  sg: Convert to the scsi_status union
  3w*: Convert to the scsi_status union
  53c700: Convert to the scsi_status union
  BusLogic: Convert to the scsi_status union
  NCR5380: Convert to the scsi_status union
  a100u2w: Convert to the scsi_status union
  aacraid: Convert to the scsi_status union
  acornscsi: Annotate fallthrough
  acornscsi: Convert to the scsi_status union
  advansys: Convert to the scsi_status union
  aha*: Convert to the scsi_status union
  aic*: Convert to the scsi_status union
  arcmsr: Convert to the scsi_status union
  ata: Convert to the scsi_status union
  atp870u: Convert to the scsi_status union
  be2iscsi: Convert to the scsi_status union
  bfa: Use type int32_t to represent a signed integer
  bfa: Convert to the scsi_status union
  bnx2fc: Convert to the scsi_status union
  cdrom: Convert to the scsi_status union
  csiostor: Convert to the scsi_status union
  cxlflash: Convert to the scsi_status union
  dc395x: Use the set_{host,msg,status}_byte() functions
  dc395x: Convert to the scsi_status union
  dpt_i2o: Convert to the scsi_status union
  esas2r: Convert to the scsi_status union
  esp_scsi: Convert to the scsi_status union
  fas216: Fix two source code comments
  fas216: Convert to the scsi_status union
  fc: Convert to the scsi_status union
  fdomain: Convert to the scsi_status union
  firewire: sbp2: Convert to the scsi_status union
  fnic: Convert to the scsi_status union
  hpsa: Convert to the scsi_status union
  hptiop: Convert to the scsi_status union
  ib_srp: Convert to the scsi_status union
  ibmvfc: Fix the documentation of the return value of
    ibmvfc_host_chkready()
  ibmvfc: Convert to the scsi_status union
  ibmvscsi: Convert to the scsi_status union
  ide: Convert to the scsi_status union
  imm: Convert to the scsi_status union
  initio: Convert to the scsi_status union
  ipr: Convert to the scsi_status union
  ips: Convert to the scsi_status union
  iscsi: Convert to the scsi_status union
  libfc: Convert to the scsi_status union
  sas: Convert to the scsi_status union
  lpfc: Convert to the scsi_status union
  mac53c94: Convert to the scsi_status union
  megaraid: Convert to the scsi_status union
  mesh: Convert to the scsi_status union
  message: fusion: Convert to the scsi_status union
  mpt3sas: Convert to the scsi_status union
  mvumi: Convert to the scsi_status union
  myrb: Convert to the scsi_status union
  myrs: Convert to the scsi_status union
  ncr53c8xx: Convert to the scsi_status union
  nfsd: Convert to the scsi_status union
  nsp32: Convert to the scsi_status union
  pcmcia: Convert to the scsi_status union
  pktcdvd: Convert to the scsi_status union
  pmcraid: Convert to the scsi_status union
  ppa: Convert to the scsi_status union
  ps3rom: Convert to the scsi_status union
  qedf: Convert to the scsi_status union
  qedi: Convert to the scsi_status union
  qla1280: Convert to the scsi_status union
  qla2xxx: Convert to the scsi_status union
  qla4xxx: Convert to the scsi_status union
  qlogicfas408: Convert to the scsi_status union
  qlogicpti: Convert to the scsi_status union
  s390/zfcp: Convert to the scsi_status union
  scsi_debug: Convert to the scsi_status union
  smartpqi: Convert to the scsi_status union
  snic: Convert to the scsi_status union
  staging: Convert to the scsi_status union
  stex: Convert to the scsi_status union
  storvsc: Convert to the scsi_status union
  sym53c8xx_2: Convert to the scsi_status union
  target: Convert to the scsi_status union
  ufs: Remove an unused structure member
  ufs: Remove a local variable
  ufs: Use enum sam_status where appropriate
  ufs: Remove an assignment from ufshcd_transfer_rsp_status()
  ufs: Convert to the scsi_status union
  usb: Convert to the scsi_status union
  virtio-scsi: Convert to the scsi_status union
  vmw_pvscsi: Convert to the scsi_status union
  wd33c93: Convert to the scsi_status union
  wd719x: Convert to the scsi_status union
  xen-scsiback: Pass union status to the {status,msg,host,driver}_byte()
    macros
  xen-scsifront: Convert to the scsi_status union
  Finalize the switch from 'int' to 'union scsi_status'
  Use the scsi_status union more widely
  Change the return type of scsi_execute() into union scsi_status
  Change the return type of scsi_execute_req() into union scsi_status
  Change the return type of scsi_test_unit_ready() into union
    scsi_status
  Change the return types of scsi_mode_sense() and sd_do_mode_sense()
  Change the return type of scsi_mode_select() into union scsi_status
  Change the return type of ioctl_internal_command() into union
    scsi_status

 block/bsg-lib.c                               |  16 +-
 block/bsg.c                                   |   6 +-
 block/scsi_ioctl.c                            |  14 +-
 drivers/ata/libata-sata.c                     |   2 +-
 drivers/ata/libata-scsi.c                     |  60 +++----
 drivers/block/pktcdvd.c                       |   2 +-
 drivers/cdrom/cdrom.c                         |   2 +-
 drivers/firewire/sbp2.c                       |   2 +-
 drivers/hwmon/drivetemp.c                     |   2 +-
 drivers/ide/ide-atapi.c                       |  10 +-
 drivers/ide/ide-cd.c                          |  20 +--
 drivers/ide/ide-cd_ioctl.c                    |   2 +-
 drivers/ide/ide-devsets.c                     |   4 +-
 drivers/ide/ide-dma.c                         |   2 +-
 drivers/ide/ide-eh.c                          |  36 ++---
 drivers/ide/ide-floppy.c                      |  10 +-
 drivers/ide/ide-io.c                          |  10 +-
 drivers/ide/ide-ioctls.c                      |   4 +-
 drivers/ide/ide-park.c                        |   2 +-
 drivers/ide/ide-pm.c                          |   6 +-
 drivers/ide/ide-tape.c                        |   4 +-
 drivers/ide/ide-taskfile.c                    |   6 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |  27 ++--
 drivers/message/fusion/mptfc.c                |   6 +-
 drivers/message/fusion/mptsas.c               |   2 +-
 drivers/message/fusion/mptscsih.c             |  70 ++++-----
 drivers/message/fusion/mptspi.c               |   4 +-
 drivers/s390/scsi/zfcp_dbf.c                  |   2 +-
 drivers/s390/scsi/zfcp_dbf.h                  |   2 +-
 drivers/s390/scsi/zfcp_fc.c                   |   4 +-
 drivers/s390/scsi/zfcp_fc.h                   |   2 +-
 drivers/s390/scsi/zfcp_scsi.c                 |   6 +-
 drivers/scsi/3w-9xxx.c                        |  12 +-
 drivers/scsi/3w-sas.c                         |   8 +-
 drivers/scsi/3w-xxxx.c                        |  20 +--
 drivers/scsi/53c700.c                         |   4 +-
 drivers/scsi/BusLogic.c                       |  25 +--
 drivers/scsi/NCR5380.c                        |  30 ++--
 drivers/scsi/a100u2w.c                        |   2 +-
 drivers/scsi/aacraid/aachba.c                 | 142 ++++++++---------
 drivers/scsi/advansys.c                       |   4 +-
 drivers/scsi/aha152x.c                        |   4 +-
 drivers/scsi/aha1542.c                        |   4 +-
 drivers/scsi/aha1740.c                        |   4 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c            |  10 +-
 drivers/scsi/aic7xxx/aic79xx_osm.h            |  16 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c            |   8 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.h            |  16 +-
 drivers/scsi/aic94xx/aic94xx_task.c           |   2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c              |  38 ++---
 drivers/scsi/arm/acornscsi.c                  |  30 ++--
 drivers/scsi/arm/fas216.c                     |  44 +++---
 drivers/scsi/atp870u.c                        |  14 +-
 drivers/scsi/be2iscsi/be_main.c               |  12 +-
 drivers/scsi/bfa/bfad_bsg.c                   |  14 +-
 drivers/scsi/bfa/bfad_im.c                    |  30 ++--
 drivers/scsi/bnx2fc/bnx2fc_io.c               |  14 +-
 drivers/scsi/ch.c                             |   3 +-
 drivers/scsi/constants.c                      |   8 +-
 drivers/scsi/csiostor/csio_scsi.c             |  18 ++-
 drivers/scsi/cxlflash/main.c                  |  32 ++--
 drivers/scsi/cxlflash/superpipe.c             |  14 +-
 drivers/scsi/cxlflash/vlun.c                  |   8 +-
 drivers/scsi/dc395x.c                         |  73 ++++-----
 drivers/scsi/device_handler/scsi_dh_alua.c    |  28 ++--
 drivers/scsi/device_handler/scsi_dh_emc.c     |   7 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c   |  12 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c    |   2 +-
 drivers/scsi/dpt_i2o.c                        |  28 ++--
 drivers/scsi/esas2r/esas2r.h                  |   2 +-
 drivers/scsi/esas2r/esas2r_main.c             |  12 +-
 drivers/scsi/esp_scsi.c                       |  10 +-
 drivers/scsi/fdomain.c                        |   4 +-
 drivers/scsi/fnic/fnic_scsi.c                 |  38 ++---
 drivers/scsi/hosts.c                          |   8 +-
 drivers/scsi/hpsa.c                           |  74 ++++-----
 drivers/scsi/hptiop.c                         |  20 +--
 drivers/scsi/ibmvscsi/ibmvfc.c                |  26 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  16 +-
 drivers/scsi/imm.c                            |  10 +-
 drivers/scsi/initio.c                         |   2 +-
 drivers/scsi/ipr.c                            |  34 ++--
 drivers/scsi/ips.c                            |  72 ++++-----
 drivers/scsi/isci/request.c                   |  10 +-
 drivers/scsi/isci/task.c                      |   2 +-
 drivers/scsi/libfc/fc_fcp.c                   |  36 ++---
 drivers/scsi/libfc/fc_lport.c                 |   8 +-
 drivers/scsi/libiscsi.c                       |  51 +++---
 drivers/scsi/libsas/sas_ata.c                 |   5 +-
 drivers/scsi/libsas/sas_expander.c            |   2 +-
 drivers/scsi/libsas/sas_scsi_host.c           |  13 +-
 drivers/scsi/libsas/sas_task.c                |   4 +-
 drivers/scsi/lpfc/lpfc_bsg.c                  | 114 +++++++-------
 drivers/scsi/lpfc/lpfc_scsi.c                 |  78 +++++----
 drivers/scsi/mac53c94.c                       |   2 +-
 drivers/scsi/megaraid.c                       |  50 +++---
 drivers/scsi/megaraid/megaraid_mbox.c         |  62 ++++----
 drivers/scsi/megaraid/megaraid_sas_base.c     |  30 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c   |  20 +--
 drivers/scsi/mesh.c                           |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |  78 ++++-----
 drivers/scsi/mvsas/mv_sas.c                   |  10 +-
 drivers/scsi/mvumi.c                          |  18 +--
 drivers/scsi/myrb.c                           |  48 +++---
 drivers/scsi/myrs.c                           |  14 +-
 drivers/scsi/ncr53c8xx.c                      |   2 +-
 drivers/scsi/nsp32.c                          |  40 ++---
 drivers/scsi/pcmcia/nsp_cs.c                  |  18 ++-
 drivers/scsi/pcmcia/sym53c500_cs.c            |  12 +-
 drivers/scsi/pm8001/pm8001_hwi.c              |  16 +-
 drivers/scsi/pm8001/pm8001_sas.c              |   4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c              |  14 +-
 drivers/scsi/pmcraid.c                        |  28 ++--
 drivers/scsi/ppa.c                            |  12 +-
 drivers/scsi/ps3rom.c                         |  10 +-
 drivers/scsi/qedf/qedf_io.c                   |  24 +--
 drivers/scsi/qedi/qedi_fw.c                   |   2 +-
 drivers/scsi/qla1280.c                        |   2 +-
 drivers/scsi/qla2xxx/qla_bsg.c                | 148 +++++++++---------
 drivers/scsi/qla2xxx/qla_iocb.c               |   4 +-
 drivers/scsi/qla2xxx/qla_isr.c                |  14 +-
 drivers/scsi/qla2xxx/qla_mr.c                 |   6 +-
 drivers/scsi/qla2xxx/qla_os.c                 |  26 +--
 drivers/scsi/qla4xxx/ql4_bsg.c                |  76 ++++-----
 drivers/scsi/qla4xxx/ql4_isr.c                |  32 ++--
 drivers/scsi/qla4xxx/ql4_os.c                 |  14 +-
 drivers/scsi/qlogicfas408.c                   |   4 +-
 drivers/scsi/qlogicpti.c                      |   6 +-
 drivers/scsi/scsi.c                           |  25 ++-
 drivers/scsi/scsi_debug.c                     |  26 +--
 drivers/scsi/scsi_debugfs.c                   |   2 +-
 drivers/scsi/scsi_error.c                     |  46 +++---
 drivers/scsi/scsi_ioctl.c                     |  24 +--
 drivers/scsi/scsi_lib.c                       |  84 +++++-----
 drivers/scsi/scsi_logging.c                   |   8 +-
 drivers/scsi/scsi_scan.c                      |  22 +--
 drivers/scsi/scsi_transport_fc.c              |  10 +-
 drivers/scsi/scsi_transport_iscsi.c           |   5 +-
 drivers/scsi/scsi_transport_sas.c             |   3 +-
 drivers/scsi/scsi_transport_spi.c             |   5 +-
 drivers/scsi/sd.c                             |  83 +++++-----
 drivers/scsi/sd.h                             |   3 +-
 drivers/scsi/sd_zbc.c                         |  12 +-
 drivers/scsi/ses.c                            |   4 +-
 drivers/scsi/sg.c                             |  11 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |  12 +-
 drivers/scsi/snic/snic_scsi.c                 |  14 +-
 drivers/scsi/sr.c                             |  20 +--
 drivers/scsi/sr_ioctl.c                       |   6 +-
 drivers/scsi/st.c                             |  23 +--
 drivers/scsi/st.h                             |   5 +-
 drivers/scsi/stex.c                           |  20 +--
 drivers/scsi/storvsc_drv.c                    |   6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c           |   2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.h           |   8 +-
 drivers/scsi/ufs/ufs_bsg.c                    |   2 +-
 drivers/scsi/ufs/ufshcd.c                     |  51 +++---
 drivers/scsi/ufs/ufshcd.h                     |   1 -
 drivers/scsi/virtio_scsi.c                    |  14 +-
 drivers/scsi/vmw_pvscsi.c                     |  32 ++--
 drivers/scsi/wd33c93.c                        |  30 ++--
 drivers/scsi/wd719x.c                         |   4 +-
 drivers/scsi/xen-scsifront.c                  |   6 +-
 drivers/staging/rts5208/rtsx.c                |  14 +-
 drivers/staging/rts5208/rtsx_transport.c      |   8 +-
 drivers/staging/unisys/include/iochannel.h    |   3 +-
 .../staging/unisys/visorhba/visorhba_main.c   |  12 +-
 drivers/target/loopback/tcm_loop.c            |   6 +-
 drivers/target/target_core_alua.c             |   6 +-
 drivers/target/target_core_iblock.c           |   2 +-
 drivers/target/target_core_pr.c               |   8 +-
 drivers/target/target_core_pscsi.c            |  16 +-
 drivers/target/target_core_sbc.c              |  10 +-
 drivers/target/target_core_spc.c              |  14 +-
 drivers/target/target_core_transport.c        |   5 +-
 drivers/target/target_core_xcopy.c            |   2 +-
 drivers/usb/image/microtek.c                  |   4 +-
 drivers/usb/storage/cypress_atacb.c           |  12 +-
 drivers/usb/storage/datafab.c                 |   4 +-
 drivers/usb/storage/isd200.c                  |  34 ++--
 drivers/usb/storage/jumpshot.c                |   4 +-
 drivers/usb/storage/realtek_cr.c              |  10 +-
 drivers/usb/storage/scsiglue.c                |   4 +-
 drivers/usb/storage/transport.c               |  30 ++--
 drivers/usb/storage/uas.c                     |   8 +-
 drivers/usb/storage/usb.c                     |  14 +-
 drivers/xen/xen-scsiback.c                    |  11 +-
 fs/nfsd/blocklayout.c                         |   4 +-
 include/linux/bsg-lib.h                       |   3 +-
 include/scsi/libsas.h                         |   3 +
 include/scsi/scsi.h                           |  96 ++----------
 include/scsi/scsi_bsg_iscsi.h                 |   5 +-
 include/scsi/scsi_cmnd.h                      |  22 +--
 include/scsi/scsi_dbg.h                       |  10 +-
 include/scsi/scsi_device.h                    |  26 +--
 include/scsi/scsi_eh.h                        |   4 +-
 include/scsi/scsi_host.h                      |   2 +-
 include/scsi/scsi_proto.h                     |  53 ++++---
 include/scsi/scsi_request.h                   |   3 +-
 include/scsi/scsi_status.h                    | 120 ++++++++++++++
 include/scsi/scsi_transport_srp.h             |  15 +-
 include/target/target_core_backend.h          |   4 +-
 include/target/target_core_base.h             |   3 +-
 include/trace/events/scsi.h                   |   2 +-
 include/uapi/scsi/scsi_bsg_fc.h               |   7 +
 include/uapi/scsi/scsi_bsg_ufs.h              |  10 +-
 206 files changed, 1995 insertions(+), 1861 deletions(-)
 create mode 100644 include/scsi/scsi_status.h

