From: Jeff Garzik <jeff@garzik.org>
Subject: [git patches] libata update
Date: Fri, 12 Oct 2007 15:40:02 -0400
Message-ID: <20071012194002.GA1545@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759849AbXJLTk1@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


[ I just sent this upstream to Andrew and Linus ]

Now that I have nailed down the corruption problem, I can attend to
this...  Fun stuff:

* port multiplier support (like an ethernet hub, only dumber)

* Asynchronous notification -- finally userspace CD-ROM polling can go away!
  (NOTE: waiting on James B to apply the piece that actually makes this
  work...)

* Alan continues to hammer out edge cases in generic ATA support.  An
  amazing amount of ancient and/or obscure hardware works with libata   thanks to him :)

* Turn on ACPI by default (watch for bug reports!).  This should make
  suspend/resume work a lot better.

* New drivers for embedded ATA chips.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/kernel-parameters.txt  |    8 +-
 drivers/ata/Kconfig                  |   59 ++-
 drivers/ata/Makefile                 |    8 +-
 drivers/ata/ahci.c                   |  451 +++++++---
 drivers/ata/ata_generic.c            |   16 +-
 drivers/ata/ata_piix.c               |   71 +-
 drivers/ata/libata-acpi.c            |  165 +++-
 drivers/ata/libata-core.c            | 1329 ++++++++++++++++++----------
 drivers/ata/libata-eh.c              |  922 ++++++++++++++------
 drivers/ata/libata-pmp.c             | 1191 +++++++++++++++++++++++++
 drivers/ata/libata-scsi.c            |  496 +++++++----
 drivers/ata/libata-sff.c             |   69 +-
 drivers/ata/libata.h                 |   41 +-
 drivers/ata/pata_acpi.c              |  395 ++++++++
 drivers/ata/pata_ali.c               |   17 +-
 drivers/ata/pata_amd.c               |   43 +-
 drivers/ata/pata_artop.c             |   20 +-
 drivers/ata/pata_at32.c              |  441 +++++++++
 drivers/ata/pata_atiixp.c            |   15 +-
 drivers/ata/pata_bf54x.c             | 1627 ++++++++++++++++++++++++++++++++++
 drivers/ata/pata_cmd640.c            |    4 +-
 drivers/ata/pata_cmd64x.c            |   43 +-
 drivers/ata/pata_cs5520.c            |   47 +-
 drivers/ata/pata_cs5530.c            |    4 +-
 drivers/ata/pata_cs5535.c            |    4 +-
 drivers/ata/pata_cypress.c           |    4 +-
 drivers/ata/pata_efar.c              |   11 +-
 drivers/ata/pata_hpt366.c            |    4 +-
 drivers/ata/pata_hpt37x.c            |   28 +-
 drivers/ata/pata_hpt3x2n.c           |   11 +-
 drivers/ata/pata_hpt3x3.c            |   10 +-
 drivers/ata/pata_icside.c            |   39 +-
 drivers/ata/pata_isapnp.c            |    8 +-
 drivers/ata/pata_it8213.c            |   11 +-
 drivers/ata/pata_it821x.c            |   17 +-
 drivers/ata/pata_ixp4xx_cf.c         |   24 +-
 drivers/ata/pata_jmicron.c           |   24 +-
 drivers/ata/pata_legacy.c            |   27 +-
 drivers/ata/pata_marvell.c           |   12 +-
 drivers/ata/pata_mpc52xx.c           |    9 +-
 drivers/ata/pata_mpiix.c             |   25 +-
 drivers/ata/pata_netcell.c           |    5 +-
 drivers/ata/pata_ns87410.c           |   11 +-
 drivers/ata/pata_ns87415.c           |  467 ++++++++++
 drivers/ata/pata_oldpiix.c           |   11 +-
 drivers/ata/pata_opti.c              |   11 +-
 drivers/ata/pata_optidma.c           |   26 +-
 drivers/ata/pata_pcmcia.c            |   16 +-
 drivers/ata/pata_pdc2027x.c          |  114 ++--
 drivers/ata/pata_pdc202xx_old.c      |   23 +-
 drivers/ata/pata_platform.c          |   16 +-
 drivers/ata/pata_qdi.c               |   15 +-
 drivers/ata/pata_radisys.c           |    4 +-
 drivers/ata/pata_rz1000.c            |   13 +-
 drivers/ata/pata_sc1200.c            |    4 +-
 drivers/ata/pata_scc.c               |   66 +-
 drivers/ata/pata_serverworks.c       |    8 +-
 drivers/ata/pata_sil680.c            |   11 +-
 drivers/ata/pata_sis.c               |   33 +-
 drivers/ata/pata_sl82c105.c          |   11 +-
 drivers/ata/pata_triflex.c           |   11 +-
 drivers/ata/pata_via.c               |   16 +-
 drivers/ata/pata_winbond.c           |   13 +-
 drivers/ata/pdc_adma.c               |  103 ++-
 drivers/ata/sata_inic162x.c          |   34 +-
 drivers/ata/sata_mv.c                |   68 +-
 drivers/ata/sata_nv.c                |   53 +-
 drivers/ata/sata_promise.c           |   27 +-
 drivers/ata/sata_qstor.c             |   17 +-
 drivers/ata/sata_sil.c               |   53 +-
 drivers/ata/sata_sil24.c             |  341 ++++++--
 drivers/ata/sata_sis.c               |    2 -
 drivers/ata/sata_svw.c               |   14 +-
 drivers/ata/sata_sx4.c               |   25 +-
 drivers/ata/sata_uli.c               |   16 +-
 drivers/ata/sata_via.c               |   35 +-
 drivers/ata/sata_vsc.c               |   16 +-
 drivers/scsi/ipr.c                   |   19 +-
 drivers/scsi/libsas/sas_ata.c        |   11 +-
 include/asm-generic/libata-portmap.h |    5 -
 include/linux/ata.h                  |  116 +++-
 include/linux/libata.h               |  320 +++++--
 82 files changed, 7866 insertions(+), 2064 deletions(-)
 create mode 100644 drivers/ata/libata-pmp.c
 create mode 100644 drivers/ata/pata_acpi.c
 create mode 100644 drivers/ata/pata_at32.c
 create mode 100644 drivers/ata/pata_bf54x.c
 create mode 100644 drivers/ata/pata_ns87415.c

