Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD3337B00F
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 21:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067632; cv=none; b=sn6OBeCNGbTbKT7loLksvQd+QsduolIj0qMPlZ4AjPpAujbNcY7hCsJDPu8vQ1DFkVJrWiMbAVfRYKCur0pqnN2f4rbOdB7ymkSqB/kZs0FwHS/ONtaisfgIdn1R5AqGEKB00cGsnEl15mBYBGqRGqXepMYozF/9ETQGMQ3nJow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067632; c=relaxed/simple;
	bh=hHGBfgsFIS/fWaYBP6xUIEFJGcQYMS1nVd4GseMd5fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYkUvpkzroARjBEJ9Y190tV/JGFJIMi7kokeeo+hz1eBdNsjKueGOO2S7TSHsCt6OGOe5n8hO3nlbIq09I5r+YVP8TXjcjbmQu2uhGuAq+TQWDtTyRQBIRRQr2ZOn0evsGknHJPDoDfRqmFSn7spcHbny7bbOp51l0lLPCF2mCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Sp8y9BmF; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Sp8y9BmF"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2e221a71e19so8200813eec.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 14:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777067630; x=1777672430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjwOH8dh32lYZxv/xF+3RovylECSf2Ua18MpEZ94hIM=;
        b=Sp8y9BmF6FoMPcntNwhPbOxvZXpw4aELirkHHVOgkZH0z72mK83aZkLHWtm2hCYeO4
         36C3HSMVRHuKvD5I3NVzbYv3bz3HdZqzqVLJS81vlllQDsTwfWDSu/d7tcIny4jLEzGi
         eD/kAb7aZ2mW6T7K3qTxUrzMwDXjeQ1bjO339JJRWNSbHp0wOenHOpPxlTTzg/PBCBzD
         ODI90clg6pDm3e04+AabdCHkZ1zcQprQH1iNL0Sk6zDy/MHfZRc/HO8CLbs5mTvVQawe
         N0OITfsrd9BDEQGOdkaLGvxkFieHxgqLEZ1gnULW+izNnHc8q0+t2gVtgU7c4OVpIQwk
         s+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777067630; x=1777672430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xjwOH8dh32lYZxv/xF+3RovylECSf2Ua18MpEZ94hIM=;
        b=KvTjFXc59JF1qYbkI1Y/LdjVQztIo9/nX9TeDFCIY32OmBsN70TVbXEu+FmmyxUqVx
         8GErgTqfNnA8ZJRBSEFRKy18HXVc7cIL2ufC4kHz88w4J093dfhULvbNNwHVwS8+pcZS
         pzkKo2gkAJ1eE+oKIpe2LHJhIswuz36CcPQ9nyPfB4zA4ZQD7lFPk6qrYB5Xeu4BcfTD
         98TzmdwN3OhvgfXMpO/nEBRl5Bt5axCyloaPBcxhHFlR+iW4NHsVuReXsCQl3yHtftkY
         tr/orA/lhqhCV+o2oi6q9ZLMeOnOK9Un7qCQVkOaOD5OwG0JiJYxt2m5LMVCgpDzoS++
         PNsQ==
X-Forwarded-Encrypted: i=1; AFNElJ8qp46/MdPjko1ywVaqDMLfznYlCL/2IC/u9RlliwPfHGSv+tJuBvvc6gpLFw8j+brxYKSzlkhc2hcI@vger.kernel.org
X-Gm-Message-State: AOJu0YxiA22sYHzTxIi+s1HFZkQvZm71BF5o7549a4THcx18YY/iFkSc
	fUZRQkmqlxEskpzO7OD91+RiW97upiXnkReLs/t+lDtSHX57XWIP4cJu8RbKfbZ97AxK5inGYC+
	mix+efuQ=
X-Gm-Gg: AeBDiesTLD5unHnixYzSEw9pkseo55s/0kglCJDAJblznDFO508nC7yxTF8G7BNSugk
	LJQ1jTYjhQEd1PxP27nb1oGPQipioOriMUIQof8nWPJIinEzBIUcsN+3GT4C2iqpArp1Wj7OtTJ
	yBzB4ipUkS/MMW/6M0NNluXxr1IB8V0EEdcNI/LEkr5tfObyC37RTwjsicx/XiOtGTB1hYOe0+L
	qtY+fToORQ7fgXLxul3kU9GI+6/kRPLAeKQ7az0Xy29i4cpgad3pd2qmGxJkiblP+YDjJOIpvpx
	9l3q5YvIP+4awevMkxFinF+LEl9T8L92z6MRBRlGs0UwO1GWzq0LIrXONY6QWTLveV3fMpsD8iU
	C1jIQV700nqhR9qvey+EH6sumPR6zqXQlKULQpq3prWKfadxZydGRCYbcbU4Mc+CQ4WRaT+nyNh
	ol5nIM5a0mB4uYTluH7RpJ9ZvkALNqLibe8vH2D0x1AA0Oqe2mqKGJ6am4rU695kb0xmFJwgulT
	fXghdr9SPm1+wH1np25vkTvlM7WOqnaLTjxGYZnkhe0Te5Aw9NPgBohoYhShVdaqepy+RcQHTXm
	QjABZ5chLQNsKWVw/Wy7dlEamRczApGEiBU=
