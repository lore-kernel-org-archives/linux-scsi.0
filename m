From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.9-rc2
Date: Sat, 22 Oct 2016 19:31:25 -0700
Message-ID: <1477189885.18052.25.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35421 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756237AbcJWCbg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2016 22:31:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, vst@datera.io, ddi@datera.io, nixon.vincent@calsoftinc.com

Hello Linus,

Here are the outstanding target-pending fixes for v4.9-rc2.  Please go
ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes:

  - Fix v4.1.y+ reference leak regression with concurrent TMR ABORT_TASK +
    session shutdown. (Vaibhav Tandon)
  - Enable tcm_fc w/ SCF_USE_CPUID to avoid host exchange timeouts (Hannes)
  - target/user error sense handling fixes. (Andy + MNC + HCH)
  - Fix iscsi-target NOP_OUT error path iscsi_cmd descriptor leak (Varun)
  - Two EXTENDED_COPY SCSI status fixes for ESX VAAI (Dinesh Israni + Nixon Vincent)
  - Revert a v4.8 residual overflow change, that breaks sg_inq with
    small allocation lengths.

There are a number of folks stress testing the v4.1.y regression fix in
their environments, and more folks doing iser-target I/O stress testing
atop recent v4.x.y code.

There is also one v4.2.y+ RCU conversion regression related to explicit
NodeACL configfs changes, that is still being tracked down.

Thank you,

--nab

Andy Grover (3):
  target/user: Use sense_reason_t in tcmu_queue_cmd_ring
  target/user: Return an error if cmd data size is too large
  target/user: Fix comments to not refer to data ring

Colin Ian King (1):
  iscsi-target: fix spelling mistake "Unsolicitied" -> "Unsolicited"

Dinesh Israni (1):
  target: Don't override EXTENDED_COPY xcopy_pt_cmd SCSI status code

Hannes Reinecke (5):
  target: fix potential race window in target_sess_cmd_list_waiting()
  target/tcm_fc: print command pointer in debug message
  target/tcm_fc: return detailed error in ft_sess_create()
  target/tcm_fc: Update debugging statements to match libfc usage
  target/tcm_fc: use CPU affinity for responses

Nicholas Bellinger (3):
  target: Re-add missing SCF_ACK_KREF assignment in v4.1.y
  target: Make EXTENDED_COPY 0xe4 failure return COPY TARGET DEVICE NOT
    REACHABLE
  Revert "target: Fix residual overflow handling in
    target_complete_cmd_with_length"

Varun Prakash (1):
  iscsi-target: fix iscsi cmd leak

 drivers/target/iscsi/iscsi_target.c       |  6 +++-
 drivers/target/iscsi/iscsi_target_login.c |  4 +--
 drivers/target/target_core_transport.c    | 39 ++++++++++++------------
 drivers/target/target_core_user.c         | 50 +++++++++++++------------------
 drivers/target/target_core_xcopy.c        | 34 ++++++++++++++++-----
 drivers/target/tcm_fc/tfc_cmd.c           |  4 +--
 drivers/target/tcm_fc/tfc_sess.c          | 42 ++++++++++++++++++--------
 include/target/target_core_base.h         |  1 +
 8 files changed, 105 insertions(+), 75 deletions(-)

