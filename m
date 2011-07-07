From: Andy Grover <agrover@redhat.com>
Subject: [0/20] Patches from June 28 v2
Date: Thu,  7 Jul 2011 15:33:11 -0700
Message-ID: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1GGWdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2011 18:33:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi nab, hch, and all.

Here's the patchset from June 28, revised based on hch's comments.

The few added patches just clean up the redundant parentheses throughout
the code, no material changes but they bugged me :)

I've also been working on going back to core-alloc for iscsi and other
iscsit_handle_scsi_cmd() cleanups, but that work is not ready and getting
complicated, so I'll save it for next time.

Thanks -- Regards -- Andy

The following changes since commit 2a940ce682163cd41670243c3c10b47dbb206cfd:

  tcm_fc: Fix transport_lookup_tmr_lun failure usage (2011-06-22 19:51:27 -0700)

are available in the git repository at:
  git://fedorapeople.org/home/fedora/grover/public_git/linux-2.6.git for-nab

Andy Grover (20):
      target: Remove ifdeffed code in t_g_process_write
      target: Pass 2nd param of transport_split_cdb by value
      target: Make all control CDBs scatter-gather
      target: Enforce 1 page max for control cdb buffer sizes
      target: Remove direct ramdisk code
      target: Eliminate usage of struct se_mem
      target: Rename task_sg_num to task_sg_nents
      target: Remove custom debug macros for pr_debug. Use pr_err().
      target: Remove custom debug macros in non-iscsi fabrics
      target/iscsi: Remove iscsi_target_debug.h and usage of TRACE() & printk()
      target/iscsi: Remove SE_CMD macro
      target: Set WSNZ=1 in block limits VPD. Abort if WRITE_SAME sectors = 0
      target: Remove transport do_se_mem_map callback
      target: When using kunmap_first_data_page, use goto-style err handling
      target: Further simplify transport_free_pages
      target: Redo task allocation return value handling
      target/core: Remove extra parentheses
      target: Extraneous paren removal in tcm_vhost and tcm_qla2xxx
      target/iscsi: Remove unneeded parens in conditional statements
      target/iscsi: Simplify two small bits

 drivers/infiniband/ulp/srpt/ib_srpt.c             |    7 -
 drivers/scsi/qla2xxx/qla_target.c                 |    3 -
 drivers/target/iscsi/Kconfig                      |    9 -
 drivers/target/iscsi/iscsi_target.c               |  493 +++----
 drivers/target/iscsi/iscsi_target_auth.c          |   84 +-
 drivers/target/iscsi/iscsi_target_configfs.c      |   76 +-
 drivers/target/iscsi/iscsi_target_core.h          |    3 -
 drivers/target/iscsi/iscsi_target_datain_values.c |   13 +-
 drivers/target/iscsi/iscsi_target_debug.h         |  113 --
 drivers/target/iscsi/iscsi_target_device.c        |    7 +-
 drivers/target/iscsi/iscsi_target_erl0.c          |   71 +-
 drivers/target/iscsi/iscsi_target_erl1.c          |   67 +-
 drivers/target/iscsi/iscsi_target_erl2.c          |   86 +-
 drivers/target/iscsi/iscsi_target_login.c         |  115 +-
 drivers/target/iscsi/iscsi_target_nego.c          |   89 +-
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |   41 +-
 drivers/target/iscsi/iscsi_target_parameters.c    |  379 +++---
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |   53 +-
 drivers/target/iscsi/iscsi_target_tmr.c           |   63 +-
 drivers/target/iscsi/iscsi_target_tpg.c           |   77 +-
 drivers/target/iscsi/iscsi_target_tq.c            |   43 +-
 drivers/target/iscsi/iscsi_target_util.c          |  145 +-
 drivers/target/loopback/Kconfig                   |    6 -
 drivers/target/loopback/tcm_loop.c                |   99 +-
 drivers/target/loopback/tcm_loop.h                |    6 -
 drivers/target/target_core_alua.c                 |  210 ++--
 drivers/target/target_core_cdb.c                  |  115 +-
 drivers/target/target_core_configfs.c             |  470 +++---
 drivers/target/target_core_device.c               |  219 ++--
 drivers/target/target_core_fabric_configfs.c      |  110 +-
 drivers/target/target_core_fabric_lib.c           |   10 +-
 drivers/target/target_core_file.c                 |   90 +-
 drivers/target/target_core_hba.c                  |   12 +-
 drivers/target/target_core_iblock.c               |  117 +-
 drivers/target/target_core_pr.c                   |  514 ++++---
 drivers/target/target_core_pscsi.c                |  188 +--
 drivers/target/target_core_rd.c                   |  446 +-----
 drivers/target/target_core_scdb.c                 |   20 +-
 drivers/target/target_core_scdb.h                 |   10 +-
 drivers/target/target_core_stgt.c                 |   62 +-
 drivers/target/target_core_tmr.c                  |   61 +-
 drivers/target/target_core_tpg.c                  |   75 +-
 drivers/target/target_core_transport.c            | 1724 ++++++---------------
 drivers/target/target_core_ua.c                   |   30 +-
 drivers/target/tcm_fc/tcm_fc.h                    |   24 -
 drivers/target/tcm_fc/tfc_cmd.c                   |   57 +-
 drivers/target/tcm_fc/tfc_conf.c                  |   33 +-
 drivers/target/tcm_fc/tfc_io.c                    |  125 +-
 drivers/target/tcm_fc/tfc_sess.c                  |   18 +-
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |    6 -
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c |  216 ++--
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |   43 +-
 drivers/target/tcm_vhost/tcm_vhost_configfs.c     |   62 +-
 drivers/target/tcm_vhost/tcm_vhost_fabric.c       |   18 +-
 drivers/target/tcm_vhost/tcm_vhost_scsi.c         |   15 +-
 include/target/target_core_base.h                 |   19 +-
 include/target/target_core_transport.h            |   11 +-
 57 files changed, 2966 insertions(+), 4312 deletions(-)
 delete mode 100644 drivers/target/iscsi/iscsi_target_debug.h


