From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] virtio_scsi: check on resp->sense_len instead of 'sense_buffer'
Date: Fri, 18 Jul 2014 22:57:17 +0800
Message-ID: <1405695438-18485-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61453 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965730AbaGRO5k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 10:57:40 -0400
Received: by mail-pa0-f46.google.com with SMTP id lj1so5541305pab.5
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2014 07:57:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>

The 'sense_buffer' of 'struct scsi_cmnd' is always true, but
resp->sense_len is only set if there is sense available.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/scsi/virtio_scsi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index eee1bc0..4d2d3b2 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -194,11 +194,10 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	}
 
 	WARN_ON(resp->sense_len > VIRTIO_SCSI_SENSE_SIZE);
-	if (sc->sense_buffer) {
+	if (resp->sense_len) {
 		memcpy(sc->sense_buffer, resp->sense,
 		       min_t(u32, resp->sense_len, VIRTIO_SCSI_SENSE_SIZE));
-		if (resp->sense_len)
-			set_driver_byte(sc, DRIVER_SENSE);
+		set_driver_byte(sc, DRIVER_SENSE);
 	}
 
 	sc->scsi_done(sc);
-- 
1.7.9.5

