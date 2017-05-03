From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.11+ merge window
Date: Wed, 03 May 2017 15:10:08 -0700
Message-ID: <1493849408.22788.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59070 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751567AbdECWKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 18:10:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This update includes the usual round of major driver updates (hisi_sas,
ufs, fnic, cxlflash, be2iscsi, ipr, stex).  There's also the usual
amount of cosmetic and spelling stuff.

The major thing you should be aware of is that there's a clash between
a char dev change in the char-misc tree (adding the new cdev_device_add
helper) and the make checking the return value of scsi_device_get()
mandatory (in osd_uld.c).  I was waiting for you to pull Greg's tree,
but since you haven't, here's mine.  Just in case we cross, the
proposed resolution is below (from merging char-misc followed by
scsi/misc).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alexey Khoroshilov (1):
      scsi: mvumi: remove code handling zero scsi_sg_count(scmd) case

Arnd Bergmann (6):
      scsi: pmcraid: use normal copy_from_user
      scsi: pmcraid: fix minor sparse warnings
      scsi: pmcraid: fix endianess sparse annotations
      scsi: pmcraid: use __iomem pointers for ioctl argument
      scsi: advansys: fix uninitialized data access
      scsi: hisi_sas: fix SATA dependency

Bart Van Assche (3):
      scsi: sd_zbc: Remove superfluous assignments
      scsi: Make checking the scsi_device_get() return value mandatory
      scsi: osd_uld: Check scsi_device_get() return value

Brian King (6):
      scsi: ipr: Driver version 2.6.4
      scsi: ipr: Fix SATA EH hang
      scsi: ipr: Error path locking fixes
      scsi: ipr: Fix abort path race condition
      scsi: ipr: Remove redundant initialization
      scsi: ipr: Fix missed EH wakeup

Cathy Avery (2):
      scsi: storvsc: Add support for FC rport.
      scsi: scsi_transport_fc: Add dummy initiator role to rport

Charles (2):
      scsi: stex: Add S6 support
      scsi: stex: Support Pegasus 3 product

Christoph Hellwig (7):
      scsi: sd: Cleanup sd_done sense data handling
      scsi: pmcraid: fix lock imbalance in pmcraid_reset_reload()
      scsi: bfa: remove bfa_module_s madness
      scsi: libsas: allow async aborts
      scsi: csiostor: switch to pci_alloc_irq_vectors
      scsi: be2iscsi: switch to pci_alloc_irq_vectors
      scsi: fnic: switch to pci_alloc_irq_vectors

Colin Ian King (11):
      scsi: qla4xxx: fix spelling mistake: "Tempalate" -> "Template"
      scsi: stex: make S6flag static
      scsi: fcoe: make fcoe_e_d_tov and fcoe_r_a_tov static
      scsi: fusion: fix spelling mistake: "Persistancy" -> "Persistency"
      scsi: BusLogic: fix incorrect spelling of adatper_reset_req
      scsi: aic7xxx: fix order of arguments in function prototype
      scsi: fc: remove redundant check of an unsigned long being less than zero
      scsi: snic: fix spelling mistake: "Cann't" -> "Cannot"
      scsi: qla2xxx: remove some redundant pointer assignments
      scsi: hisi_sas: add missing break in switch statement
      scsi: esas2r: Remove redundant NULL check on buffer

Damien Le Moal (5):
      scsi: sd_zbc: Do not write lock zones for reset
      scsi: sd: sd_zbc: Rename sd_zbc_setup_write_cmnd
      scsi: Improve scsi_get_sense_info_fld
      scsi: sd: Improve sd_completed_bytes
      scsi: sd: Fix function descriptions

Dan Carpenter (1):
      scsi: osd_uld: remove an unneeded NULL check

David Gibson (1):
      scsi: virtio_scsi: Always try to read VPD pages

Dmitry Torokhov (1):
      scsi: remove incorrect __exit markups

Don Brace (2):
      scsi: hpsa: change driver version
      scsi: hpsa: update pci ids

Elena Reshetova (2):
      scsi: libiscsi: qedi: convert iscsi_task.refcount from atomic_t to refcount_t
      scsi: libfc: convert fc_fcp_pkt.ref_cnt from atomic_t to refcount_t

Finn Thain (1):
      scsi: mac_esp: Replace bogus memory barrier with spinlock

