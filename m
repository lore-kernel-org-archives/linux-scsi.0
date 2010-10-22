From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] first round of SCSI updates for the merge window
Date: Fri, 22 Oct 2010 11:27:41 -0500
Message-ID: <1287764862.8930.220.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49905 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757823Ab0JVQ1z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2010 12:27:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This represents the usual assortment of driver updates (bnx2i, zfcp,
qla, lpfc, ipr ..) plus several libfc and fcoe updates and a partial bfa
cleanup.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Brian King (2):
      ibmvfc: Handle Virtual I/O Server reboot
      ibmvfc: Log link up/down events

Christof Schmitt (12):
      zfcp: Remove scsi_cmnd->serial_number from debug traces
      zfcp: Remove duplicated code from zfcp_ccw_set_online
      zfcp: Move ACL/CFDC code to zfcp_cfdc.c
      zfcp: Reorder FCP I/O and task management handler functions
      zfcp: Change spin_lock_bh to spin_lock_irq to fix lockdep warning
      zfcp: Allow midlayer to scan for LUNs when running in NPIV mode
      zfcp: Use SCSI device data zfcp_scsi_dev instead of zfcp_unit
      zfcp: Allow running unit/LUN shutdown without acquiring reference
      zfcp: Remove ZFCP_SYSFS_FAILED macro and implement fcp_lun_show without macro
      zfcp: Move code for managing zfcp_unit devices to new file
      zfcp: Add zfcp private struct as SCSI device driver data
      zfcp: Reorder registration of initial SCSI device

Dan Carpenter (2):
      pm8001: handle allocation failures
      lpfc: change spin_lock_irq() to spin_lock()

Darrick J. Wong (1):
      libsas: Don't issue commands to devices that have been hot-removed

David Milburn (1):
      libsas: fix NCQ mixing with non-NCQ

Eddie Wai (5):
      bnx2i: Updated version to bnx2i-2.1.3
      bnx2i: Added chip cleanup for the remove module path
      bnx2i: Recouple the CFC delete cleanup with cm_abort/close completion
      bxn2i: Added support for other TMFs besides ABORT_TASK
      bnx2i: Fixed a protocol violation on nopout responses

Giridhar Malavali (6):
      qla2xxx: Increase SG table size to support large IO size per scsi command.
      qla2xxx: Clear local references of rport on device loss timeout notification from FC transport.
      qla2xxx: Cleanup some dead-code and make some functions static.
      qla2xxx: Return proper fabric name based on device state.
      qla2xxx: Pass first 64 bytes of MBX information when vendor commands fail.
      qla2xxx: Don't issue set or get port param MBC if port is not online.

Hannes Reinecke (1):
      scsi_dh_alua: Handle all states correctly

Jack Wang (1):
      libsas: fix bug for vacant phy

James Smart (7):
      lpfc 8.3.17: Update lpfc driver version to 8.3.17
      lpfc 8.3.17: Replace function reset methodology
      lpfc 8.3.17: SCSI fixes
      lpfc 8.3.17: BSG fixes
      lpfc 8.3.17: SLI Additions and Fixes
      lpfc 8.3.17: Code Cleanup and Locking fixes
      scsi_transport_fc: fix blocked bsg request when fc object deleted

Jayamohan Kallickal (3):
      be2iscsi: SGE Len == 64K
      be2iscsi: Remove premature free of cid
      be2iscsi: More time for FW

Jiri Slaby (2):
      aha152x: enable PCMCIA on 64bit
      qla4xxx: fix build on PPC

Julia Lawall (2):
      drivers/message/fusion: Return -ENOMEM on memory allocation failure
      drivers/scsi: Adjust confusing if indentation

Kai Makisara (1):
      st: add MTWEOFI to write filemarks without flushing drive buffer

Krishna Gudipati (1):
      bfa: cleanup driver

Lalit Chandivade (2):
      qla2xxx: Update to AER support, do early abort commands.
      qla2xxx: Added AER support for ISP82xx.

Madhuranath Iyengar (1):
      qla2xxx: Handle MPI timeout indicated by AE8002

Martin K. Petersen (3):
      sd: Fix overflow with big physical blocks
      sd: Update thin provisioning support
      scsi_debug: Update thin provisioning support

