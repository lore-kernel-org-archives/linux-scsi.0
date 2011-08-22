From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.1-rc3
Date: Mon, 22 Aug 2011 13:38:53 -0700
Message-ID: <1314045533.12514.32.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

The following is the current set of pending target fixes for -rc3 that
address a number of issues with -rc1 target code.  These fixes have been
stewing in lio-core-2.6.git for the last two weeks, and have been
re-posted to the list last week for additional review.

Note that the series was rebased this morning to include a missing bit
in one of the existing patches, but other than this minor item the
current series remains unchanged and has been seeing a fair amount of
testing from users over the last week.

This series includes the following major fixes:

*) Make INQUIRY return 'non connected' status to address breakge with
   certain initiators (reported + extra fix by Roland)
*) Fix write payload exception handling with ->new_cmd_map
*) Fix CDB emulation handling for WRITE_SAME
*) Fix CDB emulation handling for SYNCHRONIZE_CACHE zero LBA + range   
   breakage
*) Fix multiple se_task handling bug (reported by Chris Boot)
*) Fix task SGL chaining breakage with transport_allocate_data_tasks

At this point there is still two outstanding issues not addressed in
this series related to some recent NAA IEEE Registered Extended
designator format breakage reported with VMFS, and breakage with LUN
discovery in tcm_fc(fcoe).  These bugs are still being discussed and
addressed, and will be sent out in a seperate series for -rc4.

The series is available directly here:

  master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.git 3.1-rc-fixes

This tree is also available from kernel.org mirrors at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git 3.1-rc-fixes

The series has been made against the following upstream HEAD:

commit 93ee7a9340d64f20295aacc3fb6a22b759323280
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Aug 14 15:09:08 2011 -0700

    Linux 3.1-rc2

Thanks!

--nab

Chris Boot (1):
  iscsi-target: Implement iSCSI target IPv6 address printing.

Dan Carpenter (3):
  iscsi-target: remove duplicate return
  iscsi-target: forever loop bug in iscsit_attach_ooo_cmdsn()
  iscsi-target: Fix iscsit_allocate_se_cmd_for_tmr failure path bugs

Jesper Juhl (1):
  iscsi-target: Fix leak on failure in iscsi_copy_param_list()

Julia Lawall (1):
  target: Convert target_core_rd.c to use use BUG_ON

Nicholas Bellinger (10):
  target: Change TCM_NON_EXISTENT_LUN response to ASC=LOGICAL UNIT NOT
    SUPPORTED
  target: Make standard INQUIRY return 'not connected' for
    tpg_virt_lun0
  target: Fix write payload exception handling with ->new_cmd_map
  target: Add WRITE_SAME (10) parsing and refactor passthrough checks
  target: Fix WRITE_SAME usage with transport_get_size
  target: Remove duplicate task completions in
    transport_emulate_control_cdb
  target: Fix SYNCHRONIZE_CACHE zero LBA + range breakage
  target: Add missing DATA_SG_IO transport_cmd_get_valid_sectors check
  target: Fix task count > 1 handling breakage and use max_sector page
    alignment
  target: Fix task SGL chaining breakage with
    transport_allocate_data_tasks

Roland Dreier (4):
  target: Print subpage too for unhandled MODE SENSE pages
  tcm_fc: init/exit functions should not be protected by "#ifdef
    MODULE"
  target: Make locking in transport_deregister_session() IRQ safe
  target: Convert acl_node_lock to be IRQ-disabling

Thomas Meyer (1):
  target: Use ERR_CAST inlined function

 drivers/target/iscsi/iscsi_target.c            |    1 -
 drivers/target/iscsi/iscsi_target_configfs.c   |    4 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |    2 +-
 drivers/target/iscsi/iscsi_target_login.c      |   16 +--
 drivers/target/iscsi/iscsi_target_parameters.c |   43 ++---
 drivers/target/iscsi/iscsi_target_util.c       |    4 +-
 drivers/target/target_core_cdb.c               |   57 ++++---
 drivers/target/target_core_device.c            |   48 +++++-
 drivers/target/target_core_fabric_configfs.c   |    2 +-
 drivers/target/target_core_pr.c                |    8 +-
 drivers/target/target_core_rd.c                |   24 +--
 drivers/target/target_core_tpg.c               |   64 ++++----
 drivers/target/target_core_transport.c         |  206 ++++++++++++++----------
 drivers/target/tcm_fc/tfc_conf.c               |    6 +-
 include/target/target_core_fabric_ops.h        |    6 +
 15 files changed, 275 insertions(+), 216 deletions(-)

-- 
1.7.6