Hannes Reinecke (13):
      scsi: mpt: Move scsi_remove_host() out of mptscsih_remove_host()
      scsi: sg: reset 'res_in_use' after unlinking reserved array
      scsi: sg: close race condition in sg_remove_sfp_usercontext()
      scsi: sg: use standard lists for sg_requests
      scsi: sg: protect accesses to 'reserved' page array
      scsi: sg: remove 'save_scat_len'
      scsi: sg: disable SET_FORCE_LOW_DMA
      scsi: make asynchronous aborts mandatory
      scsi: make scsi_eh_scmd_add() always succeed
      scsi: make eh_eflags persistent
      scsi: always send command aborts
      scsi: sd: Return SUCCESS in sd_eh_action() after device offline
      scsi: scsi_error: count medium access timeout only once per EH run

Jack Wang (1):
      MAINTAINERS: remove pmchba list for PM8001

Jitendra Bhivare (10):
      scsi: be2iscsi: Update driver version
      scsi: be2iscsi: Update Copyright
      scsi: be2iscsi: Check size before copying ASYNC handle
      scsi: be2iscsi: Remove free_list for ASYNC handles
      scsi: be2iscsi: Use num_cons field in Rx CQE
      scsi: be2iscsi: Increase HDQ default queue size
      scsi: scsi_transport_iscsi: Use flush_work in iscsi_remove_session
      scsi: be2iscsi: Replace spin_unlock_bh with spin_lock
      scsi: be2iscsi: Fix closing of connection
      scsi: be2iscsi: Check tag in beiscsi_mccq_compl_wait

Johannes Thumshirn (4):
      scsi: sas: move scsi_remove_host call into sas_remove_host
      scsi: libfc: directly call ELS request handlers
      scsi: sg: check for valid direction before starting the request
      scsi: sas: remove sas_domain_release_transport

John Garry (16):
      scsi: hisi_sas: fix NULL deference when TMF timeouts
      scsi: hisi_sas: add v2 hw internal abort timeout workaround
      scsi: hisi_sas: check hisi_sas_lu_reset() error message
      scsi: hisi_sas: add hisi_sas_clear_nexus_ha()
      scsi: hisi_sas: rename hisi_sas_link_timeout_{enable, disable}_link
      scsi: hisi_sas: some modifications to v2 hw reg init values
      scsi: hisi_sas: remove task free'ing for timeouts
      scsi: hisi_sas: fix some sas_task.task_state_lock locking
      scsi: hisi_sas: check for SAS_TASK_STATE_ABORTED in slot complete
      scsi: hisi_sas: hardreset for SATA disk in LU reset
      scsi: hisi_sas: modify hisi_sas_abort_task() for SSP
      scsi: hisi_sas: only reset link for PHY_FUNC_LINK_RESET
      scsi: hisi_sas: error hisi_sas_task_prep() when port down
      scsi: hisi_sas: remove hisi_sas_port_deformed()
      scsi: hisi_sas: move PHY init to hisi_sas_scan_start()
      scsi: hisi_sas: add to_hisi_sas_port()

Kees Cook (2):
      scsi: bfa: use designated initializers
      scsi: qedi: qedf: Use designated initializers

Mahesh Rajashekhara (1):
      scsi: aacraid: pci_alloc_consistent() failures on ARM64

Matthew R. Ochs (16):
      scsi: cxlflash: Introduce hardware queue steering
      scsi: cxlflash: Add hardware queues attribute
      scsi: cxlflash: Improve asynchronous interrupt processing
      scsi: cxlflash: Fix warnings/errors
      scsi: cxlflash: Fix power-of-two validations
      scsi: cxlflash: Remove unnecessary DMA mapping
      scsi: cxlflash: Fence EEH during probe
      scsi: cxlflash: Support up to 4 ports
      scsi: cxlflash: SISlite updates to support 4 ports
      scsi: cxlflash: Hide FC internals behind common access routine
      scsi: cxlflash: Remove port configuration assumptions
      scsi: cxlflash: Support dynamic number of FC ports
      scsi: cxlflash: Update sysfs helper routines to pass config structure
      scsi: cxlflash: Implement IRQ polling for RRQ processing
      scsi: cxlflash: Serialize RRQ access and support offlevel processing
      scsi: cxlflash: Separate RRQ processing from the RRQ interrupt handler

