From: <kgudipat@brocade.com>
Subject: [PATCH 00/33] bfa: Brocade BFA FC SCSI driver v2.3.2.0 submission.
Date: Wed, 15 Sep 2010 11:50:49 -0700
Message-ID: <1284576649-12684-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56589 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043Ab0IOSvD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 14:51:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

This is the cleaned up Brocade BFA FC SCSI driver v2.3.2.0 submission.

We have flattened the BFA hierarchy and also reduced the number of
source and header files we used to have earlier.

This patchset is organized as follows:

	- The initial 15 patches will be cleaning up the current existing code as follows:

	  a) We flattened the BFA, removed unused source/header files & merged related ones.

	  b) We removed some of the files first even though they are going to stay in the new
	     2.3.2.0 cleaned up BFA, since this will make reviewing the code easier, else the
	     diff gets really confusing. Hope its ok.

	- The next 18 patches will pull back in the cleaned up 2.3.2.0 based BFA driver and
	  the changes that were needed while flattening / cleaning up the BFA driver.

I have compiled & tested the code against your scsi-misc and net-next (2.6.36-rc3-0-3-default).

Please note that the patches are not bisectable, since this cleanup needed lot of changes.

We hope this patch set meets the upstream standard and gets included in your scsi-misc tree.

Thanks,
Krishna C Gudipati.

