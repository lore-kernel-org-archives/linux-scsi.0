From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.16+ merge window
Date: Wed, 04 Apr 2018 16:52:13 -0700
Message-ID: <1522885933.4759.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly updates of the usual drivers: arcmsr, qla2xx, lpfc, ufs,
mpt3sas, hisi_sas.  In addition we have removed several really old
drivers: sym53c416, NCR53c406a, fdomain, fdomain_cs and removed the old
scsi_module.c initialization from all remaining drivers.  Plus an
assortment of bug fixes, initialization errors and other minor fixes.

This time there's a really nasty merge between the fixes and misc
branches of the SCSI tree which I've resolved in the merge commit: the
non obvious part is that you have to remove some lines from
qla2xxx/qla_gs.c to avoid a compile failure which would cause bisection
 problems, so I've done that and documented it in the merge commit.  If
you'd like to do it yourself, let me know and I'll send the two
branches separately.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

Adrian Hunter (1):
      scsi: ufs: Add support for Auto-Hibernate Idle Timer

Arnd Bergmann (7):
      scsi: mpt3sas: clarify mmio pointer types
      scsi: qedi: fix build regression
      scsi: sym53c416: avoid section mismatch with LTO
      scsi: NCR53c406a: avoid section mismatch with LTO
      scsi: qedf: use correct strncpy() size
      scsi: qedf: fix LTO-enabled build
      scsi: qedi: fix building with LTO

Bart Van Assche (15):
      scsi: ufs: Fix kernel-doc errors and warnings
      scsi: sd_zbc: Fix sd_zbc_get_seq_zones() kernel-doc header
      scsi: libsas: Fix kernel-doc headers
      scsi: core: Reduce number of scsi_test_unit_ready() retries
      scsi: core: Move the eh_deadline module parameter definition
      scsi: core: scmd_eh_abort_handler(): Add a comment
      scsi: pmcraid: Use sgl_alloc_order() and sgl_free_order()
      scsi: pmcraid: Remove an unused structure member
      scsi: ipr: Use sgl_alloc_order() and sgl_free_order()
      scsi: scsi_debug: Simplify request tag decoding
      scsi: qla2xxx: Fix function argument descriptions
      scsi: qla4xxx: Move an array from a .h into a .c file
      scsi: qla4xxx: Remove unused symbols
      scsi: qla2xxx: Remove unused symbols
      scsi: qla2xxx: Use %p for printing pointers

Ching Huang (4):
      scsi: arcmsr: Change driver version to v1.40.00.05-20180309
      scsi: arcmsr: Sleep to avoid CPU stuck too long for waiting adapter ready
      scsi: arcmsr: Handle adapter removed due to thunderbolt cable disconnection.
      scsi: arcmsr: Rename ACB_F_BUS_HANG_ON to ACB_F_ADAPTER_REMOVED for adapter hot-plug

Christoph Hellwig (11):
      scsi: remove the old scsi_module.c initialization model
      scsi: remove the sym53c416 driver
      scsi: remove the NCR53c406a driver
      scsi: remove the fdomain and fdomain_cs drivers
      scsi: mvme147: stop using scsi_module.c
      scsi: esas2r: remove initialization / cleanup dead wood
      scsi: core: unexport scsi_host_set_state
      scsi: documentation: remove ChangeLog.1992-1997
      scsi: aha1740: stop using scsi_unregister
      scsi: ips: don't set .detect and .release in the host template
      scsi: dpt_i2o: stop using scsi_unregister

Colin Ian King (7):
      scsi: qla2xxx: fix spelling mistake: "existant" -> "existent"
      scsi: lpfc: make several unions static, fix non-ANSI prototype
      scsi: scsi_transport_spi: make two const arrays static, shrinks object size
      scsi: pmcraid: remove redundant initializations of pointer 'ioadl'
      scsi: isci: remove redundant initialization to 'bit'
      scsi: libfc: remove redundant initialization of 'disc'
      scsi: qedf: remove redundant initialization of 'fcport'

Dan Carpenter (3):
      scsi: dpt_i2o: use after free in __adpt_reset()
      scsi: dpt_i2o: use after free in adpt_release()
      scsi: atp870u: 64 bit bug in atp885_init()

Darren Trapp (10):
      scsi: qla2xxx: Cleanup code to improve FC-NVMe error handling
      scsi: qla2xxx: Fix FC-NVMe IO abort during driver reset
      scsi: qla2xxx: Fix retry for PRLI RJT with reason of BUSY
      scsi: qla2xxx: Remove nvme_done_list
      scsi: qla2xxx: Return busy if rport going away
      scsi: qla2xxx: Fix n2n_ae flag to prevent dev_loss on PDB change
      scsi: qla2xxx: Add FC-NVMe abort processing
      scsi: qla2xxx: Add changes for devloss timeout in driver
      scsi: qla2xxx: Set IIDMA and fcport state before qla_nvme_register_remote()
      scsi: qla2xxx: Restore ZIO threshold setting