Michael Reed (1):
      sd name space exhaustion causes system hang

Mike Christie (11):
      fc class: add fc host dev loss sysfs file
      lpfc: prep for fc host dev loss tmo support
      qla2xxx: prep for fc host dev loss tmo support
      ibmvfc: prep for fc host dev loss tmo support
      fnic: prep for fc host dev loss tmo support
      scsi/block: increase flush/sync timeout
      ibmvfc: do not reset dev_loss_tmo in slave callout
      fnic: do not reset dev_loss_tmo in slave callout
      lpfc: do not reset dev_loss_tmo in slave callout
      qla2xxx: do not reset dev_loss_tmo in slave callout
      fc class: add fc host default default dev loss setting

Nicholas Bellinger (1):
      scsi_debug: Convert to use root_device_register() and root_device_unregister()

Randy Dunlap (2):
      fix kconfig dependency warnings related to SCSI_SAS_ATTRS
      iscsi transport: fix kernel-doc notation

Saurav Kashyap (1):
      qla2xxx: AER Support-Return recovered from mmio_enable function for 82XX.

Shyam Sundar (1):
      qla2xxx: ROM lock recovery if fw hangs while holding the lock.

Swen Schillig (1):
      zfcp: Replace status modifier functions.

Thomas Gleixner (1):
      aacraid: semaphore cleanup

Wayne Boyer (4):
      ipr: fix array error logging
      ipr: reverse the isr optimization changes
      ipr: Driver version 2.5.1
      ipr: fix resource address formatting and add attribute for device ID

bo yang (1):
      megaraid_sas: Add Online Controller Reset to MegaRAID SAS drive

kxie@chelsio.com (7):
      cxgb4i: connection and ddp setting update
      cxgb3i: fixed connection over vlan
      libcxgbi: pdu read fixes
      cxgbi: rename alloc_cpl to alloc_wr
      cxgb3i: change cxgb3i to use libcxgbi
      cxgb4i v5: iscsi driver
      libcxgbi: common library for cxgb3i and cxgb4i

