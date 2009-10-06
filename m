From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Tue, 06 Oct 2009 15:46:46 +0000
Message-ID: <1254844007.4383.85.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758099AbZJFPsH@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly fixes.  However, it contains two new drivers: Brocade SAS
(bfa), the Bladengine2 iSCSI (be2iscsi) under the merge window exemption
(There's also an update to pmcraid which isn't strictly a bug fix, but
which is currently also under the merge window exemption as a new driver
in the 2.6.32 merge window).  There's also an update to our DIF/DIX
infrastructure to add DIF type 2 (lacking DIF type 2 is the bug we're
fixing here).

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Anil Ravindranath (1):
      pmcraid: Changed driver prints to scmd/sdev_printk

Anil Veerabhadrappa (1):
      bnx2i: Fix context mapping issue for architectures with PAGE_SIZE != 4096

Anirban Chakraborty (1):
      qla2xxx: Fix NULL ptr deref bug in fail path during queue create

Christof Schmitt (6):
      zfcp: Fix hang when offlining device with offline chpid
      zfcp: Fix lockdep warning when offlining device with offline chpid
      zfcp: Fix oops during shutdown of offline device
      zfcp: Fix initial device and cfdc for delayed adapter allocation
      zfcp: correctly initialize unchained requests
      sg: Free data buffers after calling blk_rq_unmap_user

David Jeffery (1):
      st: fix possible memory use after free after MTSETBLK ioctl

Hannes Reinecke (1):
      Retry ADD_TO_MLQUEUE return value for EH commands

HighPoint Linux Team (1):
      hptiop: Add RR44xx adapter support

Jayamohan Kallickal (3):
      be2iscsi: Moving to pci_pools v3
      libiscsi: iscsi_session_setup to allow for private space
      be2iscsi: add 10Gbps iSCSI - BladeEngine 2 driver

Jing Huang (1):
      bfa: Brocade BFA FC SCSI driver

Kashyap, Desai (9):
      mpt2sas: Bump version 02.100.03.00
      mpt2sas: Support dev remove when phy status is MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT
      mpt2sas: Timeout occurred within the HANDSHAKE logic while waiting on firmware to ACK.
      mpt2sas: Call init_completion on a per request basis.
      mpt2sas: Target Reset will be issued from Interrupt context.
      mpt2sas: Added SCSIIO, Internal and high priority memory pools to support multiple TM
      mpt2sas: Copyright change to 2009.
      mpt2sas: Added mpi2_history.txt for MPI2 headers.
      mpt2sas: Update driver to MPI2 REV K headers.

Martin K. Petersen (5):
      scsi_debug: Implement support for DIF Type 2
      sd: Support disks formatted with DIF Type 2
      Fix protection scsi_data_buffer leak
      sd: Detach DIF from block integrity infrastructure
      Deprecate SCSI_PROT_*_CONVERT operations

Moger, Babu (1):
      scsi_dh_rdac: Fix for returning correct mode select cmd return info

Nick Cheng (1):
      mvsas: Support Areca SAS/SATA HBA, ARC-1300/1320

Randy Dunlap (1):
      scsi_transport_fc: fix missing kernel-doc

Tejun Heo (1):
      sr: consider the last written sector when determining media size


The diffstat is:

 Documentation/scsi/hptiop.txt                      |   21 
 MAINTAINERS                                        |   15 
 drivers/infiniband/ulp/iser/iscsi_iser.c           |    2 
 drivers/s390/scsi/zfcp_aux.c                       |   33 
 drivers/s390/scsi/zfcp_ccw.c                       |   40 
 drivers/s390/scsi/zfcp_cfdc.c                      |   17 
 drivers/s390/scsi/zfcp_ext.h                       |    2 
 drivers/s390/scsi/zfcp_fsf.c                       |   22 
 drivers/scsi/Kconfig                               |   11 
 drivers/scsi/Makefile                              |    2 
 drivers/scsi/be2iscsi/Kconfig                      |    8 
 drivers/scsi/be2iscsi/Makefile                     |    8 
 drivers/scsi/be2iscsi/be.h                         |  183 +
 drivers/scsi/be2iscsi/be_cmds.c                    |  523 +++
 drivers/scsi/be2iscsi/be_cmds.h                    |  877 +++++
 drivers/scsi/be2iscsi/be_iscsi.c                   |  638 +++
 drivers/scsi/be2iscsi/be_iscsi.h                   |   75 
 drivers/scsi/be2iscsi/be_main.c                    | 3390 +++++++++++++++++++++
 drivers/scsi/be2iscsi/be_main.h                    |  837 +++++
 drivers/scsi/be2iscsi/be_mgmt.c                    |  321 +
 drivers/scsi/be2iscsi/be_mgmt.h                    |  249 +
 drivers/scsi/bfa/Makefile                          |   15 
 drivers/scsi/bfa/bfa_callback_priv.h               |   57 
 drivers/scsi/bfa/bfa_cb_ioim_macros.h              |  205 +
 drivers/scsi/bfa/bfa_cee.c                         |  492 +++
 drivers/scsi/bfa/bfa_core.c                        |  402 ++
 drivers/scsi/bfa/bfa_csdebug.c                     |   58 
 drivers/scsi/bfa/bfa_fcpim.c                       |  175 +
 drivers/scsi/bfa/bfa_fcpim_priv.h                  |  188 +
 drivers/scsi/bfa/bfa_fcport.c                      | 1671 ++++++++++
 drivers/scsi/bfa/bfa_fcs.c                         |  182 +
 drivers/scsi/bfa/bfa_fcs_lport.c                   |  940 +++++
 drivers/scsi/bfa/bfa_fcs_port.c                    |   68 
 drivers/scsi/bfa/bfa_fcs_uf.c                      |  105 
 drivers/scsi/bfa/bfa_fcxp.c                        |  782 ++++
 drivers/scsi/bfa/bfa_fcxp_priv.h                   |  138 
 drivers/scsi/bfa/bfa_fwimg_priv.h                  |   31 
 drivers/scsi/bfa/bfa_hw_cb.c                       |  142 
 drivers/scsi/bfa/bfa_hw_ct.c                       |  162 +
 drivers/scsi/bfa/bfa_intr.c                        |  218 +
 drivers/scsi/bfa/bfa_intr_priv.h                   |  115 
 drivers/scsi/bfa/bfa_ioc.c                         | 2382 ++++++++++++++
 drivers/scsi/bfa/bfa_ioc.h                         |  259 +
 drivers/scsi/bfa/bfa_iocfc.c                       |  872 +++++
 drivers/scsi/bfa/bfa_iocfc.h                       |  168 +
 drivers/scsi/bfa/bfa_iocfc_q.c                     |   44 
 drivers/scsi/bfa/bfa_ioim.c                        | 1311 ++++++++
 drivers/scsi/bfa/bfa_itnim.c                       | 1088 ++++++
 drivers/scsi/bfa/bfa_log.c                         |  346 ++
 drivers/scsi/bfa/bfa_log_module.c                  |  451 ++
 drivers/scsi/bfa/bfa_lps.c                         |  782 ++++
 drivers/scsi/bfa/bfa_lps_priv.h                    |   38 
 drivers/scsi/bfa/bfa_module.c                      |   90 
 drivers/scsi/bfa/bfa_modules_priv.h                |   43 
 drivers/scsi/bfa/bfa_os_inc.h                      |  222 +
 drivers/scsi/bfa/bfa_port.c                        |  460 ++
 drivers/scsi/bfa/bfa_port_priv.h                   |   90 
 drivers/scsi/bfa/bfa_priv.h                        |  113 
 drivers/scsi/bfa/bfa_rport.c                       |  911 +++++
 drivers/scsi/bfa/bfa_rport_priv.h                  |   45 
 drivers/scsi/bfa/bfa_sgpg.c                        |  231 +
 drivers/scsi/bfa/bfa_sgpg_priv.h                   |   79 
 drivers/scsi/bfa/bfa_sm.c                          |   38 
 drivers/scsi/bfa/bfa_timer.c                       |   90 
 drivers/scsi/bfa/bfa_trcmod_priv.h                 |   66 
 drivers/scsi/bfa/bfa_tskim.c                       |  689 ++++
 drivers/scsi/bfa/bfa_uf.c                          |  345 ++
 drivers/scsi/bfa/bfa_uf_priv.h                     |   47 
 drivers/scsi/bfa/bfad.c                            | 1182 +++++++
 drivers/scsi/bfa/bfad_attr.c                       |  649 ++++
 drivers/scsi/bfa/bfad_attr.h                       |   65 
 drivers/scsi/bfa/bfad_drv.h                        |  295 +
 drivers/scsi/bfa/bfad_fwimg.c                      |   95 
 drivers/scsi/bfa/bfad_im.c                         | 1230 +++++++
 drivers/scsi/bfa/bfad_im.h                         |  150 
 drivers/scsi/bfa/bfad_im_compat.h                  |   46 
 drivers/scsi/bfa/bfad_intr.c                       |  214 +
 drivers/scsi/bfa/bfad_ipfc.h                       |   42 
 drivers/scsi/bfa/bfad_os.c                         |   50 
 drivers/scsi/bfa/bfad_tm.h                         |   59 
 drivers/scsi/bfa/bfad_trcmod.h                     |   52 
 drivers/scsi/bfa/fab.c                             |   62 
 drivers/scsi/bfa/fabric.c                          | 1278 +++++++
 drivers/scsi/bfa/fcbuild.c                         | 1449 ++++++++
 drivers/scsi/bfa/fcbuild.h                         |  273 +
 drivers/scsi/bfa/fcpim.c                           |  844 +++++
 drivers/scsi/bfa/fcptm.c                           |   68 
 drivers/scsi/bfa/fcs.h                             |   30 
 drivers/scsi/bfa/fcs_auth.h                        |   37 
 drivers/scsi/bfa/fcs_fabric.h                      |   61 
 drivers/scsi/bfa/fcs_fcpim.h                       |   44 
 drivers/scsi/bfa/fcs_fcptm.h                       |   45 
 drivers/scsi/bfa/fcs_fcxp.h                        |   29 
 drivers/scsi/bfa/fcs_lport.h                       |  117 
 drivers/scsi/bfa/fcs_ms.h                          |   35 
 drivers/scsi/bfa/fcs_port.h                        |   32 
 drivers/scsi/bfa/fcs_rport.h                       |   61 
 drivers/scsi/bfa/fcs_trcmod.h                      |   56 
 drivers/scsi/bfa/fcs_uf.h                          |   32 
 drivers/scsi/bfa/fcs_vport.h                       |   39 
 drivers/scsi/bfa/fdmi.c                            | 1223 +++++++
 drivers/scsi/bfa/include/aen/bfa_aen.h             |   92 
 drivers/scsi/bfa/include/aen/bfa_aen_adapter.h     |   31 
 drivers/scsi/bfa/include/aen/bfa_aen_audit.h       |   31 
 drivers/scsi/bfa/include/aen/bfa_aen_ethport.h     |   35 
 drivers/scsi/bfa/include/aen/bfa_aen_ioc.h         |   37 
 drivers/scsi/bfa/include/aen/bfa_aen_itnim.h       |   33 
 drivers/scsi/bfa/include/aen/bfa_aen_lport.h       |   51 
 drivers/scsi/bfa/include/aen/bfa_aen_port.h        |   57 
 drivers/scsi/bfa/include/aen/bfa_aen_rport.h       |   37 
 drivers/scsi/bfa/include/bfa.h                     |  177 +
 drivers/scsi/bfa/include/bfa_fcpim.h               |  159 
 drivers/scsi/bfa/include/bfa_fcptm.h               |   47 
 drivers/scsi/bfa/include/bfa_svc.h                 |  324 ++
 drivers/scsi/bfa/include/bfa_timer.h               |   53 
 drivers/scsi/bfa/include/bfi/bfi.h                 |  174 +
 drivers/scsi/bfa/include/bfi/bfi_boot.h            |   34 
 drivers/scsi/bfa/include/bfi/bfi_cbreg.h           |  305 +
 drivers/scsi/bfa/include/bfi/bfi_cee.h             |  119 
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h           |  611 +++
 drivers/scsi/bfa/include/bfi/bfi_fabric.h          |   92 
 drivers/scsi/bfa/include/bfi/bfi_fcpim.h           |  301 +
 drivers/scsi/bfa/include/bfi/bfi_fcxp.h            |   71 
 drivers/scsi/bfa/include/bfi/bfi_ioc.h             |  202 +
 drivers/scsi/bfa/include/bfi/bfi_iocfc.h           |  177 +
 drivers/scsi/bfa/include/bfi/bfi_lport.h           |   89 
 drivers/scsi/bfa/include/bfi/bfi_lps.h             |   96 
 drivers/scsi/bfa/include/bfi/bfi_port.h            |  115 
 drivers/scsi/bfa/include/bfi/bfi_pport.h           |  184 +
 drivers/scsi/bfa/include/bfi/bfi_rport.h           |  104 
 drivers/scsi/bfa/include/bfi/bfi_uf.h              |   52 
 drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h      |   36 
 drivers/scsi/bfa/include/cna/cee/bfa_cee.h         |   77 
 drivers/scsi/bfa/include/cna/port/bfa_port.h       |   69 
 drivers/scsi/bfa/include/cna/pstats/ethport_defs.h |   36 
 drivers/scsi/bfa/include/cna/pstats/phyport_defs.h |  218 +
 drivers/scsi/bfa/include/cs/bfa_checksum.h         |   60 
 drivers/scsi/bfa/include/cs/bfa_debug.h            |   44 
 drivers/scsi/bfa/include/cs/bfa_log.h              |  184 +
 drivers/scsi/bfa/include/cs/bfa_perf.h             |   34 
 drivers/scsi/bfa/include/cs/bfa_plog.h             |  162 +
 drivers/scsi/bfa/include/cs/bfa_q.h                |   81 
 drivers/scsi/bfa/include/cs/bfa_sm.h               |   69 
 drivers/scsi/bfa/include/cs/bfa_trc.h              |  176 +
 drivers/scsi/bfa/include/cs/bfa_wc.h               |   68 
 drivers/scsi/bfa/include/defs/bfa_defs_adapter.h   |   82 
 drivers/scsi/bfa/include/defs/bfa_defs_aen.h       |   73 
 drivers/scsi/bfa/include/defs/bfa_defs_audit.h     |   38 
 drivers/scsi/bfa/include/defs/bfa_defs_auth.h      |  112 
 drivers/scsi/bfa/include/defs/bfa_defs_boot.h      |   71 
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h       |  159 
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h    |   40 
 drivers/scsi/bfa/include/defs/bfa_defs_ethport.h   |   98 
 drivers/scsi/bfa/include/defs/bfa_defs_fcpim.h     |   45 
 drivers/scsi/bfa/include/defs/bfa_defs_im_common.h |   32 
 drivers/scsi/bfa/include/defs/bfa_defs_im_team.h   |   72 
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h       |  152 
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h     |  310 +
 drivers/scsi/bfa/include/defs/bfa_defs_ipfc.h      |   70 
 drivers/scsi/bfa/include/defs/bfa_defs_itnim.h     |  126 
 drivers/scsi/bfa/include/defs/bfa_defs_led.h       |   35 
 drivers/scsi/bfa/include/defs/bfa_defs_lport.h     |   68 
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h       |   58 
 drivers/scsi/bfa/include/defs/bfa_defs_pci.h       |   41 
 drivers/scsi/bfa/include/defs/bfa_defs_pm.h        |   33 
 drivers/scsi/bfa/include/defs/bfa_defs_pom.h       |   56 
 drivers/scsi/bfa/include/defs/bfa_defs_port.h      |  245 +
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |  383 ++
 drivers/scsi/bfa/include/defs/bfa_defs_qos.h       |   99 
 drivers/scsi/bfa/include/defs/bfa_defs_rport.h     |  199 +
 drivers/scsi/bfa/include/defs/bfa_defs_status.h    |  255 +
 drivers/scsi/bfa/include/defs/bfa_defs_tin.h       |  118 
 drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h   |   43 
 drivers/scsi/bfa/include/defs/bfa_defs_types.h     |   30 
 drivers/scsi/bfa/include/defs/bfa_defs_version.h   |   22 
 drivers/scsi/bfa/include/defs/bfa_defs_vf.h        |   74 
 drivers/scsi/bfa/include/defs/bfa_defs_vport.h     |   91 
 drivers/scsi/bfa/include/fcb/bfa_fcb.h             |   33 
 drivers/scsi/bfa/include/fcb/bfa_fcb_fcpim.h       |   76 
 drivers/scsi/bfa/include/fcb/bfa_fcb_port.h        |  113 
 drivers/scsi/bfa/include/fcb/bfa_fcb_rport.h       |   80 
 drivers/scsi/bfa/include/fcb/bfa_fcb_vf.h          |   47 
 drivers/scsi/bfa/include/fcb/bfa_fcb_vport.h       |   47 
 drivers/scsi/bfa/include/fcs/bfa_fcs.h             |   73 
 drivers/scsi/bfa/include/fcs/bfa_fcs_auth.h        |   82 
 drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h      |  112 
 drivers/scsi/bfa/include/fcs/bfa_fcs_fcpim.h       |  131 
 drivers/scsi/bfa/include/fcs/bfa_fcs_fdmi.h        |   63 
 drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h       |  226 +
 drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h       |  104 
 drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h       |   63 
 drivers/scsi/bfa/include/log/bfa_log_fcs.h         |   28 
 drivers/scsi/bfa/include/log/bfa_log_hal.h         |   30 
 drivers/scsi/bfa/include/log/bfa_log_linux.h       |   44 
 drivers/scsi/bfa/include/log/bfa_log_wdrv.h        |   36 
 drivers/scsi/bfa/include/protocol/ct.h             |  492 +++
 drivers/scsi/bfa/include/protocol/fc.h             | 1105 ++++++
 drivers/scsi/bfa/include/protocol/fc_sp.h          |  224 +
 drivers/scsi/bfa/include/protocol/fcp.h            |  186 +
 drivers/scsi/bfa/include/protocol/fdmi.h           |  163 +
 drivers/scsi/bfa/include/protocol/pcifw.h          |   75 
 drivers/scsi/bfa/include/protocol/scsi.h           | 1648 ++++++++++
 drivers/scsi/bfa/include/protocol/types.h          |   42 
 drivers/scsi/bfa/loop.c                            |  422 ++
 drivers/scsi/bfa/lport_api.c                       |  291 +
 drivers/scsi/bfa/lport_priv.h                      |   82 
 drivers/scsi/bfa/ms.c                              |  759 ++++
 drivers/scsi/bfa/n2n.c                             |  105 
 drivers/scsi/bfa/ns.c                              | 1243 +++++++
 drivers/scsi/bfa/plog.c                            |  184 +
 drivers/scsi/bfa/rport.c                           | 2618 ++++++++++++++++
 drivers/scsi/bfa/rport_api.c                       |  180 +
 drivers/scsi/bfa/rport_ftrs.c                      |  375 ++
 drivers/scsi/bfa/scn.c                             |  482 ++
 drivers/scsi/bfa/vfapi.c                           |  292 +
 drivers/scsi/bfa/vport.c                           |  891 +++++
 drivers/scsi/bnx2i/bnx2i.h                         |    2 
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    2 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    2 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c                 |    2 
 drivers/scsi/device_handler/scsi_dh_rdac.c         |    2 
 drivers/scsi/hptiop.c                              |   37 
 drivers/scsi/hptiop.h                              |    3 
 drivers/scsi/iscsi_tcp.c                           |    2 
 drivers/scsi/libiscsi.c                            |    6 
 drivers/scsi/lpfc/lpfc_scsi.c                      |   15 
 drivers/scsi/mpt2sas/Kconfig                       |    2 
 drivers/scsi/mpt2sas/mpi/mpi2.h                    |  103 
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h               |  200 +
 drivers/scsi/mpt2sas/mpi/mpi2_history.txt          |  334 ++
 drivers/scsi/mpt2sas/mpi/mpi2_init.h               |   18 
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h                |   65 
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h               |  134 
 drivers/scsi/mpt2sas/mpt2sas_base.c                |  446 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h                |  106 
 drivers/scsi/mpt2sas/mpt2sas_config.c              |   22 
 drivers/scsi/mpt2sas/mpt2sas_ctl.c                 |   61 
 drivers/scsi/mpt2sas/mpt2sas_ctl.h                 |    2 
 drivers/scsi/mpt2sas/mpt2sas_debug.h               |    2 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |  568 ++-
 drivers/scsi/mpt2sas/mpt2sas_transport.c           |   26 
 drivers/scsi/mvsas/mv_defs.h                       |    4 
 drivers/scsi/mvsas/mv_init.c                       |    4 
 drivers/scsi/pmcraid.c                             |   58 
 drivers/scsi/qla2xxx/qla_mid.c                     |    6 
 drivers/scsi/scsi.c                                |   11 
 drivers/scsi/scsi_debug.c                          |  139 
 drivers/scsi/scsi_error.c                          |    3 
 drivers/scsi/scsi_transport_fc.c                   |    2 
 drivers/scsi/sd.c                                  |  140 
 drivers/scsi/sd.h                                  |    9 
 drivers/scsi/sd_dif.c                              |   65 
 drivers/scsi/sg.c                                  |   10 
 drivers/scsi/sr.c                                  |   22 
 drivers/scsi/st.c                                  |    3 
 include/scsi/libiscsi.h                            |    3 
 include/scsi/scsi.h                                |    3 
 include/scsi/scsi_cmnd.h                           |    4 
 include/scsi/scsi_host.h                           |   15 
 259 files changed, 58442 insertions(+), 666 deletions(-)

And if I exclude the two new drivers, the total becomes:

 52 files changed, 2147 insertions(+), 666 deletions(-)

The diff excluding the new drivers is attached.

James

---

diff --git a/Documentation/scsi/hptiop.txt b/Documentation/scsi/hptiop.txt
index a6eb4ad..9605179 100644
--- a/Documentation/scsi/hptiop.txt
+++ b/Documentation/scsi/hptiop.txt
@@ -3,6 +3,25 @@ HIGHPOINT ROCKETRAID 3xxx/4xxx ADAPTER DRIVER (hptiop)
 Controller Register Map
 -------------------------
 
+For RR44xx Intel IOP based adapters, the controller IOP is accessed via PCI BAR0 and BAR2:
+
+     BAR0 offset    Register
+            0x11C5C Link Interface IRQ Set
+            0x11C60 Link Interface IRQ Clear
+
+     BAR2 offset    Register
+            0x10    Inbound Message Register 0
+            0x14    Inbound Message Register 1
+            0x18    Outbound Message Register 0
+            0x1C    Outbound Message Register 1
+            0x20    Inbound Doorbell Register
+            0x24    Inbound Interrupt Status Register
+            0x28    Inbound Interrupt Mask Register
+            0x30    Outbound Interrupt Status Register
+            0x34    Outbound Interrupt Mask Register
+            0x40    Inbound Queue Port
+            0x44    Outbound Queue Port
+
 For Intel IOP based adapters, the controller IOP is accessed via PCI BAR0:
 
      BAR0 offset    Register
@@ -93,7 +112,7 @@ The driver exposes following sysfs attributes:
 
 
 -----------------------------------------------------------------------------
-Copyright (C) 2006-2007 HighPoint Technologies, Inc. All Rights Reserved.
+Copyright (C) 2006-2009 HighPoint Technologies, Inc. All Rights Reserved.
 
   This file is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 0ba6ec8..add9188 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -426,7 +426,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	 * because we preallocate so many resources
 	 */
 	cls_session = iscsi_session_setup(&iscsi_iser_transport, shost,
-					  ISCSI_DEF_XMIT_CMDS_MAX,
+					  ISCSI_DEF_XMIT_CMDS_MAX, 0,
 					  sizeof(struct iscsi_iser_task),
 					  initial_cmdsn, 0);
 	if (!cls_session)
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 1be6bf7..0f79f3a 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -80,28 +80,35 @@ int zfcp_reqlist_isempty(struct zfcp_adapter *adapter)
 
 static void __init zfcp_init_device_configure(char *busid, u64 wwpn, u64 lun)
 {
+	struct ccw_device *ccwdev;
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
 
-	mutex_lock(&zfcp_data.config_mutex);
-	read_lock_irq(&zfcp_data.config_lock);
-	adapter = zfcp_get_adapter_by_busid(busid);
-	if (adapter)
-		zfcp_adapter_get(adapter);
-	read_unlock_irq(&zfcp_data.config_lock);
+	ccwdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
+	if (!ccwdev)
+		return;
+
+	if (ccw_device_set_online(ccwdev))
+		goto out_ccwdev;
 
+	mutex_lock(&zfcp_data.config_mutex);
+	adapter = dev_get_drvdata(&ccwdev->dev);
 	if (!adapter)
-		goto out_adapter;
-	port = zfcp_port_enqueue(adapter, wwpn, 0, 0);
-	if (IS_ERR(port))
+		goto out_unlock;
+	zfcp_adapter_get(adapter);
+
+	port = zfcp_get_port_by_wwpn(adapter, wwpn);
+	if (!port)
 		goto out_port;
+
+	zfcp_port_get(port);
 	unit = zfcp_unit_enqueue(port, lun);
 	if (IS_ERR(unit))
 		goto out_unit;
 	mutex_unlock(&zfcp_data.config_mutex);
-	ccw_device_set_online(adapter->ccw_device);
 
+	zfcp_erp_unit_reopen(unit, 0, "auidc_1", NULL);
 	zfcp_erp_wait(adapter);
 	flush_work(&unit->scsi_work);
 
@@ -111,8 +118,10 @@ out_unit:
 	zfcp_port_put(port);
 out_port:
 	zfcp_adapter_put(adapter);
-out_adapter:
+out_unlock:
 	mutex_unlock(&zfcp_data.config_mutex);
+out_ccwdev:
+	put_device(&ccwdev->dev);
 	return;
 }
 
@@ -593,10 +602,8 @@ void zfcp_adapter_dequeue(struct zfcp_adapter *adapter)
 	int retval = 0;
 	unsigned long flags;
 
-	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
-	zfcp_adapter_scsi_unregister(adapter);
 	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
 			   &zfcp_sysfs_adapter_attrs);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index 0c90f8e..e083394 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -102,6 +102,14 @@ static void zfcp_ccw_remove(struct ccw_device *ccw_device)
 	adapter = dev_get_drvdata(&ccw_device->dev);
 	if (!adapter)
 		goto out;
+	mutex_unlock(&zfcp_data.config_mutex);
+
+	cancel_work_sync(&adapter->scan_work);
+
+	mutex_lock(&zfcp_data.config_mutex);
+
+	/* this also removes the scsi devices, so call it first */
+	zfcp_adapter_scsi_unregister(adapter);
 
 	write_lock_irq(&zfcp_data.config_lock);
 	list_for_each_entry_safe(port, p, &adapter->port_list_head, list) {
@@ -117,11 +125,8 @@ static void zfcp_ccw_remove(struct ccw_device *ccw_device)
 	write_unlock_irq(&zfcp_data.config_lock);
 
 	list_for_each_entry_safe(port, p, &port_remove_lh, list) {
-		list_for_each_entry_safe(unit, u, &unit_remove_lh, list) {
-			if (unit->device)
-				scsi_remove_device(unit->device);
+		list_for_each_entry_safe(unit, u, &unit_remove_lh, list)
 			zfcp_unit_dequeue(unit);
-		}
 		zfcp_port_dequeue(port);
 	}
 	wait_event(adapter->remove_wq, atomic_read(&adapter->refcount) == 0);
@@ -192,13 +197,9 @@ static int zfcp_ccw_set_offline(struct ccw_device *ccw_device)
 
 	mutex_lock(&zfcp_data.config_mutex);
 	adapter = dev_get_drvdata(&ccw_device->dev);
-	if (!adapter)
-		goto out;
-
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccsoff1", NULL);
 	zfcp_erp_wait(adapter);
 	mutex_unlock(&zfcp_data.config_mutex);
-out:
 	return 0;
 }
 
@@ -253,13 +254,17 @@ static void zfcp_ccw_shutdown(struct ccw_device *cdev)
 
 	mutex_lock(&zfcp_data.config_mutex);
 	adapter = dev_get_drvdata(&cdev->dev);
+	if (!adapter)
+		goto out;
+
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccshut1", NULL);
 	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
+out:
 	mutex_unlock(&zfcp_data.config_mutex);
 }
 
