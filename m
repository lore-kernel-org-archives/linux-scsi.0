From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 03/07] Don't online offlined devices in scsi_target_quiesce()
Date: Wed, 26 Nov 2008 19:25:13 +0100
Message-ID: <200811261925.14088.bs@q-leap.de>
References: <200811261840.45360.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:57781 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYKZSZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 13:25:19 -0500
In-Reply-To: <200811261840.45360.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>

Don't online offlined devices in scsi_target_quiesce(), it often onlines
devices which just have been take offline due to an error on the host.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

---
 drivers/scsi/scsi_lib.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -2487,7 +2487,15 @@ device_quiesce_fn(struct scsi_device *sd
 void
 scsi_target_quiesce(struct scsi_target *starget)
 {
-	starget_for_each_device(starget, NULL, device_quiesce_fn);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost) {
+		if ((sdev->channel == starget->channel) &&
+		    (sdev->id == starget->id) &&
+		    (sdev->sdev_state != SDEV_OFFLINE))
+			device_quiesce_fn(sdev, NULL);
+	}
 }
 EXPORT_SYMBOL(scsi_target_quiesce);
