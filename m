From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.18+ merge window
Date: Mon, 08 Dec 2014 12:15:37 -0800
Message-ID: <1418069737.2141.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch is the usual mix of driver updates (srp, ipr, scsi_debug,
NCR5380, fnic, 53c974, ses, wd719x, hpsa, megaraid_sas).  Of those,
wd7a9x is new and 53c974 is a rewrite of the old tmscsim driver and the
extensive work by Finn Thain rewrites all the NCR5380 based drivers.
There's also extensive infrastructure updates: a new logging
infrastructure for sense information and a rewrite of the tagged command
queue API and an assortment of minor updates.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

Anton Blanchard (2):
      ipr: set coherent DMA mask
      ipr: convert to generic DMA API

Bart Van Assche (11):
      IB/srp: Fix a race condition triggered by destroying a queue pair
      IB/srp: Add multichannel support
      IB/srp: Use block layer tags
      IB/srp: Separate target and channel variables
      IB/srp: Introduce two new srp_target_port member variables
      IB/srp: Avoid that I/O hangs due to a cable pull during LUN scanning
      IB/srp: Remove stale connection retry mechanism
      IB/srp: Move ib_destroy_cm_id() call into srp_free_ch_ib()
      scsi: add support for multiple hardware queues in scsi_(host_)find_tag
      scsi: add support for multiple hardware queues
      blk-mq: add blk_mq_unique_tag()

Chen Gang (1):
      qla2xxx: remove redundant declaration in 'qla_gbl.h'

Christoph Hellwig (37):
      libsas: remove task_collector mode
      scsi: remove scsi_driver owner field
      scsi: move scsi_dispatch_cmd to scsi_lib.c
      scsi: stop passing a gfp_mask argument down the command setup path
      scsi: remove scsi_next_command
      scsi: don't use scsi_next_command in scsi_reset_provider
      vmw_pscsi: simplify ->change_queue_depth
      mpt3sas: simplify ->change_queue_depth
      mpt2sas: simplify ->change_queue_depth
      scsi: drop reason argument from ->change_queue_depth
      scsi: don't allow setting of queue_depth bigger than can_queue
      scsi: avoid ->change_queue_depth indirection for queue full tracking
      lpfc: remove queue_depth events
      ufs: remove spurious scsi_set_tag_type call
      scsi: don't force tagged_supported in drivers
      scsi: don't set tagging state from scsi_adjust_queue_depth
      scsi: always assign block layer tags if enabled
      scsi: remove use_blk_tcq Scsi_Host field
      mptfusion: don't change queue type in ->change_queue_depth
      scsi: remove abuses of scsi_populate_tag
      scsi: remove ordered_tag host template field
      scsi: remove ordered_tags scsi_device field
      scsi: add new scsi-command flag for tagged commands
      scsi: provide a generic change_queue_type method
      scsi: handle more device handler setup/teardown in common code
      scsi: device handlers must have attach and detach methods
      scsi: remove struct scsi_dh_devlist
      scsi: use container_of to get at device handler private data
      scsi_dh: get module reference outside of device handler
      scsi_dh_hp_sw: fix return value on failed allocation
      scsi: return EAGAIN when resetting a device under EH
      osst: call scsi_set_medium_removal directly
      st: call scsi_set_medium_removal directly
      sd: fix up ->compat_ioctl
      scsi: split scsi_nonblockable_ioctl
      scsi: refactor scsi_reset_provider handling
      scsi: PC partition tables are little endian

Dan Carpenter (3):
      scsi: set fmt to NULL scsi_extd_sense_format() by default
      bnx2fc: fix an error code in _bnx2fc_create()
      bnx2fc: check IS_ERR() instead of NULL

Don Brace (1):
      hpsa: Clean up warnings from sparse.

Douglas Gilbert (6):
      scsi_debug: add Report supported opcodes+tmfs; Compare and write
      scsi_debug: change SCSI command parser to table driven
      scsi_debug: add Capacity Changed Unit Attention
      scsi_debug: append inject error flags onto scsi_cmnd object
      scsi_debug: pinpoint invalid field in sense data
      scsi: add SG_SCSI_RESET_NO_ESCALATE flag to SG_SCSI_RESET ioctl

Fabian Frederick (1):
      bfa: replace 2 kzalloc/copy_from_user by memdup_user

