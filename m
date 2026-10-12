Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAF34BEE3B
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839165; cv=none; b=Q3foUHQflLtbrlDcMjpd9LDRY/9hrSUQ+908K9KafotgdxAYpuzp039w8is96aOgtosaJBMuaEfo/qhm1qK9CBAQB2UZq/kfqE3nkg5+P9Mms0otYIRd3JtLg5keiBwlBeJHP+U8OHqCchVKX4V0PZ5b1UZaGomOzDGLJny4n80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839165; c=relaxed/simple;
	bh=1yLU+JDE9U6v7t10idDgIQ31J2xV6ke1MIB0EsI1zaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8qs3Ke6WxlLMlnlKO4y0ALMKMPJM4MrR/qDap0O719V+k0BY1+fX/Qy63binPsB0zxZ/7wjaYDStGnblop5kqKHE6jngpxAJ5seAE/XJaEoljoM78j4zHrnx6zxmq93YRB9qKKqiWOYqHcNY/e/hB1S7TeJMCnsQ2Xc3DeK+LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=SAghfdRU; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="SAghfdRU"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-354ba08cfd1so4020816eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1791839163; x=1792443963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hhWCMwErtxsKb6kwQ7Y1pLF3Gwu4PczSpzLFWIP+EsE=;
        b=SAghfdRU2ZYwLTS5QkmfQEM73cfsVRynSgnZ6aFrWxMPtBrHe/VuZ4S8krlv6XuEk0
         IeDC+HojPnKSUeUuT6MBePReJYU+N0VwG++1EUp0jyWzT5+wJv5+0zVtduyAR1KwA8Jq
         Ys8082yOww4xl1boRUI6Qucv4v2aue7Iltmdc2AZZ4A+xubJMqDXB617FnDd3uvMZGHK
         VB8oWFoKzRR8FSRi5z8v41/CdT+4m2R52nwKbUY2MU7nZFmQ58fF+BlibKlcIdTATNDg
         gFPlMu7uOvB/QT2KmLxdAq+otyhz6nLj5qdpSfYj2/FMnCM/It1VM8XduwQ12n2z6eVg
         zyGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791839163; x=1792443963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hhWCMwErtxsKb6kwQ7Y1pLF3Gwu4PczSpzLFWIP+EsE=;
        b=M85/qQsdN2VfPNmi9112kE6BzwNqmMKbQAFNG2L8CJYMaTpvMKjRyZZ0ufBJxgxSBN
         FGzo5YQM5spY+vffW0t0QTYnYGPI323gXFdXVzpZ/jYwR8nAlqSHFuPH3vWCVAkkmlYz
         Pwik8SwJHQnWzVwqnk65xwF4/BrQ8FNwg4zEolC+3vrKT+YvKhSroywx9Yq3rIXsD9LP
         6rWA9aqjfHRs8xxmgRXxfW4VPREEtza3GqrrNy+QtlHOo17w9nBl/rl3R3AHs56JFVb0
         ikkCTXeTpOtBNo2v8+mfYWM+625u7LAIIFVO6PDQXrFpxdEKV7HUPUO3eSAw6XXKMUnW
         5pwA==
X-Gm-Message-State: AFq9FYKm3rVtMIZaqgk3ssZXLvU/PgA+FKDXDLhc11Y3FDyDwvipmlZZ
	M5D/F5xx5A+h73x9mcp+3OC7XSR3xDzV+eywQI0kn3qDO6vq4gZGya32z5OXNfTkpYSt3jDiK3Z
	ZyPJU601ARLtZo4LUO/R0bxvh7Lw5NzmAjMq+WNfm87vl1C3xXELEa70vg85udF8LMgyeXn/0WO
	3YBeojYmEug1n2OseaeQzB27DRZotKjaY1G+9/PyylfsK/vcBHuA==
X-Gm-Gg: AYBFou2Ps9A0ci7Yu+Pbv44kaO0NnA1cwCk+bKWSKu61Fp+OSMyIDKiPCX9W4LwqFK+
	Be4cdNbC9F6tziNIQheESFUm5h9IFXMWpjsahbyo9c08SwpqRJ2cwmpEpE+LAbIXuQZchqMrVbv
	XGO9b0cS+xy0eoOimKj+8RUcSU/4jbLjS8JCIEIU+kAGLUbeCLaDZcX4RDRf9kyUWlBEAnLLjKL
	VVE+FgQcKUrsK+/yKHQHIGsxEj4Qr88Np8G8HY3KVywnsV2EQmtk35xPfDMTJx+uaHRvOr8Vo/o
	ivmJx5mOXCTQ1UtgoNH5yPooaWrlskh8aiXtCtkkKdc+ceRCw7ACZ9ziK1D+0vMm5vGxmnE/6nL
	kDasEJwDzkrB3idv192xwQm4doIRycxkAyulDxilFEQ28dRql8ZSVkCxy5G0Fic0OIL01ubSUSs
	eMuLRi+VfT1/MDZh3L72vC+U3FfOb399TQSM5pJFFrifAyENrMYl9C1Nw6tp9mT/qoRxqcKKEIG
	2qv9bR6MpOobhy3FF5VLocBKbKNuilMlVI/Shu27xiO8cbFIK367/yBbZJR16dL7dJIZqBYvw/+
	y/+/j+bb4TvH6HNS1V3BW3vlh8lb4/3wPsjkoG+0QhhP2YKuKd+NAxdAbvZSKZa2J0i76hw=
X-Received: by 2002:a05:7300:f402:b0:359:ee24:502f with SMTP id 5a478bee46e88-359ee2452demr7194626eec.17.1791839162775;
        Mon, 12 Oct 2026 14:06:02 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.201.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb2fd33sm35528777eec.28.2026.10.12.14.06.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 14:06:02 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v6 5/5] scsi: core: Handle reprobe for existing devices during SCSI scan
Date: Mon, 12 Oct 2026 14:05:06 -0700
Message-ID: <20261012210511.16061-6-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012210511.16061-1-brian@purestorage.com>
References: <20261012210511.16061-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complement scsi_rescan_device() reprobe by handling the scan path.
Update INQUIRY data and reprobe existing devices when standard INQUIRY
data changed.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 91 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 83 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ddb92282d49f..6df140d3c748 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1208,6 +1208,7 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
 	unsigned char *result;
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
+	bool is_reprobe = false;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1215,7 +1216,32 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
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
@@ -1230,11 +1256,11 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
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
@@ -1249,6 +1275,40 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
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
@@ -1331,12 +1391,27 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
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
2.55.0

