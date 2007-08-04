From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Sat, 04 Aug 2007 12:31:43 -0500
Message-ID: <1186248703.3439.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51834 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932302AbXHDRbq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Aug 2007 13:31:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is mainly bug fixes ... there's one or two features completions
that have been delayed pending ack and review to do with bsg (headers
and passthrough) but these are really required to complete already
upstream code.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Boaz Harrosh (6):
      aha152x: use data accessors and !use_sg cleanup
      aha152x: Fix check_condition code-path
      aha152x: Clean Reset path
      aha152x: preliminary fixes and some comments
      aha152x: use bounce buffer
      aha152x: fix debug mode symbol conflict

David Miller (1):
      ESP: Revert ESP_BUS_TIMEOUT back down to 250

FUJITA Tomonori (6):
      initialize shost_data to zero
      mptsas: add SMP passthrough support via bsg
      bsg: update sg_io_v4 structure
      ibmvscsi: use shost_priv
      ibmvscsi: remove unnecessary map_sg check
      zfcp: convert to use the data buffer accessors

James Bottomley (4):
      sd: disentangle barriers in SCSI
      aic7xxx: cap maxsync according to correct card limits
      mpt fusion: make logging a global sysfs parameter
      libsas: fix build dependencies on libata

James Smart (9):
      lpfc : scsi command accessor fix for 8.2.2
      lpfc 8.2.2 : Change version number to 8.2.2
      lpfc 8.2.2 : Style cleanups
      lpfc 8.2.2 : Miscellaneous Bug Fixes
      lpfc 8.2.2 : Miscellaneous management and logging mods
      lpfc 8.2.2 : Rework the lpfc_printf_log() macro
      lpfc 8.2.2 : Attribute and Parameter splits for vport and physical port
      lpfc 8.2.2 : Fix locking around HBA's port_list
      lpfc 8.2.2 : Error messages and debugfs updates

Jeff Garzik (1):
      gdth: remove redundant PCI stuff

Mark Fortescue (1):
      qlogicpti: Some cosmetic changes

Matthew Wilcox (1):
      dpt_i2o: convert to SCSI hotplug model

Matthias Kaehlcke (1):
      st: Use mutex instead of semaphore

Salyzyn, Mark (1):
      aacraid: prevent panic on adapter resource failure

Seokmann Ju (1):
      qla2xxx: fix panic caused by previous patch


and the diffstat:

 block/bsg.c                         |   10 
 drivers/message/fusion/mptbase.c    |   17 
 drivers/message/fusion/mptsas.c     |  126 ++++++
 drivers/s390/scsi/zfcp_fsf.c        |    5 
 drivers/s390/scsi/zfcp_qdio.c       |   41 --
 drivers/scsi/aacraid/linit.c        |    4 
 drivers/scsi/aha152x.c              |  169 ++++----
 drivers/scsi/aha152x.h              |    2 
 drivers/scsi/aic7xxx/aic7xxx_core.c |   22 +
 drivers/scsi/dpt_i2o.c              |  132 +++---
 drivers/scsi/dpti.h                 |    9 
 drivers/scsi/esp_scsi.h             |    2 
 drivers/scsi/gdth.c                 |   48 +-
 drivers/scsi/gdth.h                 |    6 
 drivers/scsi/hosts.c                |    2 
 drivers/scsi/ibmvscsi/ibmvscsi.c    |   39 --
 drivers/scsi/libsas/Kconfig         |    3 
 drivers/scsi/lpfc/lpfc.h            |   72 ++-
 drivers/scsi/lpfc/lpfc_attr.c       |  423 +++++++++++++++-------
 drivers/scsi/lpfc/lpfc_crtn.h       |   28 -
 drivers/scsi/lpfc/lpfc_ct.c         |  243 ++++++------
 drivers/scsi/lpfc/lpfc_debugfs.c    |  595 ++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_debugfs.h    |    2 
 drivers/scsi/lpfc/lpfc_els.c        |  679 ++++++++++++++++--------------------
 drivers/scsi/lpfc/lpfc_hbadisc.c    |  539 ++++++++++++----------------
 drivers/scsi/lpfc/lpfc_hw.h         |   14 
 drivers/scsi/lpfc/lpfc_init.c       |  284 +++++++--------
 drivers/scsi/lpfc/lpfc_logmsg.h     |   10 
 drivers/scsi/lpfc/lpfc_mbox.c       |   20 -
 drivers/scsi/lpfc/lpfc_mem.c        |   32 +
 drivers/scsi/lpfc/lpfc_nportdisc.c  |  162 +++-----
 drivers/scsi/lpfc/lpfc_scsi.c       |  413 ++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli.c        |  423 +++++++++++-----------
 drivers/scsi/lpfc/lpfc_sli.h        |   10 
 drivers/scsi/lpfc/lpfc_version.h    |    4 
 drivers/scsi/lpfc/lpfc_vport.c      |  164 +++++---
 drivers/scsi/lpfc/lpfc_vport.h      |    2 
 drivers/scsi/qla2xxx/qla_os.c       |   14 
 drivers/scsi/qlogicpti.c            |   50 +-
 drivers/scsi/scsi_lib.c             |   17 
 drivers/scsi/sd.c                   |   14 
 drivers/scsi/st.c                   |   16 
 drivers/scsi/st.h                   |    3 
 include/linux/bsg.h                 |   13 
 include/scsi/scsi_driver.h          |    2 
 include/scsi/sd.h                   |    2 
 46 files changed, 2837 insertions(+), 2050 deletions(-)

James


