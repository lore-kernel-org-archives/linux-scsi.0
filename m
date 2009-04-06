From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] final set of SCSI updates for the merge window
Date: Mon, 06 Apr 2009 15:54:26 +0000
Message-ID: <1239033266.3641.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33848 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbZDFPyu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 11:54:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is just an assorted set of driver updates (fcoe, qla2x, stex etc.)

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (3):
      a2091: make 2 functions static
      a3000: make 2 functions static
      ses: #if 0 the unused ses_match_host()

Alan Cox (2):
      mptsas: remove unneeded check
      config: Make need for SCSI_CDROM clearer

Andrew Vasquez (12):
      qla2xxx: Update version number to 8.03.01-k1.
      qla2xxx: Don't cache VPD data for newer ISPs.
      qla2xxx: Explicitly set the execution-throttle with recent ISPs.
      qla2xxx: Reduce request queue-size overhead with recent ISPs.
      qla2xxx: Always use an FLT's NVRAM/VPD region information.
      qla2xxx: Ensure the timer and DPC routines complete prior to midlayer tear-down.
      qla2xxx: Correct abort-semantics in qla2x00_abort_all_cmds().
      qla2xxx: Update MPI/PHY version retrieval codes.
      qla2xxx: Preserve an fcport's loop-id after terminate_rport_io().
      qla2xxx: Pass in optional extended-initialization control block.
      qla2xxx: Always (re)read firmware version/capabilities information.
      qla2xxx: Refactor request/response-queue register handling.

Boaz Harrosh (2):
      osd_uld: Remove creation of osd_scsi class symlink
      libosd: fix blk_put_request called from within request_end_io

Brian King (5):
      ibmvfc: Driver version 1.0.5
      ibmvfc: Improve ADISC timeout handling
      ibmvfc: Show host maxframe_size
      ibmvfc: Fixup module parms attributes
      ibmvfc: Fix dropped interrupts

Ed Lin (5):
      stex: update version to 4.6.0000.3
      stex: add new 6G controller support
      stex: use config struct for parameters of different controllers
      stex: add MSI support
      stex: small code fixes and changes

FUJITA Tomonori (3):
      sg: return EFAULT for an invalid user address
      sg: fix q->queue_lock on scsi_error_handler path
      sg: fix iovec bugs introduced by the block layer conversion

Giridhar Malavali (4):
      qla2xxx: Drop use of IRQF_DISABLE.
      qla2xxx: Correct over-allocation of firmware-dump buffer.
      qla2xxx: Initialize FCE debugfs codes with the proper vha structure.
      qla2xxx: Consolidate queuecommand implementations.

Hannes Reinecke (1):
      aic7xxx: leaves timer running on init failure

Harish Zunjarrao (2):
      qla2xxx: Get FLT address in dword format.
      qla2xxx: Use byte-address while reading FC boot code versions from flash.

Harvey Harrison (1):
      replace __inline with inline

James Bottomley (1):
      fix recovered error handling

Jaswinder Singh Rajput (3):
      qlogicpti: use request_firmware
      advansys: use request_firmware
      qla1280: use request_firmware

Jean Delvare (1):
      libiscsi: fix iscsi pool error path

Joe Carnuccio (2):
      qla2xxx: Add EDC-update support.
      qla2xxx: Add Flash-Access-Control support for recent ISPs.

Joe Eykholt (2):
      fcoe, libfcoe: Add support for FIP. FCoE discovery and keep-alive.
      fcoe: Add a header file defining the FIP protocol for FCoE.

Karen Xie (4):
      cxgb3i: merge cxgb3i_ddp into cxgb3i module
      cxgb3i: close all tcp connections upon chip reset
      cxgb3i: re-initialize ddp settings after chip reset
      cxgb3i: subscribe to error notification from cxgb3 driver

