From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI merge for 2.6.13
Date: Tue, 06 Sep 2005 19:37:32 -0500
Message-ID: <1126053452.5012.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751166AbVIGAh5@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

This should be the entire contents of the SCSI tree I've been saving.
It also includes Jens' send SCSI requests via bios tree that he, Mike
Christie and I have been working on.

The patch is available here:

master.kernel.org:/pub/linux/kernel/scm/jejb/scsi-for-linus-2.6.git

The short changelog is:

Adrian Bunk:
  o drivers/scsi/constants.c should include scsi_dbg.h
  o git-scsi-misc: drivers/scsi/ch.c: remove devfs stuff

Alan Stern:
  o sd: pause in sd_spinup_disk for slow USB devices
  o return success after retries in scsi_eh_tur

Andrew Morton:
  o fix C syntax problem in scsi_lib.c
  o fix warning in aic7770.c
  o fix warning in scsi_softirq
  o aic79xx: needs to select SPI_TRANSPORT_ATTRS

Andrew Vasquez:
  o qla2xxx: Update version number to 8.01.00-k
  o qla2xxx: Stop firmware execution at unintialization time
  o qla2xxx: Replace schedule_timeout()
  o qla2xxx: Remove bad call to fc_remove_host() during probe failure
  o qla2xxx: Add host attributes
  o qla2xxx: Add change_queue_depth/type() API support
  o qla2xxx: Remove redundant call to pci_unmap_sg()
  o qla2xxx: Remove RISC pause/release barriers during flash manipulati=
on
  o qla2xxx: Correct LED scheme definition
  o qla2xxx: Simplify redundant target/device reset logic
  o qla2xxx: Correct domain/area exclusion logic
  o qla2xxx: Add FDMI support
  o qla2xxx: Export class-of-service (COS) information
  o qla2xxx: Use dma_get_required_mask() in determining the 'ideal' DMA=
 mask

Anton Blanchard:
  o Universal Xport no attach blacklist

Christoph Hellwig:
  o unexport scsi_add_timer/scsi_delete_timer
  o switch EH thread startup to the kthread API
  o fix SCSI_IOCTL_PROBE_HOST
  o fusion: whitespace fixes
  o fusion: endianess fixes
  o fusion: update LSI headers
  o fusion: extended config header support
  o aic7xxx: remove aiclib.c
  o comment cleanup for spi_execute
  o aiclib remove dead
  o aic79xx: sane pci probing
  o aic79xx: remove some dead code
  o qla1280: endianess annotations
  o qla1280: don't use bitfields for hardware access, parameters
  o qla1280: don't use bitfields for hardware access in isp_config
  o qla1280: always load microcode
  o qla1280: remove SG_SEGMENTS
  o qla1280: use SAM_ constants
  o qla1280: misc cleanups
  o qla1280: interupt posting for irq disabling/enabling
  o qla1280: remove dead per-host flag variables
  o [PATCH] ll_rw_blk.c kerneldoc updates

Dave Boutcher:
  o ibmvscsi timeout fix
  o ibmvscsi eh locking

Dave Jones:
  o blacklist addition

Douglas Gilbert:
  o sg direct io/mmap oops, st sync

Hannes Reinecke:
  o aic79xx: fixup DT setting
  o aic79xx: DV parameter settings
  o aic79xx: update to use scsi_transport_spi
  o aic79xx: Remove busyq

James Bottomley:
  o Merge by hand (conflicts in sd.c)
  o quieten messages on scsi_execute commands
  o ibmvscsi: handle large scatter/gather lists
  o This patch fixes in st.c the bug in the signed/unsigned int compari=
son
  o embryonic RAID class
  o attribute container final klist fixes
  o correct attribute_container list usage
  o Merge by hand (conflicts in sr.c)
  o fix sense buffer length handling problem
  o fix 3ware raid emulated commands
  o convert ch to use scsi_execute_req
  o convert sr to scsi_execute_req
  o convert sd to scsi_execute_req (and update the scsi_execute_req API=
)
  o convert SPI transport class to scsi_execute
  o convert the remaining mid-layer pieces to scsi_execute_req
  o Merge HEAD from ../scsi-misc-2.6-tmp
  o add missing attribute container function prototype
  o fix transport class corner case after rework
  o use scatter lists for all block pc requests and simplify hw handler=
s
  o update scsi_wait_req to new format for blk_rq_map_kern()
  o use scatter lists for all block pc requests and simplify hw handler=
s
  o fix mismerge in ll_rw_blk.c
  o correct transport class abstraction to work outside SCSI
  o add ability to deny binding to SPI transport class
  o aic7xxx: lost multifunction flags handling
  o Make the HSG80 a REPORTLUN2 device
  o aic79xx: fix boot panic with no hardware
  o add global timeout to the scsi mid-layer
  o aacraid: correct use of cmd->timeout field
  o aic7xxx/79xx: fix another potential panic due to a non existent tar=
get
  o aic7xxx: upport all sequencer and core fixes from adaptec version 6=
