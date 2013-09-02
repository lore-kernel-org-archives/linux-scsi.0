From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/9] mptsas: Enable new EH timeout handler
Date: Mon,  2 Sep 2013 09:13:02 +0200
Message-ID: <1378105985-79686-7-git-send-email-hare@suse.de>
References: <1378105985-79686-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104Ab3IBHNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 03:13:14 -0400
In-Reply-To: <1378105985-79686-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/message/fusion/mptsas.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index dd239bd..d0aed77 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1986,7 +1986,8 @@ static struct scsi_host_template mptsas_driver_template = {
 	.slave_configure		= mptsas_slave_configure,
 	.target_destroy			= mptsas_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
-	.change_queue_depth 		= mptscsih_change_queue_depth,
+	.change_queue_depth		= mptscsih_change_queue_depth,
+	.eh_timed_out			= scsi_abort_command,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
-- 
1.7.12.4

