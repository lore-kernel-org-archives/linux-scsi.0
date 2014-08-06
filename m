From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.16+ merge window
Date: Wed, 06 Aug 2014 10:28:27 -0700
Message-ID: <1407346107.2319.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch set consists of the usual driver updates (ufs, storvsc,
pm8001 hpsa).  It also has removal of the user space target driver code
(everyone is using LIO now), a partial PCI MSI-X update, more
multi-queue updates, conversion to 64 bit LUNs (so we could
theoretically cope with any LUN returned by a device) and placeholder
support for the ZBC device type (Shingle drives), plus an assortment of
minor updates and bug fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Akinobu Mita (6):
      ufs: fix DMA mask setting
      ufs: adjust queue settings to PRDT limitations
      scsi_debug: allow huge transfer length for read/write commands
      scsi: increase upper limit for max_sectors
      sd: use READ_16 or WRITE_16 when transfer length is greater than =
0xffff
      sg: prevent integer overflow when converting from sectors to byte=
s

Alexander Gordeev (8):
      vmw_pvscsi: Use pci_enable_msix_exact() instead of pci_enable_msi=
x()
      pm8001: Fix invalid return when request_irq() failed
      lpfc: Remove superfluous call to pci_disable_msix()
      isci: Use pci_enable_msix_exact() instead of pci_enable_msix()
      bfa: Use pci_enable_msix_exact() instead of pci_enable_msix()
      bfa: Cleanup bfad_setup_intr() function
      bfa: Do not call pci_enable_msix() after it failed once
      fnic: Use pci_enable_msix_exact() instead of pci_enable_msix()

Arnd Bergmann (6):
      hpsa: fix non-x86 builds
      3w-xxxx: fix mis-aligned struct accesses
      NCR53c406a: don't call free_dma() by default
      qlogicfas: don't call free_dma()
      pas16: don't call free_dma()
      advansys: don't build ARM

Bart Van Assche (3):
      tgt: defconfig cleanup
      tgt: removal
      scsi: remove two cancel_delayed_work() calls from the mid-layer

Ben Hutchings (1):
      bfa: Fix undefined bit shift on big-endian architectures with 32-=
bit DMA address

Bradley Grove (1):
      pm8001: Fix hibernation issue

Christoph Hellwig (30):
      scsi: move the writeable field from struct scsi_device to struct =
scsi_cd
      scsi: add a symbolic name for the ZBC device type
      scsi: update scsi_device_types
      fnic: reject device resets without assigned tags for the blk-mq c=
ase
      scsi: add support for a blk-mq based I/O path.
      scatterlist: allow chaining to preallocated chunks
      scsi: unwind blk_end_request_all and blk_end_request_err calls
      scsi: only maintain target_blocked if the driver has a target que=
ue limit
      scsi: fix the {host,target,device}_blocked counter mess
      scsi: convert device_busy to atomic_t
      scsi: convert host_busy to atomic_t
      scsi: convert target_busy to an atomic_t
      scsi: push host_lock down into scsi_{host,target}_queue_ready
      scsi: set ->scsi_done before calling scsi_dispatch_cmd
      scsi: centralize command re-queueing in scsi_dispatch_fn
      scsi: split __scsi_queue_insert
      scsi: add scsi_setup_cmnd helper
      scsi: mark scsi_setup_blk_pc_cmnd static
      sd: split sd_init_command
      sd: retry discard commands
      sd: retry write same commands
      sd: don't use scsi_setup_blk_pc_cmnd for discard requests
      sd: don't use scsi_setup_blk_pc_cmnd for write same requests
      sd: don't use scsi_setup_blk_pc_cmnd for flush requests
      scsi: set sc_data_direction in common code
      scsi: restructure command initialization for TYPE_FS requests
      scsi: move the nr_phys_segments assert into scsi_init_io
      scsi: remove various exports that were only used by scsi_tgt
      libsrp: removal
      ibmvstgt: remove

Cl=E9ment Calmels (1):
      sd: bad return code of init_sd

Dick Kennedy (1):
      scsi: add defines for new FC port speeds.

