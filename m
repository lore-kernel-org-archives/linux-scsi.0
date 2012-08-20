From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH] [SCSI] virtio-scsi: Initialize scatterlist structure.
Date: Mon, 20 Aug 2012 15:04:50 +0100
Message-ID: <1345471490-17289-1-git-send-email-rjones@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab2HTOFA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Aug 2012 10:05:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, linux-scsi@vger.kernel.org

From: "Richard W.M. Jones" <rjones@redhat.com>

The sg struct is used without being initialized.

https://bugzilla.redhat.com/show_bug.cgi?id=847548

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c7030fb..8a66f83 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -219,7 +219,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 	struct scatterlist sg;
 	unsigned long flags;
 
-	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
+	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
 
-- 
1.7.10.4

