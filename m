From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5][RFC] Support 64-bit LUNs
Date: Tue, 10 Dec 2013 12:05:10 +0100
Message-ID: <1386673515-87133-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab3LJLFU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 06:05:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this patchset updates the SCSI stack to support full 64-bit LUNs.
The first patch is a simple fix; the next two patches update
the sequential scan logic to be compliant with SPC.
The last two patches update the SCSI stack and all drivers
to use 64-bit LUNs where appropriate.

The patchset is marked as an RFC as I've had to do
some modifications to existing drivers, and would like
to have the individual maintainers a cross-check here.

In particular the qla2xxx driver (currently) uses a 32-bit
LUN for TMFs; I've updated that to 64-bit but the change
needs to be validated.
The zfcp driver uses a 32-bit LUN for debug records; the
record format would need to be updated to cope with 64-bit LUNs.

The other changes have been pretty straightforward.

Hannes Reinecke (5):
  scsi: Remove CONFIG_SCSI_MULTI_LUN
  scsi_scan: Restrict sequential scan to 256 LUNs
  qla2xxx: Restrict max_luns to 16-bit for older HBAs
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
 drivers/scsi/qla2xxx/qla_init.c      |  4 +--
 drivers/scsi/qla2xxx/qla_iocb.c      | 14 ++++----
 drivers/scsi/qla2xxx/qla_isr.c       |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c       | 12 +++----
 drivers/scsi/qla2xxx/qla_mr.c        | 10 +++---
 drivers/scsi/qla2xxx/qla_os.c        | 46 ++++++++++++++----------
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
 69 files changed, 301 insertions(+), 313 deletions(-)

-- 
1.7.12.4