Alan Cox (22):
      libata: Correct IORDY handling
      libata-core: Document some limits/assumptions about ID_ATA
      libata: Note that our cache flush code needs fixing up
      pata_cmd64x: Set up MWDMA modes properly
      [libata] add ACPI cable detect API
      libata pata_amd: ACPI checks for 80wire cable
      libata pata_via: ACPI checks for 80wire cable
      libata: Switch most of the remaining SFF drivers to ata_sff_port_start
      libata-portmap: Remove unused definitions
      libata: Spot bridge chips
      libata: Strict checking for identify reporting
      libata: Update experimental tags to reflect reality better
      pdc2027x: Switch properly to ioread/iowrite
      pata_atiixp: Audit notes on locking
      pata_pdc202xx_old MWDMA fixes, and notes
      pata_ns87415: Initial cut at 87415/87560 IDE support
      libata: Fix HPA handling regression
      libata: Add a drivers/ide style DMA disable
      libata: correct handling of SRST reset sequences
      libata_scsi: Fix ATAPI transfer lengths
      libata-core: Expose gtm methods for driver use
      pata_acpi: ACPI driver support

Albert Lee (2):
      libata: move ata_altstatus() to pio data xfer functions
      libata: pata_pdc2027x PLL detection minor cleanup

Andrew Morton (1):
      libata-add-irq_flags-to-struct-pata_platform_info-fix

Boaz Harrosh (2):
      libata-scsi: Remove !use_sg code paths
      libata-scsi: convert to use the data buffer accessors

Christian Lamparter (1):
      ata_piix: disallow UDMA 133 on ICH5 & ICH7

Dave Jones (1):
      libata: correct kernel parameter in documentation.

David Milburn (1):
      libata-core: blacklist HITACHI HDS drives using wildcard blacklist matching

Jason Gaston (2):
      ata_piix: replace spaces with tabs
      ahci: RAID mode SATA patch for Intel Tolapai

Jeff Garzik (14):
      [libata] pdc_adma: convert to new exception handling (EH) framework
      [libata] Remove ->irq_ack() hook, and ata_dummy_irq_on()
      [libata] Remove ->port_disable() hook
      [libata] ata_piix: Use more-robust form of array initialization
      [libata] blacklist Maxtor*BANC* using new wildcard blacklist matching
      [libata] SCSI: support INQUIRY page 89h (ATA info page)
      [libata] Slightly improved no-op REQUEST SENSE, SEND DIAGNOSTIC
      [libata] SCSI: improve FORMAT UNIT; minor code cleanups
      [libata] SCSI: clean up R/W recovery mode page
      [libata] SCSI: simulator version, not device version, belongs in VPD
      [libata] AHCI: enable AHCI mode, before using AHCI reset
      [libata] ata_piix: add HP compaq laptop to short cable list
      [libata] Turn on ACPI by default
      [libata] struct pci_dev related cleanups

