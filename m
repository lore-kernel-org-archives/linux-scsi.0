From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.3+ merge window
Date: Thu, 05 Nov 2015 09:17:38 -0800
Message-ID: <1446743858.2211.24.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch includes a couple of minor fixes, some core changes to help
issues we're still seeing with the suspend/resume code and updates to
lpfc and cxlflash.

We're (actually Martin Petersen is) trying to wrangle a mpt2/mpt3sas
merger for the merge window which will help enormously with the
maintenance burden, so there will be another round before it closes

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The Short Changelog is:

Alan Stern (2):
      SCSI: fix bug in scsi_dev_info_list matching
      SCSI: refactor device-matching code in scsi_devinfo.c

Ales Novak (1):
      fix: lpfc_send_rscn_event sends bigger buffer size

Bodo Stroesser (1):
      lpfc: in sli3 use configured sg_seg_cnt for sg_tablesize

Firo Yang (1):
      lpfc: Remove unnessary cast

Ian Mitchell (1):
      Fix kmalloc overflow in LPFC driver at large core count

James Smart (5):
      lpfc: Update version to 11.0.0.0 for upstream patch set
      lpfc: Fix default RA_TOV and ED_TOV in the FC/FCoE driver for all topologies
      lpfc: The linux driver does not reinitiate discovery after a failed FLOGI
      lpfc: Fix for discovery failure in PT2PT when FLOGI's ELS ACC response gets aborted
      lpfc: Add support for Lancer G6 and 32G FC links

Johannes Thumshirn (1):
      lpfc: Destroy lpfc_hba_index IDR on module exit

Ketan Mukadam (2):
      be2iscsi: Revert ownership to Emulex
      MAINTAINERS: Update be2iscsi driver

Manoj Kumar (5):
      cxlflash: Fix to escalate to LINK_RESET on login timeout
      cxlflash: Fix to double the delay each time
      cxlflash: Fix read capacity timeout
      cxlflash: Replace magic numbers with literals
      cxlflash: Fix to avoid invalid port_sel value

Matthew R. Ochs (32):
      cxlflash: Fix to avoid bypassing context cleanup
      cxlflash: Fix to avoid lock instrumentation rejection
      cxlflash: Fix to avoid corrupting port selection mask
      cxlflash: Fix to avoid leaving dangling interrupt resources
      cxlflash: Fix to avoid potential deadlock on EEH
      cxlflash: Correct trace string
      cxlflash: Fix to avoid corrupting adapter fops
      MAINTAINERS: Add cxlflash driver
      cxlflash: Fix to prevent stale AFU RRQ
      cxlflash: Correct spelling, grammar, and alignment mistakes
      cxlflash: Fix to prevent EEH recovery failure
      cxlflash: Fix MMIO and endianness errors
      cxlflash: Fix function prolog parameters and return codes
      cxlflash: Remove unnecessary scsi_block_requests
      cxlflash: Correct behavior in device reset handler following EEH
      cxlflash: Fix to prevent workq from accessing freed memory
      cxlflash: Correct usage of scsi_host_put()
      cxlflash: Fix AFU version access/storage and add check
      cxlflash: Remove dual port online dependency
      cxlflash: Fix async interrupt bypass logic
      cxlflash: Fix host link up event handling
      cxlflash: Fix location of setting resid
      cxlflash: Fix to avoid stall while waiting on TMF
      cxlflash: Fix to avoid spamming the kernel log
      cxlflash: Refine host/device attributes
      cxlflash: Make functions static
      cxlflash: Correct naming of limbo state and waitq
      cxlflash: Fix to avoid CXL services during EEH
      cxlflash: Fix context encode mask width
      cxlflash: Fix to avoid sizeof(bool)
      cxlflash: Fix data corruption when vLUN used over multiple cards
      cxlflash: Fix potential oops following LUN removal

Maurizio Lombardi (1):
      fnic: check pci_map_single() return value

Nicholas Krause (1):
      lpfc:Make the function lpfc_sli4_mbox_completions_pending static in order to comply with function prototype

Sebastian Herbszt (2):
      lpfc: remove set but not used variables
      lpfc: fix model description

Shirish Pargaonkar (1):
      bnx2fc: Do not log error for netevents that need no action


With the diffstat:

 MAINTAINERS                        |   13 +-
 drivers/scsi/be2iscsi/Kconfig      |    4 +-
 drivers/scsi/be2iscsi/Makefile     |    2 +-
 drivers/scsi/be2iscsi/be.h         |    4 +-
 drivers/scsi/be2iscsi/be_cmds.c    |    4 +-
 drivers/scsi/be2iscsi/be_cmds.h    |    4 +-
 drivers/scsi/be2iscsi/be_iscsi.c   |    4 +-
 drivers/scsi/be2iscsi/be_main.c    |    8 +-
 drivers/scsi/be2iscsi/be_main.h    |    6 +-
 drivers/scsi/be2iscsi/be_mgmt.c    |    4 +-
 drivers/scsi/be2iscsi/be_mgmt.h    |    4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |    1 -
 drivers/scsi/cxlflash/common.h     |   30 +-
 drivers/scsi/cxlflash/lunmgt.c     |   45 +-
 drivers/scsi/cxlflash/main.c       | 1550 +++++++++++++++++++-----------------
 drivers/scsi/cxlflash/main.h       |    1 +
 drivers/scsi/cxlflash/sislite.h    |    8 +-
 drivers/scsi/cxlflash/superpipe.c  |  209 +++--
 drivers/scsi/cxlflash/superpipe.h  |   14 +-
 drivers/scsi/cxlflash/vlun.c       |   68 +-
 drivers/scsi/fnic/fnic_fcs.c       |   46 +-
 drivers/scsi/fnic/fnic_scsi.c      |   16 +
 drivers/scsi/lpfc/lpfc.h           |    8 +-
 drivers/scsi/lpfc/lpfc_attr.c      |   23 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   20 -
 drivers/scsi/lpfc/lpfc_ct.c        |   11 +-
 drivers/scsi/lpfc/lpfc_els.c       |  100 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   27 +-
 drivers/scsi/lpfc/lpfc_hw.h        |    6 +-
 drivers/scsi/lpfc/lpfc_init.c      |   36 +-
 drivers/scsi/lpfc/lpfc_mbox.c      |   19 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |    2 -
 drivers/scsi/lpfc/lpfc_scsi.c      |   14 +-
 drivers/scsi/lpfc/lpfc_sli.c       |   10 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |    1 -
 drivers/scsi/lpfc/lpfc_version.h   |    2 +-
 drivers/scsi/scsi_devinfo.c        |  181 ++---
 37 files changed, 1342 insertions(+), 1163 deletions(-)

James
