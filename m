From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/5] target: Miscellaneous bug-fixes for >= v4.10
Date: Tue,  7 Feb 2017 13:17:45 +0000
Message-ID: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

This series contains a handful of bug-fixes that I've been validating
on v4.1.y code for production usage over the past couple of months.

All of these are long-standing issues that I don't think other
folks have been able to hit (or at least not reported), but have
been reproduced by Datera's QA team and/or have been reported by
customers.

Most of the patches are straight-forward fixes have been running
in Datera's nightly automation for weeks to months.

The one exception in patch #1 is a >= v4.2 RCU regression bug-fix
reported by Benjamin Estrabaud a while back, that re-instates
pre RCU conversion logic that kills a bogus BUG_ON() during
dynamic -> explicit se_node_acl conversion.

Please review.

--nab

Nicholas Bellinger (5):
  target: Don't BUG_ON during NodeACL dynamic -> explicit conversion
  target: Use correct SCSI status during EXTENDED_COPY exception
  target: Fix early transport_generic_handle_tmr abort scenario
  target: Fix multi-session dynamic se_node_acl double free OOPs
  target: Fix COMPARE_AND_WRITE ref leak for non GOOD status

 drivers/target/target_core_device.c    | 16 +++++--
 drivers/target/target_core_sbc.c       |  8 +++-
 drivers/target/target_core_tpg.c       |  4 +-
 drivers/target/target_core_transport.c | 86 +++++++++++++++++++++++-----------
 drivers/target/target_core_xcopy.c     |  2 +-
 include/target/target_core_base.h      |  1 +
 6 files changed, 80 insertions(+), 37 deletions(-)

-- 
1.9.1
