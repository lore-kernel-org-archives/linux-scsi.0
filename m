Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E965B30C608;
	Wed,  6 May 2026 23:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778111158; cv=none; b=UYKp2Tpzc79N3EqfOWuflOGvpgoLPRKO/wQE6DFA1wfPPTQgKYR1aaNZXBvOy/DjaTXsY1BJ61nsEMIn7mHSwi3ze/V60bKHbXRHFeBGk2uy45u/5gMGUxBKYphoS3XUhfQYJsVuMtAuYW0VuIvJQmr5i5NYDQ4v816ta61q7Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778111158; c=relaxed/simple;
	bh=4FH1jA71JSDRfOvyJ5eMM5Q9da7Qmo6FiQ07tWl/Uxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iy6UPMqwhCJ18I999+2lhJkJSEsJGJWDsTqsetxrxda3tKGvfZ8/ii/AKRlfBd7oO2JUT5owJv4jmuQd3Z52DEdw9wl/V7SsG8iUWJW/sBQUINcGhm/sg9ugu0eqpyhD90O5nbGczUkE2lJM6LEa4vzi4S+kFZDNOfsLf7cfDLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=G/bRXbbn; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="G/bRXbbn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1778111155;
	bh=4FH1jA71JSDRfOvyJ5eMM5Q9da7Qmo6FiQ07tWl/Uxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/bRXbbnyPTgws+nHXeqBjifNL1HByiobVNzC7kVWb3S7v22DubM7Vtr97rmV6K+q
	 a8NfA2MKiycYfAsW/B7lG+zxd43Bc/pId07jdlnVLakW9skX15OCztFXtmrjPL1zUv
	 7T7rBQvUSUPgKv5OEmeil0oW2cpLG7y09Ssy0+/I=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 7076BBE5AB;
	Wed,  6 May 2026 23:45:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 3EE0E5FC52;
	Thu,  7 May 2026 00:45:55 +0100 (BST)
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
Subject: [PATCH v4 4/7] scsi: add BLIST_NO_LUN_1F blacklist flag
Date: Thu,  7 May 2026 00:45:45 +0100
Message-ID: <20260506234548.1974603-5-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260506234548.1974603-1-philpem@philpem.me.uk>
References: <20260506234548.1974603-1-philpem@philpem.me.uk>
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

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_scan.c    | 2 ++
 include/scsi/scsi_devinfo.h | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7b11bc7de0e3..a8fbe66379b9 100644
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

