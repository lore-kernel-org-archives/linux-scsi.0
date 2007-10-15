From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI updates for 2.6.24
Date: Mon, 15 Oct 2007 00:09:41 -0400
Message-ID: <1192421381.3429.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48189 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750773AbXJOEJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 00:09:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the accumulated updates queued for 2.6.24.  It contains the
usual slew of driver updates, plus some gdth and advansys rewrites.  We
still have some outstanding bugs in gdth and fc4 for which I'm hoping to
sweep fixes into the next update.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (5):
      esp_scsi: remove __dev{init,exit}
      imm: fix check-after-use
      nsp_cs: remove kernel 2.4 code
      make scsi_decode_sense_buffer and scsi_decode_sense_extras static
      scsi_error.c should #include "scsi_transport_api.h"

Alan Cox (3):
      dtc: Fix typo
      eata_pio: Clean up proc handling, bracketing and use cpu_relax()
      dtc: clean up indent damage and add printk levels

Andrew Morton (3):
      arcmsr: build fix
      ips: warning fix
      aacraid: rename check_reset

Andrew Vasquez (15):
      qla2xxx: Update version number to 8.02.00-k4.
      qla2xxx: Limit iIDMA speed adjustments.
      qla2xxx: Rework MSI-X handlers.
      qla2xxx: Clear options-flags while staging firmware-execution.
      qla2xxx: Sparse cleanups in qla_mid.c
      qla2xxx: Cleanup several 'sparse' warnings.
      qla2xxx: Use shost_priv().
      qla2xxx: Remove unused member (list) from srb_t structure.
      qla2xxx: Use the correct pointer-address during NVRAM writes.
      qla2xxx: Set correct attribute count during FDMI RPA.
      qla2xxx: Query additional RISC registers during ISP25XX firmware dump.
      qla2xxx: Correct staging of RISC while attempting to pause.
      qla2xxx: Query additional RISC information during a pause.
      qla2xxx: Add flash burst-read/write support.
      qla2xxx: Collapse and simplify ISP2XXX firmware dump routines.

Bartlomiej Zolnierkiewicz (1):
      MAINTAINERS: mark ide-scsi as Orphan

Bernhard Walle (1):
      ips: Update version information

Boaz Harrosh (12):
      gdth: !use_sg cleanup and use of scsi accessors
      gdth: Move members from SCp to gdth_cmndinfo, stage 2
      gdth: Setup proper per-command private data
      gdth: Remove gdth_ctr_tab[]
      gdth: gdth_interrupt() gdth_get_status() & gdth_wait() fixes
      gdth: clean up host private data
      NCR5380: Use scsi_eh API for REQUEST_SENSE invocation
      usb storage: use scsi_eh API in REQUEST_SENSE execution
      scsi_error: Refactoring scsi_error to facilitate in synchronous REQUEST_SE
      scsi_error: code cleanup before refactoring of scsi_send_eh_cmnd()
      ide-scsi.: convert to data accessors and !use_sg cleanup
      microtek: use data accessors and !use_sg cleanup

Christof Schmitt (5):
      zfcp: Enable debug feature before setting adapter online
      scsi_transport_fc: Introduce disable_target_scan flag
      zfcp: Remove braces for only one statement
      zfcp: Remove unnecessary assignment
      zfcp: correct indentation for nested if-else

Christoph Hellwig (5):
      gdth: switch to modern scsi host registration
      gdth: Remove virt hosts
      gdth: split out pci probing
      gdth: split out eisa probing
      gdth: split out isa probing

David Woodhouse (1):
      Fix ibmvscsi client for multiplatform iSeries+pSeries kernel

Dhaval Giani (1):
      gdth: fix CONFIG_ISA build failure

