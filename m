From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Re-instate sess_wait_list usage
Date: Sat, 18 May 2013 00:40:28 +0000
Message-ID: <1368837631-2239-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Joern Engel <joern@logfs.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here's a short series to re-instate the original sess_wait_list to pre
commit 1c7b13fe652 logic, along with the necessary changes to function
within ib_srpt code during active I/O shutdown.

This has been tested with ib_srpt, but still needs to be verified with
tcm_qla2xxx during active I/O shutdown.

Thanks,

--nab

Joern Engel (1):
  target: Remove unused wait_for_tasks bit in target_wait_for_sess_cmds

Nicholas Bellinger (2):
  target: Re-instate sess_wait_list for target_wait_for_sess_cmds
  ib_srpt: Call target_sess_cmd_list_set_waiting during
    shutdown_session

 drivers/infiniband/ulp/srpt/ib_srpt.c  |   34 +++++++++++++++++------
 drivers/infiniband/ulp/srpt/ib_srpt.h  |    1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    2 +-
 drivers/target/target_core_transport.c |   46 +++++++++++++------------------
 include/target/target_core_base.h      |    1 +
 include/target/target_core_fabric.h    |    2 +-
 6 files changed, 48 insertions(+), 38 deletions(-)

-- 
1.7.2.5