Dolev Raviv (4):
      ufs: read door bell register after clearing interrupt aggregation
      ufs: Logical Unit (LU) command queue depth
      ufs: device query status and size check
      ufs: query descriptor API

Douglas Gilbert (5):
      scsi_debug: support scsi-mq, queues and locks
      scsi: cleanup switch in scsi_adjust_queue_depth
      sg: O_EXCL and other lock handling
      sg: add SG_FLAG_Q_AT_TAIL flag
      sg: relax 16 byte cdb restriction

=46abian Frederick (1):
      bfa: use ARRAY_SIZE instead of sizeof/sizeof[0]

Hannes Reinecke (13):
      scsi: use dev_printk variants where possible
      scsi: use dev_printk() variants for ioctl
      scsi: Implement st_printk()
      scsi: Implement ch_printk()
      scsi: Implement sg_printk()
      scsi: Implement sr_printk()
      scsi_scan: Fixup scsilun_to_int()
      scsi: use 64-bit value for 'max_luns'
      Add module param type 'ullong'
      scsi: use 64-bit LUNs
      qla2xxx: Restrict max_lun to 16-bit for older HBAs
      scsi_scan: Restrict sequential scan to 256 LUNs
      scsi: Remove CONFIG_SCSI_MULTI_LUN

Himangi Saraogi (1):
      aic7xxx: Use kstrdup

James Bottomley (1):
      scsi: use short driver name for per-driver cmd slab caches

Janusz Dziemidowicz (1):
      scsi: do not issue SCSI RSOC command to Promise Vtrak E610f

Joe Lawrence (11):
      mptfusion: tweak null pointer checks
      mptfusion: combine fw_event_work and its event_data
      mptfusion: make adapter prod_name[] a pointer
      mptfusion: use memdup_user
      mptfusion: remove redundant kfree checks
      mptfusion: mark file-private functions as static
      mpt3sas: combine fw_event_work and its event_data
      mpt3sas: correct scsi_{target,device} hostdata allocation
      mpt2sas: annotate ioc->reply_post_host_index as __iomem
      mpt2sas: combine fw_event_work and its event_data
      mpt2sas: correct scsi_{target,device} hostdata allocation

Joe Perches (2):
      qla2xxx: Use dma_zalloc_coherent
      bfa: Use dma_zalloc_coherent

K. Y. Srinivasan (9):
      Drivers: add blist flags
      drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure
      drivers: scsi: storvsc: Set srb_flags in all cases
      Drivers: scsi: storvsc: Implement a eh_timed_out handler
      Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol vers=
ion
      Drivers: scsi: storvsc: Filter commands based on the storage prot=
ocol version
      Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supporte=
d by the Host
      Drivers: scsi: storvsc: Change the limits to reflect the values o=
n the host
      sd: fix a bug in deriving the FLUSH_TIMEOUT from the basic I/O ti=
meout

Martin K. Petersen (4):
      mpt3sas: Rework the MSI-X grouping code
      mpt2sas: Rework the MSI-X grouping code
      scsi: add a blacklist flag which enables VPD page inquiries
      sd: Limit transfer length

Maurizio Lombardi (2):
      be2iscsi: Fix memory leak in mgmt_set_ip()
      scsi_lib: remove the description string in scsi_io_completion()

Mike Christie (1):
      bnx2i, be2iscsi: fix custom stats length

Ming Lei (1):
      virtio-scsi: replace target spinlock with seqcount

Nick Black' via open-iscsi (1):
      iscsi: kill redundant casts

Paul Bolle (1):
      tgt: remove SCSI_TGT and SCSI_FC_TGT_ATTRS

Peter Senna Tschudin (1):
      bfa: remove useless return variables

Reddy, Sreekanth (2):
      mpt3sas: delay scsi_add_host call to work with scsi-mq
      mpt2sas: delay scsi_add_host call to work with scsi-mq

Rickard Strandqvist (2):
      pm8001: Cleaning up uninitialized variables
      pm8001: Fix to remove null pointer checks that could never happen

Robert Elliott (1):
      hpsa: do not unconditionally copy sense data

Saurav Kashyap (1):
      bnx2fc: Rebranding bnx2fc driver

