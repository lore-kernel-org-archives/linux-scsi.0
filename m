From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] tcm_fc fixes
Date: Mon, 22 Aug 2016 10:54:05 +0200
Message-ID: <1471856051-87398-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51563 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754686AbcHVIyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Aug 2016 04:54:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>

Hi Nic,

here's a set of patches and fixes I've found during debugging
FCoE over virtio.
The first two fix a race condition I've encountered during starting
and stopping initiators; they are similar to your prior patches,
but I still think they should be applied to avoid any race issues.
The next three are just minor cleanups, but the last one is
_absolutely_ crucial.
With the current code tcm_fc will behave _very_ odd if you're
running in a virtualized environment, as the xid allocator in libfc
will be thouroughly thrashed by sending frames on _other_ cpus than
those the originator frame got received on.
This causes frames to be delayed (by up to several minutes)
leading to I/O errors on the initiator side.

As usual, comments and reviews are welcome.

Hannes Reinecke (6):
  target: fix hang in target_wait_for_sess_cmds()
  target: fix potential race window in target_sess_cmd_list_waiting()
  target/tcm_fc: print command pointer in debug message
  target/tcm_fc: return detailed error in ft_sess_create()
  target/tcm_fc: Update debugging statements to match libfc usage
  target/tcm_fc: use CPU affinity for responses

 drivers/target/target_core_transport.c | 28 ++++++++++++++---------
 drivers/target/tcm_fc/tfc_cmd.c        |  4 ++--
 drivers/target/tcm_fc/tfc_sess.c       | 42 +++++++++++++++++++++++-----------
 3 files changed, 48 insertions(+), 26 deletions(-)

-- 
1.8.5.6

