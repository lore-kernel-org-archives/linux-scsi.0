From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target: Updates for v3.0-rc5
Date: Thu, 23 Jun 2011 17:42:59 -0700
Message-ID: <1308876179-3974-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm22.access.bullet.mail.mud.yahoo.com ([66.94.237.223]:34838
	"HELO nm22.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754264Ab1FXAg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2011 20:36:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Kiran Patil <kiran.patil@intel.com>, Roland Dreier <roland@purestorage.com>, Dan Carpenter <error27@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Linus,

Here are the target updates for v3.0-rc5 that have been marinating in
lio-core-2.6.git for a few weeks now, and are ready for you to pull.

It includes a OOPs bugfix for task management exception handling in target
core, a bugfix for incorrect TMR LUN lookup in tcm_fc fixed by Kiran,
a series from Dan to address issues with ERR_PTR dereferencing + strlen usage +
possible deadlock fix, and Roland's spin_lock_irq() -> irqsave() change
required for certain cases in HW target mode operation in order prevent from
re-enabling interrupts that have already been disabled with a seperate
irqsave() call.

This series has been made against the following HEAD:

commit 56299378726d5f2ba8d3c8cbbd13cb280ba45e4f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jun 20 20:25:46 2011 -0700

    Linux 3.0-rc4

Please pull go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-linus

Thanks!

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Dan Carpenter (4):
  target: Fix ERR_PTR dereferencing bugs
  target: Drop bogus ERR_PTR usage in target_fabric_configfs_init
  target: Fix incorrect strlen() NULL terminator checks
  tcm_fc: Fix possible lock to unlock type deadlock

Kiran Patil (1):
  tcm_fc: Fix ft_send_tm LUN lookup OOPs

Nicholas Bellinger (2):
  target: Fix transport_get_lun_for_tmr failure cases
  tcm_fc: Fix conversion spec warning

Roland Dreier (1):
  target: Convert transport_deregister_session_configfs nacl_sess_lock
    to save irq state

 drivers/target/loopback/tcm_loop.c     |   13 ++++--
 drivers/target/target_core_configfs.c  |   24 ++++++------
 drivers/target/target_core_device.c    |    5 +-
 drivers/target/target_core_pr.c        |    6 +-
 drivers/target/target_core_tmr.c       |    8 +++-
 drivers/target/target_core_transport.c |    6 +-
 drivers/target/tcm_fc/tcm_fc.h         |    2 +-
 drivers/target/tcm_fc/tfc_cmd.c        |   64 ++++++++++++++++---------------
 drivers/target/tcm_fc/tfc_io.c         |    2 +-
 drivers/target/tcm_fc/tfc_sess.c       |    4 +-
 10 files changed, 73 insertions(+), 61 deletions(-)

-- 
1.7.5.4