Stephen M. Cameron (4):
      hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl
      hpsa: remove online devices from offline device list
      hpsa: fix 6-byte READ/WRITE with 0 length data xfer
      hpsa: make hpsa_init_one return -ENOMEM if allocation of h->locku=
p_detected fails

Sujit Reddy Thumma (4):
      scsi: ufs: fix endianness sparse warnings
      scsi: ufs: make undeclared functions static
      ufs: Fix sending unsupported SCSI command
      ufs: Fix queue depth handling for best effort cases

Tomas Henzl (7):
      pm8001: fix a memory leak in nvmd_resp
      pm8001: fix update_flash
      pm8001: fix a memory leak in flash_update
      pm8001: more fixes to honor return value
      pm8001: add a new spinlock to protect the CCB
      pm8001: honor return value
      pm8001: clean bitmap management functions

Tyrel Datwyler (1):
      ibmvfc: fix little endian issues

Vaughan Cao (1):
      sd: notify block layer when using temporary change to cache_type

Venkatesh Srinivas (1):
      virtio-scsi: Implement change_queue_depth for virtscsi targets

Vikas Chaudhary (3):
      bnx2i: Update driver version to 2.7.10.1
      MAINTAINERS: Update maintainer list for bnx2i and bnx2fc
      bnx2i: Rebranding bnx2i driver