-static struct ccw_driver zfcp_ccw_driver = {
+struct ccw_driver zfcp_ccw_driver = {
 	.owner       = THIS_MODULE,
 	.name        = "zfcp",
 	.ids         = zfcp_ccw_device_id,
@@ -284,20 +289,3 @@ int __init zfcp_ccw_register(void)
 {
 	return ccw_driver_register(&zfcp_ccw_driver);
 }
-
-/**
- * zfcp_get_adapter_by_busid - find zfcp_adapter struct
- * @busid: bus id string of zfcp adapter to find
- */
-struct zfcp_adapter *zfcp_get_adapter_by_busid(char *busid)
-{
-	struct ccw_device *ccw_device;
-	struct zfcp_adapter *adapter = NULL;
-
-	ccw_device = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
-	if (ccw_device) {
-		adapter = dev_get_drvdata(&ccw_device->dev);
-		put_device(&ccw_device->dev);
-	}
-	return adapter;
-}
diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_cfdc.c
index 8305c87..ef681df 100644
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -86,8 +86,23 @@ static int zfcp_cfdc_copy_to_user(void __user  *user_buffer,
 static struct zfcp_adapter *zfcp_cfdc_get_adapter(u32 devno)
 {
 	char busid[9];
+	struct ccw_device *ccwdev;
+	struct zfcp_adapter *adapter = NULL;
+
 	snprintf(busid, sizeof(busid), "0.0.%04x", devno);
-	return zfcp_get_adapter_by_busid(busid);
+	ccwdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
+	if (!ccwdev)
+		goto out;
+
+	adapter = dev_get_drvdata(&ccwdev->dev);
+	if (!adapter)
+		goto out_put;
+
+	zfcp_adapter_get(adapter);
+out_put:
+	put_device(&ccwdev->dev);
+out:
+	return adapter;
 }
 
 static int zfcp_cfdc_set_fsf(struct zfcp_fsf_cfdc *fsf_cfdc, int command)
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 36935bc..629edec 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -28,7 +28,7 @@ extern int zfcp_sg_setup_table(struct scatterlist *, int);
 /* zfcp_ccw.c */
 extern int zfcp_ccw_register(void);
 extern int zfcp_ccw_priv_sch(struct zfcp_adapter *);
-extern struct zfcp_adapter *zfcp_get_adapter_by_busid(char *);
+extern struct ccw_driver zfcp_ccw_driver;
 
 /* zfcp_cfdc.c */
 extern struct miscdevice zfcp_cfdc_misc;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index f09c863..38a7e4a 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1058,11 +1058,25 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->queue_req,
 					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_resp, max_sbals);
+	req->qtcb->bottom.support.resp_buf_length = bytes;
 	if (bytes <= 0)
 		return -EIO;
 
+	return 0;
+}
+
+static int zfcp_fsf_setup_ct_els(struct zfcp_fsf_req *req,
+				 struct scatterlist *sg_req,
+				 struct scatterlist *sg_resp,
+				 int max_sbals)
+{
+	int ret;
+
+	ret = zfcp_fsf_setup_ct_els_sbals(req, sg_req, sg_resp, max_sbals);
+	if (ret)
+		return ret;
+
 	/* common settings for ct/gs and els requests */
-	req->qtcb->bottom.support.resp_buf_length = bytes;
 	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.support.timeout = 2 * R_A_TOV;
 	zfcp_fsf_start_timer(req, 2 * R_A_TOV + 10);
@@ -1094,8 +1108,8 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct *ct, mempool_t *pool)
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els_sbals(req, ct->req, ct->resp,
-					  FSF_MAX_SBALS_PER_REQ);
+	ret = zfcp_fsf_setup_ct_els(req, ct->req, ct->resp,
+				    FSF_MAX_SBALS_PER_REQ);
 	if (ret)
 		goto failed_send;
 
@@ -1192,7 +1206,7 @@ int zfcp_fsf_send_els(struct zfcp_send_els *els)
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els_sbals(req, els->req, els->resp, 2);
+	ret = zfcp_fsf_setup_ct_els(req, els->req, els->resp, 2);
 
 	if (ret)
 		goto failed_send;
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 82bb3b2..e11cca4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -366,6 +366,7 @@ config ISCSI_TCP
 
 source "drivers/scsi/cxgb3i/Kconfig"
 source "drivers/scsi/bnx2i/Kconfig"
+source "drivers/scsi/be2iscsi/Kconfig"
 
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
@@ -1827,6 +1828,16 @@ config SCSI_SRP
 	  To compile this driver as a module, choose M here: the
 	  module will be called libsrp.
 
+config SCSI_BFA_FC
+	tristate "Brocade BFA Fibre Channel Support"
+	depends on PCI && SCSI
+	select SCSI_FC_ATTRS
+	help
+	  This bfa driver supports all Brocade PCIe FC/FCOE host adapters.
+
+	  To compile this driver as a module, choose M here. The module will
+	  be called bfa.
+
 endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 61a94af..3ad61db 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
 obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
+obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
 obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
@@ -130,6 +131,7 @@ obj-$(CONFIG_SCSI_MVSAS)	+= mvsas/
 obj-$(CONFIG_PS3_ROM)		+= ps3rom.o
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgb3i/
 obj-$(CONFIG_SCSI_BNX2_ISCSI)	+= libiscsi.o bnx2i/
+obj-$(CONFIG_BE2ISCSI)		+= libiscsi.o be2iscsi/
 obj-$(CONFIG_SCSI_PMCRAID)	+= pmcraid.o
 
 obj-$(CONFIG_ARM)		+= arm/
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index d7576f2..5edde1a 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -100,6 +100,8 @@
 #define CTX_OFFSET 			0x10000
 #define MAX_CID_CNT			0x4000
 
+#define BNX2I_570X_PAGE_SIZE_DEFAULT	4096
+
 /* 5709 context registers */
 #define BNX2_MQ_CONFIG2			0x00003d00
 #define BNX2_MQ_CONFIG2_CONT_SZ		(0x7L<<4)
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 41e1b0e..5c8d763 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2386,7 +2386,7 @@ int bnx2i_map_ep_dbell_regs(struct bnx2i_endpoint *ep)
 		ctx_sz = (config2 & BNX2_MQ_CONFIG2_CONT_SZ) >> 3;
 		if (ctx_sz)
 			reg_off = CTX_OFFSET + MAX_CID_CNT * MB_KERNEL_CTX_SIZE
-				  + PAGE_SIZE *
+				  + BNX2I_570X_PAGE_SIZE_DEFAULT *
 				  (((cid_num - first_l4l5) / ctx_sz) + 256);
 		else
 			reg_off = CTX_OFFSET + (MB_KERNEL_CTX_SIZE * cid_num);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 9a7ba71..cafb888 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1243,7 +1243,7 @@ bnx2i_session_create(struct iscsi_endpoint *ep,
 		cmds_max = BNX2I_SQ_WQES_MIN;
 
 	cls_session = iscsi_session_setup(&bnx2i_iscsi_transport, shost,
-					  cmds_max, sizeof(struct bnx2i_cmd),
+					  cmds_max, 0, sizeof(struct bnx2i_cmd),
 					  initial_cmdsn, ISCSI_MAX_TARGET);
 	if (!cls_session)
 		return NULL;
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index c399f48..2631bdd 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -422,7 +422,7 @@ cxgb3i_session_create(struct iscsi_endpoint *ep, u16 cmds_max, u16 qdepth,
 	BUG_ON(hba != iscsi_host_priv(shost));
 
 	cls_session = iscsi_session_setup(&cxgb3i_iscsi_transport, shost,
-					  cmds_max,
+					  cmds_max, 0,
 					  sizeof(struct iscsi_tcp_task) +
 					  sizeof(struct cxgb3i_task_data),
 					  initial_cmdsn, ISCSI_MAX_TARGET);
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 11c8931..268189d 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -500,8 +500,6 @@ static int mode_select_handle_sense(struct scsi_device *sdev,
 	if (!ret)
 		goto done;
 
-	err = SCSI_DH_OK;
-
 	switch (sense_hdr.sense_key) {
 	case NO_SENSE:
 	case ABORTED_COMMAND:
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index c596ab5..a0e7e71 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1,6 +1,6 @@
 /*
  * HighPoint RR3xxx/4xxx controller driver for Linux
- * Copyright (C) 2006-2007 HighPoint Technologies, Inc. All Rights Reserved.
+ * Copyright (C) 2006-2009 HighPoint Technologies, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -41,7 +41,7 @@ MODULE_DESCRIPTION("HighPoint RocketRAID 3xxx/4xxx Controller Driver");
 
 static char driver_name[] = "hptiop";
 static const char driver_name_long[] = "RocketRAID 3xxx/4xxx Controller driver";
-static const char driver_ver[] = "v1.3 (071203)";
+static const char driver_ver[] = "v1.6 (090910)";
 
 static int iop_send_sync_msg(struct hptiop_hba *hba, u32 msg, u32 millisec);
 static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
@@ -115,9 +115,13 @@ static void hptiop_drain_outbound_queue_itl(struct hptiop_hba *hba)
 static int iop_intr_itl(struct hptiop_hba *hba)
 {
 	struct hpt_iopmu_itl __iomem *iop = hba->u.itl.iop;
+	void __iomem *plx = hba->u.itl.plx;
 	u32 status;
 	int ret = 0;
 
+	if (plx && readl(plx + 0x11C5C) & 0xf)
+		writel(1, plx + 0x11C60);
+
 	status = readl(&iop->outbound_intstatus);
 
 	if (status & IOPMU_OUTBOUND_INT_MSG0) {
@@ -460,15 +464,25 @@ static void __iomem *hptiop_map_pci_bar(struct hptiop_hba *hba, int index)
 
 static int hptiop_map_pci_bar_itl(struct hptiop_hba *hba)
 {
+	struct pci_dev *pcidev = hba->pcidev;
 	hba->u.itl.iop = hptiop_map_pci_bar(hba, 0);
-	if (hba->u.itl.iop)
-		return 0;
-	else
+	if (hba->u.itl.iop == NULL)
 		return -1;
+	if ((pcidev->device & 0xff00) == 0x4400) {
+		hba->u.itl.plx = hba->u.itl.iop;
+		hba->u.itl.iop = hptiop_map_pci_bar(hba, 2);
+		if (hba->u.itl.iop == NULL) {
+			iounmap(hba->u.itl.plx);
+			return -1;
+		}
+	}
+	return 0;
 }
 
 static void hptiop_unmap_pci_bar_itl(struct hptiop_hba *hba)
 {
+	if (hba->u.itl.plx)
+		iounmap(hba->u.itl.plx);
 	iounmap(hba->u.itl.iop);
 }
 
@@ -1239,22 +1253,23 @@ static struct hptiop_adapter_ops hptiop_mv_ops = {
 static struct pci_device_id hptiop_id_table[] = {
 	{ PCI_VDEVICE(TTI, 0x3220), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3320), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3520), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4320), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3510), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3511), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3520), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3521), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3522), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3540), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3540), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4311), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4320), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4400), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3120), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3122), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3020), (kernel_ulong_t)&hptiop_mv_ops },
diff --git a/drivers/scsi/hptiop.h b/drivers/scsi/hptiop.h
index a0289f2..0b871c0 100644
--- a/drivers/scsi/hptiop.h
+++ b/drivers/scsi/hptiop.h
@@ -1,6 +1,6 @@
 /*
  * HighPoint RR3xxx/4xxx controller driver for Linux
- * Copyright (C) 2006-2007 HighPoint Technologies, Inc. All Rights Reserved.
+ * Copyright (C) 2006-2009 HighPoint Technologies, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -228,6 +228,7 @@ struct hptiop_hba {
 	union {
 		struct {
 			struct hpt_iopmu_itl __iomem *iop;
+			void __iomem *plx;
 		} itl;
 		struct {
 			struct hpt_iopmv_regs *regs;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 2b1b834..edc49ca 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -811,7 +811,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		goto free_host;
 
 	cls_session = iscsi_session_setup(&iscsi_sw_tcp_transport, shost,
-					  cmds_max,
+					  cmds_max, 0,
 					  sizeof(struct iscsi_tcp_task) +
 					  sizeof(struct iscsi_sw_tcp_hdrbuf),
 					  initial_cmdsn, 0);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8dc73c4..f1a4246 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2436,7 +2436,7 @@ static void iscsi_host_dec_session_cnt(struct Scsi_Host *shost)
  */
 struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
-		    uint16_t cmds_max, int cmd_task_size,
+		    uint16_t cmds_max, int dd_size, int cmd_task_size,
 		    uint32_t initial_cmdsn, unsigned int id)
 {
 	struct iscsi_host *ihost = shost_priv(shost);
@@ -2486,7 +2486,8 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
 
 	cls_session = iscsi_alloc_session(shost, iscsit,
-					  sizeof(struct iscsi_session));
+					  sizeof(struct iscsi_session) +
+					  dd_size);
 	if (!cls_session)
 		goto dec_session_count;
 	session = cls_session->dd_data;
@@ -2503,6 +2504,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->max_cmdsn = initial_cmdsn + 1;
 	session->max_r2t = 1;
 	session->tt = iscsit;
+	session->dd_data = cls_session->dd_data + sizeof(*session);
 	mutex_init(&session->eh_mutex);
 	spin_lock_init(&session->lock);
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 61d0897..c88f59f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -56,8 +56,6 @@ static char *dif_op_str[] = {
 	"SCSI_PROT_WRITE_INSERT",
 	"SCSI_PROT_READ_PASS",
 	"SCSI_PROT_WRITE_PASS",
-	"SCSI_PROT_READ_CONVERT",
-	"SCSI_PROT_WRITE_CONVERT"
 };
 static void
 lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
@@ -1131,13 +1129,11 @@ lpfc_sc_to_sli_prof(struct scsi_cmnd *sc)
 			ret_prof = LPFC_PROF_A1;
 			break;
 
-		case SCSI_PROT_READ_CONVERT:
-		case SCSI_PROT_WRITE_CONVERT:
+		case SCSI_PROT_READ_PASS:
+		case SCSI_PROT_WRITE_PASS:
 			ret_prof = LPFC_PROF_AST1;
 			break;
 
-		case SCSI_PROT_READ_PASS:
-		case SCSI_PROT_WRITE_PASS:
 		case SCSI_PROT_NORMAL:
 		default:
 			printk(KERN_ERR "Bad op/guard:%d/%d combination\n",
@@ -1157,8 +1153,6 @@ lpfc_sc_to_sli_prof(struct scsi_cmnd *sc)
 			ret_prof = LPFC_PROF_C1;
 			break;
 
-		case SCSI_PROT_READ_CONVERT:
-		case SCSI_PROT_WRITE_CONVERT:
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
 		case SCSI_PROT_NORMAL:
@@ -1209,8 +1203,7 @@ lpfc_get_cmd_dif_parms(struct scsi_cmnd *sc, uint16_t *apptagmask,
 	static int cnt;
 
 	if (protcnt && (op == SCSI_PROT_WRITE_STRIP ||
-				op == SCSI_PROT_WRITE_PASS ||
-				op == SCSI_PROT_WRITE_CONVERT)) {
+				op == SCSI_PROT_WRITE_PASS)) {
 
 		cnt++;
 		spt = page_address(sg_page(scsi_prot_sglist(sc))) +
@@ -1501,8 +1494,6 @@ lpfc_prot_group_type(struct lpfc_hba *phba, struct scsi_cmnd *sc)
 	case SCSI_PROT_WRITE_STRIP:
 	case SCSI_PROT_READ_PASS:
 	case SCSI_PROT_WRITE_PASS:
-	case SCSI_PROT_WRITE_CONVERT:
-	case SCSI_PROT_READ_CONVERT:
 		ret = LPFC_PG_TYPE_DIF_BUF;
 		break;
 	default:
diff --git a/drivers/scsi/mpt2sas/Kconfig b/drivers/scsi/mpt2sas/Kconfig
index 4a86855..70c4c24 100644
--- a/drivers/scsi/mpt2sas/Kconfig
+++ b/drivers/scsi/mpt2sas/Kconfig
@@ -2,7 +2,7 @@
 # Kernel configuration file for the MPT2SAS
 #
 # This code is based on drivers/scsi/mpt2sas/Kconfig
-# Copyright (C) 2007-2008  LSI Corporation
+# Copyright (C) 2007-2009  LSI Corporation
 #  (mailto:DL-MPTFusionLinux@lsi.com)
 
 # This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2.h b/drivers/scsi/mpt2sas/mpi/mpi2.h
index 7bb2ece..f9f6c08 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2.h
@@ -8,7 +8,7 @@
  *                  scatter/gather formats.
  *  Creation Date:  June 21, 2006
  *
- *  mpi2.h Version:  02.00.11
+ *  mpi2.h Version:  02.00.12
  *
  *  Version History
  *  ---------------
@@ -45,6 +45,13 @@
  *  10-02-08  02.00.10  Bumped MPI2_HEADER_VERSION_UNIT.
  *                      Moved LUN field defines from mpi2_init.h.
  *  01-19-09  02.00.11  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  05-06-09  02.00.12  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      In all request and reply descriptors, replaced VF_ID
+ *                      field with MSIxIndex field.
+ *                      Removed DevHandle field from
+ *                      MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR and made those
+ *                      bytes reserved.
+ *                      Added RAID Accelerator functionality.
  *  --------------------------------------------------------------------------
  */
 
@@ -70,7 +77,7 @@
 #define MPI2_VERSION_02_00                  (0x0200)
 
 /* versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x0B)
+#define MPI2_HEADER_VERSION_UNIT            (0x0C)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
@@ -257,7 +264,7 @@ typedef volatile struct _MPI2_SYSTEM_INTERFACE_REGS
 typedef struct _MPI2_DEFAULT_REQUEST_DESCRIPTOR
 {
     U8              RequestFlags;               /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             LMID;                       /* 0x04 */
     U16             DescriptorTypeDependent;    /* 0x06 */
@@ -271,6 +278,7 @@ typedef struct _MPI2_DEFAULT_REQUEST_DESCRIPTOR
 #define MPI2_REQ_DESCRIPT_FLAGS_SCSI_TARGET             (0x02)
 #define MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY           (0x06)
 #define MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE            (0x08)
+#define MPI2_REQ_DESCRIPT_FLAGS_RAID_ACCELERATOR        (0x0A)
 
 #define MPI2_REQ_DESCRIPT_FLAGS_IOC_FIFO_MARKER (0x01)
 
@@ -279,7 +287,7 @@ typedef struct _MPI2_DEFAULT_REQUEST_DESCRIPTOR
 typedef struct _MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR
 {
     U8              RequestFlags;               /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             LMID;                       /* 0x04 */
     U16             Reserved1;                  /* 0x06 */
@@ -293,7 +301,7 @@ typedef struct _MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR
 typedef struct _MPI2_SCSI_IO_REQUEST_DESCRIPTOR
 {
     U8              RequestFlags;               /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             LMID;                       /* 0x04 */
     U16             DevHandle;                  /* 0x06 */
@@ -306,7 +314,7 @@ typedef struct _MPI2_SCSI_IO_REQUEST_DESCRIPTOR
 typedef struct _MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR
 {
     U8              RequestFlags;               /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             LMID;                       /* 0x04 */
     U16             IoIndex;                    /* 0x06 */
@@ -315,14 +323,29 @@ typedef struct _MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR
   Mpi2SCSITargetRequestDescriptor_t,
   MPI2_POINTER pMpi2SCSITargetRequestDescriptor_t;
 
+
+/* RAID Accelerator Request Descriptor */
+typedef struct _MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR {
+    U8              RequestFlags;               /* 0x00 */
+    U8              MSIxIndex;                  /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U16             LMID;                       /* 0x04 */
+    U16             Reserved;                   /* 0x06 */
+} MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR,
+  Mpi2RAIDAcceleratorRequestDescriptor_t,
+  MPI2_POINTER pMpi2RAIDAcceleratorRequestDescriptor_t;
+
+
 /* union of Request Descriptors */
 typedef union _MPI2_REQUEST_DESCRIPTOR_UNION
 {
-    MPI2_DEFAULT_REQUEST_DESCRIPTOR         Default;
-    MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR   HighPriority;
-    MPI2_SCSI_IO_REQUEST_DESCRIPTOR         SCSIIO;
-    MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR     SCSITarget;
-    U64                                     Words;
+    MPI2_DEFAULT_REQUEST_DESCRIPTOR             Default;
+    MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR       HighPriority;
+    MPI2_SCSI_IO_REQUEST_DESCRIPTOR             SCSIIO;
+    MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR         SCSITarget;
+    MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR          RAIDAccelerator;
+    U64                                         Words;
 } MPI2_REQUEST_DESCRIPTOR_UNION, MPI2_POINTER PTR_MPI2_REQUEST_DESCRIPTOR_UNION,
   Mpi2RequestDescriptorUnion_t, MPI2_POINTER pMpi2RequestDescriptorUnion_t;
 
@@ -333,19 +356,20 @@ typedef union _MPI2_REQUEST_DESCRIPTOR_UNION
 typedef struct _MPI2_DEFAULT_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             DescriptorTypeDependent1;   /* 0x02 */
     U32             DescriptorTypeDependent2;   /* 0x04 */
 } MPI2_DEFAULT_REPLY_DESCRIPTOR, MPI2_POINTER PTR_MPI2_DEFAULT_REPLY_DESCRIPTOR,
   Mpi2DefaultReplyDescriptor_t, MPI2_POINTER pMpi2DefaultReplyDescriptor_t;
 
 /* defines for the ReplyFlags field */
-#define MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK               (0x0F)
-#define MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS         (0x00)
-#define MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY           (0x01)
-#define MPI2_RPY_DESCRIPT_FLAGS_TARGETASSIST_SUCCESS    (0x02)
-#define MPI2_RPY_DESCRIPT_FLAGS_TARGET_COMMAND_BUFFER   (0x03)
-#define MPI2_RPY_DESCRIPT_FLAGS_UNUSED                  (0x0F)
+#define MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK                   (0x0F)
+#define MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS             (0x00)
+#define MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY               (0x01)
+#define MPI2_RPY_DESCRIPT_FLAGS_TARGETASSIST_SUCCESS        (0x02)
+#define MPI2_RPY_DESCRIPT_FLAGS_TARGET_COMMAND_BUFFER       (0x03)
+#define MPI2_RPY_DESCRIPT_FLAGS_RAID_ACCELERATOR_SUCCESS    (0x05)
+#define MPI2_RPY_DESCRIPT_FLAGS_UNUSED                      (0x0F)
 
 /* values for marking a reply descriptor as unused */
 #define MPI2_RPY_DESCRIPT_UNUSED_WORD0_MARK             (0xFFFFFFFF)
@@ -355,7 +379,7 @@ typedef struct _MPI2_DEFAULT_REPLY_DESCRIPTOR
 typedef struct _MPI2_ADDRESS_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U32             ReplyFrameAddress;          /* 0x04 */
 } MPI2_ADDRESS_REPLY_DESCRIPTOR, MPI2_POINTER PTR_MPI2_ADDRESS_REPLY_DESCRIPTOR,
@@ -368,10 +392,10 @@ typedef struct _MPI2_ADDRESS_REPLY_DESCRIPTOR
 typedef struct _MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U16             TaskTag;                    /* 0x04 */
-    U16             DevHandle;                  /* 0x06 */
+    U16             Reserved1;                  /* 0x06 */
 } MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR,
   MPI2_POINTER PTR_MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR,
   Mpi2SCSIIOSuccessReplyDescriptor_t,
@@ -382,7 +406,7 @@ typedef struct _MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR
 typedef struct _MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U16             SMID;                       /* 0x02 */
     U8              SequenceNumber;             /* 0x04 */
     U8              Reserved1;                  /* 0x05 */
@@ -397,7 +421,7 @@ typedef struct _MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR
 typedef struct _MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR
 {
     U8              ReplyFlags;                 /* 0x00 */
-    U8              VF_ID;                      /* 0x01 */
+    U8              MSIxIndex;                  /* 0x01 */
     U8              VP_ID;                      /* 0x02 */
     U8              Flags;                      /* 0x03 */
     U16             InitiatorDevHandle;         /* 0x04 */
@@ -411,15 +435,28 @@ typedef struct _MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR
 #define MPI2_RPY_DESCRIPT_TCB_FLAGS_PHYNUM_MASK     (0x3F)
 
 
+/* RAID Accelerator Success Reply Descriptor */
+typedef struct _MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR {
+    U8              ReplyFlags;                 /* 0x00 */
+    U8              MSIxIndex;                  /* 0x01 */
+    U16             SMID;                       /* 0x02 */
+    U32             Reserved;                   /* 0x04 */
+} MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR,
+  MPI2_POINTER PTR_MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR,
+  Mpi2RAIDAcceleratorSuccessReplyDescriptor_t,
+  MPI2_POINTER pMpi2RAIDAcceleratorSuccessReplyDescriptor_t;
+
+
 /* union of Reply Descriptors */
 typedef union _MPI2_REPLY_DESCRIPTORS_UNION
 {
-    MPI2_DEFAULT_REPLY_DESCRIPTOR               Default;
-    MPI2_ADDRESS_REPLY_DESCRIPTOR               AddressReply;
-    MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR       SCSIIOSuccess;
-    MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR  TargetAssistSuccess;
-    MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR TargetCommandBuffer;
-    U64                                         Words;
+    MPI2_DEFAULT_REPLY_DESCRIPTOR                   Default;
+    MPI2_ADDRESS_REPLY_DESCRIPTOR                   AddressReply;
+    MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR           SCSIIOSuccess;
+    MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR      TargetAssistSuccess;
+    MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR     TargetCommandBuffer;
+    MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR  RAIDAcceleratorSuccess;
+    U64                                             Words;
 } MPI2_REPLY_DESCRIPTORS_UNION, MPI2_POINTER PTR_MPI2_REPLY_DESCRIPTORS_UNION,
   Mpi2ReplyDescriptorsUnion_t, MPI2_POINTER pMpi2ReplyDescriptorsUnion_t;
 
@@ -458,6 +495,7 @@ typedef union _MPI2_REPLY_DESCRIPTORS_UNION
 #define MPI2_FUNCTION_DIAG_RELEASE                  (0x1E) /* Diagnostic Release */
 #define MPI2_FUNCTION_TARGET_CMD_BUF_BASE_POST      (0x24) /* Target Command Buffer Post Base */
 #define MPI2_FUNCTION_TARGET_CMD_BUF_LIST_POST      (0x25) /* Target Command Buffer Post List */
+#define MPI2_FUNCTION_RAID_ACCELERATOR              (0x2C) /* RAID Accelerator*/
 
 
 
@@ -555,12 +593,17 @@ typedef union _MPI2_REPLY_DESCRIPTORS_UNION
 
 #define MPI2_IOCSTATUS_DIAGNOSTIC_RELEASED          (0x00A0)
 
+/****************************************************************************
+*  RAID Accelerator values
+****************************************************************************/
+
+#define MPI2_IOCSTATUS_RAID_ACCEL_ERROR             (0x00B0)
 
 /****************************************************************************
 *  IOCStatus flag to indicate that log info is available
 ****************************************************************************/
 
-#define MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE  (0x8000)
+#define MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE      (0x8000)
 
 /****************************************************************************
 *  IOCLogInfo Types
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
index 2f27cf6..ab47c46 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *          Title:  MPI Configuration messages and pages
  *  Creation Date:  November 10, 2006
  *
- *    mpi2_cnfg.h Version:  02.00.10
+ *    mpi2_cnfg.h Version:  02.00.11
  *
  *  Version History
  *  ---------------
@@ -95,6 +95,11 @@
  *                      Added MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED define.
  *                      Added PortGroups, DmaGroup, and ControlGroup fields to
  *                      SAS Device Page 0.
+ *  05-06-09  02.00.11  Added structures and defines for IO Unit Page 5 and IO
+ *                      Unit Page 6.
+ *                      Added expander reduced functionality data to SAS
+ *                      Expander Page 0.
+ *                      Added SAS PHY Page 2 and SAS PHY Page 3.
  *  --------------------------------------------------------------------------
  */
 
@@ -723,6 +728,65 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_3
 #define MPI2_IOUNITPAGE3_GPIO_SETTING_ON                (0x0001)
 
 
+/* IO Unit Page 5 */
+
+/*
+ * Upper layer code (drivers, utilities, etc.) should leave this define set to
+ * one and check Header.PageLength or NumDmaEngines at runtime.
+ */
+#ifndef MPI2_IOUNITPAGE5_DMAENGINE_ENTRIES
+#define MPI2_IOUNITPAGE5_DMAENGINE_ENTRIES      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_5 {
+    MPI2_CONFIG_PAGE_HEADER Header;				/* 0x00 */
+    U64                     RaidAcceleratorBufferBaseAddress;  /* 0x04 */
+    U64                     RaidAcceleratorBufferSize;         /* 0x0C */
+    U64                     RaidAcceleratorControlBaseAddress; /* 0x14 */
+    U8                      RAControlSize;                     /* 0x1C */
+    U8                      NumDmaEngines;                     /* 0x1D */
+    U8                      RAMinControlSize;                  /* 0x1E */
+    U8                      RAMaxControlSize;                  /* 0x1F */
+    U32                     Reserved1;                         /* 0x20 */
+    U32                     Reserved2;                         /* 0x24 */
+    U32                     Reserved3;                         /* 0x28 */
+    U32                     DmaEngineCapabilities
+				[MPI2_IOUNITPAGE5_DMAENGINE_ENTRIES]; /* 0x2C */
+} MPI2_CONFIG_PAGE_IO_UNIT_5, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IO_UNIT_5,
+  Mpi2IOUnitPage5_t, MPI2_POINTER pMpi2IOUnitPage5_t;
+
+#define MPI2_IOUNITPAGE5_PAGEVERSION                    (0x00)
+
+/* defines for IO Unit Page 5 DmaEngineCapabilities field */
+#define MPI2_IOUNITPAGE5_DMA_CAP_MASK_MAX_REQUESTS      (0xFF00)
+#define MPI2_IOUNITPAGE5_DMA_CAP_SHIFT_MAX_REQUESTS     (16)
+
+#define MPI2_IOUNITPAGE5_DMA_CAP_EEDP                   (0x0008)
+#define MPI2_IOUNITPAGE5_DMA_CAP_PARITY_GENERATION      (0x0004)
+#define MPI2_IOUNITPAGE5_DMA_CAP_HASHING                (0x0002)
+#define MPI2_IOUNITPAGE5_DMA_CAP_ENCRYPTION             (0x0001)
+
+
+/* IO Unit Page 6 */
+
+typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_6 {
+    MPI2_CONFIG_PAGE_HEADER Header;                                 /* 0x00 */
+    U16                     Flags;                                  /* 0x04 */
+    U8                      RAHostControlSize;                      /* 0x06 */
+    U8                      Reserved0;                              /* 0x07 */
+    U64                     RaidAcceleratorHostControlBaseAddress;  /* 0x08 */
+    U32                     Reserved1;                              /* 0x10 */
+    U32                     Reserved2;                              /* 0x14 */
+    U32                     Reserved3;                              /* 0x18 */
+} MPI2_CONFIG_PAGE_IO_UNIT_6, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_IO_UNIT_6,
+  Mpi2IOUnitPage6_t, MPI2_POINTER pMpi2IOUnitPage6_t;
+
+#define MPI2_IOUNITPAGE6_PAGEVERSION                    (0x00)
+
+/* defines for IO Unit Page 6 Flags field */
+#define MPI2_IOUNITPAGE6_FLAGS_ENABLE_RAID_ACCELERATOR  (0x0001)
+
+
 /****************************************************************************
 *   IOC Config Pages
 ****************************************************************************/
@@ -1709,10 +1773,14 @@ typedef struct _MPI2_CONFIG_PAGE_EXPANDER_0
     U64                                 ActiveZoneManagerSASAddress;/* 0x2C */
     U16                                 ZoneLockInactivityLimit;    /* 0x34 */
     U16                                 Reserved1;                  /* 0x36 */
+    U8                                  TimeToReducedFunc;          /* 0x38 */
+    U8                                  InitialTimeToReducedFunc;   /* 0x39 */
+    U8                                  MaxReducedFuncTime;         /* 0x3A */
+    U8                                  Reserved2;                  /* 0x3B */
 } MPI2_CONFIG_PAGE_EXPANDER_0, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_EXPANDER_0,
   Mpi2ExpanderPage0_t, MPI2_POINTER pMpi2ExpanderPage0_t;
 
-#define MPI2_SASEXPANDER0_PAGEVERSION       (0x05)
+#define MPI2_SASEXPANDER0_PAGEVERSION       (0x06)
 
 /* values for SAS Expander Page 0 DiscoveryStatus field */
 #define MPI2_SAS_EXPANDER0_DS_MAX_ENCLOSURES_EXCEED         (0x80000000)
@@ -1737,6 +1805,7 @@ typedef struct _MPI2_CONFIG_PAGE_EXPANDER_0
 #define MPI2_SAS_EXPANDER0_DS_LOOP_DETECTED                 (0x00000001)
 
 /* values for SAS Expander Page 0 Flags field */
+#define MPI2_SAS_EXPANDER0_FLAGS_REDUCED_FUNCTIONALITY      (0x2000)
 #define MPI2_SAS_EXPANDER0_FLAGS_ZONE_LOCKED                (0x1000)
 #define MPI2_SAS_EXPANDER0_FLAGS_SUPPORTED_PHYSICAL_PRES    (0x0800)
 #define MPI2_SAS_EXPANDER0_FLAGS_ASSERTED_PHYSICAL_PRES     (0x0400)
@@ -1944,6 +2013,133 @@ typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_1
 #define MPI2_SASPHY1_PAGEVERSION            (0x01)
 
 
+/* SAS PHY Page 2 */
+
+typedef struct _MPI2_SASPHY2_PHY_EVENT {
+    U8          PhyEventCode;       /* 0x00 */
+    U8          Reserved1;          /* 0x01 */
+    U16         Reserved2;          /* 0x02 */
+    U32         PhyEventInfo;       /* 0x04 */
+} MPI2_SASPHY2_PHY_EVENT, MPI2_POINTER PTR_MPI2_SASPHY2_PHY_EVENT,
+  Mpi2SasPhy2PhyEvent_t, MPI2_POINTER pMpi2SasPhy2PhyEvent_t;
+
+/* use MPI2_SASPHY3_EVENT_CODE_ for the PhyEventCode field */
+
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.ExtPageLength or NumPhyEvents at runtime.
+ */
+#ifndef MPI2_SASPHY2_PHY_EVENT_MAX
+#define MPI2_SASPHY2_PHY_EVENT_MAX      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_2 {
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U32                                 Reserved1;                  /* 0x08 */
+    U8                                  NumPhyEvents;               /* 0x0C */
+    U8                                  Reserved2;                  /* 0x0D */
+    U16                                 Reserved3;                  /* 0x0E */
+    MPI2_SASPHY2_PHY_EVENT              PhyEvent[MPI2_SASPHY2_PHY_EVENT_MAX];
+								/* 0x10 */
+} MPI2_CONFIG_PAGE_SAS_PHY_2, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_PHY_2,
+  Mpi2SasPhyPage2_t, MPI2_POINTER pMpi2SasPhyPage2_t;
+
+#define MPI2_SASPHY2_PAGEVERSION            (0x00)
+
+
+/* SAS PHY Page 3 */
+
+typedef struct _MPI2_SASPHY3_PHY_EVENT_CONFIG {
+    U8          PhyEventCode;       /* 0x00 */
+    U8          Reserved1;          /* 0x01 */
+    U16         Reserved2;          /* 0x02 */
+    U8          CounterType;        /* 0x04 */
+    U8          ThresholdWindow;    /* 0x05 */
+    U8          TimeUnits;          /* 0x06 */
+    U8          Reserved3;          /* 0x07 */
+    U32         EventThreshold;     /* 0x08 */
+    U16         ThresholdFlags;     /* 0x0C */
+    U16         Reserved4;          /* 0x0E */
+} MPI2_SASPHY3_PHY_EVENT_CONFIG, MPI2_POINTER PTR_MPI2_SASPHY3_PHY_EVENT_CONFIG,
+  Mpi2SasPhy3PhyEventConfig_t, MPI2_POINTER pMpi2SasPhy3PhyEventConfig_t;
+
+/* values for PhyEventCode field */
+#define MPI2_SASPHY3_EVENT_CODE_NO_EVENT                    (0x00)
+#define MPI2_SASPHY3_EVENT_CODE_INVALID_DWORD               (0x01)
+#define MPI2_SASPHY3_EVENT_CODE_RUNNING_DISPARITY_ERROR     (0x02)
+#define MPI2_SASPHY3_EVENT_CODE_LOSS_DWORD_SYNC             (0x03)
+#define MPI2_SASPHY3_EVENT_CODE_PHY_RESET_PROBLEM           (0x04)
+#define MPI2_SASPHY3_EVENT_CODE_ELASTICITY_BUF_OVERFLOW     (0x05)
+#define MPI2_SASPHY3_EVENT_CODE_RX_ERROR                    (0x06)
+#define MPI2_SASPHY3_EVENT_CODE_RX_ADDR_FRAME_ERROR         (0x20)
+#define MPI2_SASPHY3_EVENT_CODE_TX_AC_OPEN_REJECT           (0x21)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AC_OPEN_REJECT           (0x22)
+#define MPI2_SASPHY3_EVENT_CODE_TX_RC_OPEN_REJECT           (0x23)
+#define MPI2_SASPHY3_EVENT_CODE_RX_RC_OPEN_REJECT           (0x24)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AIP_PARTIAL_WAITING_ON   (0x25)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AIP_CONNECT_WAITING_ON   (0x26)
+#define MPI2_SASPHY3_EVENT_CODE_TX_BREAK                    (0x27)
+#define MPI2_SASPHY3_EVENT_CODE_RX_BREAK                    (0x28)
+#define MPI2_SASPHY3_EVENT_CODE_BREAK_TIMEOUT               (0x29)
+#define MPI2_SASPHY3_EVENT_CODE_CONNECTION                  (0x2A)
+#define MPI2_SASPHY3_EVENT_CODE_PEAKTX_PATHWAY_BLOCKED      (0x2B)
+#define MPI2_SASPHY3_EVENT_CODE_PEAKTX_ARB_WAIT_TIME        (0x2C)
+#define MPI2_SASPHY3_EVENT_CODE_PEAK_ARB_WAIT_TIME          (0x2D)
+#define MPI2_SASPHY3_EVENT_CODE_PEAK_CONNECT_TIME           (0x2E)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SSP_FRAMES               (0x40)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SSP_FRAMES               (0x41)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SSP_ERROR_FRAMES         (0x42)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SSP_ERROR_FRAMES         (0x43)
+#define MPI2_SASPHY3_EVENT_CODE_TX_CREDIT_BLOCKED           (0x44)
+#define MPI2_SASPHY3_EVENT_CODE_RX_CREDIT_BLOCKED           (0x45)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SATA_FRAMES              (0x50)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SATA_FRAMES              (0x51)
+#define MPI2_SASPHY3_EVENT_CODE_SATA_OVERFLOW               (0x52)
+#define MPI2_SASPHY3_EVENT_CODE_TX_SMP_FRAMES               (0x60)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SMP_FRAMES               (0x61)
+#define MPI2_SASPHY3_EVENT_CODE_RX_SMP_ERROR_FRAMES         (0x63)
+#define MPI2_SASPHY3_EVENT_CODE_HOTPLUG_TIMEOUT             (0xD0)
+#define MPI2_SASPHY3_EVENT_CODE_MISALIGNED_MUX_PRIMITIVE    (0xD1)
+#define MPI2_SASPHY3_EVENT_CODE_RX_AIP                      (0xD2)
+
+/* values for the CounterType field */
+#define MPI2_SASPHY3_COUNTER_TYPE_WRAPPING                  (0x00)
+#define MPI2_SASPHY3_COUNTER_TYPE_SATURATING                (0x01)
+#define MPI2_SASPHY3_COUNTER_TYPE_PEAK_VALUE                (0x02)
+
+/* values for the TimeUnits field */
+#define MPI2_SASPHY3_TIME_UNITS_10_MICROSECONDS             (0x00)
+#define MPI2_SASPHY3_TIME_UNITS_100_MICROSECONDS            (0x01)
+#define MPI2_SASPHY3_TIME_UNITS_1_MILLISECOND               (0x02)
+#define MPI2_SASPHY3_TIME_UNITS_10_MILLISECONDS             (0x03)
+
+/* values for the ThresholdFlags field */
+#define MPI2_SASPHY3_TFLAGS_PHY_RESET                       (0x0002)
+#define MPI2_SASPHY3_TFLAGS_EVENT_NOTIFY                    (0x0001)
+
+/*
+ * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
+ * one and check Header.ExtPageLength or NumPhyEvents at runtime.
+ */
+#ifndef MPI2_SASPHY3_PHY_EVENT_MAX
+#define MPI2_SASPHY3_PHY_EVENT_MAX      (1)
+#endif
+
+typedef struct _MPI2_CONFIG_PAGE_SAS_PHY_3 {
+    MPI2_CONFIG_EXTENDED_PAGE_HEADER    Header;                     /* 0x00 */
+    U32                                 Reserved1;                  /* 0x08 */
+    U8                                  NumPhyEvents;               /* 0x0C */
+    U8                                  Reserved2;                  /* 0x0D */
+    U16                                 Reserved3;                  /* 0x0E */
+    MPI2_SASPHY3_PHY_EVENT_CONFIG       PhyEventConfig
+					[MPI2_SASPHY3_PHY_EVENT_MAX]; /* 0x10 */
+} MPI2_CONFIG_PAGE_SAS_PHY_3, MPI2_POINTER PTR_MPI2_CONFIG_PAGE_SAS_PHY_3,
+  Mpi2SasPhyPage3_t, MPI2_POINTER pMpi2SasPhyPage3_t;
+
+#define MPI2_SASPHY3_PAGEVERSION            (0x00)
+
+
 /****************************************************************************
 *   SAS Port Config Pages
 ****************************************************************************/
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_history.txt b/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
new file mode 100644
index 0000000..65fcaa3
--- /dev/null
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
@@ -0,0 +1,334 @@
+ ==============================
+ Fusion-MPT MPI 2.0 Header File Change History
+ ==============================
+
+ Copyright (c) 2000-2009 LSI Corporation.
+
+ ---------------------------------------
+ Header Set Release Version:    02.00.12
+ Header Set Release Date:       05-06-09
+ ---------------------------------------
+
+ Filename               Current version     Prior version
+ ----------             ---------------     -------------
+ mpi2.h                 02.00.12            02.00.11
+ mpi2_cnfg.h            02.00.11            02.00.10
+ mpi2_init.h            02.00.07            02.00.06
+ mpi2_ioc.h             02.00.11            02.00.10
+ mpi2_raid.h            02.00.03            02.00.03
+ mpi2_sas.h             02.00.02            02.00.02
+ mpi2_targ.h            02.00.03            02.00.03
+ mpi2_tool.h            02.00.03            02.00.02
+ mpi2_type.h            02.00.00            02.00.00
+ mpi2_ra.h              02.00.00
+ mpi2_history.txt       02.00.11            02.00.12
+
+
+ *  Date      Version   Description
+ *  --------  --------  ------------------------------------------------------
+
+mpi2.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-04-07  02.00.01  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  06-26-07  02.00.02  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  08-31-07  02.00.03  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Moved ReplyPostHostIndex register to offset 0x6C of the
+ *                      MPI2_SYSTEM_INTERFACE_REGS and modified the define for
+ *                      MPI2_REPLY_POST_HOST_INDEX_OFFSET.
+ *                      Added union of request descriptors.
+ *                      Added union of reply descriptors.
+ *  10-31-07  02.00.04  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Added define for MPI2_VERSION_02_00.
+ *                      Fixed the size of the FunctionDependent5 field in the
+ *                      MPI2_DEFAULT_REPLY structure.
+ *  12-18-07  02.00.05  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Removed the MPI-defined Fault Codes and extended the
+ *                      product specific codes up to 0xEFFF.
+ *                      Added a sixth key value for the WriteSequence register
+ *                      and changed the flush value to 0x0.
+ *                      Added message function codes for Diagnostic Buffer Post
+ *                      and Diagnsotic Release.
+ *                      New IOCStatus define: MPI2_IOCSTATUS_DIAGNOSTIC_RELEASED
+ *                      Moved MPI2_VERSION_UNION from mpi2_ioc.h.
+ *  02-29-08  02.00.06  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  03-03-08  02.00.07  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  05-21-08  02.00.08  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Added #defines for marking a reply descriptor as unused.
+ *  06-27-08  02.00.09  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  10-02-08  02.00.10  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      Moved LUN field defines from mpi2_init.h.
+ *  01-19-09  02.00.11  Bumped MPI2_HEADER_VERSION_UNIT.
+ *  05-06-09  02.00.12  Bumped MPI2_HEADER_VERSION_UNIT.
+ *                      In all request and reply descriptors, replaced VF_ID
+ *                      field with MSIxIndex field.
+ *                      Removed DevHandle field from
+ *                      MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR and made those
+ *                      bytes reserved.
+ *                      Added RAID Accelerator functionality.
+ *  --------------------------------------------------------------------------
+
+mpi2_cnfg.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-04-07  02.00.01  Added defines for SAS IO Unit Page 2 PhyFlags.
+ *                      Added Manufacturing Page 11.
+ *                      Added MPI2_SAS_EXPANDER0_FLAGS_CONNECTOR_END_DEVICE
+ *                      define.
+ *  06-26-07  02.00.02  Adding generic structure for product-specific
+ *                      Manufacturing pages: MPI2_CONFIG_PAGE_MANUFACTURING_PS.
+ *                      Rework of BIOS Page 2 configuration page.
+ *                      Fixed MPI2_BIOSPAGE2_BOOT_DEVICE to be a union of the
+ *                      forms.
+ *                      Added configuration pages IOC Page 8 and Driver
+ *                      Persistent Mapping Page 0.
+ *  08-31-07  02.00.03  Modified configuration pages dealing with Integrated
+ *                      RAID (Manufacturing Page 4, RAID Volume Pages 0 and 1,
+ *                      RAID Physical Disk Pages 0 and 1, RAID Configuration
+ *                      Page 0).
+ *                      Added new value for AccessStatus field of SAS Device
+ *                      Page 0 (_SATA_NEEDS_INITIALIZATION).
+ *  10-31-07  02.00.04  Added missing SEPDevHandle field to
+ *                      MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
+ *  12-18-07  02.00.05  Modified IO Unit Page 0 to use 32-bit version fields for
+ *                      NVDATA.
+ *                      Modified IOC Page 7 to use masks and added field for
+ *                      SASBroadcastPrimitiveMasks.
+ *                      Added MPI2_CONFIG_PAGE_BIOS_4.
+ *                      Added MPI2_CONFIG_PAGE_LOG_0.
+ *  02-29-08  02.00.06  Modified various names to make them 32-character unique.
+ *                      Added SAS Device IDs.
+ *                      Updated Integrated RAID configuration pages including
+ *                      Manufacturing Page 4, IOC Page 6, and RAID Configuration
+ *                      Page 0.
+ *  05-21-08  02.00.07  Added define MPI2_MANPAGE4_MIX_SSD_SAS_SATA.
+ *                      Added define MPI2_MANPAGE4_PHYSDISK_128MB_COERCION.
+ *                      Fixed define MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING.
+ *                      Added missing MaxNumRoutedSasAddresses field to
+ *                      MPI2_CONFIG_PAGE_EXPANDER_0.
+ *                      Added SAS Port Page 0.
+ *                      Modified structure layout for
+ *                      MPI2_CONFIG_PAGE_DRIVER_MAPPING_0.
+ *  06-27-08  02.00.08  Changed MPI2_CONFIG_PAGE_RD_PDISK_1 to use
+ *                      MPI2_RAID_PHYS_DISK1_PATH_MAX to size the array.
+ *  10-02-08  02.00.09  Changed MPI2_RAID_PGAD_CONFIGNUM_MASK from 0x0000FFFF
+ *                      to 0x000000FF.
+ *                      Added two new values for the Physical Disk Coercion Size
+ *                      bits in the Flags field of Manufacturing Page 4.
+ *                      Added product-specific Manufacturing pages 16 to 31.
+ *                      Modified Flags bits for controlling write cache on SATA
+ *                      drives in IO Unit Page 1.
+ *                      Added new bit to AdditionalControlFlags of SAS IO Unit
+ *                      Page 1 to control Invalid Topology Correction.
+ *                      Added SupportedPhysDisks field to RAID Volume Page 1 and
+ *                      added related defines.
+ *                      Added additional defines for RAID Volume Page 0
+ *                      VolumeStatusFlags field.
+ *                      Modified meaning of RAID Volume Page 0 VolumeSettings
+ *                      define for auto-configure of hot-swap drives.
+ *                      Added PhysDiskAttributes field (and related defines) to
+ *                      RAID Physical Disk Page 0.
+ *                      Added MPI2_SAS_PHYINFO_PHY_VACANT define.
+ *                      Added three new DiscoveryStatus bits for SAS IO Unit
+ *                      Page 0 and SAS Expander Page 0.
+ *                      Removed multiplexing information from SAS IO Unit pages.
+ *                      Added BootDeviceWaitTime field to SAS IO Unit Page 4.
+ *                      Removed Zone Address Resolved bit from PhyInfo and from
+ *                      Expander Page 0 Flags field.
+ *                      Added two new AccessStatus values to SAS Device Page 0
+ *                      for indicating routing problems. Added 3 reserved words
+ *                      to this page.
+ *  01-19-09  02.00.10  Fixed defines for GPIOVal field of IO Unit Page 3.
+ *                      Inserted missing reserved field into structure for IOC
+ *                      Page 6.
+ *                      Added more pending task bits to RAID Volume Page 0
+ *                      VolumeStatusFlags defines.
+ *                      Added MPI2_PHYSDISK0_STATUS_FLAG_NOT_CERTIFIED define.
+ *                      Added a new DiscoveryStatus bit for SAS IO Unit Page 0
+ *                      and SAS Expander Page 0 to flag a downstream initiator
+ *                      when in simplified routing mode.
+ *                      Removed SATA Init Failure defines for DiscoveryStatus
+ *                      fields of SAS IO Unit Page 0 and SAS Expander Page 0.
+ *                      Added MPI2_SAS_DEVICE0_ASTATUS_DEVICE_BLOCKED define.
+ *                      Added PortGroups, DmaGroup, and ControlGroup fields to
+ *                      SAS Device Page 0.
+ *  05-06-09  02.00.11  Added structures and defines for IO Unit Page 5 and IO
+ *                      Unit Page 6.
+ *                      Added expander reduced functionality data to SAS
+ *                      Expander Page 0.
+ *                      Added SAS PHY Page 2 and SAS PHY Page 3.
+ *  --------------------------------------------------------------------------
+
+mpi2_init.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  10-31-07  02.00.01  Fixed name for pMpi2SCSITaskManagementRequest_t.
+ *  12-18-07  02.00.02  Modified Task Management Target Reset Method defines.
+ *  02-29-08  02.00.03  Added Query Task Set and Query Unit Attention.
+ *  03-03-08  02.00.04  Fixed name of struct _MPI2_SCSI_TASK_MANAGE_REPLY.
+ *  05-21-08  02.00.05  Fixed typo in name of Mpi2SepRequest_t.
+ *  10-02-08  02.00.06  Removed Untagged and No Disconnect values from SCSI IO
+ *                      Control field Task Attribute flags.
+ *                      Moved LUN field defines to mpi2.h becasue they are
+ *                      common to many structures.
+ *  05-06-09  02.00.07  Changed task management type of Query Unit Attention to
+ *                      Query Asynchronous Event.
+ *                      Defined two new bits in the SlotStatus field of the SCSI
+ *                      Enclosure Processor Request and Reply.
+ *  --------------------------------------------------------------------------
+
+mpi2_ioc.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-04-07  02.00.01  In IOCFacts Reply structure, renamed MaxDevices to
+ *                      MaxTargets.
+ *                      Added TotalImageSize field to FWDownload Request.
+ *                      Added reserved words to FWUpload Request.
+ *  06-26-07  02.00.02  Added IR Configuration Change List Event.
+ *  08-31-07  02.00.03  Removed SystemReplyQueueDepth field from the IOCInit
+ *                      request and replaced it with
+ *                      ReplyDescriptorPostQueueDepth and ReplyFreeQueueDepth.
+ *                      Replaced the MinReplyQueueDepth field of the IOCFacts
+ *                      reply with MaxReplyDescriptorPostQueueDepth.
+ *                      Added MPI2_RDPQ_DEPTH_MIN define to specify the minimum
+ *                      depth for the Reply Descriptor Post Queue.
+ *                      Added SASAddress field to Initiator Device Table
+ *                      Overflow Event data.
+ *  10-31-07  02.00.04  Added ReasonCode MPI2_EVENT_SAS_INIT_RC_NOT_RESPONDING
+ *                      for SAS Initiator Device Status Change Event data.
+ *                      Modified Reason Code defines for SAS Topology Change
+ *                      List Event data, including adding a bit for PHY Vacant
+ *                      status, and adding a mask for the Reason Code.
+ *                      Added define for
+ *                      MPI2_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING.
+ *                      Added define for MPI2_EXT_IMAGE_TYPE_MEGARAID.
+ *  12-18-07  02.00.05  Added Boot Status defines for the IOCExceptions field of
+ *                      the IOCFacts Reply.
+ *                      Removed MPI2_IOCFACTS_CAPABILITY_EXTENDED_BUFFER define.
+ *                      Moved MPI2_VERSION_UNION to mpi2.h.
+ *                      Changed MPI2_EVENT_NOTIFICATION_REQUEST to use masks
+ *                      instead of enables, and added SASBroadcastPrimitiveMasks
+ *                      field.
+ *                      Added Log Entry Added Event and related structure.
+ *  02-29-08  02.00.06  Added define MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID.
+ *                      Removed define MPI2_IOCFACTS_PROTOCOL_SMP_TARGET.
+ *                      Added MaxVolumes and MaxPersistentEntries fields to
+ *                      IOCFacts reply.
+ *                      Added ProtocalFlags and IOCCapabilities fields to
+ *                      MPI2_FW_IMAGE_HEADER.
+ *                      Removed MPI2_PORTENABLE_FLAGS_ENABLE_SINGLE_PORT.
+ *  03-03-08  02.00.07  Fixed MPI2_FW_IMAGE_HEADER by changing Reserved26 to
+ *                      a U16 (from a U32).
+ *                      Removed extra 's' from EventMasks name.
+ *  06-27-08  02.00.08  Fixed an offset in a comment.
+ *  10-02-08  02.00.09  Removed SystemReplyFrameSize from MPI2_IOC_INIT_REQUEST.
+ *                      Removed CurReplyFrameSize from MPI2_IOC_FACTS_REPLY and
+ *                      renamed MinReplyFrameSize to ReplyFrameSize.
+ *                      Added MPI2_IOCFACTS_EXCEPT_IR_FOREIGN_CONFIG_MAX.
+ *                      Added two new RAIDOperation values for Integrated RAID
+ *                      Operations Status Event data.
+ *                      Added four new IR Configuration Change List Event data
+ *                      ReasonCode values.
+ *                      Added two new ReasonCode defines for SAS Device Status
+ *                      Change Event data.
+ *                      Added three new DiscoveryStatus bits for the SAS
+ *                      Discovery event data.
+ *                      Added Multiplexing Status Change bit to the PhyStatus
+ *                      field of the SAS Topology Change List event data.
+ *                      Removed define for MPI2_INIT_IMAGE_BOOTFLAGS_XMEMCOPY.
+ *                      BootFlags are now product-specific.
+ *                      Added defines for the indivdual signature bytes
+ *                      for MPI2_INIT_IMAGE_FOOTER.
+ *  01-19-09  02.00.10  Added MPI2_IOCFACTS_CAPABILITY_EVENT_REPLAY define.
+ *                      Added MPI2_EVENT_SAS_DISC_DS_DOWNSTREAM_INITIATOR
+ *                      define.
+ *                      Added MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE
+ *                      define.
+ *                      Removed MPI2_EVENT_SAS_DISC_DS_SATA_INIT_FAILURE define.
+ *  05-06-09  02.00.11  Added MPI2_IOCFACTS_CAPABILITY_RAID_ACCELERATOR define.
+ *                      Added MPI2_IOCFACTS_CAPABILITY_MSI_X_INDEX define.
+ *                      Added two new reason codes for SAS Device Status Change
+ *                      Event.
+ *                      Added new event: SAS PHY Counter.
+ *  --------------------------------------------------------------------------
+
+mpi2_raid.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  08-31-07  02.00.01  Modifications to RAID Action request and reply,
+ *                      including the Actions and ActionData.
+ *  02-29-08  02.00.02  Added MPI2_RAID_ACTION_ADATA_DISABL_FULL_REBUILD.
+ *  05-21-08  02.00.03  Added MPI2_RAID_VOL_CREATION_NUM_PHYSDISKS so that
+ *                      the PhysDisk array in MPI2_RAID_VOLUME_CREATION_STRUCT
+ *                      can be sized by the build environment.
+ *  --------------------------------------------------------------------------
+
+mpi2_sas.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  06-26-07  02.00.01  Added Clear All Persistent Operation to SAS IO Unit
+ *                      Control Request.
+ *  10-02-08  02.00.02  Added Set IOC Parameter Operation to SAS IO Unit Control
+ *                      Request.
+ *  --------------------------------------------------------------------------
+
+mpi2_targ.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  08-31-07  02.00.01  Added Command Buffer Data Location Address Space bits to
+ *                      BufferPostFlags field of CommandBufferPostBase Request.
+ *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
+ *  10-02-08  02.00.03  Removed NextCmdBufferOffset from
+ *                      MPI2_TARGET_CMD_BUF_POST_BASE_REQUEST.
+ *                      Target Status Send Request only takes a single SGE for
+ *                      response data.
+ *  --------------------------------------------------------------------------
+
+mpi2_tool.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  12-18-07  02.00.01  Added Diagnostic Buffer Post and Diagnostic Release
+ *                      structures and defines.
+ *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
+ *  05-06-09  02.00.03  Added ISTWI Read Write Tool and Diagnostic CLI Tool.
+ *  --------------------------------------------------------------------------
+
+mpi2_type.h
+ *  04-30-07  02.00.00  Corresponds to Fusion-MPT MPI Specification Rev A.
+ *  --------------------------------------------------------------------------
+
+mpi2_ra.h
+ *  05-06-09  02.00.00  Initial version.
+ *  --------------------------------------------------------------------------
+
+mpi2_history.txt         Parts list history
+
+Filename     02.00.12
+----------   --------
+mpi2.h       02.00.12
+mpi2_cnfg.h  02.00.11
+mpi2_init.h  02.00.07
+mpi2_ioc.h   02.00.11
+mpi2_raid.h  02.00.03
+mpi2_sas.h   02.00.02
+mpi2_targ.h  02.00.03
+mpi2_tool.h  02.00.03
+mpi2_type.h  02.00.00
+mpi2_ra.h    02.00.00
+
+Filename     02.00.11  02.00.10  02.00.09  02.00.08  02.00.07  02.00.06
+----------   --------  --------  --------  --------  --------  --------
+mpi2.h       02.00.11  02.00.10  02.00.09  02.00.08  02.00.07  02.00.06
+mpi2_cnfg.h  02.00.10  02.00.09  02.00.08  02.00.07  02.00.06  02.00.06
+mpi2_init.h  02.00.06  02.00.06  02.00.05  02.00.05  02.00.04  02.00.03
+mpi2_ioc.h   02.00.10  02.00.09  02.00.08  02.00.07  02.00.07  02.00.06
+mpi2_raid.h  02.00.03  02.00.03  02.00.03  02.00.03  02.00.02  02.00.02
+mpi2_sas.h   02.00.02  02.00.02  02.00.01  02.00.01  02.00.01  02.00.01
+mpi2_targ.h  02.00.03  02.00.03  02.00.02  02.00.02  02.00.02  02.00.02
+mpi2_tool.h  02.00.02  02.00.02  02.00.02  02.00.02  02.00.02  02.00.02
+mpi2_type.h  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00
+
+Filename     02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
+----------   --------  --------  --------  --------  --------  --------
+mpi2.h       02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
+mpi2_cnfg.h  02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
+mpi2_init.h  02.00.02  02.00.01  02.00.00  02.00.00  02.00.00  02.00.00
+mpi2_ioc.h   02.00.05  02.00.04  02.00.03  02.00.02  02.00.01  02.00.00
+mpi2_raid.h  02.00.01  02.00.01  02.00.01  02.00.00  02.00.00  02.00.00
+mpi2_sas.h   02.00.01  02.00.01  02.00.01  02.00.01  02.00.00  02.00.00
+mpi2_targ.h  02.00.01  02.00.01  02.00.01  02.00.00  02.00.00  02.00.00
+mpi2_tool.h  02.00.01  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00
+mpi2_type.h  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00  02.00.00
+
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_init.h b/drivers/scsi/mpt2sas/mpi/mpi2_init.h
index f1115f0..563e56d 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_init.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_init.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2008 LSI Corporation.
+ *  Copyright (c) 2000-2009 LSI Corporation.
  *
  *
  *           Name:  mpi2_init.h
  *          Title:  MPI SCSI initiator mode messages and structures
  *  Creation Date:  June 23, 2006
  *
- *    mpi2_init.h Version:  02.00.06
+ *    mpi2_init.h Version:  02.00.07
  *
  *  Version History
  *  ---------------
@@ -23,6 +23,10 @@
  *                      Control field Task Attribute flags.
  *                      Moved LUN field defines to mpi2.h becasue they are
  *                      common to many structures.
+ *  05-06-09  02.00.07  Changed task management type of Query Unit Attention to
+ *                      Query Asynchronous Event.
+ *                      Defined two new bits in the SlotStatus field of the SCSI
+ *                      Enclosure Processor Request and Reply.
  *  --------------------------------------------------------------------------
  */
 
@@ -289,7 +293,11 @@ typedef struct _MPI2_SCSI_TASK_MANAGE_REQUEST
 #define MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK           (0x07)
 #define MPI2_SCSITASKMGMT_TASKTYPE_CLR_ACA              (0x08)
 #define MPI2_SCSITASKMGMT_TASKTYPE_QRY_TASK_SET         (0x09)
-#define MPI2_SCSITASKMGMT_TASKTYPE_QRY_UNIT_ATTENTION   (0x0A)
+#define MPI2_SCSITASKMGMT_TASKTYPE_QRY_ASYNC_EVENT      (0x0A)
+
+/* obsolete TaskType name */
+#define MPI2_SCSITASKMGMT_TASKTYPE_QRY_UNIT_ATTENTION	\
+	(MPI2_SCSITASKMGMT_TASKTYPE_QRY_ASYNC_EVENT)
 
 /* MsgFlags bits */
 
@@ -375,6 +383,8 @@ typedef struct _MPI2_SEP_REQUEST
 #define MPI2_SEP_REQ_SLOTSTATUS_HOT_SPARE               (0x00000100)
 #define MPI2_SEP_REQ_SLOTSTATUS_UNCONFIGURED            (0x00000080)
 #define MPI2_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT         (0x00000040)
+#define MPI2_SEP_REQ_SLOTSTATUS_IN_CRITICAL_ARRAY       (0x00000010)
+#define MPI2_SEP_REQ_SLOTSTATUS_IN_FAILED_ARRAY         (0x00000008)
 #define MPI2_SEP_REQ_SLOTSTATUS_DEV_REBUILDING          (0x00000004)
 #define MPI2_SEP_REQ_SLOTSTATUS_DEV_FAULTY              (0x00000002)
 #define MPI2_SEP_REQ_SLOTSTATUS_NO_ERROR                (0x00000001)
@@ -410,6 +420,8 @@ typedef struct _MPI2_SEP_REPLY
 #define MPI2_SEP_REPLY_SLOTSTATUS_HOT_SPARE             (0x00000100)
 #define MPI2_SEP_REPLY_SLOTSTATUS_UNCONFIGURED          (0x00000080)
 #define MPI2_SEP_REPLY_SLOTSTATUS_PREDICTED_FAULT       (0x00000040)
+#define MPI2_SEP_REPLY_SLOTSTATUS_IN_CRITICAL_ARRAY     (0x00000010)
+#define MPI2_SEP_REPLY_SLOTSTATUS_IN_FAILED_ARRAY       (0x00000008)
 #define MPI2_SEP_REPLY_SLOTSTATUS_DEV_REBUILDING        (0x00000004)
 #define MPI2_SEP_REPLY_SLOTSTATUS_DEV_FAULTY            (0x00000002)
 #define MPI2_SEP_REPLY_SLOTSTATUS_NO_ERROR              (0x00000001)
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
index 8c5d818..c294128 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
@@ -6,7 +6,7 @@
  *          Title:  MPI IOC, Port, Event, FW Download, and FW Upload messages
  *  Creation Date:  October 11, 2006
  *
- *  mpi2_ioc.h Version:  02.00.10
+ *  mpi2_ioc.h Version:  02.00.11
  *
  *  Version History
  *  ---------------
@@ -79,6 +79,11 @@
  *                      Added MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE
  *                      define.
  *                      Removed MPI2_EVENT_SAS_DISC_DS_SATA_INIT_FAILURE define.
+ *  05-06-09  02.00.11  Added MPI2_IOCFACTS_CAPABILITY_RAID_ACCELERATOR define.
+ *                      Added MPI2_IOCFACTS_CAPABILITY_MSI_X_INDEX define.
+ *                      Added two new reason codes for SAS Device Status Change
+ *                      Event.
+ *                      Added new event: SAS PHY Counter.
  *  --------------------------------------------------------------------------
  */
 
@@ -261,6 +266,8 @@ typedef struct _MPI2_IOC_FACTS_REPLY
 /* ProductID field uses MPI2_FW_HEADER_PID_ */
 
 /* IOCCapabilities */
+#define MPI2_IOCFACTS_CAPABILITY_MSI_X_INDEX            (0x00008000)
+#define MPI2_IOCFACTS_CAPABILITY_RAID_ACCELERATOR       (0x00004000)
 #define MPI2_IOCFACTS_CAPABILITY_EVENT_REPLAY           (0x00002000)
 #define MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID        (0x00001000)
 #define MPI2_IOCFACTS_CAPABILITY_TLR                    (0x00000800)
@@ -440,6 +447,7 @@ typedef struct _MPI2_EVENT_NOTIFICATION_REPLY
 #define MPI2_EVENT_IR_PHYSICAL_DISK                 (0x001F)
 #define MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST     (0x0020)
 #define MPI2_EVENT_LOG_ENTRY_ADDED                  (0x0021)
+#define MPI2_EVENT_SAS_PHY_COUNTER                  (0x0022)
 
 
 /* Log Entry Added Event data */
@@ -502,17 +510,19 @@ typedef struct _MPI2_EVENT_DATA_SAS_DEVICE_STATUS_CHANGE
   MPI2_POINTER pMpi2EventDataSasDeviceStatusChange_t;
 
 /* SAS Device Status Change Event data ReasonCode values */
-#define MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA               (0x05)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED              (0x07)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET    (0x08)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL      (0x09)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL  (0x0A)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL  (0x0B)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL      (0x0C)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_ASYNC_NOTIFICATION       (0x0D)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET   (0x0E)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_TASK_ABORT_INTERNAL  (0x0F)
-#define MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE        (0x10)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA                           (0x05)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED                          (0x07)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET                (0x08)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL                  (0x09)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL              (0x0A)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL              (0x0B)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL                  (0x0C)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_ASYNC_NOTIFICATION                   (0x0D)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET               (0x0E)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_TASK_ABORT_INTERNAL              (0x0F)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_SATA_INIT_FAILURE                    (0x10)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_EXPANDER_REDUCED_FUNCTIONALITY       (0x11)
+#define MPI2_EVENT_SAS_DEV_STAT_RC_CMP_EXPANDER_REDUCED_FUNCTIONALITY   (0x12)
 
 
 /* Integrated RAID Operation Status Event data */
@@ -822,6 +832,37 @@ typedef struct _MPI2_EVENT_DATA_SAS_ENCL_DEV_STATUS_CHANGE
 #define MPI2_EVENT_SAS_ENCL_RC_NOT_RESPONDING       (0x02)
 
 
+/* SAS PHY Counter Event data */
+
+typedef struct _MPI2_EVENT_DATA_SAS_PHY_COUNTER {
+    U64         TimeStamp;          /* 0x00 */
+    U32         Reserved1;          /* 0x08 */
+    U8          PhyEventCode;       /* 0x0C */
+    U8          PhyNum;             /* 0x0D */
+    U16         Reserved2;          /* 0x0E */
+    U32         PhyEventInfo;       /* 0x10 */
+    U8          CounterType;        /* 0x14 */
+    U8          ThresholdWindow;    /* 0x15 */
+    U8          TimeUnits;          /* 0x16 */
+    U8          Reserved3;          /* 0x17 */
+    U32         EventThreshold;     /* 0x18 */
+    U16         ThresholdFlags;     /* 0x1C */
+    U16         Reserved4;          /* 0x1E */
+} MPI2_EVENT_DATA_SAS_PHY_COUNTER,
+  MPI2_POINTER PTR_MPI2_EVENT_DATA_SAS_PHY_COUNTER,
+  Mpi2EventDataSasPhyCounter_t, MPI2_POINTER pMpi2EventDataSasPhyCounter_t;
+
+/* use MPI2_SASPHY3_EVENT_CODE_ values from mpi2_cnfg.h for the
+ * PhyEventCode field
+ * use MPI2_SASPHY3_COUNTER_TYPE_ values from mpi2_cnfg.h for the
+ * CounterType field
+ * use MPI2_SASPHY3_TIME_UNITS_ values from mpi2_cnfg.h for the
+ * TimeUnits field
+ * use MPI2_SASPHY3_TFLAGS_ values from mpi2_cnfg.h for the
+ * ThresholdFlags field
+ * */
+
+
 /****************************************************************************
 *  EventAck message
 ****************************************************************************/
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
index 2ff4e93..007e950 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
@@ -1,12 +1,12 @@
 /*
- *  Copyright (c) 2000-2008 LSI Corporation.
+ *  Copyright (c) 2000-2009 LSI Corporation.
  *
  *
  *           Name:  mpi2_tool.h
  *          Title:  MPI diagnostic tool structures and definitions
  *  Creation Date:  March 26, 2007
  *
- *    mpi2_tool.h Version:  02.00.02
+ *    mpi2_tool.h Version:  02.00.03
  *
  *  Version History
  *  ---------------
@@ -17,6 +17,7 @@
  *  12-18-07  02.00.01  Added Diagnostic Buffer Post and Diagnostic Release
  *                      structures and defines.
  *  02-29-08  02.00.02  Modified various names to make them 32-character unique.
+ *  05-06-09  02.00.03  Added ISTWI Read Write Tool and Diagnostic CLI Tool.
  *  --------------------------------------------------------------------------
  */
 
@@ -32,7 +33,10 @@
 /* defines for the Tools */
 #define MPI2_TOOLBOX_CLEAN_TOOL                     (0x00)
 #define MPI2_TOOLBOX_MEMORY_MOVE_TOOL               (0x01)
+#define MPI2_TOOLBOX_ISTWI_READ_WRITE_TOOL          (0x03)
 #define MPI2_TOOLBOX_BEACON_TOOL                    (0x05)
+#define MPI2_TOOLBOX_DIAGNOSTIC_CLI_TOOL            (0x06)
+
 
 /****************************************************************************
 *  Toolbox reply
@@ -112,6 +116,77 @@ typedef struct _MPI2_TOOLBOX_MEM_MOVE_REQUEST
 
 
 /****************************************************************************
+*  Toolbox ISTWI Read Write Tool
+****************************************************************************/
+
+/* Toolbox ISTWI Read Write Tool request message */
+typedef struct _MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST {
+    U8                      Tool;                       /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U32                     Reserved5;                  /* 0x0C */
+    U32                     Reserved6;                  /* 0x10 */
+    U8                      DevIndex;                   /* 0x14 */
+    U8                      Action;                     /* 0x15 */
+    U8                      SGLFlags;                   /* 0x16 */
+    U8                      Reserved7;                  /* 0x17 */
+    U16                     TxDataLength;               /* 0x18 */
+    U16                     RxDataLength;               /* 0x1A */
+    U32                     Reserved8;                  /* 0x1C */
+    U32                     Reserved9;                  /* 0x20 */
+    U32                     Reserved10;                 /* 0x24 */
+    U32                     Reserved11;                 /* 0x28 */
+    U32                     Reserved12;                 /* 0x2C */
+    MPI2_SGE_SIMPLE_UNION   SGL;                        /* 0x30 */
+} MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST,
+  MPI2_POINTER PTR_MPI2_TOOLBOX_ISTWI_READ_WRITE_REQUEST,
+  Mpi2ToolboxIstwiReadWriteRequest_t,
+  MPI2_POINTER pMpi2ToolboxIstwiReadWriteRequest_t;
+
+/* values for the Action field */
+#define MPI2_TOOL_ISTWI_ACTION_READ_DATA            (0x01)
+#define MPI2_TOOL_ISTWI_ACTION_WRITE_DATA           (0x02)
+#define MPI2_TOOL_ISTWI_ACTION_SEQUENCE             (0x03)
+#define MPI2_TOOL_ISTWI_ACTION_RESERVE_BUS          (0x10)
+#define MPI2_TOOL_ISTWI_ACTION_RELEASE_BUS          (0x11)
+#define MPI2_TOOL_ISTWI_ACTION_RESET                (0x12)
+
+/* values for SGLFlags field are in the SGL section of mpi2.h */
+
+
+/* Toolbox ISTWI Read Write Tool reply message */
+typedef struct _MPI2_TOOLBOX_ISTWI_REPLY {
+    U8                      Tool;                       /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      MsgLength;                  /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U16                     Reserved5;                  /* 0x0C */
+    U16                     IOCStatus;                  /* 0x0E */
+    U32                     IOCLogInfo;                 /* 0x10 */
+    U8                      DevIndex;                   /* 0x14 */
+    U8                      Action;                     /* 0x15 */
+    U8                      IstwiStatus;                /* 0x16 */
+    U8                      Reserved6;                  /* 0x17 */
+    U16                     TxDataCount;                /* 0x18 */
+    U16                     RxDataCount;                /* 0x1A */
+} MPI2_TOOLBOX_ISTWI_REPLY, MPI2_POINTER PTR_MPI2_TOOLBOX_ISTWI_REPLY,
+  Mpi2ToolboxIstwiReply_t, MPI2_POINTER pMpi2ToolboxIstwiReply_t;
+
+
+/****************************************************************************
 *  Toolbox Beacon Tool request
 ****************************************************************************/
 
@@ -139,6 +214,61 @@ typedef struct _MPI2_TOOLBOX_BEACON_REQUEST
 #define MPI2_TOOLBOX_FLAGS_BEACONMODE_ON        (0x01)
 
 
+/****************************************************************************
+*  Toolbox Diagnostic CLI Tool
+****************************************************************************/
+
+#define MPI2_TOOLBOX_DIAG_CLI_CMD_LENGTH    (0x5C)
+
+/* Toolbox Diagnostic CLI Tool request message */
+typedef struct _MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST {
+    U8                      Tool;                       /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      ChainOffset;                /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U8                      SGLFlags;                   /* 0x0C */
+    U8                      Reserved5;                  /* 0x0D */
+    U16                     Reserved6;                  /* 0x0E */
+    U32                     DataLength;                 /* 0x10 */
+    U8                      DiagnosticCliCommand
+		[MPI2_TOOLBOX_DIAG_CLI_CMD_LENGTH];     /* 0x14 */
+    MPI2_SGE_SIMPLE_UNION   SGL;                        /* 0x70 */
+} MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST,
+  MPI2_POINTER PTR_MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST,
+  Mpi2ToolboxDiagnosticCliRequest_t,
+  MPI2_POINTER pMpi2ToolboxDiagnosticCliRequest_t;
+
+/* values for SGLFlags field are in the SGL section of mpi2.h */
+
+
+/* Toolbox Diagnostic CLI Tool reply message */
+typedef struct _MPI2_TOOLBOX_DIAGNOSTIC_CLI_REPLY {
+    U8                      Tool;                       /* 0x00 */
+    U8                      Reserved1;                  /* 0x01 */
+    U8                      MsgLength;                  /* 0x02 */
+    U8                      Function;                   /* 0x03 */
+    U16                     Reserved2;                  /* 0x04 */
+    U8                      Reserved3;                  /* 0x06 */
+    U8                      MsgFlags;                   /* 0x07 */
+    U8                      VP_ID;                      /* 0x08 */
+    U8                      VF_ID;                      /* 0x09 */
+    U16                     Reserved4;                  /* 0x0A */
+    U16                     Reserved5;                  /* 0x0C */
+    U16                     IOCStatus;                  /* 0x0E */
+    U32                     IOCLogInfo;                 /* 0x10 */
+    U32                     ReturnedDataLength;         /* 0x14 */
+} MPI2_TOOLBOX_DIAGNOSTIC_CLI_REPLY,
+  MPI2_POINTER PTR_MPI2_TOOLBOX_DIAG_CLI_REPLY,
+  Mpi2ToolboxDiagnosticCliReply_t,
+  MPI2_POINTER pMpi2ToolboxDiagnosticCliReply_t;
+
+
 /*****************************************************************************
 *
 *       Diagnostic Buffer Messages
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index d95d2f2..670241e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.c
- * Copyright (C) 2007-2008  LSI Corporation
+ * Copyright (C) 2007-2009  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -63,7 +63,7 @@
 static MPT_CALLBACK	mpt_callbacks[MPT_MAX_CALLBACKS];
 
 #define FAULT_POLLING_INTERVAL 1000 /* in milliseconds */
-#define MPT2SAS_MAX_REQUEST_QUEUE 500 /* maximum controller queue depth */
+#define MPT2SAS_MAX_REQUEST_QUEUE 600 /* maximum controller queue depth */
 
 static int max_queue_depth = -1;
 module_param(max_queue_depth, int, 0);
@@ -543,13 +543,13 @@ mpt2sas_base_fault_info(struct MPT2SAS_ADAPTER *ioc , u16 fault_code)
  * _base_display_reply_info -
  * @ioc: pointer to scsi command object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
  * Return nothing.
  */
 static void
-_base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
+_base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
@@ -572,22 +572,24 @@ _base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
  * mpt2sas_base_done - base internal command completion routine
  * @ioc: pointer to scsi command object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
-mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+u8
+mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply && mpi_reply->Function == MPI2_FUNCTION_EVENT_ACK)
-		return;
+		return 1;
 
 	if (ioc->base_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 
 	ioc->base_cmds.status |= MPT2_CMD_COMPLETE;
 	if (mpi_reply) {
@@ -596,18 +598,20 @@ mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 	}
 	ioc->base_cmds.status &= ~MPT2_CMD_PENDING;
 	complete(&ioc->base_cmds.done);
+	return 1;
 }
 
 /**
  * _base_async_event - main callback handler for firmware asyn events
  * @ioc: pointer to scsi command object
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-static void
-_base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
+static u8
+_base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 {
 	Mpi2EventNotificationReply_t *mpi_reply;
 	Mpi2EventAckRequest_t *ack_request;
@@ -615,9 +619,9 @@ _base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (!mpi_reply)
-		return;
+		return 1;
 	if (mpi_reply->Function != MPI2_FUNCTION_EVENT_NOTIFICATION)
-		return;
+		return 1;
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	_base_display_event_data(ioc, mpi_reply);
 #endif
@@ -635,16 +639,47 @@ _base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
 	ack_request->Function = MPI2_FUNCTION_EVENT_ACK;
 	ack_request->Event = mpi_reply->Event;
 	ack_request->EventContext = mpi_reply->EventContext;
-	ack_request->VF_ID = VF_ID;
-	mpt2sas_base_put_smid_default(ioc, smid, VF_ID);
+	ack_request->VF_ID = 0;  /* TODO */
+	ack_request->VP_ID = 0;
+	mpt2sas_base_put_smid_default(ioc, smid);
 
  out:
 
 	/* scsih callback handler */
-	mpt2sas_scsih_event_callback(ioc, VF_ID, reply);
+	mpt2sas_scsih_event_callback(ioc, msix_index, reply);
 
 	/* ctl callback handler */
-	mpt2sas_ctl_event_callback(ioc, VF_ID, reply);
+	mpt2sas_ctl_event_callback(ioc, msix_index, reply);
+
+	return 1;
+}
+
+/**
+ * _base_get_cb_idx - obtain the callback index
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Return callback index.
+ */
+static u8
+_base_get_cb_idx(struct MPT2SAS_ADAPTER *ioc, u16 smid)
+{
+	int i;
+	u8 cb_idx = 0xFF;
+
+	if (smid >= ioc->hi_priority_smid) {
+		if (smid < ioc->internal_smid) {
+			i = smid - ioc->hi_priority_smid;
+			cb_idx = ioc->hpr_lookup[i].cb_idx;
+		} else {
+			i = smid - ioc->internal_smid;
+			cb_idx = ioc->internal_lookup[i].cb_idx;
+		}
+	} else {
+		i = smid - 1;
+		cb_idx = ioc->scsi_lookup[i].cb_idx;
+	}
+	return cb_idx;
 }
 
 /**
@@ -680,7 +715,6 @@ _base_unmask_interrupts(struct MPT2SAS_ADAPTER *ioc)
 {
 	u32 him_register;
 
-	writel(0, &ioc->chip->HostInterruptStatus);
 	him_register = readl(&ioc->chip->HostInterruptMask);
 	him_register &= ~MPI2_HIM_RIM;
 	writel(him_register, &ioc->chip->HostInterruptMask);
@@ -712,9 +746,10 @@ _base_interrupt(int irq, void *bus_id)
 	u16 smid;
 	u8 cb_idx;
 	u32 reply;
-	u8 VF_ID;
+	u8 msix_index;
 	struct MPT2SAS_ADAPTER *ioc = bus_id;
 	Mpi2ReplyDescriptorsUnion_t *rpf;
+	u8 rc;
 
 	if (ioc->mask_interrupts)
 		return IRQ_NONE;
@@ -733,7 +768,7 @@ _base_interrupt(int irq, void *bus_id)
 		reply = 0;
 		cb_idx = 0xFF;
 		smid = le16_to_cpu(rpf->Default.DescriptorTypeDependent1);
-		VF_ID = rpf->Default.VF_ID;
+		msix_index = rpf->Default.MSIxIndex;
 		if (request_desript_type ==
 		    MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY) {
 			reply = le32_to_cpu
@@ -745,16 +780,18 @@ _base_interrupt(int irq, void *bus_id)
 		    MPI2_RPY_DESCRIPT_FLAGS_TARGETASSIST_SUCCESS)
 			goto next;
 		if (smid)
-			cb_idx = ioc->scsi_lookup[smid - 1].cb_idx;
+			cb_idx = _base_get_cb_idx(ioc, smid);
 		if (smid && cb_idx != 0xFF) {
-			mpt_callbacks[cb_idx](ioc, smid, VF_ID, reply);
+			rc = mpt_callbacks[cb_idx](ioc, smid, msix_index,
+			    reply);
 			if (reply)
-				_base_display_reply_info(ioc, smid, VF_ID,
+				_base_display_reply_info(ioc, smid, msix_index,
 				    reply);
-			mpt2sas_base_free_smid(ioc, smid);
+			if (rc)
+				mpt2sas_base_free_smid(ioc, smid);
 		}
 		if (!smid)
-			_base_async_event(ioc, VF_ID, reply);
+			_base_async_event(ioc, msix_index, reply);
 
 		/* reply free queue handling */
 		if (reply) {
@@ -1191,19 +1228,6 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * mpt2sas_base_get_msg_frame_dma - obtain request mf pointer phys addr
- * @ioc: per adapter object
- * @smid: system request message index(smid zero is invalid)
- *
- * Returns phys pointer to message frame.
- */
-dma_addr_t
-mpt2sas_base_get_msg_frame_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid)
-{
-	return ioc->request_dma + (smid * ioc->request_sz);
-}
-
-/**
  * mpt2sas_base_get_msg_frame - obtain request mf pointer
  * @ioc: per adapter object
  * @smid: system request message index(smid zero is invalid)
@@ -1258,7 +1282,7 @@ mpt2sas_base_get_reply_virt_addr(struct MPT2SAS_ADAPTER *ioc, u32 phys_addr)
 }
 
 /**
- * mpt2sas_base_get_smid - obtain a free smid
+ * mpt2sas_base_get_smid - obtain a free smid from internal queue
  * @ioc: per adapter object
  * @cb_idx: callback index
  *
@@ -1272,6 +1296,39 @@ mpt2sas_base_get_smid(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx)
 	u16 smid;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (list_empty(&ioc->internal_free_list)) {
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		printk(MPT2SAS_ERR_FMT "%s: smid not available\n",
+		    ioc->name, __func__);
+		return 0;
+	}
+
+	request = list_entry(ioc->internal_free_list.next,
+	    struct request_tracker, tracker_list);
+	request->cb_idx = cb_idx;
+	smid = request->smid;
+	list_del(&request->tracker_list);
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return smid;
+}
+
+/**
+ * mpt2sas_base_get_smid_scsiio - obtain a free smid from scsiio queue
+ * @ioc: per adapter object
+ * @cb_idx: callback index
+ * @scmd: pointer to scsi command object
+ *
+ * Returns smid (zero is invalid)
+ */
+u16
+mpt2sas_base_get_smid_scsiio(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx,
+    struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	struct request_tracker *request;
+	u16 smid;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (list_empty(&ioc->free_list)) {
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		printk(MPT2SAS_ERR_FMT "%s: smid not available\n",
@@ -1281,6 +1338,36 @@ mpt2sas_base_get_smid(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx)
 
 	request = list_entry(ioc->free_list.next,
 	    struct request_tracker, tracker_list);
+	request->scmd = scmd;
+	request->cb_idx = cb_idx;
+	smid = request->smid;
+	list_del(&request->tracker_list);
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return smid;
+}
+
+/**
+ * mpt2sas_base_get_smid_hpr - obtain a free smid from hi-priority queue
+ * @ioc: per adapter object
+ * @cb_idx: callback index
+ *
+ * Returns smid (zero is invalid)
+ */
+u16
+mpt2sas_base_get_smid_hpr(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx)
+{
+	unsigned long flags;
+	struct request_tracker *request;
+	u16 smid;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (list_empty(&ioc->hpr_free_list)) {
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		return 0;
+	}
+
+	request = list_entry(ioc->hpr_free_list.next,
+	    struct request_tracker, tracker_list);
 	request->cb_idx = cb_idx;
 	smid = request->smid;
 	list_del(&request->tracker_list);
@@ -1300,10 +1387,32 @@ void
 mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	unsigned long flags;
+	int i;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	ioc->scsi_lookup[smid - 1].cb_idx = 0xFF;
-	list_add_tail(&ioc->scsi_lookup[smid - 1].tracker_list,
+	if (smid >= ioc->hi_priority_smid) {
+		if (smid < ioc->internal_smid) {
+			/* hi-priority */
+			i = smid - ioc->hi_priority_smid;
+			ioc->hpr_lookup[i].cb_idx = 0xFF;
+			list_add_tail(&ioc->hpr_lookup[i].tracker_list,
+			    &ioc->hpr_free_list);
+		} else {
+			/* internal queue */
+			i = smid - ioc->internal_smid;
+			ioc->internal_lookup[i].cb_idx = 0xFF;
+			list_add_tail(&ioc->internal_lookup[i].tracker_list,
+			    &ioc->internal_free_list);
+		}
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		return;
+	}
+
+	/* scsiio queue */
+	i = smid - 1;
+	ioc->scsi_lookup[i].cb_idx = 0xFF;
+	ioc->scsi_lookup[i].scmd = NULL;
+	list_add_tail(&ioc->scsi_lookup[i].tracker_list,
 	    &ioc->free_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
@@ -1352,21 +1461,19 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
  * mpt2sas_base_put_smid_scsi_io - send SCSI_IO request to firmware
  * @ioc: per adapter object
  * @smid: system request message index
- * @vf_id: virtual function id
  * @handle: device handle
  *
  * Return nothing.
  */
 void
-mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id,
-    u16 handle)
+mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u16 handle)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 
 	descriptor.SCSIIO.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
-	descriptor.SCSIIO.VF_ID = vf_id;
+	descriptor.SCSIIO.MSIxIndex = 0; /* TODO */
 	descriptor.SCSIIO.SMID = cpu_to_le16(smid);
 	descriptor.SCSIIO.DevHandle = cpu_to_le16(handle);
 	descriptor.SCSIIO.LMID = 0;
@@ -1379,20 +1486,18 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id,
  * mpt2sas_base_put_smid_hi_priority - send Task Managment request to firmware
  * @ioc: per adapter object
  * @smid: system request message index
- * @vf_id: virtual function id
  *
  * Return nothing.
  */
 void
-mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    u8 vf_id)
+mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 	descriptor.HighPriority.RequestFlags =
 	    MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY;
-	descriptor.HighPriority.VF_ID = vf_id;
+	descriptor.HighPriority.MSIxIndex = 0; /* TODO */
 	descriptor.HighPriority.SMID = cpu_to_le16(smid);
 	descriptor.HighPriority.LMID = 0;
 	descriptor.HighPriority.Reserved1 = 0;
@@ -1404,18 +1509,17 @@ mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid,
  * mpt2sas_base_put_smid_default - Default, primarily used for config pages
  * @ioc: per adapter object
  * @smid: system request message index
- * @vf_id: virtual function id
  *
  * Return nothing.
  */
 void
-mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id)
+mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 	descriptor.Default.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
-	descriptor.Default.VF_ID = vf_id;
+	descriptor.Default.MSIxIndex = 0; /* TODO */
 	descriptor.Default.SMID = cpu_to_le16(smid);
 	descriptor.Default.LMID = 0;
 	descriptor.Default.DescriptorTypeDependent = 0;
@@ -1427,21 +1531,20 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id)
  * mpt2sas_base_put_smid_target_assist - send Target Assist/Status to firmware
  * @ioc: per adapter object
  * @smid: system request message index
- * @vf_id: virtual function id
  * @io_index: value used to track the IO
  *
  * Return nothing.
  */
 void
 mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    u8 vf_id, u16 io_index)
+    u16 io_index)
 {
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
 	descriptor.SCSITarget.RequestFlags =
 	    MPI2_REQ_DESCRIPT_FLAGS_SCSI_TARGET;
-	descriptor.SCSITarget.VF_ID = vf_id;
+	descriptor.SCSITarget.MSIxIndex = 0; /* TODO */
 	descriptor.SCSITarget.SMID = cpu_to_le16(smid);
 	descriptor.SCSITarget.LMID = 0;
 	descriptor.SCSITarget.IoIndex = cpu_to_le16(io_index);
@@ -1717,6 +1820,8 @@ _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 	}
 
 	kfree(ioc->scsi_lookup);