Kristen Carlson Accardi (4):
      [libata] check for SATA async notify support
      [libata] ahci: send event when AN received
      ahci: Store interrupt value
      ata: increase allowed config flags

Kristoffer Nyborg Gregertsen (1):
      AVR32 PATA driver

Mark Lord (1):
      libata: add support for ATA_16 on ATAPI

Matthew Garrett (1):
      libata: Integrate ACPI-based PATA/SATA hotplug - version 5

Paolo Ornati (1):
      libata: blacklist NCQ on Seagate Barracuda ST380817AS

Peer Chen (1):
      ahci: Add MCP79 support to AHCI driver

Robert Hancock (1):
      libata: add human-readable error value decoding

Satyam Sharma (1):
      libata: Fix build failure on ppc64 drivers/ata/pata_scc.c

Sonic Zhang (1):
      libata driver for bf548 on chip ATAPI controller.

Tejun Heo (61):
      libata-link: introduce ata_link
      libata-link: implement and use link/device iterators
      libata-link: linkify PHY-related functions
      libata-link: linkify EH action helpers
      libata-link: linkify reset
      libata-link: linkify config/EH related functions
      libata-link: make two port flags HRST_TO_RESUME and SKIP_D2H_BSY link flags
      libata-link: separate out link initialization functions
      libata-link: implement ata_link_abort()
      libata-link: add PMP links
      libata-link: update ata_scsi_error() to handle PMP links
      libata-link: update EH to deal with PMP links
      libata-link: update hotplug to handle PMP links
      libata-link: update Power Management to handle PMP links
      libata: use ata_port_printk() in ata_wait_idle()
      libata: add printf format attribute to ehi desc functions
      libata: implement and use ata_port_desc() to report port configuration
      libata: move EH repeat reporting into ata_eh_report()
      libata: move ata_id_n_sectors() upward
      libata: clean up read/set native_max address functions
      libata: remiplement ata_hpa_resize()
      ahci: reimplement port_map handling
      libata: update ata_dev_try_classify() arguments
      libata: assume ATA_DEV_ATA on diagnostic failure
      libata: misc updates for AN
      libata-pmp-prep: add PMP related constants, fields, ops and update helpers
      libata-pmp-prep: add @new_class to ata_dev_revalidate()
      libata-pmp-prep: make a number of functions global to libata
      libata-pmp-prep: implement ops->qc_defer()
      libata-pmp-prep: implement qc_defer helpers
      libata-pmp-prep: implement ATA_LFLAG_NO_SRST, ASSUME_ATA and ASSUME_SEMB
      libata-pmp-prep: implement ATA_LFLAG_NO_RETRY
      libata-pmp-prep: implement ATA_LFLAG_DISABLED
      libata-pmp-prep: implement EH fast-fail path
      libata-pmp-prep: implement ATA_HORKAGE_SKIP_PM
      libata-pmp-prep: implement sata_async_notification()
      libata: fix ata_set_max_sectors()
      sata_via: kill SATA_PATA_SHARING register handling
      libata: update spurious NCQ completion blacklist
      libata-pmp: update ata_eh_reset() for PMP
      libata-pmp: implement Port Multiplier support
      libata-pmp: hook PMP support and enable it
      libata-pmp: extend ACPI support to cover PMP
      libata-pmp: implement qc_defer for command switching PMP support
      sata_sil24: implement PMP support
      sata_sil24: implement PORT_RST
      ahci: implement PMP support
      ahci: move host flags over to pi.private_data
      ahci: implement AHCI_HFLAG_NO_PMP
      libata: add HDT722516DLA380 to NCQ blacklist
      libata: add ST9160821AS / 3.ALD to NCQ blacklist
      pata_jmicron: match vendor and class code only
      libata: clear ehi description after initial host report
      libata: skip suppress reporting if ATA_EHI_QUIET
      libata: wrap schedule_timeout_uninterruptible() in loop
      ahci: kill leftover from enabling NCQ over PMP
      ahci: clean up PORT_IRQ_BAD_PMP enabling
      ahci: fix notification handling
      libata: add @timeout to ata_exec_internal[_sg]()
      libata: implement ATA_PFLAG_RESETTING
      libata: use ata_exec_internal() for PMP register access

[patch snipped due to size; grab it from git]