Finn Thain (39):
      atari_NCR5380: Fix "transfered" typo
      atari_NCR5380: Remove RESET_RUN_DONE macro
      atari_NCR5380: Move static co-routine variables to host data
      atari_NCR5380: Move static TagAlloc array to host data
      atari_NCR5380: Introduce FLAG_TAGGED_QUEUING
      atari_NCR5380: Merge from NCR5380.c
      sun3_scsi: Adopt atari_NCR5380 core driver and remove sun3_NCR5380.c
      atari_NCR5380: Merge from sun3_NCR5380.c
      atari_NCR5380: Refactor Falcon locking
      atari_NCR5380: Refactor Falcon special cases
      ncr5380: Remove ENABLE_IRQ/DISABLE_IRQ macros
      sun3_scsi: Move macro definitions
      sun3_scsi: Convert to platform device
      atari_scsi: Remove header
      atari_scsi: Convert to platform device
      atari_scsi: Fix atari_scsi deadlocks on Falcon
      mac_scsi: Convert to platform device
      mac_scsi: Cleanup PDMA code
      mac_scsi: Add module option to Kconfig
      mac_scsi: Remove header
      dmx3191d: Use NO_IRQ
      ncr5380: Drop legacy scsi.h include
      ncr5380: Remove *_RELEASE macros
      ncr5380: Remove pointless compiler command line override macros
      ncr5380: Move static PDMA spin counters to host data
      ncr5380: Cleanup host info() methods
      ncr5380: Remove NCR5380_STATS
      ncr5380: Fix SCSI_IRQ_NONE bugs
      ncr5380: Remove duplicate comments
      ncr5380: Remove redundant AUTOSENSE macro
      ncr5380: Cleanup TAG_NEXT and TAG_NONE macros
      ncr5380: Remove more useless prototypes
      ncr5380: Remove useless prototypes
      ncr5380: Remove unused macros
      ncr5380: Fix compiler warnings and __setup options
      ncr5380: Remove unused hostdata fields
      ncr5380: Use printk() not pr_debug()
      scsi_debug: error message should say scsi_host_alloc not scsi_register
      tmscim: remove unused SCSI_IRQ_NONE macro definition

Hannes Reinecke (40):
      scsi: add SPC-3 command definitions
      scsi: rename SERVICE_ACTION_IN to SERVICE_ACTION_IN_16
      tmscsim: replace by am53c974 driver
      esp_scsi: enable CONFIG2_FENAB for am53c974
      esp_scsi: correctly detect am53c974
      am53c974: BLAST residual handling
      am53c974: add new driver
      esp_scsi: use FIFO for command submission
      esp_scsi: read status registers
      esp_scsi: debug event and command
      esp_scsi: convert to dev_printk
      esp_scsi: make number of tags configurable
      esp_scsi: spellcheck 'driver'
      vmw_pvscsi: fixup tagging
      scsi: ratelimit I/O error messages
      scsi: correct return values for .eh_abort_handler implementations
      scsi: document scsi_try_to_abort_cmd
      scsi: use shost argument in scsi_eh_prt_fail_stats
      scsi: fixup logging messages in scsi_error.c
      scsi: simplify scsi_log_(send|completion)
      scsi: remove scsi_show_result()
      scsi: separate out scsi_(host|driver)byte_string()
      scsi: Remove scsi_print_command when calling abort
      scsi: repurpose the last argument from print_opcode_name()
      scsi: consolidate opcode lookup in scsi_opcode_sa_name()
      scsi: merge print_opcode_name()
      scsi: implement scsi_opcode_sa_name
      scsi: remove scsi_print_status()
      scsi: use 'bool' as return value for scsi_normalize_sense()
      scsi: do not decode sense extras
      scsi: stop decoding if scsi_normalize_sense() fails
      53c700: remove scsi_print_sense() usage
      fas216: update logging messages
      fas216: return DID_ERROR for incomplete data transfer
      acornscsi: use scsi_print_command()
      scsi: use sdev as argument for sense code printing
      scsi: introduce sdev_prefix_printk()
      aha152x: debug output update and whitespace cleanup
      sd: remove scsi_print_sense() in sd_done()
      scsi: remove scsi_cmd_print_sense_hdr()

