From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.16-rc1
Date: Fri, 09 Feb 2018 10:43:39 -0800
Message-ID: <1518201819.24576.356.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target-pending updates for v4.16-rc1.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The highlights include:

- Numerous target-core-user improvements related to queue full and timeout handling. (MNC)
- Prevent target-core-user corruption when invalid data page is requested. (MNC)
- Add target-core device action configfs attributes to allow user-space to
  trigger events separate from existing attributes exposed to end-users. (MNC)
- Fix iscsi-target NULL pointer dereference 4.6+ regression in CHAP error path.
  (David Disseldorp)
- Avoid target-core backend UNMAP callbacks if range is zero. (Andrei Vagin)
- Fix a iscsi-target 4.14+ regression related multiple PDU logins, that
  was exposed due to removal of TCP prequeue support. (Florian Westphal + MNC)

Also, there is a iser-target bug still being worked on for post -rc1
code to address a long standing issue resulting in persistent
ib_post_send() failures, for RNICs with small max_send_sge.  

Thank you,

--nab

Andrei Vagin (1):
  target: don't call an unmap callback if a range length is zero

David Disseldorp (1):
  target/iscsi: avoid NULL dereference in CHAP auth error path

Florian Westphal (1):
  iscsi-target: make sure to wake up sleeping login worker

Luis de Bethencourt (1):
  tcmu: Fix trailing semicolon

Markus Elfring (7):
  sbp-target: Delete an error message for a failed memory allocation in
    three functions
  target: tcm_loop: Delete an error message for a failed memory
    allocation in four functions
  target: tcm_loop: Improve a size determination in two functions
  target: tcm_loop: Combine substrings for 26 messages
  target: tcm_loop: Delete two unnecessary variable initialisations in
    tcm_loop_issue_tmr()
  target: tcm_loop: Delete an unnecessary return statement in
    tcm_loop_submission_work()
  target: tcm_loop: Use seq_puts() in tcm_loop_show_info()

Mike Christie (19):
  tcmu: merge common block release code
  tcmu: split unmap_thread_fn
  tcmu: fix unmap thread race
  tcmu: move expired command completion to unmap thread
  tcmu: remove commands_lock
  tcmu: release blocks for partially setup cmds
  tcmu: simplify scatter_data_area error handling
  tcmu: fix free block calculation
  tcmu: prep queue_cmd_ring to be used by unmap wq
  tcmu: simplify dbi thresh handling
  tcmu: don't block submitting context for block waits
  tcmu: make ring buffer timer configurable
  tcmu: allow max block and global max blocks to be settable
  tcmu: prevent corruption when invalid data page requested
  target: add SAM_STAT_BUSY sense reason
  target_core_user: add cmd id to broken ring message
  target core: add device action configfs files
  tcmu: allow userspace to reset ring
  tcmu: fix cmd user after free

Rasmus Villemoes (1):
  target-core: don't use "const char*" for a buffer that is written to

Varun Prakash (1):
  cxgbit: call neigh_event_send() to update MAC address

Wei Yongjun (1):
  tcmu: fix error return code in tcmu_configure_device()

Xiubo Li (1):
  tcmu: clean up the scatter helper

tangwenji (2):
  tcmu: fix page addr in tcmu_flush_dcache_range
  target: fix destroy device in target_configure_device

 drivers/target/iscsi/cxgbit/cxgbit_cm.c  |   3 +
 drivers/target/iscsi/iscsi_target_auth.c |   3 +-
 drivers/target/iscsi/iscsi_target_nego.c |   3 +
 drivers/target/loopback/tcm_loop.c       | 145 ++---
 drivers/target/sbp/sbp_target.c          |  13 +-
 drivers/target/target_core_configfs.c    |   6 +
 drivers/target/target_core_device.c      |   4 +-
 drivers/target/target_core_fabric_lib.c  |   6 +-
 drivers/target/target_core_internal.h    |   3 +-
 drivers/target/target_core_pr.c          |   4 +-
 drivers/target/target_core_sbc.c         |   8 +-
 drivers/target/target_core_transport.c   |   3 +
 drivers/target/target_core_user.c        | 983 ++++++++++++++++++++++---------
 include/target/target_core_backend.h     |   1 +
 include/target/target_core_base.h        |   2 +
 15 files changed, 798 insertions(+), 389 deletions(-)
