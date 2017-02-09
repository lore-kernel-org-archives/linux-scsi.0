From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.10
Date: Thu, 09 Feb 2017 13:17:08 -0800
Message-ID: <1486675028.12776.35.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, Robert Millner <rlm@daterainc.com>, Gary Guo <ghg@datera.io>, Kevin Vajk <kmv@datera.io>, Vaibhov Tandon <vst@datera.io>, Nixon Vincent <nixon.vincent@calsoftinc.com>, Benjamin ESTRABAUD <be@mpstor.com>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Donald White <dew@datera.io>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

The following target series for v4.10 contains fixes which address a few
long-standing bugs that DATERA's QA + automation teams have uncovered
while putting v4.1.y target code into production usage.

We've been running the top three in our nightly automated regression
runs for the last two months, and the COMPARE_AND_WRITE fix Mr. Gary Guo
has been manually verifying against a four node ESX cluster this past
week. 

Note all of them have CC' stable tags.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes:

  - Fix a bug with ESX EXTENDED_COPY + SAM_STAT_RESERVATION_CONFLICT 
    status, where target_core_xcopy.c logic was incorrectly returning
    SAM_STAT_CHECK_CONDITION for all non SAM_STAT_GOOD cases.
    (Nixon Vincent)
  - Fix a TMR LUN_RESET hung task bug while other in-flight TMRs are 
    being aborted, before the new one had been dispatched into tmr_wq.
    (Rob Millner)
  - Fix a long standing double free OOPs, where a dynamically generated
    'demo-mode' NodeACL has multiple sessions associated with it, and
    the /sys/kernel/config/target/$FABRIC/$WWN/ subsequently disables
    demo-mode, but never converts the dynamic ACL into a explicit ACL.
    (Rob Millner)
  - Fix a long standing reference leak with ESX VAAI COMPARE_AND_WRITE
    when the second phase WRITE COMMIT command fails, resulting in
    CHECK_CONDITION response never being sent and se_cmd->cmd_kref
    never reaching zero.  (Gary Guo)

Beyond these items on v4.1.y we've reproduced, fixed, and run through
our regression test suite using iscsi-target exports, there are two
additional outstanding list items:

  - Remove a >= v4.2 RCU conversion BUG_ON that would trigger when 
    dynamic node NodeACLs where being converted to explicit NodeACLs.  
    The patch drops the BUG_ON to follow how pre RCU conversion
    worked for this special case. (Benjamin Estrabaud)
  - Add ibmvscsis target_core_fabric_ops->max_data_sg_nent
    assignment to match what IBM's Virtual SCSI hypervisor is
    already enforcing at transport layer.  (Bryant Ly + Steven Royer).

Thank you,

--nab

Bryant G. Ly (1):
  ibmvscsis: Add SGL limit

Nicholas Bellinger (5):
  target: Don't BUG_ON during NodeACL dynamic -> explicit conversion
  target: Use correct SCSI status during EXTENDED_COPY exception
  target: Fix early transport_generic_handle_tmr abort scenario
  target: Fix multi-session dynamic se_node_acl double free OOPs
  target: Fix COMPARE_AND_WRITE ref leak for non GOOD status

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  1 +
 drivers/target/target_core_device.c      | 10 +++-
 drivers/target/target_core_sbc.c         |  8 ++-
 drivers/target/target_core_transport.c   | 86 +++++++++++++++++++++-----------
 drivers/target/target_core_xcopy.c       |  2 +-
 include/target/target_core_base.h        |  1 +
 6 files changed, 76 insertions(+), 32 deletions(-)
