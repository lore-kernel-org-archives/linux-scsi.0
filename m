From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/9] virtio_scsi: Enable new EH timeout handler
Date: Mon,  2 Sep 2013 09:13:00 +0200
Message-ID: <1378105985-79686-5-git-send-email-hare@suse.de>
References: <1378105985-79686-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758098Ab3IBHNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 03:13:14 -0400
In-Reply-To: <1378105985-79686-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/virtio_scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 74b88ef..5fca1ca 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -683,6 +683,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.queuecommand = virtscsi_queuecommand_single,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = scsi_abort_command,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
@@ -699,6 +700,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.queuecommand = virtscsi_queuecommand_multi,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = scsi_abort_command,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
-- 
1.7.12.4

