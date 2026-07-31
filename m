Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6A72E03EA;
	Fri, 31 Jul 2026 21:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534759; cv=none; b=AbPIPkMZxEPltZTT+u5fNdudqB//5PRW1w6DAGSEqcZ/TeKuRsEecfEZGFzWtQRJNpR2KoxDoL6rDL/2AG+hLMfzBgcBwm7YYbNKovW6OM9/c9pIRtbeOEBKg78HethJZ8HwehdhbTTlgPFW5KtEVMfDhvtNbR8PzJhjpyEwNR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534759; c=relaxed/simple;
	bh=qUboVyGXEhsRGVvQleQs1ZKSf621X3Pwym0vMk4PeKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SO/xVPXN05oiLOfsUpXUHsgIwiqUJBSH0jkD8ySGkZJU3DBAB/lmQU3nIs1JHD67Ha3gL8ggaZ3ye3cYZhCD/NYQ93Hno9ivF0BX3t3dEx3NiwBtke5vK8L81YuoorClFZ4/xCjzbGdH1RCR/VC2dZJKE+TWPHZjbFsRuGxlxeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=YtRYepYT; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="YtRYepYT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1785533714;
	bh=qUboVyGXEhsRGVvQleQs1ZKSf621X3Pwym0vMk4PeKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtRYepYTJO4/LvcgS5dan5LjgqNmRl0Xj8fEb/HMLL7art1W8MizHCmVCOWvmyZod
	 rG4IXMyPWHHBCH6e370lkczpeXaFZYBQqxYfE1+GNWJpG85J+s01GUTom1/ZU6nYL9
	 fo6+meiS+krFKSrMUtvK5mYEojP/Hgd913H1NjFQ=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id E1501BE53E;
	Fri, 31 Jul 2026 21:35:14 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id A64875F888;
	Fri, 31 Jul 2026 22:35:14 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Phil Pemberton <philpem@philpem.me.uk>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v8 5/6] ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
Date: Fri, 31 Jul 2026 22:35:02 +0100
Message-ID: <20260731213503.2379771-6-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260731213503.2379771-1-philpem@philpem.me.uk>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
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
This probes LUNs 1..shost->max_lun, driven by the libata atapi_max_lun
module parameter.

Devices without BLIST_FORCELUN (the vast majority of ATAPI devices)
are left with only LUN 0 -- no sequential scan is triggered, so
single-LUN devices like the iHAS124 DVD writer are completely
unaffected.

Non-responding LUNs (PQ=0/PDT=0x1f) are silently skipped by
scsi_probe_and_add_lun() when BLIST_NO_LUN_1F is set on the device
via scsi_devinfo.

Also fix a TOCTOU window: call ata_scsi_assign_ofnode() before
scsi_device_put() so the reference to dev->sdev[0] is held while
the OF node is assigned.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0b1e4842860c..5bbb3169bea7 100644
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
@@ -5281,13 +5282,27 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 
 			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
 						 NULL);
-			if (!IS_ERR(sdev)) {
-				dev->sdev[0] = sdev;
-				ata_scsi_assign_ofnode(dev, ap);
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
+			    sdev->sdev_bflags & BLIST_FORCELUN &&
+			    !WARN_ON_ONCE(ap->scsi_host->max_lun > ATAPI_MAX_LUN))
+				scsi_scan_target(&ap->scsi_host->shost_gendev,
+						 channel, id, SCAN_WILD_CARD,
+						 SCSI_SCAN_RESCAN);
+			if (dev->sdev[0])
+				ata_scsi_assign_ofnode(dev, ap);
+			scsi_device_put(sdev);
 		}
 	}
 
-- 
2.43.0

