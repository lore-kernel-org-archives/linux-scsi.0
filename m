Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC3B37C108;
	Sun, 26 Apr 2026 19:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777230584; cv=none; b=jzXwBuUA54OrG6m3B+2eZ/xZNxtSLgXr8WBI/1p8VHq7/YvRCiR16aM2TfGnfaioJg306HV3qEIStiI7JxNdoAh9aCobQCRNzaV2qp/TmRGG4PpXwsjJK5krT0VV8SRsbu72R2bAGH7TI/JyZlUhFEQrB7H8LUrR5NCKuCMTehI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777230584; c=relaxed/simple;
	bh=FbOQbJbQwX4HDdjMy+Pjy5LUOfdit7DkdhbmA+zqbrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrPirjxbwf9YwJRuJoU1fOMRAqhmfZq11j/5TTGQUjko2b9NCMJtkhGKotYC7kFSTXCNT923DRnQpJUzm7vsws09oQ9EoXmZN4tXRGWv/yJIo7dBNdK6G5PDEvayuZ/FBzHr+bzLYiPS5MIX/U183XpSC70VvP6kASbRLW7H5uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=L8ZQ32ym; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="L8ZQ32ym"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1777230569;
	bh=FbOQbJbQwX4HDdjMy+Pjy5LUOfdit7DkdhbmA+zqbrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8ZQ32ymQlEQnhuznZm29yzzZW4HpgcblUouHGtSHEc1+TXUUA5AosQVmOYOIvrX/
	 qsRFVRpQYnHZ9K7Q7eHuKLQ6BLLRWJEIzZ6HuNcju5AZL8lC6sHO6K+csQ4yksSTtC
	 EGrhS8r8FwVf7/OblpJ6friOPq4A97OL7HTpbgUA=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 97685BEFF0;
	Sun, 26 Apr 2026 19:09:29 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 3D11B5FC57;
	Sun, 26 Apr 2026 20:09:29 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v3 5/7] ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
Date: Sun, 26 Apr 2026 20:09:18 +0100
Message-ID: <20260426190920.2051289-6-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260426190920.2051289-1-philpem@philpem.me.uk>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After LUN 0 is added for an ATAPI device, check its BLIST_FORCELUN
flag.  If set, call scsi_scan_target() with SCAN_WILD_CARD to trigger
the SCSI layer's built-in sequential LUN scan for that target only.
This probes LUNs 1..shost->max_lun, driven by the atapi_max_lun module
parameter from patch 1/6.  Devices without BLIST_FORCELUN (the vast
majority of ATAPI devices) are left with only LUN 0 -- no sequential
scan is triggered, so single-LUN devices like the iHAS124 DVD writer
are completely unaffected.

Non-responding LUNs (PQ=0/PDT=0x1f) are silently skipped by
scsi_probe_and_add_lun() when BLIST_NO_LUN_1F is set on the device
via scsi_devinfo (see patch 4/6).

Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 48c7d323d6f9..fc719e3d7d60 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -26,6 +26,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
+#include <scsi/scsi_devinfo.h>
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
@@ -4700,7 +4701,6 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
  repeat:
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
-			struct scsi_device *sdev;
 			int channel = 0, id = 0;
 
 			if (dev->sdev[0])
@@ -4711,15 +4711,34 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			else
 				channel = link->pmp;
 
-			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
-						 NULL);
-			if (!IS_ERR(sdev)) {
-				dev->sdev[0] = sdev;
-				ata_scsi_assign_ofnode(dev, ap);
-				scsi_device_put(sdev);
-			} else {
-				dev->sdev[0] = NULL;
+			{
+				struct scsi_device *sdev;
+
+				sdev = __scsi_add_device(ap->scsi_host,
+							 channel, id, 0, NULL);
+				if (!IS_ERR(sdev)) {
+					/*
+					 * For multi-LUN ATAPI (BLIST_FORCELUN),
+					 * trigger the sequential LUN scan.
+					 * pdt_1f_for_no_lun (set during LUN 0
+					 * configure) ensures non-responding LUNs
+					 * are silently skipped.  dev->sdev[] is
+					 * populated by ata_scsi_dev_config()
+					 * during the scan callbacks.
+					 */
+					if (dev->class == ATA_DEV_ATAPI &&
+					    sdev->sdev_bflags & BLIST_FORCELUN)
+						scsi_scan_target(
+							&ap->scsi_host->shost_gendev,
+							channel, id,
+							SCAN_WILD_CARD,
+							SCSI_SCAN_RESCAN);
+					scsi_device_put(sdev);
+				}
 			}
+
+			if (dev->sdev[0])
+				ata_scsi_assign_ofnode(dev, ap);
 		}
 	}
 
-- 
2.43.0

