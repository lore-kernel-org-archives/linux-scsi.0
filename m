From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/9] virtio-scsi: Implement TMF timeout
Date: Mon, 10 Jun 2013 09:40:54 +0200
Message-ID: <1370850058-27613-6-git-send-email-hare@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab3FJHlD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 03:41:03 -0400
In-Reply-To: <1370850058-27613-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>

Any TMF might be take longer as expected, or not return at all.
So we need to use 'wait_for_completion_timeout' when sending
a TMF to protect against these cases.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/virtio_scsi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1efd219..abfc684 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -30,6 +30,7 @@
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
 #define VIRTIO_SCSI_EVENT_LEN 8
 #define VIRTIO_SCSI_VQ_BASE 2
+#define VIRTIO_SCSI_TMF_TIMEOUT 30
 
 /* Command queue element */
 struct virtio_scsi_cmd {
@@ -597,8 +598,10 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 			      GFP_NOIO) < 0)
 		goto out;
 
-	wait_for_completion(&comp);
-	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
+	if (wait_for_completion_timeout(&comp,
+					VIRTIO_SCSI_TMF_TIMEOUT * HZ) == 0)
+		ret = FAILED;
+	else if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
 	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
 		ret = SUCCESS;
 
-- 
1.7.12.4