Don Brace (1):
      scsi: smartpqi: update driver version

Douglas Gilbert (2):
      scsi: core: Make SCSI Status CONDITION MET equivalent to GOOD
      scsi: scsi_debug: implement IMMED bit

Finn Thain (1):
      scsi: jazz_esp, sun3x_esp: Pass struct device pointer in dma calls

Geert Uytterhoeven (1):
      scsi: hisi_sas: Remove depends on HAS_DMA in case of platform dependency

Hannes Reinecke (1):
      scsi: raid_class: Add 'JBOD' RAID level

James Smart (43):
      scsi: lpfc: Change Copyright of 12.0.0.1 modified files to 2018
      scsi: lpfc: update driver version to 12.0.0.1
      scsi: lpfc: Memory allocation error during driver start-up on power8
      scsi: lpfc: Fix mailbox wait for POST_SGL mbox command
      scsi: lpfc: Fix SCSI lun discovery when port configured for both SCSI and NVME
      scsi: lpfc: Streamline NVME Targe6t WQE setup
      scsi: lpfc: Streamline NVME Initiator WQE setup
      scsi: lpfc: Code cleanup for 128byte wqe data type
      scsi: lpfc: Fix NVME Initiator FirstBurst
      scsi: lpfc: Add missing unlock in WQ full logic
      scsi: lpfc: use __raw_writeX on DPP copies
      scsi: lpfc: Change Copyright of 12.0.0.0 modified files to 2018
      scsi: lpfc: update driver version to 12.0.0.0
      scsi: lpfc: Work around NVME cmd iu SGL type
      scsi: lpfc: Fix nvme embedded io length on new hardware
      scsi: lpfc: Add embedded data pointers for enhanced performance
      scsi: lpfc: Enable fw download on if_type=6 devices
      scsi: lpfc: Add if_type=6 support for cycling valid bits
      scsi: lpfc: Add 64G link speed support
      scsi: lpfc: Add PCI Ids for if_type=6 hardware
      scsi: lpfc: Add push-to-adapter support to sli4
      scsi: lpfc: Add SLI-4 if_type=6 support to the code base
      scsi: lpfc: Rework sli4 doorbell infrastructure
      scsi: lpfc: Rework lpfc to allow different sli4 cq and eq handlers
      scsi: lpfc: Update 11.4.0.7 modified files for 2018 Copyright
      scsi: lpfc: update driver version to 11.4.0.7
      scsi: lpfc: Fix nonrecovery of NVME controller after cable swap.
      scsi: lpfc: Treat SCSI Write operation Underruns as an error
      scsi: lpfc: Fix header inclusion in lpfc_nvmet
      scsi: lpfc: Validate adapter support for SRIU option
      scsi: lpfc: Fix SCSI io host reset causing kernel crash
      scsi: lpfc: Indicate CONF support in NVMe PRLI
      scsi: lpfc: Fix issue_lip if link is disabled
      scsi: lpfc: Fix soft lockup in lpfc worker thread during LIP testing
      scsi: lpfc: Allow set of maximum outstanding SCSI cmd limit for a target
      scsi: lpfc: Fix RQ empty firmware trap
      scsi: lpfc: Fix IO failure during hba reset testing with nvme io.
      scsi: lpfc: Fix PRLI handling when topology type changes
      scsi: lpfc: Add WQ Full Logic for NVME Target
      scsi: lpfc: correct debug counters for abort
      scsi: lpfc: move placement of target destroy on driver detach
      scsi: lpfc: Increase CQ and WQ sizes for SCSI
      scsi: lpfc: Fix frequency of Release WQE CQEs

Jianchao Wang (2):
      scsi: core: use blk_mq_requeue_request in __scsi_queue_insert
      scsi: core: fix two wrong indentation cases

John Pittman (2):
      scsi: scsi_dh_alua: Correct comment for alua_alloc_pg()
      scsi: scsi_debug: Fix pointer styling issues

Kevin Barnett (2):
      scsi: smartpqi: workaround fw bug for oq deletion
      scsi: smartpqi: add in new supported controllers

Laurence Oberman (1):
      scsi: scsi_debug: Add two new parameters to scsi_debug driver

Martin K. Petersen (2):
      scsi: documentation: Obsolete documentation references
      scsi: eata: eata-pio: Deprecate legacy EATA drivers

