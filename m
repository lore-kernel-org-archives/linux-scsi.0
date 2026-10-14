Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC2B3E44E7
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 22:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792015261; cv=none; b=lJqoIVqhqhmRKtVssLaQjipnHMLN2LVACPIcCKV+Kl4ceeUCB/UNiyV7EG2HOINzJ4zM2ByyNOTA2lqykq6AyjCgfpdrJOjVrtvoX/ZJ/qtCTU4ZwBjZsgs9zKhK462AUexnyrlUj2OQNsDEVLHqo0qzWhxVDbIN8IxPFwnwqGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792015261; c=relaxed/simple;
	bh=OVMGk0DIaZeo4BtaOiwkmBKl1dvEOlbHoEks+h7tb88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8w8vs7YcgG8tg4818S9OAkyPGUruY51kFZHqvan9PxRwAEr6VOhlY+xELCQjtLNy7e+8mhRZcFph2kx/DVYlwa6lnHwlmo+xNI0HZP99xFkIRwY4/7CqCRTTeCcYHWwlVLjfY/ZqeBi3MWkx/B4YK66qFeyKHT6DPynFTvYarA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=LGFwWWHy; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="LGFwWWHy"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-35a31bb9fb6so6273841eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792015259; x=1792620059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vqcKdnjz9GKAU1pPan8uzA6y5uLOoqMX5K/Gjl+RmXA=;
        b=LGFwWWHyLh4vZ0RlR2MxW0dBWVkBDedCVcYLZedJUpSmiezjQCQlx0D0bGuRsXrk1n
         yDXFgpXJSPRkRbE2UQt/LXKr1kFGipUsnuvif53VuvNBZ7AE9ePJUc3FpBvfX6Oj5DcG
         xCDMr0pbFGTNZI/6ytojykNul/weao+fTsA69SqL+hXmyPkk3NwPNjfEl5XSWf5AFCvZ
         LRuANQO7TH0ck8EG7Dgpqlejf+VSD7q1PMnmoFwJD8nDwjUJhemm0et15yFCAXMQ/FOz
         FNGp12Fcdlc4fMoPIqqxtuR7b+gJlD2IR0jwvcufoO+n/k+GS5QpuhlgrHrptxsijb7l
         owbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792015259; x=1792620059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vqcKdnjz9GKAU1pPan8uzA6y5uLOoqMX5K/Gjl+RmXA=;
        b=dFLKLYvlO51ttKP3gyyOup6k5IYr9D3ALADmL2YtYDV78jPgdVit+Xn4e2xYscKwKG
         2URR/3tD+bmY+rwmPmlKcpLw97aUpivVrjq4yDqEukKi8j3KPQISjPSLBYk8a5ySfDjP
         oRoXDFCFvBLcAq5LXcxCvtoC5+C9IgAqznpOL90O2+Qxn4aHjBAw/PAWUoiTKPBQw17x
         7ejVPtHihJmb/p3qg/zkw3HvKhvKbjvi2+Bi3kKjLqaKf2ZWNjnG5eFV/gXUQvhu29En
         RwULneDG75VN3DTimsEUe9YUOT3VK1p/pixgWGJFqNWAeTrOp2+1GGF767AheHrX+/4c
         gR/Q==
X-Gm-Message-State: AFq9FYKCvk/6wvnU1GNbq3JoYEWn5VnyDbIMIDJcrZgfr/tnaJmkMMgW
	uKq+wwSi7iEheD2TmZU76Lg3JJuhkvzNeFmMND8NnWmyA5hTKuxAKE/fLzPfVcE1+P1H8bLvR5u
	dL6cyvNfMN13Oct0NUhC+U/7y+UED20ikbRFalK6hbY7v0+OdGd9IgtctMpL6nER2BKtQEeQfLJ
	oEnj2ET8VE0/SQWXkKX386owS9nrhhk6BXkhs60pn7TkVUxThDkg==
X-Gm-Gg: AYBFou3Qf84kCYYfh3lWhE8R1e6A5DQ/GARk+n4xm5R4iCNKlUlbDjMHxkAfEIzTO3W
	slIU137DbNPwlpgBnHexExanOthIEc2hCx1j5YSiFweruhfrFJNNWhwrXjd2ts/h/eh4lDgosvD
	RZ9DDcjpyfa61T3qY+ZmzoM2IQawwkuwKODHVeFR8p0ncsTD8Oi8hYJnvs7L4567ihfmGJJ8sU4
	bjDCCAm/0scmlUajAuP1IlhjKyBSa+x6eK38QyBMpFsWi56Ly++ysDpoUBsNWeGhZ6ksMjdnp7T
	1SvRzM0zlsUuDyifEE7Wihw/JnpzoLIB9YA9jXuJRA5Shu2UVDUJ2Kl/VNBmDv9lLp+ibo7kRXo
	G2zeVKWfxd6wDLrLJbPSlQYmDJrpu3tFJlKR1AD1bnYrrI6AjS1467/zyLmtB2dVmMtJjFX3RDv
	bqNtymsDW/ZpZUTt55QEOf+jRieLhrFIVEeJbsC6yZCRsLGPPQ3/yb1xRbo9kqakvAyYsGhy24M
	nE7t84rtPq56rNu1RXsM2avmFaIJ5Yc418gUNRG6Ivdd9Gsq9lJ9ugpQDvwFwQdpqytk7rzy2Ph
	eh7PHUQU4Qw086BEX0RDIQhVpkTgILIaJYsUx4X6sHGq5+ZOoF+Uvi7oxx7h12urJz8738LU
X-Received: by 2002:a05:693c:895a:10b0:343:9eb1:9940 with SMTP id 5a478bee46e88-3537e0270fbmr23992138eec.26.1792015258445;
        Wed, 14 Oct 2026 15:00:58 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b19c6c7b4sm30236633eec.24.2026.10.14.15.00.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 15:00:54 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v7 5/5] scsi: core: Handle reprobe for existing devices during SCSI scan
Date: Wed, 14 Oct 2026 15:00:14 -0700
Message-ID: <20261014220014.94330-6-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014220014.94330-1-brian@purestorage.com>
References: <20261014220014.94330-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complement scsi_rescan_device() reprobe by handling the scan path.
When a manual or transport-initiated scan finds a LUN that already has
a fully set up scsi_device, call scsi_rescan_device() for it so that
changes to the standard INQUIRY data are picked up and the device is
reprobed if its peripheral qualifier or device type changed.

The device lock is taken inside scsi_rescan_device() while the host's
scan_mutex is held; that lock order is already used by
scsi_remove_device(). Pseudo devices and devices that are still being
set up by another scan are left alone.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2c848265c9b9..ea54c9cf9f0b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1154,6 +1154,16 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
 			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
+			/*
+			 * Rescanning a device that has been fully set up:
+			 * refresh its INQUIRY data so that peripheral
+			 * qualifier or device type changes (e.g. ALUA state
+			 * transitions) are picked up.
+			 */
+			if (rescan != SCSI_SCAN_INITIAL &&
+			    !scsi_device_created(sdev) &&
+			    !scsi_device_is_pseudo_dev(sdev))
+				scsi_rescan_device(sdev);
 			if (sdevp)
 				*sdevp = sdev;
 			else
-- 
2.56.0

