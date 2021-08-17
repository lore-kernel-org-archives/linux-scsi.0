Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1414AC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E290560EE4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbhHQJRP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:15 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47364 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhHQJRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B6D2C2000E;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=5kDAz5NMYcUrAzP0YZCcSlcPhpRYGTh2O6ECAEE7Y5w=;
        b=XulMjQ/mRr//PKcIa6nx0j/rjICHIuUXCVXhe8JSdmcLeSA/mw/w5SDRjBYh3xFrSIEuaN
        VGj9oDKx5w2kD2wGYSv1HzAX7CY//dikf7OYDiSMvgOeKkQ7Tkf+63wXEBEJQbC8yBFz4C
        HB5WI3PzsYRuhdPMzVMiovbZ8ym/CUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=5kDAz5NMYcUrAzP0YZCcSlcPhpRYGTh2O6ECAEE7Y5w=;
        b=sXdnDznXlOxXpcd6kwcW5i4b1PEp2B/d5s/jrkD4yBRpwypizT9IenFq2h5WS53ca+1DO9
        B608rmAuMErKOiDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id AE346A3B91;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 98038518CE5F; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/51] SCSI EH argument reshuffle part II
Date:   Tue, 17 Aug 2021 11:14:05 +0200
Message-Id: <20210817091456.73342-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

finally here's the patchset to revamp the SCSI EH callback arguments
which I promised to do (some years ago ...).
(And, hint: do not order the series by date; some patches are _old_)

The overall idea is to match the scope of the eh_XXX callbacks with
the appropriate argument, eg eh_device_reset_handler() should have a
scsi device as argument etc.
Relying on the scsi command has the problem that
a) we're holding a reference on that command for the entire lifetime
of the error handling and
b) it leads to some 'interesting' driver implementations; some
higher-level EH callback implementations go through the list of
outstanding commands and try to abort this particular command only;
makes one wonder what'll happen to the other commands ...

However, this patchset has the nice side-effect that we don't need to
allocate an out-of-order scsi command in scsi_ioctl_reset(), but can
call the function directly.

This is the second part which rearranges the individual EH handler
implementation to not rely on the passed in scsi command and do
the final conversion to the new calling convention.

The entire patchset can be found at

https://git.kernel.org/hare/scsi-devel/h/eh-rework.v2

As usual, comments and reviews are welcome.

Changes to the original submission:
- Updated to 5.15/scsi-queue
- Add patches for mpi3mr driver

