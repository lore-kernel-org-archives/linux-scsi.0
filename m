Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEA4331EB1;
	Fri, 31 Jul 2026 21:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785533725; cv=none; b=hUljsbTIXuALaoPH/SOvT3mA2iyKYdCoclciZpL8qS7Y1JeHt9FoyqD9kkXhnTBWEUXuvOxo5TQRdMTL3S1swbpM8Oe2MgApUluCI/NVrNtQKWMCvk3q8e6ZVHjYSqdG73s8Ii4ZWKbioBeO1nXv5lUWBruVra6SkBaeM2ZwvTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785533725; c=relaxed/simple;
	bh=ESXYlLL9LSnVpycKDLNE3K5jRm2q+89vmOuxy2cnQ5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cw6hQyGOCY7t8PHHKCOs554fJFclRfI4xR1t5ZuNiKdPge92bI1iP4DOGhRWu1TSdrfQV6SR2zt6nNDF1sHzmIrf81Ki4WyPOXnN+2Kr2Zxn6jGGipg7/und8PkNZNw9Z58ORsWSN9pPAvk/9uV4qm420bDkYKE/piob2jliiGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=UeptepJl; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="UeptepJl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1785533714;
	bh=ESXYlLL9LSnVpycKDLNE3K5jRm2q+89vmOuxy2cnQ5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeptepJl1VYjFHitdgexZeJ7MennuagPuT6npa4MetAfcXG7wPaMNZiwdjYtKf8OZ
	 KtEkE7pjbOk9I5uB4Xa80d0lFie/eIz8ZsgA2WxZzs3O4vwNoJoF42V+bt/j1UYdVM
	 ewpaI9fDKCQwqiufeSbsYXbQQob/AGoL8kmoffkM=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id E7040BE58D;
	Fri, 31 Jul 2026 21:35:14 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 93B215FC3E;
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
Subject: [PATCH v8 4/6] scsi: add BLIST_NO_LUN_1F blacklist flag
Date: Fri, 31 Jul 2026 22:35:01 +0100
Message-ID: <20260731213503.2379771-5-philpem@philpem.me.uk>
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

Some multi-LUN devices respond to INQUIRY on unpopulated LUNs with
PQ=0 / PDT=0x1f instead of the standard PQ=3.  The SCSI scan layer
normally adds such devices (PQ=0 means "connected"), producing
spurious "No Device" entries.

The scsi_target field pdt_1f_for_no_lun already exists to suppress
this, but was previously only set by the USB UFI driver.

Add BLIST_NO_LUN_1F so the flag can be set per-device from
scsi_devinfo, and wire it up in scsi_probe_and_add_lun() to set
starget->pdt_1f_for_no_lun from the blacklist flags.  This is placed
immediately before the PDT=0x1f check so it takes effect for all LUNs,
including LUN 0, without waiting for scsi_add_lun() to run.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_scan.c    | 3 +++
 include/scsi/scsi_devinfo.h | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e27da038603a..98bd4d49fd62 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1296,6 +1296,9 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 * PDT=00h Direct-access device (floppy)
 	 * PDT=1Fh none (no FDD connected to the requested logical unit)
 	 */
+	if (bflags & BLIST_NO_LUN_1F)
+		starget->pdt_1f_for_no_lun = 1;
+
 	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
 	    (result[0] & 0x1f) == 0x1f &&
 	    !scsi_is_wlun(lun)) {
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 1d79a3b536ce..6957b0705510 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -34,7 +34,8 @@
 #define BLIST_NOSTARTONADD	((__force blist_flags_t)(1ULL << 12))
 /* do not ask for VPD page size first on some broken targets */
 #define BLIST_NO_VPD_SIZE	((__force blist_flags_t)(1ULL << 13))
-#define __BLIST_UNUSED_14	((__force blist_flags_t)(1ULL << 14))
+/* PDT 0x1f with PQ 0 means no LUN present (e.g. some ATAPI multi-LUN) */
+#define BLIST_NO_LUN_1F		((__force blist_flags_t)(1ULL << 14))
 #define __BLIST_UNUSED_15	((__force blist_flags_t)(1ULL << 15))
 #define __BLIST_UNUSED_16	((__force blist_flags_t)(1ULL << 16))
 /* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
@@ -77,8 +78,7 @@
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
 			       ((__force __u64)__BLIST_LAST_USED - 1ULL)))
-#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_14 | \
-			     __BLIST_UNUSED_15 | \
+#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_15 | \
 			     __BLIST_UNUSED_16 | \
 			     __BLIST_UNUSED_24 | \
 			     __BLIST_UNUSED_27 | \
-- 
2.43.0

