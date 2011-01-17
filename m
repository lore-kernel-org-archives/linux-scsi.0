From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] target: Fix demo-mode TPG shutdown breakage
Date: Sun, 16 Jan 2011 21:23:38 -0800
Message-ID: <1295241821-2006-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:25545 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750744Ab1AQFXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jan 2011 00:23:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This series contains fixes for two bugs recently uncovered while testing
dynamically generated (demo-mode) NodeACLs + MappedLUNs with active SPC-3
persistent registrations+reservations.  Both issues are shutdown related,
and one is specific to TPG shutdown with tfo->tpg_check_demo_mode_cache()=1
mode enabled.

Also note that while running TCM persistent reservation logic with TPG demo-mode
operation is possible, using explict NodeACLs + MappedLUNs via configfs objects
is still strongly recommended for proper production usage with SPC-3 PR capable
client environments.

These two patches have been pushed into lio-core-2.6.git/linus-38-rc1 and
queued up into scsi-post-merge-2.6.git/for-jejb.

Thanks,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  target: Fix demo-mode MappedLUN shutdown UA/PR breakage
  target: Release left-over demo-mode NodeACLs w/
    tfo->tpg_check_demo_mode_cache()=1

 drivers/target/target_core_device.c |   15 ++++++++-------
 drivers/target/target_core_tpg.c    |   22 ++++++++++++++++++++++
 2 files changed, 30 insertions(+), 7 deletions(-)

