From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.12-rc7
Date: Sat, 24 Jun 2017 21:38:07 -0700
Message-ID: <1498365487.28997.90.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37699 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbdFYEiJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jun 2017 00:38:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Linus,

Here are the target-pending fixes for v4.12-rc7 that have been queued up
for the last 2 weeks.  Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes:

- Fix a TMR related kref underflow detected by the recent refcount_t 
  conversion in upstream.
- Fix a iscsi-target corner case during explicit connection logout 
  timeout failure.
- Address last fallout in iscsi-target immediate data handling from
  v4.4 target-core now allowing control CDB payload underflow.

Thank you,

--nab

Nicholas Bellinger (3):
  target: Fix kref->refcount underflow in transport_cmd_finish_abort
  iscsi-target: Fix delayed logout processing greater than
    SECONDS_FOR_LOGOUT_COMP
  iscsi-target: Reject immediate data underflow larger than SCSI
    transfer length

 drivers/target/iscsi/iscsi_target.c    | 22 ++++++++++++++++++++--
 drivers/target/target_core_internal.h  |  2 +-
 drivers/target/target_core_tmr.c       | 16 ++++++++--------
 drivers/target/target_core_transport.c |  9 ++++++---
 4 files changed, 35 insertions(+), 14 deletions(-)
