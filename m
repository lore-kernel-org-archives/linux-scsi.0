From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/31] target: mainline updates for .38-rc5
Date: Wed,  9 Feb 2011 15:34:35 -0800
Message-ID: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm23.bullet.mail.ne1.yahoo.com ([98.138.90.86]:48207 "HELO
	nm23.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752197Ab1BIXew (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:34:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

The following patches condenses the original two target series to only contain
bugfixes and updates to Documentation/target/tcm_mod_builder.py:

{PATCH 00/12] target: Updates for .38-rc4
http://marc.info/?l=linux-scsi&m=129680191624837&w=2

[PATCH 00/24] target updates for .38-rc3 (v2)
http://marc.info/?l=linux-scsi&m=129632617326015&w=2

Please review and apply for mainline.  The patches are also available in git here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc5-jejb

This series is made against the following mainline commit HEAD:

  commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d
  Author: Linus Torvalds <torvalds@linux-foundation.org>
  Date:   Mon Feb 7 16:03:17 2011 -0800

      Linux 2.6.38-rc4

Also, the handful minor patches not included in this series, and been pushed here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc5-jejb-misc

Please let me know if you have any questions,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Christoph Hellwig (1):
  target: do not include target_core_mib.h under include/target

Dan Carpenter (3):
  target: iblock/pscsi claim checking for NULL instead of IS_ERR
  target: fix dubious one-bit signed bitfield
  target: Convert rd_build_device_space() to use errno

Fubo Chen (2):
  target: Drop nacl->device_list_lock on
    core_update_device_list_for_node failure
  target: Fix generated *_drop_nodeacl() handler in tcm_mod_builder.py

Jesper Juhl (2):
  target/file: Fix memory leak in fd_set_configfs_dev_params().
  target: Avoid mem leak and needless work in transport_generic_get_mem

Nicholas Bellinger (22):
  target/iblock: Fix failed bd claim NULL pointer dereference
  target/iblock: Fix memory leak in iblock_set_configfs_dev_params
  target: Fix memory leaks in
    target_core_dev_pr_store_attr_res_aptpl_metadata
  target: Fix demo-mode MappedLUN shutdown UA/PR breakage
  target: Release left-over demo-mode NodeACLs w/
    tfo->tpg_check_demo_mode_cache()=1
  target: tcm_mod_builder.py generated Makefile cleanups
  target: Convert backend ->create_virtdevice() call to return ERR_PTR
  target: Convert TMR REQ/RSP definitions to target namespace
  target core v4.0.0-rc7
  target: Fix top-level configfs_subsystem default_group shutdown
    breakage
  target: Move core_delete_hba() into ->release() callback
  target: Move subdev release logic into ->release() callback
  target: Move core_alua_free_lu_gp() into ->release() callback
  target: Move core_alua_free_tg_pt_gp() into ->release() callback
  target: Move fabric dependent struct se_wwn free into ->release()
    callback
  target: Move fabric dependent se_portal_group free into ->release()
    callback
  target: Move fabric dependent se_node_acl free into ->release
    callback()
  target: Move fabric dependent struct se_tpg_np free into ->release()
    callback
  target: Move fabric independent se_lun_acl free into ->release()
    callback
  target: Remove procfs based target_core_mib.c code
  target: Fix SCF_SCSI_CONTROL_SG_IO_CDB breakage
  target: Fix bogus return in transport_add_device_to_core_hba failure
    path

Roland Dreier (1):
  target: Fix memory leak on error path

 Documentation/target/tcm_mod_builder.py      |   18 +-
 drivers/target/Makefile                      |    3 +-
 drivers/target/target_core_configfs.c        |  192 +++--
 drivers/target/target_core_device.c          |   13 +-
 drivers/target/target_core_fabric_configfs.c |   92 ++-
 drivers/target/target_core_file.c            |   26 +-
 drivers/target/target_core_iblock.c          |   34 +-
 drivers/target/target_core_mib.c             | 1078 --------------------------
 drivers/target/target_core_mib.h             |   28 -
 drivers/target/target_core_pscsi.c           |   23 +-
 drivers/target/target_core_rd.c              |   15 +-
 drivers/target/target_core_tpg.c             |   29 +-
 drivers/target/target_core_transport.c       |   81 ++-
 include/target/target_core_base.h            |   45 +-
 include/target/target_core_fabric_ops.h      |    2 +-
 include/target/target_core_tmr.h             |   52 +-
 include/target/target_core_transport.h       |    2 +
 17 files changed, 393 insertions(+), 1340 deletions(-)
 delete mode 100644 drivers/target/target_core_mib.c
 delete mode 100644 drivers/target/target_core_mib.h

-- 
1.7.4