Mauricio Faria de Oliveira (1):
      scsi: ses: don't get power status of SES device slot on probe

Maurizio Lombardi (1):
      scsi: lpfc: fix potential buffer overflow.

Miguel Bernal Marin (2):
      scsi: storvsc: remove return at end of void function
      scsi: storvsc: Prefer kcalloc over kzalloc with multiply

Milan P Gandhi (1):
      scsi: qla2xxx: Fix typo in driver

NeilBrown (1):
      scsi: ibmvfc: don't check for failure from mempool_alloc()

Nicholas Mc Guire (1):
      scsi: qla4xxx: drop redundant init_completion

Satish Kharat (7):
      scsi: fnic: bug fix for fip.fip_subcode in fnic_fcoe_send_vlan_req
      scsi: fnic: Adding debug IO and Abort latency counter to fnic stats
      scsi: fnic: Adding Check Condition counter to misc fnicstats
      scsi: fnic: Avoid false out-of-order detection for aborted command
      scsi: fnic: Fix for "Number of Active IOs" in fnicstats becoming negative
      scsi: fnic: minor cleanup in fnic_fcpio_itmf_cmpl_handler, removing else case
      scsi: fnic: Ratelimit printks to avoid flooding when vlan is not set by the switch.i

Sinan Kaya (1):
      scsi: mpt3sas: remove redundant wmb

Szymon Mielczarek (1):
      Revert "scsi: ufs: add queries retry mechanism"

Tomohiro Kusumi (9):
      scsi: ufs: make ufshcd_get_lists_status() register operation obvious
      scsi: ufs: use MASK_EE_STATUS
      scsi: ufs: just use sizeof() for snprintf()
      scsi: ufs: remove deprecated enum for hw interrupt
      scsi: ufs: add missing macros for register bits from UFSHCI spec
      scsi: ufs: non functional macro fix
      scsi: ufs: use existing macro CONTROLLER_ENABLE to test register bit
      scsi: ufs: make ufshcd_is_{device_present, hba_active}() return bool
      scsi: ufs: fix wrong/ambiguous fall through comments

Uma Krishnan (1):
      scsi: cxlflash: Support multiple hardware queues

Varun Prakash (1):
      scsi: cxgb4i: update module description

Wei Yongjun (1):
      scsi: mac_esp: fix to pass correct device identity to free_irq()

Xiang Chen (8):
      scsi: hisi_sas: controller reset for multi-bits ECC and AXI fatal errors
      scsi: hisi_sas: use dev_is_sata to identify SATA or SAS disk
      scsi: hisi_sas: release SMP slot in lldd_abort_task
      scsi: hisi_sas: process error codes according to their priority
      scsi: hisi_sas: free slots after hardreset
      scsi: hisi_sas: modify error handling for v2 hw
      scsi: hisi_sas: add softreset function for SATA disk
      scsi: hisi_sas: add controller reset

Xiaofei Tan (5):
      scsi: hisi_sas: workaround SoC about abort timeout bug
      scsi: hisi_sas: workaround a SoC SATA IO processing bug
      scsi: hisi_sas: workaround STP link SoC bug
      scsi: hisi_sas: add is_sata_phy_v2_hw()
      scsi: hisi_sas: handle PHY UP+DOWN simultaneous irq

