From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/28] SCSI EH argument reshuffle part I
Date: Wed, 28 Jun 2017 10:24:48 +0200
Message-ID: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52873 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751548AbdF1IbB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:01 -0400
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
this is the first part which just does a general EH function cleanup
without introducing any functional differences.

As usual, comments and reviews are welcome.

Hannes Reinecke (28):
  scsi: fix comment in scsi_device_set_state()
  mptfc: Do not call fc_block_scsi_eh() on host reset
  ibmvfc: Do not call fc_block_scsi_eh() on host reset
  fc_fcp: do not call fc_block_scsi_eh() from host reset
  fnic: do not call host reset from command abort
  uas: move eh_bus_reset_handler to eh_device_reset_handler
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
  imm: drop duplicate bus_reset handler
  ppa: drop duplicate bus_reset handler
  qedf: drop bus reset handler
  nsp32: drop bus reset
  aha152x: drop bus reset
  53c700: move bus reset to host reset
  bnx2fc: remove obsolete bnx2fc_eh_host_reset() definition
  megaraid_mbox: drop duplicate bus reset and device reset function
  lpfc: drop lpfc_no_handler and lpfc_bus_reset_handler()
  visorhba: sanitze private device data allocation
  eata: remove 'arg_done' from eata2x_eh_host_reset()
  NCR5380: Clear all unissued commands on host reset

 drivers/message/fusion/mptfc.c                  |  10 +-
 drivers/scsi/53c700.c                           |  22 +----
 drivers/scsi/NCR5380.c                          |  11 ++-
 drivers/scsi/a2091.c                            |  17 ----
 drivers/scsi/a3000.c                            |  17 ----
 drivers/scsi/aha152x.c                          |  10 --
 drivers/scsi/aic94xx/aic94xx_init.c             |   2 +-
 drivers/scsi/arm/acornscsi.c                    |  11 ++-
 drivers/scsi/arm/cumana_1.c                     |   2 +-
 drivers/scsi/arm/oak.c                          |   2 +-
 drivers/scsi/atari_scsi.c                       |   6 +-
 drivers/scsi/bfa/bfad_im.c                      |  37 +++----
 drivers/scsi/bnx2fc/bnx2fc.h                    |   1 -
 drivers/scsi/dmx3191d.c                         |   2 +-
 drivers/scsi/eata.c                             |   9 +-
 drivers/scsi/fdomain.c                          |   6 +-
 drivers/scsi/fdomain.h                          |   2 +-
 drivers/scsi/fnic/fnic_scsi.c                   |   4 -
 drivers/scsi/g_NCR5380.c                        |   4 +-
 drivers/scsi/gvp11.c                            |  18 ----
 drivers/scsi/hisi_sas/hisi_sas_main.c           |   2 +-
 drivers/scsi/hptiop.c                           |  11 +--
 drivers/scsi/ibmvscsi/ibmvfc.c                  |   6 +-
 drivers/scsi/imm.c                              |   1 -
 drivers/scsi/isci/init.c                        |   2 +-
 drivers/scsi/libfc/fc_fcp.c                     |   2 -
 drivers/scsi/libsas/sas_scsi_host.c             |  12 +--
 drivers/scsi/lpfc/lpfc_scsi.c                   |  99 -------------------
 drivers/scsi/mac_scsi.c                         |   4 +-
 drivers/scsi/megaraid/megaraid_mbox.c           |   2 -
 drivers/scsi/mvme147.c                          |  16 ---
 drivers/scsi/mvsas/mv_init.c                    |   2 +-
 drivers/scsi/nsp32.c                            |  22 +----
 drivers/scsi/pcmcia/fdomain_stub.c              |   2 +-
 drivers/scsi/pcmcia/qlogic_stub.c               |   4 +-
 drivers/scsi/pm8001/pm8001_init.c               |   2 +-
 drivers/scsi/ppa.c                              |   1 -
 drivers/scsi/qedf/qedf_main.c                   |  11 ---
 drivers/scsi/qlogicfas.c                        |   2 +-
 drivers/scsi/qlogicfas408.c                     |   6 +-
 drivers/scsi/qlogicfas408.h                     |   2 +-
 drivers/scsi/qlogicpti.c                        |   5 +-
 drivers/scsi/scsi_lib.c                         |   2 +-
 drivers/scsi/sgiwd93.c                          |  15 ---
 drivers/scsi/sun3_scsi.c                        |   4 +-
 drivers/scsi/wd33c93.c                          |   2 +
 drivers/staging/rts5208/rtsx.c                  |  11 ---
 drivers/staging/unisys/visorhba/visorhba_main.c | 123 ++++++++++--------------
 drivers/usb/storage/uas.c                       |   4 +-
 include/scsi/libsas.h                           |   2 +-
 50 files changed, 135 insertions(+), 437 deletions(-)

-- 
1.8.5.6
