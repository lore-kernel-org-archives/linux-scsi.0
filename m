Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F154FDE7D;
	Tue,  6 Oct 2026 23:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330136; cv=none; b=goV7TkoZly1TV0niZGzM9/nFflTWErYxbNQEBDBJz1z8F5V9WVPlMfHujQNH5FbR2twY+ZyBGcya+pLfnh/oON4+vd0+yn/pd4PTrnCtyYLm2axIZD+CTqK5kj2hcZrzitlWsCKd96SY0Kyu7JLRc8gIhBj6pwEUOdp+VIuGU0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330136; c=relaxed/simple;
	bh=IFelv4Rh9wjKdz8RhmMYvdqrrJ3VZ/3JWGZ+JtTGgeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlyArw1SG2YpqAkrwa8ZhTbC1ZN36NQYA/tchiJtZH5N17s/+mii0yZ+KmBecPRvJ8KXD19OORcQVPh5Q0g191wlCHm+B1WbeZBxWxfDOw5QYYaa6o+xC0sRMXmuvV+hKb0SlPO6v4W+1bW30vHJYkcK4wUj69jtc1TORNeoYmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=T6IVFNx+; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="T6IVFNx+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791330125;
	bh=IFelv4Rh9wjKdz8RhmMYvdqrrJ3VZ/3JWGZ+JtTGgeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6IVFNx+I+mVSjtCkv2lBdquHdIN3ReBsBjU+w6hbMmhPlCHCn0+o7PuHkpIXZfHx
	 TXlNXhCNZ/lqyWGmmZYrZ4JYb1K0QsIOUzsYMFNR34CN1vlkCn+z9BYEasZ0qXTUtW
	 vnSu18e+xgI8I54nwi/VmasQgx+0FziE1qXam+kw=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id E39BFBE601;
	Tue,  6 Oct 2026 23:42:05 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id A40D55FADC;
	Wed,  7 Oct 2026 00:42:05 +0100 (BST)
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
Subject: [PATCH v9 10/11] ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
Date: Wed,  7 Oct 2026 00:42:00 +0100
Message-ID: <20261006234202.1139018-11-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006234202.1139018-1-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
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
 drivers/ata/libata-scsi.c | 57 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 471daf63382a..0ee6bdeb81f0 100644
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
@@ -5340,13 +5341,25 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 
 			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
 						 NULL);
-			if (!IS_ERR(sdev)) {
-				dev->sdev[0] = sdev;
-				ata_scsi_assign_ofnode(sdev, dev, ap);
-				scsi_device_put(sdev);
-			} else {
+			if (IS_ERR(sdev)) {
 				dev->sdev[0] = NULL;
+				continue;
 			}
+
+			/*
+			 * For multi-LUN ATAPI (BLIST_FORCELUN), trigger a
+			 * sequential scan for this target.  pdt_1f_for_no_lun,
+			 * set during LUN 0 configure, ensures non-responding
+			 * LUNs are silently skipped; dev->sdev[] is populated
+			 * by ata_scsi_dev_config() during the scan.
+			 */
+			if (dev->class == ATA_DEV_ATAPI &&
+			    sdev->sdev_bflags & BLIST_FORCELUN)
+				scsi_scan_target(&ap->scsi_host->shost_gendev,
+						 channel, id, SCAN_WILD_CARD,
+						 SCSI_SCAN_RESCAN);
+			ata_scsi_assign_ofnode(sdev, dev, ap);
+			scsi_device_put(sdev);
 		}
 	}
 
@@ -5554,7 +5567,7 @@ void ata_scsi_hotplug(struct work_struct *work)
  *	@lun: LUN to scan
  *
  *	This function is called when user explicitly requests bus
- *	scan.  Set probe pending flag and invoke EH.
+ *	scan.  Set probe pending flag and invoke EH, then scan ATAPI LUNs.
  *
  *	LOCKING:
  *	SCSI layer (we don't care)
@@ -5569,7 +5582,7 @@ int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 	unsigned long flags;
 	int devno, rc = 0;
 
-	if (lun != SCAN_WILD_CARD && lun)
+	if (lun != SCAN_WILD_CARD && lun >= shost->max_lun)
 		return -EINVAL;
 
 	if (!sata_pmp_attached(ap)) {
@@ -5610,6 +5623,36 @@ int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
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
+			}
+		}
+		mutex_unlock(&ap->scsi_scan_mutex);
+	}
+
 	return rc;
 }
 
-- 
2.43.0

