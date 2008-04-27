From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] another tranche of SCSI updates for 2.6.26
Date: Sun, 27 Apr 2008 13:14:36 -0500
Message-ID: <1209320076.3801.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36065 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760051AbYD0SOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2008 14:14:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This represents the tree I had waitin on other mergers.  I'm not sure
this is it, because there are other features (like aic94xx running
abort) we're racing to get in.

The patch is available at:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (3):
      qla2xxx: make qla2x00_issue_iocb_timeout() static
      qla2xxx: qla_os.c, make 2 functions static
      FlashPoint: fix off-by-one errors

Andrew Vasquez (7):
      qla2xxx: Update version number to 8.02.01-k2.
      qla2xxx: Correct regression in relogin code.
      qla2xxx: Re-register FDMI information after a LIP.
      qla2xxx: Correct SRB usage-after-completion/free issues.
      qla2xxx: Correct ISP84XX verify-chip response handling.
      qla2xxx: Wakeup DPC thread to process any deferred-work requests.
      qla2xxx: Collapse RISC-RAM retrieval code during a firmware-dump.

David S. Miller (1):
      esp_scsi: Make cur_residue and tot_residue signed.

Denys Vlasenko (3):
      aic7xxx: add const
      aic7xxx: add static
      aic7xxx, aic79xx: deinline functions

FUJITA Tomonori (2):
      scsi_transport_sas: fix the lifetime of sas bsg objects
      bsg: add release callback support

Finn Thain (1):
      m68k: new mac_esp scsi driver

Hannes Reinecke (6):
      aic7xxx: Update _shipped files
      aic7xxx: teach aicasm to not emit unused debug code/data
      aic7xxx: Update type check in aicasm grammar
      use default attributes for scsi_host
      qla2xxx, lfpc: Rename 'state' attribute to 'link_state'
      add scsi_host and scsi_target to scsi_bus

James Bottomley (6):
      fix SLUB WARN_ON
      rework scsi_target allocation
      scsi_transport_spi: fix the attribute settings
      sysfs: make group is_valid return a mode_t
      ses: fix up functionality after class_device->device conversion
      st: fix up after class_device removal

James Smart (1):
      scsi_transport_fc: fc_user_scan correction

Jeff Garzik (2):
      aha1542: minor irq handler cleanups
      aha152x, eata, u14-34f: minor irq handler cleanups

Kay Sievers (1):
      jazz_esp, sgiwd93, sni_53c710, sun3x_esp: fix platform driver hotplug/cold

Randy Dunlap (1):
      scsi_transport_spi: include sysfs.h

Seokmann Ju (1):
      qla2xxx: Correct misc. endian and byte-ordering issues.

Sergei Shtylyov (2):
      aic79xx: fix MMIO for PPC 44x platforms
      aic7xxx: fix MMIO for PPC 44x platforms

Swen Schillig (3):
      zfcp: Add some statistics provided by the FCP adapter to the sysfs
      zfcp: Print some messages only during ERP
      zfcp: Wait for free SBAL during exchange config

