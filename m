From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5/6] virtio-scsi: fix various bad behavior on aborted requests
Date: Tue,  3 Jun 2014 21:33:17 +0200
Message-ID: <1401823998-29167-6-git-send-email-pbonzini@redhat.com>
References: <1401823998-29167-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53778 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933942AbaFCTdd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2014 15:33:33 -0400
In-Reply-To: <1401823998-29167-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com, stable@vger.kernel.org, Ulrich Obergfell <uobergfe@redhat.com>

Even though the virtio-scsi spec guarantees that all requests related
to the TMF will have been completed by the time the TMF itself completes,
the request queue's callback might not have run yet.  This causes requests
to be completed more than once, and as a result triggers a variety of
BUGs or oopses.

Cc: stable@vger.kernel.org
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index d66c4ee2c774..fda9fb358888 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -235,6 +235,16 @@ static void virtscsi_req_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
 };
 
+static void virtscsi_poll_requests(struct virtio_scsi *vscsi)
+{
+	int i, num_vqs;
+
+	num_vqs = vscsi->num_queues;
+	for (i = 0; i < num_vqs; i++)
+		virtscsi_vq_done(vscsi, &vscsi->req_vqs[i],
+				 virtscsi_complete_cmd);
+}
+
 static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
@@ -579,6 +589,18 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
 		ret = SUCCESS;
 
+	/*
+	 * The spec guarantees that all requests related to the TMF have
+	 * been completed, but the callback might not have run yet if
+	 * we're using independent interrupts (e.g. MSI).  Poll the
+	 * virtqueues once.
+	 *
+	 * In the abort case, sc->scsi_done will do nothing, because
+	 * the block layer must have detected a timeout and as a result
+	 * REQ_ATOM_COMPLETE has been set.
+	 */
+	virtscsi_poll_requests(vscsi);
+
 out:
 	mempool_free(cmd, virtscsi_cmd_pool);
 	return ret;
-- 
1.8.3.1


