Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8ABB661
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 21:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753392110; cv=none; b=GJhabing3fTwNVfJWorlWnHCB6+RxTIcO3U13EJ9cIXeba9VzoH2E/Kt52GEPL8QLZJP14GL4Afq6yUOI4U+CULiCLKkfBVCr11YaTg//KscQEHEdZXirrrNdX6mCTpZvjDX0CSV6uzMcfnEzwJW3Li4N6n5i/UW2iWtLZRppK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753392110; c=relaxed/simple;
	bh=y1SIf7gY43SwKa7IR0gF6UJkqjIsuRGzDo7QEIv7M80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qebKgV4kZTm/OMcZb7jKya6HY82IIBdZzhFh6qdJK+KBC3ms4OzZEpbYV4NSPyaCHKKoQLxvR+wVN9Lw0MuhkbclO11MpSiKCeJ/Rq7i5HH5iASYXTNzPdmHC6FvUqij1Fw6OwBjbfdI1O5p9Qeeg6XHAbBQpeVhfYYoc92Exus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KDAP1sUn; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KDAP1sUn"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748d96b974cso1291529b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 14:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753392109; x=1753996909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X/z17J3MJSAj5T5y3QojA2SOzybnkEbHLfb3RK0Rs3s=;
        b=KDAP1sUnx5g6oQjaMm1W7ZI5yqss0ELQiP2kqQ59rAuqoWDBUMR/1xMYkpP6j83eqf
         IQsTukJEcWnxN31NTcLh/wCjCjzEL5RxTEYS33Ya7Hw4VXlgZBNER8cZxJoo/36VgL2u
         ZC1pafPPAhlGRtK8yw6tWaJHiRVbQzv8xC0az+SZh6PZk8Ej9oUtsX47WCnh8QyEYn5j
         cxYI7mmhgASTAJECrI8Yhf/8fF6pWmRO/iwKXRnwdbOCOknsXHHN8sjetYA9GwMcK0c1
         l9iOqec4CimewV2a1gHihFLGLtn9uqhRDjupRrhHaOHPzu/NcEJF3wXI3aVbipEYJiG3
         H1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753392109; x=1753996909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/z17J3MJSAj5T5y3QojA2SOzybnkEbHLfb3RK0Rs3s=;
        b=JQyJ8OMXXdoW+FvaGx9erTiM2pvpYS1RK7AvnvG3wxf35Uz4yLiKI6VJgV2QLbT4XX
         sQkHxUgkW4L7DM96zDwiuELBJlpUUVJ8cZvwR2CQCfqWhiTwxojQGoa7KkF9vEYWPIIA
         RCgzCj2o+0i32FBcq0bB9KyVUozRGfFeDAHIwBqOcLh01J2GwDayNXjmjpMv/apEgCyz
         LoiqxPO9XELyNPpAuifkQ1ltQj2iAx7vNpzCq1e628kD6PAOa6vxyYsvZMwCS3+J098+
         gRjlXoIqW0ofGeGbiZ3ba7dE50dunW5KuUee6I6yehdqRY4WtQgd6CqAuUf51Eh0Gqlt
         VAPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXImVLkW8jGQv1exwYZnto9n8N9kQqOBRley4nnxW8CBJ9FASV2xR1/QuMGYIAaXxyltABJuu4WKGDD@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2luShcEppnRgeYkrW1zfwc9IxDEbf1L1NUEEEQSMckJQwblgS
	EY8J2QeaON6N+ZplFJnsTcJXrICs2QeVz78aEJ8g/urzTSZb5of1eEwTi4YZrrvnzZfciKp/J8W
	G7WzvN9NH7dGEvZGlP8umGPQQqg==
X-Google-Smtp-Source: AGHT+IEJ9XYOWVgjjXZ78n5qyUTxKXo4rnIJzirVFj5roXLp7h/SZ8Os1OF5p+0AkWDbfIK/trpg4rsoj9Lv2j7KrQ==
X-Received: from pfbmy24-n2.prod.google.com ([2002:a05:6a00:6d58:20b0:748:df52:fdc5])
 (user=salomondush job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:14ce:b0:73d:fefb:325 with SMTP id d2e1a72fcca58-76034c002ffmr12500904b3a.5.1753392108676;
 Thu, 24 Jul 2025 14:21:48 -0700 (PDT)
Date: Thu, 24 Jul 2025 21:21:37 +0000
In-Reply-To: <CAPE3x153br+UdtWYnxdtAX7hz2OwKYovQeWdeOCWvicTxDayeQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAPE3x153br+UdtWYnxdtAX7hz2OwKYovQeWdeOCWvicTxDayeQ@mail.gmail.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250724212137.105270-1-salomondush@google.com>
Subject: [PATCH v2] scsi: sd: fix sd shutdown to issue START STOP UNIT command appropriately
From: Salomon Dushimirimana <salomondush@google.com>
To: salomondush@google.com
Cc: James.Bottomley@hansenpartnership.com, bvanassche@acm.org, 
	ipylypiv@google.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, vishakhavc@google.com, dlemoal@kernel.org
Content-Type: text/plain; charset="UTF-8"

Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
manage_system_start_stop") enabled libata EH to manage device power mode
trasitions for system suspend/resume and removed the flag from
ata_scsi_dev_config. However, since the sd_shutdown() function still
relies on the manage_system_start_stop flag, a spin-down command is not
issued to the disk with command "echo 1 > /sys/block/sdb/device/delete"

sd_shutdown() can be called for both system/runtime start stop
operations, so utilize the manage_run_time_start_stop flag set in the
ata_scsi_dev_config and issue a spin-down command during disk removal
when the system is running. This is in addition to when the system is
powering off and manage_shutdown flag is set. The
manage_system_start_stop flag will still be used for drivers that still
set the flag.

Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
Change-Id: I820269189d1a2ee03795b8c0db41aa50c0cb484d
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eeaa6af294b81..282000c761f8e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4173,7 +4173,9 @@ static void sd_shutdown(struct device *dev)
 	if ((system_state != SYSTEM_RESTART &&
 	     sdkp->device->manage_system_start_stop) ||
 	    (system_state == SYSTEM_POWER_OFF &&
-	     sdkp->device->manage_shutdown)) {
+	     sdkp->device->manage_shutdown) ||
+	    (system_state == SYSTEM_RUNNING &&
+	     sdkp->device->manage_runtime_start_stop)) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
-- 
2.50.1.470.g6ba607880d-goog