Martin Wilck (2):
      scsi: scsi_debug: call resp_*() function after setting host_scribble
      scsi: scsi_debug: reset injection flags for every_nth > 0

Meelis Roos (2):
      scsi: qla2xxx: fx00 copypaste typo
      scsi: qla2xxx: fix error message on <qla2400

Quinn Tran (1):
      scsi: qla2xxx: Fix Async GPN_FT for FCP and FC-NVMe scan

Raghava Aditya Renukunta (3):
      scsi: aacraid: Auto detect INTx or MSIx mode during sync cmd processing
      scsi: aacraid: Preserve MSIX mode in the OMR register
      scsi: aacraid: Implement DropIO sync command

Souptick Joarder (4):
      scsi: ipr: Use dma_pool_zalloc()
      scsi: megaraid: Use dma_pool_zalloc()
      scsi: qla2xxx: Use dma_pool_zalloc()
      scsi: qla4xxx: Use dma_pool_zalloc()

Stanislav Nijnikov (12):
      scsi: ufs: sysfs: reworking of the rpm_lvl and spm_lvl entries
      scsi: ufs: sysfs: attributes
      scsi: ufs: sysfs: flags
      scsi: ufs: sysfs: unit descriptor
      scsi: core: host template attribute groups
      scsi: ufs: sysfs: string descriptors
      scsi: ufs: sysfs: power descriptor
      scsi: ufs: sysfs: health descriptor
      scsi: ufs: sysfs: geometry descriptor
      scsi: ufs: sysfs: interconnect descriptor
      scsi: ufs: sysfs: device descriptor
      scsi: ufs: sysfs: attribute group for existing sysfs entries.

Stephen Kitt (3):
      scsi: bfa: remove VLA
      scsi: aic7xxx: aic79xx: remove VLAs
      scsi: device_handler: remove VLAs

Suganath Prabu S (1):
      scsi: mpt3sas: Do not use 32-bit atomic request descriptor for Ventura controllers.

Suganath Prabu Subramani (6):
      scsi: mpt3sas: Introduce function to clone mpi reply.
      scsi: mpt3sas: Introduce function to clone mpi request.
      scsi: mpt3sas: Introduce Base function for cloning.
      scsi: mpt3sas: Introduce API to get BAR0 mapped buffer address
      scsi: mpt3sas: Configure reply post queue depth, DMA and sgl tablesize.
      scsi: mpt3sas: Add PCI device ID for Andromeda.

Varun Prakash (1):
      scsi: csiostor: add support for 32 bit port capabilities

Weiping Zhang (1):
      scsi: sd: Documentation: add sd-parameters.txt

Wilfried Weissmann (1):
      scsi: mvsas: fix wrong endianness of sgpio api

Xiang Chen (3):
      scsi: hisi_sas: add v3 hw MODULE_DEVICE_TABLE()
      scsi: hisi_sas: Code cleanup and minor bug fixes
      scsi: hisi_sas: remove unused variable hisi_sas_devices.running_req

Xiaofei Tan (7):
      scsi: hisi_sas: modify some register config for hip08
      scsi: hisi_sas: fix return value of hisi_sas_task_prep()
      scsi: hisi_sas: increase timer expire of internal abort task
      scsi: hisi_sas: fix the issue of setting linkrate register
      scsi: hisi_sas: fix the issue of link rate inconsistency
      scsi: hisi_sas: support the property of signal attenuation for v2 hw
      scsi: hisi_sas: dt-bindings: add an property of signal attenuation

Xose Vazquez Perez (3):
      scsi: devinfo: remove dasd devices from the scsi subsystem
      scsi: devinfo: remove DF arrays from HP
      scsi: devinfo: add HP DISK-SUBSYSTEM device, for HP XP arrays

himanshu.madhani@cavium.com (2):
      scsi: qla2xxx: Update driver version to 10.00.00.06-k
      scsi: qla2xxx: Remove unneeded message and minor cleanup for FC-NVMe

