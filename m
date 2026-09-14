Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875CC481AB3
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397361; cv=none; b=gx4kyLda+3zqYxXzhyDhiecJu9C/ZgvjKwN6rboAwwTx4iRKgthRYS6ZEIl6PK2n9lX/doIRhvcwZpgPexsDcV+OTYx2s8bq7B99l/jYMjaG+S4QnnlVpxwxIhDdN0m/m6wt4aHVVXo0/9rmBWeVr4VHzWKnM7iGelvgcIA9Dcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397361; c=relaxed/simple;
	bh=MOZvIDLp+P4PaYMlBybrB7g2C8901KtST7iPIcuJYX8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A9Ezz319cS9HLqJUSFohrqGyy8/4gdrQnfWQI4qeZPxeMu7hjfGsV3PJVtY53VytCG0WZ6KPSGCBGs/vaH3dYBJUe/sW0KwJPxy6Jop+IljNDOE+4e3II5xujGTHYQlQe+yOsrHRQ87g1MVP4M5BY9kkklauX004deLS3WmYmFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ef5z76FD; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ef5z76FD"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ccb687f82eso45507755ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789397359; x=1790002159; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GLuFMMXFta9UIcczpAvsByGxUUvVheyRObO/swxvTLo=;
        b=Ef5z76FDVm+xuBXJuMir2RXldcRSQn+UhyZYHeluZ3ANDkgC0BYV4ZYlOxsrkJMtZG
         XcKgk+9u61fwoL+eaU+qoxGpb+lOPAt1pc5Yckgwb/ogPFdImK9amogGEhNydQ1Abjj2
         KVz9arysg+XVR1wObSW+dCa6ori2G/ZdWYlkLvnZtHnXM7wGzZvX9F1XyjnOZuqlOApK
         WWMe5SaOgTAer9Rk4q7SbX1UCHe1CwBg1AJQt81tixideRSkCYA+9ytnfBirICrqiRhX
         4Tc+HiIWv7gMALrYq8VEnv/pbL2uVy2MmQqBi/P2uJtnYz+eiL9ZZrTjd6nYqdspVnjr
         wjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397359; x=1790002159;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GLuFMMXFta9UIcczpAvsByGxUUvVheyRObO/swxvTLo=;
        b=HK7V2aYT6g1mmBPrGonlN1FLsUDgjb+CXR98j4Vr85Okz8c+tFG8LKpvEkmCRUNswQ
         p/j5Eqx/t6/5NIg8xVZLW0+PhdVix/N9Sj807VGbVFv3fRUO/KlDEsdFICmz1wHNdJPV
         rVBVwUzuzpGjjyY0WJTA6XjdwcyavU1BYXc/DuWOwhVCD7vlbSy2GVGPBW64uQ04VOJs
         FSZeRBASi0xKuqpD7XzwEaLNLjEH+SsSDnIgT+HmF31HLMj33AKBiek28nbjShk4w4/0
         sNt9TalWmc+/3HL9hKx2q73imjjFep1H5yRdVQkhcgDANwLW0Rsn4GM1j+DxWgxSW/M6
         a/wQ==
X-Forwarded-Encrypted: i=1; AKwUvBwiX+JEVJRvrv2SQGCY3e7cD86hFpKGRjVOxMRVvYhl3asgRv9Bg4aFy9YKbwmwon+iiVKksIoEum4S@vger.kernel.org
X-Gm-Message-State: AFuF++nI5ML0sF683zS3YxCQXPLn5BDSufvpX3VhqP38BDOgFYWD/RN4
	P15+JF1BdI2A7wnhwz2BoZer9IdEKwTBlOaqFosdE5Gc7tqBJZF7zslTKCfGyHwTIByUBEchS8A
	8skwQRpsQGRV7Y0uChiH7Fg==
X-Received: from pldu13.prod.google.com ([2002:a17:903:108d:b0:2db:4e23:16ee])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ebc8:b0:2d8:d4d0:792f with SMTP id d9443c01a7336-2dd6c76cee8mr56584075ad.19.1789397358517;
 Mon, 14 Sep 2026 07:49:18 -0700 (PDT)
Date: Mon, 14 Sep 2026 22:49:10 +0800
In-Reply-To: <20260914144910.931518-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260914144910.931518-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260914144910.931518-4-stanleyjhu@google.com>
Subject: [PATCH v5 3/3] scsi: ufs: rpmb: Drop the unregistered ufs_rpmb bus
From: Stanley Jhu <stanleyjhu@google.com>
To: jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
	can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
	shyamsaini@linux.microsoft.com, alex.bennee@linaro.org, 
	James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufs_rpmb_probe() assigns ufs_rpmb_bus_type to dev.bus, but that bus is
never passed to bus_register(). bus_add_device() used to return success
and leave such a device off the bus. UFS RPMB therefore registered from
v6.19 onwards, with /sys/bus/ufs_rpmb simply absent. Since commit
36f35b8df697 ("driver core: reject devices with unregistered buses") in
v7.2-rc1 it returns -EINVAL instead, and device_register() fails:

  bus_add_device: cannot add device 'ufs_rpmb0' to unregistered bus
  'ufs_rpmb'
  ufshcd 0000:00:02.0: Failed to register UFS RPMB device 0

ufs_rpmb_probe() unwinds on the first failure, so no region registers at
all and /sys/class/rpmb stays empty.

ufs_rpmb_bus_type declares no .match and no .probe, and no driver binds
to it. RPMB devices are exposed to consumers through /sys/class/rpmb/,
which rpmb_dev_register() already sets up. Drop the bus rather than
register it: device_register() works with dev.bus left NULL given a
parent and a release callback, both of which ufs_rpmb_probe() sets.

With the bus gone, on a device advertising four RPMB regions:

  ufshcd 0000:00:02.0: UFS RPMB region 0 registered (capacity=32)
  ufshcd 0000:00:02.0: UFS RPMB region 1 registered (capacity=32)
  ufshcd 0000:00:02.0: UFS RPMB region 2 registered (capacity=32)
  ufshcd 0000:00:02.0: UFS RPMB region 3 registered (capacity=32)

/sys/class/rpmb then holds rpmb0 to rpmb3, and unbinding the host
removes them.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/ufs/core/ufs-rpmb.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index a3e43902bf08..ad3e8b054dc6 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -28,10 +28,6 @@
 #define UFS_RPMB_SEC_PROTOCOL		0xEC	/* JEDEC UFS application */
 #define UFS_RPMB_SEC_PROTOCOL_ID	0x01	/* JEDEC UFS RPMB protocol ID, CDB byte3 */
 
-static const struct bus_type ufs_rpmb_bus_type = {
-	.name = "ufs_rpmb",
-};
-
 /* UFS RPMB device structure */
 struct ufs_rpmb_dev {
 	u8 region_id;
@@ -206,7 +202,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 		ufs_rpmb->sdev = sdev;
 		ufs_rpmb->region_id = region;
 		ufs_rpmb->dev.parent = &sdev->sdev_gendev;
-		ufs_rpmb->dev.bus = &ufs_rpmb_bus_type;
 		ufs_rpmb->dev.release = ufs_rpmb_device_release;
 		dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
 
-- 
2.55.0.1007.g17ff1f9808-goog