And the diffstat:

 Documentation/scsi/tmscsim.txt                   |    2 -
 MAINTAINERS                                      |    4 +-
 arch/arm/configs/msm_defconfig                   |    1 -
 arch/arm/configs/s3c2410_defconfig               |    1 -
 arch/m68k/configs/amiga_defconfig                |    1 -
 arch/m68k/configs/apollo_defconfig               |    1 -
 arch/m68k/configs/atari_defconfig                |    1 -
 arch/m68k/configs/bvme6000_defconfig             |    1 -
 arch/m68k/configs/hp300_defconfig                |    1 -
 arch/m68k/configs/mac_defconfig                  |    1 -
 arch/m68k/configs/multi_defconfig                |    1 -
 arch/m68k/configs/mvme147_defconfig              |    1 -
 arch/m68k/configs/mvme16x_defconfig              |    1 -
 arch/m68k/configs/q40_defconfig                  |    1 -
 arch/m68k/configs/sun3_defconfig                 |    1 -
 arch/m68k/configs/sun3x_defconfig                |    1 -
 arch/mips/configs/db1xxx_defconfig               |    1 -
 arch/mips/configs/decstation_defconfig           |    1 -
 arch/mips/configs/ip22_defconfig                 |    1 -
 arch/mips/configs/ip27_defconfig                 |    1 -
 arch/mips/configs/ip32_defconfig                 |    1 -
 arch/mips/configs/jazz_defconfig                 |    1 -
 arch/mips/configs/loongson3_defconfig            |    1 -
 arch/mips/configs/malta_defconfig                |    1 -
 arch/mips/configs/malta_kvm_defconfig            |    1 -
 arch/mips/configs/malta_kvm_guest_defconfig      |    1 -
 arch/mips/configs/markeins_defconfig             |    1 -
 arch/mips/configs/nlm_xlp_defconfig              |    3 -
 arch/mips/configs/nlm_xlr_defconfig              |    3 -
 arch/mips/configs/rm200_defconfig                |    1 -
 arch/mips/configs/tb0226_defconfig               |    1 -
 arch/mips/configs/tb0287_defconfig               |    1 -
 arch/powerpc/configs/52xx/motionpro_defconfig    |    1 -
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig |    1 -
 arch/powerpc/configs/mpc5200_defconfig           |    1 -
 arch/powerpc/configs/ppc6xx_defconfig            |    2 -
 arch/s390/configs/default_defconfig              |    2 -
 arch/s390/configs/gcov_defconfig                 |    2 -
 arch/s390/configs/performance_defconfig          |    2 -
 arch/sh/configs/sh2007_defconfig                 |    1 -
 arch/tile/configs/tilegx_defconfig               |    1 -
 arch/tile/configs/tilepro_defconfig              |    1 -
 drivers/ata/libata-scsi.c                        |    2 +-
 drivers/ata/libata.h                             |    2 +-
 drivers/message/fusion/mptbase.c                 |   23 +-
 drivers/message/fusion/mptbase.h                 |    4 +-
 drivers/message/fusion/mptctl.c                  |   18 +-
 drivers/message/fusion/mptfc.c                   |    9 +-
 drivers/message/fusion/mptsas.c                  |   76 +-
 drivers/message/fusion/mptsas.h                  |    2 +-
 drivers/message/fusion/mptscsih.c                |   31 +-
 drivers/message/fusion/mptscsih.h                |    4 +-
 drivers/message/fusion/mptspi.c                  |    5 +-
 drivers/message/i2o/i2o_scsi.c                   |   11 +-
 drivers/s390/scsi/zfcp_dbf.c                     |    3 +-
 drivers/s390/scsi/zfcp_unit.c                    |    4 +-
 drivers/scsi/3w-xxxx.h                           |    4 +-
 drivers/scsi/53c700.c                            |    7 +-
 drivers/scsi/Kconfig                             |   61 +-
 drivers/scsi/Makefile                            |    5 -
 drivers/scsi/NCR5380.c                           |   31 +-
 drivers/scsi/NCR53c406a.c                        |    4 +-
 drivers/scsi/a100u2w.c                           |    2 +-
 drivers/scsi/aacraid/linit.c                     |    2 +-
 drivers/scsi/advansys.c                          |    6 +-
 drivers/scsi/aha152x.c                           |    6 +-
 drivers/scsi/aic7xxx/aic7770_osm.c               |    3 +-
 drivers/scsi/aic7xxx/aic79xx.h                   |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c               |    6 +-
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c           |    3 +-
 drivers/scsi/aic7xxx/aic79xx_proc.c              |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c               |   11 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c           |    3 +-
 drivers/scsi/aic7xxx/aic7xxx_proc.c              |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                 |    8 +-
 drivers/scsi/arm/acornscsi.c                     |   14 +-
 drivers/scsi/arm/fas216.c                        |   11 +-
 drivers/scsi/arm/queue.c                         |    3 +-
 drivers/scsi/atari_NCR5380.c                     |   62 +-
 drivers/scsi/be2iscsi/be_iscsi.c                 |    2 +-
 drivers/scsi/be2iscsi/be_mgmt.c                  |   20 +-
 drivers/scsi/bfa/bfa_fcs.c                       |    6 +-
 drivers/scsi/bfa/bfa_ioc.h                       |    2 +-
 drivers/scsi/bfa/bfad.c                          |   62 +-
 drivers/scsi/bfa/bfad_bsg.c                      |   16 +-
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h            |   13 +
 drivers/scsi/bnx2fc/Kconfig                      |    4 +-
 drivers/scsi/bnx2fc/bnx2fc.h                     |    7 +-
 drivers/scsi/bnx2fc/bnx2fc_constants.h           |   13 +
 drivers/scsi/bnx2fc/bnx2fc_debug.c               |   13 +
 drivers/scsi/bnx2fc/bnx2fc_debug.h               |   13 +
 drivers/scsi/bnx2fc/bnx2fc_els.c                 |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                |   11 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                 |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                  |    7 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                 |    3 +-
 drivers/scsi/bnx2i/57xx_iscsi_constants.h        |    6 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h              |    6 +-
 drivers/scsi/bnx2i/Kconfig                       |    4 +-
 drivers/scsi/bnx2i/bnx2i.h                       |    6 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                   |    6 +-
 drivers/scsi/bnx2i/bnx2i_init.c                  |   14 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                 |   15 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c                 |    6 +-
 drivers/scsi/ch.c                                |   30 +-
 drivers/scsi/csiostor/csio_scsi.c                |   24 +-
 drivers/scsi/cxgbi/libcxgbi.c                    |    2 +-
 drivers/scsi/cxgbi/libcxgbi.h                    |    2 +-
 drivers/scsi/dc395x.c                            |   51 +-
 drivers/scsi/dpt_i2o.c                           |   38 +-
 drivers/scsi/dpti.h                              |    6 +-
 drivers/scsi/eata.c                              |    4 +-
 drivers/scsi/fnic/fnic_isr.c                     |    4 +-
 drivers/scsi/fnic/fnic_scsi.c                    |   20 +-
 drivers/scsi/g_NCR5380.c                         |    2 +-
 drivers/scsi/hosts.c                             |   50 +-
 drivers/scsi/hpsa.c                              |   37 +-
 drivers/scsi/hptiop.c                            |    2 +-
 drivers/scsi/ibmvscsi/Makefile                   |    1 -
 drivers/scsi/ibmvscsi/ibmvfc.c                   |  477 +++----
 drivers/scsi/ibmvscsi/ibmvfc.h                   |  268 ++--
 drivers/scsi/ibmvscsi/ibmvstgt.c                 | 1001 --------------=
