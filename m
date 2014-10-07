From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.16+ merge window
Date: Tue, 07 Oct 2014 16:49:26 -0700
Message-ID: <1412725766.19012.9.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch set consists of the usual driver updates (megaraid_sas,
arcmsr, be2iscsi, lpfc, mpt2sas, mpt3sas, qla2xxx, ufs) plus several
assorted fixes and miscellaneous updates (including the
pci_msix_enable_range() changes that have been pending for a while).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-li=
nus

The short changelog is:

Adam Radford (5):
      megaraid_sas: Version and Changelog update
      megaraid_sas: Fix reset_mutex leak
      megaraid_sas: Remove unused variables in megasas_instance
      megaraid_sas: Add missing initial call to megasas_get_ld_vf_affil=
iation().
      megaraid_sas: Fix LD/VF affiliation parsing

Alan Stern (1):
      scsi: don't store LUN bits in CDB[1] for USB mass-storage devices

Alex Vechersky (1):
      qla2xxx: Add missing ISP27xx checks to optrom code.

Alexander Gordeev (13):
      lpfc: Use pci_enable_msix_range() instead of pci_enable_msix()
      pmcraid: Use pci_enable_msix_range() instead of pci_enable_msix()
      pmcraid: Get rid of a redundant assignment
      csiostor: Use pci_enable_msix_range() instead of pci_enable_msix(=
)
      csiostor: Remove superfluous call to pci_disable_msix()
      be2iscsi: Use pci_enable_msix_range()
      qla2xxx: Use pci_enable_msix_range() instead of pci_enable_msix()
      mpt3sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
      mpt2sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
      megaraid: Use pci_enable_msix_range() instead of pci_enable_msix(=
)
      megaraid: Fail resume if MSI-X re-initialization failed
      hpsa: Use pci_enable_msix_range() instead of pci_enable_msix()
      hpsa: Fallback to MSI rather than to INTx if MSI-X failed

Andreea-Cristina Bernat (1):
      libfc: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Anish Bhatt (1):
      cxgb4i: avoid holding mutex in interrupt context

Arun Easi (7):
      qla2xxx: Host reset handling in ABTS path.
      qla2xxx: Handle chip reset in target mode.
      qla2xxx: Add Host reset handling in target mode.
      qla2xxx: Enable SLER conditionally in target mode.
      qla2xxx: Remove verbose messages in target mode.
      qla2xxx: Use correct offset to req-q-out for reserve calculation
      qla2xxx: Unload of qla2xxx driver crashes the machine.

Chad Dupuis (9):
      qla2xxx: Fail adapter initialization on load ram failure.
      qla2xxx: Disable PCI device in shutdown handler.
      qla2xxx: Mark port lost when we receive an RSCN for it.
      qla2xxx: Honor FCP_RSP retry delay timer field.
      qla2xxx: Force use of mailbox interface for flash access commands=
 for ISP27xx.
      qla2xxx: Enable fast flash access for ISP83xx.
      bnx2fc: fix incorrect DMA memory mapping in bnx2fc_unmap_sg_list(=
)
      qla2xxx: Remove restriction on starting remote device discovery o=
n port update.
      qla2xxx: Move mailbox failure messages to a default debug level.

Ching Huang (19):
      arcmsr: simplify ioctl data read/write
      arcmsr: simplify of updating doneq_index and postq_index
      arcmsr: call scsi_scan_host at the end of host initialization
      arcmsr: add support new adapter ARC12x4 series
      arcmsr: modify some character strings
      arcmsr: fix sparse warnings and errors
      arcmsr: fix ioctl data read/write error for adapter type C
      arcmsr: revise allocation of second dma_coherent_handle for type =
B
      arcmsr: rename functions and variables
      arcmsr: clear outbound doorbell buffer completely
      arcmsr: modify printing adapter model number and F/W messages
      arcmsr: remove calling arcmsr_hbb_enable_driver_mode
      arcmsr: revise message_isr_bh_fn to remove duplicate code
      arcmsr: store adapter type in PCI id table
      arcmsr: return status of abort command
      arcmsr: limit max. number of SCSI command request
      arcmsr: add code to support hibernation
      arcmsr: add code to support MSI-X and MSI interrupt
      arcmsr: fix command timeout under heavy load

