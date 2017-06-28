From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/47] SCSI EH argument reshuffle part II
Date: Wed, 28 Jun 2017 10:32:26 +0200
Message-ID: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53636 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751492AbdF1IdQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,
finally here's the patchset to revamp the SCSI EH callback arguments
which I promised to do (some years ago ...).

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

As per request from hch the patchset has been split in two parts;
this is the second part which rearranges the individual EH handler
implementation to not rely on the passed in scsi command and do
the final conversion to the new calling convention.

The entire patchset can be found at

https://git.kernel.org/hare/scsi-devel/h/eh-reset.v3

As usual, comments and reviews are welcome.

Hannes Reinecke (47):
  aacraid: split off functions to generate reset FIB
  aacraid: split off host reset
  aacraid: split off device, target, and bus reset
  aacraid: use aac_tmf_callback for reset fib
  aacraid: enable sending of TMFs from aac_hba_send()
  aacraid: add fib flag to mark scsi command callback
  aacraid: complete all commands during bus reset
  sym53c8xx_2: split off bus reset from host reset
  zfcp: open-code fc_block_scsi_eh() for host reset
  ips: Do not try to abort command from host reset
  snic: reserve tag for TMF
  qla1280: separate out host reset function from qla1280_error_action()
  megaraid: pass in NULL scb for host reset
  scsi: Use Scsi_Host as argument for eh_host_reset_handler
  scsi_transport_fc: Use fc_rport as argument for fc_block_scsi_eh
  mptfc: simplify mpt_fc_block_error_handler()
  mptfusion: correct definitions for mptscsih_dev_reset()
  mptfc: open-code mptfc_block_error_handler() for bus reset
  pmcraid: Select device in pmcraid_eh_bus_reset_handler()
  scsi: Use Scsi_Host and channel number as argument for
    eh_bus_reset_handler()
  libiscsi: use cls_session as argument for target and session reset
  bnx2fc: Do not rely on a scsi command when issueing lun or target
    reset
  zfcp: do not rely on scsi command for debugging message
  zfcp: use scsi device as argument for zfcp_task_mgmt_function()
  ibmvfc: open-code reset loop for target reset
  lpfc: use rport as argument for lpfc_send_taskmgmt()
  lpfc: use rport as argument for lpfc_chk_tgt_mapped()
  qla2xxx: open-code qla2xxx_generic_reset()
  qedf: use fc rport as argument for qedf_initiate_tmf()
  sym53c8xx_2: rework reset handling
  bfa: Do not use scsi command to signal TMF status
  scsi: Use scsi_target as argument for eh_target_reset_handler()
  cxlflash: use dedicated reset command in send_tmf()
  aha152x: look for stuck command when resetting device
  fnic: use dedicated device reset command
  a1000u2w: do not rely on the command for inia100_device_reset()
  aic79xx: use scsi device as argument for BUILD_SCSIID()
  aic7xxx: use scsi device as argument for BUILD_SCSIID()
  aic79xx: do not reference scsi command when resetting device
  aic7xxx: do not reference scsi command when resetting device
  xen-scsifront: add scsi device as argument to scsifront_do_request()
  xen-scsifront: call scsifront_action_handler() with a NULL command
    argument
  fas216: Rework device reset to not rely on SCSI command pointer
  csiostor: use separate TMF command
  snic: use dedicated device reset command
  scsi: Move eh_device_reset_handler() to use scsi_device as argument
  scsi: Do not allocate scsi command in scsi_ioctl_reset()

 Documentation/scsi/scsi_eh.txt                  |   6 +-
 Documentation/scsi/scsi_mid_low_api.txt         |  13 +-
 arch/ia64/hp/sim/simscsi.c                      |   2 +-
 drivers/block/cciss_scsi.c                      |  14 +-
 drivers/infiniband/ulp/srp/ib_srp.c             |  14 +-
 drivers/message/fusion/mptfc.c                  |  99 +++++---
 drivers/message/fusion/mptsas.c                 |  10 +-
 drivers/message/fusion/mptscsih.c               | 117 ++++++---
 drivers/message/fusion/mptscsih.h               |   7 +-
 drivers/message/fusion/mptspi.c                 |   8 +-
 drivers/s390/scsi/zfcp_dbf.c                    |  28 +--
 drivers/s390/scsi/zfcp_dbf.h                    |  10 +-
 drivers/s390/scsi/zfcp_ext.h                    |   6 +-
 drivers/s390/scsi/zfcp_fc.h                     |   9 +-
 drivers/s390/scsi/zfcp_fsf.c                    |  21 +-
 drivers/s390/scsi/zfcp_scsi.c                   |  73 ++++--
 drivers/scsi/3w-9xxx.c                          |  11 +-
 drivers/scsi/3w-sas.c                           |  11 +-
 drivers/scsi/3w-xxxx.c                          |  11 +-
 drivers/scsi/53c700.c                           |  39 +--
 drivers/scsi/BusLogic.c                         |  14 +-
 drivers/scsi/NCR5380.c                          |   5 +-
 drivers/scsi/NCR53c406a.c                       |   6 +-
 drivers/scsi/a100u2w.c                          |  52 ++--
 drivers/scsi/aacraid/aacraid.h                  |   1 +
 drivers/scsi/aacraid/commsup.c                  |   3 +-
 drivers/scsi/aacraid/linit.c                    | 318 +++++++++++++++++-------
 drivers/scsi/advansys.c                         |  26 +-
 drivers/scsi/aha152x.c                          |  39 ++-
 drivers/scsi/aha152x.h                          |   2 +-
 drivers/scsi/aha1542.c                          |  27 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c              |  64 ++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c              | 120 ++++-----
 drivers/scsi/arcmsr/arcmsr_hba.c                |   9 +-
 drivers/scsi/arm/fas216.c                       |  67 +++--
 drivers/scsi/arm/fas216.h                       |  11 +-
 drivers/scsi/atari_scsi.c                       |   4 +-
 drivers/scsi/be2iscsi/be_main.c                 |  18 +-
 drivers/scsi/bfa/bfad_im.c                      | 113 +++++----
 drivers/scsi/bfa/bfad_im.h                      |   2 +
 drivers/scsi/bnx2fc/bnx2fc.h                    |   5 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                |  14 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |  97 ++++----
 drivers/scsi/csiostor/csio_hw.h                 |   2 +
 drivers/scsi/csiostor/csio_init.c               |   2 +-
 drivers/scsi/csiostor/csio_scsi.c               |  53 ++--
 drivers/scsi/cxlflash/common.h                  |   3 +-
 drivers/scsi/cxlflash/main.c                    |  51 ++--
 drivers/scsi/dc395x.c                           |  25 +-
 drivers/scsi/dpt_i2o.c                          |  43 ++--
 drivers/scsi/dpti.h                             |   6 +-
 drivers/scsi/eata.c                             |  10 +-
 drivers/scsi/eata_pio.c                         |  29 ++-
 drivers/scsi/esas2r/esas2r.h                    |   8 +-
 drivers/scsi/esas2r/esas2r_main.c               |  55 ++--
 drivers/scsi/esp_scsi.c                         |   8 +-
 drivers/scsi/fdomain.c                          |   2 +-
 drivers/scsi/fdomain.h                          |   2 +-
 drivers/scsi/fnic/fnic.h                        |   4 +-
 drivers/scsi/fnic/fnic_main.c                   |   2 +
 drivers/scsi/fnic/fnic_scsi.c                   | 117 ++++-----
 drivers/scsi/gdth.c                             |  16 +-
 drivers/scsi/hpsa.c                             |  14 +-
 drivers/scsi/hptiop.c                           |   6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                  |  58 +++--
 drivers/scsi/ibmvscsi/ibmvscsi.c                |  23 +-
 drivers/scsi/imm.c                              |   6 +-
 drivers/scsi/initio.c                           |  11 +-
 drivers/scsi/ipr.c                              |  35 +--
 drivers/scsi/ips.c                              |  40 +--
 drivers/scsi/libfc/fc_fcp.c                     |  18 +-
 drivers/scsi/libiscsi.c                         |  38 ++-
 drivers/scsi/libsas/sas_scsi_host.c             |  21 +-
 drivers/scsi/lpfc/lpfc_scsi.c                   |  67 +++--
 drivers/scsi/mac53c94.c                         |   8 +-
 drivers/scsi/megaraid.c                         |  46 ++--
 drivers/scsi/megaraid.h                         |   2 +-
 drivers/scsi/megaraid/megaraid_mbox.c           |  14 +-
 drivers/scsi/megaraid/megaraid_sas.h            |   3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c       |  38 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c     |  47 ++--
 drivers/scsi/mesh.c                             |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            |  77 +++---
 drivers/scsi/mvumi.c                            |   7 +-
 drivers/scsi/ncr53c8xx.c                        |   4 +-
 drivers/scsi/nsp32.c                            |  12 +-
 drivers/scsi/pcmcia/aha152x_stub.c              |   2 +-
 drivers/scsi/pcmcia/nsp_cs.c                    |  10 +-
 drivers/scsi/pcmcia/qlogic_stub.c               |   4 +-
 drivers/scsi/pcmcia/sym53c500_cs.c              |   8 +-
 drivers/scsi/pmcraid.c                          |  75 ++++--
 drivers/scsi/ppa.c                              |   6 +-
 drivers/scsi/qedf/qedf.h                        |   5 +-
 drivers/scsi/qedf/qedf_io.c                     |  48 ++--
 drivers/scsi/qedf/qedf_main.c                   |  16 +-
 drivers/scsi/qedi/qedi_iscsi.c                  |   3 +-
 drivers/scsi/qla1280.c                          |  72 +++---
 drivers/scsi/qla2xxx/qla_os.c                   | 167 +++++++------
 drivers/scsi/qla4xxx/ql4_os.c                   |  85 ++++---
 drivers/scsi/qlogicfas408.c                     |  10 +-
 drivers/scsi/qlogicfas408.h                     |   2 +-
 drivers/scsi/scsi_debug.c                       |  86 +++----
 drivers/scsi/scsi_error.c                       | 160 ++++++------
 drivers/scsi/scsi_transport_fc.c                |   7 +-
 drivers/scsi/scsi_transport_iscsi.c             |   6 +-
 drivers/scsi/smartpqi/smartpqi_init.c           |   6 +-
 drivers/scsi/snic/snic.h                        |   6 +-
 drivers/scsi/snic/snic_main.c                   |   3 +
 drivers/scsi/snic/snic_scsi.c                   | 126 ++++------
 drivers/scsi/stex.c                             |   7 +-
 drivers/scsi/storvsc_drv.c                      |   4 +-
 drivers/scsi/sym53c416.c                        |  16 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c             | 190 ++++++++------
 drivers/scsi/ufs/ufshcd.c                       |  24 +-
 drivers/scsi/virtio_scsi.c                      |  14 +-
 drivers/scsi/vmw_pvscsi.c                       |  20 +-
 drivers/scsi/wd33c93.c                          |   4 +-
 drivers/scsi/wd33c93.h                          |   2 +-
 drivers/scsi/wd719x.c                           |  17 +-
 drivers/scsi/xen-scsifront.c                    |  54 ++--
 drivers/staging/rts5208/rtsx.c                  |   4 +-
 drivers/staging/unisys/visorhba/visorhba_main.c |  42 ++--
 drivers/target/loopback/tcm_loop.c              |  17 +-
 drivers/usb/image/microtek.c                    |   4 +-
 drivers/usb/storage/scsiglue.c                  |   8 +-
 drivers/usb/storage/uas.c                       |   3 +-
 include/scsi/libfc.h                            |   4 +-
 include/scsi/libiscsi.h                         |   6 +-
 include/scsi/libsas.h                           |   4 +-
 include/scsi/scsi_host.h                        |   8 +-
 include/scsi/scsi_transport_fc.h                |   2 +-
 include/scsi/scsi_transport_iscsi.h             |   2 +-
 132 files changed, 2093 insertions(+), 1845 deletions(-)

-- 
1.8.5.6
