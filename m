Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228906;
	b=mHj71ehVYuZerdrkjTm3jfPlOBIqEkLqC5+Z2Yec0ftpC+TbQpm1aixVEX3EbiP5w/0g
	 Ys9T2jv+YlPOvyj3cRUh5Hc2aAd5bJsuEVmmU0aIwOqMaQnxTqRhIYHYp4ISWr65dSQOY
	 60mRSXI9dRQekUxn7WzSNTzVgAWl1xrjq7DwLYiylVFr+lEzc+7tGbS7J7qx17d5x8AP4
	 0XQJFpnzmo1PJZ3WQQhplPX5CQK7CdiBjCEghlxCr18a6s2LV52hqJzGMlImh9HQk79QI
	 TLuD1wLIzBsx/l2i7Pb4HbuZaNspOlff2DuN7aeL+5snFV+Q3Gsq/M92BWdjzVcYmzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228906;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bhlsdshfnNZCJFg367rxdQX1Hi8PPLBCauvPnVoRPhQ=;
	b=pqc5xZ86abiBSOVlESgTiOpT16RtyvjTEn534n4+kHDdcpDvgfNTx7BbGtHK9FOv8rt/
	 lmhEHgSULRCH2uIVtiQqLAScv6+lNOXUo9/j44torSfNZxQbGyADLs5eHV9YzkekJMzOC
	 /Wgxo90lMv9QuF9Zj1elJz6TMZRXUhr6nimPA+mRSxZBM0zJKb9WZL/3JFcu3/qr14aiA
	 mqe+eS74yNuF7jOcy3ZrOimuN2fZSyZPYlkOfOdmJndf4oZRh88pxFVyrrQ2p2hDp9zMJ
	 HqK7RPy6P+g+X/7G6hmWzKHRLkOdhBfr4iTpa7Gzca6FB7MLtCGSZUNOIYxkTlzUx7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=DPXORmg1;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4775606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 23:08:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4775606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=DPXORmg1
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-35b2c599f43so3239674eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 16:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793228905; x=1793833705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bhlsdshfnNZCJFg367rxdQX1Hi8PPLBCauvPnVoRPhQ=;
        b=DPXORmg1T+ImVV5i57xOZRhNqT+smzQr5bXnCgRSQqsXWzchE2rQc4kNLCtagtls/H
         2kpfEzl01OCrHdCROVWiVOHjvw0SvFcKOLQ4KsY64tAY8NutL5vuGNNoMHYLtYjsI1W9
         C1ejDt8hCXlMjZdEtFjoC/RQN1XxH4mvQsGIgBNuzvLi2tSo77X3GAWUwrtgrwt/MnFB
         F4bNG+eJ+e3sAG4AiOc9jIst8RqMsY+6TWzpR5Ennsncc+oQ8TZUBW3QMu54xLQs2BAC
         mTS4HDxLdgigMAGoFpdLUFWVHFW++j+bARMUdsowKAXWZRol6Z4PBkQnJ3qfGc0KjW16
         cnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793228905; x=1793833705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bhlsdshfnNZCJFg367rxdQX1Hi8PPLBCauvPnVoRPhQ=;
        b=TJTlYhRPUbNY76KTJAY0AuTmFWTGWH1HtrfAsUt777gqX+ZsTVFII9mGBgE0+ZhmkQ
         OTuFHNJc2nfQB1dwEwVEfWcehu8E0j4fA+ejYZPs4L6EhEVa6DAdxxpeuUGs95f7mV31
         L1r5Gw0VfA58qDr5TwordU7u+ljcxiImk12CfsIy3Pfa8aRtJIiZxW23tsj86k5x24Nu
         Glc6tIcBOLe+t9YiCE/ywzbk2igAFPCjmvXqXXHObir6fcsmcQpCDEkg55CzVDfDTq5G
         mGueukuNbShRYikZyfksvlYc+WlUE1lg5cou0nLUTRasLAjm4bwL5SodrnpdruFlmNwp
         mI4Q==
X-Gm-Message-State: AFq9FYIu2Uy8F59a5J/+Fk+YfZ0fmUt57wITr0LbiqS+8fmyWnUd5xyO
	v/hU+oDuHK0W67DM7idfhPk5QW98NGoyKAIyEFxXgx5muHm29SIH9qh8vysb9F6ykMWr9IY/7Ns
	6n81r88xnzkyZATrdVBsKvQHEDFtAEKHsfp8mtLUqY4acgWk0zN/DKPiToRkpajuM2BeDhzVJ6H
	kVImHeWvXiqoSAAbLRyYcKgUlb7fKXMP0VXXern1HGDMTo+slN3w==
