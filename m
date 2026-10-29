Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793233547;
	b=r2jQfKbaI82VuquXCb6PF/BapPlXYHX1wDGirVT+34ZSJIgW+DPjP/QCE4NbC6qEUqxM
	 fYpPhEEJ1eWqikzkNo7lcFRN/7f8wIrxw+ki7kjeLNfTy8CTeXrHLH22sXFfVgrlc35aa
	 T5OhP9282c7AmGRNaiIyDiL9Q6Pvfj8yKcr1gK4rh2T5rEBgUy3VdK59XEIFoWyjugioo
	 Vg3gXUGVuiIjQRsS4XKyh0lGsZgrWCG8PSjqGfGBfP05JMBqAMa2P1/wAUpInHz3x7wvt
	 Q13EBN2JrhOVTmbtVAZmZuhIcgkftusdd87fkh9frJWaPzA2/h8I+v+DxXT0oeVRRSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793233547;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bhlsdshfnNZCJFg367rxdQX1Hi8PPLBCauvPnVoRPhQ=;
	b=m/c3rQjIJG4QR3WJVH1cnBjx19mMys/BVOOFnL0FXvam9fTPWD76CpCEkeiV+6DFa6Rd
	 5yx6Uc+FmrXlHQaSZWiWN1a0qbiDv4ZCf72Ndr1Yc2S/jVCeI8qCxgkW4MZiXj3uFmhiw
	 PsDgHolPqaO+WUSAvO270RileM0RVStLJ7usDUoMUXRVcCWmnZRIiDZZ5Q1Abd6e77SFY
	 0mPGOtWjsSRRwMPvDx3fJxFnwLp4IlQVBco1asrxF2Fbfac9a4q613AQSDjrJOAvEf4dz
	 eiso0Am0Xn0CkrHJKxsmoPDFxolgq9yCd4v4Jn5PzLjZfWklxMeAAdzqJj3cmavE+JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=LzwWhEqP;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A393606A31D
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A393606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=LzwWhEqP
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso1891272eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 17:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793233546; x=1793838346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bhlsdshfnNZCJFg367rxdQX1Hi8PPLBCauvPnVoRPhQ=;
        b=LzwWhEqPL+yqWpI4wPQa3bZF7xRdyx2WFTf5Xu5QkROiTsHM6g9slJGAFOcPrDVlJS
         vg2OgxPhflyFmyW+fWwT/e8A6rAW6CG4ifQbQEq7tx0F7ZcC2dQpGUJLkx5CmEhOWAuI
         PC8kZ3Nob7V/4PC3Nkmk+kPUqbak7+yTZbmbmOsyVWj4FbcnRoOK4jGgbz+nl7pJUEIh
         2JpB0YCL5SfSOpWcw2zYb5F0pfpwgCyHrnV/qJhAxDY3HRzqJ/S5Uv0n4aQdFYOh2ErV
         6mB2DiKxh9ZWnhu2uBPyb4sxnVtpAd017Zs+9sZLCdH1QP4bs2Zn0NoyBGma40pFnwmD
         HPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793233546; x=1793838346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bhlsdshfnNZCJFg367rxdQX1Hi8PPLBCauvPnVoRPhQ=;
        b=ipXklfL0F+J85EzOarxpNbZBExn1vpWFlHYXXGTE7hJubzzp+ruOAN7UAcwTacwcDB
         hHCoEs4rK0dlRekqXtkXQBqHsuOKric/Eq9/fX3kPhAXpGrZpMxs/R4Gdu1C3Ga8dEUf
         uVYBflgIIJ6bVXpwaulChwJP4/d4hRFmiUcxe+NRt4t2ptLZakJjVvkJ0SdWQECTWWe8
         LA3BOi3NjAh68zQDDaX8WaarY2/0N4AIwjiIOEoZKLGZw3wSPjlBBohY+iuNFb9+CGkc
         tU0J79VOACkUDLM+A3cR7vFHG2jEtCSX7ZUyUhnmPevRLjwWtnvA61CI413S/xCvxprC
         CIng==
X-Gm-Message-State: AFq9FYIIUm4qVAvafgMH2sXanBjqEKZcR1WSu+VWrS54VCWcHSCKTsw1
	orm4ukB/7HZCQ3+qB02d9688lAnSWqeTrVh5xVx74kYYssBoFDt82UORtMzyf38YiXlBh04x8H6
	MqwQTJK1U5N4Vnt+eFiPInS/rZumkclGTDtf2977R0xBw0RabAYCyQ9MNVytp4lxNyGCRUM5uHP
	KWNcyjcA6EE7veYWcapyxehFugPJRsL1q5dCOeIhseeiAuzFOYNg==
X-Gm-Gg: AYBFou2RetfDPSeLfRoiuy+rMqHgpv20GiJTA8BEynaAxv4KmKZZBE4r1pIeky+XGs6
	FBF7odu153dFiMiIM7RtoXr3SJL5YxKvXj1z9UFXDhSqGjhDoVeZZ6xJTdA8eZtz4mhH5DptjcV
	C5PE/s4WS2KmgGxvD+pWFMqoijAYN0i9xlAeGSyGIB/hFZzwU/S/kRKoSh4rvCudg8FX9fQzfJO
	szcZp8CBZmq8Q9DLceIBUbpxwYZKxP4RdJ2YUvFziZR5JPVSJaxv3bNDGCH6iyNeJQCqPho7ERR
	yL87LBShgBaJKOLH7THxr349P6otH+f0gZVh1l/+mZJjlus+iAdXYz4ecwAwPf1Lwo5rsinqFAh
	A+X7C8TF2tMH+f7TzexBo+Adyaw8JSR2VKD7YQkEyfuXFp+lIIVzgyBUU/OdbezVzSlbJlbB9+b
	lNHKR2mxqsGYQvqyo+xR/AyT0zUamx/LP9ZEw7TuqogAWRLMabLLTiehlVvZFWV3t+ZXdpcbkS2
	r9TQihle6gDl50JpPQo8tVTfA5N3TWODMWmOY+NBvF9pR+43SuVzA9vLTlmS0E/NgZaFhpxvv4D
	0Y6G1DATIYmW9u8Nrxlt3X82fRe5th8/kf9A9bhIncDCG+YUasQrqcuPjm5x9+oJCsjzo06KM9g
	oiwQzNXylGeNJ1192TAS8hEg8W4QltbW4PMaqB8yLv5Btl9pRmu4lQySelPDxrTUpJ2FvR0tiUT
	bqHXBZsg6RQs/C5om65arfOZX7rw==
X-Received: by 2002:a05:7301:7c12:b0:35c:ba31:6fef with SMTP id 5a478bee46e88-36a2016c61dmr8056488eec.36.1793233545869;
        Wed, 28 Oct 2026 17:25:45 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a239a2e29sm11294226eec.26.2026.10.28.17.25.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 17:25:45 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v3 3/3] scsi: core: Match ULDs to logical units in the ALUA unavailable state
Date: Wed, 28 Oct 2026 17:25:31 -0700
Message-ID: <20261029002531.82824-4-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029002531.82824-1-brian@purestorage.com>
References: <20261029002531.82824-1-brian@purestorage.com>
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