With diffstat:

 Documentation/powerpc/cxlflash.txt     |    5 +
 Documentation/scsi/scsi_eh.txt         |   30 +-
 MAINTAINERS                            |    1 -
 drivers/message/fusion/mptbase.c       |    2 +-
 drivers/message/fusion/mptfc.c         |    7 +-
 drivers/message/fusion/mptscsih.c      |    2 -
 drivers/message/fusion/mptspi.c        |   10 +-
 drivers/misc/enclosure.c               |    7 +-
 drivers/scsi/BusLogic.c                |   14 +-
 drivers/scsi/BusLogic.h                |    2 +-
 drivers/scsi/aacraid/aachba.c          |   13 +-
 drivers/scsi/aacraid/commctrl.c        |    6 +-
 drivers/scsi/aacraid/comminit.c        |    3 +-
 drivers/scsi/aacraid/commsup.c         |   20 +-
 drivers/scsi/aacraid/linit.c           |    8 +-
 drivers/scsi/aacraid/rx.c              |   16 +-
 drivers/scsi/advansys.c                |   21 +-
 drivers/scsi/aic7xxx/aic7xxx_pci.c     |    4 +-
 drivers/scsi/aic94xx/aic94xx_init.c    |    1 -
 drivers/scsi/be2iscsi/be.h             |   12 +-
 drivers/scsi/be2iscsi/be_cmds.c        |   17 +-
 drivers/scsi/be2iscsi/be_cmds.h        |   74 +-
 drivers/scsi/be2iscsi/be_iscsi.c       |  111 +--
 drivers/scsi/be2iscsi/be_iscsi.h       |   13 +-
 drivers/scsi/be2iscsi/be_main.c        |  397 +++++------
 drivers/scsi/be2iscsi/be_main.h        |   30 +-
 drivers/scsi/be2iscsi/be_mgmt.c        |  140 ++--
 drivers/scsi/be2iscsi/be_mgmt.h        |   43 +-
 drivers/scsi/bfa/bfa_core.c            |   66 +-
 drivers/scsi/bfa/bfa_fcpim.c           |   37 +-
 drivers/scsi/bfa/bfa_fcs_lport.c       |   31 +-
 drivers/scsi/bfa/bfa_ioc.c             |   30 +-
 drivers/scsi/bfa/bfa_modules.h         |  101 ++-
 drivers/scsi/bfa/bfa_svc.c             |  172 +----
 drivers/scsi/csiostor/csio_hw.h        |    1 -
 drivers/scsi/csiostor/csio_isr.c       |  128 ++--
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c     |    2 +-
 drivers/scsi/cxlflash/common.h         |  137 +++-
 drivers/scsi/cxlflash/lunmgt.c         |    4 +-
 drivers/scsi/cxlflash/main.c           | 1162 ++++++++++++++++++++++--------
 drivers/scsi/cxlflash/main.h           |    2 -
 drivers/scsi/cxlflash/sislite.h        |  124 ++--
 drivers/scsi/cxlflash/superpipe.c      |   16 +-
 drivers/scsi/cxlflash/superpipe.h      |   56 +-
 drivers/scsi/cxlflash/vlun.c           |   99 ++-
 drivers/scsi/cxlflash/vlun.h           |    2 +-
 drivers/scsi/esas2r/esas2r_log.c       |    5 -
 drivers/scsi/fcoe/fcoe.c               |    4 +-
 drivers/scsi/fnic/fnic.h               |    3 +-
 drivers/scsi/fnic/fnic_fcs.c           |   23 +-
 drivers/scsi/fnic/fnic_isr.c           |   41 +-
 drivers/scsi/fnic/fnic_scsi.c          |  105 ++-
 drivers/scsi/fnic/fnic_stats.h         |   16 +
 drivers/scsi/fnic/fnic_trace.c         |   49 +-
 drivers/scsi/hisi_sas/Kconfig          |    1 +
 drivers/scsi/hisi_sas/hisi_sas.h       |   19 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  471 +++++++++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   19 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1201 +++++++++++++++++++++++++-------
 drivers/scsi/hpsa.c                    |    6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c         |    6 -
 drivers/scsi/ipr.c                     |  259 +++++--
 drivers/scsi/ipr.h                     |    4 +-
 drivers/scsi/isci/init.c               |    1 -
 drivers/scsi/libfc/fc_fcp.c            |    6 +-
 drivers/scsi/libfc/fc_lport.c          |   20 +-
 drivers/scsi/libiscsi.c                |    8 +-
 drivers/scsi/libsas/sas_init.c         |    7 -
 drivers/scsi/libsas/sas_scsi_host.c    |    5 -
 drivers/scsi/lpfc/lpfc_attr.c          |    4 +-
 drivers/scsi/mac_esp.c                 |   35 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c    |    2 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c   |    1 -
 drivers/scsi/mvsas/mv_init.c           |    1 -
 drivers/scsi/mvumi.c                   |   85 +--
 drivers/scsi/osd/osd_uld.c             |   15 +-
 drivers/scsi/pm8001/pm8001_init.c      |    1 -
 drivers/scsi/pmcraid.c                 |  234 +++----
 drivers/scsi/pmcraid.h                 |    8 +-
 drivers/scsi/qedf/qedf_debugfs.c       |    2 +-
 drivers/scsi/qedi/qedi_debugfs.c       |    2 +-
 drivers/scsi/qedi/qedi_iscsi.c         |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c        |    2 +-
 drivers/scsi/qla2xxx/qla_bsg.c         |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c          |    2 +-
 drivers/scsi/qla2xxx/qla_init.c        |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c         |    6 +-
 drivers/scsi/qla2xxx/qla_os.c          |    6 -
 drivers/scsi/qla4xxx/ql4_init.c        |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c          |    1 -
 drivers/scsi/scsi_error.c              |  184 ++---
 drivers/scsi/scsi_lib.c                |    4 +-
 drivers/scsi/scsi_priv.h               |    3 +-
 drivers/scsi/scsi_transport_fc.c       |   12 +-
 drivers/scsi/scsi_transport_iscsi.c    |    3 +-
 drivers/scsi/scsi_transport_sas.c      |    8 +-
 drivers/scsi/sd.c                      |  134 ++--
 drivers/scsi/sd.h                      |   14 +-
 drivers/scsi/sd_zbc.c                  |   58 +-
 drivers/scsi/ses.c                     |    1 -
 drivers/scsi/sg.c                      |  284 ++++----
 drivers/scsi/sgiwd93.c                 |    2 +-
 drivers/scsi/sni_53c710.c              |    2 +-
 drivers/scsi/snic/snic_debugfs.c       |    2 +-
 drivers/scsi/stex.c                    |  287 ++++++--
 drivers/scsi/storvsc_drv.c             |   27 +-
 drivers/scsi/ufs/ufshcd.c              |  102 +--
 drivers/scsi/ufs/ufshci.h              |    6 +
 drivers/scsi/virtio_scsi.c             |   24 +
 drivers/scsi/zalon.c                   |    2 +-
 include/scsi/libfc.h                   |    3 +-
 include/scsi/libiscsi.h                |    3 +-
 include/scsi/libsas.h                  |    1 -
 include/scsi/scsi_device.h             |    2 +-
 include/scsi/scsi_driver.h             |    1 +
 include/scsi/scsi_eh.h                 |    5 +-
 include/scsi/scsi_host.h               |    5 -
 include/scsi/scsi_transport_fc.h       |    1 +
 include/scsi/sg.h                      |    1 -
 119 files changed, 4302 insertions(+), 2752 deletions(-)