Lalit Chandivade (4):
      qla2xxx: Export flash-block-size for application support.
      qla2xxx: Remove implicit ISP-abort after a flash update.
      qla2xxx: Add reset capabilities for application support.
      qla2xxx: Correct ISP abort semantics for NVRAM, VPD, and flash update.

Leubner, Achim (1):
      aacraid driver update

Mike Christie (2):
      cxgb3i: call ddp release function directly
      cxgb3i: re-read ddp settings information after chip reset

Robert Love (4):
      fcoe: create/destroy fcoe Rx threads on CPU hotplug events
      fcoe: Use per-CPU kernel function for dev_stats instead of an array
      fcoe: Use percpu kernel funcs for struct fcoe_percpu_s
      fcoe: Initialize all possilbe skb_queue(s) when module is loaded

Seokmann Ju (1):
      qla2xxx: Correct several PCI-EEH issues.

Shyam Sundar (1):
      qla2xxx: Cleanup unused flags and #defines.

Vasu Dev (8):
      fcoe, libfc: fix double fcoe_softc memory alloc
      fcoe: cleans up libfcoe.h and adds fcoe.h for fcoe module
      fcoe: moves common FCoE library API functions to libfcoe module
      fcoe, libfc: add libfcoe module
      fcoe: renames libfcoe.c to fcoe.c as the only fcoe module file
      fcoe: removes default sw transport code file fcoe_sw.c
      fcoe: removes fc_transport_fcoe.[ch] code files
      fcoe: prep work to completely remove fc_transport_fcoe code

Wei Yongjun (1):
      use kmem_cache_zalloc instead of kmem_cache_alloc/memset


