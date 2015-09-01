From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.2+ merge window
Date: Tue, 01 Sep 2015 11:36:11 -0600
Message-ID: <1441128971.2296.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38172 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103AbbIARgR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2015 13:36:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This includes one new driver: cxlflash plus the usual grab bag of
updates for the major drivers: qla2xxx, ipr, storvsc, pm80xx, hptiop,
plus a few assorted fixes.  There's another tranch coming, but I want to
incubate it another few days in the checkers, plus it includes a mpt2sas
separated lifetime fix, which Avago won't get done testing until
Friday. 

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The Short Changelog is:


Alexey Khoroshilov (1):
      bfa: fix leak of bfad_im_port_index on module unload

Arun Easi (1):
      qla2xxx: Fix missing device login retries.

Bart Van Assche (11):
      qla2xxx: Avoid that sparse complains about context imbalances
      qla2xxx: Remove dead code
      qla2xxx: Remove a superfluous test
      qla2xxx: Fix sparse annotations
      qla2xxx: Avoid that sparse complains about duplicate [noderef] attributes
      qla2xxx: Remove __constant_ prefix
      qla2xxx: Replace two macros with an inline function
      qla2xxx: Remove set-but-not-used variables
      qla2xxx: Declare local functions static
      qla2xxx: Report both rsp_info and rsp_info_len
      libfc: Fix a typo in a source code comment

Bjorn Helgaas (3):
      megaraid_sas: fix whitespace errors
      megaraid_sas: use dev_printk when possible
      megaraid : use dev_printk when possible

Brian King (2):
      ipr: Driver version 2.6.2
      ipr: Endian / sparse fixes

Chad Dupuis (3):
      qla2xxx: Remove decrement of sp reference count in abort handler.
      qla2xxx: Do not reset ISP for error entry with an out of range handle.
      qla2xxx: Do not reset adapter if SRB handle is in range.

Chris Leech (1):
      iSCSI: let session recovery_tmo sysfs writes persist across recovery

Dan Carpenter (5):
      aic94xx: set an error code on failure
      cxlflash: shift wrapping bug in afu_link_reset()
      cxlflash: off by one bug in cxlflash_show_port_status()
      mptfusion: prevent some memory corruption
      hpsa: fix an sprintf() overflow in the reset handler

Dilip Kumar Uppugandla (1):
      qla2xxx: Return the fabric command state for non-task management requests

Don Brace (7):
      hpsa: fix rmmod issues
      hpsa: add in new controllers
      hpsa: cleanup update scsi devices
      hpsa: add PMC to copyright
      hpsa: correct static checker warnings on driver init cleanup
      hpsa: correct decode sense data
      hpsa: Correct double unlock of mutex

Hannes Reinecke (2):
      scsi: Add ALUA state change UA handling
      scsi: retry MODE SENSE on unit attention

Himanshu Madhani (2):
      qla2xxx: Update driver version to 8.07.00.26-k
      qla2xxx: do not clear slot in outstanding cmd array

Hiral Patel (1):
      qla2xxx: Do not crash system for sp ref count zero

Jack Wang (1):
      MAINTAINERS: update email for pm8001

Joe Carnuccio (4):
      qla2xxx: Pause risc before manipulating risc semaphore.
      qla2xxx: Use ssdid to gate semaphore manipulation.
      qla2xxx: Handle AEN8014 incoming port logout.
      qla2xxx: Add serdes register read/write support for ISP25xx.

Joe Handzik (1):
      hpsa: add sysfs entry path_info to show box and bay information

Johannes Thumshirn (2):
      st: Destroy st_index_idr on module exit
      mvsas: always iounmap resources

K. Y. Srinivasan (1):
      storvsc: Set the error code correctly in failure conditions

Keith Mange (6):
      storvsc: Allow write_same when host is windows 10
      storvsc: use storage protocol version to determine storage capabilities
      storvsc: use correct defaults for values determined by protocol negotiation
      storvsc: Untangle the storage protocol negotiation from the vmbus protocol negotiation.
      storvsc: Use a single value to track protocol versions
      storvsc: Rather than look for sets of specific protocol versions, make decisions based on ranges.

