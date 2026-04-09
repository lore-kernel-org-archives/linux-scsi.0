Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409B8324B2D;
	Thu,  9 Apr 2026 21:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775768772; cv=none; b=HWjZV7cgtcdTHIHIzJSXiFx5dLb28G23HhC7DTc35xh4Qug7DuMgUVj2JCAznsajZH9PX6HEqbfy4CWKIJa5PIWxn52jSrhEkV6rvwaV30wGtPX4b7XWT7K8sTCy18Cn+lPhhLqcY/DvJi/WousvSKt5j7hAyQQkfZLVz4OWXPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775768772; c=relaxed/simple;
	bh=MlOIDuUdpcyW/0eVakGVWxRBBujqmvqNJ1Tze0LcJ9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGGezC24OT7tk/K0WNTKqOwnoEF+CcxcTbygRXUYB26uxArFohyK3FFOkNCV1SdXxPtDmgW8S3FEF6qKjQ41H8gS1XDrhSTcYkd2ZzOAS44utWOnCqcWWo5pFpITrBr1po5Gy7t2YiZfn4fjQmJb9xMMSqPHcmM8W2O0x6FloMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=ftTqES+2; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="ftTqES+2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1775768768;
	bh=MlOIDuUdpcyW/0eVakGVWxRBBujqmvqNJ1Tze0LcJ9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftTqES+2Not+gEuuu3vOrfk6vfc3c25AxbDSOhl9c0RT0L1/TqQxIXaUwNp2jFRrT
	 g+pbguHiVr0gs721OKrIjKfwvwLtEUNQzqFTl7n98TIkhVgQof1vb/Nh1E/AhZc8uB
	 TvmRf4mLSiSzRq4nIu+jFzt2XlHJXn/QJY8BS6zA=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id B1651BE599;
	Thu,  9 Apr 2026 21:06:08 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 66FB05FC52;
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
Subject: [PATCH 3/3] ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
Date: Thu,  9 Apr 2026 22:05:59 +0100
Message-ID: <20260409210559.155864-4-philpem@philpem.me.uk>
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

Some ATAPI devices (e.g. the Panasonic PD/CD combo drives) implement
multiple logical units. For instance the aforementioned PD/CD has a CD
drive on LUN 0 and the rewritable Phase-change Dual (PD) block device on
LUN 1.

ata_scsi_scan_host() previously only scanned LUN 0 via
__scsi_add_device(). With the multi-LUN work now in place, extend this
scan to probe for additional LUNs on devices which have BLIST_FORCELUN
set in the SCSI device info table.

Scanning stops when __scsi_add_device() fails, or the device reports
device type 0x1f (unknown or no device type). The PD drive returns this
for unimplemented LUNs.

The aforementioned BLIST_FORCELUN guard prevents non-multilun devices
from being affected.

Tested with a Panasonic LF-1195C PD/CD with Compaq firmware, which now
correctly enumerates as a CD drive (sr) and PD optical drive (sd).

Also tested with a LITE-ON iHAS124 DVD drive, which has a single LUN and
ignores the LUN parameter in the CDB. As a result, without the
BLIST_FORCELUN guard, this drive would pop up as eight separate devices.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-scsi.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index dc6829e60fb3..0a7ce44118fe 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4732,6 +4732,35 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
 				ata_scsi_assign_ofnode(dev, ap);
+				/*
+				 * Multi-LUN ATAPI devices (e.g. PD/CD combo
+				 * drives) are flagged BLIST_FORCELUN in
+				 * scsi_devinfo.  Probe additional LUNs when
+				 * the flag is set.
+				 */
+				if (dev->class == ATA_DEV_ATAPI &&
+				    (sdev->sdev_bflags & BLIST_FORCELUN)) {
+					u64 lun;
+
+					for (lun = 1; lun < ap->scsi_host->max_lun;
+					     lun++) {
+						struct scsi_device *extra;
+
+						extra = __scsi_add_device(
+							ap->scsi_host,
+							channel, id, lun,
+							NULL);
+						if (IS_ERR(extra))
+							break;
+						/* PDT 0x1f: no device type */
+						if (extra->type == 0x1f) {
+							scsi_remove_device(extra);
+							scsi_device_put(extra);
+							break;
+						}
+						scsi_device_put(extra);
+					}
+				}
 				scsi_device_put(sdev);
 			} else {
 				dev->sdev = NULL;
-- 
2.39.5

