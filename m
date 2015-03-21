From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/3] iscsi/iser-target: Convert to kthread.h + fix logout failure
Date: Sat, 21 Mar 2015 06:16:01 +0000
Message-ID: <1426918564-22581-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Slava Shwartsman <valyushash@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hello Sagi & Slava,

Following the earlier pre-LSF discussion, here is a patch series
to convert iscsi/iser target to using modern kthread.h primitives
when starting / stopping RX + TX kernel threads during iscsi_conn
creation / shutdown.

So far this code has been tested with traditional iscsi-target
login / logout code-paths, and needs to be verified via iser-target
login / logout code-paths as well.

Also, patch #3 is a seperate iser-target bugfix to handle a failed
outgoing ISCSI_OP_LOGOUT_RSP in isert_cq_comp_err() completion
interrupt path code.  This one may or may not have been triggering
earlier, but addresses a possible iser-target specific logout bug.

Please review + test for v4.1-rc1 code.

Thank you,

--nab

Nicholas Bellinger (3):
  iscsi-target: Convert iscsi_thread_set usage to kthread.h
  iscsi-target: Drop legacy iscsi_target_tq.c logic
  iser-target: Handle special case for logout during connection failure

 drivers/infiniband/ulp/isert/ib_isert.c   |  16 +-
 drivers/target/iscsi/Makefile             |   1 -
 drivers/target/iscsi/iscsi_target.c       | 109 +++----
 drivers/target/iscsi/iscsi_target_erl0.c  |  14 +-
 drivers/target/iscsi/iscsi_target_login.c |  60 +++-
 drivers/target/iscsi/iscsi_target_tq.c    | 495 ------------------------------
 drivers/target/iscsi/iscsi_target_tq.h    |  84 -----
 drivers/target/iscsi/iscsi_target_util.c  |   1 -
 include/target/iscsi/iscsi_target_core.h  |  13 +-
 9 files changed, 131 insertions(+), 662 deletions(-)
 delete mode 100644 drivers/target/iscsi/iscsi_target_tq.c
 delete mode 100644 drivers/target/iscsi/iscsi_target_tq.h

-- 
1.9.1