Chris J Arges (1):
      mptfusion: enable no_write_same for vmware scsi disks

Chris Leech (1):
      fcoe: extend ethtool to FC port speed mapping

Christoph Hellwig (4):
      scsi: add a CONFIG_SCSI_MQ_DEFAULT option
      ipr: fix compile failure
      eata: remove driver_lock
      scsi: fix regression that accidentally disabled block-based tcq

Daniel Borkmann (1):
      lpfc: do not feed jiffies as random seed from lpfc driver

Dolev Raviv (2):
      ufs: definitions for phy interface
      ufs: refactor configuring power mode

Douglas Gilbert (4):
      scsi_debug: deadlock between completions and surprise module remo=
val
      scsi_debug: bump inquiry version to SPC-4, update version descrip=
tors
      scsi_debug: give unit attention and other errors precedence over =
TSF
      scsi_debug: scsi_cmnd->cmnd check and casts unnecessary

Hans Wennborg (1):
      scsi: fix decimal printf format specifiers prefixed with 0x

Himanshu Madhani (12):
      qla2xxx: Add memory barrier before ringing doorbell.
      qla2xxx: Do not send SS_RESIDUAL_UNDER with SAM_STAT_BUSY
      qla2xxx: fix crash due to task mgmt cmd type
      qla2xxx: Increase room in request queue for sending priority pack=
ets
      qla2xxx: fix kernel NULL pointer access
      qla2xxx: Fix sparse warnings in tcm_qla2xxx.c
      qla2xxx: Restore WWPN in case of Loop Dead.
      qla2xxx: Disable laser for ISP2031 while unloading driver.
      qla2xxx: Enable diagnostic port using NVRAM parameters.
      qla2xxx: Allow user to change ql2xfdmienable value.
      qla2xxx: Fix driver version string message.
      qla2xxx: Add FDMI-2 functionality.

Hiral Shah (1):
      fnic: assign FIP_ALL_FCF_MACS to fcoe_all_fcfs

James Smart (10):
      lpfc: update lpfc version to driver version 10.4.8000.0
      lpfc: fix for handling unmapped ndlp in target reset handler
      lpfc: fix low priority issues from fortify source code scan
      lpfc: fix high priority issues from fortify source code scan
      lpfc: fix crash from page fault caused by use after rport delete
      lpfc: fix locking issues with abort data paths
      lpfc: fix race between LOGO/PLOGI handling causing NULL pointer
      lpfc: fix IP Reset processing - wait for RDY before proceeding
      lpfc: fix quarantined XRI recovery qualifier state in link bounce
      lpfc: fix discovery timeout during nameserver login

Jan Kulich (1):
      qla2xxx: ISPFx00 unexpected resets during adapter boot sequence.

Jayamohan Kallickal (5):
      be2iscsi: Bump the driver version
      be2iscsi: Fix processing CQE before connection resources are free=
d
      be2iscsi: Fix updating the boot enteries in sysfs
      be2iscsi: Fix the copyright year
      be2iscsi: Fix the sparse warning introduced in previous submissio=
n

Joe Carnuccio (15):
      qla2xxx: Fix sparse warning in qla_iocb.c file.
      qla2xxx: Add diagnostic port functionality.
      qla2xxx: Add FA-WWN functionality.
      qla2xxx: Incorrect linked list semantic in qlafx00_get_fcport().
      qla2xxx: Incorrect debug level on mailbox command print 0x1111.
      qla2xxx: ISPFX00 avoid writing semaphore register in request_irqs=
().
      qla2xxx: Fix potential return count bug in qla2xxx_get_vpd_field(=
).
      qla2xxx: ISP27xx fwdump template error print simplification.
      qla2xxx: ISP25xx multiqueue shadow register crash fix.
      qla2xxx: Add endianizer to max_payload_size modifier.
      qla2xxx: Add ISP27xx fwdump template entry T275 (insert buffer).
      qla2xxx: ISP27xx fwdump template fix insertbuf() routine.
      qla2xxx: ISP27xx fwdump template remove high frequency debug logs=
