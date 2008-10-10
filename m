From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 2.6.28 merge window
Date: Fri, 10 Oct 2008 09:45:54 +0200
Message-ID: <1223624754.4962.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56188 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbYJJHqB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2008 03:46:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is actually a very thin set.  Most of our changes are backed up
behind the block tree which contains a lot of timer and error handler
changes.

The tree is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (1):
      qla2xxx: remove the unused SCSI_QLOGIC_FC_FIRMWARE option

Alexander Beregalov (1):
      qla2xxx: fix printk format warnings

Andrew Vasquez (6):
      qla2xxx: Update version number to 8.02.01-k8.
      qla2xxx: Additional residual-count corrections during UNDERRUN handling.
      qla2xxx: Add NPIV-Config Table support.
      qla2xxx: Add Flash Layout Table support.
      qla2xxx: Change GFP_ATOMIC to GFP_KERNEL for non-atomic allocations.
      fc_transport: Add an API to allow an LLD to create vports

Bjorn Helgaas (1):
      qla2xxx: Fix "occured" spelling errors.

Christof Schmitt (2):
      zfcp: Simplify zfcp data structures
      zfcp: Update message with input from review

FUJITA Tomonori (1):
      scsi_dh: no need to initialize rq->cmd with blk_get_request

Harish Zunjarrao (1):
      qla2xxx: Add input/output byte-count statistics.

James Bottomley (5):
      scsi_dh: suppress comparison warning
      sd: use generic helper to print capacities in both binary and SI
      lib: add generic helper to print sizes rounded to the correct SI range
      Update the SCSI state model to allow blocking in the created state
      add inline functions for recognising created and blocked states

James Smart (2):
      scsi_netlink: Add transport and LLD recieve and event support
      scsi_host_lookup: error returns and NULL pointers

Matthew Wilcox (1):
      qla2xxx: Remove semaphore.h

Mike Christie (1):
      libiscsi: return error passed in during iscsi recovery

Nick Warne (1):
      tmscsim: Fixup KERN_INFO in printk

Pierre Ossman (1):
      mmc_block: use generic helper to print capacities

Ravi Anand (1):
      qla2xxx: Ignore payload reserved-bits during RSCN processing.

Stefan Raspl (1):
      zfcp: add queue_full sysfs attribute

Swen Schillig (10):
      zfcp: fix double dbf id usage
      zfcp: wait on SCSI work to be finished before proceeding with init dev
      zfcp: fix erp list usage without using locks
      zfcp: prevent fc_remote_port_delete calls for unregistered rport
      zfcp: fix deadlock caused by shared work queue tasks
      zfcp: put threshold data in hba trace
      zfcp: Simplify get_adapter_by_busid
      zfcp: remove all typedefs and replace them with standards
      zfcp: attach and release SAN nameserver port on demand
      zfcp: remove unused references, declarations and flags

Yanqing_Liu@Dell.com (1):
      scsi_dh: add Dell product information into rdac device handler


And the diffstat:

 Documentation/scsi/scsi_fc_transport.txt    |   36 +
 drivers/mmc/card/block.c                    |   10 
 drivers/s390/scsi/zfcp_aux.c                |  150 +------
 drivers/s390/scsi/zfcp_ccw.c                |   45 +-
 drivers/s390/scsi/zfcp_dbf.c                |   75 ++-
 drivers/s390/scsi/zfcp_dbf.h                |    1 
 drivers/s390/scsi/zfcp_def.h                |  179 ++------
 drivers/s390/scsi/zfcp_erp.c                |  229 +++-------
 drivers/s390/scsi/zfcp_ext.h                |   27 -
 drivers/s390/scsi/zfcp_fc.c                 |  227 +++++++---
 drivers/s390/scsi/zfcp_fsf.c                |  584 +++++++++++++++-------------
 drivers/s390/scsi/zfcp_fsf.h                |   75 ---
 drivers/s390/scsi/zfcp_qdio.c               |   67 +--
 drivers/s390/scsi/zfcp_scsi.c               |   28 -
 drivers/s390/scsi/zfcp_sysfs.c              |   60 +-
 drivers/scsi/Kconfig                        |    8 
 drivers/scsi/device_handler/scsi_dh_emc.c   |    5 
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    2 
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    4 
 drivers/scsi/hosts.c                        |    2 
 drivers/scsi/libiscsi.c                     |    2 
 drivers/scsi/qla2xxx/qla_attr.c             |    9 
 drivers/scsi/qla2xxx/qla_def.h              |   13 
 drivers/scsi/qla2xxx/qla_fw.h               |   71 +++
 drivers/scsi/qla2xxx/qla_gbl.h              |    4 
 drivers/scsi/qla2xxx/qla_init.c             |   14 
 drivers/scsi/qla2xxx/qla_inline.h           |    2 
 drivers/scsi/qla2xxx/qla_iocb.c             |   30 -
 drivers/scsi/qla2xxx/qla_isr.c              |   17 
 drivers/scsi/qla2xxx/qla_mbx.c              |    6 
 drivers/scsi/qla2xxx/qla_os.c               |    9 
 drivers/scsi/qla2xxx/qla_sup.c              |  338 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_version.h          |    2 
 drivers/scsi/scsi.c                         |   13 
 drivers/scsi/scsi_lib.c                     |   39 +
 drivers/scsi/scsi_netlink.c                 |  523 ++++++++++++++++++++++++-
 drivers/scsi/scsi_proc.c                    |    8 
 drivers/scsi/scsi_scan.c                    |   20 
 drivers/scsi/scsi_sysfs.c                   |    1 
 drivers/scsi/scsi_tgt_lib.c                 |    6 
 drivers/scsi/scsi_transport_fc.c            |   54 +-
 drivers/scsi/scsi_transport_iscsi.c         |    4 
 drivers/scsi/sd.c                           |   27 -
 drivers/scsi/tmscsim.c                      |    4 
 include/linux/string_helpers.h              |   16 
 include/scsi/scsi_device.h                  |   21 -
 include/scsi/scsi_netlink.h                 |   62 ++
 include/scsi/scsi_transport_fc.h            |   23 +
 lib/Makefile                                |    3 
 lib/string_helpers.c                        |   64 +++
 50 files changed, 2107 insertions(+), 1112 deletions(-)

James


