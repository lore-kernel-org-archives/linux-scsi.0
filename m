Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AB538643B
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 03:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789270603; cv=none; b=LLtP1PYrRFOHUC5EpMaOgYv+XWsYebtSnGfqZ9iFDc5BUPgV6lCNCy17eS00VWziYNWfyjp4Prh6SVALk3Yx1rhHCffTOCx5DvVkj/x4iHfURMcB3dJtlNYg8MOOJOwe+9Vijcwwx2opv7+rEQ3dk+ocQ8BBNCfcbIAW4c/I1dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789270603; c=relaxed/simple;
	bh=y5nlk2rbktcB0mr9bhig5aE1DSOnUCWGPb9Zv50URaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ezaAqIl3f1QUn0nE+VdVDMdbSf34zc6JpnwB3dTqY/TH3uhQ9okPoef92/hZf36ezyE/tPnoFjg+ZmOZCGMA2kDeJp+FlaBzwWjvjwoAGd9/UrHM288+F2PKRbJQ3PnEUTvK7dbM/vKH2OmBhoxXIlQz/dw0KmQlsgzr+N7jAf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nmGOYYym; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nmGOYYym"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc4b524ce78so1674228a12.2
        for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 20:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789270601; x=1789875401; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BpeuUSLBGH+HVGEYbdNREfMzEQGOS789hsIrwdg90ro=;
        b=nmGOYYymJu0BbBMa+PLeVdTRcZX6FCFCsHG3+9ElpkokEsdsZfhPoGh/bSb7fn/oRJ
         bI/X1f7d4vr3VZhfDD4GoF8JtS/mugTw0QCgpTrNw5Ko9A1jF63j1xGMFB6BzeVCFYoB
         A+qGFHF/SmMCPvqrBqmWyr01K3RnU1dD6weRpNwqBfXfTS8zmmamgwS6SDrKgxuYDdBe
         s0Vo2X0DXv5q0X8sB28kdOFatFvGWls9o/ec3W+Bt7ncr5oiuT7UQezk41DMfna3sVMY
         kJBueUbTsb7b6WwxO+R8DTDMCy4oWdP5pi8rgDrU5UKetwyg490W8jCZjHaJVCssPJuk
         VObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789270601; x=1789875401;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BpeuUSLBGH+HVGEYbdNREfMzEQGOS789hsIrwdg90ro=;
        b=Rk6FHdb02Qz0HpPtsyUWUp6+AgTyyR+Oniij+CpTiXXlyNjAkEUM8Rnz76VuB+OanA
         Nogw54vhJu6ZMKmddRfwdGQF1JeykcgQvZjEjagvCRV7Y0N/E69vex7ECKkt2KWLMbYg
         Sqbyc/P5VNgOgfFubvuTywpmge3Z3RxkCiL+Bsvh+y7QEybEJMykQ1Ngl2phUxad5xK9
         ltnjeUbzS9pTtlomENMQcbpCnCCgzC3gebQnIRSOEfMyvX8H/ti6pkIN5vC99OWibRmX
         ffOSScMp+6niuzU3SFv348eZs2piwm4kMnVU9U/eIb2uM8Pl32saL0txhygtjVISJ/Tt
         j2Tg==
X-Forwarded-Encrypted: i=1; AKwUvBxb/ZSYRFxVpV6h+J0J+Q59jW3e8YcnK3Ly8wAluiLSsj7YkiU21LXVxOSObsvTbX+snT/isEgHLtgN@vger.kernel.org
X-Gm-Message-State: AFuF++n67j6SrNUXAlCA7iZG3xKbZDI3WezB94ZQcRfeGMPvQS+r1cjq
	bFMQtpUZSawF0TjA/davnKYjaDqPKX8D0XhZNaR6867/IZ5kgRaG/kW0NT85sn7Mp7RWdJ6Z+G9
	20Oj+Qpwlew35AhEUub0Cog==
X-Received: from pjst9.prod.google.com ([2002:a17:90b:189:b0:39d:915e:403])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:440e:b0:38f:efed:5445 with SMTP id 98e67ed59e1d1-39d9bc0ff30mr19633535a91.4.1789270600695;
 Sat, 12 Sep 2026 20:36:40 -0700 (PDT)
Date: Sun, 13 Sep 2026 11:36:33 +0800
In-Reply-To: <20260913033633.3159296-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260913033633.3159296-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260913033633.3159296-4-stanleyjhu@google.com>
Subject: [PATCH v4 3/3] scsi: ufs: rpmb: Drop the unregistered ufs_rpmb bus
From: Stanley Jhu <stanleyjhu@google.com>
To: jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
	can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
	tomas.winkler@intel.com, shyamsaini@linux.microsoft.com, 
	alex.bennee@linaro.org, James.Bottomley@HansenPartnership.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

ufs_rpmb_probe() assigns ufs_rpmb_bus_type to dev.bus, but that bus is
never passed to bus_register(). bus_add_device() rejects devices on an
unregistered bus, so device_register() has always failed:

  bus_add_device: cannot add device 'ufs_rpmb0' to unregistered bus
  'ufs_rpmb'
  ufshcd 0000:00:02.0: Failed to register UFS RPMB device 0

ufs_rpmb_probe() unwinds on the first failure, so no RPMB region has
ever been registered and /sys/bus/ufs_rpmb/devices/ has never been
populated.

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
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-rpmb.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 373b60aba916..684fb37705c7 100644
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
@@ -208,7 +204,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 		ufs_rpmb->sdev = sdev;
 		ufs_rpmb->region_id = region;
 		ufs_rpmb->dev.parent = &sdev->sdev_gendev;
-		ufs_rpmb->dev.bus = &ufs_rpmb_bus_type;
 		ufs_rpmb->dev.release = ufs_rpmb_device_release;
 		dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
 
-- 
2.55.0.1007.g17ff1f9808-goog

