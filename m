From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.4+ merge window
Date: Wed, 13 Jan 2016 16:24:58 -0800
Message-ID: <1452731098.2363.34.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46312 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbcANAZB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 19:25:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This pull includes driver updates from the usual suspects (bfa, arcmsr,
scsi_dh_alua, lpfc, storvsc, cxlflash).  The major change is the
addition of the hisi_sas driver, which is an ARM platform device for
SAS.  The other change of note is an enormous style transformation to
the atp870u driver (which is our worst written SCSI driver).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Andy Shevchenko (1):
      scsi_debug: check for bigger value first

Anil Gurumurthy (4):
      bfa: Update driver version to 3.2.25.0
      bfa: File header and user visible string changes
      bfa: Fix for crash when bfa_itnim is NULL
      bfa: Update copyright messages

Arnd Bergmann (2):
      scsi: use sector_div instead of do_div
      SCSI: initio: remove duplicate module device table

Bart Van Assche (1):
      scsi_transport_fc: Introduce scsi_host_{get,put}()

Ching Huang (8):
      arcmsr: change driver version to v1.30.00.22-20151126
      arcmsr: Split dma resource allocation to a new function
      arcmsr: more readability improvements
      arcmsr: changes driver version number
      arcmsr: adds code to support new Areca adapter ARC1203
      arcmsr: make code more readable
      arcmsr: fixes not release allocated resource
      arcmsr: fixed getting wrong configuration data

Colin Ian King (2):
      cciss: print max outstanding commands as a hex value
      scsi: ufs: fix spelling mistake in error message

Dan Carpenter (2):
      hisi_sas: fix error codes in hisi_sas_task_prep()
      cxlflash: a couple off by one bugs

Don Brace (3):
      hpsa: Add box and bay information for enclosure devices
      hpsa: Change SAS transport devices to bus 0.
      hpsa: fix path_info_show

Fengguang Wu (1):
      aacraid: aac_release_resources() can be static

Geert Uytterhoeven (1):
      st: Remove obsolete scsi_tape.max_pfn

Geliang Tang (1):
      cxlflash: drop unlikely before IS_ERR_OR_NULL

Hannes Reinecke (20):
      scsi_dh_alua: Remove stale variables
      scsi_dh_alua: use scsi_vpd_tpg_id()
      scsi: Add scsi_vpd_tpg_id()
      scsi: export 'wwid' to sysfs
      scsi: Add scsi_vpd_lun_id()
      scsi_dh_alua: simplify sense code handling
      scsi_dh_alua: rework alua_check_tpgs() to return the tpgs mode
      scsi_dh_alua: use unaligned access macros
      scsi_dh_alua: use flag for RTPG extended header
      scsi: remove scsi_show_sense_hdr()
      scsi_dh_alua: fixup description of stpg_endio()
      scsi_dh_alua: return standard SCSI return codes in submit_rtpg
      scsi_dh_alua: use standard logging functions
      scsi_dh_alua: sanitze sense code handling
      scsi_dh_alua: improved logging
      scsi_dh_alua: Use vpd_pg83 information
      scsi_dh_alua: Disable ALUA handling for non-disk devices
      scsi: ignore errors from scsi_dh_add_device()
      scsi_dh: move 'dh_state' sysfs attribute to generic code
      scsi: rescan VPD attributes

Himanshu Madhani (1):
      qla2xxx: Remove unavailable firmware files

James Bottomley (3):
      ses: fix discovery of SATA devices in SAS enclosures
      scsi_transport_sas: add function to get SAS endpoint address
      scsi_transport_sas: add is_sas_attached() function

James Smart (14):
      lpfc: Update version to 11.0.0.10 for upstream patch set
      lpfc: Add logging for misconfigured optics.
      lpfc: Fix external loopback failure.
      lpfc: Fix mbox reuse in PLOGI completion
      lpfc: Use new FDMI speed definitions for 10G, 25G and 40G FCoE.
      lpfc: Make write check error processing more resilient
      lpfc: Fix RDP ACC being too long.
      lpfc: Fix RDP Speed reporting.
      lpfc: Modularize and cleanup FDMI code in driver
      lpfc: Fix crash in fcp command completion path.
      lpfc: Fix driver crash when module parameter lpfc_fcp_io_channel set to 16
      lpfc: Fix RegLogin failed error seen on Lancer FC during port bounce
      lpfc: Fix the FLOGI discovery logic to comply with T11 standards
      lpfc: Fix FCF Infinite loop in lpfc_sli4_fcf_rr_next_index_get.