+	kfree(ioc->hpr_lookup);
+	kfree(ioc->internal_lookup);
 }
 
 
@@ -1736,7 +1841,6 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	u16 num_of_reply_frames;
 	u16 chains_needed_per_io;
 	u32 sz, total_sz;
-	u16 i;
 	u32 retry_sz;
 	u16 max_request_credit;
 
@@ -1764,7 +1868,10 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		    MPT2SAS_MAX_REQUEST_QUEUE) ? MPT2SAS_MAX_REQUEST_QUEUE :
 		    facts->RequestCredit;
 	}
-	ioc->request_depth = max_request_credit;
+
+	ioc->hba_queue_depth = max_request_credit;
+	ioc->hi_priority_depth = facts->HighPriorityCredit;
+	ioc->internal_depth = ioc->hi_priority_depth + 5;
 
 	/* request frame size */
 	ioc->request_sz = facts->IOCRequestFrameSize * 4;
@@ -1802,7 +1909,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	ioc->chains_needed_per_io = chains_needed_per_io;
 
 	/* reply free queue sizing - taking into account for events */
-	num_of_reply_frames = ioc->request_depth + 32;
+	num_of_reply_frames = ioc->hba_queue_depth + 32;
 
 	/* number of replies frames can't be a multiple of 16 */
 	/* decrease number of reply frames by 1 */
