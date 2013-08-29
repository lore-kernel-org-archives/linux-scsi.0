From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/9] virtio_scsi: Enable new EH timeout handler
Date: Thu, 29 Aug 2013 15:32:15 +0200
Message-ID: <1377783140-57191-5-git-send-email-hare@suse.de>
References: <1377783140-57191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab3H2NcY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 09:32:24 -0400
In-Reply-To: <1377783140-57191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/virtio_scsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 74b88ef..d34b195 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -630,6 +630,12 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
 	return virtscsi_tmf(vscsi, cmd);
 }
 
+static enum blk_eh_timer_return virtscsi_timedout(struct scsi_cmnd *scmd)
+{
+	scsi_abort_command(scmd);
+	return BLK_EH_SCHEDULED;
+}
+
 static int virtscsi_abort(struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
@@ -683,6 +689,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.queuecommand = virtscsi_queuecommand_single,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_timedout,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
@@ -699,6 +706,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.queuecommand = virtscsi_queuecommand_multi,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
+	.eh_timed_out = virtscsi_timedout,
 
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
-- 
1.7.12.4

