Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC152DF701;
	Sun, 24 Aug 2025 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756058572; cv=none; b=dFBluYvvCYEm3llB+IRY46lSRkM6G71u6G6VWbDsHjp4laJ4XEVKXqKGrrwMmlHGgCiSM/MiSJmyTpIl9Ubx/KqBA3C0Gh+WA+FMMZfk4NFyn/FI8C09KZFMmRGvE5VqcuHuv/6lIG0KbwzS9q3iFeVycG0cY+1c197RxSqsMRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756058572; c=relaxed/simple;
	bh=C8Wx/V1kWrXKW9xvkgo8ZriLoR7tlGu2v9fC1G12fic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bC+8DhihLoNUy3Fhmz8OV3wugKUSMRusLy9rcni+26laWHlxvzZ+qAAGrrBTBV1L77u6KGgNJ1WymggK/Bcs2h4U9zVZVtMwGX+wv1TIBw1SbWEjbQNt0zxCBgGFuFfuv4bUvG1ptXkD/5ln2WyqkH7xlFwoRfCX8Vo9Xi+D4GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ebDMGhbh; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebDMGhbh"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so3172540b3a.0;
        Sun, 24 Aug 2025 11:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756058571; x=1756663371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wsl4Vyv86VdWxaOZ5lMXC35Raah6QnnsSnoFlh2WVOk=;
        b=ebDMGhbhGZUu7OJw/4jMlCHrmXqhaZGzLkTPB8M2Db0kJC+BrHL7lKEI/Rmd6P+hn7
         PO327EpuG5wx42S3temVN4kqgRN9Vm2Zt3sAfDhqvjA8Y/G1EvswqKoybA4SwqjMn3CB
         B8sZGOc0uezO78MO4MTyCg2NboEj4j+ldlz+mDunQzHGuyI/UyLBVguEyiHTEFwvKhrs
         xNRlXV/R84MYkNLfa189q5v+wbQdR3vKLgp1EtfjwVpIEhg7AGsHINK01wDb0dvLpDPg
         tmWQ63f5T4WMUtqvaG/tuEch8A2vUeyPT5/DSlgyMxMY8ukZhDgvnXBfCLg3TD0yoNue
         eNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756058571; x=1756663371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsl4Vyv86VdWxaOZ5lMXC35Raah6QnnsSnoFlh2WVOk=;
        b=d8rL7Q6bVAw4CTvuUXXGoWCxPdks4DjHmpQSDQDQEBvu5f5DfzKssHHDFvA2hG6hCU
         hxEWIFM+itd1yD8P1rFI4IMRuvv+kgY6bAjLCrJZ+VGtbIW9laHFNYSHJ7uJNcbkHeqx
         h6NMipa2E84+spYdGmnhJDgQ7iF8IBumFAIAfJIRu8SzFmhTjtuW9WVp1TbGerSeelo0
         UTyzbrM/9M0n4xocZhldCG8JA+72Ngkjy/CT4dT3clo6rsgqvI/v4yxJ/vSK6gXoeago
         Mq9iU1Yj7BB6mR5EW82oJ3iOavxf/oURLJxzBp80TuqPwTt/8cd2U+Fziwuuo37YlleF
         ZT1w==
X-Forwarded-Encrypted: i=1; AJvYcCX4S9a/3tLWvJokHv9vIbg0PMbMIKh/ITsCqPWc55ioT/bI0zLiMgfQmcYfDZsLyKkAQlSUafd0gxmpPw==@vger.kernel.org, AJvYcCXA5Z6+6PsSPPLp73tYyHIqOCPZ0DgcGEe9GsDq7i6FvveoCjWxhDJXJEdzo0OR6nMSvjd63L7tMIkHdhY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSvpDT409d028wdWeCxtBsQbeRHNGT+mYg/6gKm3Zl26SlWGiC
	+M09PDewNMmQFHBYXu58uZfYS67EaW7DXlL6phLpEDuCjmCagB+QpMvJ
X-Gm-Gg: ASbGncsA8oid71wgQE2QZCeQEjSMjXULbjKDsCdLIvI6FA4akwO9uh5Bu6R+FB4oz7P
	tqnGWjGbWbPF+TDPkcXV0PgkF/haHrf1FImtwYe2rjJEQ1EWAsPw0NTZY5d9QJJhuvOYjCX6Xiq
	g7Dg4qMYq+GIodp67Cz226wW/d5rz09O5ooHYEStxijlQm5ddNN6AgbkwhnZDHrjLiyiQU8PFDK
	2fZO/CvVqvtG9knGeucw/bWknAyJeGqDDA1AQI/Z3hSQNgwdnDX5NlEi1W7HETUBH4thDYzfIRy
	qmLF1ykbVGk+1yp+4f7BNZwDtecoB1jqdK9+rREU4VZ9bX7xHNRc62ZQmpYsPsRvsmst69d6w84
	PESADFkJCQ2/i/qQOOL5zD2Xp8WFbty3SHujfQ7VtVDHihA==
X-Google-Smtp-Source: AGHT+IHAoZJae+FbhWcaoxxUI6hdRjNNBOrpxTBTUFcC36w6MXZtfhvK6X+MjocHkbPictzwppacKA==
X-Received: by 2002:a05:6a20:2448:b0:243:78a:829a with SMTP id adf61e73a8af0-24340e06a0cmr13377826637.51.1756058570606;
        Sun, 24 Aug 2025 11:02:50 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbb7b6fbsm4743532a12.30.2025.08.24.11.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 11:02:50 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v9 3/3] scsi: sd: make sd_revalidate_disk() return void
Date: Sun, 24 Aug 2025 23:32:18 +0530
Message-ID: <20250824180218.39498-4-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
References: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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