John Garry (34):
      hisi_sas: use platform_get_irq()
      hisi_sas: Remove dependency on of_irq_count
      MAINTAINERS: Add maintainer for HiSi SAS driver
      hisi_sas: Add fatal irq handler
      hisi_sas: Add control phy handler
      hisi_sas: Add tmf methods
      hisi_sas: Add scan finished and start
      hisi_sas: Add smp protocol support
      hisi_sas: Add bcast interrupt handler
      hisi_sas: Add abnormal irq handler
      hisi_sas: Add dev_found and dev_gone
      hisi_sas: Add cq interrupt handler
      hisi_sas: Add ssp command function
      hisi_sas: Add path from phyup irq to SAS framework
      hisi_sas: Add v1 hardware interrupt init
      hisi_sas: Add v1 hardware initialisation code
      hisi_sas: Add v1 hardware register definitions
      hisi_sas: Add v1 hw module init
      hisi_sas: Add timer and spinlock init
      hisi_sas: Add phy and port init
      hisi_sas: Add hisi sas device type
      hisi_sas: Add hisi_hba workqueue
      hisi_sas: Set dev DMA mask
      hisi_sas: Add phy SAS ADDR initialization
      hisi_sas: Add cq structure initialization
      hisi_sas: Add slot init code
      hisi_sas: Add hisi_sas_remove
      hisi_sas: Allocate memories and create pools
      hisi_sas: Add HW DMA structures
      hisi_sas: Scan device tree
      hisi_sas: Add scsi host registration
      hisi_sas: Add initial bare main driver
      devicetree: bindings: scsi: HiSi SAS
      scsi: Centralise ssp frame information units

Josh Boyer (1):
      VMW_PVSCSI: Fix the issue of DMA-API related warnings.

K. Y. Srinivasan (4):
      storvsc: Tighten up the interrupt path
      storvsc: Refactor the code in storvsc_channel_init()
      storvsc: Properly support Fibre Channel devices
      storvsc: Fix a bug in the layout of the hv_fc_wwn_packet

Long Li (1):
      storvsc: add logging for error/warning messages

Luis de Bethencourt (1):
      mvsas: fix misleading indentation

Manoj Kumar (4):
      cxlflash: Enable device id for future IBM CXL adapter
      cxlflash: Resolve oops in wait_port_offline
      cxlflash: Fix to resolve cmd leak after host reset
      cxlflash: Fix to escalate LINK_RESET also on port 1

Markus Elfring (1):
      lpfc: Delete unnecessary checks before the function call "mempool_destroy"

Martin K. Petersen (1):
      scsi_debug: Increase the reported optimal transfer length

Matthew R. Ochs (1):
      cxlflash: Fix to avoid virtual LUN failover failure

Ondrej Zary (52):
      atp870u: Introduce atp870_init()
      atp870u: Introduce atp885_init()
      atp870u: Introduce atp880_init()
      atp870u: Initialize tables earlier
      atp870u: Remove scam_on from struct atp_unit
      atp870u: Request IRQ later, remove weird locking
      atp870u: Use pci_request_regions
      atp870u: Introduce is880(), is885() and remove dev_id
      atp870u: Simplify _probe()
      atp870u: Remove chip_ver from struct atp_unit
      atp870u: Improve unsupported chip detection
      atp870u: Improve _probe()
      atp870u: Remove unused irq from struct atp_unit
      atp870u: Remove useless and broken card counting
      atp870u: Use n_io_port in request_region and release_region
      atp870u: Use module_pci_driver
      atp870u: Remove empty tscam_885()
      atp870u: Reduce log spam on module load/unload
      atp870u: Introduce atp_set_host_id
      atp870u: Fix incorrect writeb_io access to register 0x3a
      atp870u: Replace port 0x80 delay by udelay
      atp870u: Convert remaining in[bwl] and out[bwl] to wrappers
      atp870u: Rename is885() to atp_is()
      atp870u: Remove is870()
      atp870u: Move 870-specific code out of is870()
      atp870u: Add remaining 870 support to is885()
      atp870u: Add wide_chip parameter to is870() and is885()
      atp870u: Remove is880()
      atp870u: Move chip-specific lines out of is880() and is885()
      atp870u: Add channel parameter to is870() and is880()
      atp870u: Unify code format in is870(), is880() and is885()
      atp870u: Convert is885() to use wrappers
      atp870u: Convert is880() to use wrappers
      atp870u: Convert is870() to use wrappers
      atp870u: Introduce HW access wrappers
      atp870u: Remove ugly gotos #5
      atp870u: Remove ugly gotos #4
      atp870u: Remove ugly gotos #3
      atp870u: Remove ugly gotos #2
      atp870u: Remove ugly gotos
      atp870u: Untangle tmpcip #2
      atp870u: Untangle tmpcip
      atp870u: Untangle tmport #8
      atp870u: Untangle tmport #7
      atp870u: Untangle tmport #6
      atp870u: Untangle tmport #5
      atp870u: Untangle tmport #4
      atp870u: Untangle tmport #3
      atp870u: Untangle tmport #2
      atp870u: Untangle tmport
      atp870u: Remove tmport1
      atp870u: Remove workport

