From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/13] Misc patches leading to target_submit_tmr
Date: Thu, 19 Jan 2012 13:39:10 -0800
Message-ID: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab2ASVj3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:39:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com

Hi nab, Kiran, and all,

Here are some cleanup patches to target, scsi, and tcm_fc. The biggest
change is adding a target_submit_tmr to match the new target_submit_cmd
helper function. I've only changed tcm_fc to use it so far, if it looks ok
I will change over the other fabrics.

I'm especially looking for review of the error handling changes in the
last few patches. Does transport_generic_free_cmd end up doing the
same thing as ft_sess_put, for example?

Thanks -- Regards -- Andy

The following changes since commit 7acd456a2fdae22d0f43db60f689ba3c57b69838:

  target: Fail INQUIRY commands with EVPD==0 but PAGE CODE!=0 (2012-01-17 22:54:29 -0800)

are available in the git repository at:
  git://fedorapeople.org/home/fedora/grover/public_git/linux-2.6.git for-nab

Andy Grover (13):
      scsi: Use struct scsi_lun in fc/fcp.h
      target: fix comment typos
      target: Remove unused struct se_queue_req
      target/iscsi: Remove unneeded wrapper functions
      target/fc: Simplify ft_send_work for tmr path
      target/fc: Remove cmd->cdb data member
      target: Inline struct se_tmr_req into se_cmd
      target/fc: Move core->fc code conversion earlier in ft_send_tm()
      target/fc: Call lookup_tmr_lun() for all TM types
      target/fc: Use transport_generic_free_cmd for ft_sess_put in ft_send_tm
      target: Add target_submit_tmr helper function
      target/fc: Use target_submit_tmr()
      target: Change target_submit_cmd() to return void

 drivers/infiniband/ulp/srpt/ib_srpt.c      |   18 +---
 drivers/scsi/bnx2fc/bnx2fc_io.c            |    4 +-
 drivers/scsi/libfc/fc_fcp.c                |    5 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c         |   22 ++---
 drivers/target/iscsi/iscsi_target.c        |   12 +-
 drivers/target/iscsi/iscsi_target_device.c |   19 ----
 drivers/target/iscsi/iscsi_target_device.h |    2 -
 drivers/target/iscsi/iscsi_target_tmr.c    |    6 +-
 drivers/target/iscsi/iscsi_target_util.c   |    8 +-
 drivers/target/loopback/tcm_loop.c         |   14 +--
 drivers/target/target_core_device.c        |    2 +-
 drivers/target/target_core_internal.h      |    2 -
 drivers/target/target_core_tmr.c           |   20 +---
 drivers/target/target_core_transport.c     |   77 +++++++++++-----
 drivers/target/tcm_fc/tcm_fc.h             |    2 -
 drivers/target/tcm_fc/tfc_cmd.c            |  142 ++++++++--------------------
 include/scsi/fc/fc_fcp.h                   |    6 +-
 include/target/target_core_base.h          |   47 ++++-----
 include/target/target_core_fabric.h        |    7 +-
 19 files changed, 164 insertions(+), 251 deletions(-)

