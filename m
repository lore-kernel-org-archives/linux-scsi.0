From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.12-rc4
Date: Wed, 31 May 2017 21:17:34 -0700
Message-ID: <1496290654.27407.173.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

Here are the target-pending fixes for v4.12-rc4.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes:

  - ibmviscsis ABORT_TASK handling fixes that missed the v4.12 merge 
    window. (Bryant Ly and Michael Cyr)
  - Re-add a target-core check enforcing WRITE overflow reject that was 
    relaxed in v4.3, to avoid unsupported iscsi-target immediate data 
    overflow. (nab)
  - Fix a target-core-user OOPs during device removal. (MNC + Bryant Ly)
  - Fix a long standing iscsi-target potential issue where kthread exit 
    did not wait for kthread_should_stop(). (Jiang Yi)
  - Fix a iscsi-target v3.12.y regression OOPs involving initial login 
    PDU processing during asynchronous TCP connection close. (MNC + nab)

This is a little larger than usual for an -rc4, primarily due to the
iscsi-target v3.12.y regression OOPs bug-fix.

However, it's an important patch as MNC + Hannes where both able to
trigger it using a reduced iscsi initiator login timeout combined with a
backend taking a long time to complete I/Os during iscsi login driven
session reinstatement.

Note the trailing two patches have a recent CommitDate, as the second to
last was updated today to include MNC's tested-by and reviewed-by tags.
The patches themselves has not changed though, and both have been run
through manual and automated regression testing from multiple parties
over the last 7 days.

Thank you,

--nab

Bryant G. Ly (2):
  ibmvscsis: Clear left-over abort_cmd pointers
  ibmvscsis: Fix the incorrect req_lim_delta

Jiang Yi (1):
  iscsi-target: Always wait for kthread_should_stop() before kthread
    exit

Mike Christie (1):
  tcmu: fix crash during device removal

Nicholas Bellinger (2):
  target: Re-add check to reject control WRITEs with overflow data
  iscsi-target: Fix initial login PDU asynchronous socket close OOPs

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c  |  27 ++++-
 drivers/target/iscsi/iscsi_target.c       |  30 ++++-
 drivers/target/iscsi/iscsi_target_erl0.c  |   6 +-
 drivers/target/iscsi/iscsi_target_erl0.h  |   2 +-
 drivers/target/iscsi/iscsi_target_login.c |   4 +
 drivers/target/iscsi/iscsi_target_nego.c  | 194 ++++++++++++++++++++----------
 drivers/target/target_core_transport.c    |  23 +++-
 drivers/target/target_core_user.c         |  46 +++++--
 include/target/iscsi/iscsi_target_core.h  |   1 +
 9 files changed, 241 insertions(+), 92 deletions(-)