@@ -1823,7 +1930,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	 * frames
 	 */
 
-	queue_size = ioc->request_depth + num_of_reply_frames + 1;
+	queue_size = ioc->hba_queue_depth + num_of_reply_frames + 1;
 	/* round up to 16 byte boundary */
 	if (queue_size % 16)
 		queue_size += 16 - (queue_size % 16);
@@ -1837,60 +1944,85 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		if (queue_diff % 16)
 			queue_diff += 16 - (queue_diff % 16);
 
-		/* adjust request_depth, reply_free_queue_depth,
+		/* adjust hba_queue_depth, reply_free_queue_depth,
 		 * and queue_size
 		 */
-		ioc->request_depth -= queue_diff;
+		ioc->hba_queue_depth -= queue_diff;
 		ioc->reply_free_queue_depth -= queue_diff;
 		queue_size -= queue_diff;
 	}
 	ioc->reply_post_queue_depth = queue_size;
 
-	/* max scsi host queue depth */
-	ioc->shost->can_queue = ioc->request_depth - INTERNAL_CMDS_COUNT;
-	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi host queue: depth"
-	    "(%d)\n", ioc->name, ioc->shost->can_queue));
-
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scatter gather: "
 	    "sge_in_main_msg(%d), sge_per_chain(%d), sge_per_io(%d), "
 	    "chains_per_io(%d)\n", ioc->name, ioc->max_sges_in_main_message,
 	    ioc->max_sges_in_chain_message, ioc->shost->sg_tablesize,
 	    ioc->chains_needed_per_io));
 