Hiral Shah (5):
      Fnic: Fnic Driver crashed with NULL pointer reference
      Fnic: For Standalone C series, "sending VLAN request" message seen even if the link is down
      Fnic: Improper resue of exchange Ids
      Fnic: Memcopy only mimumum of data or trace buffer
      Fnic: Not probing all the vNICS via fnic_probe on boot

Laurence Oberman (1):
      st: add a debug_flag module parameter request

Mark Knibbs (2):
      scsi: fix off-by-one LUN check in scsi_scan_host_selected()
      scsi: fix trivial typos in scsi_scan.c comment

Mark Rustad (1):
      scsi: resolve some missing-field-initializers warnings

Markus Stockhausen (1):
      enclosure: handle non-unique element descriptors

Martin K. Petersen (1):
      sd: disable discard_zeroes_data for UNMAP

Martin Peschke (2):
      zfcp: auto port scan resiliency
      zfcp: remove access control tables interface (port leftovers)

Ming Lei (1):
      virtio_scsi: support multi hw queue of blk-mq

Nicholas Bellinger (1):
      hpsa: Convert SCSI LLD ->queuecommand() for host_lock less operation

Ondrej Zary (4):
      wd719x: remove dma_cache_sync call
      wd719x: Add firmware documentation
      wd719x: Introduce Western Digital WD7193/7197/7296 PCI SCSI card driver
      eeprom-93cx6: Add (read-only) support for 8-bit mode

Paolo Bonzini (1):
      esp_scsi: let DMA driver provide a config2 value

Robert Elliott (2):
      hpsa: always call pci_set_master after pci_enable_device
      hpsa: remove dev_warn prints from RAID-1ADM

Steffen Maier (1):
      zfcp: bring back unit sysfs attributes for automatic LUN scan

Stephen M. Cameron (8):
      hpsa: remove spin lock around command allocation
      hpsa: do not be so noisy about check conditions
      hpsa: use atomics for commands_outstanding
      hpsa: get rid of type/attribute/direction bit field where possible
      hpsa: fix endianness issue with scatter gather elements
      hpsa: fix allocation sizes for CISS_REPORT_LUNs commands
      hpsa: remove 'action required' phrasing
      hpsa: fix a couple pci id table mistakes

Sumit.Saxena@avagotech.com (7):
      megaraid_sas: do not process IOCTLs and SCSI commands during driver removal
      megaraid_sas: dndinaness related bug fixes
      megaraid_sas: corrected return of wait_event from abort frame path
      megaraid_sas: make HBA operational after LD_MAP_SYNC DCMD in OCR path
      megaraid_sas: online Firmware upgrade support for Extended VD feature
      megaraid_sas: update MAINTAINERS and copyright information for megaraid drivers
      megaraid_sas: driver version upgrade and remove some meta data of driver

Tomas Henzl (3):
      esas2r: fix an oversight in setting return value
      esas2r: fix an error path in esas2r_ioctl_handler
      esas2r: fir error handling in do_fm_api

Webb Scales (1):
      hpsa: correct off-by-one sizing of chained SG block

