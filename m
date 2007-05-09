From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] final SCSI updates for 2.6.21
Date: Tue, 08 May 2007 20:17:39 -0500
Message-ID: <1178673459.3737.114.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57802 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754877AbXEIBRr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 21:17:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This should be the second half of the SCSI tree, mainly assorted driver
updates and fixes.  The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (1):
      qla4xxx: possible cleanups

Amol Lad (1):
      megaraid: replace yield() with cond_resched()

Andrew Vasquez (6):
      qla2xxx: Update version number to 8.01.07-k7.
      qla2xxx: Add MSI support.
      qla2xxx: Correct pci_set_msi() usage semantics.
      qla2xxx: Attempt to stop firmware only if it had been previously executed.
      qla2xxx: Honor NVRAM port-down-retry-count settings.
      qla2xxx: Error-out during probe() if we're unable to complete HBA initiali

Brian King (11):
      ipr: Use PCI-E reset API for new ipr adapter
      ipr: Better handle adapter boot time errors
      ipr: Enable multi-initator RAID support
      ipr: Improved dual adapter errors
      ipr: Increase adapter operational timeout
      ipr: Handle IOA reset request
      ipr: Handle check condition status from disk array device
      ipr: Handle UA on disk array following an adapter reset
      ipr: Allow driver_data to be passed for dynamic ids
      ipr: Prevent overlapped adapter resets
      use sysfs configured timeout for EH Start Unit timeout

Christof Schmitt (4):
      zfcp: Fix deadlock between zfcp ERP and SCSI
      zfcp: Locking for req_no and req_seq_no
      zfcp: print S_ID and D_ID with 3 bytes
      zfcp: Stop system after memory corruption

Christoph Hellwig (2):
      deprecate the old NCR53C9x driver
      sas_scsi_host: Convert to use the kthread API

David Milburn (1):
      megaraid: update version reported by MEGAIOC_QDRVRVER

Guennadi Liakhovetski (3):
      tmscsim: Remove the last bus_to_virt()
      tmscsim: remove bogus endianness conversions
      tmscsim: remove long dead DMA_INT

Heiko Carstens (3):
      zfcp: clear boxed flag on unit reopen.
      zfcp: clear adapter failed flag if an fsf request times out.
      zfcp: rework request ID management.

James Smart (17):
      fc_transport: make all rports wait dev_loss_tmo before removing them
      lpfc 8.1.12 : Change version number to 8.1.12
      lpfc 8.1.12 : Update copyright year to 2007
      lpfc 8.1.12 : Added support for 8G speed and new HBAs
      lpfc 8.1.12 : Add support for async scanning
      lpfc 8.1.12 : Don't process ERATT interrupts when issuing KILL_BOARD mbx c
      lpfc 8.1.12 : Collapse discovery lists to a single node list
      lpfc 8.1.12 : Reference count node structures for node lifetime management
      lpfc 8.1.12 : Improve handling of failed ELS aborts
      lpfc 8.1.12 : Improve diagnostic messages and change local loopback messag
      lpfc 8.1.12 : Fixed recovery of rport after race with dev_loss_tmo
      lpfc 8.1.12 : Round 2 of Miscellaneous fixes
      lpfc 8.1.12 : Reorganize lpfc_nlp_list() and callers to prepare for nodeli
      lpfc 8.1.12 : Fix unlock inside list traversal
      lpfc 8.1.12 : Rework offline path to solve HBA reset issues
      lpfc 8.1.12 : Modify ELS abort handling to prevent double completion
      lpfc 8.1.12 : Misc bug fixes and code cleanup

Matthias Kaehlcke (1):
      qla1280: use DMA_64BIT_MASK instead of ~ 0ULL

Olaf Hering (1):
      mesh: cleanup variable usage in interrupt handler

Salyzyn, Mark (4):
      aacraid: correct SUN products to README
      aacraid: superfluous adapter reset for IBM 8 series ServeRAID controllers
      aacraid: kexec fix (reset interrupt handler)
      aacraid: kmalloc/memset->kzalloc

