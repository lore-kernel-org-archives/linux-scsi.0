From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] TCM/LIO v4.0.0-rc7 for 2.6.38-rc2
Date: Mon, 24 Jan 2011 15:21:04 -0800
Message-ID: <1295911264.24778.79.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43081 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab1AXXVI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 18:21:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

Greetings all,

TCM/LIO v4.0.0-rc7 for 2.6.38-rc2 has been tagged and pushed into the
LIO upstream tree at @ lio-core-2.6.git/linus-38-rc2.  At this point
lio-core-2.6.git/linus-38-rc2 has been synced with mainline target code,
and the v4.0.0-rc7 PULL requests will be sent out shortly.

Thanks again to everyone who submitted patches and gave feedback this
round for LIO upstream code.  With these v4.0 changes headed into
mainline, the new lio-4.1 development tree will be starting shortly for
items tagged as 'for-39'.

Thanks!

--nab

Christoph Hellwig (2):
  target: do not include target_core_mib.h under include/target
  target: remove EXTRA_CFLAGS

Dan Carpenter (2):
  target: remove an unused variable
  target: unlock on error path in configfs

Fubo Chen (3):
  target: Drop nacl->device_list_lock on
    core_update_device_list_for_node failure
  target: Reaquire hba_lock + se_port_lock during se_clear_dev_ports
    continue
  target: Minor sparse warning fixes and annotations

Jesper Juhl (2):
  target/file: Fix memory leak in fd_set_configfs_dev_params().
  target: remove duplicate include target_core_device.h

Kiran Patil (3):
  TCM/LIO: Support for large FC offload (write exchange)
  ixgbe: Added support for receive offload in base driver for storage
    target.
  TCM/OpenFCoE : Added Large Send Offload

Nicholas Bellinger (25):
  tcm_fc: Clear frame_len before skipping to next frame
  Revert "tcm_fc: Clear frame_len before skipping to next frame"
  target: Add linux/blkdev.h include in target_core_base.h
  target: Add SCSI and BLOCK depends for TARGET_CORE
  target: Fix excessive stack usage
  target: Fix T_TASK(cmd)->t_task_cdb assignement breakage
  target: Add missing core_scsi3_put_pr_reg() for explict REGISTER key
    change
  target: Call transport_new_cmd_failure() while draining qobj_list
    during LUN_RESET
  target: Convert remaining usage of simple_strtoul -> strict_strtoul
  [SCSI] target: Add LIO target core v4.0.0-rc6
  target: iblock/pscsi claim checking for NULL instead of IS_ERR
  target: fix dubious one-bit signed bitfield
  target/iblock: Fix failed bd claim NULL pointer dereference
  iscsi: Fix OOPs in crypto_free_hash() exception path
  iscsi: select CRYPTO and CRYPTO_CRC32C* by default
  target/iblock: Fix memory leak in iblock_set_configfs_dev_params
  target: Fix memory leaks in
    target_core_dev_pr_store_attr_res_aptpl_metadata
  target: Fix demo-mode MappedLUN shutdown UA/PR breakage
  target: Release left-over demo-mode NodeACLs w/
    tfo->tpg_check_demo_mode_cache()=1
  target: Call missing list_del() for demo-mode MappedLUN disable
  target: Call proc_mkdir + remove_proc_entry with NULL parameter
  target: Convert backend ->create_virtdevice() call to return ERR_PTR
  target: Remove spurious double cast from structure macro accessors
  lio-core v4.0.0-rc7
  target core v4.0.0-rc7

Roland Dreier (2):
  target: Fix memory leak on error path
  target: Remove unneeded test of se_cmd

 drivers/target/Kconfig                           |    2 +
 drivers/target/Makefile                          |    1 -
 drivers/target/lio-target/Kconfig                |    3 +
 drivers/target/lio-target/iscsi_target_login.c   |    4 +-
 drivers/target/lio-target/iscsi_target_version.h |    2 +-
 drivers/target/target_core_configfs.c            |   56 ++++++++---
 drivers/target/target_core_device.c              |   51 +++++-----
 drivers/target/target_core_fabric_configfs.c     |   79 ++++++++---------
 drivers/target/target_core_fabric_lib.c          |    7 +-
 drivers/target/target_core_file.c                |   30 +++++--
 drivers/target/target_core_hba.c                 |    2 +-
 drivers/target/target_core_iblock.c              |   48 ++++++----
 drivers/target/target_core_mib.c                 |   20 ++++
 drivers/target/target_core_mib.h                 |    8 --
 drivers/target/target_core_pr.c                  |   59 ++++++------
 drivers/target/target_core_pscsi.c               |   45 +++++----
 drivers/target/target_core_pscsi.h               |    2 +-
 drivers/target/target_core_rd.c                  |   10 +-
 drivers/target/target_core_rd.h                  |    2 -
 drivers/target/target_core_scdb.c                |    2 +-
 drivers/target/target_core_tmr.c                 |   13 ++-
 drivers/target/target_core_tpg.c                 |   27 +++++-
 drivers/target/target_core_transport.c           |   68 +++++++-------
 drivers/target/tcm_fc/tcm_fc.h                   |    3 +
 drivers/target/tcm_fc/tfc_cmd.c                  |   33 ++++++-
 drivers/target/tcm_fc/tfc_conf.c                 |    4 +
 drivers/target/tcm_fc/tfc_io.c                   |  108 ++++++++++++++++++++--
 include/target/target_core_base.h                |   51 ++++++-----
 include/target/target_core_fabric_configfs.h     |    2 +-
 include/target/target_core_fabric_ops.h          |    2 +-
 include/target/target_core_transport.h           |    5 +
 31 files changed, 495 insertions(+), 254 deletions(-)


