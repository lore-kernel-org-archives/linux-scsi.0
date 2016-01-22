From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.4+ merge window
Date: Fri, 22 Jan 2016 11:52:44 -0800
Message-ID: <1453492364.2339.49.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly stuff which missed the first pull request because it
needed to incubate longer.  It's mainly made up of the ncr 5380 rework
but also has a few assorted bug fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Dan Carpenter (2):
      storvsc: Fix typo in MODULE_PARM_DESC
      cxgbi: Typo in MODULE_PARM_DESC

Finn Thain (71):
      ncr5380: Cleanup whitespace and parentheses
      atari_NCR5380: Merge changes from NCR5380.c
      ncr5380: Merge changes from atari_NCR5380.c
      ncr5380: Fix whitespace in comments using regexp
      ncr5380: Fix trailing whitespace using regexp
      ncr5380: Cleanup comments
      ncr5380: Fix soft lockups
      atari_scsi, sun3_scsi: Remove global Scsi_Host pointer
      atari_NCR5380: Eliminate HOSTNO macro
      atari_NCR5380: Remove HOSTNO macro from printk() and seq_printf() calls
      ncr5380: Implement new eh_bus_reset_handler
      ncr5380: Fix EH during arbitration and selection
      ncr5380: Implement new eh_abort_handler
      ncr5380: Fix autosense bugs
      ncr5380: Refactor command completion
      ncr5380: Use standard list data structure
      ncr5380: Remove redundant volatile qualifiers
      ncr5380: Remove LIST and REMOVE macros
      ncr5380: Use dsprintk() for queue debugging
      ncr5380: Use shost_priv helper
      ncr5380: Remove H_NO macro and introduce dsprintk
      ncr5380: Remove command list debug code
      ncr5380: Change instance->host_lock to hostdata->lock
      ncr5380: Remove redundant ICR_ARBITRATION_LOST test and eliminate FLAG_DTC3181E
      atari_NCR5380: Fix queue_size limit
      ncr5380: Fix and cleanup scsi_host_template initializers
      ncr5380: Fix NDEBUG_NO_DATAOUT flag
      ncr5380: Cleanup #include directives
      ncr5380: Fix off-by-one bug in extended_msg[] bounds check
      ncr5380: Standardize reselection handling
      ncr5380: Replace READ_OVERRUNS macro with FLAG_NO_DMA_FIXUPS
      ncr5380: Replace redundant flags with FLAG_NO_DMA_FIXUP
      ncr5380: Introduce NCR5380_poll_politely2
      ncr5380: Standardize interrupt handling
      ncr5380: Remove UNSAFE macro
      ncr5380: Standardize work queueing algorithm
      ncr5380: Use work_struct instead of delayed_work
      ncr5380: Dont wait for BUS FREE after disconnect
      atari_NCR5380: Use arbitration timeout
      atari_NCR5380: Set do_abort() timeouts
      ncr5380: Fix bus phase in do_abort()
      ncr5380: Fix !REQ timeout in do_abort()
      ncr5380: Add missing break after case MESSAGE_REJECT
      ncr5380: Drop DEF_SCSI_QCMD macro
      ncr5380: Add missing lock in eh_abort_handler
      ncr5380: Fix NCR5380_transfer_pio() result
      ncr5380: Rework disconnect versus poll logic
      ncr5380: Implement NCR5380_dma_xfer_len and remove LIMIT_TRANSFERSIZE macro
      ncr5380: Always retry arbitration and selection
      ncr5380: Eliminate selecting state
      ncr5380: Sleep when polling, if possible
      ncr5380: Introduce unbound workqueue
      ncr5380: Cleanup bogus {request,release}_region() calls
      ncr5380: Eliminate USLEEP_WAITLONG delay
      ncr5380: Keep BSY asserted when entering SELECTION phase
      ncr5380: Proceed with next command after NCR5380_select() calls scsi_done
      ncr5380: Always escalate bad target time-out in NCR5380_select()
      ncr5380: Use return instead of goto in NCR5380_select()
      ncr5380: Remove redundant register writes
      ncr5380: Remove unused hostdata->aborted flag
      ncr5380: Simplify bus reset handlers
      atari_NCR5380: Remove RESET_BOOT, CONFIG_ATARI_SCSI_TOSHIBA_DELAY and CONFIG_ATARI_SCSI_RESET_BOOT
      atari_NCR5380: Reset bus on driver initialization if required
      ncr5380: Move NCR53C400-specific code
      ncr5380: Split NCR5380_init() into two functions
      ncr5380: Remove NCR5380_instance_name macro
      ncr5380: Remove NCR5380_local_declare and NCR5380_setup macros
      ncr5380: Remove more pointless macros
      ncr5380: Eliminate PDEBUG*, TDEBUG* and DTCDEBUG* macros
      ncr5380: Remove redundant static variable initializers
      atari_scsi: Fix SCSI host ID setting

Hannes Reinecke (1):
      ncr5380: Remove references to linked commands

Insu Yun (1):
      ipr: Fix out-of-bounds null overwrite

John Garry (3):
      hisi_sas: Use u64 for qw0 in free_device_v1_hw()
      hisi_sas: Fix typo in setup_itct_v1_hw()
      hisi_sas: Fix v1 itct masks

Mike Christie (1):
      scsi: add Synology to 1024 sector blacklist

Nicholas Krause (1):
      megaraid: Fix possible NULL pointer deference in mraid_mm_ioctl

Ondrej Zary (6):
      ncr5380: Add support for HP C2502
      ncr5380: Fix wait for 53C80 registers registers after PDMA
      ncr5380: Enable PDMA for DTC chips
      ncr5380: Enable PDMA for NCR53C400A
      ncr5380: Use runtime register mapping
      ncr5380: Fix pseudo DMA transfers on 53C400

Ryan C. Underwood (1):
      3w-xxxx: Pass through compat mode ioctls

Sudip Mukherjee (1):
      imm: Use new parport device model

And the diffstat:

 drivers/scsi/3w-xxxx.c                 |    3 +
 drivers/scsi/Kconfig                   |   17 -
 drivers/scsi/NCR5380.c                 | 2870 +++++++++++++++-----------------
 drivers/scsi/NCR5380.h                 |   87 +-
 drivers/scsi/arm/cumana_1.c            |   31 +-
 drivers/scsi/arm/oak.c                 |   27 +-
 drivers/scsi/atari_NCR5380.c           | 2272 +++++++++++--------------
 drivers/scsi/atari_scsi.c              |  102 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c     |    2 +-
 drivers/scsi/dmx3191d.c                |   33 +-
 drivers/scsi/dtc.c                     |  115 +-
 drivers/scsi/dtc.h                     |   45 +-
 drivers/scsi/g_NCR5380.c               |  408 +++--
 drivers/scsi/g_NCR5380.h               |   66 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   40 +-
 drivers/scsi/imm.c                     |   50 +-
 drivers/scsi/ipr.c                     |    5 +-
 drivers/scsi/mac_scsi.c                |  117 +-
 drivers/scsi/megaraid/megaraid_mm.c    |    4 +
 drivers/scsi/pas16.c                   |  116 +-
 drivers/scsi/pas16.h                   |   40 +-
 drivers/scsi/scsi_devinfo.c            |    1 +
 drivers/scsi/storvsc_drv.c             |    2 +-
 drivers/scsi/sun3_scsi.c               |  141 +-
 drivers/scsi/t128.c                    |  102 +-
 drivers/scsi/t128.h                    |   39 +-
 26 files changed, 3013 insertions(+), 3722 deletions(-)

James
