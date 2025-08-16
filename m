Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D995B2D0C93;
	Sat, 16 Aug 2025 20:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755377655; cv=none; b=POE4dlsOMUtjluUfYLoc7W79MAzXNTV3Rb6J2pjb60V3YAuksSaFrGJlN6nJPRxyM+TGhNajZlP1J4nw580Hg0U2bUfW4GPRSjq0rfEFTnDdQn6keL3DlrzWdu0gRxIdTqiX4i2WXYgLtKFBvxawxZOr04bL9Qhxu//RhN4BNPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755377655; c=relaxed/simple;
	bh=j//4/Y3YVPGUz3Y8VjQqQAg73P1GbGkbLzFkd1MRs2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTchON+eEHkwgeeiNWT9pNobHzDGQr5sUeu4+F+5O5QbiDhigSV3tC4Z5Ew+1U20dR+iBkWonRPaBN3NF9TDDYx2dbOVM8i+ZEMzDLqITh25VyIGGonf57iNdhj3Jz5LQYGZUJN7iE6QdarH7k893un//QcGJiA9xjPFuxQfmF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMw78KyZ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMw78KyZ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so762538b3a.0;
        Sat, 16 Aug 2025 13:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755377653; x=1755982453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34/e/gMA3rbNvxNje27VwqCNEdXoYxJi3L/UJkaHF/Q=;
        b=FMw78KyZbv7tyyGoY3RG05BSgyeK8823y+u3+ljdTOC7xt8DIMd8GGmeSzuUENIO65
         t37N/MvpjuIuEIzm8FRqOTWEBpDEzCW7/WcbW1QUa21lNebKjIKK913vvf34RfRL6pnH
         TJwf9Cb2/vvj6pZWLAE0ZDVG8fmMpChvW2YLmWdGMg8hTPzm347ZubMma1EHQRlf/qK8
         PhH3X01K/acxsDYFsc2HWM8YtImVJ4gEcL4YC0oloAEiUTOqXP0lYopKvTpUH7zvBN+X
         xnzq/YyPIkuMb1btpJhiiDicC3y3oDJMaIwK8gu8gSNW5pvXOh/0skLtzkm0XLijPTP3
         LjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755377653; x=1755982453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=34/e/gMA3rbNvxNje27VwqCNEdXoYxJi3L/UJkaHF/Q=;
        b=toGSoLrZo5P2l4WPGjR/EzybnxddjZTdCzW3bZVBWuBKARNl4JK6XgoweyxTtRpybp
         XBkMRBZxtp6gejfc445lHPgDSxza6XWE1jnvORqN3KAHjRsR8MFI8dhaNJoVXiFGOH4B
         WSx9cxEiDTYd6Z/EOioByW7jUkAcXG5YU0G4aDLoUWKfVWteluJVwzc2nqKGKFSKiM42
         gIphFYso1srzOI7y4Zngc32QKxKQi5qhkm+WOpdDhcl6hiAx2Aq2yceudsXeJlKW4+Qz
         EzWWjZLICtwPEnYFGlvUp5PyE3CCx93N8caglfrqQW5ygniQOMCVJ8cG/IIgEkkOw++h
         fYlw==
X-Forwarded-Encrypted: i=1; AJvYcCWjItYIlFJitwqm3TzBBPd9yRuRzOWPwVrVmdPMbPZDq8HYAqrUkkT0Ok0gjyCSOPknpLeF9PryVrdiIZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDgj1AxBsJwd/upfCMIjC5iuaglmwouNhXQvIYJ6gZGWHdebzP
	Z/JDecmLGmZE6YDZe3gbupwqVm58wvzc+zYOgtQnnhzyAQNH6Rx1hDYW
X-Gm-Gg: ASbGncu2wK09di6KbhAcF9F1ig05cwC5K3ESQJqbNstNrXiXbhH/WhOgV4ymdym9u76
	y9rTwYLtY7qZWAYhyae9E5lBWZQOrMYJojmYG8cM66YUB/UgQJm9dcunKUK3Ntp5cUFt8tHkTOx
	kwRJNreaKG8BtQKgJstcggEreCverWiyOj3z9zzptapZtjqiwaVoRWW4PrFyska0UdTXlx97Cn0
	DP+G0Uq8Al5LFZoojSoSSW2Z73ZWk/Nr0KjfR2K0V2RJJ9xPPWMB+RPyYzKPrmUFw44jyhSmezw
	17Ipvb5PZFEVYonDvXe3KKSkb+fDStFryKM+opayNbv68o+gC/eNHAh6/RYUcqcQXifY9CTNu+5
	mW1Yum4/G2M8TM22/vtjumzeP5JDHs67t2P5Y57XWIXJYrQ==
X-Google-Smtp-Source: AGHT+IFx09QVFUdWWcrdYDRkEcDo+ImxAk/HZ1EioMQPPNKC2P2A7A8lDat74sf4jjCgNVLhPAs1VA==
X-Received: by 2002:a05:6a21:99a1:b0:220:33e9:15da with SMTP id adf61e73a8af0-240e6117aacmr4246725637.2.1755377653204;
        Sat, 16 Aug 2025 13:54:13 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e4528c812sm3833154b3a.45.2025.08.16.13.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Aug 2025 13:54:12 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abinash Singh <abinashsinghlalotra@gmail.com>
Subject: [PATCH v7 2/2] scsi: sd: make sd_revalidate_disk() return void
Date: Sun, 17 Aug 2025 02:23:29 +0530
Message-ID: <20250816205329.404116-3-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250816205329.404116-1-abinashsinghlalotra@gmail.com>
References: <20250816205329.404116-1-abinashsinghlalotra@gmail.com>
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

Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
---
 drivers/scsi/sd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c3791746806d..ba3bfd9b00aa 100644
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
@@ -3709,13 +3709,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * of the other niceties.
 	 */
 	if (!scsi_device_online(sdp))
-		goto out;
+		return;
 
 	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
 	if (!lim) {
 		sd_printk(KERN_WARNING, sdkp,
 			"sd_revalidate_disk: Disk limit allocation failure.\n");
-		goto out;
+		return;
 	}
 
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
@@ -3829,7 +3829,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	kfree(lim);
 	kfree(buffer);
 
-	return err;
 }
 
 /**
-- 
2.43.0

