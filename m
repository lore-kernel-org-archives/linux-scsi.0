From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.5
Date: Fri, 11 Mar 2016 19:51:51 -0800
Message-ID: <1457754711.4062.95.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here is the outstanding target-core bug-fix for v4.5 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This patch addresses a recent Task Management (TMR) regression related
to larger set of multi-port LUN_RESET bug-fixes in v4.5-rc5.

It drops a left-over target_put_sess_cmd() of se_cmd->cmd_kref within
ABORT_TASK failure path, once a se_cmd descriptor has already completed
posting response to fabric driver logic, and must be skipped during
normal ABORT_TASK se_cmd->tag lookup.

Thank you,

--nab

Nicholas Bellinger (1):
  target: Drop incorrect ABORT_TASK put for completed commands

 drivers/target/target_core_tmr.c | 1 -
 1 file changed, 1 deletion(-)
