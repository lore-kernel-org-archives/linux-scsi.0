From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/4] iscsi/iser-target fixes for v4.2-rc
Date: Fri, 24 Jul 2015 02:51:15 +0000
Message-ID: <1437706279-10580-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Sagi & Co,

The following series is a handful of iscsi/iser-target related bugfixes
for issues uncovered during recent testing with v4.2-rc code.

Patch #1 fixes a long-standing use-after-free issue during explicit TPG
shutdown for demo-mode sessions.

Patch #2 addresses a >= v4.0-rc1 specific regression for the failure case
when iscsi_start_kthreads() is unable to start new kthreads.  An earlier
version of the patch was broken wrt iser-target, and this updated version
is now working as expected (with failure cases) for both transports.

Patch #3 address a different >= v4.0-rc1 specific regression where during
explicit logout with iser-target, the TX thread was being leaked due to
the same iscsi_start_kthreads() change.

And finally, patch #4 addresses a (new?) iser-target use-after-free issue,
where a REJECT CM event -> isert_connect_error() is doing the final
isert_put_conn() -> kref_put(), before iscsi_np context is able to release
the associated iscsi_conn, and do isert_wait_conn() -> isert_free_conn().

All four patches have been tested with both transports, but I'd really like
your review + testing especially on #4 as I'm not sure if the special case
applies only to REJECT events, or to other isert_connect_error() events
as well.   (#4 currently does the latter)

Thank you,

--nab

Nicholas Bellinger (4):
  iscsi-target: Fix use-after-free during TPG session shutdown
  iscsi-target: Fix iscsit_start_kthreads failure OOPs
  iscsi-target: Fix iser explicit logout TX kthread leak
  iser-target: Fix REJECT CM event use-after-free OOPs

 drivers/infiniband/ulp/isert/ib_isert.c   | 16 +++++++----
 drivers/target/iscsi/iscsi_target.c       | 48 +++++++++++++++++++++++++------
 drivers/target/iscsi/iscsi_target_login.c | 45 +++++++++++------------------
 drivers/target/iscsi/iscsi_target_login.h |  3 +-
 drivers/target/iscsi/iscsi_target_nego.c  | 34 +++++++++++++++++++++-
 include/target/iscsi/iscsi_target_core.h  |  1 +
 6 files changed, 103 insertions(+), 44 deletions(-)

-- 
1.9.1
