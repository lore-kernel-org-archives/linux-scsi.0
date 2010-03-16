From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] final scsi updates for 2.6.34-rc1
Date: Tue, 16 Mar 2010 10:11:44 -0700
Message-ID: <1268759504.21384.29.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

OK, I think we've got understanding that this is the *second* pull
request from SCSI ... it's just all the changes that got flushed out
during the merge window, so I'm resubmitting it.

Going forwards, we're going to try to send in our last pull at the 11th
day, which means it needs to be in my scsi-misc tree by the 8th day of
the merge window (to get sufficient a work out in linux-next).  We're
also going to try to move as much stuff as we can from the second pull
to the first one, so this practice will be acceptable only if the second
pull is a lot smaller than the first one.

The tree is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Boaz Harrosh (1):
      libosd: Fix unchecked err return found by smatch

Brian King (2):
      ibmvfc: Add suspend/resume support
      ibmvscsi: Add suspend/resume support

Gal Rosen (1):
      scsi_transport_fc: Fix synchronization issue while deleting vport

Hannes Reinecke (1):
      scsi_dh_emc: fix mode select request setup

James Bottomley (1):
      raid_attrs: fix dependency problems

James Smart (7):
      lpfc 8.3.10: Update Driver version to 8.3.10
      lpfc 8.3.10: Added round robin FCF failover
      lpfc 8.3.10: Fix Discovery issues
      lpfc 8.3.10: Added management for LP21000 through BSG.
      lpfc 8.3.10: Update SLI interface areas
      lpfc 8.3.10: Fix user interface issues
      lpfc 8.3.10: Fix Initialization issues

Jayamohan Kallickal (7):
      be2iscsi: Alloc only one EQ if intr mode
      be2iscsi: Fixing memory allocation for connection
      be2iscsi: Remove debug code
      be2iscsi: cleans up abort handling
      be2iscsi: Fix for a possible udelay while holding lock
      be2iscsi: Cleanup of resets for device and target
      libiscsi: Make iscsi_eh_target_reset start with session reset

Krishna Gudipati (30):
      bfa: Update the driver version to 2.1.2.1.
      bfa: Remove unused header files and did some cleanup.
      bfa: Handle SCSI IO underrun case.
      bfa: FCS and include file changes.
      bfa: Modified the portstats get/clear logic
      bfa: Replace bfa_get_attr() with specific APIs
      bfa: New portlog entries for events (FIP/FLOGI/FDISC/LOGO).
      bfa: Rename pport to fcport in BFA FCS.
      bfa: IOC fixes, check for IOC down condition.
      bfa: In MSIX mode, ignore spurious RME interrupts when FCoE ports are in FW mismatch state.
      bfa: Fix Command Queue (CPE) full condition check and ack CPE interrupt.
      bfa: IOC recovery fix in fcmode.
      bfa: AEN and byte alignment fixes.
      bfa: Introduce a link notification state machine.
      bfa: Added firmware save clear feature for BFA driver.
      bfa: FCS authentication related changes.
      bfa: PCI VPD, FIP and include file changes.
      bfa: Fix to copy fpma MAC when requested by user space application.
      bfa: RPORT state machine: direct attach mode fix.
      bfa: Replace bfa_assert() with bfa_sm_fault()
      bfa: Clear LL_HALT and PSS_ERR bit when IOC crashes.
      bfa: IOC changes: Support faster recovery and split bfa_ioc.c into ASIC specific code.
      bfa: Resume BFA operations after firmware mismatch is resolved.
      bfa: Fix to allow creation of only 190 vports on CNA.
      bfa: New interface to handle firmware upgrade scenario
      bfa: Changes to support FDMI Driver Parameter
      bfa: Enable new halt interrupt in BFA.
      bfa: Enable IOC auto-recovery and IOC type fix.
      bfa: Defined a new LPS event to clear virtual link on a vport
      bfa: Added separate MSI-X module parameters.

Martin K. Petersen (1):
      sd: Fix VPD buffer allocations

Mike Miller (1):
      hpsa: remove scan thread

Stephen M. Cameron (8):
      hpsa: remove unused members next, prev, and retry_count from command list structure.
      hpsa: Increase the number of scatter gather elements supported.
      hpsa: Clarify calculation of padding for commandlist structure
      hpsa: mark hpsa_pci_init as __devinit
      hpsa: return -ENOMEM, not -1
      hpsa: fix scsi status mis-shift
      hpsa: fix firmwart typo
      hpsa: allow modifying device queue depth.

