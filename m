From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL -v3] target fixes for v3.12-rc0 (was v3.11)
Date: Mon, 02 Sep 2013 23:15:08 -0700
Message-ID: <1378188908.32763.404.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, nab@daterainc.com, Ted Ts'o <tytso@thunk.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Now with DKIM + SPF in place on linux-iscsi.org (thanks for the help Ted
& Co), here is another attempt at the target fixes PULL request for
v3.11 that was missed.

Given that the last PULL emails hit your spam folder, if/when you get
this please give me a quick response to confirm.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The first patch is to address a long standing issue where INQUIRY vendor
+ model response data was not correctly padded with ASCII spaces,
causing MSFT and Falconstor multipath stacks to not function with our
LUNs.

The second -> forth patches are additional iscsi-target regression fixes
for the post >= v3.10 iser-target changes.  The second and third are
failure cases that have appeared during further testing, and the forth
is only reproducible with malformed NOP packets.

The fifth patch is a v3.11 specific regression caused by a recent
optimization that showed up during WRITE I/O failure testing.

I'll be sending Patch #1 and Patch #5 to Greg-KH separately for stable.

Thank you,

--nab

Nicholas Bellinger (5):
  target: Fix trailing ASCII space usage in INQUIRY vendor+model
  iscsi-target: Fix ImmediateData=Yes failure regression in >= v3.10
  iscsi-target: Fix iscsit_transport reference leak during NP thread
    reset
  iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject
  target: Fix se_cmd->state_list leak regression during WRITE failure

 drivers/target/iscsi/iscsi_target.c       |   17 ++++++++++-------
 drivers/target/iscsi/iscsi_target_login.c |    9 ++++-----
 drivers/target/target_core_spc.c          |    9 ++++++---
 drivers/target/target_core_transport.c    |   11 +++++++++++
 4 files changed, 31 insertions(+), 15 deletions(-)