Krishna Gudipati (33):
  bfa:(Cleanup Patch) Remove the include subdir and flatten BFA.
  bfa: (Cleanup Patch) Remove the per BFA sub-module files.
  bfa: (Cleanup Patch) Remove all FCP IM related files.
  bfa: (Cleanup Patch) Consolidate interface functions between BFAD and
    BFA sub-modules.
  bfa: (Cleanup Patch) BFA code consolidation / cleanup.
  bfa: (Cleanup Patch) BFA FCS LPORT code consolidation / cleanup.
  bfa: (Cleanup Patch) BFA FCS RPORT code consolidation / cleanup.
  bfa: (Cleanup Patch)- BFA FCS code consolidation / cleanup.
  bfa: (Cleanup Patch) BFA FCS code consolidation / cleanup.
  bfa: (Cleanup Patch) Remove the per BFA sub-module header files.
  bfa: (Cleanup Patch) BFA header file consolidation / cleanup.
  bfa: (Cleanup Patch) BFA FCS header file consolidation / cleanup.
  bfa: (Cleanup Patch) BFA header file consolidation / cleanup.
  bfa: (Cleanup Patch) BFAD header file consolidation / cleanup.
  bfa: (Cleanup Patch) BFAD file consolidation / cleanup.
  bfa: Add cleaned up (2.3.2.0) BFA driver specific code .
  bfa: Add cleaned up (2.3.2.0) BFA driver specific header files.
  bfa: Add back cleaned up BFA specific header files.
  bfa: Add back cleaned up consolidated BFA FCS specific header file.
  bfa: Add back cleaned up consolidated BFA sub-modules header file.
  bfa: Add back cleaned up bfa definitions header files to top-level
    BFA.
  bfa: Add back cleaned up bfa to firmware interface header files.
  bfa: Add cleaned up bfa FCP specifc header files.
  bfa: Add back BFA FCP(IM) & port specifc header files.
  bfa: IOC state machine restructuring / cleanup changes.
  bfa: Add cleaned up BFAD to BFA sub-modules interface.
  bfa: Add cleaned up consolidated BFA sub-module definitions to
    interface with BFA.
  bfa: Add back consolidated BFA & FCS FCP(IM) handling definitions.
  bfa: Add back cleaned up BFA FCS Logical PORT handling.
  bfa: Add back cleaned up BFA FCS Remote PORT handling.
  bfa: Add cleaned up BFA FC link service frame building and parsing
    routines.
  bfa: Add cleaned up BFAD to FCS interfaces.
  bfa: Update to (2.3.2.0) Makefile changes.

 drivers/scsi/bfa/Makefile                          |   17 +-
 drivers/scsi/bfa/bfa.h                             |  438 ++
 drivers/scsi/bfa/bfa_callback_priv.h               |   57 -
 drivers/scsi/bfa/bfa_cb_ioim.h                     |  169 +
 drivers/scsi/bfa/bfa_cb_ioim_macros.h              |  181 -
 drivers/scsi/bfa/bfa_cee.c                         |  492 --
 drivers/scsi/bfa/bfa_core.c                        | 1131 ++++-
 drivers/scsi/bfa/bfa_cs.h                          |  364 ++
 drivers/scsi/bfa/bfa_csdebug.c                     |   58 -
 drivers/scsi/bfa/bfa_defs.h                        |  466 ++
 drivers/scsi/bfa/bfa_defs_fcs.h                    |  457 ++
 drivers/scsi/bfa/bfa_defs_svc.h                    | 1081 ++++
 drivers/scsi/bfa/bfa_drv.c                         |  107 +
 drivers/scsi/bfa/bfa_fc.h                          | 1916 +++++++
 drivers/scsi/bfa/bfa_fcbuild.c                     | 1410 +++++
 drivers/scsi/bfa/bfa_fcbuild.h                     |  316 ++
 drivers/scsi/bfa/bfa_fcpim.c                       | 3460 +++++++++++++-
 drivers/scsi/bfa/bfa_fcpim.h                       |  401 ++
 drivers/scsi/bfa/bfa_fcpim_priv.h                  |  192 -
 drivers/scsi/bfa/bfa_fcport.c                      | 1962 -------
 drivers/scsi/bfa/bfa_fcs.c                         | 1611 ++++++-
 drivers/scsi/bfa/bfa_fcs.h                         |  779 +++
 drivers/scsi/bfa/bfa_fcs_fcpim.c                   |  783 +++
 drivers/scsi/bfa/bfa_fcs_lport.c                   | 5413 +++++++++++++++++++-
 drivers/scsi/bfa/bfa_fcs_port.c                    |   61 -
 drivers/scsi/bfa/bfa_fcs_rport.c                   | 3126 +++++++++++
 drivers/scsi/bfa/bfa_fcs_uf.c                      |   99 -
 drivers/scsi/bfa/bfa_fcxp.c                        |  774 ---
 drivers/scsi/bfa/bfa_fcxp_priv.h                   |  138 -
 drivers/scsi/bfa/bfa_fwimg_priv.h                  |   44 -
 drivers/scsi/bfa/bfa_hw_cb.c                       |    8 +-
 drivers/scsi/bfa/bfa_hw_ct.c                       |   11 +-
 drivers/scsi/bfa/bfa_intr.c                        |  270 -
 drivers/scsi/bfa/bfa_intr_priv.h                   |  117 -
 drivers/scsi/bfa/bfa_ioc.c                         | 1984 +++++---
 drivers/scsi/bfa/bfa_ioc.h                         |  248 +-
 drivers/scsi/bfa/bfa_ioc_cb.c                      |  124 +-
 drivers/scsi/bfa/bfa_ioc_ct.c                      |  137 +-
 drivers/scsi/bfa/bfa_iocfc.c                       |  927 ----
 drivers/scsi/bfa/bfa_iocfc.h                       |  184 -
 drivers/scsi/bfa/bfa_iocfc_q.c                     |   44 -
 drivers/scsi/bfa/bfa_ioim.c                        | 1364 -----
 drivers/scsi/bfa/bfa_itnim.c                       | 1088 ----
 drivers/scsi/bfa/bfa_log.c                         |  346 --
 drivers/scsi/bfa/bfa_log_module.c                  |  537 --
 drivers/scsi/bfa/bfa_lps.c                         |  892 ----
 drivers/scsi/bfa/bfa_lps_priv.h                    |   38 -
 drivers/scsi/bfa/bfa_module.c                      |   90 -
 drivers/scsi/bfa/bfa_modules.h                     |  130 +
 drivers/scsi/bfa/bfa_modules_priv.h                |   43 -
 drivers/scsi/bfa/bfa_os_inc.h                      |  144 +-
 drivers/scsi/bfa/bfa_plog.h                        |  159 +
 drivers/scsi/bfa/bfa_port.c                        |  134 +-
 drivers/scsi/bfa/bfa_port.h                        |   66 +
 drivers/scsi/bfa/bfa_port_priv.h                   |   94 -
 drivers/scsi/bfa/bfa_priv.h                        |  110 -
 drivers/scsi/bfa/bfa_rport.c                       |  906 ----
 drivers/scsi/bfa/bfa_rport_priv.h                  |   45 -
 drivers/scsi/bfa/bfa_sgpg.c                        |  226 -
 drivers/scsi/bfa/bfa_sgpg_priv.h                   |   79 -
 drivers/scsi/bfa/bfa_sm.c                          |   38 -
 drivers/scsi/bfa/bfa_svc.c                         | 5423 ++++++++++++++++++++
 drivers/scsi/bfa/bfa_svc.h                         |  657 +++
 drivers/scsi/bfa/bfa_timer.c                       |   90 -
 drivers/scsi/bfa/bfa_trcmod_priv.h                 |   64 -
 drivers/scsi/bfa/bfa_tskim.c                       |  690 ---
 drivers/scsi/bfa/bfa_uf.c                          |  343 --
 drivers/scsi/bfa/bfa_uf_priv.h                     |   47 -
 drivers/scsi/bfa/bfad.c                            | 1355 +++--
 drivers/scsi/bfa/bfad_attr.c                       |  241 +-
 drivers/scsi/bfa/bfad_attr.h                       |   56 -
 drivers/scsi/bfa/bfad_debugfs.c                    |   10 +-
 drivers/scsi/bfa/bfad_drv.h                        |  254 +-
 drivers/scsi/bfa/bfad_fwimg.c                      |  131 -
 drivers/scsi/bfa/bfad_im.c                         |  257 +-
 drivers/scsi/bfa/bfad_im.h                         |   56 +-
 drivers/scsi/bfa/bfad_im_compat.h                  |   45 -
 drivers/scsi/bfa/bfad_intr.c                       |  222 -
 drivers/scsi/bfa/bfad_ipfc.h                       |   42 -
 drivers/scsi/bfa/bfad_os.c                         |   50 -
 drivers/scsi/bfa/bfad_tm.h                         |   59 -
 drivers/scsi/bfa/bfad_trcmod.h                     |   52 -
 drivers/scsi/bfa/bfi.h                             |  579 +++
 drivers/scsi/bfa/bfi_cbreg.h                       |  304 ++
 drivers/scsi/bfa/bfi_ctreg.h                       |  627 +++
 drivers/scsi/bfa/bfi_ms.h                          |  765 +++
 drivers/scsi/bfa/fab.c                             |   62 -
 drivers/scsi/bfa/fabric.c                          | 1323 -----
 drivers/scsi/bfa/fcbuild.c                         | 1449 ------
 drivers/scsi/bfa/fcbuild.h                         |  279 -
 drivers/scsi/bfa/fcpim.c                           |  824 ---
 drivers/scsi/bfa/fcptm.c                           |   68 -
 drivers/scsi/bfa/fcs.h                             |   30 -
 drivers/scsi/bfa/fcs_auth.h                        |   37 -
 drivers/scsi/bfa/fcs_fabric.h                      |   68 -
 drivers/scsi/bfa/fcs_fcpim.h                       |   39 -
 drivers/scsi/bfa/fcs_fcptm.h                       |   45 -
 drivers/scsi/bfa/fcs_fcxp.h                        |   29 -
 drivers/scsi/bfa/fcs_lport.h                       |  118 -
 drivers/scsi/bfa/fcs_ms.h                          |   35 -
 drivers/scsi/bfa/fcs_port.h                        |   31 -
 drivers/scsi/bfa/fcs_rport.h                       |   61 -
 drivers/scsi/bfa/fcs_trcmod.h                      |   56 -
 drivers/scsi/bfa/fcs_uf.h                          |   31 -
 drivers/scsi/bfa/fcs_vport.h                       |   32 -
 drivers/scsi/bfa/fdmi.c                            | 1230 -----
 drivers/scsi/bfa/include/aen/bfa_aen.h             |   96 -
 drivers/scsi/bfa/include/aen/bfa_aen_adapter.h     |   31 -
 drivers/scsi/bfa/include/aen/bfa_aen_audit.h       |   31 -
 drivers/scsi/bfa/include/aen/bfa_aen_ethport.h     |   35 -
 drivers/scsi/bfa/include/aen/bfa_aen_ioc.h         |   45 -
 drivers/scsi/bfa/include/aen/bfa_aen_itnim.h       |   33 -
 drivers/scsi/bfa/include/aen/bfa_aen_lport.h       |   51 -
 drivers/scsi/bfa/include/aen/bfa_aen_port.h        |   57 -
 drivers/scsi/bfa/include/aen/bfa_aen_rport.h       |   37 -
 drivers/scsi/bfa/include/bfa.h                     |  203 -
 drivers/scsi/bfa/include/bfa_fcpim.h               |  177 -
 drivers/scsi/bfa/include/bfa_fcptm.h               |   47 -
 drivers/scsi/bfa/include/bfa_svc.h                 |  338 --
 drivers/scsi/bfa/include/bfa_timer.h               |   53 -
 drivers/scsi/bfa/include/bfi/bfi.h                 |  174 -
 drivers/scsi/bfa/include/bfi/bfi_boot.h            |   34 -
 drivers/scsi/bfa/include/bfi/bfi_cbreg.h           |  319 --
 drivers/scsi/bfa/include/bfi/bfi_cee.h             |  119 -
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h           |  640 ---
 drivers/scsi/bfa/include/bfi/bfi_fabric.h          |   92 -
 drivers/scsi/bfa/include/bfi/bfi_fcpim.h           |  301 --
 drivers/scsi/bfa/include/bfi/bfi_fcxp.h            |   71 -
 drivers/scsi/bfa/include/bfi/bfi_ioc.h             |  208 -
 drivers/scsi/bfa/include/bfi/bfi_iocfc.h           |  179 -
 drivers/scsi/bfa/include/bfi/bfi_lport.h           |   89 -
 drivers/scsi/bfa/include/bfi/bfi_lps.h             |  104 -
 drivers/scsi/bfa/include/bfi/bfi_pbc.h             |   62 -
 drivers/scsi/bfa/include/bfi/bfi_port.h            |  115 -
 drivers/scsi/bfa/include/bfi/bfi_pport.h           |  118 -
 drivers/scsi/bfa/include/bfi/bfi_rport.h           |  104 -
 drivers/scsi/bfa/include/bfi/bfi_uf.h              |   52 -
 drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h      |   40 -
 drivers/scsi/bfa/include/cna/cee/bfa_cee.h         |   77 -
 drivers/scsi/bfa/include/cna/port/bfa_port.h       |   70 -
 drivers/scsi/bfa/include/cna/pstats/ethport_defs.h |   36 -
 drivers/scsi/bfa/include/cna/pstats/phyport_defs.h |  218 -
 drivers/scsi/bfa/include/cs/bfa_checksum.h         |   60 -
 drivers/scsi/bfa/include/cs/bfa_debug.h            |   45 -
 drivers/scsi/bfa/include/cs/bfa_log.h              |  184 -
 drivers/scsi/bfa/include/cs/bfa_perf.h             |   34 -
 drivers/scsi/bfa/include/cs/bfa_plog.h             |  167 -
 drivers/scsi/bfa/include/cs/bfa_q.h                |   81 -
 drivers/scsi/bfa/include/cs/bfa_sm.h               |   77 -
 drivers/scsi/bfa/include/cs/bfa_trc.h              |  176 -
 drivers/scsi/bfa/include/cs/bfa_wc.h               |   68 -
 drivers/scsi/bfa/include/defs/bfa_defs_adapter.h   |   83 -
 drivers/scsi/bfa/include/defs/bfa_defs_aen.h       |   83 -
 drivers/scsi/bfa/include/defs/bfa_defs_audit.h     |   38 -
 drivers/scsi/bfa/include/defs/bfa_defs_auth.h      |  134 -
 drivers/scsi/bfa/include/defs/bfa_defs_boot.h      |   81 -
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h       |  157 -
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h    |   41 -
 drivers/scsi/bfa/include/defs/bfa_defs_ethport.h   |   99 -
 drivers/scsi/bfa/include/defs/bfa_defs_fcpim.h     |   45 -
 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h    |   88 -
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h       |  158 -
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h     |  322 --
 drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h      |   70 -
 drivers/scsi/bfa/include/defs/bfa_defs_itnim.h     |  136 -
 drivers/scsi/bfa/include/defs/bfa_defs_led.h       |   35 -
 drivers/scsi/bfa/include/defs/bfa_defs_lport.h     |   68 -
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h       |  144 -
 drivers/scsi/bfa/include/defs/bfa_defs_pci.h       |   48 -
 drivers/scsi/bfa/include/defs/bfa_defs_pm.h        |   33 -
 drivers/scsi/bfa/include/defs/bfa_defs_pom.h       |   56 -
 drivers/scsi/bfa/include/defs/bfa_defs_port.h      |  248 -
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |  393 --
 drivers/scsi/bfa/include/defs/bfa_defs_qos.h       |   99 -
 drivers/scsi/bfa/include/defs/bfa_defs_rport.h     |  199 -
 drivers/scsi/bfa/include/defs/bfa_defs_status.h    |  282 -
 drivers/scsi/bfa/include/defs/bfa_defs_tin.h       |  118 -
 drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h   |   43 -
 drivers/scsi/bfa/include/defs/bfa_defs_types.h     |   30 -
 drivers/scsi/bfa/include/defs/bfa_defs_version.h   |   22 -
 drivers/scsi/bfa/include/defs/bfa_defs_vf.h        |   74 -
 drivers/scsi/bfa/include/defs/bfa_defs_vport.h     |   91 -
 drivers/scsi/bfa/include/fcb/bfa_fcb.h             |   33 -
 drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h       |   75 -
 drivers/scsi/bfa/include/fcb/bfa_fcb_port.h        |  113 -
 drivers/scsi/bfa/include/fcb/bfa_fcb_rport.h       |   80 -
 drivers/scsi/bfa/include/fcb/bfa_fcb_vf.h          |   47 -
 drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h       |   48 -
 drivers/scsi/bfa/include/fcs/bfa_fcs.h             |   76 -
 drivers/scsi/bfa/include/fcs/bfa_fcs_auth.h        |   82 -
 drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h      |  112 -
 drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h       |  132 -
 drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h        |   63 -
 drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h       |  219 -
 drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h       |  105 -
 drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h       |   67 -
 drivers/scsi/bfa/include/log/bfa_log_fcs.h         |   28 -
 drivers/scsi/bfa/include/log/bfa_log_hal.h         |   36 -
 drivers/scsi/bfa/include/log/bfa_log_linux.h       |   62 -
 drivers/scsi/bfa/include/log/bfa_log_wdrv.h        |   36 -
 drivers/scsi/bfa/include/protocol/ct.h             |  492 --
 drivers/scsi/bfa/include/protocol/fc.h             | 1111 ----
 drivers/scsi/bfa/include/protocol/fc_sp.h          |  224 -
 drivers/scsi/bfa/include/protocol/fcp.h            |  184 -
 drivers/scsi/bfa/include/protocol/fdmi.h           |  163 -
 drivers/scsi/bfa/include/protocol/scsi.h           | 1648 ------
 drivers/scsi/bfa/include/protocol/types.h          |   42 -
 drivers/scsi/bfa/loop.c                            |  213 -
 drivers/scsi/bfa/lport_api.c                       |  303 --
 drivers/scsi/bfa/lport_priv.h                      |   82 -
 drivers/scsi/bfa/ms.c                              |  759 ---
 drivers/scsi/bfa/n2n.c                             |  105 -
 drivers/scsi/bfa/ns.c                              | 1242 -----
 drivers/scsi/bfa/plog.c                            |  184 -
 drivers/scsi/bfa/rport.c                           | 2676 ----------
 drivers/scsi/bfa/rport_api.c                       |  185 -
 drivers/scsi/bfa/rport_ftrs.c                      |  379 --
 drivers/scsi/bfa/scn.c                             |  482 --
 drivers/scsi/bfa/vfapi.c                           |  292 --
 drivers/scsi/bfa/vport.c                           |  903 ----
 220 files changed, 34823 insertions(+), 43478 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfa.h
 delete mode 100644 drivers/scsi/bfa/bfa_callback_priv.h
 create mode 100644 drivers/scsi/bfa/bfa_cb_ioim.h
 delete mode 100644 drivers/scsi/bfa/bfa_cb_ioim_macros.h
 delete mode 100644 drivers/scsi/bfa/bfa_cee.c
 create mode 100644 drivers/scsi/bfa/bfa_cs.h
 delete mode 100644 drivers/scsi/bfa/bfa_csdebug.c
 create mode 100644 drivers/scsi/bfa/bfa_defs.h
 create mode 100644 drivers/scsi/bfa/bfa_defs_fcs.h
 create mode 100644 drivers/scsi/bfa/bfa_defs_svc.h
 create mode 100644 drivers/scsi/bfa/bfa_drv.c
 create mode 100644 drivers/scsi/bfa/bfa_fc.h
 create mode 100644 drivers/scsi/bfa/bfa_fcbuild.c
 create mode 100644 drivers/scsi/bfa/bfa_fcbuild.h
 create mode 100644 drivers/scsi/bfa/bfa_fcpim.h
 delete mode 100644 drivers/scsi/bfa/bfa_fcpim_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_fcport.c
 create mode 100644 drivers/scsi/bfa/bfa_fcs.h
 create mode 100644 drivers/scsi/bfa/bfa_fcs_fcpim.c
 delete mode 100644 drivers/scsi/bfa/bfa_fcs_port.c
 create mode 100644 drivers/scsi/bfa/bfa_fcs_rport.c
 delete mode 100644 drivers/scsi/bfa/bfa_fcs_uf.c
 delete mode 100644 drivers/scsi/bfa/bfa_fcxp.c
 delete mode 100644 drivers/scsi/bfa/bfa_fcxp_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_fwimg_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_intr.c
 delete mode 100644 drivers/scsi/bfa/bfa_intr_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_iocfc.c
 delete mode 100644 drivers/scsi/bfa/bfa_iocfc.h
 delete mode 100644 drivers/scsi/bfa/bfa_iocfc_q.c
 delete mode 100644 drivers/scsi/bfa/bfa_ioim.c
 delete mode 100644 drivers/scsi/bfa/bfa_itnim.c
 delete mode 100644 drivers/scsi/bfa/bfa_log.c
 delete mode 100644 drivers/scsi/bfa/bfa_log_module.c
 delete mode 100644 drivers/scsi/bfa/bfa_lps.c
 delete mode 100644 drivers/scsi/bfa/bfa_lps_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_module.c
 create mode 100644 drivers/scsi/bfa/bfa_modules.h
 delete mode 100644 drivers/scsi/bfa/bfa_modules_priv.h
 create mode 100644 drivers/scsi/bfa/bfa_plog.h
 create mode 100644 drivers/scsi/bfa/bfa_port.h
 delete mode 100644 drivers/scsi/bfa/bfa_port_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_rport.c
 delete mode 100644 drivers/scsi/bfa/bfa_rport_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_sgpg.c
 delete mode 100644 drivers/scsi/bfa/bfa_sgpg_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_sm.c
 create mode 100644 drivers/scsi/bfa/bfa_svc.c
 create mode 100644 drivers/scsi/bfa/bfa_svc.h
 delete mode 100644 drivers/scsi/bfa/bfa_timer.c
 delete mode 100644 drivers/scsi/bfa/bfa_trcmod_priv.h
 delete mode 100644 drivers/scsi/bfa/bfa_tskim.c
 delete mode 100644 drivers/scsi/bfa/bfa_uf.c
 delete mode 100644 drivers/scsi/bfa/bfa_uf_priv.h
 delete mode 100644 drivers/scsi/bfa/bfad_attr.h
 delete mode 100644 drivers/scsi/bfa/bfad_fwimg.c
 delete mode 100644 drivers/scsi/bfa/bfad_im_compat.h
 delete mode 100644 drivers/scsi/bfa/bfad_intr.c
 delete mode 100644 drivers/scsi/bfa/bfad_ipfc.h
 delete mode 100644 drivers/scsi/bfa/bfad_os.c
 delete mode 100644 drivers/scsi/bfa/bfad_tm.h
 delete mode 100644 drivers/scsi/bfa/bfad_trcmod.h
 create mode 100644 drivers/scsi/bfa/bfi.h
 create mode 100644 drivers/scsi/bfa/bfi_cbreg.h
 create mode 100644 drivers/scsi/bfa/bfi_ctreg.h
 create mode 100644 drivers/scsi/bfa/bfi_ms.h
 delete mode 100644 drivers/scsi/bfa/fab.c
 delete mode 100644 drivers/scsi/bfa/fabric.c
 delete mode 100644 drivers/scsi/bfa/fcbuild.c
 delete mode 100644 drivers/scsi/bfa/fcbuild.h
 delete mode 100644 drivers/scsi/bfa/fcpim.c
 delete mode 100644 drivers/scsi/bfa/fcptm.c
 delete mode 100644 drivers/scsi/bfa/fcs.h
 delete mode 100644 drivers/scsi/bfa/fcs_auth.h
 delete mode 100644 drivers/scsi/bfa/fcs_fabric.h
 delete mode 100644 drivers/scsi/bfa/fcs_fcpim.h
 delete mode 100644 drivers/scsi/bfa/fcs_fcptm.h
 delete mode 100644 drivers/scsi/bfa/fcs_fcxp.h
 delete mode 100644 drivers/scsi/bfa/fcs_lport.h
 delete mode 100644 drivers/scsi/bfa/fcs_ms.h
 delete mode 100644 drivers/scsi/bfa/fcs_port.h
 delete mode 100644 drivers/scsi/bfa/fcs_rport.h
 delete mode 100644 drivers/scsi/bfa/fcs_trcmod.h
 delete mode 100644 drivers/scsi/bfa/fcs_uf.h
 delete mode 100644 drivers/scsi/bfa/fcs_vport.h
 delete mode 100644 drivers/scsi/bfa/fdmi.c
 delete mode 100644 drivers/scsi/bfa/include/aen/bfa_aen.h
 delete mode 100644 drivers/scsi/bfa/include/aen/bfa_aen_adapter.h
 delete mode 100644 drivers/scsi/bfa/include/aen/bfa_aen_audit.h
 delete mode 100644 drivers/scsi/bfa/include/aen/bfa_aen_ethport.h
 delete mode 100644 drivers/scsi/bfa/include/aen/bfa_aen_ioc.h
 delete mode 100644 drivers/scsi/bfa/include/aen/bfa_aen_itnim.h
 delete mode 100644 drivers/scsi/bfa/include/aen/bfa_aen_lport.h
 delete mode 100644 drivers/scsi/bfa/include/aen/bfa_aen_port.h
 delete mode 100644 drivers/scsi/bfa/include/aen/bfa_aen_rport.h
 delete mode 100644 drivers/scsi/bfa/include/bfa.h
 delete mode 100644 drivers/scsi/bfa/include/bfa_fcpim.h
 delete mode 100644 drivers/scsi/bfa/include/bfa_fcptm.h
 delete mode 100644 drivers/scsi/bfa/include/bfa_svc.h
 delete mode 100644 drivers/scsi/bfa/include/bfa_timer.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_boot.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_cbreg.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_cee.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_ctreg.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_fabric.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_fcpim.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_fcxp.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_ioc.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_iocfc.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_lport.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_lps.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_pbc.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_port.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_pport.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_rport.h
 delete mode 100644 drivers/scsi/bfa/include/bfi/bfi_uf.h
 delete mode 100644 drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h
 delete mode 100644 drivers/scsi/bfa/include/cna/cee/bfa_cee.h
 delete mode 100644 drivers/scsi/bfa/include/cna/port/bfa_port.h
 delete mode 100644 drivers/scsi/bfa/include/cna/pstats/ethport_defs.h
 delete mode 100644 drivers/scsi/bfa/include/cna/pstats/phyport_defs.h
 delete mode 100644 drivers/scsi/bfa/include/cs/bfa_checksum.h
 delete mode 100644 drivers/scsi/bfa/include/cs/bfa_debug.h
 delete mode 100644 drivers/scsi/bfa/include/cs/bfa_log.h
 delete mode 100644 drivers/scsi/bfa/include/cs/bfa_perf.h
 delete mode 100644 drivers/scsi/bfa/include/cs/bfa_plog.h
 delete mode 100644 drivers/scsi/bfa/include/cs/bfa_q.h
 delete mode 100644 drivers/scsi/bfa/include/cs/bfa_sm.h
 delete mode 100644 drivers/scsi/bfa/include/cs/bfa_trc.h
 delete mode 100644 drivers/scsi/bfa/include/cs/bfa_wc.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_adapter.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_aen.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_audit.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_auth.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_boot.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_cee.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_driver.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_ethport.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_fcpim.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_itnim.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_led.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_lport.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_pci.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_pm.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_pom.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_port.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_pport.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_qos.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_rport.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_status.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_tin.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_types.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_version.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_vf.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_vport.h
 delete mode 100644 drivers/scsi/bfa/include/fcb/bfa_fcb.h
 delete mode 100644 drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h
 delete mode 100644 drivers/scsi/bfa/include/fcb/bfa_fcb_port.h
 delete mode 100644 drivers/scsi/bfa/include/fcb/bfa_fcb_rport.h
 delete mode 100644 drivers/scsi/bfa/include/fcb/bfa_fcb_vf.h
 delete mode 100644 drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h
 delete mode 100644 drivers/scsi/bfa/include/fcs/bfa_fcs.h
 delete mode 100644 drivers/scsi/bfa/include/fcs/bfa_fcs_auth.h
 delete mode 100644 drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h
 delete mode 100644 drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h
 delete mode 100644 drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h
 delete mode 100644 drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
 delete mode 100644 drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h
 delete mode 100644 drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h
 delete mode 100644 drivers/scsi/bfa/include/log/bfa_log_fcs.h
 delete mode 100644 drivers/scsi/bfa/include/log/bfa_log_hal.h
 delete mode 100644 drivers/scsi/bfa/include/log/bfa_log_linux.h
 delete mode 100644 drivers/scsi/bfa/include/log/bfa_log_wdrv.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/ct.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/fc.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/fc_sp.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/fcp.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/fdmi.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/scsi.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/types.h
 delete mode 100644 drivers/scsi/bfa/loop.c
 delete mode 100644 drivers/scsi/bfa/lport_api.c
 delete mode 100644 drivers/scsi/bfa/lport_priv.h
 delete mode 100644 drivers/scsi/bfa/ms.c
 delete mode 100644 drivers/scsi/bfa/n2n.c
 delete mode 100644 drivers/scsi/bfa/ns.c
 delete mode 100644 drivers/scsi/bfa/plog.c
 delete mode 100644 drivers/scsi/bfa/rport.c
 delete mode 100644 drivers/scsi/bfa/rport_api.c
 delete mode 100644 drivers/scsi/bfa/rport_ftrs.c
 delete mode 100644 drivers/scsi/bfa/scn.c
 delete mode 100644 drivers/scsi/bfa/vfapi.c
 delete mode 100644 drivers/scsi/bfa/vport.c

-- 
1.7.3.rc1