-
 drivers/scsi/in2000.c                            |    6 +-
 drivers/scsi/isci/init.c                         |    2 +-
 drivers/scsi/libiscsi.c                          |   12 +-
 drivers/scsi/libsas/sas_scsi_host.c              |   16 +-
 drivers/scsi/libsrp.c                            |  447 -------
 drivers/scsi/lpfc/lpfc_attr.c                    |   10 +-
 drivers/scsi/lpfc/lpfc_init.c                    |    9 +-
 drivers/scsi/lpfc/lpfc_scsi.c                    |   36 +-
 drivers/scsi/megaraid.c                          |    6 +-
 drivers/scsi/megaraid/mega_common.h              |    2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c      |    4 +-
 drivers/scsi/mesh.c                              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c              |   75 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c             |   83 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c              |   75 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c             |   92 +-
 drivers/scsi/ncr53c8xx.c                         |    2 +-
 drivers/scsi/ncr53c8xx.h                         |    4 -
 drivers/scsi/nsp32.c                             |    2 +-
 drivers/scsi/pas16.c                             |    2 -
 drivers/scsi/pcmcia/nsp_cs.c                     |    2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c               |    2 +-
 drivers/scsi/pm8001/pm8001_ctl.c                 |   11 +-
 drivers/scsi/pm8001/pm8001_hwi.c                 |   65 +-
 drivers/scsi/pm8001/pm8001_init.c                |   40 +-
 drivers/scsi/pm8001/pm8001_sas.c                 |   38 +-
 drivers/scsi/pm8001/pm8001_sas.h                 |    2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                 |   48 +-
 drivers/scsi/pmcraid.c                           |    2 +-
 drivers/scsi/ps3rom.c                            |    2 +-
 drivers/scsi/qla2xxx/qla_def.h                   |    6 +-
 drivers/scsi/qla2xxx/qla_gbl.h                   |   18 +-
 drivers/scsi/qla2xxx/qla_init.c                  |   10 +-
 drivers/scsi/qla2xxx/qla_iocb.c                  |   11 +-
 drivers/scsi/qla2xxx/qla_isr.c                   |    4 +-
 drivers/scsi/qla2xxx/qla_mbx.c                   |   12 +-
 drivers/scsi/qla2xxx/qla_mr.c                    |    8 +-
 drivers/scsi/qla2xxx/qla_os.c                    |   48 +-
 drivers/scsi/qla4xxx/ql4_glbl.h                  |    4 +-
 drivers/scsi/qla4xxx/ql4_iocb.c                  |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c                   |   22 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                   |    6 +-
 drivers/scsi/qla4xxx/ql4_os.c                    |   20 +-
 drivers/scsi/qlogicfas.c                         |    2 -
 drivers/scsi/qlogicpti.c                         |    2 +-
 drivers/scsi/scsi.c                              |  132 +-
 drivers/scsi/scsi_debug.c                        | 1483 ++++++++++++++=