=2E3.9
  o aic79xx: add hold_mcs to the transport parameters
  o add missing hold_mcs parameter to the spi transport class
  o aic79xx: fix up transport settings
  o add template for scsi_host_set_state()
  o [PATCH] update blk_execute_rq to take an at_head parameter
  o [PATCH] The blk_rq_map_user() change missed an update in scsi_ioctl=
=2Ec
  o [PATCH] Add scatter-gather support for the block layer SG_IO

James Smart:
  o Add Emulex as maintainer of lpfc SCSI driver
  o lpfc driver 8.0.30 : update version to 8.0.30
  o lpfc driver 8.0.30 : convert to use of int_to_scsilun()
  o lpfc driver 8.0.30 : dev_loss and nodev timeouts
  o lpfc driver 8.0.30 : fix get_stats panic
  o lpfc driver 8.0.30 : task mgmt bit clearing
  o lpfc driver 8.0.30 : fix lip/cablepull panic
  o lpfc driver 8.0.30 : fix iocb reuse initialization

Jens Axboe:
  o [PATCH] kill 'reading' variable in sg_io(), it isn't used anymore
  o [PATCH] Cleanup blk_rq_map_* interfaces
  o [PATCH] Keep the bio end_io parts inside of bio.c for blk_rq_map_ke=
rn()

Kai M=E4kisara:
  o drivers/scsi/st.c: add reference count and related fixes

Mark Haverkamp:
  o aacraid: bad BUG_ON fix
  o aacraid: Fix aacraid probe breakage (updated)
  o aacraid: adapter support update
  o aacraid: sgraw command support
  o aacraid: aif registration timeout fix
  o aacraid: remove duplicate io callback code
  o aacraid: driver shutdown method
  o aacraid: driver version update
  o aacraid: interupt mitigation

Mike Anderson:
  o host state model update: mediate host add/remove race
  o host state model update: reimplement scsi_host_cancel
  o host state model update: replace old host bitmap state

Mike Christie:
  o [PATCH] Add blk_rq_map_kern()

Olaf Hering:
  o aic byteorder fixes after recent cleanup

Pete Zaitcev:
  o sr.c: Fix getting wrong size

And the diffstat:

 Documentation/scsi/aic7xxx.txt                   |    6=20
 Documentation/scsi/scsi_mid_low_api.txt          |   41=20
 MAINTAINERS                                      |    7=20
 drivers/base/attribute_container.c               |   86=20
 drivers/base/transport_class.c                   |   19=20
 drivers/block/ll_rw_blk.c                        |  192=20
 drivers/block/scsi_ioctl.c                       |   60=20
 drivers/cdrom/cdrom.c                            |   15=20
 drivers/ide/ide-disk.c                           |    2=20
 drivers/message/fusion/lsi/mpi.h                 |   19=20
 drivers/message/fusion/lsi/mpi_cnfg.h            |   85=20
 drivers/message/fusion/lsi/mpi_history.txt       |   67=20
 drivers/message/fusion/lsi/mpi_init.h            |  203=20
 drivers/message/fusion/lsi/mpi_ioc.h             |   11=20
 drivers/message/fusion/lsi/mpi_targ.h            |   74=20
 drivers/message/fusion/mptbase.c                 |  321 -
 drivers/message/fusion/mptbase.h                 |    5=20
 drivers/message/fusion/mptctl.c                  |   14=20
 drivers/message/fusion/mptscsih.c                |  140=20
 drivers/message/fusion/mptspi.c                  |    6=20
 drivers/scsi/3w-xxxx.c                           |   57=20
 drivers/scsi/Kconfig                             |    6=20
 drivers/scsi/Makefile                            |    2=20
 drivers/scsi/aacraid/aachba.c                    |  327 -
 drivers/scsi/aacraid/aacraid.h                   |   55=20
 drivers/scsi/aacraid/commctrl.c                  |   18=20
 drivers/scsi/aacraid/comminit.c                  |    4=20
 drivers/scsi/aacraid/commsup.c                   |   20=20
 drivers/scsi/aacraid/linit.c                     |  106=20
 drivers/scsi/aacraid/rkt.c                       |   20=20
 drivers/scsi/aacraid/rx.c                        |   20=20
 drivers/scsi/aacraid/sa.c                        |   22=20
 drivers/scsi/advansys.c                          |    4=20
 drivers/scsi/aic7xxx/Kconfig.aic79xx             |    1=20
 drivers/scsi/aic7xxx/aic7770.c                   |    1=20
 drivers/scsi/aic7xxx/aic79xx.h                   |    6=20
 drivers/scsi/aic7xxx/aic79xx_core.c              |  104=20
 drivers/scsi/aic7xxx/aic79xx_osm.c               | 5502 ++++++--------=
