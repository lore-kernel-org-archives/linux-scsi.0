Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A20A242D7C
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 02:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764641986; cv=none; b=kb9Fxd2eaphfQQ22u6Y+OBumkTsPvLkOq5xHVGtCqNDpDglKLo7oP9/Q8xtzazWlZJQ2Ktlsvwh7GVMbrYjUTBOYnNm4KxJ2bxt3mIsSlfTy8UfYrwstlT7sbKvXkgwNkFqo7SbWAkf+y0JaINgL6utwQXsNOuepGX+XTKJ6+gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764641986; c=relaxed/simple;
	bh=jQ9+htAShEepMYuJXlSmnov65MqzRQbb7FM2wmpc/Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/drlGieF5ENfxl3Xkp6iC34GFsFeODLRcKqxcfOHZZDXlo6cuicKUn2gcvYsLxfHBbH6ugt0Lj4hPrkRKGU7h9L/BmTGsF3ZTZtqUxPo2RoTXgc5P6TlV0u4xH/doFVSpsJEswXkEYwlSY13SOsUNf7Rw8wu9zf6GwGyLFHlM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CW10AIvC; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CW10AIvC"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-bc2abdcfc6fso2996987a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 01 Dec 2025 18:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764641984; x=1765246784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Mx3ieJ+IqTygbyENkxYOE7qOS5V+AiTVC9vxS0u8pI=;
        b=CW10AIvCPPXuC3MI0JbgQI0VYaDFP6St6mR4YzbvXrda7qewv0/aV9+ZBa3L12cbOm
         htFCNNtXXkK98jJj08kwXYa3x6ZSfc854tlkukzCgttXnlJkDYATtnCpkv7a32VOB9Ua
         9ctZGQIV/e1f7iX/f4VRMa0BbTj2H7GGVT04safcY2DisJPk0Pt8ZEZERUiS+lk/gOjH
         mCbtwqCHzw9clcEfiYhFclEUAHzgfHvWERat0sJF7DNI5ODn+zZbmqmxkh4lXwhzUbSB
         j6HmFX8G4O+GYQh6DQdH86ekJtWeeSuaVJlE5rGwGYG3ttzwUdfB8a/rnDGj15SuGKxO
         8DIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764641984; x=1765246784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Mx3ieJ+IqTygbyENkxYOE7qOS5V+AiTVC9vxS0u8pI=;
        b=vR6ilQSpVtgzevxrKVZcl//zfay2YekKpwNqw8PL/Xqt5zeXHpAFexH21FXlZqrN7V
         E2cWPt3jHCKrkhdDgxl36x5bfQL5r5cgxEiIgM1xZxbks36fA7Y2Xvv4Ahit14VJCaA/
         kFkXT6MKShc9Kb1Rdhj0A6pmvmcCgszpjp+F5qT582L7pLTfwrtIi3kAUItPlLGDHwtH
         /H+RyB4BeFMMcHMZi+igV4VzQpaSqSEBVya85vtU82d1zCG2+jD3viCs4bme/KWZx5yP
         CBYf9l3l766mSsTS7dukB1n55dO8bIY6/CoeXjRK8GbRBzTbkA88P8qeRmcVdmrtOaaR
         hQ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVl0hm7+cGxzEOvHSPFgPDVrbbCWSkYP/C2tWD2CFD+rZ+fM6GkhFkIgKGbUUacGQcn9CPlUzQ0txaH@vger.kernel.org
X-Gm-Message-State: AOJu0YyRWN0jDjvdptMFBybnMHACB++nd5A7XfDOPx7GTf7WkCR/ltHu
	mXQEwAEK1mTQTfi9xUNxzRrOkj4tM8R4vy65KVZqcbsCYkSzorDY5zhc
X-Gm-Gg: ASbGnct0S4z+Gdo4PjE+qB80W5QSnRqP0PA6q8htQAVLvmWtJNsxpnlcuoeRB+zpf9Q
	Mlc7GlPH70dosk6XhvkD+WKSm8QKLlDictCTFZaYxr9tPCvKwrSC2dUCgAjV7UzrD9jBvy6Di/x
	y3IM7Pr1VlXHOTlkhjojx+2vUpWlbHJkeFwgJsB8mEU7u+m7aTmkLXuuPBkBYGu+5dnEvKGOL/i
	RyBALOXrr1UuQY92UKC3Wp/Ay5bZL5on7kixYmZNuItOsGJ9SZBJmsWwheEeZ1jdebxoOfBwSfg
	H0jAL9d08wE5ltl0RKGoctDJ58SDxDY7Fj5VN5EFVZie+AKYSHydIYaCS6OL+tsZVTM+lNhphp5
	xh7EhgAovfUKEF3tjF93DKfyQ4v2Aq34+22jFs3f7juDDGKXEomGQhAttqgvGLnnnmaggzBnkN1
	fkKK0r20CELhOBavCrB8M9C2u3TXyyGmE=
X-Google-Smtp-Source: AGHT+IEdWiY45MZ1XqiVM5yL++r5Ek0FdtzjJJm4sNMk9kQxJ/RNpqsRnB+liblWscI1M0AWal0Ksw==
X-Received: by 2002:a05:7301:790:b0:2a4:69ec:ff0 with SMTP id 5a478bee46e88-2a719fb92e6mr19287121eec.27.1764641984146;
        Mon, 01 Dec 2025 18:19:44 -0800 (PST)
Received: from deb-101020-bm01.dtc.local ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a9655ceb04sm49089945eec.1.2025.12.01.18.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:19:43 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	kernel@pankajraghav.com,
	Swarna Prabhu <sw.prabhu6@gmail.com>,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [PATCH 2/2] scsi: enable sector_size > PAGE_SIZE
Date: Tue,  2 Dec 2025 02:15:23 +0000
Message-ID: <20251202021522.188419-4-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251202021522.188419-1-sw.prabhu6@gmail.com>
References: <20251202021522.188419-1-sw.prabhu6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Swarna Prabhu <sw.prabhu6@gmail.com>

Now that block layer can support block size > PAGE_SIZE
and the issue with WRITE SAME(16) and WRITE SAME(10) are
fixed for sector sizes > PAGE_SIZE, enable sector sizes
> PAGE_SIZE in scsi and scsi_debug.

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
---
 drivers/scsi/scsi_debug.c | 9 ++-------
 drivers/scsi/sd.c         | 6 ++----
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b2ab97be5db3..b5839e62d3bb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8459,13 +8459,8 @@ static int __init scsi_debug_init(void)
 	} else if (sdebug_ndelay > 0)
 		sdebug_jdelay = JDELAY_OVERRIDDEN;
 
-	switch (sdebug_sector_size) {
-	case  512:
-	case 1024:
-	case 2048:
-	case 4096:
-		break;
-	default:
+	if (sdebug_sector_size < 512 || sdebug_sector_size > BLK_MAX_BLOCK_SIZE ||
+	    !is_power_of_2(sdebug_sector_size)) {
 		pr_err("invalid sector_size %d\n", sdebug_sector_size);
 		return -EINVAL;
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c3502fcba1bb..f2eac79d7263 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2889,10 +2889,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			  "assuming 512.\n");
 	}
 
-	if (sector_size != 512 &&
-	    sector_size != 1024 &&
-	    sector_size != 2048 &&
-	    sector_size != 4096) {
+	if (sector_size < 512 || sector_size > BLK_MAX_BLOCK_SIZE ||
+	    !is_power_of_2(sector_size)) {
 		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
 			  sector_size);
 		/*
-- 
2.51.0

