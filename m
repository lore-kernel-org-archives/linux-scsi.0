From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/7] Use 'Scsi_Host' as argument for host reset
Date: Fri, 27 Jun 2014 08:26:58 +0200
Message-ID: <1403850425-89297-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbaF0G1J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 02:27:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

eh_host_reset_handler can only depend on the Scsi_Host, so
we should make that explicit by using 'struct Scsi_Host' as
argument for it.

This uncovered issues with some FC HBAs; calling
'fc_block_scsi_eh' _before_ host reset is not only pointless
(the host reset will reset the rport state anyway), but
downright wrong as the rport might have been vanished
altogether, and indeed be the cause for the host reset
in the first place.

Hannes Reinecke (7):
  scsi: fix comment in scsi_device_set_state()
  mptfc: Do not call fc_block_scsi_eh() on host reset
  ibmvfc: Do not call fc_block_scsi_eh() on host reset
  libfc: Do not call fc_block_scsi_eh() on host reset
  scsi_transport_fc: Use fc_rport as argument for fc_block_scsi_eh
  scsi: Use Scsi_Host as argument for eh_host_reset_handler
  scsi_error: do not use command list for host reset

 Documentation/scsi/scsi_eh.txt            |  2 +-
 Documentation/scsi/scsi_mid_low_api.txt   |  4 +--
 arch/ia64/hp/sim/simscsi.c                |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |  4 +--
 drivers/message/fusion/mptfc.c            | 10 +------
 drivers/message/fusion/mptscsih.c         | 18 ++++++------
 drivers/message/fusion/mptscsih.h         |  2 +-
 drivers/s390/scsi/zfcp_scsi.c             | 12 +++++---
 drivers/scsi/3w-9xxx.c                    | 11 ++++----
 drivers/scsi/3w-sas.c                     | 11 ++++----
 drivers/scsi/3w-xxxx.c                    | 11 ++++----
 drivers/scsi/53c700.c                     | 15 +++++-----
 drivers/scsi/BusLogic.c                   | 13 +++------
 drivers/scsi/NCR53c406a.c                 |  6 ++--
 drivers/scsi/aacraid/linit.c              | 14 ++++-----
 drivers/scsi/aha152x.c                    | 11 +-------
 drivers/scsi/aha152x.h                    |  2 +-
 drivers/scsi/aha1542.c                    | 22 +++++++--------
 drivers/scsi/arm/fas216.c                 |  8 +++---
 drivers/scsi/arm/fas216.h                 |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c           |  4 +--
 drivers/scsi/csiostor/csio_scsi.c         |  4 +--
 drivers/scsi/dpt_i2o.c                    | 14 ++++-----
 drivers/scsi/dpti.h                       |  2 +-
 drivers/scsi/eata.c                       | 19 +++----------
 drivers/scsi/eata_pio.c                   | 29 +++++++++----------
 drivers/scsi/esas2r/esas2r.h              |  2 +-
 drivers/scsi/esas2r/esas2r_main.c         | 16 ++++++-----
 drivers/scsi/esp_scsi.c                   |  4 +--
 drivers/scsi/fnic/fnic.h                  |  2 +-
 drivers/scsi/fnic/fnic_scsi.c             | 21 ++++++++------
 drivers/scsi/ibmvscsi/ibmvfc.c            | 17 ++++++-----
 drivers/scsi/ibmvscsi/ibmvscsi.c          |  4 +--
 drivers/scsi/imm.c                        |  7 ++---
 drivers/scsi/ipr.c                        |  4 +--
 drivers/scsi/ips.c                        | 40 ++++++--------------------
 drivers/scsi/libfc/fc_fcp.c               | 12 ++++----
 drivers/scsi/lpfc/lpfc_scsi.c             | 15 ++++++----
 drivers/scsi/mac53c94.c                   |  8 +++---
 drivers/scsi/megaraid.c                   | 16 +++++------
 drivers/scsi/megaraid.h                   |  2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     | 16 +++--------
 drivers/scsi/megaraid/megaraid_sas_base.c | 32 +++++----------------
 drivers/scsi/mesh.c                       | 10 +++----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      | 13 ++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 13 ++++-----
 drivers/scsi/mvumi.c                      |  7 ++---
 drivers/scsi/nsp32.c                      | 14 ++++-----
 drivers/scsi/pcmcia/aha152x_stub.c        |  2 +-
 drivers/scsi/pcmcia/nsp_cs.c              |  4 +--
 drivers/scsi/pcmcia/sym53c500_cs.c        |  8 +++---
 drivers/scsi/pmcraid.c                    |  4 +--
 drivers/scsi/ppa.c                        |  7 ++---
 drivers/scsi/qla1280.c                    | 23 ++++++++++++---
 drivers/scsi/qla2xxx/qla_os.c             | 38 ++++++++++++-------------
 drivers/scsi/qla4xxx/ql4_os.c             | 16 +++++------
 drivers/scsi/scsi_debug.c                 |  2 +-
 drivers/scsi/scsi_error.c                 | 42 ++++++++++-----------------
 drivers/scsi/scsi_lib.c                   |  2 +-
 drivers/scsi/scsi_transport_fc.c          |  7 ++---
 drivers/scsi/sgiwd93.c                    | 15 ----------
 drivers/scsi/stex.c                       |  5 ++--
 drivers/scsi/storvsc_drv.c                |  4 +--
 drivers/scsi/sym53c416.c                  |  6 ++--
 drivers/scsi/sym53c8xx_2/sym_glue.c       | 47 +++++++++++++++++++++----------
 drivers/scsi/u14-34f.c                    | 17 ++++-------
 drivers/scsi/ultrastor.c                  |  7 ++---
 drivers/scsi/vmw_pvscsi.c                 |  5 ++--
 drivers/scsi/wd33c93.c                    |  7 ++---
 drivers/scsi/wd33c93.h                    |  2 +-
 drivers/scsi/wd7000.c                     | 10 +++----
 drivers/usb/image/microtek.c              |  4 +--
 include/scsi/libfc.h                      |  2 +-
 include/scsi/scsi_host.h                  |  2 +-
 include/scsi/scsi_transport_fc.h          |  2 +-
 75 files changed, 361 insertions(+), 456 deletions(-)

-- 
1.7.12.4

