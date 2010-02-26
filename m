From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 00/32] bfa: update bfa driver to version 2.1.2.1 (resubmit)
Date: Thu, 25 Feb 2010 17:46:20 -0800
Message-ID: <1267148780-21472-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:27233 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934883Ab0BZBvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:51:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Hi James,

We are resubmitting brocade bfa 2.1.2.1 driver patch. We completely reworked

the patch by hand merging previous checkins so that each patch addresses a

specific issue. We hope this patch set meets the upstream standard and gets

included in your scsi-misc tree. In the following weeks, we will submit more

patches to clean up the driver and reduce the number of files to be on par

with most of the upstream drivers.


Here are the changes we made in 2.1.2.1 driver:

Krishna Gudipati (32):
  bfa: Update the driver version to 2.1.2.1.
  bfa: Added separate MSI-X module parameters.
  bfa: Defined a new LPS event to clear virtual link on a vport
  bfa: Enable IOC auto-recovery and IOC type fix.
  bfa: Enable new halt interrupt in BFA.
  bfa: Changes to support FDMI Driver Parameter
  bfa: New interface to handle firmware upgrade scenario
  bfa: Fix to allow creation of only 190 vports on CNA.
  bfa: Resume BFA operations after firmware mismatch is resolved.
  bfa: IOC changes: Support faster recovery and split bfa_ioc.c into
    ASIC specific code.
  bfa: Clear LL_HALT and PSS_ERR bit when IOC crashes.
  bfa: Replace bfa_assert() with bfa_sm_fault()
  bfa: RPORT state machine: direct attach mode fix.
  bfa: Fix to copy fpma MAC when requested by user space application.
  bfa: PCI VPD, FIP and include file changes.
  bfa: FCS authentication related changes.
  bfa: Added firmware save clear feature for BFA driver.
  bfa: Introduce a link notification state machine.
  bfa: AEN and byte alignment fixes.
  bfa: IOC recovery fix in fcmode.
  bfa: Fix Command Queue (CPE) full condition check and ack CPE
    interrupt.
  bfa: In MSIX mode, ignore spurious RME interrupts when FCoE ports are
    in FW mismatch state.
  bfa: IOC fixes, check for IOC down condition
  bfa: Rename pport to fcport in BFA FCS.
  bfa: New portlog entries for events (FIP/FLOGI/FDISC/LOGO).
  bfa: Replace bfa_get_attr() with specific APIs
  bfa: Modified the portstats get/clear logic
  bfa: FCS and include file changes.
  bfa: Makefile changes for upstream driver upgrade.
  bfa: Handle SCSI IO underrun case.
  bfa: Support vport create/delete from sysfs.
  bfa: Remove unused header files and did some cleanup.

 drivers/scsi/bfa/Makefile                          |    6 +-
 drivers/scsi/bfa/bfa_core.c                        |   19 +
 drivers/scsi/bfa/bfa_fcport.c                      | 1707 +++++++++++---------
 drivers/scsi/bfa/bfa_fcs.c                         |   63 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |   75 +-
 drivers/scsi/bfa/bfa_fcs_port.c                    |   11 +-
 drivers/scsi/bfa/bfa_fcs_uf.c                      |    8 +-
 drivers/scsi/bfa/bfa_hw_cb.c                       |   13 +
 drivers/scsi/bfa/bfa_hw_ct.c                       |    9 +
 drivers/scsi/bfa/bfa_intr.c                        |  111 +-
 drivers/scsi/bfa/bfa_ioc.c                         |  762 +++------
 drivers/scsi/bfa/bfa_ioc.h                         |   57 +-
 drivers/scsi/bfa/bfa_ioc_cb.c                      |  274 ++++
 drivers/scsi/bfa/bfa_ioc_ct.c                      |  424 +++++
 drivers/scsi/bfa/bfa_iocfc.c                       |   24 +-
 drivers/scsi/bfa/bfa_iocfc.h                       |    3 +
 drivers/scsi/bfa/bfa_ioim.c                        |   22 +-
 drivers/scsi/bfa/bfa_itnim.c                       |   30 +-
 drivers/scsi/bfa/bfa_lps.c                         |  134 ++-
 drivers/scsi/bfa/bfa_module.c                      |    4 +-
 drivers/scsi/bfa/bfa_modules_priv.h                |    2 +-
 drivers/scsi/bfa/bfa_port_priv.h                   |   57 +-
 drivers/scsi/bfa/bfa_priv.h                        |    2 +-
 drivers/scsi/bfa/bfa_rport.c                       |   26 +-
 drivers/scsi/bfa/bfa_trcmod_priv.h                 |   62 +-
 drivers/scsi/bfa/bfa_tskim.c                       |   14 +-
 drivers/scsi/bfa/bfad.c                            |  208 ++-
 drivers/scsi/bfa/bfad_attr.c                       |  180 ++-
 drivers/scsi/bfa/bfad_attr.h                       |    9 -
 drivers/scsi/bfa/bfad_drv.h                        |   35 +-
 drivers/scsi/bfa/bfad_im.c                         |   53 +-
 drivers/scsi/bfa/bfad_im.h                         |    5 -
 drivers/scsi/bfa/bfad_intr.c                       |   11 +-
 drivers/scsi/bfa/fabric.c                          |   59 +-
 drivers/scsi/bfa/fcbuild.h                         |    6 +
 drivers/scsi/bfa/fcpim.c                           |   51 +-
 drivers/scsi/bfa/fcs_fabric.h                      |    2 +
 drivers/scsi/bfa/fcs_fcpim.h                       |    5 -
 drivers/scsi/bfa/fcs_lport.h                       |    7 +-
 drivers/scsi/bfa/fcs_port.h                        |    3 +-
 drivers/scsi/bfa/fcs_rport.h                       |    3 -
 drivers/scsi/bfa/fcs_uf.h                          |    3 +-
 drivers/scsi/bfa/fcs_vport.h                       |    8 -
 drivers/scsi/bfa/fdmi.c                            |   78 +-
 drivers/scsi/bfa/include/aen/bfa_aen.h             |   50 +-
 drivers/scsi/bfa/include/bfa.h                     |   22 +
 drivers/scsi/bfa/include/bfa_svc.h                 |  101 +-
 drivers/scsi/bfa/include/bfa_timer.h               |    2 +-
 drivers/scsi/bfa/include/bfi/bfi.h                 |    4 +-
 drivers/scsi/bfa/include/bfi/bfi_cbreg.h           |   16 +-
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h           |   26 +
 drivers/scsi/bfa/include/bfi/bfi_ioc.h             |    2 +-
 drivers/scsi/bfa/include/bfi/bfi_lps.h             |    8 +
 drivers/scsi/bfa/include/bfi/bfi_pport.h           |  172 +--
 drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h      |    4 +
 drivers/scsi/bfa/include/cs/bfa_log.h              |    2 +-
 drivers/scsi/bfa/include/cs/bfa_plog.h             |    9 +-
 drivers/scsi/bfa/include/cs/bfa_sm.h               |    8 +
 drivers/scsi/bfa/include/defs/bfa_defs_aen.h       |   10 +
 drivers/scsi/bfa/include/defs/bfa_defs_auth.h      |   22 +
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h       |   14 +-
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h    |    3 +-
 drivers/scsi/bfa/include/defs/bfa_defs_ethport.h   |    1 +
 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h    |   94 ++
 drivers/scsi/bfa/include/defs/bfa_defs_im_common.h |   32 -
 drivers/scsi/bfa/include/defs/bfa_defs_im_team.h   |   72 -
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h       |    3 +-
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h     |   12 +-
 drivers/scsi/bfa/include/defs/bfa_defs_lport.h     |    4 +-
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h       |  111 ++-
 drivers/scsi/bfa/include/defs/bfa_defs_port.h      |   19 +-
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |  151 +-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h    |   17 +-
 drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h       |    1 -
 drivers/scsi/bfa/include/fcs/bfa_fcs.h             |    5 +-
 drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h       |    8 -
 drivers/scsi/bfa/include/log/bfa_log_hal.h         |    6 +
 drivers/scsi/bfa/include/log/bfa_log_linux.h       |   16 +
 drivers/scsi/bfa/include/protocol/fc.h             |    5 +
 drivers/scsi/bfa/include/protocol/pcifw.h          |   75 -
 drivers/scsi/bfa/loop.c                            |    2 +-
 drivers/scsi/bfa/lport_api.c                       |    5 +-
 drivers/scsi/bfa/ms.c                              |   29 +-
 drivers/scsi/bfa/ns.c                              |   36 +-
 drivers/scsi/bfa/rport.c                           |   91 +-
 drivers/scsi/bfa/rport_api.c                       |    2 +-
 drivers/scsi/bfa/rport_ftrs.c                      |   12 +-
 drivers/scsi/bfa/scn.c                             |   10 +-
 drivers/scsi/bfa/vport.c                           |   86 +-
 89 files changed, 3588 insertions(+), 2437 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfa_ioc_cb.c
 create mode 100644 drivers/scsi/bfa/bfa_ioc_ct.c
 create mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_im_common.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_im_team.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/pcifw.h

Thanks,
Krishna Chaitanya Gudipati.

