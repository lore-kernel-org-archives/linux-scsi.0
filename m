Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0E9399019;
	Mon, 20 Apr 2026 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776689128; cv=none; b=hpMbfncGS1QSvLPsNIvmITZOpaWpU09uU4niRAJnoyvJNzDSudMox41e77N+MVVgGguNqRuCamOClFj58T1XsQM7/pwtj181xf72SY6kkIEvYqdcdEYM9erQN3ycy4dY0xFrJIcGiit6meIqPhZEJpsqn9Zs/7Hc+aAUELUIyyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776689128; c=relaxed/simple;
	bh=vGCMlAn3ZRxZJy5AYq/flJzKXszt4Qsi2hLGeF8baJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8T3S5DzPG80e80/2iurSLWG6aPQFdN+q2GMeOz/AKY/v/e9idgAxLAuN0YVTspCHGffIe/Hdo6OxxqHvtP1hdwB6AwUgkEFE8cbYlHLDkHZnimXiItVKPBtf8ePKrVHnZySpZvRRWLvPRjwfWFOaDglE525Bla0HFk6UBl9zN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=NnwMstFn; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="NnwMstFn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1776687809;
	bh=vGCMlAn3ZRxZJy5AYq/flJzKXszt4Qsi2hLGeF8baJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnwMstFnPSaFTU9eZ02elsf1KakiUBpX9K4dsmrpcq/SiZOR3aYyucaWZaz0PIBWS
	 w0Z6UUJyWKvfErW4V8Eh0WQCed0AB8cfcYXMVhTfbyWLXhEi2MipW12P9T7ezWPr9h
	 xNEMsI1u9RiJqFYDU0vt0Hr6ieNzT8L0LfORqRUk=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 45D87BEFE9;
	Mon, 20 Apr 2026 12:23:29 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id BC87A5FC5A;
	Mon, 20 Apr 2026 13:23:28 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v2 4/5] ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
Date: Mon, 20 Apr 2026 13:23:20 +0100
Message-ID: <20260420122321.4161027-5-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260420122321.4161027-1-philpem@philpem.me.uk>
References: <20260420122321.4161027-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

After LUN 0 is added for an ATAPI device, check its BLIST_FORCELUN
flag.  If set, call scsi_scan_target() with SCAN_WILD_CARD to trigger
the SCSI layer's built-in sequential LUN scan for that target only.
This probes LUNs 1..shost->max_lun, driven by the atapi_max_lun module
parameter from patch 1/5.  Devices without BLIST_FORCELUN (the vast
majority of ATAPI devices) are left with only LUN 0 — no sequential
scan is triggered, so single-LUN devices like the iHAS124 DVD writer
are completely unaffected.

To suppress spurious "No Device" log entries from non-responding LUNs
(e.g. LUN 2+ on a two-LUN PD/CD drive), set pdt_1f_for_no_lun on the
scsi_target during LUN 0 configuration.  The Panasonic PD-1 returns
PQ=0/PDT=0x1f for unpopulated LUNs rather than the standard PQ=3;
with this flag, scsi_probe_and_add_lun() silently skips them.

If BLIST_FORCELUN is set but atapi_max_lun is still at its default of
1, an informational message points the user at the module parameter so
the knob is discoverable from dmesg.

Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 53 ++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4e88ae7d94c3..9d18ef2835a5 100644
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
@@ -1132,6 +1133,22 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 		sdev->security_supported = 1;
 
 	dev->sdev[sdev->lun] = sdev;
+
+	/*
+	 * Tell the SCSI scan layer that PDT 0x1f with PQ 0 means "no LUN
+	 * present" for this target.  The Panasonic PD-1 (and likely other
+	 * multi-LUN ATAPI devices) returns PQ=0/PDT=0x1f for unpopulated
+	 * LUNs instead of the standard PQ=3.  Setting this flag lets the
+	 * sequential LUN scan skip those LUNs cleanly.
+	 */
+	if (dev->class == ATA_DEV_ATAPI && sdev->lun == 0) {
+		sdev->sdev_target->pdt_1f_for_no_lun = 1;
+
+		if ((sdev->sdev_bflags & BLIST_FORCELUN) && atapi_max_lun < 2)
+			ata_dev_info(dev,
+				"device has additional LUNs; set libata.atapi_max_lun=2 or higher to access them\n");
+	}
+
 	return 0;
 }
 
@@ -4700,7 +4717,6 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
  repeat:
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ENABLED) {
-			struct scsi_device *sdev;
 			int channel = 0, id = 0;
 
 			if (dev->sdev[0])
@@ -4711,15 +4727,34 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
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

