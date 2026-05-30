Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0069213D53C
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 00:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100451; cv=none; b=dxSYQTt27rf2f0FxUslLaoxrbyETV3m1WvGRY8Kq8OQPu7K3dR+h6T7XBy+uExStSCISFl2uEggrkdNG7i52hc+bx7+bS4XiEOp5OAQgDdztu6R4qniUXyr/bD0snShEyyRg52nc5GUO3KLQULhtb4IpDMD/e6Tv3dHqLyU/uD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100451; c=relaxed/simple;
	bh=gVuLHuuWrm6jB5XTPw8YDzVNHdXcvEm26u9ULAlgsfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfMpOGwKx4qoxTMrYFB1J86ll9In4Jz7nyjdrKunvVeyid990bDDMH37tduo9Q1Y/CeGOTLa0dxKTzIQN02sM5HhlpT7kLX+IPxBOZEfyMdU7cUztF44g/QHRvg409cDoliLf3LnRNSzZ6kyeuevuKJTyTAFs24K06yHH4lFcQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=f77UyRR7; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="f77UyRR7"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-134fe980658so17227427c88.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 17:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1780100449; x=1780705249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxtMZOet/chLxeMQSrtUKxzNBtCgiJ6XXEjpeslIupA=;
        b=f77UyRR7aT6Rb2MmsdHWLtMCRmfixJXDkCzIKpBYl3oSppKdfmeGKWAGVRv9gN0OSG
         Lo9aHck2wnftOScfrx5voaZvW2ao2hoVmCX2mn6CeLwgaBKxXY+5/bagSDtPsC3OsVAW
         ZMRaugzO+/JaGyCbFlr1/mmPSMT0Y/OtDgasEAAdQgHPgXIgAt/qznG89Ymwbv4pOxx5
         rdsYnEiNc7BcQWRp+gtOyE56qasxNB5dvVRhHVPzzQLHNiCNFwy6NxYgfKsMpYkjuell
         hZQH984jp+bcTwKoSGoYLmbjfA5Sy/KhuNJf+nYGgQ6VjC6aMrZvDdhqV8STq9vBDiwY
         FL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780100449; x=1780705249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RxtMZOet/chLxeMQSrtUKxzNBtCgiJ6XXEjpeslIupA=;
        b=fn5IH6g6r3Lzz+WRcCkOVHtyiGpjzZ3kj0Px72pgYAm8Cr6myTj2kLdDsyNTeE84JT
         8TWPHPs8BLshxVmNWbAyXBeDL+bQUY9oeMLFrk//yVN3MPhkRQRrNAQF3c3JRucEN2Ug
         VUNgFs5fXYZMYIQe1Y1xtpApWBNXzVCFZHoMUC7hVzHftYVJRUugxy+ybVZfkUc+NaP+
         si+Gbic6EhxRvXp+IRHm/q+F5KTKM+nPp+AvsG6bab4WVG9rvaH46Urmc9dltGWULk8J
         vp8RMEHYJki90omcdmapa4GHVyU/PbE5p6CtBdH5XIENboFK1ugyNCChVn0KU3p2xHfI
         c2aw==
X-Gm-Message-State: AOJu0YyhkLkrlANlNmyiBiQMIEnV2J4exx5P3l0pOAUSZvgOHz6T5G+1
	u62yY3NTOxxo96EsW77plyRh/v3FhDNU7HWt6QFLBQCW6Wa2vyC/6QmbJJ9CE5UL7Qx02FEbBno
	nAJj/3+rXpQBWGGrQM/KhB9K5Ahd6ONrx5teDLgNEf05GVHsj5WCaU+qNsfvDMZTa5/oZvvGreY
	cq3R2F/MN29gXlLykx6deEvgk6zQ8e+6LMPitvknoX5zKZ1NfA+w==
X-Gm-Gg: Acq92OGZ1AD6PgktBJDA4ir6jt8VyjJBXOaNY9QZNRE6RtvjHDCswXsJdX6vM8pT4g8
	Zcv+EbTO11GVAr+vFZDcKWwtweFVBTNbk5snDcFvxznCaiFxfoWT15B/rvmBL+XMa8tS8DvpkDx
	sTJAerFadxrglZFhsl9mlzp1TSYBWTrrE9DqwmpT0i14RHlfqc5MFsLYb+bact9II27Ji+4eG9F
	MfBaqC8oZFN0hAu9rwQxSeZlafUPs3VnXtZNWgi278AHeTmbEAjo7zC3FfxgIjf+ggDgUd3YFNg
	Reh9fnKPUWtoBTfLcH152mtKlKZxAg4NCdwESp6mzJmvJ01hNJ6/jjfC4S0ruUtoH571VtZLv13
	Z4mk0LN+ybiR2BMsrsc6AutaYtczlmOxfVsKfI3PpcFJqfEvkkgLaY2tnf+uDSlyKcACPNNQUOE
	7Rnu1JNKAh9MR6Z3UOeFoczNFylnRO1ItCFEk3YzWv0qMU+yAAycweZ7CV1ixOq6B9NTjfeaUWi
	Enuaw7BvbUtA/AufRI4OVKNxpZjYIoBz5B5JOBMbToyXkUPpbkXU7ICyy35stsAZfjejbxnisP1
	jr8ciP1Eqqlp+A1bkpXsK6ADz+dNvwAOqG0=
X-Received: by 2002:a05:7022:4b:b0:130:c9cc:3395 with SMTP id a92af1059eb24-137d413272bmr795912c88.29.1780100448949;
        Fri, 29 May 2026 17:20:48 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.115])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3d8f839sm2027163c88.15.2026.05.29.17.20.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 17:20:48 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	hare@suse.de,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v4 5/5] scsi: core: Handle reprobe for existing devices during SCSI scan
Date: Fri, 29 May 2026 17:20:19 -0700
Message-ID: <20260530002019.47109-6-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260530002019.47109-1-brian@purestorage.com>
References: <20260429224939.77082-1-brian@purestorage.com>
 <20260530002019.47109-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complement scsi_rescan_device() reprobe by handling the scan path.
Update INQUIRY data and reprobe existing devices when PQ or type changed.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 91 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 83 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 89513f341d84..62f524e1757e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1206,6 +1206,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	bool is_reprobe = false;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1213,7 +1214,32 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
@@ -1228,11 +1254,11 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
@@ -1247,6 +1273,40 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
@@ -1329,12 +1389,27 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
2.54.0

