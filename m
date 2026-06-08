Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97072E9729;
	Mon,  8 Jun 2026 21:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780954502; cv=none; b=EObORNGKhVvmWp6THv4VizxNg6f2hlnNCK9e9bH9cyg28siFLEbaIMIfYqrryUEPKDQnR+X0EOzJCHLVKl2ePuJaPjSxsCm2Ue94DgPhmUg5FiqFrkbhXfkFOg82Zo1RjY4kPVDO3tlqGNFZkX6RFzeStKN1RDICl7buiPLMHJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780954502; c=relaxed/simple;
	bh=2Zw3vbvV8x4GK8JZGJ5RHUORMcfvOnvV4537sQAvgsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUzIpDHMY9rMMmuT41946lcyG98P7RPnITNHx2h+a70ehW7M0UFwNo0nV0m0x52kKbQZEyboya/ADBfZEVralcsfuAg39dfJAy7OvischzFZMWmctH41KqWbfjuD4EJc1Ef7Pq8UlDCJigjiFIwbViXEOozHhGndkb+FuMMTHLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=U6TBUtIB; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="U6TBUtIB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1780954491;
	bh=2Zw3vbvV8x4GK8JZGJ5RHUORMcfvOnvV4537sQAvgsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6TBUtIBmVrjngcikqOas574rgOrKoEECqKy1zZoLX3+ZtoTQtSbSFGdC9t1nIXfv
	 r5bGWJuMC7cEqkWmrou9znw/U0tGzHI0o1u1Fyafo3YLf3xYpPhpOwSQzcO7uxwe4w
	 2WwI20Ir/yJfqKqSJZjO7s5VrTcoMNVfEBLbW4Oc=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 81A10BE731;
	Mon,  8 Jun 2026 21:34:51 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 1ABA65FC4F;
	Mon,  8 Jun 2026 22:34:51 +0100 (BST)
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
Subject: [PATCH v6 5/6] ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
Date: Mon,  8 Jun 2026 22:34:42 +0100
Message-ID: <20260608213443.2296614-6-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260608213443.2296614-1-philpem@philpem.me.uk>
References: <20260608213443.2296614-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After LUN 0 is added for an ATAPI device, check its BLIST_FORCELUN
flag.  If set, bump dev->nr_luns to the host's max_lun so the LUN
routing in atapi_xlat() accepts the probe INQUIRYs, then call
scsi_scan_target() with SCAN_WILD_CARD to trigger the SCSI layer's
built-in sequential LUN scan for that target only.  This probes
LUNs 1..shost->max_lun, driven by the libata atapi_max_lun module
parameter.

Devices without BLIST_FORCELUN (the vast majority of ATAPI devices)
are left with only LUN 0 -- no sequential scan is triggered, so
single-LUN devices like the iHAS124 DVD writer are completely
unaffected.

Non-responding LUNs (PQ=0/PDT=0x1f) are silently skipped by
scsi_probe_and_add_lun() when BLIST_NO_LUN_1F is set on the device
via scsi_devinfo.

Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2d714efc855f..a6f5557014c7 100644
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
@@ -4745,12 +4746,30 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
 						 NULL);
 			if (!IS_ERR(sdev)) {
-				dev->sdev[0] = sdev;
-				ata_scsi_assign_ofnode(dev, ap);
+				/*
+				 * For multi-LUN ATAPI (BLIST_FORCELUN), bump
+				 * dev->nr_luns to the host max so the LUN
+				 * routing in atapi_xlat() accepts the probe
+				 * INQUIRYs to LUN > 0, then trigger the
+				 * sequential scan.  pdt_1f_for_no_lun, set
+				 * during LUN 0 configure, ensures
+				 * non-responding LUNs are silently skipped;
+				 * dev->sdev[] is populated by
+				 * ata_scsi_dev_config() during the scan.
+				 */
+				if (dev->class == ATA_DEV_ATAPI &&
+				    sdev->sdev_bflags & BLIST_FORCELUN) {
+					dev->nr_luns = ap->scsi_host->max_lun;
+					scsi_scan_target(
+						&ap->scsi_host->shost_gendev,
+						channel, id, SCAN_WILD_CARD,
+						SCSI_SCAN_RESCAN);
+				}
 				scsi_device_put(sdev);
-			} else {
-				dev->sdev[0] = NULL;
 			}
+
+			if (dev->sdev[0])
+				ata_scsi_assign_ofnode(dev, ap);
 		}
 	}
 
-- 
2.43.0

