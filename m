From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH for 3.6 3/3] virtio-scsi: fix LUNs greater than 255
Date: Wed, 29 Aug 2012 12:39:08 +0200
Message-ID: <1346236748-12554-2-git-send-email-pbonzini@redhat.com>
References: <1346155154-12915-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46773 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2H2KjS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Aug 2012 06:39:18 -0400
In-Reply-To: <1346155154-12915-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, jbottomley@parallels.com, stable@vger.kernel.org

virtio-scsi needs to report LUNs greater than 256 using the "flat"
format.  Because the Linux SCSI layer just maps the SCSI LUN to
an u32, without any parsing, these end up in the range from 16640
to 32767.  Fix max_lun to account for the possibility that logical
unit numbers are encoded with the "flat" format.

Cc: Stable kernel <stable@vger.kernel.org> # 3.4: 4fe74b1: [SCSI] virtio-scsi: SCSI driver
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 7554d78..a7cf726 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -677,7 +677,11 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
 	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
 	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
 	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
-	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1;
+
+	/* LUNs > 256 are reported with format 1, so they go in the range
+	 * 16640-32767.
+	 */
+	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1 + 0x4000;
 	shost->max_id = num_targets;
 	shost->max_channel = 0;
 	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
-- 
1.7.1

