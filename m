Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7725A30FF3A;
	Mon, 25 Aug 2025 18:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756147307; cv=none; b=BObs9c478ONCrelgAfa/LHvt+h6vEETv5ivkv1PGFiBF4mC+U4Bue5szoBBs5J84gUheQso7FN6w+AZEWY6OtK12zmJXAwLRtFAATqeYGyZrY7rgGCnUyrElavh6olRaYXYzjbH2xc8TbW4jV/74H+k25dIxC0khTByAFeYzrns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756147307; c=relaxed/simple;
	bh=lskP3OTE/HVwgQmUtjcx8Ff0gt8uvmrmqIxG5M/3DSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVEnZWhaNBpLHMLZuNqvRre+N94EvQs70KSbU/XrtHXgUU1sq98Gqd+PfalCAuhuv6Okrsph/XRn4mMEVRmnKGc6sWIGGz9n5OiZCXPFjcwX7Tq04+LctCO8C06E2Hd1jtqJn/7n1VFEXddmS7Iml0nHXsesAhajgTeTKMDCo2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iC743E49; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iC743E49"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77057c4d88bso1274925b3a.2;
        Mon, 25 Aug 2025 11:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756147306; x=1756752106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UX7ijHX7a+tf5eCXYmPN5Iaxr4+le1dNHKiFE/ef1Ik=;
        b=iC743E49mE2e+PjLqvt+d/K2KgDx6t7LyJwz7uOREo/tdZ95xeCqSoXMIlMe2rMiP5
         61ZORpavoMqx4v4jkPglkFx/0pO9ZbR8DJ3f660aqUn7fAkQPzOcGKvwTf8JKSlhzb7o
         6C6/YxaKNRQCvMEUfNB/36flzS/HWTW60biLHL2MTYUIo1qSJMUnBbyBiiFr8vEif0Mr
         7ejEFuhahY+LOqnKvLD5dGtYmWD8DmYWtkSXE5/onWtJandRNkjClRajMOwQ13fq/WhH
         x51+VkBduA+eXObwLq/lqDOPwWMbZBaV6d2hZIx0gd/wgRDdO5gw6BKFG3gT5KFdeRYT
         YbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756147306; x=1756752106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UX7ijHX7a+tf5eCXYmPN5Iaxr4+le1dNHKiFE/ef1Ik=;
        b=oH3OhwGPMnnwcB7YNkz9s9oZmY+SWho/J3iFikIov+AUMf8bN5HsegrjojQaagb/HY
         OU5xvAPk8R4pAtwIo1OHCEREH81Y7oU21WuljC9BI9sDHVk7NeeIF4Ytt7lBZSCSzQuy
         zLenTQDEcmDiG9U6P/rrLwE7WSyZvvrf8YH7oCwafF2Akw6Q/5ICyZEtML20YRaFHNMh
         wLF1JJWkFhQN8+rMnEIQd75xIWI1wbDG9/fQO1up2HDE2aetaP4YmN1xDr1hTwt/TaIu
         RoUS7jIWl9n8yNdsFRY7ZXEtbR8Ce8p6OxNdP1KQmFV+mpxGF0I9tsDy9kvb9qcEcDXl
         jErA==
X-Forwarded-Encrypted: i=1; AJvYcCW9DFaUbt42hwd24fziL8h+CmdOYClAjI/IOTXJiUkHkZQzfRYhZ5+oxj5ZbxdyEXR/lin+JWPK64/M8w==@vger.kernel.org, AJvYcCXp/yoyKYv5Ld1QoWLoCdQZmo7j/XxDcWvrwEe7s9QZY3GbwssMKSAlZBcccfo6UsVidQtOQGzhMNPlYF8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpIID/kfSe1twKiTgsHvIVXmUBULLegU/EKBW6ByjBnUt+gLfZ
	2EEV2qU6254aAYsvYfKhY/VBlSGDaubmuQrlcbuBVzPnNPzqLfppxJRw
X-Gm-Gg: ASbGncu0eoYD4bzYFKLjuxlwhSN+PBLTr0/6hiZfnwCqR5MfO2Z7zhvl6iSaKpUZe2s
	ZIGrXo/FcW6j059tsK1sxIiYoJ+0eghMfYl6W9SvNidU93En3CtTp9TruZbzzgcM17A2q27KeSW
	twAMuG3nT0F6uYq/1S5z1aXBBVX62Y31Yvb79uiphmqRgVFalWfF9MFXdLG0vAqFmsSppf82pmK
	tkoa435HWuNKOsnYyE66mb4YcstYAE+GeCdH/aGhidI5I1RBi9Wt2VkncIeiVx7UDQONFh5RlNd
	yIyVTg2Dk2O+3HnoqRYa36KYKfsQv9VPg0aRkFd2JPacJdRAoWgHjp0hfiHNTCOW44J8KDZtAJM
	jk7dc/mLekc5818SgXDu774YRraG2T/iPeJx1iVjtQx02zOAWSwvxflBN
X-Google-Smtp-Source: AGHT+IEyPqAP6OnlZ3n314e6oI31EDPffNxEjOEtw7QvcJ9ulHANdUGvE55kj25p/OkhEBFcWCfaZQ==
X-Received: by 2002:a05:6a20:be23:b0:243:7136:2ffe with SMTP id adf61e73a8af0-243713631acmr5545453637.25.1756147305822;
        Mon, 25 Aug 2025 11:41:45 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77040249e37sm8155142b3a.105.2025.08.25.11.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 11:41:45 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v10 3/3] scsi: sd: make sd_revalidate_disk() return void
Date: Tue, 26 Aug 2025 00:09:40 +0530
Message-ID: <20250825183940.13211-4-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
References: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sd_revalidate_disk() function currently returns 0 for
both success and memory allocation failure.Since none of its
callers use the return value, this return code is both unnecessary
and potentially misleading.

Change the return type of sd_revalidate_disk() from int to void
and remove all return value handling. This makes the function
semantics clearer and avoids confusion about unused return codes.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
---
 drivers/scsi/sd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 35856685d7fa..b3926c43e700 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -106,7 +106,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
 		unsigned int mode);
 static void sd_config_write_same(struct scsi_disk *sdkp,
 		struct queue_limits *lim);
-static int  sd_revalidate_disk(struct gendisk *);
+static void  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
 static void sd_shutdown(struct device *);
 static void scsi_disk_release(struct device *cdev);
@@ -3691,7 +3691,7 @@ static void sd_read_block_zero(struct scsi_disk *sdkp)
  *	performs disk spin up, read_capacity, etc.
  *	@disk: struct gendisk we care about
  **/
-static int sd_revalidate_disk(struct gendisk *disk)
+static void sd_revalidate_disk(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
@@ -3699,7 +3699,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct queue_limits *lim = NULL;
 	unsigned char *buffer = NULL;
 	unsigned int dev_max;
-	int err = 0;
+	int err;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -3709,11 +3709,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * of the other niceties.
 	 */
 	if (!scsi_device_online(sdp))
-		goto out;
+		return;
 
 	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
 	if (!lim)
-		goto out;
+		return;
 
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
 	if (!buffer)
@@ -3823,7 +3823,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	kfree(buffer);
 	kfree(lim);
 
-	return err;
 }
 
 /**
-- 
2.43.0