The diffstat is:

 Documentation/scsi/st.txt                          |   15 
 drivers/message/fusion/mptbase.c                   |    4 
 drivers/s390/scsi/Makefile                         |    5 
 drivers/s390/scsi/zfcp_aux.c                       |  126 
 drivers/s390/scsi/zfcp_ccw.c                       |   17 
 drivers/s390/scsi/zfcp_cfdc.c                      |  186 
 drivers/s390/scsi/zfcp_dbf.c                       |   32 
 drivers/s390/scsi/zfcp_dbf.h                       |   14 
 drivers/s390/scsi/zfcp_def.h                       |   78 
 drivers/s390/scsi/zfcp_erp.c                       |  631 +-
 drivers/s390/scsi/zfcp_ext.h                       |   63 
 drivers/s390/scsi/zfcp_fc.c                        |    2 
 drivers/s390/scsi/zfcp_fsf.c                       |  609 +-
 drivers/s390/scsi/zfcp_qdio.c                      |   18 
 drivers/s390/scsi/zfcp_scsi.c                      |  158 
 drivers/s390/scsi/zfcp_sysfs.c                     |  221 
 drivers/s390/scsi/zfcp_unit.c                      |  244 
 drivers/scsi/Kconfig                               |    5 
 drivers/scsi/Makefile                              |    3 
 drivers/scsi/aacraid/commctrl.c                    |    2 
 drivers/scsi/aacraid/commsup.c                     |    2 
 drivers/scsi/arcmsr/arcmsr_hba.c                   |    4 
 drivers/scsi/be2iscsi/be_cmds.c                    |    2 
 drivers/scsi/be2iscsi/be_iscsi.c                   |    3 
 drivers/scsi/be2iscsi/be_main.c                    |    2 
 drivers/scsi/bfa/Makefile                          |   17 
 drivers/scsi/bfa/bfa.h                             |  438 +
 drivers/scsi/bfa/bfa_callback_priv.h               |   57 
 drivers/scsi/bfa/bfa_cb_ioim.h                     |  169 
 drivers/scsi/bfa/bfa_cb_ioim_macros.h              |  181 
 drivers/scsi/bfa/bfa_cee.c                         |  492 -
 drivers/scsi/bfa/bfa_core.c                        | 1131 ++++
 drivers/scsi/bfa/bfa_cs.h                          |  364 +
 drivers/scsi/bfa/bfa_csdebug.c                     |   58 
 drivers/scsi/bfa/bfa_defs.h                        |  466 +
 drivers/scsi/bfa/bfa_defs_fcs.h                    |  457 +
 drivers/scsi/bfa/bfa_defs_svc.h                    | 1081 ++++
 drivers/scsi/bfa/bfa_drv.c                         |  107 
 drivers/scsi/bfa/bfa_fc.h                          | 1916 +++++++
 drivers/scsi/bfa/bfa_fcbuild.c                     | 1410 +++++
 drivers/scsi/bfa/bfa_fcbuild.h                     |  316 +
 drivers/scsi/bfa/bfa_fcpim.c                       | 3460 +++++++++++++
 drivers/scsi/bfa/bfa_fcpim.h                       |  401 +
 drivers/scsi/bfa/bfa_fcpim_priv.h                  |  192 
 drivers/scsi/bfa/bfa_fcport.c                      | 1962 -------
 drivers/scsi/bfa/bfa_fcs.c                         | 1609 ++++++
 drivers/scsi/bfa/bfa_fcs.h                         |  779 +++
 drivers/scsi/bfa/bfa_fcs_fcpim.c                   |  783 +++
 drivers/scsi/bfa/bfa_fcs_lport.c                   | 5411 +++++++++++++++++++-
 drivers/scsi/bfa/bfa_fcs_port.c                    |   61 
 drivers/scsi/bfa/bfa_fcs_rport.c                   | 3126 ++++++++++++
 drivers/scsi/bfa/bfa_fcs_uf.c                      |   99 
 drivers/scsi/bfa/bfa_fcxp.c                        |  774 --
 drivers/scsi/bfa/bfa_fcxp_priv.h                   |  138 
 drivers/scsi/bfa/bfa_fwimg_priv.h                  |   44 
 drivers/scsi/bfa/bfa_hw_cb.c                       |    8 
 drivers/scsi/bfa/bfa_hw_ct.c                       |   11 
 drivers/scsi/bfa/bfa_intr.c                        |  270 -
 drivers/scsi/bfa/bfa_intr_priv.h                   |  117 
 drivers/scsi/bfa/bfa_ioc.c                         | 1888 +++++--
 drivers/scsi/bfa/bfa_ioc.h                         |  248 
 drivers/scsi/bfa/bfa_ioc_cb.c                      |  124 
 drivers/scsi/bfa/bfa_ioc_ct.c                      |  137 
 drivers/scsi/bfa/bfa_iocfc.c                       |  927 ---
 drivers/scsi/bfa/bfa_iocfc.h                       |  184 
 drivers/scsi/bfa/bfa_iocfc_q.c                     |   44 
 drivers/scsi/bfa/bfa_ioim.c                        | 1364 -----
 drivers/scsi/bfa/bfa_itnim.c                       | 1088 ----
 drivers/scsi/bfa/bfa_log.c                         |  346 -
 drivers/scsi/bfa/bfa_log_module.c                  |  537 --
 drivers/scsi/bfa/bfa_lps.c                         |  892 ---
 drivers/scsi/bfa/bfa_lps_priv.h                    |   38 
 drivers/scsi/bfa/bfa_module.c                      |   90 
 drivers/scsi/bfa/bfa_modules.h                     |  130 
 drivers/scsi/bfa/bfa_modules_priv.h                |   43 
 drivers/scsi/bfa/bfa_os_inc.h                      |  144 
 drivers/scsi/bfa/bfa_plog.h                        |  159 
 drivers/scsi/bfa/bfa_port.c                        |  134 
 drivers/scsi/bfa/bfa_port.h                        |   66 
 drivers/scsi/bfa/bfa_port_priv.h                   |   94 
 drivers/scsi/bfa/bfa_priv.h                        |  110 
 drivers/scsi/bfa/bfa_rport.c                       |  906 ---
 drivers/scsi/bfa/bfa_rport_priv.h                  |   45 
 drivers/scsi/bfa/bfa_sgpg.c                        |  226 
 drivers/scsi/bfa/bfa_sgpg_priv.h                   |   79 
 drivers/scsi/bfa/bfa_sm.c                          |   38 
 drivers/scsi/bfa/bfa_svc.c                         | 5423 +++++++++++++++++++++
 drivers/scsi/bfa/bfa_svc.h                         |  657 ++
 drivers/scsi/bfa/bfa_timer.c                       |   90 
 drivers/scsi/bfa/bfa_trcmod_priv.h                 |   64 
 drivers/scsi/bfa/bfa_tskim.c                       |  690 --
 drivers/scsi/bfa/bfa_uf.c                          |  343 -
 drivers/scsi/bfa/bfa_uf_priv.h                     |   47 
 drivers/scsi/bfa/bfad.c                            | 1355 +++--
 drivers/scsi/bfa/bfad_attr.c                       |  241 
 drivers/scsi/bfa/bfad_attr.h                       |   56 
 drivers/scsi/bfa/bfad_debugfs.c                    |   10 
 drivers/scsi/bfa/bfad_drv.h                        |  254 
 drivers/scsi/bfa/bfad_fwimg.c                      |  131 
 drivers/scsi/bfa/bfad_im.c                         |  257 
 drivers/scsi/bfa/bfad_im.h                         |   56 
 drivers/scsi/bfa/bfad_im_compat.h                  |   45 
 drivers/scsi/bfa/bfad_intr.c                       |  222 
 drivers/scsi/bfa/bfad_ipfc.h                       |   42 
 drivers/scsi/bfa/bfad_os.c                         |   50 
 drivers/scsi/bfa/bfad_tm.h                         |   59 
 drivers/scsi/bfa/bfad_trcmod.h                     |   52 
 drivers/scsi/bfa/bfi.h                             |  579 ++
 drivers/scsi/bfa/bfi_cbreg.h                       |  304 +
 drivers/scsi/bfa/bfi_ctreg.h                       |  627 ++
 drivers/scsi/bfa/bfi_ms.h                          |  765 ++
 drivers/scsi/bfa/fab.c                             |   62 
 drivers/scsi/bfa/fabric.c                          | 1323 -----
 drivers/scsi/bfa/fcbuild.c                         | 1449 -----
 drivers/scsi/bfa/fcbuild.h                         |  279 -
 drivers/scsi/bfa/fcpim.c                           |  824 ---
 drivers/scsi/bfa/fcptm.c                           |   68 
 drivers/scsi/bfa/fcs.h                             |   30 
 drivers/scsi/bfa/fcs_auth.h                        |   37 
 drivers/scsi/bfa/fcs_fabric.h                      |   68 
 drivers/scsi/bfa/fcs_fcpim.h                       |   39 
 drivers/scsi/bfa/fcs_fcptm.h                       |   45 
 drivers/scsi/bfa/fcs_fcxp.h                        |   29 
 drivers/scsi/bfa/fcs_lport.h                       |  118 
 drivers/scsi/bfa/fcs_ms.h                          |   35 
 drivers/scsi/bfa/fcs_port.h                        |   31 
 drivers/scsi/bfa/fcs_rport.h                       |   61 
 drivers/scsi/bfa/fcs_trcmod.h                      |   56 
 drivers/scsi/bfa/fcs_uf.h                          |   31 
 drivers/scsi/bfa/fcs_vport.h                       |   32 
 drivers/scsi/bfa/fdmi.c                            | 1230 ----
 drivers/scsi/bfa/include/aen/bfa_aen.h             |   96 
 drivers/scsi/bfa/include/aen/bfa_aen_adapter.h     |   31 
 drivers/scsi/bfa/include/aen/bfa_aen_audit.h       |   31 
 drivers/scsi/bfa/include/aen/bfa_aen_ethport.h     |   35 
 drivers/scsi/bfa/include/aen/bfa_aen_ioc.h         |   45 
 drivers/scsi/bfa/include/aen/bfa_aen_itnim.h       |   33 
 drivers/scsi/bfa/include/aen/bfa_aen_lport.h       |   51 
 drivers/scsi/bfa/include/aen/bfa_aen_port.h        |   57 
 drivers/scsi/bfa/include/aen/bfa_aen_rport.h       |   37 
 drivers/scsi/bfa/include/bfa.h                     |  203 
 drivers/scsi/bfa/include/bfa_fcpim.h               |  177 
 drivers/scsi/bfa/include/bfa_fcptm.h               |   47 
 drivers/scsi/bfa/include/bfa_svc.h                 |  338 -
 drivers/scsi/bfa/include/bfa_timer.h               |   53 
 drivers/scsi/bfa/include/bfi/bfi.h                 |  174 
 drivers/scsi/bfa/include/bfi/bfi_boot.h            |   34 
 drivers/scsi/bfa/include/bfi/bfi_cbreg.h           |  319 -
 drivers/scsi/bfa/include/bfi/bfi_cee.h             |  119 
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h           |  640 --
 drivers/scsi/bfa/include/bfi/bfi_fabric.h          |   92 
 drivers/scsi/bfa/include/bfi/bfi_fcpim.h           |  301 -
 drivers/scsi/bfa/include/bfi/bfi_fcxp.h            |   71 
 drivers/scsi/bfa/include/bfi/bfi_ioc.h             |  208 
 drivers/scsi/bfa/include/bfi/bfi_iocfc.h           |  179 
 drivers/scsi/bfa/include/bfi/bfi_lport.h           |   89 
 drivers/scsi/bfa/include/bfi/bfi_lps.h             |  104 
 drivers/scsi/bfa/include/bfi/bfi_pbc.h             |   62 
 drivers/scsi/bfa/include/bfi/bfi_port.h            |  115 
 drivers/scsi/bfa/include/bfi/bfi_pport.h           |  118 
 drivers/scsi/bfa/include/bfi/bfi_rport.h           |  104 
 drivers/scsi/bfa/include/bfi/bfi_uf.h              |   52 
 drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h      |   40 
 drivers/scsi/bfa/include/cna/cee/bfa_cee.h         |   77 
 drivers/scsi/bfa/include/cna/port/bfa_port.h       |   70 
 drivers/scsi/bfa/include/cna/pstats/ethport_defs.h |   36 
 drivers/scsi/bfa/include/cna/pstats/phyport_defs.h |  218 
 drivers/scsi/bfa/include/cs/bfa_checksum.h         |   60 
 drivers/scsi/bfa/include/cs/bfa_debug.h            |   45 
 drivers/scsi/bfa/include/cs/bfa_log.h              |  184 
 drivers/scsi/bfa/include/cs/bfa_perf.h             |   34 
 drivers/scsi/bfa/include/cs/bfa_plog.h             |  167 
 drivers/scsi/bfa/include/cs/bfa_q.h                |   81 
 drivers/scsi/bfa/include/cs/bfa_sm.h               |   77 
 drivers/scsi/bfa/include/cs/bfa_trc.h              |  176 
 drivers/scsi/bfa/include/cs/bfa_wc.h               |   68 
 drivers/scsi/bfa/include/defs/bfa_defs_adapter.h   |   83 
 drivers/scsi/bfa/include/defs/bfa_defs_aen.h       |   83 
 drivers/scsi/bfa/include/defs/bfa_defs_audit.h     |   38 
 drivers/scsi/bfa/include/defs/bfa_defs_auth.h      |  134 
 drivers/scsi/bfa/include/defs/bfa_defs_boot.h      |   81 
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h       |  157 
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h    |   41 
 drivers/scsi/bfa/include/defs/bfa_defs_ethport.h   |   99 
 drivers/scsi/bfa/include/defs/bfa_defs_fcpim.h     |   45 
 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h    |   88 
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h       |  158 
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h     |  322 -
 drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h      |   70 
 drivers/scsi/bfa/include/defs/bfa_defs_itnim.h     |  136 
 drivers/scsi/bfa/include/defs/bfa_defs_led.h       |   35 
 drivers/scsi/bfa/include/defs/bfa_defs_lport.h     |   68 
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h       |  144 
 drivers/scsi/bfa/include/defs/bfa_defs_pci.h       |   48 
 drivers/scsi/bfa/include/defs/bfa_defs_pm.h        |   33 
 drivers/scsi/bfa/include/defs/bfa_defs_pom.h       |   56 
 drivers/scsi/bfa/include/defs/bfa_defs_port.h      |  248 
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |  393 -
 drivers/scsi/bfa/include/defs/bfa_defs_qos.h       |   99 
 drivers/scsi/bfa/include/defs/bfa_defs_rport.h     |  199 
 drivers/scsi/bfa/include/defs/bfa_defs_status.h    |  282 -
 drivers/scsi/bfa/include/defs/bfa_defs_tin.h       |  118 
 drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h   |   43 
 drivers/scsi/bfa/include/defs/bfa_defs_types.h     |   30 
 drivers/scsi/bfa/include/defs/bfa_defs_version.h   |   22 
 drivers/scsi/bfa/include/defs/bfa_defs_vf.h        |   74 
 drivers/scsi/bfa/include/defs/bfa_defs_vport.h     |   91 
 drivers/scsi/bfa/include/fcb/bfa_fcb.h             |   33 
 drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h       |   75 
 drivers/scsi/bfa/include/fcb/bfa_fcb_port.h        |  113 
 drivers/scsi/bfa/include/fcb/bfa_fcb_rport.h       |   80 
 drivers/scsi/bfa/include/fcb/bfa_fcb_vf.h          |   47 
 drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h       |   48 
 drivers/scsi/bfa/include/fcs/bfa_fcs.h             |   76 
 drivers/scsi/bfa/include/fcs/bfa_fcs_auth.h        |   82 
 drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h      |  112 
 drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h       |  132 
 drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h        |   63 
 drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h       |  219 
 drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h       |  105 
 drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h       |   67 
 drivers/scsi/bfa/include/log/bfa_log_fcs.h         |   28 
 drivers/scsi/bfa/include/log/bfa_log_hal.h         |   36 
 drivers/scsi/bfa/include/log/bfa_log_linux.h       |   62 
 drivers/scsi/bfa/include/log/bfa_log_wdrv.h        |   36 
 drivers/scsi/bfa/include/protocol/ct.h             |  492 -
 drivers/scsi/bfa/include/protocol/fc.h             | 1111 ----
 drivers/scsi/bfa/include/protocol/fc_sp.h          |  224 
 drivers/scsi/bfa/include/protocol/fcp.h            |  184 
 drivers/scsi/bfa/include/protocol/fdmi.h           |  163 
 drivers/scsi/bfa/include/protocol/scsi.h           | 1648 ------
 drivers/scsi/bfa/include/protocol/types.h          |   42 
 drivers/scsi/bfa/loop.c                            |  213 
 drivers/scsi/bfa/lport_api.c                       |  303 -
 drivers/scsi/bfa/lport_priv.h                      |   82 
 drivers/scsi/bfa/ms.c                              |  759 --
 drivers/scsi/bfa/n2n.c                             |  105 
 drivers/scsi/bfa/ns.c                              | 1242 ----
 drivers/scsi/bfa/plog.c                            |  184 
 drivers/scsi/bfa/rport.c                           | 2676 ----------
 drivers/scsi/bfa/rport_api.c                       |  185 
 drivers/scsi/bfa/rport_ftrs.c                      |  379 -
 drivers/scsi/bfa/scn.c                             |  482 -
 drivers/scsi/bfa/vfapi.c                           |  292 -
 drivers/scsi/bfa/vport.c                           |  903 ---
 drivers/scsi/bnx2i/bnx2i.h                         |    2 
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |   63 
 drivers/scsi/bnx2i/bnx2i_init.c                    |   62 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   15 
 drivers/scsi/cxgb3i/Kbuild                         |    4 
 drivers/scsi/cxgb3i/Kconfig                        |    7 
 drivers/scsi/cxgb3i/cxgb3i.h                       |  161 
 drivers/scsi/cxgb3i/cxgb3i_ddp.c                   |  773 --
 drivers/scsi/cxgb3i/cxgb3i_ddp.h                   |  312 -
 drivers/scsi/cxgb3i/cxgb3i_init.c                  |  132 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c                 | 1018 ---
 drivers/scsi/cxgb3i/cxgb3i_offload.c               | 1944 -------
 drivers/scsi/cxgb3i/cxgb3i_offload.h               |  243 
 drivers/scsi/cxgb3i/cxgb3i_pdu.c                   |  495 -
 drivers/scsi/cxgb3i/cxgb3i_pdu.h                   |   59 
 drivers/scsi/cxgbi/Kconfig                         |    2 
 drivers/scsi/cxgbi/Makefile                        |    2 
 drivers/scsi/cxgbi/cxgb3i/Kbuild                   |    3 
 drivers/scsi/cxgbi/cxgb3i/Kconfig                  |    7 
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 | 1465 +++++
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.h                 |   51 
 drivers/scsi/cxgbi/cxgb4i/Kbuild                   |    3 
 drivers/scsi/cxgbi/cxgb4i/Kconfig                  |    7 
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 | 1604 ++++++
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.h                 |   43 
 drivers/scsi/cxgbi/libcxgbi.c                      | 2612 ++++++++++
 drivers/scsi/cxgbi/libcxgbi.h                      |  745 ++
 drivers/scsi/device_handler/scsi_dh_alua.c         |   65 
 drivers/scsi/fnic/fnic_main.c                      |   15 
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   91 
 drivers/scsi/ibmvscsi/ibmvfc.h                     |    6 
 drivers/scsi/ipr.c                                 |  116 
 drivers/scsi/ipr.h                                 |   17 
 drivers/scsi/libsas/sas_ata.c                      |    5 
 drivers/scsi/libsas/sas_expander.c                 |   12 
 drivers/scsi/libsas/sas_scsi_host.c                |    7 
 drivers/scsi/lpfc/lpfc_attr.c                      |   16 
 drivers/scsi/lpfc/lpfc_bsg.c                       |  147 
 drivers/scsi/lpfc/lpfc_els.c                       |    2 
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   34 
 drivers/scsi/lpfc/lpfc_hw.h                        |    6 
 drivers/scsi/lpfc/lpfc_init.c                      |  213 
 drivers/scsi/lpfc/lpfc_scsi.c                      |   40 
 drivers/scsi/lpfc/lpfc_sli.c                       |  237 
 drivers/scsi/lpfc/lpfc_sli4.h                      |    2 
 drivers/scsi/lpfc/lpfc_version.h                   |    2 
 drivers/scsi/lpfc/lpfc_vport.c                     |    8 
 drivers/scsi/megaraid/megaraid_sas.c               |  756 ++
 drivers/scsi/megaraid/megaraid_sas.h               |   88 
 drivers/scsi/mpt2sas/mpt2sas_base.c                |    2 
 drivers/scsi/pcmcia/Kconfig                        |    1 
 drivers/scsi/pm8001/pm8001_hwi.c                   |    6 
 drivers/scsi/qla2xxx/qla_attr.c                    |   30 
 drivers/scsi/qla2xxx/qla_bsg.c                     |    7 
 drivers/scsi/qla2xxx/qla_def.h                     |    8 
 drivers/scsi/qla2xxx/qla_gbl.h                     |   15 
 drivers/scsi/qla2xxx/qla_init.c                    |   54 
 drivers/scsi/qla2xxx/qla_isr.c                     |    8 
 drivers/scsi/qla2xxx/qla_mbx.c                     |   66 
 drivers/scsi/qla2xxx/qla_nx.c                      |  431 -
 drivers/scsi/qla2xxx/qla_nx.h                      |    5 
 drivers/scsi/qla2xxx/qla_os.c                      |  156 
 drivers/scsi/qla4xxx/ql4_nx.c                      |    1 
 drivers/scsi/scsi_debug.c                          |  125 
 drivers/scsi/scsi_transport_fc.c                   |  163 
 drivers/scsi/scsi_transport_iscsi.c                |    2 
 drivers/scsi/sd.c                                  |   78 
 drivers/scsi/sd.h                                  |    6 
 drivers/scsi/st.c                                  |   15 
 include/linux/mtio.h                               |    1 
 include/scsi/libsas.h                              |    1 
 include/scsi/scsi_transport_fc.h                   |    3 
 317 files changed, 44878 insertions(+), 50672 deletions(-)

James


