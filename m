From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 0/4] Support 64-bit LUNs
Date: Wed, 25 Jun 2014 15:27:35 +0200
Message-ID: <1403702859-74437-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454AbaFYN1n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2014 09:27:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

this patchset updates the SCSI stack to support full 64-bit LUNs.
The first patche update the SCSI stack and all drivers
to use 64-bit LUNs where appropriate.
The second patch updates the kernel module parameter
functions to accept a new 'ullong' parameter.
The third the updates the 'max_lun' parameter to accept
64-bit values, too.
And finally we need to update the conversion routines
scsilun_to_int to cope with 64bit LUNs.

The patchset is relative to the 'core-for-3.17' git tree from hch.

Changes to v4:
- Drop patches already merged
- Include fixes from Bart van Assche for scsilun_to_int()
- Include missing patches for mptfc.c and mptscsih.c
- Split module parameter changes into separate patch

Changes to v3:
- Modified scsilun_to_int() as suggested by James B.

Changes to v2:
- Add patch to fixup scsilun_to_int
- Add Reviewed-by: where applicable
- Remove last references to SCSI_MULTI_LUN

Hannes Reinecke (4):
  scsi: use 64-bit LUNs
  Add module param type 'ullong'
  scsi: use 64-bit value for 'max_luns'
  scsi_scan: Fixup scsilun_to_int()

 drivers/ata/libata-scsi.c            |  2 +-
 drivers/ata/libata.h                 |  2 +-
 drivers/message/fusion/mptbase.h     |  2 +-
 drivers/message/fusion/mptfc.c       |  6 +--
 drivers/message/fusion/mptscsih.c    | 14 +++---
 drivers/message/fusion/mptscsih.h    |  4 +-
 drivers/message/i2o/i2o_scsi.c       | 11 +++--
 drivers/s390/scsi/zfcp_dbf.c         |  3 +-
 drivers/s390/scsi/zfcp_unit.c        |  4 +-
 drivers/scsi/NCR5380.c               | 28 ++++++------
 drivers/scsi/aacraid/linit.c         |  2 +-
 drivers/scsi/advansys.c              |  2 +-
 drivers/scsi/aha152x.c               |  6 +--
 drivers/scsi/aic7xxx/aic79xx.h       |  2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c   |  6 +--
 drivers/scsi/aic7xxx/aic79xx_proc.c  |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c   | 11 ++---
 drivers/scsi/aic7xxx/aic7xxx_proc.c  |  2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c     |  8 ++--
 drivers/scsi/csiostor/csio_scsi.c    | 24 +++++------
 drivers/scsi/cxgbi/libcxgbi.c        |  2 +-
 drivers/scsi/cxgbi/libcxgbi.h        |  2 +-
 drivers/scsi/dc395x.c                | 42 +++++++++---------
 drivers/scsi/eata.c                  |  4 +-
 drivers/scsi/fnic/fnic_scsi.c        |  4 +-
 drivers/scsi/hpsa.c                  |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c       |  4 +-
 drivers/scsi/libiscsi.c              |  8 ++--
 drivers/scsi/libsas/sas_scsi_host.c  | 11 ++---
 drivers/scsi/lpfc/lpfc_attr.c        | 10 ++++-
 drivers/scsi/lpfc/lpfc_scsi.c        | 36 ++++++++--------
 drivers/scsi/megaraid.c              |  6 +--
 drivers/scsi/megaraid/mega_common.h  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 +-
 drivers/scsi/pmcraid.c               |  2 +-
 drivers/scsi/qla2xxx/qla_def.h       |  6 +--
 drivers/scsi/qla2xxx/qla_gbl.h       | 18 ++++----
 drivers/scsi/qla2xxx/qla_iocb.c      | 11 +++--
 drivers/scsi/qla2xxx/qla_isr.c       |  4 +-
 drivers/scsi/qla2xxx/qla_mbx.c       | 12 +++---
 drivers/scsi/qla2xxx/qla_mr.c        |  8 ++--
 drivers/scsi/qla2xxx/qla_os.c        | 41 +++++++++---------
 drivers/scsi/qla4xxx/ql4_glbl.h      |  4 +-
 drivers/scsi/qla4xxx/ql4_iocb.c      |  2 +-
 drivers/scsi/qla4xxx/ql4_isr.c       | 22 +++++-----
 drivers/scsi/qla4xxx/ql4_mbx.c       |  6 +--
 drivers/scsi/qla4xxx/ql4_os.c        | 20 ++++-----
 drivers/scsi/scsi.c                  |  8 ++--
 drivers/scsi/scsi_debug.c            | 15 ++++---
 drivers/scsi/scsi_priv.h             |  2 +-
 drivers/scsi/scsi_proc.c             |  2 +-
 drivers/scsi/scsi_scan.c             | 82 ++++++++++++++----------------------
 drivers/scsi/scsi_sysfs.c            | 14 +++---
 drivers/scsi/scsi_transport_fc.c     |  4 +-
 drivers/scsi/scsi_transport_iscsi.c  |  4 +-
 drivers/scsi/scsi_transport_sas.c    |  2 +-
 drivers/scsi/sg.c                    |  4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c  |  2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h  |  2 +-
 drivers/target/loopback/tcm_loop.c   |  2 +-
 drivers/target/target_core_pscsi.c   | 12 +++---
 drivers/usb/storage/sddr09.c         |  4 +-
 drivers/usb/storage/usb.c            | 10 +++--
 include/linux/moduleparam.h          |  5 +++
 include/scsi/scsi.h                  |  2 +-
 include/scsi/scsi_device.h           | 22 +++++-----
 include/scsi/scsi_host.h             |  6 +--
 include/scsi/scsi_transport.h        |  2 +-
 kernel/params.c                      |  1 +
 69 files changed, 322 insertions(+), 319 deletions(-)

-- 
1.7.12.4