And the diffstat

 Documentation/ABI/testing/sysfs-driver-ufs         |  885 +++++++
 .../devicetree/bindings/scsi/hisilicon-sas.txt     |    7 +
 Documentation/driver-api/scsi.rst                  |    6 -
 Documentation/scsi/ChangeLog.1992-1997             | 2023 ---------------
 Documentation/scsi/Mylex.txt                       |    5 -
 Documentation/scsi/scsi-parameters.txt             |   14 -
 Documentation/scsi/scsi_mid_low_api.txt            |  122 +-
 Documentation/scsi/sd-parameters.txt               |   22 +
 Documentation/scsi/tmscsim.txt                     |  443 ----
 MAINTAINERS                                        |   12 -
 arch/powerpc/configs/c2k_defconfig                 |    1 -
 drivers/scsi/Kconfig                               |  114 +-
 drivers/scsi/Makefile                              |    5 -
 drivers/scsi/NCR53c406a.c                          | 1090 ---------
 drivers/scsi/aacraid/aacraid.h                     |    5 +
 drivers/scsi/aacraid/src.c                         |  205 +-
 drivers/scsi/aha1740.c                             |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |    8 +-
 drivers/scsi/aic7xxx/aic79xx_seq.h_shipped         |    3 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    8 +-
 drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped         |    3 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.c               |    3 +-
 drivers/scsi/arcmsr/arcmsr.h                       |    4 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |   90 +
 drivers/scsi/atp870u.c                             |    4 +-
 drivers/scsi/bfa/bfad_bsg.c                        |    2 +-
 drivers/scsi/csiostor/csio_attr.c                  |   16 +-
 drivers/scsi/csiostor/csio_hw.c                    |  275 ++-
 drivers/scsi/csiostor/csio_hw.h                    |   59 +
 drivers/scsi/csiostor/csio_lnode.c                 |    8 +
 drivers/scsi/csiostor/csio_mb.c                    |   70 +-
 drivers/scsi/csiostor/csio_mb.h                    |    9 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   10 +-
 drivers/scsi/device_handler/scsi_dh_emc.c          |    2 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c         |    2 +-
 drivers/scsi/dpt_i2o.c                             |   27 +-
 drivers/scsi/dpti.h                                |    1 -
 drivers/scsi/eata.c                                | 2571 --------------------
 drivers/scsi/eata_generic.h                        |  401 ---
 drivers/scsi/eata_pio.c                            |  966 --------
 drivers/scsi/eata_pio.h                            |   54 -
 drivers/scsi/esas2r/esas2r.h                       |    2 -
 drivers/scsi/esas2r/esas2r_init.c                  |   21 -
 drivers/scsi/esas2r/esas2r_main.c                  |   72 +-
 drivers/scsi/fdomain.c                             | 1783 --------------
 drivers/scsi/fdomain.h                             |   24 -
 drivers/scsi/hisi_sas/Kconfig                      |    2 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |    1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   34 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   13 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   62 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   72 +-
 drivers/scsi/hosts.c                               |   36 +-
 drivers/scsi/ipr.c                                 |   53 +-
 drivers/scsi/ipr.h                                 |    2 +-
 drivers/scsi/ips.c                                 |    4 -
 drivers/scsi/isci/host.c                           |    2 +-
 drivers/scsi/jazz_esp.c                            |    2 +-
 drivers/scsi/libfc/fc_disc.c                       |    2 +-
 drivers/scsi/libsas/sas_ata.c                      |    2 +-
 drivers/scsi/libsas/sas_discover.c                 |   13 +-
 drivers/scsi/libsas/sas_expander.c                 |   29 +-
 drivers/scsi/libsas/sas_init.c                     |    2 +-
 drivers/scsi/libsas/sas_port.c                     |    5 +-
 drivers/scsi/lpfc/lpfc.h                           |   23 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  107 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |    6 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    5 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |    8 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   22 +-
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   13 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   11 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   13 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |   15 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |  141 +-
 drivers/scsi/lpfc/lpfc_ids.h                       |    4 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  320 ++-
 drivers/scsi/lpfc/lpfc_mbox.c                      |   10 +-
 drivers/scsi/lpfc/lpfc_mem.c                       |   12 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   22 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  427 ++--
 drivers/scsi/lpfc/lpfc_nvme.h                      |    4 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  470 +++-
 drivers/scsi/lpfc/lpfc_nvmet.h                     |   10 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   64 +-
 drivers/scsi/lpfc/lpfc_scsi.h                      |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  692 ++++--
 drivers/scsi/lpfc/lpfc_sli.h                       |    6 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   42 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |    3 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h               |    1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  699 ++++--
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   19 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   22 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   74 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |    8 +-
 drivers/scsi/mvme147.c                             |  107 +-
 drivers/scsi/mvsas/mv_94xx.c                       |   23 +-
 drivers/scsi/pcmcia/Kconfig                        |    9 -
 drivers/scsi/pcmcia/Makefile                       |    2 -
 drivers/scsi/pcmcia/fdomain_core.c                 |    2 -
 drivers/scsi/pcmcia/fdomain_stub.c                 |  209 --
 drivers/scsi/pmcraid.c                             |   51 +-
 drivers/scsi/pmcraid.h                             |    3 +-
 drivers/scsi/qedf/qedf_dbg.c                       |    2 +-
 drivers/scsi/qedf/qedf_dbg.h                       |   17 +-
 drivers/scsi/qedf/qedf_debugfs.c                   |    6 +-
 drivers/scsi/qedf/qedf_io.c                        |    2 +-
 drivers/scsi/qedf/qedf_main.c                      |    8 +-
 drivers/scsi/qedi/qedi_dbg.h                       |    4 +-
 drivers/scsi/qedi/qedi_debugfs.c                   |    4 +-
 drivers/scsi/qedi/qedi_gbl.h                       |    4 +-
 drivers/scsi/qedi/qedi_main.c                      |    4 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |    3 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |    8 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   12 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    4 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  353 ++-
 drivers/scsi/qla2xxx/qla_init.c                    |   72 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |    1 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |   25 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  101 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   33 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |    6 -
 drivers/scsi/qla2xxx/qla_mr.c                      |   36 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  245 +-
 drivers/scsi/qla2xxx/qla_nvme.h                    |    9 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |    7 +-
 drivers/scsi/qla2xxx/qla_nx2.c                     |   19 +-
 drivers/scsi/qla2xxx/qla_nx2.h                     |    4 -
 drivers/scsi/qla2xxx/qla_os.c                      |   14 +-
 drivers/scsi/qla2xxx/qla_sup.c                     |    1 +
 drivers/scsi/qla2xxx/qla_target.c                  |   29 +-
 drivers/scsi/qla2xxx/qla_target.h                  |    2 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |    6 +-
 drivers/scsi/qla4xxx/ql4_nx.c                      |    2 +
 drivers/scsi/qla4xxx/ql4_nx.h                      |    7 -
 drivers/scsi/qla4xxx/ql4_os.c                      |    4 +-
 drivers/scsi/raid_class.c                          |    1 +
 drivers/scsi/scsi.c                                |    2 +-
 drivers/scsi/scsi_debug.c                          |  241 +-
 drivers/scsi/scsi_devinfo.c                        |   13 +-
 drivers/scsi/scsi_error.c                          |    8 +-
 drivers/scsi/scsi_lib.c                            |   27 +-
 drivers/scsi/scsi_module.c                         |   73 -
 drivers/scsi/scsi_sysfs.c                          |   11 +
 drivers/scsi/scsi_transport_spi.c                  |    4 +-
 drivers/scsi/sd_zbc.c                              |    3 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   89 +-
 drivers/scsi/sun3x_esp.c                           |    2 +-
 drivers/scsi/sym53c416.c                           |  844 -------
 drivers/scsi/sym53c416.h                           |   33 -
 drivers/scsi/ufs/Makefile                          |    3 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c                 |    4 +-
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c              |    2 +-
 drivers/scsi/ufs/ufs-sysfs.c                       |  817 +++++++
 drivers/scsi/ufs/ufs-sysfs.h                       |   17 +
 drivers/scsi/ufs/ufs.h                             |  115 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |    7 +-
 drivers/scsi/ufs/ufshcd.c                          |  338 +--
 drivers/scsi/ufs/ufshcd.h                          |   37 +
 drivers/scsi/ufs/ufshci.h                          |    7 +
 include/linux/raid_class.h                         |    1 +
 include/scsi/scsi.h                                |    2 +
 include/scsi/scsi_host.h                           |   36 +-
 168 files changed, 6214 insertions(+), 13066 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ufs
 delete mode 100644 Documentation/scsi/ChangeLog.1992-1997
 delete mode 100644 Documentation/scsi/Mylex.txt
 create mode 100644 Documentation/scsi/sd-parameters.txt
 delete mode 100644 Documentation/scsi/tmscsim.txt
 delete mode 100644 drivers/scsi/NCR53c406a.c
 delete mode 100644 drivers/scsi/eata.c
 delete mode 100644 drivers/scsi/eata_generic.h
 delete mode 100644 drivers/scsi/eata_pio.c
 delete mode 100644 drivers/scsi/eata_pio.h
 delete mode 100644 drivers/scsi/fdomain.c
 delete mode 100644 drivers/scsi/fdomain.h
 delete mode 100644 drivers/scsi/pcmcia/fdomain_core.c
 delete mode 100644 drivers/scsi/pcmcia/fdomain_stub.c
 delete mode 100644 drivers/scsi/scsi_module.c
 delete mode 100644 drivers/scsi/sym53c416.c
 delete mode 100644 drivers/scsi/sym53c416.h
 create mode 100644 drivers/scsi/ufs/ufs-sysfs.c
 create mode 100644 drivers/scsi/ufs/ufs-sysfs.h

James
