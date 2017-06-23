From: Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 00/35] SCSI EH argument reshuffling
Date: Fri, 23 Jun 2017 15:02:20 +0200
Message-ID: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60985 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751256AbdFWNDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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
call the function directly. Which should make hch happy :-)

It's marked as an RFC as I'm not sure if everyone agrees with this
approach; hence speak up folks!

As usual, comments and reviews are welcome.

Hannes Reinecke (35):
  scsi: fix comment in scsi_device_set_state()
  mptfc: Do not call fc_block_scsi_eh() on host reset
  ibmvfc: Do not call fc_block_scsi_eh() on host reset
  fc_fcp: do not call fc_block_scsi_eh() from host reset
  fnic: do not call host reset from command abort
  visorhba: sanitze private device data allocation
  uas: move eh_bus_reset_handler to eh_device_reset_handler
  lpfc: drop lpfc_no_handler and lpfc_bus_reset_handler()
  libsas: move bus_reset_handler() to target_reset_handler()
  bfa: move bus reset to target reset
  hptiop: Simplify reset handling
  fdomain: move bus reset to host reset
  scsi: drop bus reset for wd33c93-compatible boards
  rtsx: drop bus reset function
  qlogicpti: move bus reset to host reset
  acornscsi: move bus reset to host reset
  NCR5380: Move bus reset to host reset
  qlogicfas: move bus_reset to host_reset
  aacraid: split off lun reset function
  sym53c8xx_2: split off bus reset from host reset
  zfcp: open-code fc_block_scsi_eh() for host reset
  scsi: Use Scsi_Host as argument for eh_host_reset_handler
  qedf: drop bus reset handler
  scsi_transport_fc: Use fc_rport as argument for fc_block_scsi_eh
  mptfc: simplify mpt_fc_block_error_handler()
  mptfusion: correct definitions for mptscsih_dev_reset()
  scsi: Use Scsi_Host and channel number as argument for
    eh_bus_reset_handler()
  libiscsi: use cls_session as argument for target and session reset
  bnx2fc: remove obsolete bnx2fc_eh_host_reset() definition
  bnx2fc: Do not rely on a scsi command when issueing lun or target
    reset
  zfcp: do not rely on scsi command for debugging message
  zfcp: use scsi device as argument for zfcp_task_mgmt_function()
  scsi: Use scsi_target as argument for eh_target_reset_handler()
  scsi: Move eh_device_reset_handler() to use scsi_device as argument
  scsi: Do not allocate scsi command in scsi_ioctl_reset()

 Documentation/scsi/scsi_eh.txt                  |   6 +-
 Documentation/scsi/scsi_mid_low_api.txt         |  13 +-
 arch/ia64/hp/sim/simscsi.c                      |   2 +-
 drivers/block/cciss_scsi.c                      |  13 +-
 drivers/infiniband/ulp/srp/ib_srp.c             |  14 +-
 drivers/message/fusion/mptfc.c                  | 106 +++++++++------
 drivers/message/fusion/mptsas.c                 |  10 +-
 drivers/message/fusion/mptscsih.c               | 113 ++++++++++------
 drivers/message/fusion/mptscsih.h               |   7 +-
 drivers/message/fusion/mptspi.c                 |   8 +-
 drivers/s390/scsi/zfcp_dbf.c                    |  28 ++--
 drivers/s390/scsi/zfcp_dbf.h                    |  10 +-
 drivers/s390/scsi/zfcp_ext.h                    |   6 +-
 drivers/s390/scsi/zfcp_fc.h                     |   9 +-
 drivers/s390/scsi/zfcp_fsf.c                    |  21 +--
 drivers/s390/scsi/zfcp_scsi.c                   |  73 +++++++---
 drivers/scsi/3w-9xxx.c                          |  11 +-
 drivers/scsi/3w-sas.c                           |  11 +-
 drivers/scsi/3w-xxxx.c                          |  11 +-
 drivers/scsi/53c700.c                           |  51 +++----
 drivers/scsi/BusLogic.c                         |  14 +-
 drivers/scsi/NCR5380.c                          |  16 ++-
 drivers/scsi/NCR53c406a.c                       |   6 +-
 drivers/scsi/a100u2w.c                          |  51 +++----
 drivers/scsi/a2091.c                            |  17 ---
 drivers/scsi/a3000.c                            |  17 ---
 drivers/scsi/aacraid/linit.c                    | 127 ++++++++++++------
 drivers/scsi/advansys.c                         |  26 ++--
 drivers/scsi/aha152x.c                          |  19 +--
 drivers/scsi/aha152x.h                          |   2 +-
 drivers/scsi/aha1542.c                          |  27 ++--
 drivers/scsi/aic7xxx/aic79xx_osm.c              |  64 ++++-----
 drivers/scsi/aic7xxx/aic7xxx_osm.c              |  96 +++++++-------
 drivers/scsi/aic94xx/aic94xx_init.c             |   2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                |   9 +-
 drivers/scsi/arm/acornscsi.c                    |  11 +-
 drivers/scsi/arm/cumana_1.c                     |   2 +-
 drivers/scsi/arm/fas216.c                       |  67 +++++-----
 drivers/scsi/arm/fas216.h                       |  11 +-
 drivers/scsi/arm/oak.c                          |   2 +-
 drivers/scsi/atari_scsi.c                       |   6 +-
 drivers/scsi/be2iscsi/be_main.c                 |  18 ++-
 drivers/scsi/bfa/bfad_im.c                      |  52 ++++----
 drivers/scsi/bnx2fc/bnx2fc.h                    |   6 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                |  14 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |  97 +++++++-------
 drivers/scsi/csiostor/csio_scsi.c               |  43 +++---
 drivers/scsi/cxlflash/main.c                    |  28 ++--
 drivers/scsi/dc395x.c                           |  25 ++--
 drivers/scsi/dmx3191d.c                         |   2 +-
 drivers/scsi/dpt_i2o.c                          |  43 +++---
 drivers/scsi/dpti.h                             |   6 +-
 drivers/scsi/eata.c                             |  19 +--
 drivers/scsi/eata_pio.c                         |  29 ++--
 drivers/scsi/esas2r/esas2r.h                    |   8 +-
 drivers/scsi/esas2r/esas2r_main.c               |  55 ++++----
 drivers/scsi/esp_scsi.c                         |   8 +-
 drivers/scsi/fdomain.c                          |   6 +-
 drivers/scsi/fdomain.h                          |   2 +-
 drivers/scsi/fnic/fnic.h                        |   4 +-
 drivers/scsi/fnic/fnic_main.c                   |   2 +
 drivers/scsi/fnic/fnic_scsi.c                   | 100 +++++---------
 drivers/scsi/g_NCR5380.c                        |   4 +-
 drivers/scsi/gdth.c                             |  16 +--
 drivers/scsi/gvp11.c                            |  18 ---
 drivers/scsi/hisi_sas/hisi_sas_main.c           |   2 +-
 drivers/scsi/hpsa.c                             |  14 +-
 drivers/scsi/hptiop.c                           |  11 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                  |  27 ++--
 drivers/scsi/ibmvscsi/ibmvscsi.c                |  21 +--
 drivers/scsi/imm.c                              |   7 +-
 drivers/scsi/initio.c                           |  11 +-
 drivers/scsi/ipr.c                              |  35 ++---
 drivers/scsi/ips.c                              |  40 ++----
 drivers/scsi/isci/init.c                        |   2 +-
 drivers/scsi/libfc/fc_fcp.c                     |  20 ++-
 drivers/scsi/libiscsi.c                         |  38 +++---
 drivers/scsi/libsas/sas_scsi_host.c             |  29 ++--
 drivers/scsi/lpfc/lpfc_scsi.c                   | 164 +++++------------------
 drivers/scsi/mac53c94.c                         |   8 +-
 drivers/scsi/mac_scsi.c                         |   4 +-
 drivers/scsi/megaraid.c                         |  12 +-
 drivers/scsi/megaraid.h                         |   2 +-
 drivers/scsi/megaraid/megaraid_mbox.c           |  16 +--
 drivers/scsi/megaraid/megaraid_sas.h            |   3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c       |  38 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c     |  47 ++++---
 drivers/scsi/mesh.c                             |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            |  77 ++++++-----
 drivers/scsi/mvme147.c                          |  16 ---
 drivers/scsi/mvsas/mv_init.c                    |   2 +-
 drivers/scsi/mvumi.c                            |   7 +-
 drivers/scsi/ncr53c8xx.c                        |   4 +-
 drivers/scsi/nsp32.c                            |  26 ++--
 drivers/scsi/pcmcia/aha152x_stub.c              |   2 +-
 drivers/scsi/pcmcia/nsp_cs.c                    |  10 +-
 drivers/scsi/pcmcia/qlogic_stub.c               |   4 +-
 drivers/scsi/pcmcia/sym53c500_cs.c              |   8 +-
 drivers/scsi/pm8001/pm8001_init.c               |   2 +-
 drivers/scsi/pmcraid.c                          |  73 +++++++---
 drivers/scsi/ppa.c                              |   7 +-
 drivers/scsi/qedf/qedf.h                        |   5 +-
 drivers/scsi/qedf/qedf_io.c                     |  48 +++----
 drivers/scsi/qedf/qedf_main.c                   |  27 ++--
 drivers/scsi/qedi/qedi_iscsi.c                  |   3 +-
 drivers/scsi/qla1280.c                          |  54 ++++++--
 drivers/scsi/qla2xxx/qla_mbx.c                  |   1 -
 drivers/scsi/qla2xxx/qla_os.c                   | 160 +++++++++++-----------
 drivers/scsi/qla4xxx/ql4_os.c                   |  83 ++++++------
 drivers/scsi/qlogicfas.c                        |   2 +-
 drivers/scsi/qlogicfas408.c                     |   6 +-
 drivers/scsi/qlogicfas408.h                     |   2 +-
 drivers/scsi/qlogicpti.c                        |   5 +-
 drivers/scsi/scsi_debug.c                       |  86 +++++-------
 drivers/scsi/scsi_error.c                       | 150 ++++++++++-----------
 drivers/scsi/scsi_lib.c                         |   2 +-
 drivers/scsi/scsi_transport_fc.c                |   7 +-
 drivers/scsi/scsi_transport_iscsi.c             |   6 +-
 drivers/scsi/sgiwd93.c                          |  15 ---
 drivers/scsi/smartpqi/smartpqi_init.c           |   6 +-
 drivers/scsi/snic/snic.h                        |   5 +-
 drivers/scsi/snic/snic_main.c                   |   2 +-
 drivers/scsi/snic/snic_scsi.c                   |  99 +++++---------
 drivers/scsi/stex.c                             |   7 +-
 drivers/scsi/storvsc_drv.c                      |   4 +-
 drivers/scsi/sun3_scsi.c                        |   4 +-
 drivers/scsi/sym53c416.c                        |  16 +--
 drivers/scsi/sym53c8xx_2/sym_glue.c             | 169 ++++++++++++++++--------
 drivers/scsi/ufs/ufshcd.c                       |  24 ++--
 drivers/scsi/virtio_scsi.c                      |  14 +-
 drivers/scsi/vmw_pvscsi.c                       |  20 ++-
 drivers/scsi/wd33c93.c                          |   4 +-
 drivers/scsi/wd33c93.h                          |   2 +-
 drivers/scsi/wd719x.c                           |  17 +--
 drivers/scsi/xen-scsifront.c                    |  12 +-
 drivers/staging/rts5208/rtsx.c                  |  15 +--
 drivers/staging/unisys/visorhba/visorhba_main.c | 133 ++++++++-----------
 drivers/target/loopback/tcm_loop.c              |  17 +--
 drivers/usb/image/microtek.c                    |   4 +-
 drivers/usb/storage/scsiglue.c                  |   8 +-
 drivers/usb/storage/uas.c                       |   5 +-
 include/scsi/libfc.h                            |   4 +-
 include/scsi/libiscsi.h                         |   6 +-
 include/scsi/libsas.h                           |   4 +-
 include/scsi/scsi_host.h                        |   8 +-
 include/scsi/scsi_transport_fc.h                |   2 +-
 include/scsi/scsi_transport_iscsi.h             |   2 +-
 147 files changed, 1825 insertions(+), 1969 deletions(-)

-- 
1.8.5.6
