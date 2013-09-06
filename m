From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [RESEND PATCH v5 0/2] block,scsi: fixup blk_get_request dead queue
 scenarios
Date: Fri, 6 Sep 2013 17:44:05 -0400
Message-ID: <20130906174405.7ee1edb5@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub4.stratus.com ([134.111.1.17]:44463 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3IFVoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 17:44:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>

Hi Jens, James,

This is a resend of a patchset to 1) protect blk_get_request __GFP_WAIT
callers from dead queues and then 2) convert blk_get_request to return
ERR_PTR to distinguish between dead queues and low-memory scenarios. [1]
A similar bug report appeared on LKML in June [2], (although I don't see
any follow up).

Reproducing the original crash is hit or miss given kernel versions and
timing, however the same conditions appear present in latest linus,
scsi-next, etc. branches.

Previous patchset versions were ack'd by Boaz Harrosh
<bharrosh@panasas.com> for OSD changes and Jiri Kosina <jkosina@suse.cz>
for the pktdvd.c changes.

Can this patch go forward for the 3.12 merge, or at least in the hopper
for the next release?

Regards,

[1] http://thread.gmane.org/gmane.linux.scsi/80934
[2] http://thread.gmane.org/gmane.linux.kernel/1502882

Joe Lawrence (2):
  block,scsi: verify return pointer from blk_get_request
  block,scsi: convert and handle ERR_PTR from blk_get_request

 block/blk-core.c                            | 34 ++++++++++++++---------------
 block/bsg.c                                 |  8 +++----
 block/scsi_ioctl.c                          | 13 ++++++++---
 drivers/block/paride/pd.c                   |  2 ++
 drivers/block/pktcdvd.c                     |  2 ++
 drivers/block/sx8.c                         |  2 +-
 drivers/cdrom/cdrom.c                       |  4 ++--
 drivers/ide/ide-park.c                      |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  2 +-
 drivers/scsi/osd/osd_initiator.c            |  4 ++--
 drivers/scsi/osst.c                         |  2 +-
 drivers/scsi/scsi_error.c                   |  2 ++
 drivers/scsi/scsi_lib.c                     |  2 +-
 drivers/scsi/scsi_tgt_lib.c                 |  2 +-
 drivers/scsi/sg.c                           |  4 ++--
 drivers/scsi/st.c                           |  2 +-
 drivers/target/target_core_pscsi.c          |  4 ++--
 20 files changed, 56 insertions(+), 43 deletions(-)

-- 
1.8.3.1

