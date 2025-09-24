Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7767D1311AC
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758730002; cv=none; b=rOrSkPCae1eVeuE4JQlRDUBoTjeS8U214vQvkWI3BhK/ZzMvPMOeatcvdn3UKyIuYTgECnjqV3MpOI4glrKPjpLc8Ecq/GIERkE/qESRhhKp+3ZDCaOSia/JcGW664+7cdjKArkRVzOlHEBbOg9ddfk4f7Oa6AuRzjUtbvVLVLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758730002; c=relaxed/simple;
	bh=YIxKVzr9qaXBN0ZylLrG8vLvgAuwWPudPeCshwDYBxU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Izdd0/DSN2004SlqL6h1DXdmr8lwjhF1cZuBJ+5Ul67EB6aXE62DX4TwuNo3soWhWPL9DwnI1pvjWPkm0iW6T31+OgNXdQEwWYwB20pQ4/ndFatJAlpi18G7kFiO0P+0iRkHgudpK3DDji60+rjXa6WpUHXdLU7oLLRMGVrvcW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gpH+hhlb; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gpH+hhlb"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5821dec0408so1019928e87.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 09:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758729999; x=1759334799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KAxo+DN0iB6IwYVHObHr0a0ySgSeQeXI1l5BX4eIFNE=;
        b=gpH+hhlbuFNRekBoB9S/mnqME+ceWiW1X+i1caySkH4f0AAKqN/O5pbBZKescxfiMm
         +RH6RPIeQNOtNrsxwGC1qPr1D1a1hiJljYLKzB9rII/4P6VBcp8PF17h353mqqsE1dtJ
         PyPx1d6/SSANGBHMV+IaCunWgxMVz7xrNizcp3BGwWCWmhYyxjbGFc+NA635VI10I8Sy
         05lQWTH9CJCLWrK8uuVSubA14mtj4K7Hpf09gr76dv8TCObJlS+Zdlu5qNglKb04CxG4
         9w+y0WxRdp/1+NZues2WELHyeozgUXOgYk0YLvJq7vlOHmw/B1BPiD6kRHnh72ynm4eH
         9JNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758729999; x=1759334799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KAxo+DN0iB6IwYVHObHr0a0ySgSeQeXI1l5BX4eIFNE=;
        b=CRsd/iRL4Huwu6mr9EbchFP2P541np1M7Ek8WNsH8L4vuprOil1L2hXVTaKTfmaigo
         KQTUp3h4dg+Yi25P/IShFvmORkyEWB37Vq1vA20sVQ/YUMPQymhLUu/MGCCYQ+BD7ZFN
         4aMgBqUK20bO0xQ2YSTRy0biegbx3tqQnHLA97Uv1zibZjaIpPaJTqmxqz5s1x647YPu
         VXitdmK+dLwTkOF1N5lp/T0rPkaKeFTiaYTGClosUJ9mmbnBKWIHa3dOiNeAYBaB0Lnb
         rh3fI93HtvPZ/hrLjlmqJbJ5Y7c/Gxj9kCiLT0mG8FtA1E0jBxkPzRJdgHNf1ELOxY07
         WJ7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXiY/CRHcrSS3uUG+YoqpCAxAABheuHsDxA7xExEGT8YBeslOIDTV8Z4OTFIOBOLEwq0hs8w5o1b3bL@vger.kernel.org
X-Gm-Message-State: AOJu0YyA1cLe5uA0lkNtprp+UwrnD0JHr8gwk5sUo/sbo/knyJcTpne+
	fhNhKwtYjz/SZzXBOCcrmwVDGr5nqbg2GCnDRrU7MpHPccHkc0wgTnlp
X-Gm-Gg: ASbGncsPXSEvUath6vBdVr9xKr5q6993EMSkpT97DXjgyedX14QkPZOEcX2icm62VQe
	rV0k7fW0rBfnGmsYry7IYroGCqaTEuGzocgZOYVaJsC7EEE0jofsJvbOKrkcC+AWOVOVsgYPf3w
	FrfBvPB97DGKS0Z90hSzImq+8oB/3MIGRydSm8rRrU1LAXJFMvz3pjwKK1WNplH4ocRaFPaXpOx
	0+k8rk+p8BtgcqThThqvunOj5RI8GmZfw8MEqQ8snUdLZPB5WQZyO1124FLk7SqrezHoNFu6CbZ
	9MkUDWLvZyIFFXl5vk6d2ohr2gHNG/Wr/hmqIAtzXTBPFaTmpaHe8/9JTQ8uwRKsfx+7V3GAaYL
	R5sp1IMsm+n385zWBrDbTibIuEp53RUsyGvzJ+kExWSbYVs896DpyB/5CIEHQUM3PJn9/2msDCp
	U=
X-Google-Smtp-Source: AGHT+IFDBzKsODxZa5m6nzGg5A7qtS3fuJNPx/zQKV/tyVpLAB1PmpmnTWNVaKa6Mdu/j/mesTokIA==
X-Received: by 2002:a05:6512:3ca6:b0:57c:2474:3734 with SMTP id 2adb3069b0e04-582d2f24cbfmr4630e87.37.1758729998141;
        Wed, 24 Sep 2025 09:06:38 -0700 (PDT)
Received: from localhost.localdomain (host194.safe-lock.net. [195.20.212.194])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-57bef64ecc2sm3414595e87.129.2025.09.24.09.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 09:06:37 -0700 (PDT)
From: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
Subject: [PATCH] driver/scsi/mpi3mr.h: Fix build warning for mpi3mr_start_watchdog
Date: Wed, 24 Sep 2025 18:06:35 +0200
Message-Id: <20250924160635.27359-1-kubik.bartlomiej@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix watchdog name truncation.

In function mpi3mr_start_watchdog, watchdog_work_q_name is build
snprintf(mrioc->watchdog_work_q_name,
	sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
	mrioc->id);

Signed-off-by: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8d4ef49e04d1..5307fcdf216f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -66,6 +66,7 @@ extern atomic64_t event_counter;

 #define MPI3MR_NAME_LENGTH	64
 #define IOCNAME			"%s: "
+#define MPI3MR_WATCHDOG_NAME_LENGTH	(MPI3MR_NAME_LENGTH + 15)

 #define MPI3MR_DEFAULT_MAX_IO_SIZE	(1 * 1024 * 1024)

@@ -1261,7 +1262,7 @@ struct mpi3mr_ioc {
 	spinlock_t fwevt_lock;
 	struct list_head fwevt_list;

-	char watchdog_work_q_name[50];
+	char watchdog_work_q_name[MPI3MR_WATCHDOG_NAME_LENGTH];
 	struct workqueue_struct *watchdog_work_q;
 	struct delayed_work watchdog_work;
 	spinlock_t watchdog_lock;
--
2.39.5