James

---

diff --cc drivers/scsi/osd/osd_uld.c
index 4101c3178411,ed948025112c..0e56f1eb05dc
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@@ -442,20 -446,8 +442,21 @@@ static int osd_probe(struct device *dev
  	if (NULL == oud)
  		goto err_retract_minor;
  
 +	/* class device member */
 +	device_initialize(&oud->class_dev);
  	dev_set_drvdata(dev, oud);
  	oud->minor = minor;
 +	oud->class_dev.devt = MKDEV(SCSI_OSD_MAJOR, oud->minor);
 +	oud->class_dev.class = &osd_uld_class;
 +	oud->class_dev.parent = dev;
 +	oud->class_dev.release = __remove;
 +
 +	/* hold one more reference to the scsi_device that will get released
 +	 * in __release, in case a logout is happening while fs is mounted
 +	 */
- 	scsi_device_get(scsi_device);
++	if (scsi_device_get(scsi_device))
++		goto err_retract_minor;
 +	osd_dev_init(&oud->od, scsi_device);
  
  	/* allocate a disk and set it up */
  	/* FIXME: do we need this since sg has already done that */
@@@ -507,16 -526,14 +508,15 @@@ static int osd_remove(struct device *de
  	struct scsi_device *scsi_device = to_scsi_device(dev);
  	struct osd_uld_device *oud = dev_get_drvdata(dev);
  
- 	if (!oud || (oud->od.scsi_device != scsi_device)) {
- 		OSD_ERR("Half cooked osd-device %p,%p || %p!=%p",
- 			dev, oud, oud ? oud->od.scsi_device : NULL,
- 			scsi_device);
+ 	if (oud->od.scsi_device != scsi_device) {
+ 		OSD_ERR("Half cooked osd-device %p, || %p!=%p",
+ 			dev, oud->od.scsi_device, scsi_device);
  	}
  
 -	device_unregister(&oud->class_dev);
 -
 +	cdev_device_del(&oud->cdev, &oud->class_dev);
 +	ida_remove(&osd_minor_ida, oud->minor);
  	put_device(&oud->class_dev);
 +
  	return 0;
  }
  
