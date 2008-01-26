From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI updates for 2.6.24 (part 1)
Date: Fri, 25 Jan 2008 18:50:49 -0600
Message-ID: <1201308650.3119.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45958 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758340AbYAZAu4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 19:50:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

We have a difficult merge this time; the SCSI tree is split between
components that can go now and pieces that are waiting on other trees.
Part 1 is the components that can go now ... you'll be getting part 2
towards the end of the merge window.

There's misc driver updates, the accessor conversions (peparation for
large scatterlists) and tons of other misc updates.

There are also some sysfs changes (with Greg's ack) because of the way
the dependencies thread through SCSI.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (4):
      qla2xxx: Code cleanups.
      megaraid: add __devexit annotation
      lpfc: minor cleanups
      53c7xx: fix removal fallout

Alan Cox (1):
      aacraid: fix security weakness

Andi Kleen (1):
      sg: Only print SCSI data direction warning once for a command

Andrew Morton (1):
      sgiwd93: export sgiwd93_reset()

Andrew Vasquez (13):
      qla2xxx: Update version number to 8.02.00-k7.
      qla2xxx: Correct late-memset() of EFT buffer.
      qla2xxx: Add Fibre Channel Event (FCE) tracing support.
      qla2xxx: Trace-Control naming cleanups.
      qla2xxx: Don't schedule the DPC routine to perform an issue-lip request.
      qla2xxx: Restrict MSI/MSI-X enablement on select ISP2432-type HBAs.
      qla2xxx: Wait for FLASH write-protection to complete after a write.
      qla2xxx: Fix for 32-bit platforms with 64-bit resources.
      qla2xxx: Retrieve additional HBA port statistics from recent ISPs.
      qla2xxx: Consolidate duplicate sense-data handling codes.
      qla2xxx: Update version number to 8.02.00-k6.
      qla2xxx: Correct NPIV support for recent ISPs.
      qla2xxx: Don't explicitly read mbx registers while processing a system-err

Boaz Harrosh (26):
      libiscsi,iser: patch for AHS support
      iscsi_tcp, libiscsi: initial AHS Support
      iscsi: Prettify resid handling and some extra checks
      imm: convert to accessors and !use_sg cleanup
      ppa: convert to accessors and !use_sg cleanup
      NCR5380 family: convert to accessors & !use_sg cleanup
      wd7000: proper fix for boards without sg support
      atp870u: convert to accessors and !use_sg cleanup
      scsi_debug: convert to use the data buffer accessors
      isd200: use one-element sg list in issuing commands
      usb: transport - convert to accessors and !use_sg code path removal
      usb: shuttle_usbat - convert to accessors and !use_sg code path removal
      usb: freecom & sddr09 - convert to accessors and !use_sg cleanup
      usb: protocol - convert to accessors and !use_sg code path removal
      seagate: Remove driver
      psi240i: remove driver
      in2000: convert to accessors and !use_sg cleanup
      qlogicpti: convert to accessors and !use_sg cleanup
      wd33c93: convert to accessors and !use_sg cleanup
      fd_mcs: convert to accessors and !use_sg cleanup
      aha1542: convert to accessors and !use_sg cleanup
      a3000: convert to accessors and !use_sg cleanup
      a2091: convert to accessors and !use_sg cleanup
      eata_pio: convert to accessors and !use_sg cleanup
      nsp_cs: convert to data accessors and !use_sg cleanup
      aha152x: Use scsi_eh API for REQUEST_SENSE invocation

Brian King (1):
      ibmvscsi: Set default command timeout

Christof Schmitt (11):
      zfcp: Hold queue lock when checking port/unit handle for task management c
      zfcp: Hold queue lock when checking port/unit handle for FCP command
      zfcp: Hold queue lock when checking port handle for ELS command
      zfcp: Hold queue lock when checking port/unit handle for abort command
      zfcp: Fix evaluation of port handles in abort handler
      zfcp: Reduce flood on hba trace
      zfcp: Fix deadlock when adding invalid LUN
      zfcp: Remove SCSI devices when removing complete adapter
      zfcp: Specify waiting times in ERP in seconds
      zfcp: Use also port and adapter to identify unit in messages.
      zfcp: Remove unnecessary eh_bus_reset_handler callback

Christoph Hellwig (1):
      aacraid: don't assign cpu_to_le32(int) to u8

Darrick J. Wong (2):
      libsas: Fix various sparse complaints
      libsas: Convert sas_proto users to sas_protocol

Denis Cheng (1):
      ipr: use LIST_HEAD instead of LIST_HEAD_INIT

Erez Zilber (1):
      IB/iSER: add logical unit reset support

FUJITA Tomonori (13):
      ch: remove forward declarations
      ch: fix device minor number management bug
      ch: handle class_device_create failure properly
      use dynamically allocated sense buffer
      sg: handle class_device_create failure properly
      sg: set class_data after success
      replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
      aic7xxx_old, eata_pio, ips, libsas: don't zero out sense_buffer in queueco
      libsas: fix sense_buffer overrun
      fix scsi_setup_command_freelist failure path race
      mpt fusion: make mptsas_smp_handler update resid
      iscsi_tcp: update the website URL
      tgt: convert to use the data buffer accessors

Frederik Deweerdt (1):
      ultrastor: clean up inline asm warnings

Gilbert Wu (1):
      aic94xx: update BIOS image from user space.

Hans de Goede (2):
      usbstorage: use last_sector_bug flag universally
      sd: add fix for devices with last sector access problems

Heiko Carstens (1):
      zfcp: fix use after free bug.

HighPoint Linux Team (1):
      hptiop: add more adapter models and other fixes

James Bottomley (19):
      libsas: abstract STP task status into a function
      don't use __GFP_DMA for sense buffers if not required
      scsi.h: add macro for enclosure bit of inquiry data
      fix pcmcia compile problem
      scsi_transport_spi: convert to attribute groups
      sysfs: add filter function to groups
      add missing transport configure points for target and host
      attribute_container: update to use the group interface
      sysfs: fix the sysfs_add_file_to_group interfaces
      libata: fix corruption induced by relaxed DMA alignment in SCSI
      relax scsi dma alignment
      block: Introduce new blk_queue_update_dma_alignment interface
      sr: update to follow tray status correctly
      libsas: don't use made up error codes
      libsas, bsg: pass errors through correctly
      libsas: don't treat underrun as an error on SMP tasks
      libsas: add host SMP processing
      sd,sr: add early detection of medium not present
      DocBook scsi_midlayer.tmpl->scsi.tmpl

James Smart (18):
      lpfc 8.2.4 : Update lpfc driver version to 8.2.4
      lpfc 8.2.4 : Rework misplaced reference taking on node structure
      lpfc 8.2.4 : Enhance debugfs use
      lpfc 8.2.4 : Fix Unsolicited Data items
      lpfc 8.2.4 : Add additional sysfs and module parameters
      lpfc 8.2.4 : Miscellaneous Fixes
      lpfc 8.2.4 : Add parameters to enable and disable heartbeat and hba resets
      lpfc 8.2.4 : Correct abort handler logic
      lpfc 8.2.4 : Miscellaneous Discovery/ELS Fixes
      lpfc 8.2.3 : Change version number to 8.2.3
      lpfc 8.2.3 : Temperature handling fix
      lpfc 8.2.3 : Internal loopback fixes
      lpfc 8.2.3 : Miscellaneous Small Fixes - part 2
      lpfc 8.2.3 : FC Discovery Fixes
      lpfc 8.2.3 : Miscellaneous Small Fixes - part 1
      lpfc 8.2.3 : Remove flawed MBX_STOP_IOCB logic
      lpfc 8.2.3 : NPIV bug fixes
      lpfc 8.2.3 : Added support for ASICs that report temperature

Jeff Garzik (7):
      gdth: kill unneeded 'irq' argument
      sym53c416: kill pointless irq handler loop and test
      NCR5380: minor irq handler cleanups
      ips: handle scsi_add_host() failure, and other err cleanups
      ips: PCI API cleanups
      ips: trim trailing whitespace
      ips: remove ips_ha members that duplicate struct pci_dev members

Kai Makisara (1):
      st: convert to unlocked_ioctl

Kay Sievers (1):
      sr,sd: send media state change modification events

Krzysztof Helt (1):
      sym53c8xx: fixes two bugs related to chip reset

Marcus Barrow (1):
      qla2xxx: Use completion routines.

Mathieu Segaud (1):
      ch: Convert to use unlocked_ioctl

Matthias Kaehlcke (1):
      megaraid_sas: Convert aen_mutex to the mutex API

Mike Christie (16):
      iscsi class: bump version
      iscsi_tcp: fix setting of r2t
      iscsi_tcp: hold lock during data rsp processing
      iscsi_tcp: enable sg chaining
      libiscsi, iscsi class: set tmf to a safe default and export in sysfs
      iscsi_tcp: drop session when itt does not match any command
      libiscsi: Drop host lock in queuecommand
      libiscsi: clear conn->ctask when task is completed early
      libiscsi: Do not fail commands immediately during logout
      libiscsi: fix nop handling
      libiscsi: fix shutdown
      libiscsi: grab eh_mutex during host reset
      iscsi class: Use our own workq instead of common system one.
      libiscsi: do not block session during logout
      libiscsi, iscsi_tcp: add device support
      add DID_REQUEUE string to scsi_show_result host table

Olaf Kirch (4):
      iscsi_tcp: stop leaking r2t_info's when the incoming R2T is bad
      iscsi: convert xmit path to iscsi chunks
      libiscsi, iscsi_tcp: iscsi pool cleanup
      iscsi_tcp: rewrite recv path

Prakash, Sathya (1):
      mpt fusion: Fix for module unload problem in flash less controller environ

Randy Dunlap (8):
      NCR5380: fix section mismatch
      megaraid: fix section mismatch
      aic94xx: fix section mismatches
      sym2: fix section mismatch warning
      tgt: fix build when dprintk is defined
      docbook and kernel-doc updates
      kernel-doc: use correct function name
      boot options: correct option name and tell where to find docs for it

Rob Landley (1):
      Add Documentation and integrate into docbook build

Robert Jennings (1):
      ibmvscsi: requeue while CRQ closed

Roel Kluin (1):
      atari_NCR5380, sun3_NCR5380: operator precedence fix

Rusty Russell (1):
      BUG_ON() impossible condition in sg list counting

Salyzyn, Mark (18):
      aacraid: fib context lock for management ioctls
      aacraid: add Voodoo Lite class of cards.
      aacraid: add new driver features flags
      aacraid: remove pigs in space
      dpt_i2o: use constant instead of bare value
      aacraid: replace '<?:' with min_t()
      aacraid: SMC vendor identification
      aacraid: respond to enclosure service events
      aacraid: add call to flush_kernel_dcache_page
      aacraid: improve queue balancing
      aacraid: OS panic after Adapter panic (hardening).
      aacraid: fix multiple definition of automatic variable warning.
      aacraid: fix big endian issues
      aacraid: variable redefinition hides earlier warning
      aacraid: add sysfs report of RAID level
      aacraid: add parameter to control FUA and SYNCHRONIZE_CACHE policy
      aacraid: fix driver failure with Dell PowerEdge Expandable RAID Controller
      aacraid: forced reset override

Seokmann Ju (2):
      qla2xxx: Issue correct MBC_INITIALIZE_FIRMWARE command.
      qla2xxx: Add a filter to compare port_name against the physical on vport c

Shyam Sundar (1):
      qla2xxx: Properly handle Vport state-change-notifications.

Swen Schillig (1):
      zfcp: update MAINTAINERS

Tejun Heo (1):
      make pcmcia directory use obj-y|m instead of subdir-y|m

Tomohiro Kusumi (1):
      lpfc 8.2.4 : Make lpfc legacy I/O port free

Tony Battersby (3):
      sg: fix /proc/scsi/sg/devices when no SCSI devices
      move single_lun flag from scsi_device to scsi_target
      3w-9xxx: fix abysmal write performance on some motherboards

Vegard Nossum (1):
      aic7xxx: fix firmware build

bo yang (6):
      megaraid_sas: Update version and changelog
      megaraid_sas: support for poll_mode_io (reduced interrupt)
      megaraid_sas: call cmd completion from reset
      megaraid_sas: use unsigned long for sense_buff ptr
      megaraid_sas: check max_sgl reported by FW for setting max_sectors_per_req
      megaraid_sas: add hibernation support

vignesh babu (1):
      libiscsi: use is_power_of_2


And the diffstat:

 Documentation/DocBook/Makefile               |    2 
 Documentation/DocBook/scsi.tmpl              |  409 +++++
 Documentation/dontdiff                       |    2 
 Documentation/kernel-parameters.txt          |    8 
 Documentation/m68k/kernel-options.txt        |   60 
 Documentation/scsi/00-INDEX                  |    2 
 Documentation/scsi/ChangeLog.megaraid_sas    |  159 ++
 Documentation/scsi/aacraid.txt               |    4 
 Documentation/scsi/hptiop.txt                |   30 
 Documentation/scsi/ncr53c7xx.txt             |   40 
 MAINTAINERS                                  |    6 
 block/bsg.c                                  |   14 
 block/ll_rw_blk.c                            |   24 
 drivers/ata/libata-scsi.c                    |   11 
 drivers/base/attribute_container.c           |   14 
 drivers/firewire/fw-sbp2.c                   |    6 
 drivers/ieee1394/sbp2.c                      |    6 
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   15 
 drivers/infiniband/ulp/iser/iser_initiator.c |    4 
 drivers/message/fusion/mptbase.c             |   94 -
 drivers/message/fusion/mptbase.h             |    2 
 drivers/message/fusion/mptsas.c              |    2 
 drivers/message/fusion/mptscsih.c            |    2 
 drivers/message/i2o/i2o_scsi.c               |    2 
 drivers/s390/scsi/zfcp_aux.c                 |    2 
 drivers/s390/scsi/zfcp_ccw.c                 |    3 
 drivers/s390/scsi/zfcp_dbf.c                 |    6 
 drivers/s390/scsi/zfcp_def.h                 |   22 
 drivers/s390/scsi/zfcp_erp.c                 |   14 
 drivers/s390/scsi/zfcp_fsf.c                 |   70 
 drivers/s390/scsi/zfcp_scsi.c                |   24 
 drivers/scsi/.gitignore                      |    2 
 drivers/scsi/3w-9xxx.c                       |    1 
 drivers/scsi/53c700.c                        |   11 
 drivers/scsi/BusLogic.c                      |    2 
 drivers/scsi/Kconfig                         |   32 
 drivers/scsi/Makefile                        |    5 
 drivers/scsi/NCR5380.c                       |   23 
 drivers/scsi/a2091.c                         |   36 
 drivers/scsi/a3000.c                         |   15 
 drivers/scsi/aacraid/aachba.c                |  400 ++---
 drivers/scsi/aacraid/aacraid.h               |  335 ++--
 drivers/scsi/aacraid/commctrl.c              |  112 -
 drivers/scsi/aacraid/comminit.c              |    4 
 drivers/scsi/aacraid/commsup.c               |  394 +++--
 drivers/scsi/aacraid/dpcsup.c                |   10 
 drivers/scsi/aacraid/linit.c                 |  242 ++-
 drivers/scsi/aacraid/rx.c                    |    6 
 drivers/scsi/advansys.c                      |   14 
 drivers/scsi/aha152x.c                       |   38 
 drivers/scsi/aha1542.c                       |   49 
 drivers/scsi/aha1740.c                       |    2 
 drivers/scsi/aic7xxx/Makefile                |   45 
 drivers/scsi/aic7xxx/aic79xx_osm.c           |    6 
 drivers/scsi/aic7xxx/aic7xxx_osm.c           |    6 
 drivers/scsi/aic7xxx_old.c                   |   11 
 drivers/scsi/aic94xx/aic94xx_dev.c           |    6 
 drivers/scsi/aic94xx/aic94xx_dump.c          |    4 
 drivers/scsi/aic94xx/aic94xx_hwi.c           |    2 
 drivers/scsi/aic94xx/aic94xx_hwi.h           |    3 
 drivers/scsi/aic94xx/aic94xx_init.c          |  190 ++
 drivers/scsi/aic94xx/aic94xx_scb.c           |    6 
 drivers/scsi/aic94xx/aic94xx_sds.c           |  389 +++++
 drivers/scsi/aic94xx/aic94xx_sds.h           |  121 +
 drivers/scsi/aic94xx/aic94xx_task.c          |   50 
 drivers/scsi/aic94xx/aic94xx_tmf.c           |   12 
 drivers/scsi/arcmsr/arcmsr_hba.c             |    6 
 drivers/scsi/atari_NCR5380.c                 |   24 
 drivers/scsi/atp870u.c                       |  102 -
 drivers/scsi/ch.c                            |  215 +-
 drivers/scsi/constants.c                     |    3 
 drivers/scsi/dc395x.c                        |   16 
 drivers/scsi/dpt_i2o.c                       |    5 
 drivers/scsi/eata.c                          |    4 
 drivers/scsi/eata_pio.c                      |   13 
 drivers/scsi/fd_mcs.c                        |   36 
 drivers/scsi/gdth.c                          |   22 
 drivers/scsi/hosts.c                         |    4 
 drivers/scsi/hptiop.c                        |  593 ++++++-
 drivers/scsi/hptiop.h                        |  124 +
 drivers/scsi/ibmvscsi/ibmvscsi.c             |  155 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c             |    2 
 drivers/scsi/imm.c                           |   13 
 drivers/scsi/in2000.c                        |   10 
 drivers/scsi/ipr.c                           |    2 
 drivers/scsi/ips.c                           |  326 ++--
 drivers/scsi/ips.h                           |   32 
 drivers/scsi/iscsi_tcp.c                     | 2075 +++++++++++----------------
 drivers/scsi/iscsi_tcp.h                     |  134 -
 drivers/scsi/libiscsi.c                      | 1091 +++++++++-----
 drivers/scsi/libsas/Kconfig                  |    9 
 drivers/scsi/libsas/Makefile                 |    4 
 drivers/scsi/libsas/sas_ata.c                |    2 
 drivers/scsi/libsas/sas_discover.c           |    2 
 drivers/scsi/libsas/sas_expander.c           |   35 
 drivers/scsi/libsas/sas_host_smp.c           |  274 +++
 drivers/scsi/libsas/sas_internal.h           |   16 
 drivers/scsi/libsas/sas_scsi_host.c          |    9 
 drivers/scsi/libsas/sas_task.c               |   36 
 drivers/scsi/libsrp.c                        |   23 
 drivers/scsi/lpfc/lpfc.h                     |   53 
 drivers/scsi/lpfc/lpfc_attr.c                |  217 ++
 drivers/scsi/lpfc/lpfc_crtn.h                |   33 
 drivers/scsi/lpfc/lpfc_ct.c                  |  304 ++-
 drivers/scsi/lpfc/lpfc_debugfs.c             |  157 +-
 drivers/scsi/lpfc/lpfc_disc.h                |    2 
 drivers/scsi/lpfc/lpfc_els.c                 |  623 +++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c             |  372 +++-
 drivers/scsi/lpfc/lpfc_hw.h                  |  112 +
 drivers/scsi/lpfc/lpfc_init.c                |  429 ++++-
 drivers/scsi/lpfc/lpfc_logmsg.h              |    1 
 drivers/scsi/lpfc/lpfc_mbox.c                |   32 
 drivers/scsi/lpfc/lpfc_mem.c                 |    1 
 drivers/scsi/lpfc/lpfc_nportdisc.c           |  160 +-
 drivers/scsi/lpfc/lpfc_scsi.c                |   54 
 drivers/scsi/lpfc/lpfc_scsi.h                |    1 
 drivers/scsi/lpfc/lpfc_sli.c                 |  534 ++++--
 drivers/scsi/lpfc/lpfc_sli.h                 |   12 
 drivers/scsi/lpfc/lpfc_version.h             |    6 
 drivers/scsi/lpfc/lpfc_vport.c               |   93 -
 drivers/scsi/lpfc/lpfc_vport.h               |    2 
 drivers/scsi/megaraid.c                      |    2 
 drivers/scsi/megaraid/megaraid_mbox.c        |    6 
 drivers/scsi/megaraid/megaraid_sas.c         |  572 +++++--
 drivers/scsi/megaraid/megaraid_sas.h         |   18 
 drivers/scsi/ncr53c8xx.c                     |    3 
 drivers/scsi/pcmcia/Kconfig                  |    3 
 drivers/scsi/pcmcia/nsp_cs.c                 |   54 
 drivers/scsi/ppa.c                           |   12 
 drivers/scsi/psi240i.c                       |  689 --------
 drivers/scsi/psi240i.h                       |  315 ----
 drivers/scsi/psi_chip.h                      |  195 --
 drivers/scsi/qla1280.c                       |    4 
 drivers/scsi/qla2xxx/Makefile                |    2 
 drivers/scsi/qla2xxx/qla_attr.c              |   54 
 drivers/scsi/qla2xxx/qla_dbg.c               |   37 
 drivers/scsi/qla2xxx/qla_dbg.h               |   19 
 drivers/scsi/qla2xxx/qla_def.h               |   52 
 drivers/scsi/qla2xxx/qla_dfs.c               |  175 ++
 drivers/scsi/qla2xxx/qla_fw.h                |   30 
 drivers/scsi/qla2xxx/qla_gbl.h               |   51 
 drivers/scsi/qla2xxx/qla_init.c              |   97 -
 drivers/scsi/qla2xxx/qla_isr.c               |  120 -
 drivers/scsi/qla2xxx/qla_mbx.c               |  430 +----
 drivers/scsi/qla2xxx/qla_mid.c               |   46 
 drivers/scsi/qla2xxx/qla_os.c                |   80 -
 drivers/scsi/qla2xxx/qla_sup.c               |   18 
 drivers/scsi/qla2xxx/qla_version.h           |    2 
 drivers/scsi/qla4xxx/ql4_init.c              |    4 
 drivers/scsi/qla4xxx/ql4_isr.c               |   11 
 drivers/scsi/qla4xxx/ql4_os.c                |    7 
 drivers/scsi/qlogicpti.c                     |   31 
 drivers/scsi/scsi.c                          |  282 ++-
 drivers/scsi/scsi_debug.c                    |   37 
 drivers/scsi/scsi_devinfo.c                  |   34 
 drivers/scsi/scsi_error.c                    |  131 -
 drivers/scsi/scsi_ioctl.c                    |   26 
 drivers/scsi/scsi_lib.c                      |  117 -
 drivers/scsi/scsi_netlink.c                  |   19 
 drivers/scsi/scsi_proc.c                     |  110 +
 drivers/scsi/scsi_scan.c                     |   36 
 drivers/scsi/scsi_sysfs.c                    |    1 
 drivers/scsi/scsi_tgt_if.c                   |    2 
 drivers/scsi/scsi_tgt_lib.c                  |   30 
 drivers/scsi/scsi_transport_fc.c             |  102 -
 drivers/scsi/scsi_transport_iscsi.c          |  330 ++--
 drivers/scsi/scsi_transport_sas.c            |   41 
 drivers/scsi/scsi_transport_spi.c            |  258 ++-
 drivers/scsi/scsi_transport_srp.c            |   13 
 drivers/scsi/scsicam.c                       |   35 
 drivers/scsi/sd.c                            |   44 
 drivers/scsi/seagate.c                       | 1667 ---------------------
 drivers/scsi/sg.c                            |   24 
 drivers/scsi/sgiwd93.c                       |    1 
 drivers/scsi/sr.c                            |   35 
 drivers/scsi/sr.h                            |    4 
 drivers/scsi/sr_ioctl.c                      |   48 
 drivers/scsi/st.c                            |    9 
 drivers/scsi/sun3_NCR5380.c                  |   24 
 drivers/scsi/sym53c416.c                     |   16 
 drivers/scsi/sym53c8xx_2/sym_glue.c          |   22 
 drivers/scsi/tmscsim.c                       |    6 
 drivers/scsi/u14-34f.c                       |    4 
 drivers/scsi/ultrastor.c                     |   15 
 drivers/scsi/wd33c93.c                       |   10 
 drivers/scsi/wd7000.c                        |   12 
 drivers/usb/storage/freecom.c                |   14 
 drivers/usb/storage/isd200.c                 |   66 
 drivers/usb/storage/protocol.c               |  126 -
 drivers/usb/storage/scsiglue.c               |   24 
 drivers/usb/storage/sddr09.c                 |    9 
 drivers/usb/storage/shuttle_usbat.c          |   68 
 drivers/usb/storage/transport.c              |   45 
 drivers/usb/storage/transport.h              |    2 
 fs/sysfs/file.c                              |   11 
 fs/sysfs/group.c                             |   26 
 include/linux/attribute_container.h          |    1 
 include/linux/blkdev.h                       |    1 
 include/linux/sysfs.h                        |    2 
 include/scsi/iscsi_if.h                      |   20 
 include/scsi/iscsi_proto.h                   |   14 
 include/scsi/libiscsi.h                      |   82 -
 include/scsi/libsas.h                        |   28 
 include/scsi/sas.h                           |   13 
 include/scsi/scsi_cmnd.h                     |    2 
 include/scsi/scsi_device.h                   |   13 
 include/scsi/scsi_transport_iscsi.h          |   10 
 include/scsi/scsi_transport_sas.h            |   16 
 include/scsi/sd.h                            |    1 
 kernel/params.c                              |    2 
 210 files changed, 10519 insertions(+), 9019 deletions(-)

James


