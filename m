From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] final SCSI pieces for the merge window
Date: Tue, 23 Oct 2007 16:58:48 -0400
Message-ID: <1193173128.3434.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56696 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751935AbXJWU6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 16:58:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This should be the final SCSI updates; it's mainly just a few accessor
completion updates and two driver merges (sym2 and qla2xxx) we also
secured DaveM's agreement to remove fcal/fc4, which explains the high
removal line count.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (3):
      gdth: __init fixes
      aic7xxx_old: fix accidental logic reversal
      lpfc: lpfc_debugfs.c: fix typo

Alan Cox (1):
      initio: Fix merge fallout

Andrew Morton (1):
      qla2xxx: printk fixes

Andrew Vasquez (8):
      qla2xxx: Update version number to 8.02.00-k5.
      qla2xxx: Correct display of ISP serial-number.
      qla2xxx: Correct residual-count handling discrepancies during UNDERRUN han
      qla2xxx: Make driver (mostly) legacy I/O port free.
      qla2xxx: Fix issue where final flash-segment updates were falling into the
      qla2xxx: Handle unaligned sector writes during NVRAM/VPD updates.
      qla2xxx: Defer explicit interrupt-polling processing to init-time scenario
      qla2xxx: Resync with latest HBA SSID specification -- 2.2u.

Hannes Reinecke (3):
      aic7xxx: Fix firmware build
      aic7xxx: Update Maintainer information
      aic7xxx: Add suspend/resume support

HighPoint Linux Team (1):
      hptiop: avoid buffer overflow when returning sense data

James Bottomley (2):
      make supported_mode default to initiator.
      include linux/scatterlist.h in scsi_eh.h

Johannes Dickgreber (2):
      qla1280: eliminate wasted space in request and response ring
      qla1280: uses wrong failure path after failed pci_set_dma_mask

Kai Makisara (1):
      sym53c8xx: Work around 53c896 erratum

Linas Vepstas (1):
      sym53c8xx: PCI Error Recovery support

Matthew Wilcox (16):
      sym53c8xx: Remove sym_xpt_async_sent_bdr
      sym53c8xx: Remove pci_dev pointer from sym_shcb
      sym53c8xx: Make interrupt handler capable of returning IRQ_NONE
      sym53c8xx: Get rid of IRQ_FMT and IRQ_PRM
      sym53c8xx: Use scmd_printk where appropriate
      sym53c8xx: Simplify DAC DMA handling
      sym53c8xx: Remove tag_ctrl module parameter
      sym53c8xx: Remove io_ws, mmio_ws and ram_ws elements
      sym53c8xx: Remove ->device_id
      sym53c8xx: Use pdev->revision
      sym53c8xx: Stop overriding scsi_done
      sym53c8xx: Don't disable interrupts in the interrupt handler
      sym53c8xx: Remove unnecessary check in queuecommand
      sym53c8xx: Remove data_mapping and data_mapped
      sym53c8xx: Use pci_dev irq number
      fc4: remove this and all associated drivers

and the diffstat:

 b/Documentation/scsi/sym53c8xx_2.txt              |   21 
 b/MAINTAINERS                                     |    6 
 b/arch/sparc64/Kconfig                            |    2 
 b/drivers/Makefile                                |    1 
 b/drivers/scsi/Makefile                           |    2 
 b/drivers/scsi/aic7xxx/aic7770.c                  |   16 
 b/drivers/scsi/aic7xxx/aic79xx.h                  |   11 
 b/drivers/scsi/aic7xxx/aic79xx_core.c             |    7 
 b/drivers/scsi/aic7xxx/aic79xx_osm.c              |    4 
 b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c          |   50 
 b/drivers/scsi/aic7xxx/aic79xx_pci.c              |   27 
 b/drivers/scsi/aic7xxx/aic7xxx.h                  |   11 
 b/drivers/scsi/aic7xxx/aic7xxx_osm.c              |    4 
 b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c          |   46 
 b/drivers/scsi/aic7xxx/aic7xxx_pci.c              |   16 
 b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l |    3 
 b/drivers/scsi/aic7xxx_old.c                      |    2 
 b/drivers/scsi/gdth.c                             |    6 
 b/drivers/scsi/hosts.c                            |    6 
 b/drivers/scsi/hptiop.c                           |    5 
 b/drivers/scsi/initio.c                           |    6 
 b/drivers/scsi/lpfc/lpfc_debugfs.c                |    2 
 b/drivers/scsi/qla1280.c                          |    4 
 b/drivers/scsi/qla1280.h                          |    4 
 b/drivers/scsi/qla2xxx/qla_attr.c                 |    9 
 b/drivers/scsi/qla2xxx/qla_def.h                  |    1 
 b/drivers/scsi/qla2xxx/qla_devtbl.h               |    7 
 b/drivers/scsi/qla2xxx/qla_iocb.c                 |    2 
 b/drivers/scsi/qla2xxx/qla_isr.c                  |    8 
 b/drivers/scsi/qla2xxx/qla_mbx.c                  |    2 
 b/drivers/scsi/qla2xxx/qla_os.c                   |   50 
 b/drivers/scsi/qla2xxx/qla_sup.c                  |   30 
 b/drivers/scsi/qla2xxx/qla_version.h              |    2 
 b/drivers/scsi/scsi_error.c                       |    1 
 b/drivers/scsi/scsi_sysfs.c                       |   10 
 b/drivers/scsi/sym53c8xx_2/sym53c8xx.h            |    1 
 b/drivers/scsi/sym53c8xx_2/sym_fw.c               |   18 
 b/drivers/scsi/sym53c8xx_2/sym_fw.h               |    2 
 b/drivers/scsi/sym53c8xx_2/sym_glue.c             |  581 +++++------
 b/drivers/scsi/sym53c8xx_2/sym_glue.h             |   16 
 b/drivers/scsi/sym53c8xx_2/sym_hipd.c             |  159 +--
 b/drivers/scsi/sym53c8xx_2/sym_hipd.h             |   22 
 b/drivers/scsi/sym53c8xx_2/sym_nvram.c            |    2 
 b/include/scsi/scsi_eh.h                          |    2 
 drivers/fc4/Kconfig                               |   81 -
 drivers/fc4/Makefile                              |    9 
 drivers/fc4/fc-al.h                               |   27 
 drivers/fc4/fc.c                                  | 1146 ----------------------
 drivers/fc4/fc.h                                  |  230 ----
 drivers/fc4/fc_syms.c                             |   30 
 drivers/fc4/fcp.h                                 |   94 -
 drivers/fc4/fcp_impl.h                            |  164 ---
 drivers/fc4/soc.c                                 |  764 --------------
 drivers/fc4/soc.h                                 |  301 -----
 drivers/fc4/socal.c                               |  904 -----------------
 drivers/fc4/socal.h                               |  314 ------
 drivers/scsi/fcal.c                               |  317 ------
 drivers/scsi/fcal.h                               |   27 
 drivers/scsi/pluto.c                              |  349 ------
 drivers/scsi/pluto.h                              |   47 
 60 files changed, 675 insertions(+), 5316 deletions(-)

James