Eric Moore (16):
      mptctl : shutup uninitialized variable warnings
      mptlan: bug fix, only half the message frame is dma'd resulting in corrupt
      mpt fusion: fix up fusion prints using the sdev_printk, dev_printk, and sh
      mpt fusion: lock down ScsiLookup
      mpt fusion: Fix sparse warnings
      mpt fusion: add use of shost_priv and remove all the typecasting
      MAINTAINERS : mpt fusion mailing list change
      mpt fusion: bump version to 3.04.06
      mpt fusion: Kconfig cleanup
      mpt fusion: removing Dell copyright
      mpt fusion: removing references to hd->ioc
      mpt fusion: rename vdev to vdevice
      mpt fusion: adding/removing white space
      mpt fusion: standardize printks and debug info
      mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030
      Addition to pci_ids.h for ATTO Technology, Inc.

FUJITA Tomonori (17):
      srp_transport: convert to use supported_mode attribute
      fc_transport: add target driver support
      add supported_mode and active_mode attributes to the host
      tgt: fix can_queue bug
      fc4: convert to use the data buffer accessors
      sg: increase sglist_len of the sg_scatter_hold structure
      ps3rom: convert to use the data buffer accessors
      scsi_transport_srp: remove tgt dependencies
      tgt: convert ibmvstgt to use transport tsk_mgmt_response callback
      tgt: move tsk_mgmt_response callback to transport class
      tgt: convert libsrp and ibmvstgt to use srp_transport
      srp_transport: add target driver support
      tgt: add I_T nexus support
      transport_srp: add rport roles attribute
      ib_srp: convert to use the srp transport class
      ibmvscsi: convert to use the srp transport class
      add srp transport class

Gabriel C (2):
      fdomain: fix CONFIG_PCI=n warnings
      NCR5380: fix NCR53C400_PSEUDO_DMA is not defined

Gilbert Wu (1):
      aic94xx: Add new PCI ID for ASC58300

Heiko Carstens (1):
      zfcp: avoid if (whatever) ; constructs.

HighPoint Linux Team (1):
      hptiop: adding new firmware interface and more PCI device IDs

James Bottomley (4):
      Fix device not ready printk
      sg: use idr to replace static arrays
      move ULD attachment into the prep function
      arcmsr: fix compile problems

Jan Engelhardt (1):
      mpt fusion: Use menuconfig objects

Jeff Garzik (6):
      gdth: Reorder scsi_host_template intitializers
      gdth: kill gdth_{read,write}[bwl] wrappers
      gdth: Remove 2.4.x support, in-kernel changelog
      aic94xx: fix SSP IU status print-out
      arcmsr: irq handler fixes, cleanups, micro-opts
      arcmsr: Fix hardware wait loops

Jesper Juhl (3):
      mpt fusion: fix two potential mem leaks
      NCR_D700, lpfc: Clean up duplicate includes
      lpfc: fix potential overflow of hbqs array

Joe Carnuccio (1):
      qla2xxx: Allow region-based flash-part accesses.

Joe Korty (1):
      dpt_i2o: Fix section mismatch

Kay Sievers (2):
      fix scsi_is_sdev_device() after switch to default sdev attributes
      switch sdev sysfs attributes to default attributes

Mariusz Kozlowski (3):
      mpt fusion: remove redundant memset
      mpt fusion: mostly kmalloc + memset conversion to kzalloc
      kmalloc + memset conversion to kzalloc

Masatake YAMATO (1):
      Fix signness of parameters in scsi module