vignesh.babu@wipro.com (2):
      dpt_i2o: kmalloc/memset->kzalloc
      ch: kmalloc/memset->kzalloc

walter harms (1):
      megaraid: fix warnings when CONFIG_PROC_FS=n


And the diffstat:

 Documentation/feature-removal-schedule.txt |    9 
 Documentation/scsi/aacraid.txt             |    4 
 drivers/s390/scsi/zfcp_aux.c               |   90 --
 drivers/s390/scsi/zfcp_def.h               |   41 +
 drivers/s390/scsi/zfcp_erp.c               |   89 ++
 drivers/s390/scsi/zfcp_ext.h               |    4 
 drivers/s390/scsi/zfcp_fsf.c               |   50 -
 drivers/s390/scsi/zfcp_qdio.c              |   49 -
 drivers/s390/scsi/zfcp_scsi.c              |    9 
 drivers/scsi/aacraid/comminit.c            |    3 
 drivers/scsi/aacraid/commsup.c             |    6 
 drivers/scsi/aacraid/dpcsup.c              |    6 
 drivers/scsi/aacraid/rx.c                  |    4 
 drivers/scsi/ch.c                          |    9 
 drivers/scsi/dpt_i2o.c                     |   17 
 drivers/scsi/ipr.c                         |  349 ++++++++++-
 drivers/scsi/ipr.h                         |   33 +
 drivers/scsi/libsas/sas_scsi_host.c        |   36 -
 drivers/scsi/lpfc/lpfc.h                   |   33 -
 drivers/scsi/lpfc/lpfc_attr.c              |  212 ++++--
 drivers/scsi/lpfc/lpfc_crtn.h              |   32 -
 drivers/scsi/lpfc/lpfc_ct.c                |   24 
 drivers/scsi/lpfc/lpfc_disc.h              |   28 
 drivers/scsi/lpfc/lpfc_els.c               |  552 +++++++-----------
 drivers/scsi/lpfc/lpfc_hbadisc.c           |  884 +++++++++++++----------------
 drivers/scsi/lpfc/lpfc_hw.h                |   11 
 drivers/scsi/lpfc/lpfc_init.c              |  516 ++++++++--------
 drivers/scsi/lpfc/lpfc_mbox.c              |    3 
 drivers/scsi/lpfc/lpfc_nportdisc.c         |  307 ++++------
 drivers/scsi/lpfc/lpfc_scsi.c              |  109 ++-
 drivers/scsi/lpfc/lpfc_sli.c               |  427 +++++++-------
 drivers/scsi/lpfc/lpfc_sli.h               |   12 
 drivers/scsi/lpfc/lpfc_version.h           |    6 
 drivers/scsi/megaraid.c                    |   20 
 drivers/scsi/megaraid.h                    |    4 
 drivers/scsi/megaraid/megaraid_mm.c        |    2 
 drivers/scsi/mesh.c                        |   14 
 drivers/scsi/qla1280.c                     |    2 
 drivers/scsi/qla2xxx/qla_init.c            |   33 -
 drivers/scsi/qla2xxx/qla_isr.c             |   15 
 drivers/scsi/qla2xxx/qla_os.c              |    6 
 drivers/scsi/qla2xxx/qla_version.h         |    2 
 drivers/scsi/qla4xxx/ql4_dbg.c             |    4 
 drivers/scsi/qla4xxx/ql4_glbl.h            |    9 
 drivers/scsi/qla4xxx/ql4_init.c            |   18 
 drivers/scsi/qla4xxx/ql4_iocb.c            |   18 
 drivers/scsi/qla4xxx/ql4_mbx.c             |   19 
 drivers/scsi/qla4xxx/ql4_os.c              |    9 
 drivers/scsi/scsi_error.c                  |    3 
 drivers/scsi/scsi_transport_fc.c           |  158 +++--
 drivers/scsi/tmscsim.c                     |  225 ++-----
 drivers/scsi/tmscsim.h                     |   12 
 include/scsi/libsas.h                      |    3 
 53 files changed, 2396 insertions(+), 2144 deletions(-)

James


