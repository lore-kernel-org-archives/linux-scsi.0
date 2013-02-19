From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] scsi: 64-bit LUN support
Date: Tue, 19 Feb 2013 09:17:59 +0100
Message-ID: <1361261883-41467-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab3BSISJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 03:18:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>

This patchset updates the SCSI midlayer to use 64-bit LUNs internally.
It eliminates the need to limit the number of LUNs artificially to
avoid aliasing issues; the SCSI midlayer can now accept any LUN presented
to it.

The LLDD specific settings for 'max_lun' have been left untouched;
it should be raised to '~0' if the HBA supports 64-bit LUNs internally.
However, it is up to the driver maintainer to raise that limit.

Hannes Reinecke (4):
  scsi_scan: Fixup scsilun_to_int()
  scsi: use 64-bit LUNs
  scsi: use 64-bit value for 'max_luns'
  scsi: Remove CONFIG_SCSI_MULTI_LUN

 drivers/ata/libata-scsi.c               |    2 +-
 drivers/ata/libata.h                    |    2 +-
 drivers/message/fusion/mptscsih.c       |    2 +-
 drivers/message/i2o/i2o_scsi.c          |    6 +-
 drivers/scsi/Kconfig                    |   14 ------
 drivers/scsi/NCR5380.c                  |    2 +-
 drivers/scsi/aacraid/linit.c            |    2 +-
 drivers/scsi/aha152x.c                  |    6 +-
 drivers/scsi/aic7xxx/aic79xx.h          |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c      |    6 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c      |   11 +++--
 drivers/scsi/aic7xxx_old.c              |   21 +++++----
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c        |    8 ++--
 drivers/scsi/csiostor/csio_scsi.c       |   24 +++++-----
 drivers/scsi/cxgbi/libcxgbi.c           |    2 +-
 drivers/scsi/cxgbi/libcxgbi.h           |    2 +-
 drivers/scsi/dc395x.c                   |   52 ++++++++++------------
 drivers/scsi/eata.c                     |    4 +-
 drivers/scsi/fnic/fnic_scsi.c           |    6 +-
 drivers/scsi/hpsa.c                     |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c          |    4 +-
 drivers/scsi/libiscsi.c                 |    7 ++-
 drivers/scsi/libsas/sas_scsi_host.c     |   11 +++--
 drivers/scsi/lpfc/lpfc_attr.c           |   10 ++++-
 drivers/scsi/lpfc/lpfc_scsi.c           |   44 +++++++++---------
 drivers/scsi/megaraid.c                 |    8 ++--
 drivers/scsi/megaraid/mega_common.h     |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c    |    4 +-
 drivers/scsi/ncr53c8xx.h                |    4 --
 drivers/scsi/pmcraid.c                  |    2 +-
 drivers/scsi/qla2xxx/qla_def.h          |    4 +-
 drivers/scsi/qla2xxx/qla_gbl.h          |   12 +++---
 drivers/scsi/qla2xxx/qla_isr.c          |    4 +-
 drivers/scsi/qla2xxx/qla_mbx.c          |   12 +++---
 drivers/scsi/qla2xxx/qla_os.c           |   41 +++++++++--------
 drivers/scsi/qla4xxx/ql4_glbl.h         |    4 +-
 drivers/scsi/qla4xxx/ql4_iocb.c         |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c          |   22 +++++-----
 drivers/scsi/qla4xxx/ql4_mbx.c          |    8 ++--
 drivers/scsi/qla4xxx/ql4_os.c           |   18 ++++----
 drivers/scsi/scsi.c                     |    8 ++--
 drivers/scsi/scsi_debug.c               |   15 +++---
 drivers/scsi/scsi_priv.h                |    2 +-
 drivers/scsi/scsi_proc.c                |    2 +-
 drivers/scsi/scsi_scan.c                |   73 +++++++++++--------------------
 drivers/scsi/scsi_sysfs.c               |   14 +++---
 drivers/scsi/scsi_transport_fc.c        |    4 +-
 drivers/scsi/scsi_transport_iscsi.c     |    4 +-
 drivers/scsi/scsi_transport_sas.c       |    2 +-
 drivers/scsi/sg.c                       |    4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c     |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h     |    2 +-
 drivers/target/loopback/tcm_loop.c      |    4 +-
 drivers/target/target_core_pscsi.c      |   12 +++---
 include/linux/moduleparam.h             |    5 ++
 include/scsi/scsi.h                     |    2 +-
 include/scsi/scsi_device.h              |   22 +++++-----
 include/scsi/scsi_host.h                |    6 +-
 include/scsi/scsi_transport.h           |    2 +-
 kernel/params.c                         |    1 +
 61 files changed, 281 insertions(+), 306 deletions(-)

-- 
1.7.4.2