+	ioc->scsiio_depth = ioc->hba_queue_depth -
+	    ioc->hi_priority_depth - ioc->internal_depth;
+
+	/* set the scsi host can_queue depth
+	 * with some internal commands that could be outstanding
+	 */
+	ioc->shost->can_queue = ioc->scsiio_depth - (2);
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi host: "
+	    "can_queue depth (%d)\n", ioc->name, ioc->shost->can_queue));
+
 	/* contiguous pool for request and chains, 16 byte align, one extra "
 	 * "frame for smid=0
 	 */
-	ioc->chain_depth = ioc->chains_needed_per_io * ioc->request_depth;
-	sz = ((ioc->request_depth + 1 + ioc->chain_depth) * ioc->request_sz);
+	ioc->chain_depth = ioc->chains_needed_per_io * ioc->scsiio_depth;
+	sz = ((ioc->scsiio_depth + 1 + ioc->chain_depth) * ioc->request_sz);
+
+	/* hi-priority queue */
+	sz += (ioc->hi_priority_depth * ioc->request_sz);
+
+	/* internal queue */
+	sz += (ioc->internal_depth * ioc->request_sz);
 
 	ioc->request_dma_sz = sz;
 	ioc->request = pci_alloc_consistent(ioc->pdev, sz, &ioc->request_dma);
 	if (!ioc->request) {
 		printk(MPT2SAS_ERR_FMT "request pool: pci_alloc_consistent "
-		    "failed: req_depth(%d), chains_per_io(%d), frame_sz(%d), "
-		    "total(%d kB)\n", ioc->name, ioc->request_depth,
+		    "failed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), "
+		    "total(%d kB)\n", ioc->name, ioc->hba_queue_depth,
 		    ioc->chains_needed_per_io, ioc->request_sz, sz/1024);
-		if (ioc->request_depth < MPT2SAS_SAS_QUEUE_DEPTH)
+		if (ioc->scsiio_depth < MPT2SAS_SAS_QUEUE_DEPTH)
 			goto out;
 		retry_sz += 64;
-		ioc->request_depth = max_request_credit - retry_sz;
+		ioc->hba_queue_depth = max_request_credit - retry_sz;
 		goto retry_allocation;
 	}
 
 	if (retry_sz)
 		printk(MPT2SAS_ERR_FMT "request pool: pci_alloc_consistent "
-		    "succeed: req_depth(%d), chains_per_io(%d), frame_sz(%d), "
-		    "total(%d kb)\n", ioc->name, ioc->request_depth,
+		    "succeed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), "
+		    "total(%d kb)\n", ioc->name, ioc->hba_queue_depth,
 		    ioc->chains_needed_per_io, ioc->request_sz, sz/1024);
 
-	ioc->chain = ioc->request + ((ioc->request_depth + 1) *
+
+	/* hi-priority queue */
+	ioc->hi_priority = ioc->request + ((ioc->scsiio_depth + 1) *
+	    ioc->request_sz);
+	ioc->hi_priority_dma = ioc->request_dma + ((ioc->scsiio_depth + 1) *
+	    ioc->request_sz);
+
+	/* internal queue */
+	ioc->internal = ioc->hi_priority + (ioc->hi_priority_depth *
+	    ioc->request_sz);
+	ioc->internal_dma = ioc->hi_priority_dma + (ioc->hi_priority_depth *
+	    ioc->request_sz);
+
+	ioc->chain = ioc->internal + (ioc->internal_depth *
 	    ioc->request_sz);
-	ioc->chain_dma = ioc->request_dma + ((ioc->request_depth + 1) *
+	ioc->chain_dma = ioc->internal_dma + (ioc->internal_depth *
 	    ioc->request_sz);
+
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "request pool(0x%p): "
 	    "depth(%d), frame_size(%d), pool_size(%d kB)\n", ioc->name,
-	    ioc->request, ioc->request_depth, ioc->request_sz,
-	    ((ioc->request_depth + 1) * ioc->request_sz)/1024));
+	    ioc->request, ioc->hba_queue_depth, ioc->request_sz,
+	    (ioc->hba_queue_depth * ioc->request_sz)/1024));
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "chain pool(0x%p): depth"
 	    "(%d), frame_size(%d), pool_size(%d kB)\n", ioc->name, ioc->chain,
 	    ioc->chain_depth, ioc->request_sz, ((ioc->chain_depth *
@@ -1899,7 +2031,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	    ioc->name, (unsigned long long) ioc->request_dma));
 	total_sz += sz;
 
-	ioc->scsi_lookup = kcalloc(ioc->request_depth,
+	ioc->scsi_lookup = kcalloc(ioc->scsiio_depth,
 	    sizeof(struct request_tracker), GFP_KERNEL);
 	if (!ioc->scsi_lookup) {
 		printk(MPT2SAS_ERR_FMT "scsi_lookup: kcalloc failed\n",
@@ -1907,12 +2039,38 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 		goto out;
 	}
 
-	 /* initialize some bits */
-	for (i = 0; i < ioc->request_depth; i++)
-		ioc->scsi_lookup[i].smid = i + 1;
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsiio(0x%p): "
+	    "depth(%d)\n", ioc->name, ioc->request,
+	    ioc->scsiio_depth));
+
+	/* initialize hi-priority queue smid's */
+	ioc->hpr_lookup = kcalloc(ioc->hi_priority_depth,
+	    sizeof(struct request_tracker), GFP_KERNEL);
+	if (!ioc->hpr_lookup) {
+		printk(MPT2SAS_ERR_FMT "hpr_lookup: kcalloc failed\n",
+		    ioc->name);
+		goto out;
+	}
+	ioc->hi_priority_smid = ioc->scsiio_depth + 1;
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "hi_priority(0x%p): "
+	    "depth(%d), start smid(%d)\n", ioc->name, ioc->hi_priority,
+	    ioc->hi_priority_depth, ioc->hi_priority_smid));
+
+	/* initialize internal queue smid's */
+	ioc->internal_lookup = kcalloc(ioc->internal_depth,
+	    sizeof(struct request_tracker), GFP_KERNEL);
+	if (!ioc->internal_lookup) {
+		printk(MPT2SAS_ERR_FMT "internal_lookup: kcalloc failed\n",
+		    ioc->name);
+		goto out;
+	}
+	ioc->internal_smid = ioc->hi_priority_smid + ioc->hi_priority_depth;
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "internal(0x%p): "
+	    "depth(%d), start smid(%d)\n", ioc->name, ioc->internal,
+	     ioc->internal_depth, ioc->internal_smid));
 
 	/* sense buffers, 4 byte align */
-	sz = ioc->request_depth * SCSI_SENSE_BUFFERSIZE;
+	sz = ioc->scsiio_depth * SCSI_SENSE_BUFFERSIZE;
 	ioc->sense_dma_pool = pci_pool_create("sense pool", ioc->pdev, sz, 4,
 	    0);
 	if (!ioc->sense_dma_pool) {
@@ -1929,7 +2087,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	}
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
 	    "sense pool(0x%p): depth(%d), element_size(%d), pool_size"
-	    "(%d kB)\n", ioc->name, ioc->sense, ioc->request_depth,
+	    "(%d kB)\n", ioc->name, ioc->sense, ioc->scsiio_depth,
 	    SCSI_SENSE_BUFFERSIZE, sz/1024));
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "sense_dma(0x%llx)\n",
 	    ioc->name, (unsigned long long)ioc->sense_dma));
@@ -2304,7 +2462,7 @@ _base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int request_bytes,
 	    ((request_bytes/4)<<MPI2_DOORBELL_ADD_DWORDS_SHIFT)),
 	    &ioc->chip->Doorbell);
 
-	if ((_base_wait_for_doorbell_int(ioc, 5, sleep_flag))) {
+	if ((_base_wait_for_doorbell_int(ioc, 5, NO_SLEEP))) {
 		printk(MPT2SAS_ERR_FMT "doorbell handshake "
 		   "int failed (line=%d)\n", ioc->name, __LINE__);
 		return -EFAULT;
@@ -2454,7 +2612,8 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
 	if (mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
 	    mpi_request->Operation == MPI2_SAS_OP_PHY_LINK_RESET)
 		ioc->ioc_link_reset_in_progress = 1;
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if ((mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
@@ -2555,7 +2714,8 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 	request = mpt2sas_base_get_msg_frame(ioc, smid);
 	ioc->base_cmds.smid = smid;
 	memcpy(request, mpi_request, sizeof(Mpi2SepReply_t));
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
@@ -2701,13 +2861,12 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 /**
  * _base_send_ioc_init - send ioc_init to firmware
  * @ioc: per adapter object
- * @VF_ID: virtual function id
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
+_base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	Mpi2IOCInitRequest_t mpi_request;
 	Mpi2IOCInitReply_t mpi_reply;
@@ -2719,7 +2878,8 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
 	memset(&mpi_request, 0, sizeof(Mpi2IOCInitRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_IOC_INIT;
 	mpi_request.WhoInit = MPI2_WHOINIT_HOST_DRIVER;
-	mpi_request.VF_ID = VF_ID;
+	mpi_request.VF_ID = 0; /* TODO */
+	mpi_request.VP_ID = 0;
 	mpi_request.MsgVersion = cpu_to_le16(MPI2_VERSION);
 	mpi_request.HeaderVersion = cpu_to_le16(MPI2_HEADER_VERSION);
 
@@ -2795,13 +2955,12 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
 /**
  * _base_send_port_enable - send port_enable(discovery stuff) to firmware
  * @ioc: per adapter object
- * @VF_ID: virtual function id
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
+_base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	Mpi2PortEnableRequest_t *mpi_request;
 	u32 ioc_state;
@@ -2829,9 +2988,11 @@ _base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
 	ioc->base_cmds.smid = smid;
 	memset(mpi_request, 0, sizeof(Mpi2PortEnableRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_PORT_ENABLE;
-	mpi_request->VF_ID = VF_ID;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 
-	mpt2sas_base_put_smid_default(ioc, smid, VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    300*HZ);
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
@@ -2892,13 +3053,12 @@ _base_unmask_events(struct MPT2SAS_ADAPTER *ioc, u16 event)
 /**
  * _base_event_notification - send event notification
  * @ioc: per adapter object
- * @VF_ID: virtual function id
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_event_notification(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
+_base_event_notification(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	Mpi2EventNotificationRequest_t *mpi_request;
 	unsigned long timeleft;
@@ -2926,11 +3086,13 @@ _base_event_notification(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep_flag)
 	ioc->base_cmds.smid = smid;
 	memset(mpi_request, 0, sizeof(Mpi2EventNotificationRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_EVENT_NOTIFICATION;
-	mpi_request->VF_ID = VF_ID;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 	for (i = 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
 		mpi_request->EventMasks[i] =
 		    le32_to_cpu(ioc->event_masks[i]);
-	mpt2sas_base_put_smid_default(ioc, smid, VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
 		printk(MPT2SAS_ERR_FMT "%s: timeout\n",
@@ -2981,7 +3143,7 @@ mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_type)
 		return;
 
 	mutex_lock(&ioc->base_cmds.mutex);
-	_base_event_notification(ioc, 0, CAN_SLEEP);
+	_base_event_notification(ioc, CAN_SLEEP);
 	mutex_unlock(&ioc->base_cmds.mutex);
 }
 
@@ -3006,7 +3168,6 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 	drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "clear interrupts\n",
 	    ioc->name));
-	writel(0, &ioc->chip->HostInterruptStatus);
 
 	count = 0;
 	do {
@@ -3160,30 +3321,60 @@ _base_make_ioc_ready(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 /**
  * _base_make_ioc_operational - put controller in OPERATIONAL state
  * @ioc: per adapter object
- * @VF_ID: virtual function id
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
  *
  * Returns 0 for success, non-zero for failure.
  */
 static int
-_base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    int sleep_flag)
+_base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	int r, i;
 	unsigned long	flags;
 	u32 reply_address;
+	u16 smid;
+	struct _tr_list *delayed_tr, *delayed_tr_next;
 
 	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
 	    __func__));
 
+	/* clean the delayed target reset list */
+	list_for_each_entry_safe(delayed_tr, delayed_tr_next,
+	    &ioc->delayed_tr_list, list) {
+		list_del(&delayed_tr->list);
+		kfree(delayed_tr);
+	}
+
 	/* initialize the scsi lookup free list */
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	INIT_LIST_HEAD(&ioc->free_list);
-	for (i = 0; i < ioc->request_depth; i++) {
+	smid = 1;
+	for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
+		ioc->scsi_lookup[i].smid = smid;
+		ioc->scsi_lookup[i].scmd = NULL;
 		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
 		    &ioc->free_list);
 	}
+
+	/* hi-priority queue */
+	INIT_LIST_HEAD(&ioc->hpr_free_list);
+	smid = ioc->hi_priority_smid;
+	for (i = 0; i < ioc->hi_priority_depth; i++, smid++) {
+		ioc->hpr_lookup[i].cb_idx = 0xFF;
+		ioc->hpr_lookup[i].smid = smid;
+		list_add_tail(&ioc->hpr_lookup[i].tracker_list,
+		    &ioc->hpr_free_list);
+	}
+
+	/* internal queue */
+	INIT_LIST_HEAD(&ioc->internal_free_list);
+	smid = ioc->internal_smid;
+	for (i = 0; i < ioc->internal_depth; i++, smid++) {
+		ioc->internal_lookup[i].cb_idx = 0xFF;
+		ioc->internal_lookup[i].smid = smid;
+		list_add_tail(&ioc->internal_lookup[i].tracker_list,
+		    &ioc->internal_free_list);
+	}
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	/* initialize Reply Free Queue */
@@ -3196,7 +3387,7 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	for (i = 0; i < ioc->reply_post_queue_depth; i++)
 		ioc->reply_post_free[i].Words = ULLONG_MAX;
 
-	r = _base_send_ioc_init(ioc, VF_ID, sleep_flag);
+	r = _base_send_ioc_init(ioc, sleep_flag);
 	if (r)
 		return r;
 
@@ -3207,14 +3398,14 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	writel(0, &ioc->chip->ReplyPostHostIndex);
 
 	_base_unmask_interrupts(ioc);
-	r = _base_event_notification(ioc, VF_ID, sleep_flag);
+	r = _base_event_notification(ioc, sleep_flag);
 	if (r)
 		return r;
 
 	if (sleep_flag == CAN_SLEEP)
 		_base_static_config_pages(ioc);
 
-	r = _base_send_port_enable(ioc, VF_ID, sleep_flag);
+	r = _base_send_port_enable(ioc, sleep_flag);
 	if (r)
 		return r;
 
@@ -3278,6 +3469,17 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
+	ioc->pfacts = kcalloc(ioc->facts.NumberOfPorts,
+	    sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);
+	if (!ioc->pfacts)
+		goto out_free_resources;
+
+	for (i = 0 ; i < ioc->facts.NumberOfPorts; i++) {
+		r = _base_get_port_facts(ioc, i, CAN_SLEEP);
+		if (r)
+			goto out_free_resources;
+	}
+
 	r = _base_allocate_memory_pools(ioc, CAN_SLEEP);
 	if (r)
 		goto out_free_resources;
@@ -3286,7 +3488,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 
 	/* base internal command bits */
 	mutex_init(&ioc->base_cmds.mutex);
-	init_completion(&ioc->base_cmds.done);
 	ioc->base_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->base_cmds.status = MPT2_CMD_NOT_USED;
 
@@ -3294,7 +3495,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->transport_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->transport_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->transport_cmds.mutex);
-	init_completion(&ioc->transport_cmds.done);
 
 	/* task management internal command bits */
 	ioc->tm_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
@@ -3310,7 +3510,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->ctl_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->ctl_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->ctl_cmds.mutex);
-	init_completion(&ioc->ctl_cmds.done);
 
 	for (i = 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
 		ioc->event_masks[i] = -1;
@@ -3327,18 +3526,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	_base_unmask_events(ioc, MPI2_EVENT_IR_OPERATION_STATUS);
 	_base_unmask_events(ioc, MPI2_EVENT_TASK_SET_FULL);
 	_base_unmask_events(ioc, MPI2_EVENT_LOG_ENTRY_ADDED);
-
-	ioc->pfacts = kcalloc(ioc->facts.NumberOfPorts,
-	    sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);
-	if (!ioc->pfacts)
-		goto out_free_resources;
-
-	for (i = 0 ; i < ioc->facts.NumberOfPorts; i++) {
-		r = _base_get_port_facts(ioc, i, CAN_SLEEP);
-		if (r)
-			goto out_free_resources;
-	}
-	r = _base_make_ioc_operational(ioc, 0, CAN_SLEEP);
+	r = _base_make_ioc_operational(ioc, CAN_SLEEP);
 	if (r)
 		goto out_free_resources;
 
@@ -3466,7 +3654,7 @@ _wait_for_commands_to_complete(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 	/* pending command count */
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = 0; i < ioc->request_depth; i++)
+	for (i = 0; i < ioc->scsiio_depth; i++)
 		if (ioc->scsi_lookup[i].cb_idx != 0xFF)
 			ioc->pending_io_count++;
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
@@ -3490,7 +3678,7 @@ int
 mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
     enum reset_type type)
 {
-	int r, i;
+	int r;
 	unsigned long flags;
 
 	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
@@ -3513,9 +3701,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	if (r)
 		goto out;
 	_base_reset_handler(ioc, MPT2_IOC_AFTER_RESET);
-	for (i = 0 ; i < ioc->facts.NumberOfPorts; i++)
-		r = _base_make_ioc_operational(ioc, ioc->pfacts[i].VF_ID,
-		    sleep_flag);
+	r = _base_make_ioc_operational(ioc, sleep_flag);
 	if (!r)
 		_base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
  out:
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 2faab1e..0cf6bc2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.h
- * Copyright (C) 2007-2008  LSI Corporation
+ * Copyright (C) 2007-2009  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -69,10 +69,10 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"01.100.06.00"
-#define MPT2SAS_MAJOR_VERSION		01
+#define MPT2SAS_DRIVER_VERSION		"02.100.03.00"
+#define MPT2SAS_MAJOR_VERSION		02
 #define MPT2SAS_MINOR_VERSION		100
-#define MPT2SAS_BUILD_VERSION		06
+#define MPT2SAS_BUILD_VERSION		03
 #define MPT2SAS_RELEASE_VERSION		00
 
 /*
@@ -264,6 +264,13 @@ struct _internal_cmd {
  * SAS Topology Structures
  */
 
+#define MPTSAS_STATE_TR_SEND		0x0001
+#define MPTSAS_STATE_TR_COMPLETE	0x0002
+#define MPTSAS_STATE_CNTRL_SEND		0x0004
+#define MPTSAS_STATE_CNTRL_COMPLETE	0x0008
+
+#define MPT2SAS_REQ_SAS_CNTRL		0x0010
+
 /**
  * struct _sas_device - attached device information
  * @list: sas device list
@@ -300,6 +307,7 @@ struct _sas_device {
 	u16	slot;
 	u8	hidden_raid_component;
 	u8	responding;
+	u16	state;
 };
 
 /**
@@ -436,6 +444,17 @@ struct request_tracker {
 	struct list_head tracker_list;
 };
 
+/**
+ * struct _tr_list - target reset list
+ * @handle: device handle
+ * @state: state machine
+ */
+struct _tr_list {
+	struct list_head list;
+	u16	handle;
+	u16	state;
+};
+
 typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
 
 /**
@@ -510,8 +529,9 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
  * @config_page_sz: config page size
  * @config_page: reserve memory for config page payload
  * @config_page_dma:
+ * @hba_queue_depth: hba request queue depth
  * @sge_size: sg element size for either 32/64 bit
- * @request_depth: hba request queue depth
+ * @scsiio_depth: SCSI_IO queue depth
  * @request_sz: per request frame size
  * @request: pool of request frames
  * @request_dma:
@@ -528,6 +548,18 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
  * @chains_needed_per_io: max chains per io
  * @chain_offset_value_for_main_message: location 1st sg in main
  * @chain_depth: total chains allocated
+ * @hi_priority_smid:
+ * @hi_priority:
+ * @hi_priority_dma:
+ * @hi_priority_depth:
+ * @hpr_lookup:
+ * @hpr_free_list:
+ * @internal_smid:
+ * @internal:
+ * @internal_dma:
+ * @internal_depth:
+ * @internal_lookup:
+ * @internal_free_list:
  * @sense: pool of sense
  * @sense_dma:
  * @sense_dma_pool:
@@ -597,6 +629,8 @@ struct MPT2SAS_ADAPTER {
 	u8		ctl_cb_idx;
 	u8		base_cb_idx;
 	u8		config_cb_idx;
+	u8		tm_tr_cb_idx;
+	u8		tm_sas_control_cb_idx;
 	struct _internal_cmd base_cmds;
 	struct _internal_cmd transport_cmds;
 	struct _internal_cmd tm_cmds;
@@ -643,9 +677,10 @@ struct MPT2SAS_ADAPTER {
 	void 		*config_page;
 	dma_addr_t	config_page_dma;
 
-	/* request */
+	/* scsiio request */
+	u16		hba_queue_depth;
 	u16		sge_size;
-	u16 		request_depth;
+	u16 		scsiio_depth;
 	u16		request_sz;
 	u8		*request;
 	dma_addr_t	request_dma;
@@ -665,6 +700,22 @@ struct MPT2SAS_ADAPTER {
 	u16		chain_offset_value_for_main_message;
 	u16		chain_depth;
 
+	/* hi-priority queue */
+	u16		hi_priority_smid;
+	u8		*hi_priority;
+	dma_addr_t	hi_priority_dma;
+	u16		hi_priority_depth;
+	struct request_tracker *hpr_lookup;
+	struct list_head hpr_free_list;
+
+	/* internal queue */
+	u16		internal_smid;
+	u8		*internal;
+	dma_addr_t	internal_dma;
+	u16		internal_depth;
+	struct request_tracker *internal_lookup;
+	struct list_head internal_free_list;
+
 	/* sense */
 	u8		*sense;
 	dma_addr_t	sense_dma;
@@ -690,6 +741,8 @@ struct MPT2SAS_ADAPTER {
 	struct dma_pool *reply_post_free_dma_pool;
 	u32		reply_post_host_index;
 
+	struct list_head delayed_tr_list;
+
 	/* diag buffer support */
 	u8		*diag_buffer[MPI2_DIAG_BUF_TYPE_COUNT];
 	u32		diag_buffer_sz[MPI2_DIAG_BUF_TYPE_COUNT];
@@ -701,7 +754,7 @@ struct MPT2SAS_ADAPTER {
 	u32		diagnostic_flags[MPI2_DIAG_BUF_TYPE_COUNT];
 };
 
-typedef void (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
+typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply);
 
 
@@ -720,22 +773,28 @@ int mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 void *mpt2sas_base_get_msg_frame(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void *mpt2sas_base_get_sense_buffer(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_build_zero_len_sge(struct MPT2SAS_ADAPTER *ioc, void *paddr);
-dma_addr_t mpt2sas_base_get_msg_frame_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid);
-dma_addr_t mpt2sas_base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid);
+dma_addr_t mpt2sas_base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc,
+    u16 smid);
+
+/* hi-priority queue */
+u16 mpt2sas_base_get_smid_hpr(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx);
+u16 mpt2sas_base_get_smid_scsiio(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx,
+    struct scsi_cmnd *scmd);
 
 u16 mpt2sas_base_get_smid(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid);
-void mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id,
+void mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid,
     u16 handle);
-void mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id);
+void mpt2sas_base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    u8 vf_id, u16 io_index);
-void mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_id);
+    u16 io_index);
+void mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_initialize_callback_handler(void);
 u8 mpt2sas_base_register_callback_handler(MPT_CALLBACK cb_func);
 void mpt2sas_base_release_callback_handler(u8 cb_idx);
 
