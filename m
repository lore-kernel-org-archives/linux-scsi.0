From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.2+ merge window
Date: Sat, 20 Jul 2019 08:33:21 +0900
Message-ID: <1563579201.1602.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the final round of mostly small fixes in our initial
submit.  It's mostly minor fixes and driver updates.  The only change
of note is adding a virt_boundary_mask to the SCSI host and host
template to parametrise this for NVMe devices instead of having them do
a call in slave_alloc.  It's a fairly straightforward conversion except
in the two NVMe handling drivers that didn't set it who now have a
virtual infinity parameter added.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: lpfc: reduce stack size with CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE

Benjamin Block (3):
      scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitialized
      scsi: zfcp: fix request object use-after-free in send path causing wrong traces
      scsi: zfcp: fix request object use-after-free in send path causing seqno errors

Christoph Hellwig (8):
      scsi: megaraid_sas: set an unlimited max_segment_size
      scsi: mpt3sas: set an unlimited max_segment_size for SAS 3.0 HBAs
      scsi: IB/srp: set virt_boundary_mask in the scsi host
      scsi: IB/iser: set virt_boundary_mask in the scsi host
      scsi: storvsc: set virt_boundary_mask in the scsi host template
      scsi: ufshcd: set max_segment_size in the scsi host template
      scsi: core: take the DMA max mapping size into account
      scsi: core: add a host / host template field for the virt boundary

Colin Ian King (1):
      scsi: libfc: fix null pointer dereference on a null lport

Damien Le Moal (1):
      scsi: sd_zbc: Fix compilation warning

Deepak Ukey (1):
      scsi: pm80xx: Fixed kernel panic during error recovery for SATA drive

Denis Efremov (1):
      scsi: libsas: remove the exporting of sas_wait_eh

Marcos Paulo de Souza (1):
      scsi: devinfo: BLIST_TRY_VPD_PAGES for SanDisk Cruzer Blade

Maurizio Lombardi (1):
      scsi: core: use scmd_printk() to print which command timed out

Ming Lei (1):
      scsi: core: Fix race on creating sense cache

Shivasharan S (4):
      scsi: megaraid_sas: Update driver version to 07.710.50.00
      scsi: megaraid_sas: Add module parameter for FW Async event logging
      scsi: megaraid_sas: Enable msix_load_balance for Invader and later controllers
      scsi: megaraid_sas: Fix calculation of target ID

YueHaibing (1):
      scsi: megaraid_sas: Make some symbols static

And the diffstat:

 drivers/infiniband/ulp/iser/iscsi_iser.c  | 35 ++++----------------
 drivers/infiniband/ulp/srp/ib_srp.c       | 18 ++--------
 drivers/s390/scsi/zfcp_erp.c              |  7 ++++
 drivers/s390/scsi/zfcp_fsf.c              | 55 +++++++++++++++++++++++++++----
 drivers/scsi/hosts.c                      |  3 ++
 drivers/scsi/libfc/fc_exch.c              |  2 +-
 drivers/scsi/libsas/sas_scsi_host.c       |  1 -
 drivers/scsi/lpfc/lpfc_debugfs.h          |  2 +-
 drivers/scsi/megaraid/megaraid_sas.h      |  4 +--
 drivers/scsi/megaraid/megaraid_sas_base.c | 31 +++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  1 +
 drivers/scsi/pm8001/pm8001_sas.c          |  6 +++-
 drivers/scsi/pm8001/pm80xx_hwi.c          |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h          |  2 ++
 drivers/scsi/scsi_devinfo.c               |  2 ++
 drivers/scsi/scsi_lib.c                   | 13 +++++---
 drivers/scsi/sd_zbc.c                     |  2 +-
 drivers/scsi/storvsc_drv.c                |  5 ++-
 drivers/scsi/ufs/ufshcd.c                 |  3 +-
 include/scsi/scsi_host.h                  |  3 ++
 20 files changed, 123 insertions(+), 74 deletions(-)

James