X-Received: by 2002:a05:7300:d70e:b0:2be:1f58:32a3 with SMTP id 5a478bee46e88-2e4878d65b0mr18167398eec.29.1777067629495;
        Fri, 24 Apr 2026 14:53:49 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e539fa5c38sm33172246eec.5.2026.04.24.14.53.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Apr 2026 14:53:48 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de,
	linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 6/6] scsi: Handle reprobe for existing devices during SCSI scan
Date: Fri, 24 Apr 2026 14:53:24 -0700
Message-ID: <20260424215324.99045-7-brian@purestorage.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424215324.99045-1-brian@purestorage.com>
References: <20260424215324.99045-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complement scsi_rescan_device() reprobe by handling the scan path.
Update INQUIRY data and reprobe existing devices when PQ or type changed.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 91 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 83 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d54f64ae80f61..514b633d7182e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1129,6 +1129,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	bool is_reprobe = false;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1136,7 +1137,32 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
-		if (rescan != SCSI_SCAN_INITIAL || !scsi_device_created(sdev)) {
+		if (rescan == SCSI_SCAN_INITIAL && scsi_device_created(sdev)) {
+			/*
+			 * Initial scan found device in CREATED state (being probed
+			 * by another thread). Drop reference and allocate new -
+			 * the other thread will complete setup of the original.
+			 */
+			scsi_device_put(sdev);
+			sdev = scsi_alloc_sdev(starget, lun, hostdata);
+			if (!sdev)
+				goto out;
+		} else if (rescan != SCSI_SCAN_INITIAL && !scsi_device_created(sdev)) {
+			/*
+			 * Manual rescan of fully initialized device.
+			 * Reprobe to detect peripheral qualifier or device type
+			 * changes (e.g., ALUA state transitions).
+			 */
+			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scsi scan: device exists (type %d, PQ %d), reprobing\n",
+				sdev->type, sdev->inq_periph_qual));
+			is_reprobe = true;
+		} else {
+			/*
+			 * Either initial scan with fully initialized device,
+			 * or manual rescan with device still in CREATED state.
+			 * Return that device exists.
+			 */
 			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
@@ -1151,11 +1177,11 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 								 sdev->model);
 			return SCSI_SCAN_LUN_PRESENT;
 		}
-		scsi_device_put(sdev);
-	} else
+	} else {
 		sdev = scsi_alloc_sdev(starget, lun, hostdata);
-	if (!sdev)
-		goto out;
+		if (!sdev)
+			goto out;
+	}
 
 	if (scsi_device_is_pseudo_dev(sdev)) {
 		if (bflagsp)
@@ -1170,6 +1196,40 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (scsi_probe_lun(sdev, result, result_len, &bflags))
 		goto out_free_result;
 
+	/*
+	 * For reprobe scenarios, update the inquiry data with fresh
+	 * INQUIRY results. The device already exists in sysfs, so we
+	 * don't call scsi_add_lun() which would try to add it again.
+	 */
+	if (is_reprobe) {
+		bool need_reprobe = false;
+		int update_ret = __scsi_reprobe_inquiry(sdev, result, result_len,
+							&need_reprobe);
+
+		if (update_ret < 0) {
+			res = SCSI_SCAN_NO_RESPONSE;
+			goto out_free_result;
+		}
+
+		if (bflagsp)
+			*bflagsp = bflags;
+
+		/*
+		 * If type or PQ changed, reprobe to update driver attachment.
+		 * Reprobe failure is not fatal - device exists, just may have
+		 * wrong driver attached.
+		 */
+		if (need_reprobe) {
+			if (device_reprobe(&sdev->sdev_gendev) < 0)
+				sdev_printk(KERN_WARNING, sdev,
+					    "device reprobe failed\n");
+		}
+
+		/* Device already exists, just return success */
+		res = SCSI_SCAN_LUN_PRESENT;
+		goto out_free_result;
+	}
+
 	if (bflagsp)
 		*bflagsp = bflags;
 	/*
@@ -1252,12 +1312,27 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 			if (scsi_device_get(sdev) == 0) {
 				*sdevp = sdev;
 			} else {
-				__scsi_remove_device(sdev);
+				if (!is_reprobe)
+					__scsi_remove_device(sdev);
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
 		}
-	} else
-		__scsi_remove_device(sdev);
+		/*
+		 * For reprobe case, we held a reference from
+		 * scsi_device_lookup_by_target(), release it now.
+		 */
+		if (is_reprobe)
+			scsi_device_put(sdev);
+	} else {
+		/*
+		 * For reprobe, device already exists - don't remove it.
+		 * Just release the reference we got from lookup.
+		 */
+		if (is_reprobe)
+			scsi_device_put(sdev);
+		else
+			__scsi_remove_device(sdev);
+	}
  out:
 	return res;
 }
-- 
2.50.1 (Apple Git-155)