Punit Vara (1):
      lpfc: Use kzalloc instead of kmalloc

Rasmus Villemoes (1):
      osd: fix signed char versus %02x issue

Tomas Henzl (1):
      mpt3sas: A correction in unmap_resources

Uma Krishnan (1):
      cxlflash: Removed driver date print

Wilfried Weissmann (1):
      mvsas: Add SGPIO support to Marvell 94xx

And the diffstat:

 .../devicetree/bindings/scsi/hisilicon-sas.txt     |   69 +
 MAINTAINERS                                        |    7 +
 drivers/block/cciss.c                              |    2 +-
 drivers/scsi/Kconfig                               |    2 +
 drivers/scsi/Makefile                              |    1 +
 drivers/scsi/aacraid/linit.c                       |    2 +-
 drivers/scsi/aic94xx/aic94xx_sas.h                 |   49 +-
 drivers/scsi/arcmsr/arcmsr.h                       |   14 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |  209 +-
 drivers/scsi/atp870u.c                             | 3707 ++++++--------------
 drivers/scsi/atp870u.h                             |    4 -
 drivers/scsi/bfa/bfa.h                             |    7 +-
 drivers/scsi/bfa/bfa_core.c                        |    7 +-
 drivers/scsi/bfa/bfa_cs.h                          |    7 +-
 drivers/scsi/bfa/bfa_defs.h                        |    7 +-
 drivers/scsi/bfa/bfa_defs_fcs.h                    |    7 +-
 drivers/scsi/bfa/bfa_defs_svc.h                    |    7 +-
 drivers/scsi/bfa/bfa_fc.h                          |    7 +-
 drivers/scsi/bfa/bfa_fcbuild.c                     |    7 +-
 drivers/scsi/bfa/bfa_fcbuild.h                     |    7 +-
 drivers/scsi/bfa/bfa_fcpim.c                       |    7 +-
 drivers/scsi/bfa/bfa_fcpim.h                       |    7 +-
 drivers/scsi/bfa/bfa_fcs.c                         |    7 +-
 drivers/scsi/bfa/bfa_fcs.h                         |    9 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c                   |    7 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |    9 +-
 drivers/scsi/bfa/bfa_fcs_rport.c                   |    7 +-
 drivers/scsi/bfa/bfa_hw_cb.c                       |    7 +-
 drivers/scsi/bfa/bfa_hw_ct.c                       |    7 +-
 drivers/scsi/bfa/bfa_ioc.c                         |    9 +-
 drivers/scsi/bfa/bfa_ioc.h                         |    7 +-
 drivers/scsi/bfa/bfa_ioc_cb.c                      |    7 +-
 drivers/scsi/bfa/bfa_ioc_ct.c                      |    7 +-
 drivers/scsi/bfa/bfa_modules.h                     |    7 +-
 drivers/scsi/bfa/bfa_plog.h                        |    7 +-
 drivers/scsi/bfa/bfa_port.c                        |    7 +-
 drivers/scsi/bfa/bfa_port.h                        |    7 +-
 drivers/scsi/bfa/bfa_svc.c                         |    7 +-
 drivers/scsi/bfa/bfa_svc.h                         |    7 +-
 drivers/scsi/bfa/bfad.c                            |   24 +-
 drivers/scsi/bfa/bfad_attr.c                       |   75 +-
 drivers/scsi/bfa/bfad_bsg.c                        |    7 +-
 drivers/scsi/bfa/bfad_bsg.h                        |    7 +-
 drivers/scsi/bfa/bfad_debugfs.c                    |    7 +-
 drivers/scsi/bfa/bfad_drv.h                        |    9 +-
 drivers/scsi/bfa/bfad_im.c                         |   35 +-
 drivers/scsi/bfa/bfad_im.h                         |    7 +-
 drivers/scsi/bfa/bfi.h                             |    7 +-
 drivers/scsi/bfa/bfi_ms.h                          |    7 +-
 drivers/scsi/bfa/bfi_reg.h                         |    9 +-
 drivers/scsi/cxlflash/common.h                     |    2 +
 drivers/scsi/cxlflash/main.c                       |   54 +-
 drivers/scsi/cxlflash/main.h                       |    5 +-
 drivers/scsi/cxlflash/superpipe.c                  |    8 +-
 drivers/scsi/cxlflash/vlun.c                       |    2 +
 drivers/scsi/device_handler/scsi_dh_alua.c         |  294 +-
 drivers/scsi/hisi_sas/Kconfig                      |    6 +
 drivers/scsi/hisi_sas/Makefile                     |    2 +
 drivers/scsi/hisi_sas/hisi_sas.h                   |  341 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 1358 +++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             | 1839 ++++++++++
 drivers/scsi/hpsa.c                                |  117 +-
 drivers/scsi/hpsa.h                                |    2 +-
 drivers/scsi/hpsa_cmd.h                            |   13 +
 drivers/scsi/initio.c                              |   16 -
 drivers/scsi/lpfc/lpfc.h                           |   16 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   48 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    6 +-
 drivers/scsi/lpfc/lpfc_ct.c                        | 1864 ++++++----
 drivers/scsi/lpfc/lpfc_els.c                       |  484 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   65 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |  184 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   52 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  198 +-
 drivers/scsi/lpfc/lpfc_mem.c                       |    6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  134 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   41 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   23 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |    1 +
 drivers/scsi/lpfc/lpfc_version.h                   |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |    8 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |    4 +-
 drivers/scsi/mvsas/mv_94xx.c                       |  134 +
 drivers/scsi/mvsas/mv_94xx.h                       |   71 +
 drivers/scsi/mvsas/mv_init.c                       |    2 +
 drivers/scsi/mvsas/mv_sas.c                        |   17 +-
 drivers/scsi/mvsas/mv_sas.h                        |    5 +
 drivers/scsi/osd/osd_initiator.c                   |    5 +-
 drivers/scsi/qla2xxx/Kconfig                       |    3 -
 drivers/scsi/qla2xxx/qla_os.c                      |    3 -
 drivers/scsi/scsi.c                                |   20 +-
 drivers/scsi/scsi_debug.c                          |   14 +-
 drivers/scsi/scsi_dh.c                             |   72 +-
 drivers/scsi/scsi_lib.c                            |  188 +
 drivers/scsi/scsi_priv.h                           |    3 +-
 drivers/scsi/scsi_scan.c                           |    4 +
 drivers/scsi/scsi_sysfs.c                          |   90 +-
 drivers/scsi/scsi_transport_fc.c                   |   12 +-
 drivers/scsi/scsi_transport_sas.c                  |   30 +
 drivers/scsi/ses.c                                 |   22 +-
 drivers/scsi/st.h                                  |    2 -
 drivers/scsi/storvsc_drv.c                         |  309 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |    2 +-
 drivers/scsi/vmw_pvscsi.c                          |   45 +-
 drivers/scsi/vmw_pvscsi.h                          |    2 +-
 include/scsi/sas.h                                 |   74 +
 include/scsi/scsi_dbg.h                            |    2 -
 include/scsi/scsi_device.h                         |    7 +-
 include/scsi/scsi_transport_sas.h                  |   10 +
 include/uapi/scsi/cxlflash_ioctl.h                 |   10 +
 110 files changed, 8214 insertions(+), 4601 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
 create mode 100644 drivers/scsi/hisi_sas/Kconfig
 create mode 100644 drivers/scsi/hisi_sas/Makefile
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas.h
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_main.c
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c

James

