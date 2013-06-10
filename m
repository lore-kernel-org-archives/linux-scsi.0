From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/9] virtio_scsi: Enable new EH timeout handler
Date: Mon, 10 Jun 2013 09:40:53 +0200
Message-ID: <1370850058-27613-5-git-send-email-hare@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab3FJHlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 03:41:02 -0400
In-Reply-To: <1370850058-27613-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/virtio_scsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 2168258..1efd219 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -654,6 +654,11 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 	return virtscsi_tmf(vscsi, cmd);
 }
 
+static enum blk_eh_timer_return virtscsi_timedout(struct scsi_cmnd *scmd)
+{
+	return scsi_abort_command(scmd);
+}
+
 static int virtscsi_target_alloc(struct scsi_target *starget)
 {
 	struct virtio_scsi_target_state *tgt =
@@ -683,6 +688,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.queuecommand = virtscsi_queuecommand_single,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_timedout,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
@@ -699,6 +705,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.queuecommand = virtscsi_queuecommand_multi,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_timedout,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
-- 
1.7.12.4