Wayne Boyer (9):
      ipr: adds PCI ID definitions for new adapters
      ipr: add support for new IOASCs
      ipr: add support for multiple stages of initialization
      ipr: implement shutdown changes and remove obsolete write cache parameter
      ipr: add hardware assisted smart dump functionality
      ipr: add error handling updates for the next generation chip
      ipr: update the configuration table code for the next generation chip
      ipr: define new offsets to registers for the next generation chip
      ipr: add support for new adapter command structures for the next generation chip

The diffstat is:

 drivers/infiniband/ulp/iser/iscsi_iser.c           |    2 
 drivers/scsi/Kconfig                               |    6 
 drivers/scsi/be2iscsi/be_cmds.c                    |    7 
 drivers/scsi/be2iscsi/be_iscsi.c                   |    4 
 drivers/scsi/be2iscsi/be_main.c                    |  201 +-
 drivers/scsi/be2iscsi/be_main.h                    |   11 
 drivers/scsi/be2iscsi/be_mgmt.c                    |   14 
 drivers/scsi/be2iscsi/be_mgmt.h                    |    8 
 drivers/scsi/bfa/Makefile                          |    8 
 drivers/scsi/bfa/bfa_core.c                        |   19 
 drivers/scsi/bfa/bfa_fcport.c                      | 1709 +++++++++++---------
 drivers/scsi/bfa/bfa_fcs.c                         |   63 
 drivers/scsi/bfa/bfa_fcs_lport.c                   |   75 
 drivers/scsi/bfa/bfa_fcs_port.c                    |   11 
 drivers/scsi/bfa/bfa_fcs_uf.c                      |    8 
 drivers/scsi/bfa/bfa_hw_cb.c                       |   13 
 drivers/scsi/bfa/bfa_hw_ct.c                       |    9 
 drivers/scsi/bfa/bfa_intr.c                        |  111 -
 drivers/scsi/bfa/bfa_ioc.c                         |  762 ++-------
 drivers/scsi/bfa/bfa_ioc.h                         |   57 
 drivers/scsi/bfa/bfa_ioc_cb.c                      |  274 +++
 drivers/scsi/bfa/bfa_ioc_ct.c                      |  423 +++++
 drivers/scsi/bfa/bfa_iocfc.c                       |   24 
 drivers/scsi/bfa/bfa_iocfc.h                       |    3 
 drivers/scsi/bfa/bfa_ioim.c                        |   22 
 drivers/scsi/bfa/bfa_itnim.c                       |   30 
 drivers/scsi/bfa/bfa_lps.c                         |  134 +
 drivers/scsi/bfa/bfa_module.c                      |    4 
 drivers/scsi/bfa/bfa_modules_priv.h                |    2 
 drivers/scsi/bfa/bfa_port_priv.h                   |   57 
 drivers/scsi/bfa/bfa_priv.h                        |    2 
 drivers/scsi/bfa/bfa_rport.c                       |   26 
 drivers/scsi/bfa/bfa_trcmod_priv.h                 |   62 
 drivers/scsi/bfa/bfa_tskim.c                       |   14 
 drivers/scsi/bfa/bfad.c                            |  208 +-
 drivers/scsi/bfa/bfad_attr.c                       |   76 
 drivers/scsi/bfa/bfad_attr.h                       |    9 
 drivers/scsi/bfa/bfad_drv.h                        |   35 
 drivers/scsi/bfa/bfad_im.c                         |   53 
 drivers/scsi/bfa/bfad_im.h                         |    5 
 drivers/scsi/bfa/bfad_intr.c                       |   11 
 drivers/scsi/bfa/fabric.c                          |   59 
 drivers/scsi/bfa/fcbuild.h                         |    6 
 drivers/scsi/bfa/fcpim.c                           |   51 
 drivers/scsi/bfa/fcs_fabric.h                      |    2 
 drivers/scsi/bfa/fcs_fcpim.h                       |    5 
 drivers/scsi/bfa/fcs_lport.h                       |    7 
 drivers/scsi/bfa/fcs_port.h                        |    3 
 drivers/scsi/bfa/fcs_rport.h                       |    3 
 drivers/scsi/bfa/fcs_uf.h                          |    3 
 drivers/scsi/bfa/fcs_vport.h                       |    8 
 drivers/scsi/bfa/fdmi.c                            |   79 
 drivers/scsi/bfa/include/aen/bfa_aen.h             |   50 
 drivers/scsi/bfa/include/bfa.h                     |   22 
 drivers/scsi/bfa/include/bfa_svc.h                 |  101 -
 drivers/scsi/bfa/include/bfa_timer.h               |    2 
 drivers/scsi/bfa/include/bfi/bfi.h                 |    4 
 drivers/scsi/bfa/include/bfi/bfi_cbreg.h           |   16 
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h           |   26 
 drivers/scsi/bfa/include/bfi/bfi_ioc.h             |    2 
 drivers/scsi/bfa/include/bfi/bfi_lps.h             |    8 
 drivers/scsi/bfa/include/bfi/bfi_pport.h           |  172 --
 drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h      |    4 
 drivers/scsi/bfa/include/cs/bfa_log.h              |    2 
 drivers/scsi/bfa/include/cs/bfa_plog.h             |    9 
 drivers/scsi/bfa/include/cs/bfa_sm.h               |    8 
 drivers/scsi/bfa/include/defs/bfa_defs_aen.h       |   10 
 drivers/scsi/bfa/include/defs/bfa_defs_auth.h      |   22 
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h       |   14 
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h    |    3 
 drivers/scsi/bfa/include/defs/bfa_defs_ethport.h   |    1 
 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h    |   94 +
 drivers/scsi/bfa/include/defs/bfa_defs_im_common.h |   32 
 drivers/scsi/bfa/include/defs/bfa_defs_im_team.h   |   72 
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h       |    3 
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h     |   12 
 drivers/scsi/bfa/include/defs/bfa_defs_lport.h     |    4 
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h       |  111 +
 drivers/scsi/bfa/include/defs/bfa_defs_port.h      |   19 
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |  151 +
 drivers/scsi/bfa/include/defs/bfa_defs_status.h    |   17 
 drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h       |    1 
 drivers/scsi/bfa/include/fcs/bfa_fcs.h             |    5 
 drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h       |    8 
 drivers/scsi/bfa/include/log/bfa_log_hal.h         |    6 
 drivers/scsi/bfa/include/log/bfa_log_linux.h       |   16 
 drivers/scsi/bfa/include/protocol/fc.h             |    5 
 drivers/scsi/bfa/include/protocol/pcifw.h          |   75 
 drivers/scsi/bfa/loop.c                            |    2 
 drivers/scsi/bfa/lport_api.c                       |    5 
 drivers/scsi/bfa/ms.c                              |   29 
 drivers/scsi/bfa/ns.c                              |   36 
 drivers/scsi/bfa/rport.c                           |   91 -
 drivers/scsi/bfa/rport_api.c                       |    2 
 drivers/scsi/bfa/rport_ftrs.c                      |   12 
 drivers/scsi/bfa/scn.c                             |   10 
 drivers/scsi/bfa/vport.c                           |   86 -
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    2 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c                 |    2 
 drivers/scsi/device_handler/scsi_dh_emc.c          |    6 
 drivers/scsi/hpsa.c                                |  330 +--
 drivers/scsi/hpsa.h                                |    7 
 drivers/scsi/hpsa_cmd.h                            |   20 
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   27 
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   19 
 drivers/scsi/ibmvscsi/ibmvscsi.h                   |    1 
 drivers/scsi/ibmvscsi/iseries_vscsi.c              |    6 
 drivers/scsi/ibmvscsi/rpa_vscsi.c                  |   13 
 drivers/scsi/ipr.c                                 | 1756 ++++++++++++++++-----
 drivers/scsi/ipr.h                                 |  467 ++++-
 drivers/scsi/iscsi_tcp.c                           |    2 
 drivers/scsi/libiscsi.c                            |   23 
 drivers/scsi/lpfc/lpfc.h                           |   10 
 drivers/scsi/lpfc/lpfc_attr.c                      |    7 
 drivers/scsi/lpfc/lpfc_bsg.c                       |  332 +++
 drivers/scsi/lpfc/lpfc_bsg.h                       |   12 
 drivers/scsi/lpfc/lpfc_crtn.h                      |    7 
 drivers/scsi/lpfc/lpfc_els.c                       |  142 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  527 ++++--
 drivers/scsi/lpfc/lpfc_init.c                      |  277 ++-
 drivers/scsi/lpfc/lpfc_logmsg.h                    |    1 
 drivers/scsi/lpfc/lpfc_mbox.c                      |    8 
 drivers/scsi/lpfc/lpfc_scsi.c                      |   49 
 drivers/scsi/lpfc/lpfc_sli.c                       |  413 ++++
 drivers/scsi/lpfc/lpfc_sli.h                       |    1 
 drivers/scsi/lpfc/lpfc_sli4.h                      |   38 
 drivers/scsi/lpfc/lpfc_version.h                   |    2 
 drivers/scsi/lpfc/lpfc_vport.c                     |    7 
 drivers/scsi/osd/osd_initiator.c                   |    4 
 drivers/scsi/raid_class.c                          |    2 
 drivers/scsi/scsi_transport_fc.c                   |   24 
 drivers/scsi/sd.c                                  |    4 
 include/scsi/libiscsi.h                            |    3 
 133 files changed, 7204 insertions(+), 3525 deletions(-)

James
