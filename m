From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] intermediate SCSI updates (v2)
Date: Fri, 17 Oct 2008 10:11:42 -0500
Message-ID: <1224256302.3368.13.camel@localhost.localdomain>
References: <1223909115.5566.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53431 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757714AbYJQPLv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 11:11:51 -0400
In-Reply-To: <1223909115.5566.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

OK, lets try again, this time with a tree that's got the compile failure
fixed and been through linux-next randconfig testing for a couple of
days (yes, I verified it has this time). This represents all the pieces
of SCSI which were depending on the already merged block tree.

The patch is available at:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

James Bottomley (2):
      sd: fix compile failure with CONFIG_BLK_DEV_INTEGRITY=n
      scsi_error: fix target reset handling

James Smart (12):
      lpfc 8.2.8 v2 : Add statistical reporting control and additional fc vendor
      lpfc 8.2.8 v2 : Add sysfs control of target queue depth handling
      lpfc 8.2.8 v2 : Revert target busy in favor of transport disrupted
      lpfc 8.2.8 : update driver version to 8.2.8
      lpfc 8.2.8 : Add MSI-X support
      lpfc 8.2.8 : Update driver to use new Host byte error code DID_TRANSPORT_D
      lpfc 8.2.8 : Add support for PCI-EEH permanent disabling
      lpfc 8.2.8 : Add new FCOE hardware support
      lpfc 8.2.8 : Miscellaneous Bug Fixes
      lpfc 8.2.8 : Update driver for new SLI-3 features
      lpfc 8.2.8 : Miscellaneous Discovery Fixes
      lpfc 8.2.8 : Add kernel-doc function headers

Martin K. Petersen (4):
      sd: Switch kernel printing level for DIF messages
      sd: Correctly handle all combinations of DIF and DIX
      sd: Always print actual protection_type
      sd: Issue correct protection operation

Mike Christie (21):
      libiscsi: fix locking in iscsi_eh_device_reset
      libiscsi: check reason why we are stopping iscsi session to determine erro
      iscsi_tcp: return a descriptive error value during connection errors
      libiscsi: rename host reset to target reset
      iscsi class: fix endpoint id handling
      libiscsi: Support drivers initiating session removal
      libiscsi: fix data corruption when target has to resend data-in packets
      scsi_dh_alua: remove REQ_NOMERGE
      modify scsi to handle new fail fast flags.
      block: separate failfast into multiple bits.
      qla2xxx: use new host byte transport errors.
      fc class: Add support for new transport errors
      iscsi class, libiscsi and qla4xxx: convert to new transport host byte valu
      scsi: add transport host byte errors (v3)
      ibmvfc, qla2xxx, lpfc: remove scsi_target_unblock calls in terminate callb
      fc class: unblock target after calling terminate callback (take 2)
      lpfc: use SCSI_MLQUEUE_TARGET_BUSY when catching the rport transition race
      libiscsi: Use SCSI_MLQUEUE_TARGET_BUSY
      qla2xxx: return SCSI_MLQUEUE_TARGET_BUSY when driver has detected rport er
      qla4xxx: return SCSI_MLQUEUE_TARGET_BUSY when driver has detected session 
      Add helper code so transport classes/driver can control queueing (v3)

The diffstat is:

 block/blk-core.c                            |   11 
 drivers/infiniband/ulp/iser/iscsi_iser.c    |    3 
 drivers/md/dm-mpath.c                       |    2 
 drivers/md/multipath.c                      |    4 
 drivers/s390/block/dasd_diag.c              |    2 
 drivers/s390/block/dasd_eckd.c              |    2 
 drivers/s390/block/dasd_fba.c               |    2 
 drivers/scsi/constants.c                    |    3 
 drivers/scsi/device_handler/scsi_dh_alua.c  |    3 
 drivers/scsi/device_handler/scsi_dh_emc.c   |    3 
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    6 
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    3 
 drivers/scsi/ibmvscsi/ibmvfc.c              |    2 
 drivers/scsi/iscsi_tcp.c                    |   44 
 drivers/scsi/libiscsi.c                     |  183 ++
 drivers/scsi/lpfc/lpfc.h                    |   96 +
 drivers/scsi/lpfc/lpfc_attr.c               | 1375 +++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_crtn.h               |   51 
 drivers/scsi/lpfc/lpfc_ct.c                 |   20 
 drivers/scsi/lpfc/lpfc_debugfs.c            |  400 +++++-
 drivers/scsi/lpfc/lpfc_disc.h               |   23 
 drivers/scsi/lpfc/lpfc_els.c                | 1712 +++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c            |  241 +++
 drivers/scsi/lpfc/lpfc_hw.h                 |  183 ++
 drivers/scsi/lpfc/lpfc_init.c               |  924 +++++++++++----
 drivers/scsi/lpfc/lpfc_mbox.c               |  624 ++++++++--
 drivers/scsi/lpfc/lpfc_mem.c                |  116 +
 drivers/scsi/lpfc/lpfc_nl.h                 |  163 ++
 drivers/scsi/lpfc/lpfc_nportdisc.c          |   24 
 drivers/scsi/lpfc/lpfc_scsi.c               |  514 +++++++-
 drivers/scsi/lpfc/lpfc_scsi.h               |    5 
 drivers/scsi/lpfc/lpfc_sli.c                | 1715 ++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_sli.h                |    1 
 drivers/scsi/lpfc/lpfc_version.h            |    6 
 drivers/scsi/lpfc/lpfc_vport.c              |  168 ++
 drivers/scsi/lpfc/lpfc_vport.h              |    4 
 drivers/scsi/qla2xxx/qla_attr.c             |    1 
 drivers/scsi/qla2xxx/qla_isr.c              |   14 
 drivers/scsi/qla2xxx/qla_os.c               |   26 
 drivers/scsi/qla4xxx/ql4_isr.c              |    4 
 drivers/scsi/qla4xxx/ql4_os.c               |    4 
 drivers/scsi/scsi.c                         |   10 
 drivers/scsi/scsi_error.c                   |   72 +
 drivers/scsi/scsi_lib.c                     |  106 +
 drivers/scsi/scsi_priv.h                    |    1 
 drivers/scsi/scsi_scan.c                    |    1 
 drivers/scsi/scsi_transport_fc.c            |   47 
 drivers/scsi/scsi_transport_iscsi.c         |   19 
 drivers/scsi/scsi_transport_spi.c           |    4 
 drivers/scsi/sd.c                           |   17 
 drivers/scsi/sd.h                           |   21 
 drivers/scsi/sd_dif.c                       |   42 
 include/linux/bio.h                         |   26 
 include/linux/blkdev.h                      |   15 
 include/scsi/iscsi_if.h                     |    2 
 include/scsi/libiscsi.h                     |   15 
 include/scsi/scsi.h                         |    6 
 include/scsi/scsi_device.h                  |   10 
 include/scsi/scsi_transport_fc.h            |    8 
 include/scsi/scsi_transport_iscsi.h         |    5 
 60 files changed, 8003 insertions(+), 1111 deletions(-)

James


