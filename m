Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D383AFD1F;
	Mon,  8 Jun 2026 21:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780955825; cv=none; b=X5E5IxiG9F7GbVOi6ZaXtvEVlaEhCbZOQhZcLJkwg4NHzoEOwBZaQaTwKcJT/FftlOGEuT16xC1E9HkKaRCT167u1w1spBs9PW69C6VUY3SiM+nnKG+nKuexUvBpD0Hc3j/p3NCaQfSxVMkMxyY/cegPNj0EcKWf6HVMRyKGl/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780955825; c=relaxed/simple;
	bh=Qn3vwVigO0URt2j33/EaXlxCUk+kPReoOtoKacUnLik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A106hDyB62SQ0Fkzh4v6hRCXpGVq2CG4mqcC2sFhYYKd8GP3xkPDjXD2IMrCeu5Q7CwjtiPFEUZ9+F89ZLbWS9gHoCsREvlihcmjLu80okBqBxgiBq8DWMIwc/C0tuiak1tkw5DIeR1ga8cc3IzQgKygP3QnY8K0sWKSB8bZlBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=q4Qc/diM; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="q4Qc/diM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1780954491;
	bh=Qn3vwVigO0URt2j33/EaXlxCUk+kPReoOtoKacUnLik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4Qc/diMJSpG2jFVEV6HaJKSwQ79jFCSBbJTIc3oEiN2UDf6UClEFQ/2bABtoDLsi
	 e0ZkLq8DmKHFNmpNuZG7pSHENYqq9nTrDFmMjWLvsQiX3zr0VGElugJjdUIlt5QkBg
	 NFKm1LglVBvRbzquvpVGHcm1GjfUKgZpvGydTkTs=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 63E8BBE6EC;
	Mon,  8 Jun 2026 21:34:51 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 12F7A5FC4E;
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
Subject: [PATCH v6 4/6] scsi: add BLIST_NO_LUN_1F blacklist flag
Date: Mon,  8 Jun 2026 22:34:41 +0100
Message-ID: <20260608213443.2296614-5-philpem@philpem.me.uk>
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

Some multi-LUN devices respond to INQUIRY on unpopulated LUNs with
PQ=0 / PDT=0x1f instead of the standard PQ=3.  The SCSI scan layer
normally adds such devices (PQ=0 means "connected"), producing
spurious "No Device" entries.

The scsi_target field pdt_1f_for_no_lun already exists to suppress
this, but was previously only set by the USB UFI driver.

Add BLIST_NO_LUN_1F so the flag can be set per-device from
scsi_devinfo, and wire it up in scsi_add_lun() to set
starget->pdt_1f_for_no_lun from the blacklist flags.  This runs
during LUN 0 processing, before the sequential LUN scan probes
higher LUNs.

Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_scan.c    | 2 ++
 include/scsi/scsi_devinfo.h | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ef22a4228b85..bfbbf9be05d2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1069,6 +1069,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	transport_configure_device(&sdev->sdev_gendev);
 
 	sdev->sdev_bflags = *bflags;
+	if (sdev->sdev_bflags & BLIST_NO_LUN_1F)
+		sdev->sdev_target->pdt_1f_for_no_lun = 1;
 
 	if (scsi_device_is_pseudo_dev(sdev))
 		return SCSI_SCAN_LUN_PRESENT;
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