and the diffstat

 Documentation/ABI/stable/sysfs-driver-ib_srp |   25 +-
 Documentation/block/biodoc.txt               |    4 -
 Documentation/scsi/libsas.txt                |   82 +-
 Documentation/scsi/scsi_mid_low_api.txt      |   66 +-
 Documentation/scsi/st.txt                    |    8 +-
 Documentation/scsi/wd719x.txt                |   21 +
 MAINTAINERS                                  |   17 +-
 arch/m68k/atari/config.c                     |   27 +
 arch/m68k/atari/stdma.c                      |   61 +-
 arch/m68k/include/asm/atari_stdma.h          |    4 +-
 arch/m68k/include/asm/macintosh.h            |    4 +
 arch/m68k/mac/config.c                       |  146 +-
 arch/m68k/sun3/config.c                      |   60 +
 block/blk-core.c                             |    4 +-
 block/blk-mq-tag.c                           |   28 +
 block/blk-mq.c                               |    2 +
 block/scsi_ioctl.c                           |    2 +-
 drivers/ata/libata-scsi.c                    |   19 +-
 drivers/ata/sata_nv.c                        |    2 +-
 drivers/block/nvme-scsi.c                    |    4 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    3 +-
 drivers/infiniband/ulp/srp/ib_srp.c          | 1100 ++++++----
 drivers/infiniband/ulp/srp/ib_srp.h          |   75 +-
 drivers/message/fusion/mptsas.c              |    1 +
 drivers/message/fusion/mptscsih.c            |   22 +-
 drivers/message/fusion/mptscsih.h            |    3 +-
 drivers/misc/eeprom/eeprom_93cx6.c           |   62 +-
 drivers/misc/enclosure.c                     |   44 +-
 drivers/s390/scsi/zfcp_aux.c                 |    6 +-
 drivers/s390/scsi/zfcp_ccw.c                 |   32 +-
 drivers/s390/scsi/zfcp_def.h                 |    3 +-
 drivers/s390/scsi/zfcp_erp.c                 |    7 -
 drivers/s390/scsi/zfcp_ext.h                 |    1 +
 drivers/s390/scsi/zfcp_fc.c                  |   52 +-
 drivers/s390/scsi/zfcp_fc.h                  |   14 +-
 drivers/s390/scsi/zfcp_fsf.c                 |    3 +-
 drivers/s390/scsi/zfcp_scsi.c                |   26 +-
 drivers/s390/scsi/zfcp_sysfs.c               |   66 +-
 drivers/scsi/3w-9xxx.c                       |   15 +-
 drivers/scsi/3w-sas.c                        |   15 +-
 drivers/scsi/3w-xxxx.c                       |   15 +-
 drivers/scsi/53c700.c                        |   51 +-
 drivers/scsi/BusLogic.c                      |    4 +-
 drivers/scsi/Kconfig                         |   18 +-
 drivers/scsi/Makefile                        |    3 +-
 drivers/scsi/NCR5380.c                       |  310 +--
 drivers/scsi/NCR5380.h                       |   78 +-
 drivers/scsi/aacraid/aachba.c                |    4 +-
 drivers/scsi/aacraid/linit.c                 |   20 +-
 drivers/scsi/advansys.c                      |   11 +-
 drivers/scsi/aha152x.c                       |  994 ++-------
 drivers/scsi/aha1740.c                       |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c           |   19 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c           |   23 +-
 drivers/scsi/aic94xx/aic94xx.h               |    2 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c           |    3 +-
 drivers/scsi/aic94xx/aic94xx_init.c          |   13 +-
 drivers/scsi/aic94xx/aic94xx_task.c          |   13 +-
 drivers/scsi/am53c974.c                      |  586 +++++
 drivers/scsi/arcmsr/arcmsr_hba.c             |    9 +-
 drivers/scsi/arm/acornscsi.c                 |   12 +-
 drivers/scsi/arm/cumana_1.c                  |   18 +-
 drivers/scsi/arm/fas216.c                    |   39 +-
 drivers/scsi/arm/oak.c                       |   23 +-
 drivers/scsi/atari_NCR5380.c                 |  986 +++++----
 drivers/scsi/atari_scsi.c                    |  673 +++---
 drivers/scsi/atari_scsi.h                    |   60 -
 drivers/scsi/be2iscsi/be_main.c              |    4 +-
 drivers/scsi/bfa/bfad_debugfs.c              |   30 +-
 drivers/scsi/bfa/bfad_im.c                   |   18 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c            |    9 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c              |   18 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c             |    3 +-
 drivers/scsi/ch.c                            |   36 +-
 drivers/scsi/constants.c                     |  599 +++---
 drivers/scsi/csiostor/csio_scsi.c            |   37 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c           |    3 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c           |    3 +-
 drivers/scsi/device_handler/scsi_dh.c        |   55 +-
 drivers/scsi/device_handler/scsi_dh_alua.c   |   82 +-
 drivers/scsi/device_handler/scsi_dh_emc.c    |   86 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c  |   81 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c   |   82 +-
 drivers/scsi/dmx3191d.c                      |   31 +-
 drivers/scsi/dpt_i2o.c                       |    4 +-
 drivers/scsi/dtc.c                           |   85 +-
 drivers/scsi/dtc.h                           |   26 +-
 drivers/scsi/eata.c                          |    8 +-
 drivers/scsi/esas2r/esas2r.h                 |    5 -
 drivers/scsi/esas2r/esas2r_ioctl.c           |   22 +-
 drivers/scsi/esas2r/esas2r_main.c            |   64 +-
 drivers/scsi/esp_scsi.c                      |  428 ++--
 drivers/scsi/esp_scsi.h                      |   22 +-
 drivers/scsi/fcoe/fcoe.c                     |    6 +-
 drivers/scsi/fnic/fnic.h                     |    2 +-
 drivers/scsi/fnic/fnic_fcs.c                 |    5 +
 drivers/scsi/fnic/fnic_main.c                |   23 +-
 drivers/scsi/fnic/fnic_scsi.c                |   43 +-
 drivers/scsi/fnic/fnic_trace.c               |    4 +-
 drivers/scsi/g_NCR5380.c                     |  224 +-
 drivers/scsi/g_NCR5380.h                     |   26 +-
 drivers/scsi/gdth.c                          |    5 +-
 drivers/scsi/hosts.c                         |    5 +-
 drivers/scsi/hpsa.c                          |  509 ++---
 drivers/scsi/hpsa.h                          |   33 +-
 drivers/scsi/hpsa_cmd.h                      |   34 +-
 drivers/scsi/hptiop.c                        |    8 +-
 drivers/scsi/ibmvscsi/ibmvfc.c               |   58 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c             |   11 +-
 drivers/scsi/ipr.c                           |  175 +-
 drivers/scsi/ipr.h                           |    2 +-
 drivers/scsi/ips.c                           |    2 +-
 drivers/scsi/isci/init.c                     |    4 +-
 drivers/scsi/isci/task.c                     |  147 +-
 drivers/scsi/isci/task.h                     |    1 -
 drivers/scsi/iscsi_tcp.c                     |    3 +-
 drivers/scsi/libfc/fc_fcp.c                  |   52 +-
 drivers/scsi/libiscsi.c                      |   19 -
 drivers/scsi/libsas/sas_ata.c                |    9 +-
 drivers/scsi/libsas/sas_expander.c           |    2 +-
 drivers/scsi/libsas/sas_init.c               |   21 -
 drivers/scsi/libsas/sas_internal.h           |    2 -
 drivers/scsi/libsas/sas_scsi_host.c          |  223 +-
 drivers/scsi/lpfc/lpfc_scsi.c                |  158 +-
 drivers/scsi/mac_scsi.c                      |  552 +++--
 drivers/scsi/mac_scsi.h                      |   74 -
 drivers/scsi/megaraid.c                      |    8 +-
 drivers/scsi/megaraid/megaraid_mbox.c        |   23 +-
 drivers/scsi/megaraid/megaraid_sas.h         |   23 +-
 drivers/scsi/megaraid/megaraid_sas_base.c    |  164 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c      |   33 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c  |  112 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h  |   18 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |   82 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c         |   84 +-
 drivers/scsi/mvsas/mv_init.c                 |   24 +-
 drivers/scsi/mvsas/mv_sas.c                  |  109 +-
 drivers/scsi/mvsas/mv_sas.h                  |   10 +-
 drivers/scsi/ncr53c8xx.c                     |    5 +-
 drivers/scsi/osd/osd_uld.c                   |    2 +-
 drivers/scsi/osst.c                          |   29 +-
 drivers/scsi/pas16.c                         |  106 +-
 drivers/scsi/pas16.h                         |   21 +-
 drivers/scsi/pm8001/pm8001_init.c            |    4 +-
 drivers/scsi/pm8001/pm8001_sas.c             |   22 +-
 drivers/scsi/pm8001/pm8001_sas.h             |    3 +-
 drivers/scsi/pmcraid.c                       |   94 +-
 drivers/scsi/ps3rom.c                        |    4 -
 drivers/scsi/qla1280.c                       |    5 +-
 drivers/scsi/qla2xxx/qla_gbl.h               |    2 -
 drivers/scsi/qla2xxx/qla_iocb.c              |   92 +-
 drivers/scsi/qla2xxx/qla_mr.c                |   13 -
 drivers/scsi/qla2xxx/qla_nx2.c               |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                |   83 +-
 drivers/scsi/qla4xxx/ql4_iocb.c              |   10 -
 drivers/scsi/qla4xxx/ql4_os.c                |   35 +-
 drivers/scsi/scsi.c                          |  211 +-
 drivers/scsi/scsi_debug.c                    | 2007 ++++++++++++------
 drivers/scsi/scsi_error.c                    |  211 +-
 drivers/scsi/scsi_ioctl.c                    |   74 +-
 drivers/scsi/scsi_lib.c                      |  165 +-
 drivers/scsi/scsi_logging.h                  |    1 +
 drivers/scsi/scsi_priv.h                     |    2 -
 drivers/scsi/scsi_scan.c                     |   27 +-
 drivers/scsi/scsi_sysfs.c                    |   18 +-
 drivers/scsi/scsi_trace.c                    |    2 +-
 drivers/scsi/scsi_transport_spi.c            |   23 +
 drivers/scsi/scsicam.c                       |    4 +-
 drivers/scsi/sd.c                            |  114 +-
 drivers/scsi/sd.h                            |    6 +-
 drivers/scsi/ses.c                           |    2 +-
 drivers/scsi/sg.c                            |   62 +-
 drivers/scsi/sr.c                            |   19 +-
 drivers/scsi/sr.h                            |    3 +-
 drivers/scsi/sr_ioctl.c                      |   10 +-
 drivers/scsi/st.c                            |   47 +-
 drivers/scsi/stex.c                          |   30 +-
 drivers/scsi/storvsc_drv.c                   |    6 +-
 drivers/scsi/sun3_NCR5380.c                  | 2933 --------------------------
 drivers/scsi/sun3_scsi.c                     |  512 ++---
 drivers/scsi/sun3_scsi.h                     |   84 -
 drivers/scsi/sym53c8xx_2/sym_glue.c          |    4 +-
 drivers/scsi/t128.c                          |   83 +-
 drivers/scsi/t128.h                          |   23 +-
 drivers/scsi/tmscsim.c                       | 2620 -----------------------
 drivers/scsi/tmscsim.h                       |  551 -----
 drivers/scsi/u14-34f.c                       |   10 +-
 drivers/scsi/ufs/ufshcd.c                    |   39 +-
 drivers/scsi/virtio_scsi.c                   |   40 +-
 drivers/scsi/vmw_pvscsi.c                    |   32 +-
 drivers/scsi/wd7000.c                        |    1 -
 drivers/scsi/wd719x.c                        |  996 +++++++++
 drivers/scsi/wd719x.h                        |  249 +++
 drivers/target/loopback/tcm_loop.c           |   75 +-
 drivers/target/target_core_alua.c            |    2 +-
 drivers/target/target_core_pr.c              |    2 +-
 drivers/target/target_core_sbc.c             |    2 +-
 drivers/usb/gadget/legacy/tcm_usb_gadget.c   |    2 +-
 drivers/usb/storage/debug.c                  |   10 +-
 drivers/usb/storage/uas.c                    |    7 +-
 drivers/xen/xen-scsiback.c                   |    4 -
 include/linux/blk-mq.h                       |   17 +
 include/linux/blkdev.h                       |    1 -
 include/linux/eeprom_93cx6.h                 |    4 +
 include/linux/libata.h                       |    4 +-
 include/scsi/libfc.h                         |    2 -
 include/scsi/libiscsi.h                      |    2 -
 include/scsi/libsas.h                        |   17 +-
 include/scsi/scsi.h                          |   12 +-
 include/scsi/scsi_cmnd.h                     |    6 +-
 include/scsi/scsi_dbg.h                      |   28 +-
 include/scsi/scsi_device.h                   |   21 +-
 include/scsi/scsi_driver.h                   |    1 -
 include/scsi/scsi_eh.h                       |   24 +-
 include/scsi/scsi_host.h                     |   39 +-
 include/scsi/scsi_ioctl.h                    |    4 +-
 include/scsi/scsi_tcq.h                      |   87 +-
 include/scsi/scsi_transport_spi.h            |    1 +
 include/scsi/sg.h                            |    5 +-
 include/trace/events/scsi.h                  |    2 +-
 include/trace/events/target.h                |    2 +-
 tools/lib/traceevent/plugin_scsi.c           |    9 +-
 222 files changed, 8454 insertions(+), 14789 deletions(-)
 create mode 100644 Documentation/scsi/wd719x.txt
 create mode 100644 drivers/scsi/am53c974.c
 delete mode 100644 drivers/scsi/atari_scsi.h
 delete mode 100644 drivers/scsi/mac_scsi.h
 delete mode 100644 drivers/scsi/sun3_NCR5380.c
 delete mode 100644 drivers/scsi/tmscsim.c
 delete mode 100644 drivers/scsi/tmscsim.h
 create mode 100644 drivers/scsi/wd719x.c
 create mode 100644 drivers/scsi/wd719x.h

James
