From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Thu, 07 Feb 2008 18:56:46 -0600
Message-ID: <1202432206.3171.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933359AbYBHA5K@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Quite a bit of this is fixing things broken previously (the advansys fix
is still pending resolution, but I'll send it as an -rc fix when we have
it).  There's the final elimination of all drivers that are esp based
but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
the usual bunch of driver updates and the addition of a new enclosure
services driver and the corresponding ULD.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (2):
      advansys: make 3 functions static
      libiscsi: make __iscsi_complete_pdu() static

Aegis Lin (1):
      ps3rom: sector size should be 512 bytes

Andrew Morton (1):
      dc395x: fix uninitialized var warning

Andrew Vasquez (9):
      qla2xxx: Update version number to 8.02.00-k8.
      qla2xxx: Correct issue where incorrect init-fw mailbox command was used on
      qla2xxx: Move RISC-interrupt-register modifications to qla2x00_request_irq
      qla2xxx: Consolidate RISC-parity enablement codes.
      qla2xxx: Cleanse memory allocation logic during probe.
      qla2xxx: Clear EFT buffer before firmware reinitialization.
      qla2xxx: Cleanup any outstanding SRB resources during shutdown.
      qla2xxx: Add MODULE_FIRMWARE hint for ISP25XX firmware.
      qla2xxx: Correct resource_size_t usages.

Boaz Harrosh (1):
      arm: convert to accessors and !use_sg cleanup

James Bottomley (10):
      ses: add new Enclosure ULD
      enclosure: add support for enclosure services
      sr: fix test unit ready responses
      NCR53C9x: remove driver
      remove m68k NCR53C9x based drivers
      dec_esp: Remove driver
      update my email address
      add protocol definitions
      sd: handle bad lba in sense information
      mca_53c9x: remove driver

Mike Christie (12):
      iscsi: bump version to 2.0-868
      libiscsi: fix session age rollover and remove cid encoding
      iscsi: fix up iscsi printk prefix
      iscsi class: fix iscsi conn attr counter
      libiscsi: fix setting of nop timer
      qla4xxx: add async scan support
      iscsi class: add async scan helper
      qla4xxx: fix recovery timer and session unblock race
      iscsi class: add session scanning
      qla4xxx: use iscsi class session state check ready
      qla4xxx: directly call iscsi recovery functions
      iscsi class, libiscsi: add iscsi sysfs session state file

Nick Cheng (1):
      arcmsr: updates (1.20.00.15)

Pavel Machek (1):
      Small cleanups for scsi_host.h

Randy Dunlap (1):
      kernel-doc: fix scsi docbook

Roel Kluin (1):
      u14-34f: fix data direction bug

Salyzyn, Mark (3):
      aacraid: do not set valid bit in sense information
      aacraid: pci_set_dma_max_seg_size opened up for late model controllers
      aacraid: fib context lock for management ioctls (take 2)

Seokmann Ju (2):
      qla2xxx: Access the proper 'physical' port in FC-transport callbacks.
      qla2xxx: Correct issue where vport-state was not updated during an ISP_ABO

Thomas Bogendoerfer (1):
      sun3x_esp: convert to esp_scsi

Tony Battersby (2):
      fix BUG when sum(scatterlist) > bufflen
      sym53c8xx: fix resid calculation

and the diffstat:

 Documentation/DocBook/scsi.tmpl         |    2 
 Documentation/scsi/ChangeLog.arcmsr     |   41 
 Documentation/scsi/scsi_mid_low_api.txt |    2 
 drivers/misc/Kconfig                    |    9 
 drivers/misc/Makefile                   |    1 
 drivers/misc/enclosure.c                |  484 ++++
 drivers/scsi/Kconfig                    |   93 
 drivers/scsi/Makefile                   |   12 
 drivers/scsi/NCR53C9x.c                 | 3654 --------------------------------
 drivers/scsi/NCR53C9x.h                 |  668 -----
 drivers/scsi/aacraid/aachba.c           |   81 
 drivers/scsi/aacraid/commctrl.c         |   26 
 drivers/scsi/aacraid/linit.c            |   28 
 drivers/scsi/advansys.c                 |    6 
 drivers/scsi/arcmsr/arcmsr.h            |    4 
 drivers/scsi/arcmsr/arcmsr_hba.c        |   87 
 drivers/scsi/arm/acornscsi.c            |   14 
 drivers/scsi/arm/scsi.h                 |   87 
 drivers/scsi/blz1230.c                  |  353 ---
 drivers/scsi/blz2060.c                  |  306 --
 drivers/scsi/cyberstorm.c               |  377 ---
 drivers/scsi/cyberstormII.c             |  314 --
 drivers/scsi/dc395x.c                   |    2 
 drivers/scsi/dec_esp.c                  |  687 ------
 drivers/scsi/fastlane.c                 |  421 ---
 drivers/scsi/iscsi_tcp.c                |   57 
 drivers/scsi/libiscsi.c                 |  137 -
 drivers/scsi/mac_esp.c                  |  751 ------
 drivers/scsi/mca_53c9x.c                |  520 ----
 drivers/scsi/oktagon_esp.c              |  606 -----
 drivers/scsi/oktagon_io.S               |  194 -
 drivers/scsi/ps3rom.c                   |    2 
 drivers/scsi/qla2xxx/qla_attr.c         |   24 
 drivers/scsi/qla2xxx/qla_def.h          |    2 
 drivers/scsi/qla2xxx/qla_gbl.h          |    1 
 drivers/scsi/qla2xxx/qla_init.c         |   87 
 drivers/scsi/qla2xxx/qla_inline.h       |    7 
 drivers/scsi/qla2xxx/qla_isr.c          |   27 
 drivers/scsi/qla2xxx/qla_mbx.c          |    2 
 drivers/scsi/qla2xxx/qla_os.c           |  404 +--
 drivers/scsi/qla2xxx/qla_sup.c          |   36 
 drivers/scsi/qla2xxx/qla_version.h      |    2 
 drivers/scsi/qla4xxx/ql4_init.c         |    1 
 drivers/scsi/qla4xxx/ql4_os.c           |   75 
 drivers/scsi/scsi.c                     |    5 
 drivers/scsi/scsi_lib.c                 |    1 
 drivers/scsi/scsi_transport_iscsi.c     |  238 +-
 drivers/scsi/sd.c                       |   34 
 drivers/scsi/ses.c                      |  689 ++++++
 drivers/scsi/sr.c                       |   49 
 drivers/scsi/sr.h                       |    1 
 drivers/scsi/sr_ioctl.c                 |    3 
 drivers/scsi/sun3x_esp.c                |  546 ++--
 drivers/scsi/sym53c8xx_2/sym_hipd.c     |    2 
 drivers/scsi/u14-34f.c                  |    2 
 include/linux/enclosure.h               |  129 +
 include/scsi/iscsi_proto.h              |    4 
 include/scsi/libiscsi.h                 |   30 
 include/scsi/scsi.h                     |   14 
 include/scsi/scsi_host.h                |   44 
 include/scsi/scsi_transport_iscsi.h     |   43 
 61 files changed, 2494 insertions(+), 10034 deletions(-)

James