And the diffstat:

 block/bsg.c                                      |   43 
 drivers/misc/enclosure.c                         |  100 +
 drivers/s390/scsi/zfcp_fsf.c                     |   39 
 drivers/s390/scsi/zfcp_fsf.h                     |   18 
 drivers/s390/scsi/zfcp_scsi.c                    |  114 +
 drivers/scsi/FlashPoint.c                        |    2 
 drivers/scsi/Kconfig                             |   10 
 drivers/scsi/Makefile                            |    1 
 drivers/scsi/aha152x.c                           |    7 
 drivers/scsi/aha1542.c                           |   26 
 drivers/scsi/aic7xxx/aic79xx.h                   |   23 
 drivers/scsi/aic7xxx/aic79xx.reg                 |  115 +
 drivers/scsi/aic7xxx/aic79xx_core.c              |  835 +++++++++++-
 drivers/scsi/aic7xxx/aic79xx_inline.h            |  859 ------------
 drivers/scsi/aic7xxx/aic79xx_osm.c               |  181 ++
 drivers/scsi/aic7xxx/aic79xx_osm.h               |  177 --
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c           |   33 
 drivers/scsi/aic7xxx/aic79xx_pci.c               |    8 
 drivers/scsi/aic7xxx/aic79xx_proc.c              |    2 
 drivers/scsi/aic7xxx/aic79xx_reg.h_shipped       | 1145 ++--------------
 drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped | 1555 ++---------------------
 drivers/scsi/aic7xxx/aic79xx_seq.h_shipped       |    6 
 drivers/scsi/aic7xxx/aic7xxx.h                   |   55 
 drivers/scsi/aic7xxx/aic7xxx.reg                 |   45 
 drivers/scsi/aic7xxx/aic7xxx_93cx6.c             |   16 
 drivers/scsi/aic7xxx/aic7xxx_core.c              |  676 +++++++++
 drivers/scsi/aic7xxx/aic7xxx_inline.h            |  616 ---------
 drivers/scsi/aic7xxx/aic7xxx_osm.c               |   95 +
 drivers/scsi/aic7xxx/aic7xxx_osm.h               |  142 --
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c           |   73 -
 drivers/scsi/aic7xxx/aic7xxx_pci.c               |    9 
 drivers/scsi/aic7xxx/aic7xxx_proc.c              |    4 
 drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped |  233 ---
 drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped       |    6 
 drivers/scsi/aic7xxx/aicasm/aicasm.c             |    6 
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y        |  105 +
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l        |   19 
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c      |   25 
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h      |    1 
 drivers/scsi/eata.c                              |   11 
 drivers/scsi/esp_scsi.c                          |   35 
 drivers/scsi/esp_scsi.h                          |   13 
 drivers/scsi/hosts.c                             |   29 
 drivers/scsi/jazz_esp.c                          |    4 
 drivers/scsi/lpfc/lpfc_attr.c                    |   10 
 drivers/scsi/mac_esp.c                           |  657 +++++++++
 drivers/scsi/qla2xxx/qla_attr.c                  |    8 
 drivers/scsi/qla2xxx/qla_dbg.c                   |  394 ++---
 drivers/scsi/qla2xxx/qla_fw.h                    |   26 
 drivers/scsi/qla2xxx/qla_gbl.h                   |    4 
 drivers/scsi/qla2xxx/qla_gs.c                    |    4 
 drivers/scsi/qla2xxx/qla_init.c                  |    2 
 drivers/scsi/qla2xxx/qla_isr.c                   |    4 
 drivers/scsi/qla2xxx/qla_mbx.c                   |   19 
 drivers/scsi/qla2xxx/qla_os.c                    |   12 
 drivers/scsi/qla2xxx/qla_version.h               |    2 
 drivers/scsi/scsi_priv.h                         |    1 
 drivers/scsi/scsi_proc.c                         |    7 
 drivers/scsi/scsi_scan.c                         |   84 -
 drivers/scsi/scsi_sysfs.c                        |  142 +-
 drivers/scsi/scsi_transport_fc.c                 |   60 
 drivers/scsi/scsi_transport_sas.c                |   22 
 drivers/scsi/scsi_transport_spi.c                |   33 
 drivers/scsi/sgiwd93.c                           |    4 
 drivers/scsi/sni_53c710.c                        |    2 
 drivers/scsi/st.c                                |   10 
 drivers/scsi/sun3x_esp.c                         |    2 
 drivers/scsi/u14-34f.c                           |    9 
 fs/sysfs/file.c                                  |   14 
 fs/sysfs/group.c                                 |   83 +
 fs/sysfs/sysfs.h                                 |    2 
 include/linux/bsg.h                              |   14 
 include/linux/sysfs.h                            |    4 
 include/scsi/scsi_device.h                       |    3 
 74 files changed, 4035 insertions(+), 5120 deletions(-)

James


