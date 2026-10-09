Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEC94F3903;
	Fri,  9 Oct 2026 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563237; cv=none; b=Tg5IRgtzTGT0HQo0MAoZM6Sykgd6OlxRXdsnifbEEwnb0T24OBFC9inEnuxze2eRu4GlP7Qnfe4ddKf5+tcTWf+NmJK+rQYifqyYUplA8xB/+Gy8OR1DDTyZWndmi61gB8DawiERirTzB3hw9l4FQLoFR5HtXX1GWr8c9jekGVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563237; c=relaxed/simple;
	bh=8vCwYpM7mHZ8pQLA8yEiOGC+aoc4j1G0NNf0u5m+GIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiHpjDp8CnIs9Ym4RNJ4unDZHT1Twe9mFOeEMyx2UO0kZJHBeb7ztXfSFJzLm4sah9hifHHCYdpmkQn41KeRXgBI7/CBEtEiXgNjTZ5pIZyrfYIssuCriztga+XAv2UGbXxJbnZsW8tzDbQCvNXJRwE9pCbvLLrmohUWwJu8SnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=W99NL2Yi; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="W99NL2Yi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=8vCwYpM7mHZ8pQLA8yEiOGC+aoc4j1G0NNf0u5m+GIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W99NL2YiH5YJ62jPxtPvA+veHg291xu/a+0pE6ijnoLRE9sVp2kRsbb+Vp8zhcghL
	 LAScVf9RDigr8K3UfPGK70dRm5UHUXV8/Vbw0VmHhLOC4ARzTZ88AXtUGG++U0KH4w
	 gh/KNXLmhnjfjI7Z1sROnMyg7lp6FMh9dlWt13Vc=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id C75E5BE77C;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 8A88B5FB4D;
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
Subject: [PATCH v10 13/15] scsi: add BLIST_NO_LUN_1F blacklist flag
Date: Fri,  9 Oct 2026 16:55:20 +0100
Message-ID: <20261009155522.593045-14-philpem@philpem.me.uk>
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

Some multi-LUN devices report unpopulated LUNs with PQ=0/PDT=0x1f.
SCSI scanning adds these as spurious "No Device" entries.

Add BLIST_NO_LUN_1F to set pdt_1f_for_no_lun from scsi_devinfo before
scsi_probe_and_add_lun() checks PDT=0x1f. Setting it here also covers
LUN 0.

Give pdt_1f_for_no_lun its own bool. Sharing bitfield storage with
expecting_lun_change allows scan-time writes and concurrent I/O updates
to overwrite each other.

Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_scan.c    | 3 +++
 include/scsi/scsi_device.h  | 4 ++--
 include/scsi/scsi_devinfo.h | 6 +++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0f0f243c2561..e34824623294 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1298,6 +1298,9 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
 	 * PDT=00h Direct-access device (floppy)
 	 * PDT=1Fh none (no FDD connected to the requested logical unit)
 	 */
+	if (bflags & BLIST_NO_LUN_1F)
+		starget->pdt_1f_for_no_lun = 1;
+
 	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
 	    (result[0] & 0x1f) == 0x1f &&
 	    !scsi_is_wlun(lun)) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8694eeadd753..a81a7c8cce18 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -360,13 +360,13 @@ struct scsi_target {
 	unsigned int		single_lun:1;	/* Indicates we should only
 						 * allow I/O to one of the luns
 						 * for the device at a time. */
-	unsigned int		pdt_1f_for_no_lun:1;	/* PDT = 0x1f
-						 * means no lun present. */
 	unsigned int		no_report_luns:1;	/* Don't use
 						 * REPORT LUNS for scanning. */
 	unsigned int		expecting_lun_change:1;	/* A device has reported
 						 * a 3F/0E UA, other devices on
 						 * the same target will also. */
+	/* Keep scan-time writes separate from I/O-updated bitfields. */
+	bool			pdt_1f_for_no_lun; /* PDT = 0x1f means no LUN. */
 	/* commands actually active on LLD. */
 	atomic_t		target_busy;
 	atomic_t		target_blocked;
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

