From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/15] Target updates for June 28
Date: Tue, 28 Jun 2011 12:29:22 -0700
Message-ID: <1309289377-8029-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1F1T3s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 15:29:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi nab,

These updates comprise four major changes, and some small ones. (Please see
individual patch changelogs for rationales.) First, it makes all control cdbs
scatter-gather. Second, it removes struct se_mem. Third, it quiets dmesg
output by using pr_debug and friends instead of bare printks, and removes
the custom debug infrastructure. Fourth, it removes direct ramdisk code.

I look forward to hear your (and everyone's) comments on these changes.

Thanks -- Regards -- Andy

The following changes since commit 2a940ce682163cd41670243c3c10b47dbb206cfd:

  tcm_fc: Fix transport_lookup_tmr_lun failure usage (2011-06-22 19:51:27 -0700)

are available in the git repository at:
  git://fedorapeople.org/home/fedora/grover/public_git/linux-2.6.git for-nab

Andy Grover (15):
      target: Remove ifdeffed code in t_g_process_write
      target: Pass 2nd param of transport_split_cdb by value
      target: Make all control CDBs scatter-gather
      target: Disable rd_dr
      target: Eliminate usage of struct se_mem
      target: Rename task_sg_num to task_sg_nents
      target: Remove custom debug macros for pr_debug. Use pr_err().
      target: Remove custom debug macros in non-iscsi fabrics
      target/iscsi: Remove iscsi_target_debug.h and usage of TRACE() & printk()
      target/iscsi: Remove SE_CMD macro
      target: WRITE_SAME_16 and WRITE_SAME_32 should be DATA_SG_IO cdbs
      target: Set WSNZ=1 in block limits VPD. Abort if WRITE_SAME sectors = 0
      target: Enforce 1 page max for control cdb buffer sizes
      target: Remove direct ramdisk code
      target: Remove transport do_se_mem_map callback

 drivers/infiniband/ulp/srpt/ib_srpt.c             |    7 -
 drivers/scsi/qla2xxx/qla_target.c                 |    3 -
 drivers/target/iscsi/Kconfig                      |    9 -
 drivers/target/iscsi/iscsi_target.c               |  489 +++----
 drivers/target/iscsi/iscsi_target_auth.c          |   84 +-
 drivers/target/iscsi/iscsi_target_configfs.c      |   76 +-
 drivers/target/iscsi/iscsi_target_core.h          |    3 -
 drivers/target/iscsi/iscsi_target_datain_values.c |   13 +-
 drivers/target/iscsi/iscsi_target_debug.h         |  113 --
 drivers/target/iscsi/iscsi_target_device.c        |    7 +-
 drivers/target/iscsi/iscsi_target_erl0.c          |   71 +-
 drivers/target/iscsi/iscsi_target_erl1.c          |   67 +-
 drivers/target/iscsi/iscsi_target_erl2.c          |   86 +-
 drivers/target/iscsi/iscsi_target_login.c         |  105 +-
 drivers/target/iscsi/iscsi_target_nego.c          |   89 +-
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |   41 +-
 drivers/target/iscsi/iscsi_target_parameters.c    |  259 ++--
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |   43 +-
 drivers/target/iscsi/iscsi_target_tmr.c           |   63 +-
 drivers/target/iscsi/iscsi_target_tpg.c           |   77 +-
 drivers/target/iscsi/iscsi_target_tq.c            |   27 +-
 drivers/target/iscsi/iscsi_target_util.c          |  141 +-
 drivers/target/loopback/Kconfig                   |    6 -
 drivers/target/loopback/tcm_loop.c                |   99 +-
 drivers/target/loopback/tcm_loop.h                |    6 -
 drivers/target/target_core_alua.c                 |  120 +-
 drivers/target/target_core_cdb.c                  |   91 +-
 drivers/target/target_core_configfs.c             |  258 ++--
 drivers/target/target_core_device.c               |  175 ++--
 drivers/target/target_core_fabric_configfs.c      |   40 +-
 drivers/target/target_core_fabric_lib.c           |    6 +-
 drivers/target/target_core_file.c                 |   78 +-
 drivers/target/target_core_hba.c                  |   10 +-
 drivers/target/target_core_iblock.c               |   93 +-
 drivers/target/target_core_pr.c                   |  317 +++--
 drivers/target/target_core_pscsi.c                |  144 +--
 drivers/target/target_core_rd.c                   |  420 +-----
 drivers/target/target_core_scdb.c                 |   20 +-
 drivers/target/target_core_scdb.h                 |   10 +-
 drivers/target/target_core_stgt.c                 |   52 +-
 drivers/target/target_core_tmr.c                  |   39 +-
 drivers/target/target_core_tpg.c                  |   42 +-
 drivers/target/target_core_transport.c            | 1614 ++++++---------------
 drivers/target/target_core_ua.c                   |    8 +-
 drivers/target/tcm_fc/tcm_fc.h                    |   24 -
 drivers/target/tcm_fc/tfc_cmd.c                   |   57 +-
 drivers/target/tcm_fc/tfc_conf.c                  |   33 +-
 drivers/target/tcm_fc/tfc_io.c                    |  125 +-
 drivers/target/tcm_fc/tfc_sess.c                  |   18 +-
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |    6 -
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c |  190 ++--
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |   41 +-
 drivers/target/tcm_vhost/tcm_vhost_configfs.c     |   50 +-
 drivers/target/tcm_vhost/tcm_vhost_fabric.c       |   16 +-
 drivers/target/tcm_vhost/tcm_vhost_scsi.c         |   15 +-
 include/target/target_core_base.h                 |   19 +-
 include/target/target_core_transport.h            |   11 +-
 57 files changed, 2407 insertions(+), 3719 deletions(-)
 delete mode 100644 drivers/target/iscsi/iscsi_target_debug.h


