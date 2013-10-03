From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/3] iscsi-target: percpu_ida tag starvation regression fixes
Date: Thu,  3 Oct 2013 21:01:09 +0000
Message-ID: <1380834072-25309-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This series addresses a v3.12 starvation regression in iscsi-target
after the conversion to use percpu_ida tag preallocation for all
iscsi_cmd descriptors.

The first patch addresses an unnecessary overhead during iscsi_cmd
acknowledgement -> release, that could end up causing an extra
context switch to occur for WRITEs.  With the advent of proper
se_cmd->cmd_kref handling in v3.10, this is no longer required
in the acknowledgement fast path.

The second patch converts iscsit_ack_from_expstatsn() to populate
a local list of acknowledged iscsi_cmd descriptors, and releases
them as quickly as possible (and the associated percpu_ida tags)
directly from RX thread context.

The third patch adds another (tag_num / 2) extra pre-allocated tags,
in order to prevent percpu_ida_alloc() from needing to steal tags
when the number of acknowledged tags in use is large, seperate from
the tags for the CmdSN window depth.

I'll be including into target-pending/master shortly, and sending
off a PULL request to include for v3.12-rc4 over the next days.

Thanks,

--nab

Nicholas Bellinger (3):
  iscsi-target: Only perform wait_for_tasks when performing shutdown
  iscsi-target: Perform release of acknowledged tags from RX context
  iscsi-target; Allow an extra tag_num / 2 number of percpu_ida tags

 drivers/target/iscsi/iscsi_target.c      |   13 +++++++++----
 drivers/target/iscsi/iscsi_target_nego.c |    2 +-
 drivers/target/iscsi/iscsi_target_util.c |    4 ++--
 3 files changed, 12 insertions(+), 7 deletions(-)

-- 
1.7.10.4