-void mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply);
+u8 mpt2sas_base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply);
 void *mpt2sas_base_get_reply_virt_addr(struct MPT2SAS_ADAPTER *ioc, u32 phys_addr);
 
 u32 mpt2sas_base_get_iocstate(struct MPT2SAS_ADAPTER *ioc, int cooked);
@@ -749,6 +808,8 @@ int mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 void mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_type);
 
 /* scsih shared API */
+u8 mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+    u32 reply);
 void mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
     u8 type, u16 smid_task, ulong timeout);
 void mpt2sas_scsih_set_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle);
@@ -760,11 +821,11 @@ struct _sas_node *mpt2sas_scsih_expander_find_by_sas_address(struct MPT2SAS_ADAP
 struct _sas_device *mpt2sas_scsih_sas_device_find_by_sas_address(
     struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
 
-void mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply);
 void mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
 
 /* config shared API */
-void mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply);
+u8 mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply);
 int mpt2sas_config_get_number_hba_phys(struct MPT2SAS_ADAPTER *ioc, u8 *num_phys);
 int mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
     Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage0_t *config_page);
@@ -817,14 +878,17 @@ extern struct device_attribute *mpt2sas_host_attrs[];
 extern struct device_attribute *mpt2sas_dev_attrs[];
 void mpt2sas_ctl_init(void);
 void mpt2sas_ctl_exit(void);
-void mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply);
+u8 mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply);
 void mpt2sas_ctl_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
-void mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply);
+u8 mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+    u32 reply);
 void mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
     Mpi2EventNotificationReply_t *mpi_reply);
 
 /* transport shared API */
-void mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply);
+u8 mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply);
 struct _sas_port *mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc,
     u16 handle, u16 parent_handle);
 void mpt2sas_transport_port_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
@@ -838,6 +902,8 @@ void mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 extern struct sas_function_template mpt2sas_transport_functions;
 extern struct scsi_transport_template *mpt2sas_transport_template;
 extern int scsi_internal_device_block(struct scsi_device *sdev);
+extern u8 mpt2sas_stm_zero_smid_handler(struct MPT2SAS_ADAPTER *ioc,
+    u8 msix_index, u32 reply);
 extern int scsi_internal_device_unblock(struct scsi_device *sdev);
 
 #endif /* MPT2SAS_BASE_H_INCLUDED */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index ab8c560..594a389 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -2,7 +2,7 @@
  * This module provides common API for accessing firmware configuration pages
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.c
- * Copyright (C) 2007-2008  LSI Corporation
+ * Copyright (C) 2007-2009  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -227,23 +227,25 @@ _config_free_config_dma_memory(struct MPT2SAS_ADAPTER *ioc,
  * mpt2sas_config_done - config page completion routine
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: none.
  *
  * The callback handler when using _config_request.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
-mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+u8
+mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
 	if (ioc->config_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 	if (ioc->config_cmds.smid != smid)
-		return;
+		return 1;
 	ioc->config_cmds.status |= MPT2_CMD_COMPLETE;
 	mpi_reply =  mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply) {
@@ -257,6 +259,7 @@ mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 #endif
 	ioc->config_cmds.smid = USHORT_MAX;
 	complete(&ioc->config_cmds.done);
+	return 1;
 }
 
 /**
@@ -303,6 +306,9 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	retry_count = 0;
 	memset(&mem, 0, sizeof(struct config_request));
 
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
+
 	if (config_page) {
 		mpi_request->Header.PageVersion = mpi_reply->Header.PageVersion;
 		mpi_request->Header.PageNumber = mpi_reply->Header.PageNumber;
@@ -380,7 +386,7 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	_config_display_some_debug(ioc, smid, "config_request", NULL);
 #endif
 	init_completion(&ioc->config_cmds.done);
-	mpt2sas_base_put_smid_default(ioc, smid, config_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
 	    timeout*HZ);
 	if (!(ioc->config_cmds.status & MPT2_CMD_COMPLETE)) {
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index c2a5101..57d7246 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_ctl.c
- * Copyright (C) 2007-2008  LSI Corporation
+ * Copyright (C) 2007-2009  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -219,23 +219,25 @@ _ctl_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
  * mpt2sas_ctl_done - ctl module completion routine
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: none.
  *
  * The callback handler when using ioc->ctl_cb_idx.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
-mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+u8
+mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+	u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
 	if (ioc->ctl_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 	if (ioc->ctl_cmds.smid != smid)
-		return;
+		return 1;
 	ioc->ctl_cmds.status |= MPT2_CMD_COMPLETE;
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply) {
@@ -247,6 +249,7 @@ mpt2sas_ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 #endif
 	ioc->ctl_cmds.status &= ~MPT2_CMD_PENDING;
 	complete(&ioc->ctl_cmds.done);
+	return 1;
 }
 
 /**
@@ -328,22 +331,25 @@ mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
 /**
  * mpt2sas_ctl_event_callback - firmware event handler (called at ISR time)
  * @ioc: per adapter object
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: interrupt.
  *
  * This function merely adds a new work task into ioc->firmware_event_thread.
  * The tasks are worked from _firmware_event_work in user context.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
-mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
+u8
+mpt2sas_ctl_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+	u32 reply)
 {
 	Mpi2EventNotificationReply_t *mpi_reply;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	mpt2sas_ctl_add_to_event_log(ioc, mpi_reply);
+	return 1;
 }
 
 /**
@@ -507,7 +513,7 @@ _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
 
 	handle = le16_to_cpu(tm_request->DevHandle);
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = ioc->request_depth; i && !found; i--) {
+	for (i = ioc->scsiio_depth; i && !found; i--) {
 		scmd = ioc->scsi_lookup[i - 1].scmd;
 		if (scmd == NULL || scmd->device == NULL ||
 		    scmd->device->hostdata == NULL)
@@ -614,7 +620,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		printk(MPT2SAS_INFO_FMT "%s: ioc is operational\n",
 		    ioc->name, __func__);
 
-	smid = mpt2sas_base_get_smid(ioc, ioc->ctl_cb_idx);
+	smid = mpt2sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_idx, NULL);
 	if (!smid) {
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
@@ -737,7 +743,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		    (u32)mpt2sas_base_get_sense_buffer_dma(ioc, smid);
 		priv_sense = mpt2sas_base_get_sense_buffer(ioc, smid);
 		memset(priv_sense, 0, SCSI_SENSE_BUFFERSIZE);
-		mpt2sas_base_put_smid_scsi_io(ioc, smid, 0,
+		mpt2sas_base_put_smid_scsi_io(ioc, smid,
 		    le16_to_cpu(mpi_request->FunctionDependent1));
 		break;
 	}
@@ -759,8 +765,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		mutex_lock(&ioc->tm_cmds.mutex);
 		mpt2sas_scsih_set_tm_flag(ioc, le16_to_cpu(
 		    tm_request->DevHandle));
-		mpt2sas_base_put_smid_hi_priority(ioc, smid,
-		    mpi_request->VF_ID);
+		mpt2sas_base_put_smid_hi_priority(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SMP_PASSTHROUGH:
@@ -781,7 +786,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 			ioc->ioc_link_reset_in_progress = 1;
 			ioc->ignore_loginfos = 1;
 		}
-		mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+		mpt2sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SAS_IO_UNIT_CONTROL:
@@ -795,11 +800,11 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 			ioc->ioc_link_reset_in_progress = 1;
 			ioc->ignore_loginfos = 1;
 		}
-		mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+		mpt2sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	default:
-		mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+		mpt2sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 
@@ -807,6 +812,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		timeout = MPT2_IOCTL_DEFAULT_TIMEOUT;
 	else
 		timeout = karg.timeout;
+	init_completion(&ioc->ctl_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    timeout*HZ);
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT) {
@@ -1371,6 +1377,8 @@ _ctl_diag_register(void __user *arg, enum block_state state)
 	mpi_request->Flags = cpu_to_le32(karg.diagnostic_flags);
 	mpi_request->BufferAddress = cpu_to_le64(request_data_dma);
 	mpi_request->BufferLength = cpu_to_le32(request_data_sz);
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 
 	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: diag_buffer(0x%p), "
 	    "dma(0x%llx), sz(%d)\n", ioc->name, __func__, request_data,
@@ -1380,7 +1388,8 @@ _ctl_diag_register(void __user *arg, enum block_state state)
 		mpi_request->ProductSpecific[i] =
 			cpu_to_le32(ioc->product_specific[buffer_type][i]);
 
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->ctl_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -1643,8 +1652,11 @@ _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 
 	mpi_request->Function = MPI2_FUNCTION_DIAG_RELEASE;
 	mpi_request->BufferType = buffer_type;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->ctl_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -1902,8 +1914,11 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	for (i = 0; i < MPT2_PRODUCT_SPECIFIC_DWORDS; i++)
 		mpi_request->ProductSpecific[i] =
 			cpu_to_le32(ioc->product_specific[buffer_type][i]);
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 
-	mpt2sas_base_put_smid_default(ioc, smid, mpi_request->VF_ID);
+	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->ctl_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -2069,6 +2084,7 @@ static long
 _ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
+
 	lock_kernel();
 	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg);
 	unlock_kernel();
@@ -2143,6 +2159,7 @@ static long
 _ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
 {
 	long ret;
+
 	lock_kernel();
 	if (cmd == MPT2COMMAND32)
 		ret = _ctl_compat_mpt_command(file, cmd, arg);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
index 4da1143..211f296 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_ctl.h
- * Copyright (C) 2007-2008  LSI Corporation
+ * Copyright (C) 2007-2009  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_debug.h b/drivers/scsi/mpt2sas/mpt2sas_debug.h
index ad32509..5308a25 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_debug.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_debug.h
@@ -2,7 +2,7 @@
  * Logging Support for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_debug.c
- * Copyright (C) 2007-2008  LSI Corporation
+ * Copyright (C) 2007-2009  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 774b345..86ab32d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2,7 +2,7 @@
  * Scsi Host Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_scsih.c
- * Copyright (C) 2007-2008  LSI Corporation
+ * Copyright (C) 2007-2009  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -79,6 +79,9 @@ static u8 transport_cb_idx = -1;
 static u8 config_cb_idx = -1;
 static int mpt_ids;
 
+static u8 tm_tr_cb_idx = -1 ;
+static u8 tm_sas_control_cb_idx = -1;
+
 /* command line options */
 static u32 logging_level;
 MODULE_PARM_DESC(logging_level, " bits for enabling additional logging info "
@@ -109,6 +112,7 @@ struct sense_info {
  * @work: work object (ioc->fault_reset_work_q)
  * @ioc: per adapter object
  * @VF_ID: virtual function id
+ * @VP_ID: virtual port id
  * @host_reset_handling: handling events during host reset
  * @ignore: flag meaning this event has been marked to ignore
  * @event: firmware event MPI2_EVENT_XXX defined in mpt2_ioc.h
@@ -121,6 +125,7 @@ struct fw_event_work {
 	struct work_struct	work;
 	struct MPT2SAS_ADAPTER *ioc;
 	u8			VF_ID;
+	u8			VP_ID;
 	u8			host_reset_handling;
 	u8			ignore;
 	u16			event;
@@ -138,8 +143,10 @@ struct fw_event_work {
  * @lun: lun number
  * @cdb_length: cdb length
  * @cdb: cdb contents
- * @valid_reply: flag set for reply message
  * @timeout: timeout for this command
+ * @VF_ID: virtual function id
+ * @VP_ID: virtual port id
+ * @valid_reply: flag set for reply message
  * @sense_length: sense length
  * @ioc_status: ioc status
  * @scsi_state: scsi state
@@ -161,6 +168,8 @@ struct _scsi_io_transfer {
 	u8	cdb_length;
 	u8	cdb[32];
 	u8	timeout;
+	u8	VF_ID;
+	u8	VP_ID;
 	u8	valid_reply;
   /* the following bits are only valid when 'valid_reply = 1' */
 	u32	sense_length;
@@ -756,66 +765,16 @@ _scsih_is_end_device(u32 device_info)
 }
 
 /**
- * _scsih_scsi_lookup_get - returns scmd entry
+ * mptscsih_get_scsi_lookup - returns scmd entry
  * @ioc: per adapter object
  * @smid: system request message index
- * Context: This function will acquire ioc->scsi_lookup_lock.
  *
  * Returns the smid stored scmd pointer.
  */
 static struct scsi_cmnd *
 _scsih_scsi_lookup_get(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
-	unsigned long	flags;
-	struct scsi_cmnd *scmd;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	scmd = ioc->scsi_lookup[smid - 1].scmd;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return scmd;
-}
-
-/**
- * mptscsih_getclear_scsi_lookup - returns scmd entry
- * @ioc: per adapter object
- * @smid: system request message index
- * Context: This function will acquire ioc->scsi_lookup_lock.
- *
- * Returns the smid stored scmd pointer, as well as clearing the scmd pointer.
- */
-static struct scsi_cmnd *
-_scsih_scsi_lookup_getclear(struct MPT2SAS_ADAPTER *ioc, u16 smid)
-{
-	unsigned long	flags;
-	struct scsi_cmnd *scmd;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	scmd = ioc->scsi_lookup[smid - 1].scmd;
-	ioc->scsi_lookup[smid - 1].scmd = NULL;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return scmd;
-}
-
-/**
- * _scsih_scsi_lookup_set - updates scmd entry in lookup
- * @ioc: per adapter object
- * @smid: system request message index
- * @scmd: pointer to scsi command object
- * Context: This function will acquire ioc->scsi_lookup_lock.
- *
- * This will save scmd pointer in the scsi_lookup array.
- *
- * Return nothing.
- */
-static void
-_scsih_scsi_lookup_set(struct MPT2SAS_ADAPTER *ioc, u16 smid,
-    struct scsi_cmnd *scmd)
-{
-	unsigned long	flags;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	ioc->scsi_lookup[smid - 1].scmd = scmd;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return ioc->scsi_lookup[smid - 1].scmd;
 }
 
 /**
@@ -838,9 +797,9 @@ _scsih_scsi_lookup_find_by_scmd(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	smid = 0;
-	for (i = 0; i < ioc->request_depth; i++) {
+	for (i = 0; i < ioc->scsiio_depth; i++) {
 		if (ioc->scsi_lookup[i].scmd == scmd) {
-			smid = i + 1;
+			smid = ioc->scsi_lookup[i].smid;
 			goto out;
 		}
 	}
@@ -869,7 +828,7 @@ _scsih_scsi_lookup_find_by_target(struct MPT2SAS_ADAPTER *ioc, int id,
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
-	for (i = 0 ; i < ioc->request_depth; i++) {
+	for (i = 0 ; i < ioc->scsiio_depth; i++) {
 		if (ioc->scsi_lookup[i].scmd &&
 		    (ioc->scsi_lookup[i].scmd->device->id == id &&
 		    ioc->scsi_lookup[i].scmd->device->channel == channel)) {
@@ -903,7 +862,7 @@ _scsih_scsi_lookup_find_by_lun(struct MPT2SAS_ADAPTER *ioc, int id,
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
-	for (i = 0 ; i < ioc->request_depth; i++) {
+	for (i = 0 ; i < ioc->scsiio_depth; i++) {
 		if (ioc->scsi_lookup[i].scmd &&
 		    (ioc->scsi_lookup[i].scmd->device->id == id &&
 		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
@@ -1113,7 +1072,7 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 }
 
 /**
- * _scsih_change_queue_depth - changing device queue tag type
+ * _scsih_change_queue_type - changing device queue tag type
  * @sdev: scsi device struct
  * @tag_type: requested tag type
  *
@@ -1679,23 +1638,24 @@ _scsih_response_code(struct MPT2SAS_ADAPTER *ioc, u8 response_code)
  * _scsih_tm_done - tm completion routine
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: none.
  *
  * The callback handler when using scsih_issue_tm.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-static void
-_scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+static u8
+_scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
 	if (ioc->tm_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 	if (ioc->tm_cmds.smid != smid)
-		return;
+		return 1;
 	ioc->tm_cmds.status |= MPT2_CMD_COMPLETE;
 	mpi_reply =  mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply) {
@@ -1704,6 +1664,7 @@ _scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 	}
 	ioc->tm_cmds.status &= ~MPT2_CMD_PENDING;
 	complete(&ioc->tm_cmds.done);
+	return 1;
 }
 
 /**
@@ -1790,7 +1751,6 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 	u16 smid = 0;
 	u32 ioc_state;
 	unsigned long timeleft;
-	u8 VF_ID = 0;
 
 	if (ioc->tm_cmds.status != MPT2_CMD_NOT_USED) {
 		printk(MPT2SAS_INFO_FMT "%s: tm_cmd busy!!!\n",
@@ -1817,7 +1777,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 		goto issue_host_reset;
 	}
 
-	smid = mpt2sas_base_get_smid(ioc, ioc->tm_cb_idx);
+	smid = mpt2sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
 	if (!smid) {
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
@@ -1825,7 +1785,8 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 	}
 
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "sending tm: handle(0x%04x),"
-	    " task_type(0x%02x), smid(%d)\n", ioc->name, handle, type, smid));
+	    " task_type(0x%02x), smid(%d)\n", ioc->name, handle, type,
+	    smid_task));
 	ioc->tm_cmds.status = MPT2_CMD_PENDING;
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 	ioc->tm_cmds.smid = smid;
@@ -1834,10 +1795,12 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = type;
 	mpi_request->TaskMID = cpu_to_le16(smid_task);
+	mpi_request->VP_ID = 0;  /* TODO */
+	mpi_request->VF_ID = 0;
 	int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
 	mpt2sas_scsih_set_tm_flag(ioc, handle);
 	init_completion(&ioc->tm_cmds.done);
-	mpt2sas_base_put_smid_hi_priority(ioc, smid, VF_ID);
+	mpt2sas_base_put_smid_hi_priority(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
 	mpt2sas_scsih_clear_tm_flag(ioc, handle);
 	if (!(ioc->tm_cmds.status & MPT2_CMD_COMPLETE)) {
@@ -2075,7 +2038,7 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
 }
 
 /**
- * _scsih_abort - eh threads main host reset routine
+ * _scsih_host_reset - eh threads main host reset routine
  * @sdev: scsi device struct
  *
  * Returns SUCCESS if command aborted else FAILED
@@ -2354,6 +2317,231 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
+ * _scsih_tm_tr_send - send task management request
+ * @ioc: per adapter object
+ * @handle: device handle
+ * Context: interrupt time.
+ *
+ * This code is to initiate the device removal handshake protocal
+ * with controller firmware.  This function will issue target reset
+ * using high priority request queue.  It will send a sas iounit
+ * controll request (MPI2_SAS_OP_REMOVE_DEVICE) from this completion.
+ *
+ * This is designed to send muliple task management request at the same
+ * time to the fifo. If the fifo is full, we will append the request,
+ * and process it in a future completion.
+ */
+static void
+_scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
+{
+	Mpi2SCSITaskManagementRequest_t *mpi_request;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
+	u16 smid;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+	struct _tr_list *delayed_tr;
+
+	if (ioc->shost_recovery) {
+		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
+		    __func__, ioc->name);
+		return;
+	}
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		printk(MPT2SAS_ERR_FMT "%s: failed finding sas_device\n",
+		    ioc->name, __func__);
+		return;
+	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	/* skip is hidden raid component */
+	if (sas_device->hidden_raid_component)
+		return;
+
+	smid = mpt2sas_base_get_smid_hpr(ioc, ioc->tm_tr_cb_idx);
+	if (!smid) {
+		delayed_tr = kzalloc(sizeof(*delayed_tr), GFP_ATOMIC);
+		if (!delayed_tr)
+			return;
+		INIT_LIST_HEAD(&delayed_tr->list);
+		delayed_tr->handle = handle;
+		delayed_tr->state = MPT2SAS_REQ_SAS_CNTRL;
+		list_add_tail(&delayed_tr->list,
+		    &ioc->delayed_tr_list);
+		if (sas_device->starget)
+			dewtprintk(ioc, starget_printk(KERN_INFO,
+			    sas_device->starget, "DELAYED:tr:handle(0x%04x), "
+			    "(open)\n", sas_device->handle));
+		return;
+	}
+
+	if (sas_device->starget && sas_device->starget->hostdata) {
+		sas_target_priv_data = sas_device->starget->hostdata;
+		sas_target_priv_data->tm_busy = 1;
+		dewtprintk(ioc, starget_printk(KERN_INFO, sas_device->starget,
+		    "tr:handle(0x%04x), (open)\n", sas_device->handle));
+	}
+
+	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
+	memset(mpi_request, 0, sizeof(Mpi2SCSITaskManagementRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
+	mpi_request->DevHandle = cpu_to_le16(handle);
+	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
+	sas_device->state |= MPTSAS_STATE_TR_SEND;
+	sas_device->state |= MPT2SAS_REQ_SAS_CNTRL;
+	mpt2sas_base_put_smid_hi_priority(ioc, smid);
+}
+
+
+
+/**
+ * _scsih_sas_control_complete - completion routine
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ * Context: interrupt time.
+ *
+ * This is the sas iounit controll completion routine.
+ * This code is part of the code to initiate the device removal
+ * handshake protocal with controller firmware.
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_sas_control_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid,
+    u8 msix_index, u32 reply)
+{
+	unsigned long flags;
+	u16 handle;
+	struct _sas_device *sas_device;
+	Mpi2SasIoUnitControlReply_t *mpi_reply =
+	    mpt2sas_base_get_reply_virt_addr(ioc, reply);
+
+	handle = le16_to_cpu(mpi_reply->DevHandle);
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		printk(MPT2SAS_ERR_FMT "%s: failed finding sas_device\n",
+		    ioc->name, __func__);
+		return 1;
+	}
+	sas_device->state |= MPTSAS_STATE_CNTRL_COMPLETE;
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (sas_device->starget)
+		dewtprintk(ioc, starget_printk(KERN_INFO, sas_device->starget,
+		    "sc_complete:handle(0x%04x), "
+		    "ioc_status(0x%04x), loginfo(0x%08x)\n",
+		    handle, le16_to_cpu(mpi_reply->IOCStatus),
+		    le32_to_cpu(mpi_reply->IOCLogInfo)));
+	return 1;
+}
+
+/**
+ * _scsih_tm_tr_complete -
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ * Context: interrupt time.
+ *
+ * This is the target reset completion routine.
+ * This code is part of the code to initiate the device removal
+ * handshake protocal with controller firmware.
+ * It will send a sas iounit controll request (MPI2_SAS_OP_REMOVE_DEVICE)
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_tm_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+    u32 reply)
+{
+	unsigned long flags;
+	u16 handle;
+	struct _sas_device *sas_device;
+	Mpi2SCSITaskManagementReply_t *mpi_reply =
+	    mpt2sas_base_get_reply_virt_addr(ioc, reply);
+	Mpi2SasIoUnitControlRequest_t *mpi_request;
+	u16 smid_sas_ctrl;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
+	struct _tr_list *delayed_tr;
+	u8 rc;
+
+	handle = le16_to_cpu(mpi_reply->DevHandle);
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		printk(MPT2SAS_ERR_FMT "%s: failed finding sas_device\n",
+		    ioc->name, __func__);
+		return 1;
+	}
+	sas_device->state |= MPTSAS_STATE_TR_COMPLETE;
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (sas_device->starget)
+		dewtprintk(ioc, starget_printk(KERN_INFO, sas_device->starget,
+		    "tr_complete:handle(0x%04x), (%s) ioc_status(0x%04x), "
+		    "loginfo(0x%08x), completed(%d)\n",
+		    sas_device->handle, (sas_device->state &
+		    MPT2SAS_REQ_SAS_CNTRL) ? "open" : "active",
+		    le16_to_cpu(mpi_reply->IOCStatus),
+		    le32_to_cpu(mpi_reply->IOCLogInfo),
+		    le32_to_cpu(mpi_reply->TerminationCount)));
+
+	if (sas_device->starget && sas_device->starget->hostdata) {
+		sas_target_priv_data = sas_device->starget->hostdata;
+		sas_target_priv_data->tm_busy = 0;
+	}
+
+	if (!list_empty(&ioc->delayed_tr_list)) {
+		delayed_tr = list_entry(ioc->delayed_tr_list.next,
+		    struct _tr_list, list);
+		mpt2sas_base_free_smid(ioc, smid);
+		if (delayed_tr->state & MPT2SAS_REQ_SAS_CNTRL)
+			_scsih_tm_tr_send(ioc, delayed_tr->handle);
+		list_del(&delayed_tr->list);
+		kfree(delayed_tr);
+		rc = 0; /* tells base_interrupt not to free mf */
+	} else
+		rc = 1;
+
+
+	if (!(sas_device->state & MPT2SAS_REQ_SAS_CNTRL))
+		return rc;
+
+	if (ioc->shost_recovery) {
+		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
+		    __func__, ioc->name);
+		return rc;
+	}
+
+	smid_sas_ctrl = mpt2sas_base_get_smid(ioc, ioc->tm_sas_control_cb_idx);
+	if (!smid_sas_ctrl) {
+		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
+		    ioc->name, __func__);
+		return rc;
+	}
+
+	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid_sas_ctrl);
+	memset(mpi_request, 0, sizeof(Mpi2SasIoUnitControlRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
+	mpi_request->Operation = MPI2_SAS_OP_REMOVE_DEVICE;
+	mpi_request->DevHandle = mpi_reply->DevHandle;
+	sas_device->state |= MPTSAS_STATE_CNTRL_SEND;
+	mpt2sas_base_put_smid_default(ioc, smid_sas_ctrl);
+	return rc;
+}
+
+/**
  * _scsih_check_topo_delete_events - sanity check on topo events
  * @ioc: per adapter object
  * @event_data: the event data payload
@@ -2375,6 +2563,21 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 	u16 expander_handle;
 	struct _sas_node *sas_expander;
 	unsigned long flags;
+	int i, reason_code;
+	u16 handle;
+
+	for (i = 0 ; i < event_data->NumEntries; i++) {
+		if (event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
+			continue;
+		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		reason_code = event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_RC_MASK;
+		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING)
+			_scsih_tm_tr_send(ioc, handle);
+	}
 
 	expander_handle = le16_to_cpu(event_data->ExpanderDevHandle);
 	if (expander_handle < ioc->sas_hba.num_phys) {
@@ -2433,8 +2636,8 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
 	u16 smid;
 	u16 count = 0;
 
-	for (smid = 1; smid <= ioc->request_depth; smid++) {
-		scmd = _scsih_scsi_lookup_getclear(ioc, smid);
+	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
+		scmd = _scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
 		count++;
@@ -2616,7 +2819,7 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON))
 		mpi_control |= MPI2_SCSIIO_CONTROL_TLR_ON;
 
-	smid = mpt2sas_base_get_smid(ioc, ioc->scsi_io_cb_idx);
+	smid = mpt2sas_base_get_smid_scsiio(ioc, ioc->scsi_io_cb_idx, scmd);
 	if (!smid) {
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
@@ -2643,7 +2846,8 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	mpi_request->SGLOffset0 = offsetof(Mpi2SCSIIORequest_t, SGL) / 4;
 	mpi_request->SGLFlags = cpu_to_le16(MPI2_SCSIIO_SGLFLAGS_TYPE_MPI +
 	    MPI2_SCSIIO_SGLFLAGS_SYSTEM_ADDR);
-
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 	int_to_scsilun(sas_device_priv_data->lun, (struct scsi_lun *)
 	    mpi_request->LUN);
 	memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
@@ -2657,8 +2861,7 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		}
 	}
 
-	_scsih_scsi_lookup_set(ioc, smid, scmd);
-	mpt2sas_base_put_smid_scsi_io(ioc, smid, 0,
+	mpt2sas_base_put_smid_scsi_io(ioc, smid,
 	    sas_device_priv_data->sas_target->handle);
 	return 0;
 
@@ -2954,15 +3157,16 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
  * _scsih_io_done - scsi request callback
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
- * Callback handler when using scsih_qcmd.
+ * Callback handler when using _scsih_qcmd.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-static void
-_scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+static u8
+_scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 {
 	Mpi2SCSIIORequest_t *mpi_request;
 	Mpi2SCSIIOReply_t *mpi_reply;
@@ -2976,9 +3180,9 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 	u32 response_code;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
-	scmd = _scsih_scsi_lookup_getclear(ioc, smid);
+	scmd = _scsih_scsi_lookup_get(ioc, smid);
 	if (scmd == NULL)
-		return;
+		return 1;
 
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 
@@ -3134,6 +3338,7 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
  out:
 	scsi_dma_unmap(scmd);
 	scmd->scsi_done(scmd);
+	return 1;
 }
 
 /**
@@ -3398,9 +3603,8 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		}
 	}
 
-	sas_address = le64_to_cpu(expander_pg0.SASAddress);
-
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
+	sas_address = le64_to_cpu(expander_pg0.SASAddress);
 	sas_expander = mpt2sas_scsih_expander_find_by_sas_address(ioc,
 	    sas_address);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
@@ -3666,6 +3870,12 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	if (ioc->remove_host)
 		goto out;
 
+	if ((sas_device->state & MPTSAS_STATE_TR_COMPLETE)) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "\tskip "
+		   "target_reset handle(0x%04x)\n", ioc->name, handle));
+		goto skip_tr;
+	}
+
 	/* Target Reset to flush out all the outstanding IO */
 	device_handle = (sas_device->hidden_raid_component) ?
 	    sas_device->volume_handle : handle;
@@ -3682,6 +3892,13 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		if (ioc->shost_recovery)
 			goto out;
 	}
+ skip_tr:
+
+	if ((sas_device->state & MPTSAS_STATE_CNTRL_COMPLETE)) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "\tskip "
+		   "sas_cntrl handle(0x%04x)\n", ioc->name, handle));
+		goto out;
+	}
 
 	/* SAS_IO_UNIT_CNTR - send REMOVE_DEVICE */
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "sas_iounit: handle"
@@ -3690,7 +3907,8 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	mpi_request.Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
 	mpi_request.Operation = MPI2_SAS_OP_REMOVE_DEVICE;
 	mpi_request.DevHandle = handle;
