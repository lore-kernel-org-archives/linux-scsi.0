Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242614F3EB3;
	Fri,  9 Oct 2026 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563240; cv=none; b=QRLBHTyTxRJJJvysC8liTcEuJ1DNN38e8flwIy1VVi+G8+XLTq2iG+n3aBeavLUJmRnaKDd+hODnT+LVFaGcHSRlkLU91xsAacKsHUc4kHqSSO3eiwOZn539SRfAaz55efdH2MKGZfuefZFPNiojCNZuR5jH25OvVcnHPAHoaow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563240; c=relaxed/simple;
	bh=XUv+GHar1LWBQYs5Ndv+wqMkvKvvgtemV3ZF3JHVknU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jChJLb8bnWWNcyuOqdLMaWqwZQYJ1U8sJggA2vulPs7facDQ1bNw3Lbg4VSVI1iHnGZaTIR04iicyEri/PeMZZ7R06774QbC1sBKjtsmqggOfvALVTs62Y30Id41wmgG2MYhVYQaNPo66fs1J1/Vr1njONOctOkB9w9RZbsdOfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=HmW4RUfW; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="HmW4RUfW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=XUv+GHar1LWBQYs5Ndv+wqMkvKvvgtemV3ZF3JHVknU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmW4RUfW3mYWoV8JzaGZrb4ON6xN0MtXK0jeE9AOYXerqclEjS835XKfiX2jP0uQ9
	 1DSXRynvVo1SLPCAPKSi/cPAkdcy/ZKXLLBG0EUHvlFExMPph0sldKt3S603/xFKIZ
	 YpyU25rzp5dB9H3DdXzJAvcwwj6DRvWaw6CZ34XU=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id D67AFBE77D;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id A17DD5FC4B;
	Fri,  9 Oct 2026 17:26:55 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v10 14/15] ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
Date: Fri,  9 Oct 2026 16:55:21 +0100
Message-ID: <20261009155522.593045-15-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009155522.593045-1-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After adding LUN 0 of an ATAPI device marked BLIST_FORCELUN, scan the
target's remaining LUNs using scsi_scan_target(). The scan is bounded by
shost->max_lun, set through atapi_max_lun.

Publish the accepted secondary LUNs after the scan, using the SCSI scan
mutex and ap->lock helper introduced by the per-LUN conversion. This keeps
partially configured or failed SCSI devices out of dev->sdev[] and
serializes publication with device removal.

Also accept explicit user scans for LUNs below shost->max_lun. Scan the
selected ATAPI targets after error handling completes, using
SCSI_SCAN_MANUAL and scsi_scan_mutex to serialize with hotplug. This lets
users restore a deleted secondary LUN while LUN 0 remains attached.

BLIST_NO_LUN_1F lets the SCSI layer skip LUNs reported as absent with
PQ=0/PDT=0x1f. ata_scsi_dev_config() rejects LUNs outside dev->sdev[].

Assign the OF node before dropping the SCSI device reference, using the
referenced device so concurrent removal cannot invalidate the pointer.

Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 50 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index faf408acf65e..bba2db2f8428 100644
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
@@ -5381,6 +5382,20 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 				continue;
 
 			ata_scsi_publish_sdevs(dev);
+
+			/*
+			 * For multi-LUN ATAPI (BLIST_FORCELUN), trigger a
+			 * sequential scan for this target.  pdt_1f_for_no_lun,
+			 * set during LUN 0 configure, ensures non-responding
+			 * LUNs are silently skipped.
+			 */
+			if (dev->class == ATA_DEV_ATAPI &&
+			    sdev->sdev_bflags & BLIST_FORCELUN) {
+				scsi_scan_target(&ap->scsi_host->shost_gendev,
+						 channel, id, SCAN_WILD_CARD,
+						 SCSI_SCAN_RESCAN);
+				ata_scsi_publish_sdevs(dev);
+			}
 			ata_scsi_assign_ofnode(sdev, dev, ap);
 			scsi_device_put(sdev);
 		}
@@ -5591,7 +5606,7 @@ void ata_scsi_hotplug(struct work_struct *work)
  *	@lun: LUN to scan
  *
  *	This function is called when user explicitly requests bus
- *	scan.  Set probe pending flag and invoke EH.
+ *	scan.  Set probe pending flag and invoke EH, then scan ATAPI LUNs.
  *
  *	LOCKING:
  *	SCSI layer (we don't care)
@@ -5606,7 +5621,7 @@ int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 	unsigned long flags;
 	int devno, rc = 0;
 
-	if (lun != SCAN_WILD_CARD && lun)
+	if (lun != SCAN_WILD_CARD && lun >= shost->max_lun)
 		return -EINVAL;
 
 	if (!sata_pmp_attached(ap)) {
@@ -5647,6 +5662,37 @@ int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 	} else
 		spin_unlock_irqrestore(ap->lock, flags);
 
+	if (!rc) {
+		struct ata_link *link;
+		struct ata_device *dev;
+
+		/* EH does not scan missing LUNs on an already attached target. */
+		mutex_lock(&ap->scsi_scan_mutex);
+		ata_for_each_link(link, ap, EDGE) {
+			ata_for_each_dev(dev, link, ENABLED) {
+				unsigned int scan_channel = 0, scan_id = 0;
+
+				if (dev->class != ATA_DEV_ATAPI)
+					continue;
+				if (ata_is_host_link(link))
+					scan_id = dev->devno;
+				else
+					scan_channel = link->pmp;
+				if (channel != SCAN_WILD_CARD &&
+				    channel != scan_channel)
+					continue;
+				if (id != SCAN_WILD_CARD && id != scan_id)
+					continue;
+
+				scsi_scan_target(&shost->shost_gendev,
+						 scan_channel, scan_id, lun,
+						 SCSI_SCAN_MANUAL);
+				ata_scsi_publish_sdevs(dev);
+			}
+		}
+		mutex_unlock(&ap->scsi_scan_mutex);
+	}
+
 	return rc;
 }
 
-- 
2.43.0

