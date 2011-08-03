From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.1-rc1
Date: Wed, 03 Aug 2011 10:23:47 -0700
Message-ID: <1312392227.28195.28.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50708 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1HCRdu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2011 13:33:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>

Hi Linus,

The following are target bugfixes for v3.1-rc1 that have been brewing in
for-next since the initial drivers/target/iscsi merge last week.

This includes an important fix in transport_generic_wait_for_tasks() to
address an OOPs with direct I/O submission exception handling that
iscsi-target was triggering during testing, a tcm_fc memory corruption
bugfix from Kiran Patil to address failures with DDP HW offload enabled
in the ft_recv_write_data() path, along with some other minor fixes from
various folks.

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.git for-next

This tree is also available from kernel.org mirrors at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

This series has been made against the same linux-2.6.git HEAD:

commit bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff
Merge: 8e20487 5a9a436
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jul 22 19:02:39 2011 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6

Thanks!

--nab

Dan Carpenter (2):
  iscsi-target: Fix NULL dereference on allocation failure
  iscsi-target: strlen() doesn't count the terminator

Kiran Patil (1):
  tcm_fc: Handle DDP/SW fc_frame_payload_get failures in
    ft_recv_write_data

Nicholas Bellinger (6):
  iscsi-target: Fix uninitialized usage of cmd->pad_bytes
  iscsi-target: Fix snprintf usage with MAX_PORTAL_LEN
  iscsi-target: Fix CONFIG_SMP=n and CONFIG_MODULES=n build failure
  MAINTAINERS: Add target-devel list for drivers/target/
  target: Fix WRITE_SAME_16 lba assignment breakage
  target: Fix bug for transport_generic_wait_for_tasks with direct
    operation

Randy Dunlap (1):
  target: iscsi_target depends on NET

 MAINTAINERS                                  |    1 +
 drivers/target/iscsi/Kconfig                 |    1 +
 drivers/target/iscsi/iscsi_target.c          |   15 ++-
 drivers/target/iscsi/iscsi_target_configfs.c |    2 +-
 drivers/target/iscsi/iscsi_target_nego.c     |    2 +-
 drivers/target/target_core_transport.c       |   33 +++++++-
 drivers/target/tcm_fc/tcm_fc.h               |    5 +
 drivers/target/tcm_fc/tfc_cmd.c              |    1 +
 drivers/target/tcm_fc/tfc_io.c               |  121 +++++++++++++++-----------
 9 files changed, 122 insertions(+), 59 deletions(-)


