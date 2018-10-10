From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] target: Fix v4.19-rc active I/O shutdown deadlock
Date: Wed, 10 Oct 2018 03:23:08 +0000
Message-ID: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MNC, MKP & Co,

While testing v4.19-rc recently with simple backend I/O error injection
(via delayed BIO completion), I was able to trigger an end-less loop
deadlock with recent changes in commit 00d909a107:

  Author: Bart Van Assche <bart.vanassche@wdc.com>
  Date:   Fri Jun 22 14:52:53 2018 -0700

      scsi: target: Make the session shutdown code also wait for commands that are being aborted

It comes down to an incorrect assumption wrt signals during session
shutdown plus active I/O quiesce, which triggers an endless loop
immediately during session shutdown as se_session->sess_list_wq
waits for outstanding backend I/O to complete.

The easiest reproduction is with iser-target or simulation with plain
old iscsi-target/TCP ports.  However, any fabric driver who triggers
session shutdown from user-space processes with signals pending can
easily trigger it and bring down the machine.

The fix is simple, but requires a new wait_event_lock_irq_timeout()
macro to allow TASK_UNINTERRUPTIBLE to be set in order to work as
expected for all fabric driver session shutdown cases.

So short of reverting commit 00d909a107 now for v4.19, this is going
to be the best option.

Please review for v4.19, or v4.20-rc1 with stable CC's for both.

Thank you.

Nicholas Bellinger (2):
  sched/wait: Add wait_event_lock_irq_timeout for TASK_UNINTERRUPTIBLE
    usage
  target: Fix target_wait_for_sess_cmds breakage with active signals

 drivers/target/target_core_transport.c |  4 ++--
 include/linux/wait.h                   | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 7 deletions(-)

-- 
1.9.1