Hannes Reinecke (51):
  lpfc: kill lpfc_bus_reset_handler
  lpfc: drop lpfc_no_handler()
  sym53c8xx_2: split off bus reset from host reset
  ips: Do not try to abort command from host reset
  snic: reserve tag for TMF
  qla1280: separate out host reset function from qla1280_error_action()
  megaraid: pass in NULL scb for host reset
  zfcp: open-code fc_block_scsi_eh() for host reset
  mpi3mr: split off bus_reset function from host_reset
  scsi: Use Scsi_Host as argument for eh_host_reset_handler
  mptfc: simplify mpt_fc_block_error_handler()
  mptfusion: correct definitions for mptscsih_dev_reset()
  mptfc: open-code mptfc_block_error_handler() for bus reset
  pmcraid: Select device in pmcraid_eh_bus_reset_handler()
  qla2xxx: open-code qla2xxx_generic_reset()
  qla2xxx: Do not call fc_block_scsi_eh() during bus reset
  visorhba: select first device on the bus for bus_reset()
  ncr53c8xx: remove 'sync_reset' argument from ncr_reset_bus()
  ncr53c8xx: Complete all commands during bus reset
  ncr53c8xx: Remove unused code
  scsi: Use Scsi_Host and channel number as argument for
    eh_bus_reset_handler()
  libiscsi: use cls_session as argument for target and session reset
  bnx2fc: Do not rely on a scsi command when issueing lun or target
    reset
  ibmvfc: open-code reset loop for target reset
  lpfc: use fc_block_rport()
  lpfc: use rport as argument for lpfc_send_taskmgmt()
  lpfc: use rport as argument for lpfc_chk_tgt_mapped()
  csiostor: use fc_block_rport()
  qla2xxx: use fc_block_rport()
  fc_fcp: use fc_block_rport()
  qedf: use fc rport as argument for qedf_initiate_tmf()
  sym53c8xx_2: rework reset handling
  bfa: Do not use scsi command to signal TMF status
  scsi_transport_iscsi: use session as argument for
    iscsi_block_scsi_eh()
  pmcraid: select first available device for target reset
  scsi: Use scsi_target as argument for eh_target_reset_handler()
  aha152x: look for stuck command when resetting device
  fnic: use dedicated device reset command
  a1000u2w: do not rely on the command for inia100_device_reset()
  aic7xxx: use scsi device as argument for BUILD_SCSIID()
  aic79xx: use scsi device as argument for BUILD_SCSIID()
  aic7xxx: do not reference scsi command when resetting device
  aic79xx: do not reference scsi command when resetting device
  xen-scsifront: add scsi device as argument to scsifront_do_request()
  fas216: Rework device reset to not rely on SCSI command pointer
  csiostor: use separate TMF command
  snic: use dedicated device reset command
  snic: Use scsi_host_busy_iter() to traverse commands
  scsi: Move eh_device_reset_handler() to use scsi_device as argument
  scsi: Do not allocate scsi command in scsi_ioctl_reset()
  scsi_error: streamline scsi_eh_bus_device_reset()

 Documentation/scsi/scsi_eh.rst                |  16 +-
 Documentation/scsi/scsi_mid_low_api.rst       |  31 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |  12 +-
 drivers/message/fusion/mptfc.c                |  99 ++++--
 drivers/message/fusion/mptsas.c               |  10 +-
 drivers/message/fusion/mptscsih.c             | 115 ++++--
 drivers/message/fusion/mptscsih.h             |   7 +-
 drivers/message/fusion/mptspi.c               |   8 +-
 drivers/s390/scsi/zfcp_scsi.c                 |  41 ++-
 drivers/scsi/3w-9xxx.c                        |  11 +-
 drivers/scsi/3w-sas.c                         |  11 +-
 drivers/scsi/3w-xxxx.c                        |  11 +-
 drivers/scsi/53c700.c                         |  39 +-
 drivers/scsi/BusLogic.c                       |  14 +-
 drivers/scsi/NCR5380.c                        |   3 +-
 drivers/scsi/a100u2w.c                        |  52 +--
 drivers/scsi/aacraid/linit.c                  |  35 +-
 drivers/scsi/advansys.c                       |  26 +-
 drivers/scsi/aha152x.c                        |  34 +-
 drivers/scsi/aha1542.c                        |  30 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c            |  64 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c            | 120 ++++---
 drivers/scsi/arcmsr/arcmsr_hba.c              |   6 +-
 drivers/scsi/arm/acornscsi.c                  |   8 +-
 drivers/scsi/arm/fas216.c                     |  55 ++-
 drivers/scsi/arm/fas216.h                     |  17 +-
 drivers/scsi/atari_scsi.c                     |   4 +-
 drivers/scsi/be2iscsi/be_main.c               |  18 +-
 drivers/scsi/bfa/bfad_im.c                    | 113 +++---
 drivers/scsi/bfa/bfad_im.h                    |   2 +
 drivers/scsi/bnx2fc/bnx2fc.h                  |   5 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c              |  14 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c               |  95 +++--
 drivers/scsi/csiostor/csio_hw.h               |   2 +
 drivers/scsi/csiostor/csio_init.c             |   2 +-
 drivers/scsi/csiostor/csio_scsi.c             |  52 ++-
 drivers/scsi/cxlflash/main.c                  |  10 +-
 drivers/scsi/dc395x.c                         |  25 +-
 drivers/scsi/dpt_i2o.c                        |  43 +--
 drivers/scsi/dpti.h                           |   6 +-
 drivers/scsi/esas2r/esas2r.h                  |   8 +-
 drivers/scsi/esas2r/esas2r_main.c             |  55 +--
 drivers/scsi/esp_scsi.c                       |   8 +-
 drivers/scsi/fdomain.c                        |   3 +-
 drivers/scsi/fnic/fnic.h                      |   4 +-
 drivers/scsi/fnic/fnic_scsi.c                 | 149 +++-----
 drivers/scsi/hpsa.c                           |  14 +-
 drivers/scsi/hptiop.c                         |   6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |  55 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  23 +-
 drivers/scsi/imm.c                            |   6 +-
 drivers/scsi/initio.c                         |  11 +-
 drivers/scsi/ipr.c                            |  35 +-
 drivers/scsi/ips.c                            |  40 +--
 drivers/scsi/libfc/fc_fcp.c                   |  18 +-
 drivers/scsi/libiscsi.c                       |  38 +-
 drivers/scsi/libsas/sas_scsi_host.c           |  21 +-
 drivers/scsi/lpfc/lpfc_scsi.c                 | 160 ++-------
 drivers/scsi/mac53c94.c                       |   8 +-
 drivers/scsi/megaraid.c                       |  46 +--
 drivers/scsi/megaraid.h                       |   2 +-
 drivers/scsi/megaraid/megaraid_mbox.c         |  14 +-
 drivers/scsi/megaraid/megaraid_sas.h          |   3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c     |  44 +--
 drivers/scsi/megaraid/megaraid_sas_fusion.c   |  56 +--
 drivers/scsi/mesh.c                           |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c               | 144 ++++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |  80 ++---
 drivers/scsi/mvumi.c                          |   7 +-
 drivers/scsi/myrb.c                           |   3 +-
 drivers/scsi/myrs.c                           |   3 +-
 drivers/scsi/ncr53c8xx.c                      | 203 +----------
 drivers/scsi/nsp32.c                          |  12 +-
 drivers/scsi/pcmcia/nsp_cs.c                  |  10 +-
 drivers/scsi/pcmcia/nsp_cs.h                  |   6 +-
 drivers/scsi/pcmcia/qlogic_stub.c             |   4 +-
 drivers/scsi/pcmcia/sym53c500_cs.c            |   8 +-
 drivers/scsi/pmcraid.c                        |  73 +++-
 drivers/scsi/ppa.c                            |   6 +-
 drivers/scsi/qedf/qedf.h                      |   5 +-
 drivers/scsi/qedf/qedf_io.c                   |  80 ++---
 drivers/scsi/qedf/qedf_main.c                 |  24 +-
 drivers/scsi/qedi/qedi_iscsi.c                |   3 +-
 drivers/scsi/qla1280.c                        |  74 ++--
 drivers/scsi/qla2xxx/qla_os.c                 | 155 ++++----
 drivers/scsi/qla4xxx/ql4_os.c                 |  85 +++--
 drivers/scsi/qlogicfas408.c                   |  10 +-
 drivers/scsi/qlogicfas408.h                   |   2 +-
 drivers/scsi/qlogicpti.c                      |   3 +-
 drivers/scsi/scsi_debug.c                     |  78 ++--
 drivers/scsi/scsi_error.c                     | 160 +++++----
 drivers/scsi/scsi_transport_iscsi.c           |   6 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |  11 +-
 drivers/scsi/snic/snic.h                      |   6 +-
 drivers/scsi/snic/snic_main.c                 |   3 +
 drivers/scsi/snic/snic_scsi.c                 | 333 ++++++++----------
 drivers/scsi/stex.c                           |   7 +-
 drivers/scsi/storvsc_drv.c                    |   4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c           | 190 ++++++----
 drivers/scsi/ufs/ufshcd.c                     |  14 +-
 drivers/scsi/virtio_scsi.c                    |  12 +-
 drivers/scsi/vmw_pvscsi.c                     |  20 +-
 drivers/scsi/wd33c93.c                        |   5 +-
 drivers/scsi/wd33c93.h                        |   2 +-
 drivers/scsi/wd719x.c                         |  17 +-
 drivers/scsi/xen-scsifront.c                  |  53 +--
 drivers/staging/rts5208/rtsx.c                |   4 +-
 .../staging/unisys/visorhba/visorhba_main.c   |  40 +--
 drivers/target/loopback/tcm_loop.c            |  17 +-
 drivers/usb/image/microtek.c                  |   4 +-
 drivers/usb/storage/scsiglue.c                |   8 +-
 drivers/usb/storage/uas.c                     |   3 +-
 include/scsi/libfc.h                          |   4 +-
 include/scsi/libiscsi.h                       |   6 +-
 include/scsi/libsas.h                         |   4 +-
 include/scsi/scsi_host.h                      |   8 +-
 include/scsi/scsi_transport_iscsi.h           |   2 +-
 117 files changed, 1960 insertions(+), 2164 deletions(-)

-- 
2.29.2