=2E
      qla2xxx: ISP27xx optimize fwdump entry table lookup.
      qla2xxx: ISP27xx add tests for incomplete template.

Joe Lawrence (6):
      qla2xxx: Prevent probe and board_disable race
      qla2xxx: Prevent removal and board_disable race
      qla2xxx: Schedule board_disable only once
      qla2xxx: Collect PCI register checks and board_disable scheduling
      qla2xxx: Use qla2x00_clear_drv_active on probe failure
      qla2xxx: Fix shost use-after-free on device removal

Joe Perches (1):
      lpfc: use dma_zalloc_coherent

John Soni Jose (2):
      be2iscsi : Bump the driver version
      be2iscsi : Fix kernel panic during reboot/shutdown

K. Y. Srinivasan (1):
      storvsc: get rid of overly verbose warning messages

Kashyap.Desai@avagotech.com (1):
      scsi: add use_cmd_list flag

Manuel Sch=C3=B6lling (1):
      lpfc: use time_after()

Mike Christie (3):
      be2iscsi: check ip buffer before copying
      iscsi_tcp: export port being used
      libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu

Nigel Kirkland (1):
      qla2xxx: Free sysfs attributes for ISP27xx.

Quinn Tran (3):
      qla2xxx: Fix hang due to cmd_kref not decrementing
      qla2xxx: Add support for QFull throttling and Term Exchange retry
      qla2xxx: Declaration error cause stack corruption.

Randy Dunlap (2):
      fusion: fix excess parameter kernel-doc warning
      scsi: fix various kernel-doc problems in scsi_error.c

Rashika Kheria (5):
      lpfc: mark function as static in lpfc/lpfc_bsg.c
      lpfc: mark functions as static in lpfc/lpfc_scsi.c
      lpfc: mark functions as static in lpfc/lpfc_init.c
      lpfc: mark functions as static in lpfc/lpfc_hbadisc.c
      lpfc: mark functions as static in lpfc/lpfc_sli.c

Rasmus Villemoes (1):
      mptfusion: simplify rounding

Raviv Shvili (1):
      ufs: add voting support for host controller power

Sahitya Tummala (3):
      ufs: Add support for clock scaling using devfreq framework
      ufs: Add freq-table-hz property for UFS device
      ufs: Add support for clock gating

Saurav Kashyap (4):
      qla2xxx: Add flags for tracing the target commands.
      qla2xxx: Increase the request queue size to 8K for ISP2031
      qla2xxx: Add counter for message
      qla2xxx: Update the driver version to 8.07.00.16-k.

Sawan Chandak (2):
      qla2xxx: Move warning message to debug level.
      qla2xxx: Add fix in driver unload for pending activity.

Sebastian Herbszt (1):
      scsi: fix comment in struct Scsi_Host definition