Kevin Barnett (1):
      Change how controllers in mixed mode are handled.

Matthew R. Ochs (5):
      cxlflash: Remove unused variable from queuecommand
      cxlflash: Virtual LUN support
      cxlflash: Superpipe support
      cxlflash: Base error recovery support
      cxlflash: Base support for IBM CXL Flash Adapter

Saurav Kashyap (1):
      qla2xxx: Add adapter checks for FAWWN functionality.

Sawan Chandak (2):
      qla2xxx: Add pci device id 0x2261.
      qla2xxx: Add support to show MPI and PEP FW version for ISP27xx.

Scott Benesh (1):
      hpsa: add in new offline mode

Sebastian Herbszt (1):
      lpfc: Use && instead of & for boolean expression

Seymour, Shane M (2):
      st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
      st: convert to using driver attr groups for sysfs

Sreekanth Reddy (1):
      mpt2sas, mpt3sas: Abort initialization if no memory I/O resources detected

Suresh Thiagarajan (1):
      pm80xx: Added pm8006 controller support

Thadeu Lima de Souza Cascardo (1):
      qla2xxx: prevent board_disable from running during EEH

Viswas G (8):
      pm80xx: Bump pm80xx driver version to 0.1.38
      pm80xx: Handling Invalid SSP Response frame
      pm80xx: Add PORT RECOVERY TIMEOUT support
      pm80xx: Remove unnecessary phy disconnect while link error
      pm80xx: Fix for Incorrect DMA Unmapping of SG List
      pm80xx: Update For Thermal Page Code
      pm80xx: Corrected device state changes in I_T_Nexus_Reset.
      pm80xx: Updated link rate

Vitaly Kuznetsov (2):
      storvsc: use shost_for_each_device() instead of open coding
      storvsc: be more picky about scmnd->sc_data_direction

Wen Xiong (1):
      ipr: Byte swapping for device_id attribute in sysfs

jiang.biao2@zte.com.cn (1):
      scsi_error: should not get sense for timeout IO in scsi error handler

linux (1):
      hptiop: Support HighPoint RR36xx HBAs and Support SAS tape and SAS media changer

shane.seymour (1):
      hpsa: fix issues with multilun devices

