Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408BA29992A;
	Thu,  9 Apr 2026 21:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775768771; cv=none; b=iXJW30kti5tqWm7RIr/42+C1XX7YYXI9T7fz6toME0Q9164WLwYkSKoBOd31OXFbVTASZtIo9h4SyJ8Pq8PrBjM0bpaKz7J/SfmLFeI1RG4j3r7owClN5qE74JoSSryQ4XtmziXfMPsFtNQfN3+QpcM496MvIVQ2MlRWy2dQ7yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775768771; c=relaxed/simple;
	bh=rtFbVp8/UJ4Lu7BUwpQ9HQdvekknIbl/+cNf7dMuamo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRgIp2AvulpxWOGJTXNvqBPwLcAZ1jkfamE3W//6o5RdlZbocTT9lSeK9t55ofvDUx9fUFYAXZTWNWLGsCRRe7qvu2eM2tYqjra2j/z9cGYgHR6g29LnFx28cNQc6PdUHyUIhoDPeQ6t6vAJ1c3xOpx/Kth86e/f/0u4kmX/m1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=pWkacvkm; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="pWkacvkm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1775768768;
	bh=rtFbVp8/UJ4Lu7BUwpQ9HQdvekknIbl/+cNf7dMuamo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWkacvkm9gHK+bBO0ON7i9XVI6LUSeIwdC5mfyeSw5a0S/fGF1zgLySXKquO4FGl9
	 8QvLtL+XOUtBhBdA2jZoDaA87kXI0lwENzYXtG9aNhltwyWkUKIZKWvNKqXUscurh6
	 qZMOdvEo39HKfb0glitRBk/CL+pVlArcMxIz+P+0=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id B5EE7BE5E2;
	Thu,  9 Apr 2026 21:06:08 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 55FCB5FC51;
	Thu,  9 Apr 2026 22:06:08 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: dlemoal@kernel.org,
	cassel@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH 2/3] ata: libata-scsi: enable multi-LUN support for ATAPI devices
Date: Thu,  9 Apr 2026 22:05:58 +0100
Message-ID: <20260409210559.155864-3-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409210559.155864-1-philpem@philpem.me.uk>
References: <20260409210559.155864-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libata has never supported multi-LUN ATAPI devices like the Panasonic
and NEC PD/CD combo drives due to three limitations:

  - shost->max_lun is hardcoded to 1 in ata_scsi_add_hosts(), which
    stops the SCSI layer from probing any LUN other than 0.

  - __ata_scsi_find_dev() rejects all commands where scsidev->lun != 0,
    returning NULL which causes DID_BAD_TARGET.

  - The SCSI-2 CDB LUN field (byte 1, bits 7:5) is never set. Older
    multi-LUN ATAPI devices rely on this field to route commands to the
    correct LUN, as transport-layer LUN addressing (per SPC-3+) is not
    available over the ATA PACKET interface.

To fix all three, this change:

  - Raises max_lun from 1 to 8 (matching the SCSI host default).
    Sequential LUN scanning stops at the first non-responding LUN, so
    single-LUN devices are unaffected.

  - In __ata_scsi_find_dev(), allow non-zero LUNs for ATAPI devices by
    routing them to the same ata_device as LUN 0.

  - In atapi_xlat(), encode the target LUN into CDB byte 1 bits 7:5
    before passing the command packet to the device.

These changes are prerequisites for probing additional LUNs during
host scanning, which is done in a subsequent patch.

Additionally, fix two related issues exposed by multi-LUN scanning:

  - ata_scsi_dev_config() previously assigned dev->sdev = sdev for every
    LUN configured.  With multiple LUNs sharing one ata_device, this
    caused dev->sdev to be overwritten by each non-LUN-0 sdev.  Restrict
    the assignment to LUN 0 so that dev->sdev always tracks the
    canonical scsi_device for the underlying ATA device.

  - ata_scsi_sdev_destroy() detached the entire ATA device whenever
    dev->sdev was non-NULL.  When a spurious multi-LUN scan result was
    removed, this incorrectly tore down the underlying device.  Detach
    only when the canonical (LUN 0) sdev is being destroyed.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3b65df914ebb..dc6829e60fb3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -25,6 +25,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_transport.h>
 #include <linux/libata.h>
 #include <linux/hdreg.h>
@@ -1131,7 +1132,14 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 	if (dev->flags & ATA_DFLAG_TRUSTED)
 		sdev->security_supported = 1;
 
-	dev->sdev = sdev;
+	/*
+	 * Only LUN 0 is treated as the canonical scsi_device for the ATA
+	 * device.  Multi-LUN ATAPI devices share a single ata_device, so
+	 * dev->sdev must continue to track LUN 0 even when additional LUNs
+	 * are added or removed.
+	 */
+	if (sdev->lun == 0)
+		dev->sdev = sdev;
 	return 0;
 }
 
@@ -1220,7 +1228,12 @@ void ata_scsi_sdev_destroy(struct scsi_device *sdev)
 
 	spin_lock_irqsave(ap->lock, flags);
 	dev = __ata_scsi_find_dev(ap, sdev);
-	if (dev && dev->sdev) {
+	/*
+	 * Only detach when the canonical (LUN 0) scsi_device is going away.
+	 * Removing a non-LUN-0 sdev (e.g. a spurious multi-LUN scan result)
+	 * must not tear down the underlying ATA device.
+	 */
+	if (dev && dev->sdev == sdev) {
 		/* SCSI device already in CANCEL state, no need to offline it */
 		dev->sdev = NULL;
 		dev->flags |= ATA_DFLAG_DETACH;
@@ -2950,6 +2963,15 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
 
+	/*
+	 * Encode LUN in CDB byte 1 bits 7:5 for multi-LUN ATAPI devices
+	 * that use the SCSI-2 CDB LUN convention (e.g. Panasonic PD/CD
+	 * combo drives).
+	 */
+	if (scmd->device->lun)
+		qc->cdb[1] = (qc->cdb[1] & 0x1f) |
+			      ((scmd->device->lun & 0x7) << 5);
+
 	qc->complete_fn = atapi_qc_complete;
 
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
@@ -3062,9 +3084,17 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 
 	/* skip commands not addressed to targets we simulate */
 	if (!sata_pmp_attached(ap)) {
-		if (unlikely(scsidev->channel || scsidev->lun))
+		if (unlikely(scsidev->channel))
 			return NULL;
 		devno = scsidev->id;
+		/* Allow non-zero LUNs for ATAPI devices (e.g. PD/CD combos) */
+		if (unlikely(scsidev->lun)) {
+			struct ata_device *dev = ata_find_dev(ap, devno);
+
+			if (!dev || dev->class != ATA_DEV_ATAPI)
+				return NULL;
+			return dev;
+		}
 	} else {
 		if (unlikely(scsidev->id || scsidev->lun))
 			return NULL;
@@ -4620,7 +4650,7 @@ int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *s
 		shost->transportt = ata_scsi_transport_template;
 		shost->unique_id = ap->print_id;
 		shost->max_id = 16;
-		shost->max_lun = 1;
+		shost->max_lun = 8;
 		shost->max_channel = 1;
 		shost->max_cmd_len = 32;
 
-- 
2.39.5