---------
 drivers/scsi/aic7xxx/aic79xx_osm.h               |  288 -
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c           |   82=20
 drivers/scsi/aic7xxx/aic79xx_pci.c               |   14=20
 drivers/scsi/aic7xxx/aic79xx_proc.c              |   88=20
 drivers/scsi/aic7xxx/aic7xxx.h                   |    4=20
 drivers/scsi/aic7xxx/aic7xxx.reg                 |    4=20
 drivers/scsi/aic7xxx/aic7xxx.seq                 |    5=20
 drivers/scsi/aic7xxx/aic7xxx_93cx6.c             |   36=20
 drivers/scsi/aic7xxx/aic7xxx_core.c              |   60=20
 drivers/scsi/aic7xxx/aic7xxx_osm.c               |   97=20
 drivers/scsi/aic7xxx/aic7xxx_osm.h               |    2=20
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c           |   29=20
 drivers/scsi/aic7xxx/aic7xxx_proc.c              |   45=20
 drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped       |    6=20
 drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped |    4=20
 drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped       |  933 +--
 drivers/scsi/aic7xxx/aiclib.c                    | 1377 -----
 drivers/scsi/aic7xxx/aiclib.h                    |  890 ---
 drivers/scsi/ch.c                                |   42=20
 drivers/scsi/constants.c                         |   49=20
 drivers/scsi/hosts.c                             |  113=20
 drivers/scsi/ibmvscsi/ibmvscsi.c                 |  179=20
 drivers/scsi/ibmvscsi/ibmvscsi.h                 |    2=20
 drivers/scsi/lpfc/lpfc.h                         |    5=20
 drivers/scsi/lpfc/lpfc_attr.c                    |    6=20
 drivers/scsi/lpfc/lpfc_ct.c                      |    2=20
 drivers/scsi/lpfc/lpfc_els.c                     |    1=20
 drivers/scsi/lpfc/lpfc_hbadisc.c                 |    3=20
 drivers/scsi/lpfc/lpfc_init.c                    |    5=20
 drivers/scsi/lpfc/lpfc_mbox.c                    |    5=20
 drivers/scsi/lpfc/lpfc_mem.c                     |    5=20
 drivers/scsi/lpfc/lpfc_nportdisc.c               |    1=20
 drivers/scsi/lpfc/lpfc_scsi.c                    |   24=20
 drivers/scsi/lpfc/lpfc_scsi.h                    |   13=20
 drivers/scsi/lpfc/lpfc_sli.c                     |    2=20
 drivers/scsi/lpfc/lpfc_version.h                 |    2=20
 drivers/scsi/qla1280.c                           |  359 -
 drivers/scsi/qla1280.h                           |  336 -
 drivers/scsi/qla2xxx/qla_attr.c                  |  136=20
 drivers/scsi/qla2xxx/qla_dbg.h                   |    7=20
 drivers/scsi/qla2xxx/qla_def.h                   |  157=20
 drivers/scsi/qla2xxx/qla_gbl.h                   |   12=20
 drivers/scsi/qla2xxx/qla_gs.c                    |  564 ++
 drivers/scsi/qla2xxx/qla_init.c                  |   24=20
 drivers/scsi/qla2xxx/qla_iocb.c                  |    6=20
 drivers/scsi/qla2xxx/qla_isr.c                   |    2=20
 drivers/scsi/qla2xxx/qla_mbx.c                   |   97=20
 drivers/scsi/qla2xxx/qla_os.c                    |  117=20
 drivers/scsi/qla2xxx/qla_sup.c                   |   34=20
 drivers/scsi/qla2xxx/qla_version.h               |    4=20
 drivers/scsi/raid_class.c                        |  250 +
 drivers/scsi/scsi.c                              |   17=20
 drivers/scsi/scsi_devinfo.c                      |    4=20
 drivers/scsi/scsi_error.c                        |   48=20
 drivers/scsi/scsi_ioctl.c                        |   64=20
 drivers/scsi/scsi_lib.c                          |  294 -
 drivers/scsi/scsi_priv.h                         |    3=20
 drivers/scsi/scsi_scan.c                         |  128=20
 drivers/scsi/scsi_sysfs.c                        |   62=20
 drivers/scsi/scsi_transport_fc.c                 |    6=20
 drivers/scsi/scsi_transport_spi.c                |  168=20
 drivers/scsi/sd.c                                |  187=20
 drivers/scsi/sg.c                                |   11=20
 drivers/scsi/sr.c                                |   75=20
 drivers/scsi/sr.h                                |    1=20
 drivers/scsi/sr_ioctl.c                          |   62=20
 drivers/scsi/st.c                                |  156=20
 drivers/scsi/st.h                                |    3=20
 fs/bio.c                                         |  223=20
 include/linux/attribute_container.h              |   12=20
 include/linux/bio.h                              |    6=20
 include/linux/blkdev.h                           |   10=20
 include/linux/raid_class.h                       |   59=20
 include/linux/transport_class.h                  |   11=20
 include/scsi/scsi_cmnd.h                         |    8=20
 include/scsi/scsi_dbg.h                          |    2=20
 include/scsi/scsi_device.h                       |   22=20
 include/scsi/scsi_eh.h                           |   11=20
 include/scsi/scsi_host.h                         |   26=20
 include/scsi/scsi_request.h                      |   16=20
 include/scsi/scsi_transport_spi.h                |    6=20
 119 files changed, 6830 insertions(+), 9047 deletions(-)

James
