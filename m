From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.12-rc4
Date: Sun, 06 Oct 2013 08:50:18 -0700
Message-ID: <1381074618.19256.253.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Linus!

Here are the outstanding target fixes queued up for v3.12-rc4 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The highlights include:

  - Make vhost/scsi tag percpu_ida_alloc() use GFP_ATOMIC
  - Allow sess_cmd_map allocation failure fallback to use vzalloc
  - Fix COMPARE_AND_WRITE se_cmd->data_length bug with FILEIO backends
  - Fixes for COMPARE_AND_WRITE callback recursive failure OOPs +
    non zero scsi_status bug
  - Make iscsi-target do acknowledgement tag release from RX context
  - Setup iscsi-target with extra (cmdsn_depth / 2) percpu_ida tags

Also included is a iscsi-target patch CC'ed for v3.10+ that avoids
legacy wait_for_task=true release during fast-past StatSN
acknowledgement, and two other SRP target related patches that address
long-standing issues that are CC'ed for v3.3+.

Extra thanks to Thomas Glanzmann for his testing feedback with
COMPARE_AND_WRITE + EXTENDED_COPY VAAI logic.

Thank you,

--nab

Jack Wang (1):
  ib_srpt: always set response for task management

Nicholas Bellinger (10):
  target: Fix xop->dbl assignment in target_xcopy_parse_segdesc_02
  ib_srpt: Destroy cm_id before destroying QP.
  vhost/scsi: Use GFP_ATOMIC with percpu_ida_alloc for obtaining tag
  target: Fall back to vzalloc upon ->sess_cmd_map kzalloc failure
  target: Reset data_length for COMPARE_AND_WRITE to NoLB * block_size
  target: Fix recursive COMPARE_AND_WRITE callback failure
  target: Fail on non zero scsi_status in compare_and_write_callback
  iscsi-target: Only perform wait_for_tasks when performing shutdown
  iscsi-target: Perform release of acknowledged tags from RX context
  iscsi-target; Allow an extra tag_num / 2 number of percpu_ida tags

 drivers/infiniband/ulp/srpt/ib_srpt.c    |   14 ++++++--------
 drivers/target/iscsi/iscsi_target.c      |   13 +++++++++----
 drivers/target/iscsi/iscsi_target_nego.c |    2 +-
 drivers/target/iscsi/iscsi_target_util.c |    4 ++--
 drivers/target/target_core_sbc.c         |   28 ++++++++++++++++++++++++++--
 drivers/target/target_core_transport.c   |   20 +++++++++++++++-----
 drivers/target/target_core_xcopy.c       |    4 ++--
 drivers/vhost/scsi.c                     |    7 ++++++-
 8 files changed, 67 insertions(+), 25 deletions(-)