+-------
 drivers/scsi/scsi_devinfo.c                      |    1 +
 drivers/scsi/scsi_error.c                        |  186 +--
 drivers/scsi/scsi_ioctl.c                        |   17 +-
 drivers/scsi/scsi_lib.c                          |  935 ++++++++++----
 drivers/scsi/scsi_priv.h                         |    5 +-
 drivers/scsi/scsi_proc.c                         |    2 +-
 drivers/scsi/scsi_scan.c                         |  187 ++-
 drivers/scsi/scsi_sysfs.c                        |   45 +-
 drivers/scsi/scsi_tgt_if.c                       |  399 ------
 drivers/scsi/scsi_tgt_lib.c                      |  661 ----------
 drivers/scsi/scsi_tgt_priv.h                     |   32 -
 drivers/scsi/scsi_transport_fc.c                 |   20 +-
 drivers/scsi/scsi_transport_fc_internal.h        |   26 -
 drivers/scsi/scsi_transport_iscsi.c              |    8 +-
 drivers/scsi/scsi_transport_sas.c                |    2 +-
 drivers/scsi/scsi_transport_srp.c                |   18 -
 drivers/scsi/scsi_transport_srp_internal.h       |   25 -
 drivers/scsi/sd.c                                |  220 ++--
 drivers/scsi/sd.h                                |    3 +
 drivers/scsi/sg.c                                |  657 +++++-----
 drivers/scsi/sr.c                                |   70 +-
 drivers/scsi/sr.h                                |    5 +
 drivers/scsi/sr_ioctl.c                          |   26 +-
 drivers/scsi/sr_vendor.c                         |   36 +-
 drivers/scsi/st.c                                |  605 ++++-----
 drivers/scsi/storvsc_drv.c                       |  123 +-
 drivers/scsi/sun3_NCR5380.c                      |   57 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c              |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h              |    2 +-
 drivers/scsi/tmscsim.c                           |    6 +-
 drivers/scsi/u14-34f.c                           |   10 +-
 drivers/scsi/ufs/ufs.h                           |   38 +-
 drivers/scsi/ufs/ufshcd-pci.c                    |   26 -
 drivers/scsi/ufs/ufshcd.c                        |  427 +++++--
 drivers/scsi/ufs/ufshci.h                        |    5 +
 drivers/scsi/virtio_scsi.c                       |   75 +-
 drivers/scsi/vmw_pvscsi.c                        |    2 +-
 drivers/scsi/wd33c93.c                           |   33 +-
 drivers/staging/rts5208/rtsx.c                   |    4 +-
 drivers/target/loopback/tcm_loop.c               |    2 +-
 drivers/target/target_core_pscsi.c               |   12 +-
 drivers/usb/storage/Kconfig                      |    4 +-
 drivers/usb/storage/sddr09.c                     |    4 +-
 drivers/usb/storage/usb.c                        |   10 +-
 include/linux/moduleparam.h                      |    5 +
 include/linux/scatterlist.h                      |    6 +-
 include/scsi/libsrp.h                            |   78 --
 include/scsi/scsi.h                              |    3 +-
 include/scsi/scsi_cmnd.h                         |    3 -
 include/scsi/scsi_device.h                       |   39 +-
 include/scsi/scsi_devinfo.h                      |    5 +
 include/scsi/scsi_driver.h                       |    3 -
 include/scsi/scsi_host.h                         |   68 +-
 include/scsi/scsi_tcq.h                          |   28 +-
 include/scsi/scsi_tgt.h                          |   21 -
 include/scsi/scsi_tgt_if.h                       |  108 --
 include/scsi/scsi_transport.h                    |    2 +-
 include/scsi/scsi_transport_fc.h                 |    4 +
 include/scsi/sg.h                                |   92 +-
 kernel/params.c                                  |    1 +
 lib/scatterlist.c                                |   25 +-
 231 files changed, 4936 insertions(+), 6265 deletions(-)
 delete mode 100644 drivers/scsi/ibmvscsi/ibmvstgt.c
 delete mode 100644 drivers/scsi/libsrp.c
 delete mode 100644 drivers/scsi/scsi_tgt_if.c
 delete mode 100644 drivers/scsi/scsi_tgt_lib.c
 delete mode 100644 drivers/scsi/scsi_tgt_priv.h
 delete mode 100644 drivers/scsi/scsi_transport_fc_internal.h
 delete mode 100644 drivers/scsi/scsi_transport_srp_internal.h
 delete mode 100644 include/scsi/libsrp.h
 delete mode 100644 include/scsi/scsi_tgt.h
 delete mode 100644 include/scsi/scsi_tgt_if.h