Matthew Wilcox (77):
      gdth: Make one abuse of scsi_cmnd less obvious
      advansys: Changes to work on parisc
      advansys: Use dma mapping for overrun buffer
      advansys: Remove a couple of uses of bus_to_virt
      advansys: convert to use the data buffer accessors
      advansys: Remove DvcGetPhyAddr
      advansys: Move a couple of fields from struct board to struct adv_dvc
      advansys: Make sdtr_period_tbl a pointer
      advansys: Get rid of board index number
      advansys: Remove private lock
      advansys: Sort out debug macros
      advansys: Remove library version & serial numbers
      advansys: Remove asc_board_t typedef and ASC_BOARDP macro
      advansys: Merge ASC_IERR definitions
      advansys: Sort out irq number mess
      advansys: Remove ASC_WIDE_BOARD predicate
      advansys: Remove ASC_SELECT_QUEUE_DEPTHS
      advansys: Improve reset handler
      advansys: Fix simultaneous calls to ->queuecommand
      advansys: Restructure asc_execute_scsi_cmnd()
      advansys: Remove array of scsi targets
      advansys: Eliminate prototypes
      Get rid of scsi_cmnd->done
      gdth: Stop abusing ->done for internal commands
      qlogicpti: Add a slave_configure method
      Fix mistaken uses of ->done
      pluto: Don't abuse ->done for internal commands
      Remove ->pid field from scsi_cmnd
      ips: Close narrow race in release
      aic94xx: Free scsi host on error
      simscsi: Free scsi host on error
      qlogicfas: Close narrow race in release
      aha152x: Close narrow race in release
      ncr53c8xx: Call scsi_host_put in release
      ide-scsi: Close narrow race in release
      ibmmca: Stop leaking scsi_hosts on exit
      scsi_scan: Cope with kthread_run failing
      Improve error message when offlining a device
      advansys: Use DRV_NAME
      advansys: Comment/indentation/macro cleanup
      advansys: Remove some custom wrappers
      advansys: Remove a check for an impossible condition
      advansys: Support 16-byte commands properly
      advansys: Enable interrupts earlier in queuecommand
      advansys: Remove `active' queue and all remaining internal queueing code
      advansys: Remove `done' queue
      advansys: Remove a check for an impossible condition
      advansys: Remove `waiting' queue
      advansys: Shrink advansys_board_found a little more
      advansys: Reformat microcode
      advansys: Create AdvLoadMicrocode
      advansys: Create AdvBuildCarrierFreelist
      advansys: Fix VLB driver name
      advansys: Move documentation to Documentation/scsi
      advansys: use memcpy instead of open-coded loop
      advansys: Remove pci_slot_info
      advansys: Remove library-style callback routines
      advansys: Move struct device out of the cfg structures
      advansys: Stop using n_io_port in Scsi_Host structure
      advansys: ioremap no longer needs page-aligned addresses
      advansys: delete AscGetChipBusType
      advansys: misc reformatting
      advansys: remove INQUIRY sniffing
      Add QUANTUM XP34301 to the blacklist
      advansys: remove AscCompareString()
      advansys: More PCI cleanups
      advansys: Update resource management
      advansys: Convert to ISA driver model
      advansys: Convert to EISA driver model
      advansys: Convert to PCI driver model
      advansys: Move to scsi hotplug initialisation model
      advansys: Make advansys_board_found a little more readable
      advansys: Stop checking the scsi_cmnd belongs to our Scsi_Host
      advansys: Improve interrupt handler
      advansys: Clean up proc_info implementation
      advansys: undate version, copyright, etc
      Fix async scanning double-add problems

Matthias Kaehlcke (1):
      osst: Use mutex instead of semaphore

Michael Reed (1):
      stale residual returned on write following BUSY retry

Michael S. Tsirkin (1):
      scsi_transport_iscsi: add list, mutex includes

Mike Christie (1):
      fix write buffer length in scsi_req_map_sg()

Nick Cheng (1):
      arcmsr: 1.20.00.15: add SATA RAID plus other fixes

Prakash, Sathya (5):
      mpt fusion: Change company name from LSI Logic to LSI
      mpt fusion: Link speed change display support
      mpt fusion: Creation of mptsas.h header file
      mpt fusion: Change call back indices to u8 from int
      mpt fusion: Usage of high priority request FIFO to send task management co

Ravi Anand (1):
      qla2xxx: Correct infinite-login-retry issue.

Rob Landley (1):
      Update Documentation/scsi/00-INDEX

Robert P. J. Day (1):
      ibmmca: Remove dead references to MODULE_PARM macro

Salyzyn, Mark (1):
      aacraid: Add documentation for new Adaptec, SMC and SUN cards

Seokmann Ju (2):
      qla2xxx: Retrieve max-NPIV support capabilities from FW.
      qla2xxx: Add PCI error recovery support.

Swen Schillig (2):
      zfcp: whitespace cleanup
      zfcp: cleanup, separation of ERP, non ERP-version for exchange_ functions


and the diffstat:

 b/Documentation/scsi/00-INDEX                |   34 
 b/Documentation/scsi/ChangeLog.arcmsr        |   17 
 b/Documentation/scsi/aacraid.txt             |    8 
 b/Documentation/scsi/advansys.txt            |  243 
 b/MAINTAINERS                                |   13 
 b/arch/ia64/hp/sim/simscsi.c                 |    9 
 b/drivers/fc4/fc.c                           |   41 
 b/drivers/infiniband/ulp/srp/Kconfig         |    1 
 b/drivers/infiniband/ulp/srp/ib_srp.c        |   28 
 b/drivers/message/fusion/Kconfig             |   26 
 b/drivers/message/fusion/lsi/mpi.h           |    2 
 b/drivers/message/fusion/lsi/mpi_cnfg.h      |    2 
 b/drivers/message/fusion/lsi/mpi_fc.h        |    2 
 b/drivers/message/fusion/lsi/mpi_history.txt |    2 
 b/drivers/message/fusion/lsi/mpi_init.h      |    2 
 b/drivers/message/fusion/lsi/mpi_ioc.h       |    2 
 b/drivers/message/fusion/lsi/mpi_lan.h       |    2 
 b/drivers/message/fusion/lsi/mpi_log_fc.h    |    2 
 b/drivers/message/fusion/lsi/mpi_log_sas.h   |    2 
 b/drivers/message/fusion/lsi/mpi_raid.h      |    2 
 b/drivers/message/fusion/lsi/mpi_sas.h       |    2 
 b/drivers/message/fusion/lsi/mpi_targ.h      |    2 
 b/drivers/message/fusion/lsi/mpi_tool.h      |    2 
 b/drivers/message/fusion/lsi/mpi_type.h      |    2 
 b/drivers/message/fusion/mptbase.c           |  602 
 b/drivers/message/fusion/mptbase.h           |   80 
 b/drivers/message/fusion/mptctl.c            |  364 
 b/drivers/message/fusion/mptctl.h            |    4 
 b/drivers/message/fusion/mptfc.c             |  149 
 b/drivers/message/fusion/mptlan.c            |   32 
 b/drivers/message/fusion/mptlan.h            |    8 
 b/drivers/message/fusion/mptsas.c            |  468 
 b/drivers/message/fusion/mptsas.h            |  158 
 b/drivers/message/fusion/mptscsih.c          |  643 
 b/drivers/message/fusion/mptscsih.h          |    4 
 b/drivers/message/fusion/mptspi.c            |  211 
 b/drivers/s390/scsi/zfcp_aux.c               |   13 
 b/drivers/s390/scsi/zfcp_ccw.c               |    8 
 b/drivers/s390/scsi/zfcp_def.h               |   46 
 b/drivers/s390/scsi/zfcp_erp.c               |  140 
 b/drivers/s390/scsi/zfcp_ext.h               |   38 
 b/drivers/s390/scsi/zfcp_fsf.c               |  293 
 b/drivers/s390/scsi/zfcp_fsf.h               |   30 
 b/drivers/s390/scsi/zfcp_qdio.c              |    7 
 b/drivers/s390/scsi/zfcp_scsi.c              |   47 
 b/drivers/s390/scsi/zfcp_sysfs_unit.c        |    4 
 b/drivers/scsi/Kconfig                       |   48 
 b/drivers/scsi/Makefile                      |    1 
 b/drivers/scsi/NCR5380.c                     |   31 
 b/drivers/scsi/NCR5380.h                     |    7 
 b/drivers/scsi/NCR53C9x.c                    |    2 
 b/drivers/scsi/NCR_D700.c                    |    5 
 b/drivers/scsi/a4000t.c                      |    7 
 b/drivers/scsi/aacraid/aachba.c              |    8 
 b/drivers/scsi/aacraid/aacraid.h             |    2 
 b/drivers/scsi/aacraid/commsup.c             |    5 
 b/drivers/scsi/advansys.c                    |19980 ++++++++++-----------------
 b/drivers/scsi/aha152x.c                     |    4 
 b/drivers/scsi/aic7xxx_old.c                 |    8 
 b/drivers/scsi/aic94xx/aic94xx_hwi.h         |   12 
 b/drivers/scsi/aic94xx/aic94xx_init.c        |   42 
 b/drivers/scsi/aic94xx/aic94xx_task.c        |    2 
 b/drivers/scsi/arcmsr/arcmsr.h               |  192 
 b/drivers/scsi/arcmsr/arcmsr_attr.c          |   73 
 b/drivers/scsi/arcmsr/arcmsr_hba.c           | 2258 +--
 b/drivers/scsi/atari_NCR5380.c               |   27 
 b/drivers/scsi/bvme6000_scsi.c               |    7 
 b/drivers/scsi/constants.c                   |   16 
 b/drivers/scsi/dc395x.c                      |  110 
 b/drivers/scsi/dpt_i2o.c                     |   29 
 b/drivers/scsi/dtc.c                         |   16 
 b/drivers/scsi/eata.c                        |   44 
 b/drivers/scsi/eata_pio.c                    |  100 
 b/drivers/scsi/esp_scsi.c                    |   10 
 b/drivers/scsi/fdomain.c                     |    5 
 b/drivers/scsi/g_NCR5380.c                   |    2 
 b/drivers/scsi/gdth.c                        | 2933 +--
 b/drivers/scsi/gdth.h                        |   42 
 b/drivers/scsi/gdth_proc.c                   |  133 
 b/drivers/scsi/gdth_proc.h                   |   20 
 b/drivers/scsi/hosts.c                       |    1 
 b/drivers/scsi/hptiop.c                      |   63 
 b/drivers/scsi/hptiop.h                      |  229 
 b/drivers/scsi/ibmmca.c                      |    8 
 b/drivers/scsi/ibmvscsi/Makefile             |    2 
 b/drivers/scsi/ibmvscsi/ibmvscsi.c           |   81 
 b/drivers/scsi/ibmvscsi/ibmvscsi.h           |   32 
 b/drivers/scsi/ibmvscsi/ibmvstgt.c           |   61 
 b/drivers/scsi/ibmvscsi/iseries_vscsi.c      |   37 
 b/drivers/scsi/ibmvscsi/rpa_vscsi.c          |  113 
 b/drivers/scsi/ide-scsi.c                    |  140 
 b/drivers/scsi/imm.c                         |    4 
 b/drivers/scsi/in2000.c                      |   30 
 b/drivers/scsi/ips.c                         |    9 
 b/drivers/scsi/ips.h                         |   11 
 b/drivers/scsi/libsrp.c                      |    5 
 b/drivers/scsi/lpfc/lpfc_debugfs.c           |    5 
 b/drivers/scsi/lpfc/lpfc_init.c              |    4 
 b/drivers/scsi/lpfc/lpfc_scsi.c              |    3 
 b/drivers/scsi/lpfc/lpfc_sli.c               |    2 
 b/drivers/scsi/megaraid.c                    |    3 
 b/drivers/scsi/mvme16x_scsi.c                |    3 
 b/drivers/scsi/ncr53c8xx.c                   |   18 
 b/drivers/scsi/ncr53c8xx.h                   |    2 
 b/drivers/scsi/osst.c                        |   21 
 b/drivers/scsi/osst.h                        |    3 
 b/drivers/scsi/pcmcia/nsp_cs.c               |  159 
 b/drivers/scsi/pcmcia/nsp_cs.h               |    8 
 b/drivers/scsi/pluto.c                       |   11 
 b/drivers/scsi/ps3rom.c                      |   24 
 b/drivers/scsi/qla1280.c                     |    2 
 b/drivers/scsi/qla2xxx/qla_attr.c            |  200 
 b/drivers/scsi/qla2xxx/qla_dbg.c             | 1846 --
 b/drivers/scsi/qla2xxx/qla_dbg.h             |    2 
 b/drivers/scsi/qla2xxx/qla_def.h             |   15 
 b/drivers/scsi/qla2xxx/qla_fw.h              |    6 
 b/drivers/scsi/qla2xxx/qla_gbl.h             |    9 
 b/drivers/scsi/qla2xxx/qla_gs.c              |    6 
 b/drivers/scsi/qla2xxx/qla_init.c            |   40 
 b/drivers/scsi/qla2xxx/qla_iocb.c            |    4 
 b/drivers/scsi/qla2xxx/qla_isr.c             |   88 
 b/drivers/scsi/qla2xxx/qla_mbx.c             |   62 
 b/drivers/scsi/qla2xxx/qla_mid.c             |   40 
 b/drivers/scsi/qla2xxx/qla_os.c              |  140 
 b/drivers/scsi/qla2xxx/qla_sup.c             |  221 
 b/drivers/scsi/qla2xxx/qla_version.h         |    2 
 b/drivers/scsi/qlogicfas.c                   |    2 
 b/drivers/scsi/qlogicpti.c                   |  171 
 b/drivers/scsi/qlogicpti.h                   |    3 
 b/drivers/scsi/scsi.c                        |   26 
 b/drivers/scsi/scsi_devinfo.c                |    1 
 b/drivers/scsi/scsi_error.c                  |  162 
 b/drivers/scsi/scsi_lib.c                    |  123 
 b/drivers/scsi/scsi_priv.h                   |    1 
 b/drivers/scsi/scsi_scan.c                   |   48 
 b/drivers/scsi/scsi_sysfs.c                  |  180 
 b/drivers/scsi/scsi_tgt_if.c                 |   42 
 b/drivers/scsi/scsi_tgt_lib.c                |   85 
 b/drivers/scsi/scsi_tgt_priv.h               |   22 
 b/drivers/scsi/scsi_transport_fc.c           |   35 
 b/drivers/scsi/scsi_transport_fc_internal.h  |   26 
 b/drivers/scsi/scsi_transport_srp.c          |  381 
 b/drivers/scsi/scsi_transport_srp_internal.h |   25 
 b/drivers/scsi/sd.c                          |   76 
 b/drivers/scsi/sg.c                          |  255 
 b/drivers/scsi/sr.c                          |   80 
 b/drivers/scsi/sun3_NCR5380.c                |   22 
 b/drivers/scsi/tmscsim.c                     |   18 
 b/drivers/scsi/u14-34f.c                     |   44 
 b/drivers/scsi/wd33c93.c                     |   32 
 b/drivers/scsi/zorro7xx.c                    |    8 
 b/drivers/usb/image/microtek.c               |   32 
 b/drivers/usb/storage/transport.c            |   46 
 b/include/linux/pci_ids.h                    |    5 
 b/include/scsi/libsrp.h                      |    2 
 b/include/scsi/scsi_cmnd.h                   |   13 
 b/include/scsi/scsi_dbg.h                    |    2 
 b/include/scsi/scsi_driver.h                 |   10 
 b/include/scsi/scsi_eh.h                     |   23 
 b/include/scsi/scsi_host.h                   |   14 
 b/include/scsi/scsi_tgt.h                    |    8 
 b/include/scsi/scsi_tgt_if.h                 |   35 
 b/include/scsi/scsi_transport.h              |   12 
 b/include/scsi/scsi_transport_fc.h           |    6 
 b/include/scsi/scsi_transport_iscsi.h        |    2 
 b/include/scsi/scsi_transport_srp.h          |   39 
 b/include/scsi/sd.h                          |   14 
 drivers/scsi/gdth_kcompat.h                  |   31 
 168 files changed, 15985 insertions(+), 19930 deletions(-)

James


