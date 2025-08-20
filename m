Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BD8311C12;
	Wed, 20 Aug 2025 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701152; cv=none; b=qbiBOXmqBKa/MpM2NCk45tNPidJiasNcMIlV4r/GNS3T18LW4VBO12+r3YQq8Vld8bXXYIaGw/uObRYgx3NGzmoseLOmJfob5xLKHwL5tSb51j/VbCKCZ2unHrXae8Zn5mfuW3RHMWuS+Lpr7a87aL/o3r/B/iBvP30EiHLpj4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701152; c=relaxed/simple;
	bh=32jsBZAt7/seCXlG3NMg0xKf/4W31H8CQQqSNif1kJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9mIkM2exE5Q0qMT1ZXON6kDHNEZzQjpubsN7NL4zdSi1Vfx8mY9/1gTKhaGvuI0CGZGnz4gB8muPacJ73OrybjHUMvAByzqqjaGhfV0v1BhWsgp2iE5QOQ1IoGaUsmyD+HhM4TqjKEwyp/KbipHU7PNkFgX1Gr56mj6Ki7p0x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSuGATo1; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSuGATo1"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24458242b33so62343005ad.3;
        Wed, 20 Aug 2025 07:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755701150; x=1756305950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sj0uvyFtjxj3kU3YkRCj5peBIKCXo4rrvGtrTbINrTM=;
        b=mSuGATo1FxtvrlTCCxjhXcGaSdJ13c2ifGpI7ejp3hYie6T4ZeKVqO6br9IGIylq8w
         ji6W3ycoaOAAf/63ssdbcACoFHj1HtlQZOefw769Fub3HCPsFPQpXAqnfUNK81sEso22
         d8Mg0L/M5gX3V7kLYAbaIVQ0BK4f0SkQeT9CuEwp5nb4OZ8nKy9x/JVKuhNy2WsMNmOW
         QrAOgTlgiLiiDin9DaliJUnAiMej7Up1JBvoWUSpXIwwebgbqK+1JAl0qzrEzftK5zoy
         cccyQ9QA4F0pDst7tVWK68bd5Y3ngyVNZAYWz8Za+fZRA/qhk7Ka3IpjWoFRmuatkIb6
         k7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755701150; x=1756305950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sj0uvyFtjxj3kU3YkRCj5peBIKCXo4rrvGtrTbINrTM=;
        b=T2Bs0CgeIAFB6XINO9kexrljowtgjSaS4K19XUo6bTcke7S8xBVxF4fMtHhgExpa/o
         p8CKMKWehb0HmaTc5eG5FKuDYcOvdoDyxGde/pqgaWjSgtWDDugJi9vDxDEaNne6CVoV
         JTELU+thAnR1gLs9QhcojPxk+ybPb2BFBDzWQTj8C7a2kEXCnrZijlb7htkRmMobm+9K
         +TszYHgWNnHMbtI4ZHoURLMeEA11cyzdFMPZQIixavXhoHiL+ZgGuoLnOj8rkPsZe1PJ
         uhIOuTx/ETXVID5WcMJRRELMXTB6yNgZxngm+IvNkWnMvatcqq42JKdPuW63dL+gc0N3
         uXtg==
X-Forwarded-Encrypted: i=1; AJvYcCVXWAjjcpvILZMM7tdlzbCQdyrvAe6c18NOXqddzkdIs/rKGIxBloiVev52Mv+Fw29oo71WU7Cxc678NWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnFVSf4ID/9sXlkNRkjVgRco8gioxPpXDRpMnRoDEV1cwnQ9Xp
	IicGZ/47DPyNL1pqcqv78/uD7uhT3nL5S/s8/v+aR+vo7pqS8/8Tjb2v
X-Gm-Gg: ASbGncuz9veR4G7G0NBoxCEnI3ShTslk63Y0pReToCjDCShtnq2NQsVu+NGy659UYEf
	9mFjaaW0WUmoWLhWWFdMNn+sf3w89GLK97SP0uO0c9jq98URCUvckE/2r+iQ6aQMXrqzSAhsLHv
	KePiS85bhlgoMcvHdFeeg8ZvteWf1fUzUooEWFj0DQ7TpU3VZo1jsVPvvFvclfZ4BUpxZZ5Jwx3
	ROXN+V7BaYrxokR1zqzX9b4mcWmyI41glPF9xvLSkIkj9w9yuohMEIcLNUmpUH13FgwYzjaJSy+
	s/OqXv7m1DrFIcdk+pHL6qMSu7+guZ3PT/P7q34/0fpJBtDpAqAWX0clveRfVs5ZlVUhRwjr28O
	1mED+nEsIGdRLJa8UokKDb6WsHI5cQ3BPuL3xTRg8VzNG7g==
X-Google-Smtp-Source: AGHT+IFf4nawKbppV/T2UrrYKSAoEMOU6EWRZOkdqaZfIPVJm9V1DlFyQNJjQdkRi1Ve51HdiRHQTA==
X-Received: by 2002:a17:903:240c:b0:242:b315:dda7 with SMTP id d9443c01a7336-245ef10f5a4mr40819575ad.3.1755701150608;
        Wed, 20 Aug 2025 07:45:50 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed379e92sm29197515ad.65.2025.08.20.07.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 07:45:50 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org
Subject: [PATCH v8 2/2] scsi: sd: make sd_revalidate_disk() return void
Date: Wed, 20 Aug 2025 20:15:10 +0530
Message-ID: <20250820144511.15329-3-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820144511.15329-1-abinashsinghlalotra@gmail.com>
References: <20250820144511.15329-1-abinashsinghlalotra@gmail.com>
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
 drivers/scsi/sd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 453a27322517..2ad6a0b28822 100644
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
 	kfree(buffer);
 	kfree(lim);
 
-	return err;
 }
 
 /**
-- 
2.43.0

