From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/24] target updates for .38-rc3 (v2)
Date: Sat, 29 Jan 2011 10:36:00 -0800
Message-ID: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.238]:36383 "HELO
	nm16-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753442Ab1A2SgK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:36:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings James and Co,

This 'for-38-rc3' series updates target code from the initial mainline merge
commit to TCM v4.0.0-rc7+ in the LIO upstream tree.  This includes a number
of bug-fixes and minor cleanups submitted to linux-scsi over the past weeks,
and addresses a handful of issues that have appeared thus far during initial
.38-rc1,2 testing with mainline target code.

Please review and apply.  The patches are also available in git here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc3-v2

This series is made against the following commit HEAD:

  commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5
  Author: Linus Torvalds <torvalds@linux-foundation.org>
  Date:   Fri Jan 21 19:01:34 2011 -0800

      Linux 2.6.38-rc2

Thanks again to everyone who has submitted patches!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Christoph Hellwig (2):
  target: do not include target_core_mib.h under include/target
  target: remove EXTRA_CFLAGS

Dan Carpenter (4):
  target: iblock/pscsi claim checking for NULL instead of IS_ERR
  target: fix dubious one-bit signed bitfield
  target: Convert rd_build_device_space() to use errno
  target: Remove unnecessary container_of() pointer check

Fubo Chen (3):
  target: Drop nacl->device_list_lock on
    core_update_device_list_for_node failure
  target: Remove unnecessary hba_dev_list walk + release from
    core_delete_hba
  target: Minor sparse warning fixes and annotations

Jesper Juhl (1):
  target/file: Fix memory leak in fd_set_configfs_dev_params().

Nicholas Bellinger (12):
  target/iblock: Fix failed bd claim NULL pointer dereference
  target/iblock: Fix memory leak in iblock_set_configfs_dev_params
  target: Fix memory leaks in
    target_core_dev_pr_store_attr_res_aptpl_metadata
  target: Fix demo-mode MappedLUN shutdown UA/PR breakage
  target: Release left-over demo-mode NodeACLs w/
    tfo->tpg_check_demo_mode_cache()=1
  target: tcm_mod_builder.py generated Makefile cleanups
  target: Call proc_mkdir + remove_proc_entry with NULL parameter
  target: Convert backend ->create_virtdevice() call to return ERR_PTR
  target: Remove unnecessary se_clear_dev_ports legacy code
  target: Remove spurious double cast from structure macro accessors
  target: Convert TMR REQ/RSP definitions to target namespace
  target core v4.0.0-rc7

Roland Dreier (2):
  target: Fix memory leak on error path
  target: Remove unneeded test of se_cmd

 Documentation/target/tcm_mod_builder.py |   17 +++----
 drivers/target/Makefile                 |    1 -
 drivers/target/target_core_configfs.c   |   50 ++++++++++++++++-----
 drivers/target/target_core_device.c     |   74 ++++++++-----------------------
 drivers/target/target_core_fabric_lib.c |    1 +
 drivers/target/target_core_file.c       |   26 +++++++++--
 drivers/target/target_core_hba.c        |   16 +-----
 drivers/target/target_core_iblock.c     |   34 +++++++++-----
 drivers/target/target_core_mib.c        |   20 ++++++++
 drivers/target/target_core_mib.h        |    7 ---
 drivers/target/target_core_pscsi.c      |   26 ++++++-----
 drivers/target/target_core_rd.c         |   15 +++---
 drivers/target/target_core_rd.h         |    2 -
 drivers/target/target_core_tpg.c        |   23 ++++++++++
 drivers/target/target_core_transport.c  |   24 ++++------
 include/target/target_core_base.h       |   46 +++++++++++--------
 include/target/target_core_fabric_ops.h |    2 +-
 include/target/target_core_tmr.h        |   52 +++++++++------------
 include/target/target_core_transport.h  |    4 ++
 19 files changed, 240 insertions(+), 200 deletions(-)

-- 
1.7.3.5

