From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 00/42] qla2xxx: 8.07.00.08-k: Updates for scsi "misc" branch
Date: Fri, 11 Apr 2014 16:54:05 -0400
Message-ID: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:36210 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbaDKVcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Hi James,

Please apply the following patches to the scsi tree, misc branch at your
earliest convenience.

Thanks,
~Saurav


Armen Baloyan (3):
  qla2xxx: Change copyright year to 2014 in all the source files.
  qla2xxx: Decrease pci access for response queue processing for
    ISPFX00.
  qla2xxx: Adjust adapter reset routine to the changes in firmware
    specification for ISPFx00.

Atul Deshmukh (3):
  qla2xxx: Use proper log message for flash lock failed error.
  qla2xxx: Include <delay.h> file for msleep declartion in qla_nx2.c
    file.
  qla2xxx: IOCB data should be copied to I/O mem using memcpy_toio.

Chad Dupuis (7):
  qla2xxx: Do not schedule reset when one is already active when
    receiving an invalid status handle.
  qla2xxx: Remove unnecessary printk_ratelimited from qla_nx2.c
  qla2xxx: Avoid escalating the SCSI error handler if the command is
    not found in firmware.
  qla2xxx: Clear loop_id for ports that are marked lost during fabric
    scanning.
  qla2xxx: Reduce the time we wait for a command to complete during
    SCSI error handling.
  qla2xxx: Do logins from a chip reset in DPC thread instead of the
    error handler thread.
  qla2xxx: Remove wait for online from host reset handler.

Giridhar Malavali (3):
  qla2xxx: Log when device state is moved to failed state.
  qla2xxx: Issue abort command for outstanding commands during cleanup
    when only firmware is alive.
  qla2xxx: Check for peg alive counter and clear any outstanding
    mailbox command.

Himanshu Madani (1):
  qla2xxx: Fix beacon blink logic for ISP26xx/83xx.

Himanshu Madhani (1):
  qla2xxx: Remove mapped vp index iterator macro dead code.

Hiral Patel (5):
  qla2xxx: Track the process when the ROM_LOCK failure happens
  qla2xxx: Remove unnecessary delays from fw dump code path.
  qla2xxx: Introduce fw_dump_flag to track fw dump progress.
  qla2xxx: Enable fw_dump_size for ISP8044.
  qla2xxx: Check the QLA8044_CRB_DRV_ACTIVE_INDEX register when we are
    not the owner of the reset.

Joe Carnuccio (11):
  qla2xxx: Correct operations for ISP27xx template types 270 and 271.
  qla2xxx: Allow ISP83XX and ISP27XX both to write req_q_out register.
  qla2xxx: Correct ISP83xx/ISP27xx mislogic in setting out_mb in
    qla25xx_init_req_que().
  qla2xxx: Add pci device id 0x2271.
  qla2xxx: Add ISP8044 serdes bsg interface.
  qla2xxx: Correction to ISP27xx template entry types 256 and 258.
  qla2xxx: Update entry type 270 to match spec update.
  qla2xxx: ISP8044 poll ipmdio bus timeout improvement.
  qla2xxx: ISP27xx firmware dump template spec updates (including
    T274).
  qla2xxx: ISP27xx queue index shadow registers.
  qla2xxx: Add MBC option for fast SFP data access.

Pratik Mohanty (1):
  qla2xxx: Support of new firmware dump opcodes QLA8044_RDDFE(38),
    QLA8044_RDMDIO(39),QLA8044_POLLWR(40).

Quinn Tran (2):
  qla2xxx: T10-Dif: add T10-PI support
  qla2xxx: ABTS cause double free of qla_tgt_cmd +.

Saurav Kashyap (3):
  qla2xxx: Wait for reset completion without lock for ISPFX00.
  qla2xxx: Allow the next firmware dump if the previous dump capture
    fails for ISP8044.
  qla2xxx: Update the driver version to 8.07.00.08-k.

Sawan Chandak (1):
  qla2xxx: Delay driver unload if there is any pending activity going
    on.

Tej Prakash (1):
  qla2xxx: Don't check for firmware hung during the reset context for
    ISP82XX.

 Documentation/scsi/LICENSE.qla2xxx  |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c     |    6 +-
 drivers/scsi/qla2xxx/qla_bsg.c      |   49 +++-
 drivers/scsi/qla2xxx/qla_bsg.h      |    9 +-
 drivers/scsi/qla2xxx/qla_dbg.c      |  127 ++++---
 drivers/scsi/qla2xxx/qla_dbg.h      |    5 +-
 drivers/scsi/qla2xxx/qla_def.h      |   44 ++-
 drivers/scsi/qla2xxx/qla_dfs.c      |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h       |   14 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |   14 +-
 drivers/scsi/qla2xxx/qla_gs.c       |    2 +-
 drivers/scsi/qla2xxx/qla_init.c     |   53 +--
 drivers/scsi/qla2xxx/qla_inline.h   |   15 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |  146 ++++++---
 drivers/scsi/qla2xxx/qla_isr.c      |   23 +-
 drivers/scsi/qla2xxx/qla_mbx.c      |   93 +++++-
 drivers/scsi/qla2xxx/qla_mid.c      |    2 +-
 drivers/scsi/qla2xxx/qla_mr.c       |   64 +++-
 drivers/scsi/qla2xxx/qla_mr.h       |    3 +-
 drivers/scsi/qla2xxx/qla_nx.c       |   87 +++---
 drivers/scsi/qla2xxx/qla_nx.h       |    6 +-
 drivers/scsi/qla2xxx/qla_nx2.c      |  510 +++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_nx2.h      |   50 +++-
 drivers/scsi/qla2xxx/qla_os.c       |  102 +++---
 drivers/scsi/qla2xxx/qla_settings.h |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c      |    9 +-
 drivers/scsi/qla2xxx/qla_target.c   |  650 +++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.h   |   84 +++++-
 drivers/scsi/qla2xxx/qla_tmpl.c     |   91 ++++--
 drivers/scsi/qla2xxx/qla_tmpl.h     |   17 +-
 drivers/scsi/qla2xxx/qla_version.h  |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c  |   41 ++-
 32 files changed, 1887 insertions(+), 439 deletions(-)

-- 
1.7.7

