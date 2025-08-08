Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB872253FE;
	Fri,  8 Aug 2025 20:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754686670; cv=none; b=DwTUTnzTrXsZSwR5ysjlje2TW7hYj7OClckq0WmT8Qd0fDgVo9kxhUfUncAFY9JdqKBob9BRLthfjriOLATogLZyYiQ0uv8ZYIZQr8SyF0FYn5CYsNCWAp2nftOhNDdiIbQQ0aRkf/3stH8hwcAM6qcIVhvfW5pVrhJm/WExQxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754686670; c=relaxed/simple;
	bh=hdh9IovPgVS3WH8HOUQv61w5RPs9mEoCUMA0fqjjBZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8JPJozN5rIwvXt/4umBj5Fts9rUqmpOXslUXL4NIOBbWMKBvJ+kIjj/Y5fssxvYcFw8rdsJshBeRtT6x0tVpLJrKRVFtOJVR4g0OMSMsgH4D2cBbxVjg8FQjcidwM+PYhqxPxmScLk26YSFVVbgS/SF13CpJqzmM3PR8hhP+1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fCEq5gOU; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCEq5gOU"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b3507b63c6fso2691604a12.2;
        Fri, 08 Aug 2025 13:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754686668; x=1755291468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGsDopcx/0+LNXwYB8z1G5F5ZCC6MPmJTYcTpgAvOtc=;
        b=fCEq5gOUQVpzz+qi50fo8JmycjO4KcGFtmJ9hcG56JMiMxVt2Xcum/dgq7/yb87HRX
         Af+2Zh6FhBYTbAyvCpXTa3TVnzLUmKJOW9C8MTrYJl/J/ijmV6a8p/R6UF7b2snCd1XT
         QFIkqha8yRNrJ3BwCdeJveLE0nvBrUUe1gG5l38VRn2uKDH/SEDuJueMO2pS78maFC2B
         EF0/2P0Aol/csZLm594idsYA/zQUHzbKxPNVBb0V7++rnqiNQCIY/K4zukktsbGRGSI0
         T+qChOW5r63x2D/8xXrTZR7M6Cf2wPwBB33ROhPLekmbC45F73SitaOEIeuyZlucqga0
         cUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754686668; x=1755291468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGsDopcx/0+LNXwYB8z1G5F5ZCC6MPmJTYcTpgAvOtc=;
        b=ekb4cXHp8oeYfUIoieCnOri6fiBgETXs25q9jwqxZlpNJQ6iKr74Us+VjLKtF6z+VE
         I3zOSOlppI2PnPZRAY7fINhiZLljOHOKP4PZiG8Cp+iLjRXgUUUxrbTHVHPSPOzH7x0s
         UdRdkoPTIczwFDHrhUXz0PRNrZrfG1RnTn+S0joRTOslBywFFJJkyLh0+0hg4o6o+yyL
         llHI/5W0JKa7pJNgvIZiAApc6VyfnW3K0RrYkq89Ap12aFLANK6+E8moBaSro/Ne8PxT
         HYeGqJXR0BTksxJH+/Nep6yW80f8DNyVrDOpuRPsn7b8mxZ3L+ZbAiDKq8FAbYv7agqg
         7noA==
X-Forwarded-Encrypted: i=1; AJvYcCVRREKq7vA3CW/4Xvcg9ywnNTIuLpSGLetChIOLOFIXStqfL6abwTwV0vKsbjjYYWsCmv79W9cQcf9ilbk=@vger.kernel.org, AJvYcCX3/t516PDnGAxWDgV5olHFnZnQYriRjLidzNHaRKsPruywtNvV5r8esIvLTjwdUxHJXA87dCoE2728fQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjTpCwYaTF1LmiMXxbaoItwMegpmAXMUM3Y+M0APuqKXS6RQ9M
	agu9G5HSsHWmpXih/NuAr2qKaqNR8UXsB0mKTftBrGPedCIkeaQXBNyp
X-Gm-Gg: ASbGncuQ/aH+OTOP8PN/w5WFK7Qh3QTO6WYTVMeSpubB60lrUbmutS4aFnBAnjE4f/5
	DHwc+FKR9e2xhrUSKdFqZGFgOwBmt64TQEW/z6cpchb1Kc8LxaF9jJ+0otfIGUsugH4aS57LLut
	Ju7GEV6Bg3BpH+Xho2FioURAWPVP2ftltMCTF8g67CpcYhs+2s+rVpclSdPHxTmdef5uj6zRl8s
	1DzsA/dysLfMYkEYL7CD4efa4FSg0855B30Eczx01S0rKCvSabD9agpAggE7QOzrhlPcxqXIG7Y
	CNQ9TqbYWeoS3a3Y70DbjwRJyBYhIxdgsjtQ0Pt/ads1WuuqKwuU0cH5wjCIwgrpLQ3IFmjUHhf
	qjp8ckihNEpjwL9NOL7GJw340uXPSzeZf
X-Google-Smtp-Source: AGHT+IFM2HXcdR7jWcwXWog1LLxuetCGcmbqxs9DMmqehimupOuuZJBbhzHFWOP6tTeokELKeMoooA==
X-Received: by 2002:a17:903:1b26:b0:23f:e869:9a25 with SMTP id d9443c01a7336-242c224f2cfmr74361005ad.44.1754686667964;
        Fri, 08 Aug 2025 13:57:47 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89768a7sm216840965ad.83.2025.08.08.13.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 13:57:47 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v5 1/2] scsi: sd: make sd_revalidate_disk() return void
Date: Sat,  9 Aug 2025 02:28:18 +0530
Message-ID: <20250808205819.29517-2-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808205819.29517-1-abinashsinghlalotra@gmail.com>
References: <20250808205819.29517-1-abinashsinghlalotra@gmail.com>
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
index 4a68b2ab2804..2f9381dcbcce 100644
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

