Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116A754279;
	Sat,  9 Aug 2025 09:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754732071; cv=none; b=Dek+LhXixf3lgxdvJ5l8P0RYwE18zMZB1ZX8RQwSGKideW+ekHhOUWlgL/4N9ji4DFL/lm+h0k1rZDOS0hOSZ8FWKmW8bXhvcznF4RjD2g7iaTg2ywh5FeDdj+83SAP+1+EcC6IsE35NzvhnnbqPwON/cg3esV/nFze/aimnuYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754732071; c=relaxed/simple;
	bh=bhsW1U1Tq4PPBZ7heWpEnQpWcvY/7CsvNo2raSoXXeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrRRe+kn7YRGifyNIEV1/kRTXZS2uYZqFwUC4cCb20kfP8Y1dHn/pCjQHweAdo7kUJgtqmElY324UgP6gE/kN18FvkfVnWEXmr/JNWJFdRCysxtJ6G5p3doO/MQIIKy1ps5qJZ7qP0ZexlT3j4iFcAS7t6AGFxFFe9KE1pRnVk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SBkDDhLt; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBkDDhLt"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24099fade34so21842885ad.0;
        Sat, 09 Aug 2025 02:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754732069; x=1755336869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ublcefKyFungTBsE+rlJ1RyclH+0X3cYwS6EYOmxJmg=;
        b=SBkDDhLtP5Z1Yjo5WqRmr+2Z7abQ+XUrFnKGFLwcRm3VVRh9BfgvZ0iwr5i4V+Tzld
         cc46R3ChzprxLLXZYCQkD1TvzkCZumizvCGpoK5ev94Cj9oI1TCoRs7ZIoh6RufH/qrv
         F3O/mC3x8H1R0Ue0QlB0zg1egmuHCcyOwnRk04g2x7cV51PJS2UsgydTwo+rCdt0qi9m
         V0be+s5/BZPi0TY1uEr+AuAcG4P6FAQ3DrCuavDrovO6SBt7eLqFj7nJpSNnG4jSEfRJ
         WgbYDma+7XEyIy/Gg1inBoVmUpbQhY5XiZoQPMBt1IFOZU8aCnA2M6vroGxYzedfS2DT
         eUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754732069; x=1755336869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ublcefKyFungTBsE+rlJ1RyclH+0X3cYwS6EYOmxJmg=;
        b=KFHzfmBtjfrqrxH5cO292yijJeAOCCYvMFkLiwfZ3IJpA41ud74+W/SrrMN5pujhYe
         a3EdO/In5lHu3+XIdAiODxalkwWyLafAwNIxcKBHCJRp8kXf7EP2O9ml8fTut9Ywzmsu
         ECO0bKnZf81mbwqubE+hQDb4NGb/ZaLv1OqwhFv4B4OSlojv8pPxw0SOOy9d0mcgyYTc
         16Gg90Jyr+yEqyXUq5/Klx66j1TJCIVbODDFdOo7H58EYNgyw1IaWjBLp58HMhf8JNnP
         kR/eFFTfIYMZh1XS7oT3k41zUqKxDzM1I+tXofoZcx1EQyz26bggvBdsMjyAhfbtIg5G
         cv3g==
X-Forwarded-Encrypted: i=1; AJvYcCUVyXYiBgn+DVIvWUQV9snyf75kyAlcfC4SZJfyck+tTO9Sc5HQcgWg9rIRI0obhbCGRYGCis8Aa03dj9E=@vger.kernel.org, AJvYcCUcgseR7cWXWTcvr2nKLD9Rz/8CkWexOTHCbxsu8yPxTHXcqsiJSXn82XgBxm83yUGIFd1JIZO7SDf+kA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwTZ8HePh3WdngTOKyA2Btfnk4LLcpjOxzXkUUMvd4PoxlM0zB
	l9jjagHWYfTRqEyF/UJimcd5vx1y/x9j3FFqZklgH4i4gBV2Hz5FQ/ZW
X-Gm-Gg: ASbGncuNOIGdLcNzJ+p+U+xtaHJXcf6klDmpgOgZFDP+Q1v8/kEDKaGtpFTKF1ZVCe4
	NyCpTSnW0htpqUIipNuuL9rJWOF38mvrAWyj1hm9VAcWiTDi64IpwGae6/ngvuk72mKO9OcfIiR
	gj2Thuifu/tUfKb3nzcBvAv4krmZH8YR3+6vlY2Gie4D3WYyTPa6TiMM1GcdyQRxRfYE3EYv2cm
	Vpa6ieUXDYqT3VeE0y4FzcDVp10PMV1Bf6Awfjmijqs24leOK89sZKT84dOeUb8y6ormxnXX3qh
	7UhebHEzQau3W0gMfzoAueRD1NPYcwd4YaPC7AYURTmCpSpKGVd1g5DNEYRfR+bkSmao0wJCXQD
	l1jdnTBqFgJOeZgfhVTPvW/DTE5mL8iAD
X-Google-Smtp-Source: AGHT+IF1CLks+RhasuV2N0Oi8X0owOhZ6zkI7O41D5YGM628rk2CekKs1I01t5DpqfKLJkrcdipsWg==
X-Received: by 2002:a17:903:2f81:b0:242:9bc6:6bbf with SMTP id d9443c01a7336-242c2265efcmr92260295ad.54.1754732069148;
        Sat, 09 Aug 2025 02:34:29 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32161259329sm9823438a91.17.2025.08.09.02.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Aug 2025 02:34:28 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: abinashsinghlalotra@gmail.com
Cc: James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v6 1/2] scsi: sd: make sd_revalidate_disk() return void
Date: Sat,  9 Aug 2025 15:05:06 +0530
Message-ID: <20250809093507.372430-2-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250809093507.372430-1-abinashsinghlalotra@gmail.com>
References: <20250809093507.372430-1-abinashsinghlalotra@gmail.com>
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

Change the return type of sd_revalidate_disk() from int to void and remove all return value handling.
This makes the function semantics clearer and avoids confusion about unused return codes.

Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
---
 drivers/scsi/sd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b8668accf8e..9d5963de8c82 100644
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
@@ -3801,7 +3801,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	err = queue_limits_commit_update_frozen(sdkp->disk->queue, &lim);
 	if (err)
-		return err;
+		goto out;
 
 	/*
 	 * Query concurrent positioning ranges after
@@ -3820,7 +3820,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		set_capacity_and_notify(disk, 0);
 
  out:
-	return 0;
+	/* Placeholder for future cleanup */
 }
 
 /**
-- 
2.50.1