X-Gm-Gg: AYBFou2SO9YcnxZoiQ6fy4BZ4QcR0fGcfSqHB0wmxzNJXn2Wc1LlloEA54izA7bslBa
	iKODE6yOS65vNhA+g0zmEg4CWyRUuShagvcLqT4Gulxut6L+6IDiA/GeMHgB4UFrXIjyCb1IX/9
	dRTGSHCsA9GxBSuXTahs8NrR0Uc+XKvQH/ENH9hF+n7u7N22pd4UwHHQjMQO603bU+F8F2quOvP
	bGZol6nOaiucwCbjQ1vNkfr8hX0L8g/KIUHTnjoPbmzCROzZujLmvGgPHbafHU5mN1wM4YK0ZbQ
	T7h5LGevyPh2b03R2JHP2fAolIapr4TIsK5aCCTG4s+ZmeqDpji/bUmb3AapDjbT7cLYQil/p+1
	YVCDMWIsEXzJfLRDvenC2SqoCSAbEENzKmzhsX5+UHvEXszTuA+lILqW+6bQ65wesE4YTwP1fQ8
	Qwx7DYAcszx0g4I9nzQIt2noT2IY+g3PXw0eiXEv+A+8RVaQql7v+/I4A5QUZOFdci9mNQOS6H2
	GDNNpcqCytKlVUD9074iWDXzQ8R7xyQTKDHTRLbhIT79LtdMSFDvgD4U5m/W4d0eEC1BQhNK8YT
	oml6m01AJKGk4NpFeglvno66WLeXnGFm1MGquUKGeM//XMDzrs6m0/9rLTddaFF2F2G54mqiMu+
	RxHRDCKvIf6EZjGhCUHPNpSocpdZeKbclbJDcdqxmOhD/vrRCOc8UF4t9bbuVLeOVRqWrqArrRR
	GH5LeuUw8hACuqVHjU5E3f
X-Received: by 2002:a05:693c:23c4:b0:35d:d671:933a with SMTP id 5a478bee46e88-36a20434255mr6982950eec.15.1793228904465;
        Wed, 28 Oct 2026 16:08:24 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a26d59f0fsm8156513eec.6.2026.10.28.16.08.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 16:08:23 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v2 4/4] scsi: core: Match ULDs to logical units in the ALUA unavailable state
Date: Wed, 28 Oct 2026 16:08:07 -0700
Message-ID: <20261028230807.61578-5-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028230807.61578-1-brian@purestorage.com>
References: <20261028230807.61578-1-brian@purestorage.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scsi_bus_match() only matches devices with peripheral qualifier 000b,
so a LU that is in the ALUA unavailable state on a target port when
the host scans it never gets an upper-level driver on that path. When
the target port becomes available again, nothing binds sd and the path
stays unusable until the device is deleted and rescanned. A host that
was already running when the path became unavailable keeps sd bound,
so the result depends on when the host scanned.

Peripheral qualifier 001b cannot be matched on its own: an unmapped
LUN reports it as well, and some targets report every possible LUN in
REPORT LUNS. Binding sd to all of those would create disks with no
backing LU.

The SCSI core now reads the access state of a device that supports
target port groups with REPORT TARGET PORT GROUPS before the device is
registered, and an unmapped LUN fails that command. SPC-4 requires a LU
in the unavailable state to report PQ 001b, and the command shows that
the LU is mapped, so record in the device whether it reported PQ 001b
and its access state could be read, and match such a device. sd then
binds to the unavailable path like it does to a standby path, the path
stays in the multipath map as a failed path, and the existing UNIT
ATTENTION handling brings it back when the target port becomes
available.

The decision is made once, at scan time, and not from access_state when
the match is made. access_state follows the ALUA state, but the
peripheral qualifier it relates to does not change after the scan. If
the match depended on access_state, a device scanned in the unavailable
state would stop matching as soon as its path became available, e.g.
when the upper-level driver module is loaded later, or the driver is
rebound, or the ALUA device handler updates access_state before the
driver is probed. It also does not depend on the state that the command
returns, which can already be available if the path recovered between
the INQUIRY and the command.