Sreekanth Reddy (19):
      mpt2sas: fix undefined reference to `__udivdi3' compilation error=
s
      mpt3sas, mpt2sas: fix scsi_add_host error handling problems in _s=
csih_probe
      mpt3sas: Bump mpt3sas driver version to 04.100.00.00
      mpt3sas: Added Reply Descriptor Post Queue (RDPQ) Array support
      mpt3sas: Added OEM branding Strings
      mpt3sas: Copyright in driver sources is updated for year the 2014=
=2E
      mpt3sas: MPI2.5 Rev H (2.5.3) specifications
      mpt3sas: Bump mpt3sas driver version to 03.100.00.00
      mpt3sas: Clear PFA Status on SGPIO when PFA Drive is Removed or R=
eplaced
      mpt3sas: MPI2.5 Rev G (2.5.2) specifications
      mpt2sas: Bump mpt2sas driver version to 18.100.00.00
      mpt2sas: Get IOC_FACTS information using handshake protocol only =
after HBA card gets into READY or Operational state.
      mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
      mpt2sas: Avoid type casting for direct I/O commands
      mpt2sas: Bump mpt2sas driver version to 17.100.00.00
      mpt2sas: Clear PFA Status on SGPIO when PFA Drive is Removed or R=
eplaced
      mpt2sas: Copyright in driver sources is updated for year the 2014
      mpt2sas: MPI2 Rev Y (2.00.17) and Rev Z (2.00.18) specifications
      mpt2sas: Added driver module parameter max_msix_vectors

Subhash Jadavani (8):
      ufs: tune bkops while power managment events
      ufs: add UFS power management support
      ufs: introduce well known logical unit in ufs
      ufs: manually add well known logical units
      ufs: refactor query descriptor API support
      scsi: don't add scsi_device if its already visible
      scsi: fix the type for well known LUs
      scsi: balance out autopm get/put calls in scsi_sysfs_add_sdev()

Sujit Reddy Thumma (5):
      ufs: improve init sequence
      ufs: Add clock initialization support
      ufs: Add regulator enable support
      ufs: Allow vendor specific initialization
      sd: Avoid sending medium write commands if device is write protec=
ted

Sumit.Saxena@avagotech.com (11):
      megaraid_sas : Driver version update
      megaraid_sas : MFI MPT linked list corruption fix
      megaraid_sas : N-drive primary raid level 1 load balancing
      megaraid_sas : Add module parameter to disable IRQ-CPU affinity h=
int
      megaraid_sas : Round down max sge supported by controller to powe=
r of two
      megaraid_sas : Host lock less mode to enabled asynchronous IO sub=
mission
      megaraid_sas : Extended VD support
      megaraid_sas : Firmware crash dump feature support
      megaraid_sas : Update threshold based reply post host index regis=
ter
      megaraid_sas : Use writeq for 64bit pci write to avoid spinlock o=
verhead
      megaraid_sas : Do not scan non syspd drives

Suresh Thiagarajan (1):
      pm8001: Update nvmd response data to request buffer

Tej Parkash (1):
      bnx2i: Make boot_nic entry visible in the sysfs session objects

Tomas Henzl (2):
      hpsa: add missing pci_set_master in kdump path
      hpsa: refine the pci enable/disable handling

Yaniv Gardi (1):
      ufs: Active Power Mode - configuring bActiveICCLevel

wenxiong@linux.vnet.ibm.com (1):
      ipr: don't log error messages when applications issues illegal re=
quests

And the diffstat:

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   41 +
 Documentation/scsi/ChangeLog.megaraid_sas          |   14 +
 drivers/message/fusion/mptbase.c                   |    8 +-
 drivers/message/fusion/mptctl.c                    |    7 +-
 drivers/message/fusion/mptspi.c                    |    5 +
 drivers/scsi/Kconfig                               |   11 +
 drivers/scsi/aacraid/linit.c                       |    1 +
 drivers/scsi/arcmsr/arcmsr.h                       |  146 +-
 drivers/scsi/arcmsr/arcmsr_attr.c                  |  120 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   | 2326 ++++++++++++=
------
 drivers/scsi/be2iscsi/be.h                         |    2 +-
 drivers/scsi/be2iscsi/be_cmds.c                    |   40 +-
 drivers/scsi/be2iscsi/be_cmds.h                    |   24 +-
 drivers/scsi/be2iscsi/be_iscsi.c                   |   31 +-
 drivers/scsi/be2iscsi/be_iscsi.h                   |    2 +-
 drivers/scsi/be2iscsi/be_main.c                    |   42 +-
 drivers/scsi/be2iscsi/be_main.h                    |    8 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |   15 +-
 drivers/scsi/be2iscsi/be_mgmt.h                    |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |   15 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    3 +
 drivers/scsi/csiostor/csio_hw.h                    |    2 +-
 drivers/scsi/csiostor/csio_isr.c                   |   24 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |    2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   59 +-
 drivers/scsi/cxgbi/libcxgbi.h                      |    3 +
 drivers/scsi/dpt_i2o.c                             |    1 +
 drivers/scsi/eata.c                                |    9 -
 drivers/scsi/fcoe/fcoe_transport.c                 |   39 +-
 drivers/scsi/fnic/fnic.h                           |    2 +-
 drivers/scsi/fnic/fnic_fcs.c                       |    5 +-
 drivers/scsi/fnic/fnic_trace.c                     |    5 +-
 drivers/scsi/hpsa.c                                |   70 +-
 drivers/scsi/ipr.c                                 |   10 +
 drivers/scsi/ipr.h                                 |    1 +
 drivers/scsi/iscsi_tcp.c                           |   10 +-
 drivers/scsi/libfc/fc_libfc.c                      |    4 +-
 drivers/scsi/libiscsi.c                            |   11 +
 drivers/scsi/lpfc/lpfc_attr.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |   20 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    1 -
 drivers/scsi/lpfc/lpfc_ct.c                        |   14 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    4 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |    6 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   33 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   53 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  225 +-
 drivers/scsi/lpfc/lpfc_mbox.c                      |    6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |    2 +
 drivers/scsi/lpfc/lpfc_scsi.c                      |   34 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  247 +-
 drivers/scsi/lpfc/lpfc_sli.h                       |    1 +
 drivers/scsi/lpfc/lpfc_sli4.h                      |   20 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h               |  161 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          | 1099 ++++++---
 drivers/scsi/megaraid/megaraid_sas_fp.c            |  327 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  439 +++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |  105 +-
 drivers/scsi/mpt2sas/Kconfig                       |    2 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h                    |   12 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h               |   29 +-
 drivers/scsi/mpt2sas/mpi/mpi2_init.h               |    8 +-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h                |   74 +-
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h               |    8 +-
 drivers/scsi/mpt2sas/mpi/mpi2_sas.h                |    2 +-
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h               |   44 +-
 drivers/scsi/mpt2sas/mpi/mpi2_type.h               |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |  328 ++-
 drivers/scsi/mpt2sas/mpt2sas_base.h                |   28 +-
 drivers/scsi/mpt2sas/mpt2sas_config.c              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c                 |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h                 |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_debug.h               |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |  197 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c           |    2 +-
 drivers/scsi/mpt3sas/Kconfig                       |    2 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h                    |    8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h               |   18 +-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h               |    8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h                |   64 +-
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h               |    8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h                |    8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h               |   45 +-
 drivers/scsi/mpt3sas/mpi/mpi2_type.h               |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  287 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   49 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h                 |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h               |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   78 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c        |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h        |    2 +-
 drivers/scsi/nsp32.c                               |    2 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |    4 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |    8 +
 drivers/scsi/pmcraid.c                             |   14 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   16 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   34 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  191 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |    8 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    9 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  943 ++++++-
 drivers/scsi/qla2xxx/qla_init.c                    |   41 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |    8 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |   17 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  133 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   43 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |    2 +
 drivers/scsi/qla2xxx/qla_mr.c                      |   16 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |    8 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  132 +-
 drivers/scsi/qla2xxx/qla_sup.c                     |    7 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  693 ++++--
 drivers/scsi/qla2xxx/qla_target.h                  |   31 +
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  106 +-
 drivers/scsi/qla2xxx/qla_tmpl.h                    |    8 +
 drivers/scsi/qla2xxx/qla_version.h                 |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   45 +-
 drivers/scsi/scsi.c                                |   12 +-
 drivers/scsi/scsi_debug.c                          |  136 +-
 drivers/scsi/scsi_error.c                          |   27 +-
 drivers/scsi/scsi_lib.c                            |   24 +-
 drivers/scsi/scsi_scan.c                           |   26 +
 drivers/scsi/scsi_sysfs.c                          |   17 +-
 drivers/scsi/sd.c                                  |    8 +-
 drivers/scsi/sr.c                                  |    2 +
 drivers/scsi/st.c                                  |    2 +
 drivers/scsi/storvsc_drv.c                         |   12 -
 drivers/scsi/ufs/Kconfig                           |    2 +
 drivers/scsi/ufs/ufs.h                             |  132 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |   55 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  291 ++-
 drivers/scsi/ufs/ufshcd.c                          | 2592 ++++++++++++=
++++++--
 drivers/scsi/ufs/ufshcd.h                          |  280 ++-
 drivers/scsi/ufs/ufshci.h                          |    9 +-
 drivers/scsi/ufs/unipro.h                          |   56 +
 drivers/usb/storage/usb.c                          |    8 +
 include/scsi/scsi.h                                |    1 +
 include/scsi/scsi_device.h                         |    1 +
 include/scsi/scsi_host.h                           |    6 +-
 include/scsi/scsi_tcq.h                            |    2 +-
 145 files changed, 10441 insertions(+), 3039 deletions(-)

James
