From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.7+ merge window
Date: Wed, 27 Jul 2016 07:56:58 -0400
Message-ID: <1469620618.27356.15.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This update includes the usual round of driver updates (fcoe, lpfc,
ufs, qla2xxx, hisi_sas).  The most important other change is removing
the flag to allow non-blk_mq on a per host basis (it's unused); there
is still a global module parameter for all of SCSI just in case.  The
rest are an assortment of minor fixes and typo updates.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Arnd Bergmann (3):
      scsi: lpfc: avoid harmless comparison warning
      scsi: wd7000: print sector number as 64-bit
      scsi: libfc: fix seconds_since_last_reset calculation

Cathy Avery (1):
      scsi: storvsc: Filter out storvsc messages CD-ROM medium not present

Chris Leech (1):
      libfc: sanity check cpu number extracted from xid

Christoph Hellwig (2):
      scsi: remove the disable_blk_mq host flag
      scsi: remove current_cmnd field from struct scsi_device

Colin Ian King (1):
      bnx2i: fix spelling mistake "complection" -> "completion"

Dan Carpenter (2):
      fnic: pci_dma_mapping_error() doesn't return an error code
      ibmvfc: prevent a potential deadlock

Dave Carroll (1):
      MAINTAINERS: Update email address for aacraid

Don Brace (2):
      hpsa: change hpsa_passthru_ioctl timeout
      hpsa: correct skipping masked peripherals

Douglas Gilbert (1):
      scsi_debug: fix sleep in invalid context

Geert Uytterhoeven (1):
      MAINTAINERS: Add file patterns for scsi device tree bindings

Giridhar Malavali (1):
      qla2xxx: Set FLOGI retry in additional firmware options for P2P (N2N) mode.

Hannes Reinecke (7):
      fcoe: implement FIP VLAN responder
      fcoe: Rename 'fip_frame' to 'fip_vn2vn_notify_frame'
      fcoe: Update multicast addresses on FIP mode change
      fcoe: fcoe->realdev is always set
      fcoe: use enum for fip_mode
      fc_fip: Update to latest FC-BB-6 draft
      libfc: Update rport reference counting

Hans de Goede (1):
      usb: MAINTAINERS: Oliver Neukum is the new uas maintainer

Helge Deller (1):
      53c700: Use proper debug printk format specifiers

Himanshu Madhani (1):
      qla2xxx: Update driver version to 8.07.00.38-k

James Smart (21):
      lpfc: Update lpfc version to 11.2.0.0
      lpfc: Copyright updates
      lpfc: Disable FDMI probing if not connected to a fabric
      lpfc: Correct issue with ioremap() call on 32bit kernel
      lpfc: Re-organize source for easier driver attribute management
      lpfc: Remove global lpfc_sli_mode attribute in leiu of per-hba lpfc_sli_mode
      lpfc: Remove global lpfc_delay_discovery attribute in leiu of per-hba lpfc_delay_discovery
      lpfc: Remove global lpfc_enable_npiv attribute in leiu of per-hba lpfc_enable_npiv
      lpfc: Correct Port reset resulting in FC port going offline
      lpfc: Add support for XLane LUN priority
      lpfc: Correct RDP response Revision location
      lpfc: Re-organize source for easier device-id management
      lpfc: Correct FCOE discovery to avoid loss of storage devices after system reboot
      lpfc: Fix SLI mode 2 config failure
      lpfc: Add MDS Diagnostics Support
      lpfc: Add sysfs proc_name support
      lpfc: Reject RDP ELS if port has no login
      lpfc: Correct Buffer credit descriptor values in RDP response
      lpfc: Add recovery from adapter parity errors on some SLI4 adapters
      lpfc: Correct RDP response sizing issue
      lpfc: Fix Transgression Flag of Optical Element descriptor for RDP on Linux

Jim Gill (1):
      vmw_pvscsi: Change to update maintainer details (name, email)

Joao Pinto (10):
      ufs: Adding license info do tc-dwc-g210 and ufshcd-dwc to enable loadable module
      ufs: add TC G210 pci driver
      ufs: add TC G210 platform driver
      ufs: add support for Synopsys G210 Test Chip
      ufs: add support for DesignWare Controller
      ufs: add link status to ufshci
      ufs: add unipro attributes
      ufs: add UFS 2.0 capabilities
      ufs: add UFS 2.0 to ufshcd-pltfrm bindings
      ufs: fixed typo in ufshcd-pltfrm

Joe Carnuccio (12):
      qla2xxx: Separate ISP type bits out from device type.
      qla2xxx: Correction to function qla26xx_dport_diagnostics().
      qla2xxx: Add support to handle Loop Init error Asynchronus event.
      qla2xxx: Let DPORT be enabled purely by nvram.
      qla2xxx: Add bsg interface to support D_Port Diagnostics.
      qla2xxx: Properly reset firmware statistics.
      qla2xxx: Properly initialize IO statistics.
      qla2xxx: Make debug buffer log easier to view.
      qla2xxx: Add module parameter alternate/short names.
      qla2xxx: Shutdown board on thermal shutdown aen.
      qla2xxx: Add ram area DDR for fwdump template entry T262.
      qla2xxx: Remove sysfs node fw_dump_template.

Joe Lawrence (2):
      mpt3sas: avoid mpt3sas_transport_port_add NULL parent_dev
      mpt3sas: set num_phys after allocating phy[] space

Johannes Thumshirn (5):
      lpfc: call lpfc_sli_validate_fcp_iocb() with the hbalock held
      qla2xxx: setup data needed in ISR before setting up the ISR
      fcoe: use defines from ethtool for 20Gbit and 40Gbit speeds
      MAINTAINERS: Change FCoE maintainer
      snic: Fix use-after-free in case of a dma mapping error

John Garry (3):
      hisi_sas: update driver version to 1.5
      hisi_sas: fix the inconsistent lock issue reported by CONFIG_PROVE_LOCKING
      hisi_sas: add v2 hw ACPI support

Julia Lawall (2):
      pm8001: fix typo
      snic: fix typo

Kefeng Wang (1):
      mpt3sas: Fix panic when aer correct error occurred

Manjunath M B (1):
      scsi: ufs: tc-dwc-g210 driver fix for 20-bit RMMI

Manoj N. Kumar (1):
      cxlflash: Fix to drain operations from previous reset

Maurizio Lombardi (1):
      bnx2fc: replace printk() with BNX2FC_IO_DBG()

Muhammad Falak R Wani (1):
      aacraid: use kmemdup

Randy Dunlap (1):
      scsi: ultrastor.c depends on ISA_DMA_API

Sawan Chandak (5):
      qla2xxx: Fix BBCR offset
      qla2xxx: Fix duplicate message id.
      qla2xxx: Disable the adapter and skip error recovery in case of register disconnect.
      qla2xxx: Add bsg interface to support statistics counter reset.
      qla2xxx: Check for device state before unloading the driver.

Sebastian Andrzej Siewior (1):
      fcoe: convert to kworker

Sumit Saxena (1):
      megaraid_sas: Do not fire MR_DCMD_PD_LIST_QUERY to controllers which do not support it

Tiezhu Yang (1):
      scsi: ufs: remove unnecessary goto label

Uma Krishnan (2):
      cxlflash: Shutdown notify support for CXL Flash cards
      cxlflash: Add device dependent flags

Wei Fang (1):
      scsi:libsas: fix oops caused by assigning a freed task to ->lldd_task

Wen Xiong (2):
      ipr: Increase MSIX vectors number
      ipr: Add new CCIN for new adapters support
And the diffstat:

 .../devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt |  26 ++
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   4 +-
 MAINTAINERS                                        |  16 +-
 drivers/scsi/53c700.c                              |  10 +-
 drivers/scsi/53c700.h                              |  15 +-
 drivers/scsi/Kconfig                               |   2 +-
 drivers/scsi/aacraid/commctrl.c                    |   7 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |  14 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |   2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |   2 +-
 drivers/scsi/cxlflash/main.c                       |  98 ++++++-
 drivers/scsi/cxlflash/main.h                       |   2 +
 drivers/scsi/cxlflash/sislite.h                    |   6 +
 drivers/scsi/fcoe/fcoe.c                           | 322 ++++-----------------
 drivers/scsi/fcoe/fcoe_ctlr.c                      | 245 +++++++++++++++-
 drivers/scsi/fcoe/fcoe_sysfs.c                     |  39 +++
 drivers/scsi/fcoe/fcoe_transport.c                 |   4 +-
 drivers/scsi/fnic/fnic_fcs.c                       |  14 +-
 drivers/scsi/fnic/fnic_fip.h                       |   8 -
 drivers/scsi/hisi_sas/hisi_sas.h                   |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  73 +++--
 drivers/scsi/hosts.c                               |   2 -
 drivers/scsi/hpsa.c                                |  83 +++++-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   2 +
 drivers/scsi/ipr.c                                 |  11 +-
 drivers/scsi/ipr.h                                 |   3 +
 drivers/scsi/libfc/fc_exch.c                       |  10 +-
 drivers/scsi/libfc/fc_lport.c                      |  24 +-
 drivers/scsi/libfc/fc_rport.c                      |  49 ++--
 drivers/scsi/libsas/sas_ata.c                      |   1 +
 drivers/scsi/lpfc/lpfc.h                           |  27 +-
 drivers/scsi/lpfc/lpfc_attr.c                      | 237 +++++++--------
 drivers/scsi/lpfc/lpfc_attr.h                      | 116 ++++++++
 drivers/scsi/lpfc/lpfc_crtn.h                      |   7 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   4 +
 drivers/scsi/lpfc/lpfc_els.c                       | 290 ++++++++++++-------
 drivers/scsi/lpfc/lpfc_hw.h                        |  36 +--
 drivers/scsi/lpfc/lpfc_hw4.h                       |  41 ++-
 drivers/scsi/lpfc/lpfc_ids.h                       | 122 ++++++++
 drivers/scsi/lpfc/lpfc_init.c                      | 277 +++++++++---------
 drivers/scsi/lpfc/lpfc_scsi.c                      |  14 +-
 drivers/scsi/lpfc/lpfc_scsi.h                      |   3 +-
 drivers/scsi/lpfc/lpfc_sli.c                       | 101 ++++++-
 drivers/scsi/lpfc/lpfc_sli.h                       |   3 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   4 +-
 drivers/scsi/lpfc/lpfc_version.h                   |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   6 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  27 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   5 +
 drivers/scsi/pm8001/pm8001_init.c                  |   2 +-
 drivers/scsi/qla2xxx/qla_attr.c                    | 170 ++++-------
 drivers/scsi/qla2xxx/qla_bsg.c                     |  93 ++++--
 drivers/scsi/qla2xxx/qla_bsg.h                     |  13 +
 drivers/scsi/qla2xxx/qla_dbg.c                     |  50 ++--
 drivers/scsi/qla2xxx/qla_def.h                     |  12 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   5 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  39 ++-
 drivers/scsi/qla2xxx/qla_isr.c                     |  31 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     | 123 ++++++--
 drivers/scsi/qla2xxx/qla_os.c                      | 127 ++++++--
 drivers/scsi/qla2xxx/qla_target.c                  |  16 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |   9 +-
 drivers/scsi/qla2xxx/qla_version.h                 |   2 +-
 drivers/scsi/scsi.c                                |   1 +
 drivers/scsi/scsi_debug.c                          |  93 ++++--
 drivers/scsi/snic/snic_disc.c                      |   4 +-
 drivers/scsi/snic/snic_fwint.h                     |   2 +-
 drivers/scsi/storvsc_drv.c                         |   2 +
 drivers/scsi/ufs/Kconfig                           |  16 +
 drivers/scsi/ufs/Makefile                          |   2 +
 drivers/scsi/ufs/tc-dwc-g210-pci.c                 | 181 ++++++++++++
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c              | 113 ++++++++
 drivers/scsi/ufs/tc-dwc-g210.c                     | 319 ++++++++++++++++++++
 drivers/scsi/ufs/tc-dwc-g210.h                     |  19 ++
 drivers/scsi/ufs/ufshcd-dwc.c                      | 154 ++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h                      |  26 ++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  92 +++---
 drivers/scsi/ufs/ufshcd.h                          |   7 +
 drivers/scsi/ufs/ufshci-dwc.h                      |  36 +++
 drivers/scsi/ufs/ufshci.h                          |  11 +
 drivers/scsi/ufs/unipro.h                          |  39 +++
 drivers/scsi/vmw_pvscsi.c                          |   2 +-
 drivers/scsi/vmw_pvscsi.h                          |   2 +-
 drivers/scsi/wd7000.c                              |   6 +-
 include/scsi/fc/fc_fip.h                           |  21 +-
 include/scsi/libfc.h                               |   1 +
 include/scsi/libfcoe.h                             |  25 +-
 include/scsi/scsi_device.h                         |   1 -
 include/scsi/scsi_host.h                           |   6 +-
 91 files changed, 3098 insertions(+), 1197 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
 create mode 100644 drivers/scsi/lpfc/lpfc_attr.h
 create mode 100644 drivers/scsi/lpfc/lpfc_ids.h
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210-pci.c
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210.c
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210.h
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
 create mode 100644 drivers/scsi/ufs/ufshci-dwc.h


James
