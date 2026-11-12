Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794444085;
	b=NN5wWdKkZUXYihS/MGZZpNCbLhLelaFOMZqAwLzrim6+sQr82TwnAFfogmvJj6/okEsP
	 1EBCNUTlFzVHcYGwhdyr7OkQbbZ+i8y+AQKg7o4moXUU4DqHTWM7W2IdFLXdQE7Jn9/mN
	 6ka6okCBbU8f5TMiOdTedthVgHQ/Bx6c3IM0UGZc3wUyYJCurivjuBfBdHd/3Cgm8V5WO
	 8gZqVEcQL1llh6/mgyj5Lv2OmyDNadaKLELr4nMNB1KhD97+YLtlAHEDn9fVTY475RHi7
	 JRwW6fZPragqsC3qjehJuKFVgcHUmFrViHk7g+LRrN0bdnkKAVkUipUFJ6DkXGy/7Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794444085;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=izpK0qiPp9EDp8rLCg6Dje1fDMudES+DfbenuKy5KPY=;
	b=SyKVK/mPhoKd8kBYHHwKN71J8JRkgT7XSoc9WYrRowf0NoM4C3J984pcS8fx6ttfpFkL
	 ygb79YB9NmjIw5rsHXPNU/PROgvFbXHh2I0FlyLVqIBYh4LTIwgsSzKGOWgTeKUnw+L11
	 Hgjpd5SJb1UXWZZrH5VPgQDUHM3EG3hPfnTu1UvTty/jemjyJc0Linj4px9OQmE+5BpfC
	 LZGxXAwQWe9Se7M7h5BnBAED8rwXtEuZu5N0amavQEao8QtS7ZrtDFZrXtf4WcLA4mAe8
	 LjxVT7NuibYj5XYzlmg6vsiML2niWy//QOOh674Y/IumC2xcoESgeIDR0HFix8QPXOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="J/3F0HPb";
	arc=none smtp.remote-ip=209.85.215.199
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FD160A260E
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 00:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29FD160A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=J/3F0HPb
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd5ca3840c5so3893686a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 16:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794444084; x=1795048884; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=izpK0qiPp9EDp8rLCg6Dje1fDMudES+DfbenuKy5KPY=;
        b=J/3F0HPbxmMssjL2YGdtICYkjUPYF5mEBw6p0geVV8v5RDPQIqAnRPtGFwDJrcPC7J
         PihVv9jcsjamuf0O85qOMP3b2DK+8aAQqPSK1PLFc5//IglVOHEbPgRH9lUbpzbfUdhp
         G6RjIt+JO1rIGqPyiEmoKl9kawf0HSmCWtdSy4QACqU+OdFxX55U3HZ0QmQYNtPGcf80
         eKe/8/Ev8QRyqm1LovRcbdXEp4aheY4oS7PXgpV22s8mbVGGW4mjSsSIC0dbfJIwNqsq
         1TfQbt/39mph01aChZOVDep7glrCLHAY+rj4JMLLmrlb+VZ4MZ4+D1zFj8KQIfdi12DS
         8QBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794444084; x=1795048884;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=izpK0qiPp9EDp8rLCg6Dje1fDMudES+DfbenuKy5KPY=;
        b=KByACJXu6gshgzqhtLnEibC6F8lx+lQkMzWl3zM9+i+WR5IRszb+McfDRVrKnkZbjl
         WN2aHa2N10KvOHnZx4pkVo7CQ62fRSJ1xiKnLFmHZedDh83ZR7YzQNxFJu8BhpCMbjnx
         rzjuOdlU/a5VgaGOuxsaXuAhDSx+epidSBhD439RKzh9KuAR00IfoDRTfmilPstySmDd
         fS/KMdvgSWGyN3waPr/oZiscFGIAuU6sQWsrdJWUMDY7FDU2/XZ1PfRP3ejI8qEPfxf9
         2uqEMdst/OEk2lzxrClLgWsbLyeg+dU/yRScxr+9paP0OJAxP/ZYiMM5LSWOjkfWk6+e
         ncWg==
X-Forwarded-Encrypted: i=1; AL+hErFsc5pgeaoreMKOjRG6Qz47LqNPhB5M4Ijw8qJ3RJY0j77jDgSdQShuoQQpjmoBmvQi+kvOR721CpO5@vger.kernel.org
X-Gm-Message-State: APuU4Z+3HDZv2y+76+QzLv0mjM1xSlth/1Fe7WKES7pEvHNQi74yBscm
	gtuirIokJVPtGmdxS5o7VHFdaT+TMRjhnvzz4bJqgP1hyIcJi6ANCqVxg44kKh7kl60JeIdusxq
	W7eOMEImISDQMosdTXTfTyg==
X-Received: from pgq9.prod.google.com ([2002:a63:1049:0:b0:cd8:b3c4:e64d])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:748b:b0:3ef:ed4d:520b with SMTP id adf61e73a8af0-3f2fd195b16mr3698235637.21.1794444084204;
 Wed, 11 Nov 2026 16:41:24 -0800 (PST)
Date: Thu, 12 Nov 2026 08:41:12 +0800
In-Reply-To: <20261112004112.3059801-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261112004112.3059801-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112004112.3059801-4-stanleyjhu@google.com>
Subject: [PATCH v6 3/3] scsi: ufs: rpmb: Drop the unregistered ufs_rpmb bus
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, Jens Wiklander <jenswi@kernel.org>, linux-scsi@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Avri Altman <avri.altman@sandisk.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@iokpp.de>, 
	Bean Huo <beanhuo@micron.com>, Alexey Charkov <alchark@flipper.net>, 
	Can Guo <can.guo@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>, 
	Linus Walleij <linusw@kernel.org>, Shyam Saini <shyamsaini@linux.microsoft.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufs_rpmb_probe() assigns ufs_rpmb_bus_type to dev.bus without ever
calling bus_register(). Since commit 36f35b8df697 ("driver core: reject
devices with unregistered buses"), device_register() rejects
unregistered buses with -EINVAL and UFS RPMB region registration fails.

ufs_rpmb_bus_type defines no callbacks and has no drivers, and
consumers look up regions through /sys/class/rpmb. Drop
ufs_rpmb_bus_type and leave dev.bus unset.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-rpmb.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 11d2d8e789d0..6803f3e62d78 100644
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
2.56.0.567.gdb80ae8cd5-goog