And the diffstat:

 Documentation/ioctl/ioctl-number.txt        |    1 +
 Documentation/powerpc/cxlflash.txt          |  318 ++++
 MAINTAINERS                                 |    2 +-
 drivers/message/fusion/mptctl.c             |    9 +
 drivers/scsi/Kconfig                        |    1 +
 drivers/scsi/Makefile                       |    1 +
 drivers/scsi/aic94xx/aic94xx_init.c         |    1 +
 drivers/scsi/bfa/bfad_im.c                  |    2 +
 drivers/scsi/cxlflash/Kconfig               |   11 +
 drivers/scsi/cxlflash/Makefile              |    2 +
 drivers/scsi/cxlflash/common.h              |  208 +++
 drivers/scsi/cxlflash/lunmgt.c              |  266 +++
 drivers/scsi/cxlflash/main.c                | 2494 +++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.h                |  108 ++
 drivers/scsi/cxlflash/sislite.h             |  472 +++++
 drivers/scsi/cxlflash/superpipe.c           | 2084 ++++++++++++++++++++++
 drivers/scsi/cxlflash/superpipe.h           |  147 ++
 drivers/scsi/cxlflash/vlun.c                | 1243 +++++++++++++
 drivers/scsi/cxlflash/vlun.h                |   86 +
 drivers/scsi/hpsa.c                         |  301 ++--
 drivers/scsi/hpsa.h                         |   16 +-
 drivers/scsi/hpsa_cmd.h                     |   10 +-
 drivers/scsi/hptiop.c                       |   97 +-
 drivers/scsi/hptiop.h                       |    6 +-
 drivers/scsi/ipr.c                          |   15 +-
 drivers/scsi/ipr.h                          |   17 +-
 drivers/scsi/libfc/fc_fcp.c                 |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |    2 +-
 drivers/scsi/megaraid.c                     |  140 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  544 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   95 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         |   16 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |   16 +-
 drivers/scsi/mvsas/mv_init.c                |    5 +-
 drivers/scsi/pm8001/pm8001_defs.h           |    4 +-
 drivers/scsi/pm8001/pm8001_hwi.c            |    4 +
 drivers/scsi/pm8001/pm8001_init.c           |    5 +-
 drivers/scsi/pm8001/pm8001_sas.c            |   19 +-
 drivers/scsi/pm8001/pm8001_sas.h            |   12 +-
 drivers/scsi/pm8001/pm80xx_hwi.c            |  111 +-
 drivers/scsi/pm8001/pm80xx_hwi.h            |    5 +-
 drivers/scsi/qla2xxx/qla_attr.c             |   24 +-
 drivers/scsi/qla2xxx/qla_bsg.c              |    7 +-
 drivers/scsi/qla2xxx/qla_dbg.c              |  102 +-
 drivers/scsi/qla2xxx/qla_def.h              |   15 +-
 drivers/scsi/qla2xxx/qla_gs.c               |   52 +-
 drivers/scsi/qla2xxx/qla_init.c             |  162 +-
 drivers/scsi/qla2xxx/qla_iocb.c             |  132 +-
 drivers/scsi/qla2xxx/qla_isr.c              |   70 +-
 drivers/scsi/qla2xxx/qla_mbx.c              |   80 +-
 drivers/scsi/qla2xxx/qla_mid.c              |    3 +-
 drivers/scsi/qla2xxx/qla_mr.c               |   22 +-
 drivers/scsi/qla2xxx/qla_nx.c               |  165 +-
 drivers/scsi/qla2xxx/qla_nx2.c              |   20 +-
 drivers/scsi/qla2xxx/qla_nx2.h              |    6 +-
 drivers/scsi/qla2xxx/qla_os.c               |   41 +-
 drivers/scsi/qla2xxx/qla_sup.c              |   14 +-
 drivers/scsi/qla2xxx/qla_target.c           |  139 +-
 drivers/scsi/qla2xxx/qla_tmpl.c             |   27 +-
 drivers/scsi/qla2xxx/qla_version.h          |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c          |    6 +
 drivers/scsi/scsi_error.c                   |    9 +
 drivers/scsi/scsi_lib.c                     |   11 +-
 drivers/scsi/scsi_transport_iscsi.c         |   11 +-
 drivers/scsi/st.c                           |   83 +-
 drivers/scsi/storvsc_drv.c                  |  224 ++-
 include/scsi/scsi_device.h                  |    3 +-
 include/scsi/scsi_transport_iscsi.h         |    1 +
 include/uapi/scsi/Kbuild                    |    1 +
 include/uapi/scsi/cxlflash_ioctl.h          |  174 ++
 70 files changed, 9177 insertions(+), 1327 deletions(-)
 create mode 100644 Documentation/powerpc/cxlflash.txt
 create mode 100644 drivers/scsi/cxlflash/Kconfig
 create mode 100644 drivers/scsi/cxlflash/Makefile
 create mode 100644 drivers/scsi/cxlflash/common.h
 create mode 100644 drivers/scsi/cxlflash/lunmgt.c
 create mode 100644 drivers/scsi/cxlflash/main.c
 create mode 100644 drivers/scsi/cxlflash/main.h
 create mode 100644 drivers/scsi/cxlflash/sislite.h
 create mode 100644 drivers/scsi/cxlflash/superpipe.c
 create mode 100644 drivers/scsi/cxlflash/superpipe.h
 create mode 100644 drivers/scsi/cxlflash/vlun.c
 create mode 100644 drivers/scsi/cxlflash/vlun.h
 create mode 100644 include/uapi/scsi/cxlflash_ioctl.h

James



