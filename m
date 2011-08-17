From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/21] target: Pending fixes for v3.1-rc3
Date: Wed, 17 Aug 2011 23:17:04 +0000
Message-ID: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58285 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1HQXmK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hello from LinuxCon,

The following is the current pending series of target fixes for -rc3 that
includes a number of important bugfixes to what's currently in mainline -rc2.
This big items are fixes for a handful of control CDBs broken during the big
-rc1 merge, breakage with multi se_task support, and SGL chaining logic used
by one in tree driver and a number of in-flight HW target mode drivers..

At this point there is still two outstanding issues not addressed in this
series related to some recent NAA IEEE Registered Extended designator format
breakage reported with VMFS, and breakage with LUN discovery in tcm_fc(fcoe)
These bugs are still being discussed and addressed, and will be sent out in a
seperate series.

These patches will be going to Linus in pull request form in the next days,
so please have a look and let us know if anything needs more attention.

Thank you,

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
 drivers/target/target_core_device.c            |   44 ++++-
 drivers/target/target_core_fabric_configfs.c   |    2 +-
 drivers/target/target_core_pr.c                |    8 +-
 drivers/target/target_core_rd.c                |   24 +--
 drivers/target/target_core_tpg.c               |   64 ++++----
 drivers/target/target_core_transport.c         |  206 ++++++++++++++----------
 drivers/target/tcm_fc/tfc_conf.c               |    6 +-
 include/target/target_core_fabric_ops.h        |    6 +
 15 files changed, 272 insertions(+), 215 deletions(-)

-- 
1.7.6