and the diffstat:

 Documentation/scsi/aacraid.txt        |   15 
 drivers/message/fusion/mptsas.c       |    5 
 drivers/scsi/Kconfig                  |   17 
 drivers/scsi/Makefile                 |    1 
 drivers/scsi/a2091.c                  |    6 
 drivers/scsi/a2091.h                  |    3 
 drivers/scsi/a3000.c                  |    6 
 drivers/scsi/a3000.h                  |    3 
 drivers/scsi/aacraid/aachba.c         |   40 
 drivers/scsi/aacraid/aacraid.h        |    9 
 drivers/scsi/aacraid/comminit.c       |   14 
 drivers/scsi/aacraid/linit.c          |    8 
 drivers/scsi/advansys.c               | 1731 +-------------------------
 drivers/scsi/aic7xxx/aic79xx_core.c   |   12 
 drivers/scsi/aic7xxx/aic79xx_inline.h |   32 
 drivers/scsi/aic7xxx/aic79xx_osm.h    |  102 -
 drivers/scsi/aic7xxx/aic79xx_pci.c    |    8 
 drivers/scsi/aic7xxx/aic7xxx_inline.h |    5 
 drivers/scsi/aic7xxx/aic7xxx_osm.h    |  104 -
 drivers/scsi/aic7xxx/aic7xxx_pci.c    |   10 
 drivers/scsi/aic7xxx/aiclib.h         |    4 
 drivers/scsi/cxgb3i/Kbuild            |    4 
 drivers/scsi/cxgb3i/cxgb3i.h          |   10 
 drivers/scsi/cxgb3i/cxgb3i_ddp.c      |  275 +---
 drivers/scsi/cxgb3i/cxgb3i_ddp.h      |    6 
 drivers/scsi/cxgb3i/cxgb3i_init.c     |   31 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c    |  129 +
 drivers/scsi/cxgb3i/cxgb3i_offload.c  |  101 -
 drivers/scsi/cxgb3i/cxgb3i_offload.h  |   13 
 drivers/scsi/fcoe/Makefile            |    8 
 drivers/scsi/fcoe/fc_transport_fcoe.c |  443 ------
 drivers/scsi/fcoe/fcoe.c              | 1878 ++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe.h              |   75 +
 drivers/scsi/fcoe/fcoe_sw.c           |  561 --------
 drivers/scsi/fcoe/libfcoe.c           | 2216 +++++++++++++++-------------------
 drivers/scsi/ibmvscsi/ibmvfc.c        |  126 +
 drivers/scsi/ibmvscsi/ibmvfc.h        |   16 
 drivers/scsi/libfc/fc_fcp.c           |   10 
 drivers/scsi/libfc/fc_lport.c         |   11 
 drivers/scsi/libiscsi.c               |    4 
 drivers/scsi/osd/osd_initiator.c      |   42 
 drivers/scsi/osd/osd_uld.c            |    6 
 drivers/scsi/ql1040_fw.h              | 2130 --------------------------------
 drivers/scsi/ql12160_fw.h             | 1811 ---------------------------
 drivers/scsi/ql1280_fw.h              | 2048 -------------------------------
 drivers/scsi/qla1280.c                |  114 +
 drivers/scsi/qla1280.h                |    6 
 drivers/scsi/qla2xxx/qla_attr.c       |  295 ++++
 drivers/scsi/qla2xxx/qla_def.h        |  136 --
 drivers/scsi/qla2xxx/qla_dfs.c        |    4 
 drivers/scsi/qla2xxx/qla_fw.h         |   42 
 drivers/scsi/qla2xxx/qla_gbl.h        |   25 
 drivers/scsi/qla2xxx/qla_init.c       |  136 --
 drivers/scsi/qla2xxx/qla_iocb.c       |   37 
 drivers/scsi/qla2xxx/qla_isr.c        |   32 
 drivers/scsi/qla2xxx/qla_mbx.c        |  238 +++
 drivers/scsi/qla2xxx/qla_mid.c        |   12 
 drivers/scsi/qla2xxx/qla_os.c         |  258 +--
 drivers/scsi/qla2xxx/qla_sup.c        |  103 +
 drivers/scsi/qla2xxx/qla_version.h    |    4 
 drivers/scsi/qlogicpti.c              |   63 
 drivers/scsi/qlogicpti_asm.c          | 1160 -----------------
 drivers/scsi/scsi.c                   |    4 
 drivers/scsi/scsi_lib.c               |   17 
 drivers/scsi/sd.c                     |    6 
 drivers/scsi/ses.c                    |    2 
 drivers/scsi/sg.c                     |   37 
 drivers/scsi/sr.c                     |    9 
 drivers/scsi/stex.c                   |  742 ++++++++---
 drivers/scsi/sym53c8xx_2/sym_glue.h   |    6 
 drivers/scsi/sym53c8xx_2/sym_hipd.c   |    2 
 drivers/scsi/sym53c8xx_2/sym_hipd.h   |    6 
 drivers/scsi/sym53c8xx_2/sym_malloc.c |    2 
 drivers/scsi/sym53c8xx_2/sym_misc.h   |   18 
 firmware/Makefile                     |    5 
 firmware/WHENCE                       |   36 
 firmware/advansys/3550.bin.ihex       |  317 ++++
 firmware/advansys/38C0800.bin.ihex    |  336 +++++
 firmware/advansys/38C1600.bin.ihex    |  398 ++++++
 firmware/advansys/mcode.bin.ihex      |  147 ++
 firmware/qlogic/1040.bin.ihex         | 2111 ++++++++++++++++++++++++++++++++
 firmware/qlogic/12160.bin.ihex        | 1771 +++++++++++++++++++++++++++
 firmware/qlogic/1280.bin.ihex         | 2008 ++++++++++++++++++++++++++++++
 firmware/qlogic/isp1000.bin.ihex      | 1158 +++++++++++++++++
 include/scsi/fc/fc_fip.h              |  237 +++
 include/scsi/fc_transport_fcoe.h      |   54 
 include/scsi/libfc.h                  |   45 
 include/scsi/libfcoe.h                |  227 +--
 88 files changed, 14088 insertions(+), 12367 deletions(-)

James


