From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v4 08/19] fcoe: Set SHT->unlocked_qcmd=1 for libfc fc_queuecommand()
Date: Mon, 27 Sep 2010 19:06:27 -0700
Message-ID: <1285639587-7365-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:47311 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933326Ab0I1CGg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 22:06:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates fcoe to set struct scsi_host_template->unlocked_qcmd=1
because it is using generic libfc fc_queuecommand() code which now can be
run without struct Scsi_Host->host_lock held following the original
host_lock unlock -> do_work() -> lock optimization in fc_queuecommand().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/fcoe/fcoe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 844d618..23b01d5 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -250,6 +250,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.change_queue_depth = fc_change_queue_depth,
 	.change_queue_type = fc_change_queue_type,
 	.this_id = -1,
+	.unlocked_qcmd = 1,
 	.cmd_per_lun = 3,
 	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
 	.use_clustering = ENABLE_CLUSTERING,
-- 
1.7.3