This is the same situation as a path in the standby state, to which sd
already binds: SPC-4 requires READ CAPACITY in neither state. The
unavailable state does not require MODE SENSE either, which the standby
state does.

The cached INQUIRY data in sysfs keeps the peripheral qualifier
reported at scan time, like the rest of the INQUIRY data; access_state
shows the current ALUA state.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c   | 26 +++++++++++++++++++++-----
 drivers/scsi/scsi_sysfs.c  | 14 +++++++++++++-
 include/scsi/scsi_device.h |  6 ++++++
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a21dee1d9e9e..b78b257b4b24 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -871,8 +871,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
  * fails, e.g. with LOGICAL UNIT NOT SUPPORTED because no LU is mapped at
  * this LUN for this I_T nexus, sdev->access_state is left unchanged. The
  * ALUA device handler, if attached, keeps the state up to date later.
+ *
+ * Returns true if the state was read.
  */
-static void scsi_read_access_state(struct scsi_device *sdev)
+static bool scsi_read_access_state(struct scsi_device *sdev)
 {
 	/*
 	 * Each UNIT ATTENTION reports a different condition queued for this
@@ -902,15 +904,16 @@ static void scsi_read_access_state(struct scsi_device *sdev)
 	int group_id, len, k, off;
 	unsigned char *buff, *desc;
 	bool ext_hdr = true;
+	bool found = false;
 	int ret;
 
 	group_id = scsi_vpd_tpg_id(sdev, NULL);
 	if (group_id < 0)
-		return;
+		return false;
 
 	buff = kzalloc(bufflen, GFP_KERNEL);
 	if (!buff)
-		return;
+		return false;
 
  retry:
 	ret = scsi_report_tpgs(sdev, &buff, &bufflen, ext_hdr,
@@ -940,12 +943,14 @@ static void scsi_read_access_state(struct scsi_device *sdev)
 		off = 8 + (desc[7] * 4);
 		if (get_unaligned_be16(&desc[2]) == group_id) {
 			sdev->access_state = desc[0];
+			found = true;
 			break;
 		}
 	}
 
  out:
 	kfree(buff);
+	return found;
 }
 
 /**
@@ -1217,8 +1222,19 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * Read the ALUA state before the device is registered, so that
 	 * scsi_bus_match() can use it. This needs VPD page 0x83.
 	 */
-	if (scsi_device_tpgs(sdev))
-		scsi_read_access_state(sdev);
+	if (scsi_device_tpgs(sdev)) {
+		bool read = scsi_read_access_state(sdev);
+
+		/*
+		 * SPC-4 requires PQ 001b in the ALUA unavailable state, and
+		 * an unmapped LUN fails the command, so take this to be a
+		 * mapped LU that is unavailable. Decide once, like the
+		 * peripheral qualifier itself: access_state changes when the
+		 * ALUA state does.
+		 */
+		sdev->match_unavailable =
+			read && sdev->inq_periph_qual == SCSI_INQ_PQ_NOT_CON;
+	}
 
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fe54792ed69e..4866b5f35aed 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -539,7 +539,19 @@ static int scsi_bus_match(struct device *dev, const struct device_driver *gendrv
 	sdp = to_scsi_device(dev);
 	if (sdp->no_uld_attach)
 		return 0;
-	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
+	if (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)
+		return 1;
+	/*
+	 * Peripheral qualifier 001b is also what a LU reports while it is in
+	 * the ALUA unavailable state on this target port (SPC-4 5.15.2.4.5).
+	 * scsi_add_lun() reads that state with REPORT TARGET PORT GROUPS
+	 * before the device is registered and records whether to match it.
+	 * A LUN that is not mapped reports 001b too, but fails REPORT TARGET
+	 * PORT GROUPS and so is not matched. The decision is not made from
+	 * access_state here, as that changes with the ALUA state while the
+	 * peripheral qualifier does not.
+	 */
+	return sdp->match_unavailable;
 }
 
 static int scsi_bus_uevent(const struct device *dev, struct kobj_uevent_env *env)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 691275db0677..b9540a412ae8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -196,6 +196,12 @@ struct scsi_device {
 	 */
 	unsigned is_ata:1;
 
+	/*
+	 * Set if a ULD should be matched to a PQ 001b device in the ALUA
+	 * unavailable state.
+	 */
+	unsigned match_unavailable:1;
+
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
 	unsigned busy:1;	/* Used to prevent races */
-- 
2.56.0