-	mpi_request.VF_ID = 0;
+	mpi_request.VF_ID = 0; /* TODO */
+	mpi_request.VP_ID = 0;
 	if ((mpt2sas_base_sas_iounit_control(ioc, &mpi_reply,
 	    &mpi_request)) != 0) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
@@ -3800,15 +4018,12 @@ _scsih_sas_topology_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_topology_change_event - handle topology changes
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
- * fw_event:
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  */
 static void
-_scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataSasTopologyChangeList_t *event_data,
+_scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
     struct fw_event_work *fw_event)
 {
 	int i;
@@ -3818,6 +4033,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	struct _sas_node *sas_expander;
 	unsigned long flags;
 	u8 link_rate_;
+	Mpi2EventDataSasTopologyChangeList_t *event_data = fw_event->event_data;
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
@@ -3851,15 +4067,16 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 		}
 		if (ioc->shost_recovery)
 			return;
-		if (event_data->PHY[i].PhyStatus &
-		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
+		phy_number = event_data->StartPhyNum + i;
+		reason_code = event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_RC_MASK;
+		if ((event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT) && (reason_code !=
+		    MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING))
 			continue;
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
 		if (!handle)
 			continue;
-		phy_number = event_data->StartPhyNum + i;
-		reason_code = event_data->PHY[i].PhyStatus &
-		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		link_rate_ = event_data->PHY[i].LinkRate >> 4;
 		switch (reason_code) {
 		case MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED:
@@ -3971,19 +4188,19 @@ _scsih_sas_device_status_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_device_status_change_event - handle device status change
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataSasDeviceStatusChange_t *event_data)
+_scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
-		_scsih_sas_device_status_change_event_debug(ioc, event_data);
+		_scsih_sas_device_status_change_event_debug(ioc,
+		     fw_event->event_data);
 #endif
 }
 
@@ -4026,34 +4243,33 @@ _scsih_sas_enclosure_dev_status_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_enclosure_dev_status_change_event - handle enclosure events
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
 _scsih_sas_enclosure_dev_status_change_event(struct MPT2SAS_ADAPTER *ioc,
-    u8 VF_ID, Mpi2EventDataSasEnclDevStatusChange_t *event_data)
+    struct fw_event_work *fw_event)
 {
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_enclosure_dev_status_change_event_debug(ioc,
-		     event_data);
+		     fw_event->event_data);
 #endif
 }
 
 /**
  * _scsih_sas_broadcast_primative_event - handle broadcast events
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataSasBroadcastPrimitive_t *event_data)
+_scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 	struct scsi_cmnd *scmd;
 	u16 smid, handle;
@@ -4062,11 +4278,12 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-
+#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
+	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
+#endif
 	dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "broadcast primative: "
 	    "phy number(%d), width(%d)\n", ioc->name, event_data->PhyNum,
 	    event_data->PortWidth));
-
 	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
@@ -4074,7 +4291,7 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	termination_count = 0;
 	query_count = 0;
 	mpi_reply = ioc->tm_cmds.reply;
-	for (smid = 1; smid <= ioc->request_depth; smid++) {
+	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
 		scmd = _scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
@@ -4121,23 +4338,25 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 /**
  * _scsih_sas_discovery_event - handle discovery events
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_discovery_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataSasDiscovery_t *event_data)
+_scsih_sas_discovery_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
+	Mpi2EventDataSasDiscovery_t *event_data = fw_event->event_data;
+
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
 		printk(MPT2SAS_DEBUG_FMT "discovery event: (%s)", ioc->name,
 		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
 		    "start" : "stop");
 	if (event_data->DiscoveryStatus)
-		printk(MPT2SAS_DEBUG_FMT ", discovery_status(0x%08x)",
-		    ioc->name, le32_to_cpu(event_data->DiscoveryStatus));
+		printk("discovery_status(0x%08x)",
+		    le32_to_cpu(event_data->DiscoveryStatus));
 	printk("\n");
 	}
 #endif
@@ -4488,19 +4707,19 @@ _scsih_sas_ir_config_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_ir_config_change_event - handle ir configuration change events
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataIrConfigChangeList_t *event_data)
+_scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 	Mpi2EventIrConfigElement_t *element;
 	int i;
 	u8 foreign_config;
+	Mpi2EventDataIrConfigChangeList_t *event_data = fw_event->event_data;
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
@@ -4543,14 +4762,14 @@ _scsih_sas_ir_config_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 /**
  * _scsih_sas_ir_volume_event - IR volume event
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataIrVolume_t *event_data)
+_scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 	u64 wwid;
 	unsigned long flags;
@@ -4559,6 +4778,7 @@ _scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	u32 state;
 	int rc;
 	struct MPT2SAS_TARGET *sas_target_priv_data;
+	Mpi2EventDataIrVolume_t *event_data = fw_event->event_data;
 
 	if (event_data->ReasonCode != MPI2_EVENT_IR_VOLUME_RC_STATE_CHANGED)
 		return;
@@ -4628,14 +4848,14 @@ _scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 /**
  * _scsih_sas_ir_physical_disk_event - PD event
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-   Mpi2EventDataIrPhysicalDisk_t *event_data)
+_scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 	u16 handle;
 	u32 state;
@@ -4644,6 +4864,7 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasDevicePage0_t sas_device_pg0;
 	u32 ioc_status;
+	Mpi2EventDataIrPhysicalDisk_t *event_data = fw_event->event_data;
 
 	if (event_data->ReasonCode != MPI2_EVENT_IR_PHYSDISK_RC_STATE_CHANGED)
 		return;
@@ -4743,33 +4964,33 @@ _scsih_sas_ir_operation_status_event_debug(struct MPT2SAS_ADAPTER *ioc,
 /**
  * _scsih_sas_ir_operation_status_event - handle RAID operation events
  * @ioc: per adapter object
- * @VF_ID:
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Return nothing.
  */
 static void
-_scsih_sas_ir_operation_status_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataIrOperationStatus_t *event_data)
+_scsih_sas_ir_operation_status_event(struct MPT2SAS_ADAPTER *ioc,
+    struct fw_event_work *fw_event)
 {
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
-		_scsih_sas_ir_operation_status_event_debug(ioc, event_data);
+		_scsih_sas_ir_operation_status_event_debug(ioc,
+		     fw_event->event_data);
 #endif
 }
 
 /**
  * _scsih_task_set_full - handle task set full
  * @ioc: per adapter object
- * @event_data: event data payload
+ * @fw_event: The fw_event_work object
  * Context: user.
  *
  * Throttle back qdepth.
  */
 static void
-_scsih_task_set_full(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
-    Mpi2EventDataTaskSetFull_t *event_data)
+_scsih_task_set_full(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
+	*fw_event)
 {
 	unsigned long flags;
 	struct _sas_device *sas_device;
@@ -4780,6 +5001,7 @@ _scsih_task_set_full(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 	u16 handle;
 	int id, channel;
 	u64 sas_address;
+	Mpi2EventDataTaskSetFull_t *event_data = fw_event->event_data;
 
 	current_depth = le16_to_cpu(event_data->CurrentDepth);
 	handle = le16_to_cpu(event_data->DevHandle);
@@ -4868,6 +5090,10 @@ _scsih_mark_responding_sas_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 		if (sas_device->sas_address == sas_address &&
 		    sas_device->slot == slot && sas_device->starget) {
 			sas_device->responding = 1;
+			sas_device->state = 0;
+			starget = sas_device->starget;
+			sas_target_priv_data = starget->hostdata;
+			sas_target_priv_data->tm_busy = 0;
 			starget_printk(KERN_INFO, sas_device->starget,
 			    "handle(0x%04x), sas_addr(0x%016llx), enclosure "
 			    "logical id(0x%016llx), slot(%d)\n", handle,
@@ -4880,8 +5106,6 @@ _scsih_mark_responding_sas_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 			printk(KERN_INFO "\thandle changed from(0x%04x)!!!\n",
 			    sas_device->handle);
 			sas_device->handle = handle;
-			starget = sas_device->starget;
-			sas_target_priv_data = starget->hostdata;
 			sas_target_priv_data->handle = handle;
 			goto out;
 		}
@@ -5227,44 +5451,38 @@ _firmware_event_work(struct work_struct *work)
 
 	switch (fw_event->event) {
 	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
-		_scsih_sas_topology_change_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data, fw_event);
+		_scsih_sas_topology_change_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
-		_scsih_sas_device_status_change_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_device_status_change_event(ioc,
+		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_DISCOVERY:
-		_scsih_sas_discovery_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_discovery_event(ioc,
+		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
-		_scsih_sas_broadcast_primative_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_broadcast_primative_event(ioc,
+		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
 		_scsih_sas_enclosure_dev_status_change_event(ioc,
-		    fw_event->VF_ID, fw_event->event_data);
+		    fw_event);
 		break;
 	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
-		_scsih_sas_ir_config_change_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_ir_config_change_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_IR_VOLUME:
-		_scsih_sas_ir_volume_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_ir_volume_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_IR_PHYSICAL_DISK:
-		_scsih_sas_ir_physical_disk_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_ir_physical_disk_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_IR_OPERATION_STATUS:
-		_scsih_sas_ir_operation_status_event(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_sas_ir_operation_status_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_TASK_SET_FULL:
-		_scsih_task_set_full(ioc, fw_event->VF_ID,
-		    fw_event->event_data);
+		_scsih_task_set_full(ioc, fw_event);
 		break;
 	}
 	_scsih_fw_event_free(ioc, fw_event);
@@ -5273,17 +5491,19 @@ _firmware_event_work(struct work_struct *work)
 /**
  * mpt2sas_scsih_event_callback - firmware event handler (called at ISR time)
  * @ioc: per adapter object
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  * Context: interrupt.
  *
  * This function merely adds a new work task into ioc->firmware_event_thread.
  * The tasks are worked from _firmware_event_work in user context.
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
-mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
+u8
+mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
+	u32 reply)
 {
 	struct fw_event_work *fw_event;
 	Mpi2EventNotificationReply_t *mpi_reply;
@@ -5294,11 +5514,11 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	if (ioc->fw_events_off || ioc->remove_host) {
 		spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
-		return;
+		return 1;
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
-	mpi_reply =  mpt2sas_base_get_reply_virt_addr(ioc, reply);
+	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	event = le16_to_cpu(mpi_reply->Event);
 
 	switch (event) {
@@ -5312,7 +5532,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
 		if (baen_data->Primitive !=
 		    MPI2_EVENT_PRIMITIVE_ASYNCHRONOUS_EVENT ||
 		    ioc->broadcast_aen_busy)
-			return;
+			return 1;
 		ioc->broadcast_aen_busy = 1;
 		break;
 	}
@@ -5334,14 +5554,14 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
 		break;
 
 	default: /* ignore the rest */
-		return;
+		return 1;
 	}
 
 	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
 	if (!fw_event) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
-		return;
+		return 1;
 	}
 	fw_event->event_data =
 	    kzalloc(mpi_reply->EventDataLength*4, GFP_ATOMIC);
@@ -5349,15 +5569,17 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
 		kfree(fw_event);
-		return;
+		return 1;
 	}
 
 	memcpy(fw_event->event_data, mpi_reply->EventData,
 	    mpi_reply->EventDataLength*4);
 	fw_event->ioc = ioc;
-	fw_event->VF_ID = VF_ID;
+	fw_event->VF_ID = mpi_reply->VF_ID;
+	fw_event->VP_ID = mpi_reply->VP_ID;
 	fw_event->event = event;
 	_scsih_fw_event_add(ioc, fw_event);
+	return 1;
 }
 
 /* shost template */
@@ -5617,7 +5839,7 @@ _scsih_probe_raid(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * _scsih_probe_sas - reporting raid volumes to sas transport
+ * _scsih_probe_sas - reporting sas devices to sas transport
  * @ioc: per adapter object
  *
  * Called during initial loading of the driver.
@@ -5714,6 +5936,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->base_cb_idx = base_cb_idx;
 	ioc->transport_cb_idx = transport_cb_idx;
 	ioc->config_cb_idx = config_cb_idx;
+	ioc->tm_tr_cb_idx = tm_tr_cb_idx;
+	ioc->tm_sas_control_cb_idx = tm_sas_control_cb_idx;
 	ioc->logging_level = logging_level;
 	/* misc semaphores and spin locks */
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
@@ -5729,6 +5953,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->fw_event_list);
 	INIT_LIST_HEAD(&ioc->raid_device_list);
 	INIT_LIST_HEAD(&ioc->sas_hba.sas_port_list);
+	INIT_LIST_HEAD(&ioc->delayed_tr_list);
 
 	/* init shost parameters */
 	shost->max_cmd_len = 16;
@@ -5745,6 +5970,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
 	    | SHOST_DIF_TYPE3_PROTECTION);
+	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
 
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
@@ -5894,6 +6120,11 @@ _scsih_init(void)
 	/* ctl module callback handler */
 	ctl_cb_idx = mpt2sas_base_register_callback_handler(mpt2sas_ctl_done);
 
+	tm_tr_cb_idx = mpt2sas_base_register_callback_handler(
+	    _scsih_tm_tr_complete);
+	tm_sas_control_cb_idx = mpt2sas_base_register_callback_handler(
+	    _scsih_sas_control_complete);
+
 	mpt2sas_ctl_init();
 
 	error = pci_register_driver(&scsih_driver);
@@ -5924,6 +6155,9 @@ _scsih_exit(void)
 	mpt2sas_base_release_callback_handler(config_cb_idx);
 	mpt2sas_base_release_callback_handler(ctl_cb_idx);
 
+	mpt2sas_base_release_callback_handler(tm_tr_cb_idx);
+	mpt2sas_base_release_callback_handler(tm_sas_control_cb_idx);
+
 	mpt2sas_ctl_exit();
 }
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 742324a..eb98188 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -2,7 +2,7 @@
  * SAS Transport Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_transport.c
- * Copyright (C) 2007-2008  LSI Corporation
+ * Copyright (C) 2007-2009  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -212,25 +212,26 @@ _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
  * mpt2sas_transport_done -  internal transport layer callback handler.
  * @ioc: per adapter object
  * @smid: system request message index
- * @VF_ID: virtual function id
+ * @msix_index: MSIX table index supplied by the OS
  * @reply: reply message frame(lower 32bit addr)
  *
  * Callback handler when sending internal generated transport cmds.
  * The callback index passed is `ioc->transport_cb_idx`
  *
- * Return nothing.
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
  */
-void
-mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
+u8
+mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
     u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
 	mpi_reply =  mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	if (ioc->transport_cmds.status == MPT2_CMD_NOT_USED)
-		return;
+		return 1;
 	if (ioc->transport_cmds.smid != smid)
-		return;
+		return 1;
 	ioc->transport_cmds.status |= MPT2_CMD_COMPLETE;
 	if (mpi_reply) {
 		memcpy(ioc->transport_cmds.reply, mpi_reply,
@@ -239,6 +240,7 @@ mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID,
 	}
 	ioc->transport_cmds.status &= ~MPT2_CMD_PENDING;
 	complete(&ioc->transport_cmds.done);
+	return 1;
 }
 
 /* report manufacture request structure */
@@ -369,6 +371,8 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	memset(mpi_request, 0, sizeof(Mpi2SmpPassthroughRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SMP_PASSTHROUGH;
 	mpi_request->PhysicalPort = 0xFF;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 	sas_address_le = (u64 *)&mpi_request->SASAddress;
 	*sas_address_le = cpu_to_le64(sas_address);
 	mpi_request->RequestDataLength = sizeof(struct rep_manu_request);
@@ -396,7 +400,8 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT "report_manufacture - "
 	    "send to sas_addr(0x%016llx)\n", ioc->name,
 	    (unsigned long long)sas_address));
-	mpt2sas_base_put_smid_default(ioc, smid, 0 /* VF_ID */);
+	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->transport_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
@@ -1106,6 +1111,8 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	memset(mpi_request, 0, sizeof(Mpi2SmpPassthroughRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SMP_PASSTHROUGH;
 	mpi_request->PhysicalPort = 0xFF;
+	mpi_request->VF_ID = 0; /* TODO */
+	mpi_request->VP_ID = 0;
 	*((u64 *)&mpi_request->SASAddress) = (rphy) ?
 	    cpu_to_le64(rphy->identify.sas_address) :
 	    cpu_to_le64(ioc->sas_hba.sas_address);
@@ -1147,7 +1154,8 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s - "
 	    "sending smp request\n", ioc->name, __func__));
 
-	mpt2sas_base_put_smid_default(ioc, smid, 0 /* VF_ID */);
+	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->transport_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index f8cb9de..1849da1 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -25,6 +25,8 @@
 #ifndef _MV_DEFS_H_
 #define _MV_DEFS_H_
 
+#define PCI_DEVICE_ID_ARECA_1300	0x1300
+#define PCI_DEVICE_ID_ARECA_1320	0x1320
 
 enum chip_flavors {
 	chip_6320,
@@ -32,6 +34,8 @@ enum chip_flavors {
 	chip_6485,
 	chip_9480,
 	chip_9180,
+	chip_1300,
+	chip_1320
 };
 
 /* driver compile-time configuration */
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 8646a19..c790d45 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -32,6 +32,8 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_6485] =	{ 1, 8, 0x800, 33, 32, 10, &mvs_64xx_dispatch, },
 	[chip_9180] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 	[chip_9480] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
+	[chip_1300] =	{ 1, 4, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
+	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 };
 
 #define SOC_SAS_NUM 2
@@ -653,6 +655,8 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 	{ PCI_VDEVICE(MARVELL, 0x6485), chip_6485 },
 	{ PCI_VDEVICE(MARVELL, 0x9480), chip_9480 },
 	{ PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
+	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
+	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 
 	{ }	/* terminate list */
 };
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 4302f06..f7c70e2 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -46,6 +46,7 @@
 #include <linux/mutex.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_cmnd.h>
@@ -684,7 +685,7 @@ static void pmcraid_timeout_handler(struct pmcraid_cmd *cmd)
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	unsigned long lock_flags;
 
-	dev_err(&pinstance->pdev->dev,
+	dev_info(&pinstance->pdev->dev,
 		"Adapter being reset due to command timeout.\n");
 
 	/* Command timeouts result in hard reset sequence. The command that got
@@ -815,8 +816,9 @@ static void pmcraid_erp_done(struct pmcraid_cmd *cmd)
 
 	if (PMCRAID_IOASC_SENSE_KEY(ioasc) > 0) {
 		scsi_cmd->result |= (DID_ERROR << 16);
-		pmcraid_err("command CDB[0] = %x failed with IOASC: 0x%08X\n",
-			     cmd->ioa_cb->ioarcb.cdb[0], ioasc);
+		scmd_printk(KERN_INFO, scsi_cmd,
+			    "command CDB[0] = %x failed with IOASC: 0x%08X\n",
+			    cmd->ioa_cb->ioarcb.cdb[0], ioasc);
 	}
 
 	/* if we had allocated sense buffers for request sense, copy the sense
@@ -1541,13 +1543,13 @@ static void pmcraid_handle_error_log(struct pmcraid_instance *pinstance)
 
 	if (pinstance->ldn.hcam->notification_lost ==
 	    HOSTRCB_NOTIFICATIONS_LOST)
-		dev_err(&pinstance->pdev->dev, "Error notifications lost\n");
+		dev_info(&pinstance->pdev->dev, "Error notifications lost\n");
 
 	ioasc = le32_to_cpu(hcam_ldn->error_log.fd_ioasc);
 
 	if (ioasc == PMCRAID_IOASC_UA_BUS_WAS_RESET ||
 		ioasc == PMCRAID_IOASC_UA_BUS_WAS_RESET_BY_OTHER) {
-		dev_err(&pinstance->pdev->dev,
+		dev_info(&pinstance->pdev->dev,
 			"UnitAttention due to IOA Bus Reset\n");
 		scsi_report_bus_reset(
 			pinstance->host,
@@ -1584,7 +1586,7 @@ static void pmcraid_process_ccn(struct pmcraid_cmd *cmd)
 	    atomic_read(&pinstance->ccn.ignore) == 1) {
 		return;
 	} else if (ioasc) {
-		dev_err(&pinstance->pdev->dev,
+		dev_info(&pinstance->pdev->dev,
 			"Host RCB (CCN) failed with IOASC: 0x%08X\n", ioasc);
 		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
 		pmcraid_send_hcam(pinstance, PMCRAID_HCAM_CODE_CONFIG_CHANGE);
@@ -1634,7 +1636,7 @@ static void pmcraid_process_ldn(struct pmcraid_cmd *cmd)
 			return;
 		}
 	} else {
-		dev_err(&pinstance->pdev->dev,
+		dev_info(&pinstance->pdev->dev,
 			"Host RCB(LDN) failed with IOASC: 0x%08X\n", ioasc);
 	}
 	/* send netlink message for HCAM notification if enabled */
@@ -1822,7 +1824,6 @@ static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
 			scsi_dma_unmap(scsi_cmd);
 			pmcraid_return_cmd(cmd);
 
-
 			pmcraid_info("failing(%d) CDB[0] = %x result: %x\n",
 				     le32_to_cpu(resp) >> 2,
 				     cmd->ioa_cb->ioarcb.cdb[0],
@@ -2514,7 +2515,8 @@ static int pmcraid_reset_device(
 	res = scsi_cmd->device->hostdata;
 
 	if (!res) {
-		pmcraid_err("reset_device: NULL resource pointer\n");
+		sdev_printk(KERN_ERR, scsi_cmd->device,
+			    "reset_device: NULL resource pointer\n");
 		return FAILED;
 	}
 
@@ -2752,8 +2754,8 @@ static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
 	pinstance =
 		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
 
-	dev_err(&pinstance->pdev->dev,
-		"I/O command timed out, aborting it.\n");
+	scmd_printk(KERN_INFO, scsi_cmd,
+		    "I/O command timed out, aborting it.\n");
 
 	res = scsi_cmd->device->hostdata;
 
@@ -2824,7 +2826,8 @@ static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
  */
 static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
 {
-	pmcraid_err("Doing device reset due to an I/O command timeout.\n");
+	scmd_printk(KERN_INFO, scmd,
+		    "resetting device due to an I/O command timeout.\n");
 	return pmcraid_reset_device(scmd,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_LUN);
@@ -2832,7 +2835,8 @@ static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
 
 static int pmcraid_eh_bus_reset_handler(struct scsi_cmnd *scmd)
 {
-	pmcraid_err("Doing bus reset due to an I/O command timeout.\n");
+	scmd_printk(KERN_INFO, scmd,
+		    "Doing bus reset due to an I/O command timeout.\n");
 	return pmcraid_reset_device(scmd,
 				    PMCRAID_RESET_BUS_TIMEOUT,
 				    RESET_DEVICE_BUS);
@@ -2840,7 +2844,8 @@ static int pmcraid_eh_bus_reset_handler(struct scsi_cmnd *scmd)
 
 static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
 {
-	pmcraid_err("Doing target reset due to an I/O command timeout.\n");
+	scmd_printk(KERN_INFO, scmd,
+		    "Doing target reset due to an I/O command timeout.\n");
 	return pmcraid_reset_device(scmd,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_TARGET);
@@ -2988,11 +2993,11 @@ static int pmcraid_build_ioadl(
 	nseg = scsi_dma_map(scsi_cmd);
 
 	if (nseg < 0) {
-		dev_err(&pinstance->pdev->dev, "scsi_map_dma failed!\n");
+		scmd_printk(KERN_ERR, scsi_cmd, "scsi_map_dma failed!\n");
 		return -1;
 	} else if (nseg > PMCRAID_MAX_IOADLS) {
 		scsi_dma_unmap(scsi_cmd);
-		dev_err(&pinstance->pdev->dev,
+		scmd_printk(KERN_ERR, scsi_cmd,
 			"sg count is (%d) more than allowed!\n", nseg);
 		return -1;
 	}
@@ -5040,7 +5045,7 @@ static int pmcraid_resume(struct pci_dev *pdev)
 	rc = pci_enable_device(pdev);
 
 	if (rc) {
-		pmcraid_err("pmcraid: Enable device failed\n");
+		dev_err(&pdev->dev, "resume: Enable device failed\n");
 		return rc;
 	}
 
@@ -5054,7 +5059,7 @@ static int pmcraid_resume(struct pci_dev *pdev)
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 
 	if (rc != 0) {
-		dev_err(&pdev->dev, "Failed to set PCI DMA mask\n");
+		dev_err(&pdev->dev, "resume: Failed to set PCI DMA mask\n");
 		goto disable_device;
 	}
 
@@ -5063,7 +5068,8 @@ static int pmcraid_resume(struct pci_dev *pdev)
 	rc = pmcraid_register_interrupt_handler(pinstance);
 
 	if (rc) {
-		pmcraid_err("resume: couldn't register interrupt handlers\n");
+		dev_err(&pdev->dev,
+			"resume: couldn't register interrupt handlers\n");
 		rc = -ENODEV;
 		goto release_host;
 	}
@@ -5080,7 +5086,7 @@ static int pmcraid_resume(struct pci_dev *pdev)
 	 * state.
 	 */
 	if (pmcraid_reset_bringup(pinstance)) {
-		pmcraid_err("couldn't initialize IOA \n");
+		dev_err(&pdev->dev, "couldn't initialize IOA \n");
 		rc = -ENODEV;
 		goto release_tasklets;
 	}
@@ -5187,7 +5193,7 @@ static void pmcraid_init_res_table(struct pmcraid_cmd *cmd)
 	LIST_HEAD(old_res);
 
 	if (pinstance->cfg_table->flags & MICROCODE_UPDATE_REQUIRED)
-		dev_err(&pinstance->pdev->dev, "Require microcode download\n");
+		pmcraid_err("IOA requires microcode download\n");
 
 	/* resource list is protected by pinstance->resource_lock.
 	 * init_res_table can be called from probe (user-thread) or runtime
@@ -5224,8 +5230,7 @@ static void pmcraid_init_res_table(struct pmcraid_cmd *cmd)
 		if (!found) {
 
 			if (list_empty(&pinstance->free_res_q)) {
-				dev_err(&pinstance->pdev->dev,
-					"Too many devices attached\n");
+				pmcraid_err("Too many devices attached\n");
 				break;
 			}
 
@@ -5442,7 +5447,7 @@ static int __devinit pmcraid_probe(
 	rc = pmcraid_register_interrupt_handler(pinstance);
 
 	if (rc) {
-		pmcraid_err("couldn't register interrupt handler\n");
+		dev_err(&pdev->dev, "couldn't register interrupt handler\n");
 		goto out_scsi_host_put;
 	}
 
@@ -5466,7 +5471,7 @@ static int __devinit pmcraid_probe(
 	 */
 	pmcraid_info("starting IOA initialization sequence\n");
 	if (pmcraid_reset_bringup(pinstance)) {
-		pmcraid_err("couldn't initialize IOA \n");
+		dev_err(&pdev->dev, "couldn't initialize IOA \n");
 		rc = 1;
 		goto out_release_bufs;
 	}
@@ -5534,7 +5539,6 @@ static struct pci_driver pmcraid_driver = {
 	.shutdown = pmcraid_shutdown
 };
 
-
 /**
  * pmcraid_init - module load entry point
  */
@@ -5566,7 +5570,6 @@ static int __init pmcraid_init(void)
 		goto out_unreg_chrdev;
 	}
 
-
 	error = pmcraid_netlink_init();
 
 	if (error)
@@ -5584,6 +5587,7 @@ static int __init pmcraid_init(void)
 
 out_unreg_chrdev:
 	unregister_chrdev_region(MKDEV(pmcraid_major, 0), PMCRAID_MAX_ADAPTERS);
+
 out_init:
 	return error;
 }
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 42b799a..e07b361 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -568,7 +568,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	if (req == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory"
 			"for request que\n");
-		goto que_failed;
+		goto failed;
 	}
 
 	req->length = REQUEST_ENTRY_CNT_24XX;
@@ -632,6 +632,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 
 que_failed:
 	qla25xx_free_req_que(base_vha, req);
+failed:
 	return 0;
 }
 
@@ -659,7 +660,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (rsp == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory for"
 				" response que\n");
-		goto que_failed;
+		goto failed;
 	}
 
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
@@ -728,6 +729,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 
 que_failed:
 	qla25xx_free_rsp_que(base_vha, rsp);
+failed:
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b6e0307..dd098ca 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -241,10 +241,7 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
  */
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
-	struct scsi_cmnd *cmd;
-	unsigned char *buf;
-
-	cmd = scsi_host_alloc_command(shost, gfp_mask);
+	struct scsi_cmnd *cmd = scsi_host_alloc_command(shost, gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -258,9 +255,15 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
 		if (cmd) {
+			void *buf, *prot;
+
 			buf = cmd->sense_buffer;
+			prot = cmd->prot_sdb;
+
 			memset(cmd, 0, sizeof(*cmd));
+
 			cmd->sense_buffer = buf;
+			cmd->prot_sdb = prot;
 		}
 	}
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index fb9af20..c4103be 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -50,6 +50,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_dbg.h>
 
 #include "sd.h"
 #include "scsi_logging.h"
@@ -64,6 +65,7 @@ static const char * scsi_debug_version_date = "20070104";
 #define PARAMETER_LIST_LENGTH_ERR 0x1a
 #define INVALID_OPCODE 0x20
 #define ADDR_OUT_OF_RANGE 0x21
+#define INVALID_COMMAND_OPCODE 0x20
 #define INVALID_FIELD_IN_CDB 0x24
 #define INVALID_FIELD_IN_PARAM_LIST 0x26
 #define POWERON_RESET 0x29
@@ -180,7 +182,7 @@ static int sdebug_sectors_per;		/* sectors per cylinder */
 #define SDEBUG_SENSE_LEN 32
 
 #define SCSI_DEBUG_CANQUEUE  255
-#define SCSI_DEBUG_MAX_CMD_LEN 16
+#define SCSI_DEBUG_MAX_CMD_LEN 32
 
 struct sdebug_dev_info {
 	struct list_head dev_list;
@@ -296,9 +298,25 @@ static void mk_sense_buffer(struct sdebug_dev_info *devip, int key,
 }
 
 static void get_data_transfer_info(unsigned char *cmd,
-				   unsigned long long *lba, unsigned int *num)
+				   unsigned long long *lba, unsigned int *num,
+				   u32 *ei_lba)
 {
+	*ei_lba = 0;
+
 	switch (*cmd) {
+	case VARIABLE_LENGTH_CMD:
+		*lba = (u64)cmd[19] | (u64)cmd[18] << 8 |
+			(u64)cmd[17] << 16 | (u64)cmd[16] << 24 |
+			(u64)cmd[15] << 32 | (u64)cmd[14] << 40 |
+			(u64)cmd[13] << 48 | (u64)cmd[12] << 56;
+
+		*ei_lba = (u32)cmd[23] | (u32)cmd[22] << 8 |
+			(u32)cmd[21] << 16 | (u32)cmd[20] << 24;
+
+		*num = (u32)cmd[31] | (u32)cmd[30] << 8 | (u32)cmd[29] << 16 |
+			(u32)cmd[28] << 24;
+		break;
+
 	case WRITE_16:
 	case READ_16:
 		*lba = (u64)cmd[9] | (u64)cmd[8] << 8 |
@@ -1589,7 +1607,7 @@ static int do_device_access(struct scsi_cmnd *scmd,
 }
 
 static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
-			    unsigned int sectors)
+			    unsigned int sectors, u32 ei_lba)
 {
 	unsigned int i, resid;
 	struct scatterlist *psgl;
@@ -1636,13 +1654,23 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			return 0x01;
 		}
 
-		if (scsi_debug_dif != SD_DIF_TYPE3_PROTECTION &&
+		if (scsi_debug_dif == SD_DIF_TYPE1_PROTECTION &&
 		    be32_to_cpu(sdt[i].ref_tag) != (sector & 0xffffffff)) {
 			printk(KERN_ERR "%s: REF check failed on sector %lu\n",
 			       __func__, (unsigned long)sector);
 			dif_errors++;
 			return 0x03;
 		}
+
+		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+		    be32_to_cpu(sdt[i].ref_tag) != ei_lba) {
+			printk(KERN_ERR "%s: REF check failed on sector %lu\n",
+			       __func__, (unsigned long)sector);
+			dif_errors++;
+			return 0x03;
+		}
+
+		ei_lba++;
 	}
 
 	resid = sectors * 8; /* Bytes of protection data to copy into sgl */
@@ -1670,7 +1698,8 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 }
 
 static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
-		     unsigned int num, struct sdebug_dev_info *devip)
+		     unsigned int num, struct sdebug_dev_info *devip,
+		     u32 ei_lba)
 {
 	unsigned long iflags;
 	int ret;
@@ -1699,7 +1728,7 @@ static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
 
 	/* DIX + T10 DIF */
 	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
-		int prot_ret = prot_verify_read(SCpnt, lba, num);
+		int prot_ret = prot_verify_read(SCpnt, lba, num, ei_lba);
 
 		if (prot_ret) {
 			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, prot_ret);
@@ -1735,7 +1764,7 @@ void dump_sector(unsigned char *buf, int len)
 }
 
 static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
