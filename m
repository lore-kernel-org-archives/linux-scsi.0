From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/5] Support 64-bit LUNs
Date: Tue, 20 May 2014 13:03:06 +0200
Message-ID: <1400583791-123120-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbaETLDP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2014 07:03:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

Hi all,

this patchset updates the SCSI stack to support full 64-bit LUNs.
The first patch is a simple fix; the next patch updates
the sequential scan logic to be compliant with SPC.
The third patch addresses a firmware issue with earlier
qla2xxx HBAs.
The last two patches update the SCSI stack and all drivers
to use 64-bit LUNs where appropriate.

Two drivers have issues with 64bit LUNs:
- The qla2xxx driver uses a 32-bit LUN value for TMFs.
  But as the driver uses a max_lun value from 0xFFFF
  we should be safe for the time being.
- The zfcp driver uses a 32-bit LUN for debug records; the
  record format would need to be updated to cope with
  64-bit LUNs. But again, this driver uses 0xFFFFFFFF
  for max_lun, so it doesn't do any harm.

The other changes have been pretty straightforward.

Hannes Reinecke (5):
  scsi: Remove CONFIG_SCSI_MULTI_LUN
  scsi_scan: Restrict sequential scan to 256 LUNs
  qla2xxx: Restrict max_lun to 16-bit for older HBAs
  scsi: use 64-bit LUNs
  scsi: use 64-bit value for 'max_luns'

 drivers/ata/libata-scsi.c            |  2 +-
 drivers/ata/libata.h                 |  2 +-
 drivers/message/fusion/mptscsih.c    |  2 +-
 drivers/message/i2o/i2o_scsi.c       | 11 +++---
 drivers/s390/scsi/zfcp_dbf.c         |  3 +-
 drivers/s390/scsi/zfcp_unit.c        |  4 +--
 drivers/scsi/Kconfig                 | 14 --------
 drivers/scsi/NCR5380.c               |  2 +-
 drivers/scsi/aacraid/linit.c         |  2 +-
 drivers/scsi/aha152x.c               |  6 ++--
 drivers/scsi/aic7xxx/aic79xx.h       |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c   |  6 ++--
 drivers/scsi/aic7xxx/aic79xx_proc.c  |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c   | 11 +++---
 drivers/scsi/aic7xxx/aic7xxx_proc.c  |  2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c     |  8 ++---
 drivers/scsi/csiostor/csio_scsi.c    | 24 ++++++-------
 drivers/scsi/cxgbi/libcxgbi.c        |  2 +-
 drivers/scsi/cxgbi/libcxgbi.h        |  2 +-
 drivers/scsi/dc395x.c                | 51 ++++++++++++--------------
 drivers/scsi/eata.c                  |  4 +--
 drivers/scsi/fnic/fnic_scsi.c        |  4 +--
 drivers/scsi/hpsa.c                  |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c       |  4 +--
 drivers/scsi/libiscsi.c              |  8 ++---
 drivers/scsi/libsas/sas_scsi_host.c  | 11 +++---
 drivers/scsi/lpfc/lpfc_attr.c        | 10 +++++-
 drivers/scsi/lpfc/lpfc_scsi.c        | 32 ++++++++---------
 drivers/scsi/megaraid.c              |  6 ++--
 drivers/scsi/megaraid/mega_common.h  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 +--
 drivers/scsi/ncr53c8xx.h             |  4 ---
 drivers/scsi/pmcraid.c               |  2 +-
 drivers/scsi/qla2xxx/qla_def.h       |  6 ++--
 drivers/scsi/qla2xxx/qla_gbl.h       | 18 +++++-----
 drivers/scsi/qla2xxx/qla_iocb.c      | 11 +++---
 drivers/scsi/qla2xxx/qla_isr.c       |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c       | 12 +++----
 drivers/scsi/qla2xxx/qla_mr.c        |  8 ++---
 drivers/scsi/qla2xxx/qla_os.c        | 48 ++++++++++++++-----------
 drivers/scsi/qla4xxx/ql4_glbl.h      |  4 +--
 drivers/scsi/qla4xxx/ql4_iocb.c      |  2 +-
 drivers/scsi/qla4xxx/ql4_isr.c       | 22 ++++++------
 drivers/scsi/qla4xxx/ql4_mbx.c       |  6 ++--
 drivers/scsi/qla4xxx/ql4_os.c        | 18 +++++-----
 drivers/scsi/scsi.c                  |  8 ++---
 drivers/scsi/scsi_debug.c            | 15 ++++----
 drivers/scsi/scsi_priv.h             |  2 +-
 drivers/scsi/scsi_proc.c             |  2 +-
 drivers/scsi/scsi_scan.c             | 70 +++++++++++++++---------------------
 drivers/scsi/scsi_sysfs.c            | 14 ++++----
 drivers/scsi/scsi_transport_fc.c     |  4 +--
 drivers/scsi/scsi_transport_iscsi.c  |  4 +--
 drivers/scsi/scsi_transport_sas.c    |  2 +-
 drivers/scsi/sg.c                    |  4 +--
 drivers/scsi/sym53c8xx_2/sym_glue.c  |  2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h  |  2 +-
 drivers/target/loopback/tcm_loop.c   |  2 +-
 drivers/target/target_core_pscsi.c   | 12 +++----
 drivers/usb/storage/sddr09.c         |  4 +--
 drivers/usb/storage/usb.c            | 10 +++---
 include/linux/moduleparam.h          |  5 +++
 include/scsi/scsi.h                  |  2 +-
 include/scsi/scsi_device.h           | 22 ++++++------
 include/scsi/scsi_devinfo.h          |  2 ++
 include/scsi/scsi_host.h             |  6 ++--
 include/scsi/scsi_transport.h        |  2 +-
 kernel/params.c                      |  1 +
 68 files changed, 298 insertions(+), 309 deletions(-)

-- 
1.7.12.4