-			     unsigned int sectors)
+			     unsigned int sectors, u32 ei_lba)
 {
 	int i, j, ret;
 	struct sd_dif_tuple *sdt;
@@ -1749,11 +1778,6 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 	sector = do_div(tmp_sec, sdebug_store_sectors);
 
-	if (((SCpnt->cmnd[1] >> 5) & 7) != 1) {
-		printk(KERN_WARNING "scsi_debug: WRPROTECT != 1\n");
-		return 0;
-	}
-
 	BUG_ON(scsi_sg_count(SCpnt) == 0);
 	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
 
@@ -1808,7 +1832,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 				goto out;
 			}
 
-			if (scsi_debug_dif != SD_DIF_TYPE3_PROTECTION &&
+			if (scsi_debug_dif == SD_DIF_TYPE1_PROTECTION &&
 			    be32_to_cpu(sdt->ref_tag)
 			    != (start_sec & 0xffffffff)) {
 				printk(KERN_ERR
@@ -1819,6 +1843,16 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 				goto out;
 			}
 
+			if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+			    be32_to_cpu(sdt->ref_tag) != ei_lba) {
+				printk(KERN_ERR
+				       "%s: REF check failed on sector %lu\n",
+				       __func__, (unsigned long)sector);
+				ret = 0x03;
+				dump_sector(daddr, scsi_debug_sector_size);
+				goto out;
+			}
+
 			/* Would be great to copy this in bigger
 			 * chunks.  However, for the sake of
 			 * correctness we need to verify each sector
@@ -1832,6 +1866,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 				sector = 0;	/* Force wrap */
 
 			start_sec++;
+			ei_lba++;
 			daddr += scsi_debug_sector_size;
 			ppage_offset += sizeof(struct sd_dif_tuple);
 		}
@@ -1853,7 +1888,8 @@ out:
 }
 
 static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
-		      unsigned int num, struct sdebug_dev_info *devip)
+		      unsigned int num, struct sdebug_dev_info *devip,
+		      u32 ei_lba)
 {
 	unsigned long iflags;
 	int ret;
@@ -1864,7 +1900,7 @@ static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
 
 	/* DIX + T10 DIF */
 	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
-		int prot_ret = prot_verify_write(SCpnt, lba, num);
+		int prot_ret = prot_verify_write(SCpnt, lba, num, ei_lba);
 
 		if (prot_ret) {
 			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, prot_ret);
@@ -2872,11 +2908,12 @@ static int __init scsi_debug_init(void)
 
 	case SD_DIF_TYPE0_PROTECTION:
 	case SD_DIF_TYPE1_PROTECTION:
+	case SD_DIF_TYPE2_PROTECTION:
 	case SD_DIF_TYPE3_PROTECTION:
 		break;
 
 	default:
-		printk(KERN_ERR "scsi_debug_init: dif must be 0, 1 or 3\n");
+		printk(KERN_ERR "scsi_debug_init: dif must be 0, 1, 2 or 3\n");
 		return -EINVAL;
 	}
 
@@ -3121,6 +3158,7 @@ int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
 	int len, k;
 	unsigned int num;
 	unsigned long long lba;
+	u32 ei_lba;
 	int errsts = 0;
 	int target = SCpnt->device->id;
 	struct sdebug_dev_info *devip = NULL;
@@ -3254,14 +3292,30 @@ int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
 	case READ_16:
 	case READ_12:
 	case READ_10:
+		/* READ{10,12,16} and DIF Type 2 are natural enemies */
+		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+		    cmd[1] & 0xe0) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+					INVALID_COMMAND_OPCODE, 0);
+			errsts = check_condition_result;
+			break;
+		}
+
+		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
+		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
+		    (cmd[1] & 0xe0) == 0)
+			printk(KERN_ERR "Unprotected RD/WR to DIF device\n");
+
+		/* fall through */
 	case READ_6:
+read:
 		errsts = check_readiness(SCpnt, 0, devip);
 		if (errsts)
 			break;
 		if (scsi_debug_fake_rw)
 			break;
-		get_data_transfer_info(cmd, &lba, &num);
-		errsts = resp_read(SCpnt, lba, num, devip);
+		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
+		errsts = resp_read(SCpnt, lba, num, devip, ei_lba);
 		if (inj_recovered && (0 == errsts)) {
 			mk_sense_buffer(devip, RECOVERED_ERROR,
 					THRESHOLD_EXCEEDED, 0);
@@ -3288,14 +3342,30 @@ int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
 	case WRITE_16:
 	case WRITE_12:
 	case WRITE_10:
+		/* WRITE{10,12,16} and DIF Type 2 are natural enemies */
+		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+		    cmd[1] & 0xe0) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+					INVALID_COMMAND_OPCODE, 0);
+			errsts = check_condition_result;
+			break;
+		}
+
+		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
+		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
+		    (cmd[1] & 0xe0) == 0)
+			printk(KERN_ERR "Unprotected RD/WR to DIF device\n");
+
+		/* fall through */
 	case WRITE_6:
+write:
 		errsts = check_readiness(SCpnt, 0, devip);
 		if (errsts)
 			break;
 		if (scsi_debug_fake_rw)
 			break;
-		get_data_transfer_info(cmd, &lba, &num);
-		errsts = resp_write(SCpnt, lba, num, devip);
+		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
+		errsts = resp_write(SCpnt, lba, num, devip, ei_lba);
 		if (inj_recovered && (0 == errsts)) {
 			mk_sense_buffer(devip, RECOVERED_ERROR,
 					THRESHOLD_EXCEEDED, 0);
@@ -3341,15 +3411,38 @@ int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
 			break;
 		if (scsi_debug_fake_rw)
 			break;
-		get_data_transfer_info(cmd, &lba, &num);
-		errsts = resp_read(SCpnt, lba, num, devip);
+		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
+		errsts = resp_read(SCpnt, lba, num, devip, ei_lba);
 		if (errsts)
 			break;
-		errsts = resp_write(SCpnt, lba, num, devip);
+		errsts = resp_write(SCpnt, lba, num, devip, ei_lba);
 		if (errsts)
 			break;
 		errsts = resp_xdwriteread(SCpnt, lba, num, devip);
 		break;
+	case VARIABLE_LENGTH_CMD:
+		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION) {
+
+			if ((cmd[10] & 0xe0) == 0)
+				printk(KERN_ERR
+				       "Unprotected RD/WR to DIF device\n");
+
+			if (cmd[9] == READ_32) {
+				BUG_ON(SCpnt->cmd_len < 32);
+				goto read;
+			}
+
+			if (cmd[9] == WRITE_32) {
+				BUG_ON(SCpnt->cmd_len < 32);
+				goto write;
+			}
+		}
+
+		mk_sense_buffer(devip, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+		errsts = check_condition_result;
+		break;
+
 	default:
 		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
 			printk(KERN_INFO "scsi_debug: Opcode: 0x%x not "
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 877204d..1b0060b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -725,6 +725,9 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 		case NEEDS_RETRY:
 		case FAILED:
 			break;
+		case ADD_TO_MLQUEUE:
+			rtn = NEEDS_RETRY;
+			break;
 		default:
 			rtn = FAILED;
 			break;
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index b98885d..a67fed1 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3586,6 +3586,7 @@ enum fc_dispatch_result {
 
 /**
  * fc_bsg_host_dispatch - process fc host bsg requests and dispatch to LLDD
+ * @q:		fc host request queue
  * @shost:	scsi host rport attached to
  * @job:	bsg job to be processed
  */
@@ -3693,6 +3694,7 @@ fc_bsg_goose_queue(struct fc_rport *rport)
 
 /**
  * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
+ * @q:		rport request queue
  * @shost:	scsi host rport attached to
  * @rport:	rport request destined to
  * @job:	bsg job to be processed
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8dd96dc..9093c72 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -116,6 +116,9 @@ static DEFINE_IDA(sd_index_ida);
  * object after last put) */
 static DEFINE_MUTEX(sd_ref_mutex);
 
+struct kmem_cache *sd_cdb_cache;
+mempool_t *sd_cdb_pool;
+
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
 	"write back, no read (daft)"
@@ -370,6 +373,31 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	mutex_unlock(&sd_ref_mutex);
 }
 
+static void sd_prot_op(struct scsi_cmnd *scmd, unsigned int dif)
+{
+	unsigned int prot_op = SCSI_PROT_NORMAL;
+	unsigned int dix = scsi_prot_sg_count(scmd);
+
+	if (scmd->sc_data_direction == DMA_FROM_DEVICE) {
+		if (dif && dix)
+			prot_op = SCSI_PROT_READ_PASS;
+		else if (dif && !dix)
+			prot_op = SCSI_PROT_READ_STRIP;
+		else if (!dif && dix)
+			prot_op = SCSI_PROT_READ_INSERT;
+	} else {
+		if (dif && dix)
+			prot_op = SCSI_PROT_WRITE_PASS;
+		else if (dif && !dix)
+			prot_op = SCSI_PROT_WRITE_INSERT;
+		else if (!dif && dix)
+			prot_op = SCSI_PROT_WRITE_STRIP;
+	}
+
+	scsi_set_prot_op(scmd, prot_op);
+	scsi_set_prot_type(scmd, dif);
+}
+
 /**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
@@ -388,6 +416,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	sector_t threshold;
 	unsigned int this_count = blk_rq_sectors(rq);
 	int ret, host_dif;
+	unsigned char protect;
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
@@ -520,13 +549,49 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	/* Set RDPROTECT/WRPROTECT if disk is formatted with DIF */
 	host_dif = scsi_host_dif_capable(sdp->host, sdkp->protection_type);
 	if (host_dif)
-		SCpnt->cmnd[1] = 1 << 5;
+		protect = 1 << 5;
 	else
-		SCpnt->cmnd[1] = 0;
+		protect = 0;
 
-	if (block > 0xffffffff) {
+	if (host_dif == SD_DIF_TYPE2_PROTECTION) {
+		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
+
+		if (unlikely(SCpnt->cmnd == NULL)) {
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
+
+		SCpnt->cmd_len = SD_EXT_CDB_SIZE;
+		memset(SCpnt->cmnd, 0, SCpnt->cmd_len);
+		SCpnt->cmnd[0] = VARIABLE_LENGTH_CMD;
+		SCpnt->cmnd[7] = 0x18;
+		SCpnt->cmnd[9] = (rq_data_dir(rq) == READ) ? READ_32 : WRITE_32;
+		SCpnt->cmnd[10] = protect | (blk_fua_rq(rq) ? 0x8 : 0);
+
+		/* LBA */
+		SCpnt->cmnd[12] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
+		SCpnt->cmnd[13] = sizeof(block) > 4 ? (unsigned char) (block >> 48) & 0xff : 0;
+		SCpnt->cmnd[14] = sizeof(block) > 4 ? (unsigned char) (block >> 40) & 0xff : 0;
+		SCpnt->cmnd[15] = sizeof(block) > 4 ? (unsigned char) (block >> 32) & 0xff : 0;
+		SCpnt->cmnd[16] = (unsigned char) (block >> 24) & 0xff;
+		SCpnt->cmnd[17] = (unsigned char) (block >> 16) & 0xff;
+		SCpnt->cmnd[18] = (unsigned char) (block >> 8) & 0xff;
+		SCpnt->cmnd[19] = (unsigned char) block & 0xff;
+
+		/* Expected Indirect LBA */
+		SCpnt->cmnd[20] = (unsigned char) (block >> 24) & 0xff;
+		SCpnt->cmnd[21] = (unsigned char) (block >> 16) & 0xff;
+		SCpnt->cmnd[22] = (unsigned char) (block >> 8) & 0xff;
+		SCpnt->cmnd[23] = (unsigned char) block & 0xff;
+
+		/* Transfer length */
+		SCpnt->cmnd[28] = (unsigned char) (this_count >> 24) & 0xff;
+		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
+		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
+		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
+	} else if (block > 0xffffffff) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
-		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;
+		SCpnt->cmnd[1] = protect | (blk_fua_rq(rq) ? 0x8 : 0);
 		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
 		SCpnt->cmnd[3] = sizeof(block) > 4 ? (unsigned char) (block >> 48) & 0xff : 0;
 		SCpnt->cmnd[4] = sizeof(block) > 4 ? (unsigned char) (block >> 40) & 0xff : 0;
@@ -547,7 +612,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 			this_count = 0xffff;
 
 		SCpnt->cmnd[0] += READ_10 - READ_6;
-		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;
+		SCpnt->cmnd[1] = protect | (blk_fua_rq(rq) ? 0x8 : 0);
 		SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
 		SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
 		SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
@@ -578,8 +643,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 
 	/* If DIF or DIX is enabled, tell HBA how to handle request */
 	if (host_dif || scsi_prot_sg_count(SCpnt))
-		sd_dif_op(SCpnt, host_dif, scsi_prot_sg_count(SCpnt),
-			  sdkp->protection_type);
+		sd_prot_op(SCpnt, host_dif);
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -1023,6 +1087,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	int result = SCpnt->result;
 	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
 	struct scsi_sense_hdr sshdr;
+	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
@@ -1084,6 +1149,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
 		sd_dif_complete(SCpnt, good_bytes);
 
+	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
+	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd)
+		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+
 	return good_bytes;
 }
 
@@ -1238,34 +1307,28 @@ void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	u8 type;
 
 	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0)
-		type = 0;
-	else
-		type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
+		return;
 
-	sdkp->protection_type = type;
+	type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
 
-	switch (type) {
-	case SD_DIF_TYPE0_PROTECTION:
-	case SD_DIF_TYPE1_PROTECTION:
-	case SD_DIF_TYPE3_PROTECTION:
-		break;
+	if (type == sdkp->protection_type || !sdkp->first_scan)
+		return;
 
-	case SD_DIF_TYPE2_PROTECTION:
-		sd_printk(KERN_ERR, sdkp, "formatted with DIF Type 2 "	\
-			  "protection which is currently unsupported. "	\
-			  "Disabling disk!\n");
-		goto disable;
+	sdkp->protection_type = type;
 
-	default:
-		sd_printk(KERN_ERR, sdkp, "formatted with unknown "	\
-			  "protection type %d. Disabling disk!\n", type);
-		goto disable;
+	if (type > SD_DIF_TYPE3_PROTECTION) {
+		sd_printk(KERN_ERR, sdkp, "formatted with unsupported "	\
+			  "protection type %u. Disabling disk!\n", type);
+		sdkp->capacity = 0;
+		return;
 	}
 
-	return;
-
-disable:
-	sdkp->capacity = 0;
+	if (scsi_host_dif_capable(sdp->host, type))
+		sd_printk(KERN_NOTICE, sdkp,
+			  "Enabling DIF Type %u protection\n", type);
+	else
+		sd_printk(KERN_NOTICE, sdkp,
+			  "Disabling DIF Type %u protection\n", type);
 }
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
@@ -2300,8 +2363,24 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out_class;
 
+	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
+					 0, 0, NULL);
+	if (!sd_cdb_cache) {
+		printk(KERN_ERR "sd: can't init extended cdb cache\n");
+		goto err_out_class;
+	}
+
+	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
+	if (!sd_cdb_pool) {
+		printk(KERN_ERR "sd: can't init extended cdb pool\n");
+		goto err_out_cache;
+	}
+
 	return 0;
 
+err_out_cache:
+	kmem_cache_destroy(sd_cdb_cache);
+
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -2321,6 +2400,9 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
+	mempool_destroy(sd_cdb_pool);
+	kmem_cache_destroy(sd_cdb_cache);
+
 	scsi_unregister_driver(&sd_template.gendrv);
 	class_unregister(&sd_disk_class);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 8474b5b..e374804 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -37,6 +37,11 @@
  */
 #define SD_LAST_BUGGY_SECTORS	8
 
+enum {
+	SD_EXT_CDB_SIZE = 32,	/* Extended CDB size */
+	SD_MEMPOOL_SIZE = 2,	/* CDB pool size */
+};
+
 struct scsi_disk {
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
@@ -101,16 +106,12 @@ struct sd_dif_tuple {
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
-extern void sd_dif_op(struct scsi_cmnd *, unsigned int, unsigned int, unsigned int);
 extern void sd_dif_config_host(struct scsi_disk *);
 extern int sd_dif_prepare(struct request *rq, sector_t, unsigned int);
 extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
-static inline void sd_dif_op(struct scsi_cmnd *cmd, unsigned int a, unsigned int b, unsigned int c)
-{
-}
 static inline void sd_dif_config_host(struct scsi_disk *disk)
 {
 }
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 82f14a9..88da977 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -320,15 +320,6 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 		dif = 0; dix = 1;
 	}
 
-	if (type) {
-		if (dif)
-			sd_printk(KERN_NOTICE, sdkp,
-				  "Enabling DIF Type %d protection\n", type);
-		else
-			sd_printk(KERN_NOTICE, sdkp,
-				  "Disabling DIF Type %d protection\n", type);
-	}
-
 	if (!dix)
 		return;
 
@@ -360,62 +351,6 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 }
 
 /*
- * DIF DMA operation magic decoder ring.
- */
-void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif, unsigned int dix, unsigned int type)
-{
-	int csum_convert, prot_op;
-
-	prot_op = 0;
-
-	/* Convert checksum? */
-	if (scsi_host_get_guard(scmd->device->host) != SHOST_DIX_GUARD_CRC)
-		csum_convert = 1;
-	else
-		csum_convert = 0;
-
-	BUG_ON(dif && (scmd->cmnd[0] == READ_6 || scmd->cmnd[0] == WRITE_6));
-
-	switch (scmd->cmnd[0]) {
-	case READ_6:
-	case READ_10:
-	case READ_12:
-	case READ_16:
-		if (dif && dix)
-			if (csum_convert)
-				prot_op = SCSI_PROT_READ_CONVERT;
-			else
-				prot_op = SCSI_PROT_READ_PASS;
-		else if (dif && !dix)
-			prot_op = SCSI_PROT_READ_STRIP;
-		else if (!dif && dix)
-			prot_op = SCSI_PROT_READ_INSERT;
-
-		break;
-
-	case WRITE_6:
-	case WRITE_10:
-	case WRITE_12:
-	case WRITE_16:
-		if (dif && dix)
-			if (csum_convert)
-				prot_op = SCSI_PROT_WRITE_CONVERT;
-			else
-				prot_op = SCSI_PROT_WRITE_PASS;
-		else if (dif && !dix)
-			prot_op = SCSI_PROT_WRITE_INSERT;
-		else if (!dif && dix)
-			prot_op = SCSI_PROT_WRITE_STRIP;
-
-		break;
-	}
-
-	scsi_set_prot_op(scmd, prot_op);
-	if (dif)
-		scsi_set_prot_type(scmd, type);
-}
-
-/*
  * The virtual start sector is the one that was originally submitted
  * by the block layer.	Due to partitioning, MD/DM cloning, etc. the
  * actual physical start sector is likely to be different.  Remap
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0cb049f..a328b5f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1708,11 +1708,6 @@ static int sg_finish_rem_req(Sg_request * srp)
 	Sg_scatter_hold *req_schp = &srp->data;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
-	if (srp->res_used)
-		sg_unlink_reserve(sfp, srp);
-	else
-		sg_remove_scat(req_schp);
-
 	if (srp->rq) {
 		if (srp->bio)
 			ret = blk_rq_unmap_user(srp->bio);
@@ -1720,6 +1715,11 @@ static int sg_finish_rem_req(Sg_request * srp)
 		blk_put_request(srp->rq);
 	}
 
+	if (srp->res_used)
+		sg_unlink_reserve(sfp, srp);
+	else
+		sg_remove_scat(req_schp);
+
 	sg_remove_request(sfp, srp);
 
 	return ret;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index eb61f7a..d6f340f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -684,14 +684,20 @@ static void get_sectorsize(struct scsi_cd *cd)
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
 	} else {
-#if 0
-		if (cdrom_get_last_written(&cd->cdi,
-					   &cd->capacity))
-#endif
-			cd->capacity = 1 + ((buffer[0] << 24) |
-						    (buffer[1] << 16) |
-						    (buffer[2] << 8) |
-						    buffer[3]);
+		long last_written;
+
+		cd->capacity = 1 + ((buffer[0] << 24) | (buffer[1] << 16) |
+				    (buffer[2] << 8) | buffer[3]);
+		/*
+		 * READ_CAPACITY doesn't return the correct size on
+		 * certain UDF media.  If last_written is larger, use
+		 * it instead.
+		 *
+		 * http://bugzilla.kernel.org/show_bug.cgi?id=9668
+		 */
+		if (!cdrom_get_last_written(&cd->cdi, &last_written))
+			cd->capacity = max_t(long, cd->capacity, last_written);
+
 		sector_size = (buffer[4] << 24) |
 		    (buffer[5] << 16) | (buffer[6] << 8) | buffer[7];
 		switch (sector_size) {
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index b33d042..12d58a7 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2859,11 +2859,8 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			ioctl_result = st_int_ioctl(STp, MTBSF, 1);
 
 		if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) {
-			int old_block_size = STp->block_size;
 			STp->block_size = arg & MT_ST_BLKSIZE_MASK;
 			if (STp->block_size != 0) {
-				if (old_block_size == 0)
-					normalize_buffer(STp->buffer);
 				(STp->buffer)->buffer_blocks =
 				    (STp->buffer)->buffer_size / STp->block_size;
 			}
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 887e57e..a72edd4 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -303,6 +303,7 @@ struct iscsi_session {
 	int			cmds_max;	/* size of cmds array */
 	struct iscsi_task	**cmds;		/* Original Cmds arr */
 	struct iscsi_pool	cmdpool;	/* PDU's pool */
+	void			*dd_data;	/* LLD private data */
 };
 
 enum {
@@ -363,7 +364,7 @@ extern int iscsi_target_alloc(struct scsi_target *starget);
  */
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
-		    uint16_t, int, uint32_t, unsigned int);
+		    uint16_t, int, int, uint32_t, unsigned int);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..34c46ab 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -129,6 +129,9 @@ struct scsi_cmnd;
 #define MI_REPORT_TARGET_PGS  0x0a
 /* values for maintenance out */
 #define MO_SET_TARGET_PGS     0x0a
+/* values for variable length command */
+#define READ_32		      0x09
+#define WRITE_32	      0x0b
 
 /* Values for T10/04-262r7 */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3878d1d..a5e885a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -229,10 +229,6 @@ enum scsi_prot_operations {
 	/* OS-HBA: Protected, HBA-Target: Protected */
 	SCSI_PROT_READ_PASS,
 	SCSI_PROT_WRITE_PASS,
-
-	/* OS-HBA: Protected, HBA-Target: Protected, checksum conversion */
-	SCSI_PROT_READ_CONVERT,
-	SCSI_PROT_WRITE_CONVERT,
 };
 
 static inline void scsi_set_prot_op(struct scsi_cmnd *scmd, unsigned char op)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b62a097..6e728b1 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -798,9 +798,15 @@ static inline unsigned int scsi_host_get_prot(struct Scsi_Host *shost)
 static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsigned int target_type)
 {
 	switch (target_type) {
-	case 1: return shost->prot_capabilities & SHOST_DIF_TYPE1_PROTECTION;
-	case 2: return shost->prot_capabilities & SHOST_DIF_TYPE2_PROTECTION;
-	case 3: return shost->prot_capabilities & SHOST_DIF_TYPE3_PROTECTION;
+	case 1:
+		if (shost->prot_capabilities & SHOST_DIF_TYPE1_PROTECTION)
+			return target_type;
+	case 2:
+		if (shost->prot_capabilities & SHOST_DIF_TYPE2_PROTECTION)
+			return target_type;
+	case 3:
+		if (shost->prot_capabilities & SHOST_DIF_TYPE3_PROTECTION)
+			return target_type;
 	}
 
 	return 0;
@@ -808,13 +814,14 @@ static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsign
 
 static inline unsigned int scsi_host_dix_capable(struct Scsi_Host *shost, unsigned int target_type)
 {
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
 	switch (target_type) {
 	case 0: return shost->prot_capabilities & SHOST_DIX_TYPE0_PROTECTION;
 	case 1: return shost->prot_capabilities & SHOST_DIX_TYPE1_PROTECTION;
 	case 2: return shost->prot_capabilities & SHOST_DIX_TYPE2_PROTECTION;
 	case 3: return shost->prot_capabilities & SHOST_DIX_TYPE3_PROTECTION;
 	}
-
+#endif
 	return 0;
 }
 
