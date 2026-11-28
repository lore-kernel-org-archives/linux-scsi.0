Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795857996;
	b=fLrLd5npCqgqKlewdYcGcLW4PwoLKD4OKaFqBcUEtQ9mJxOsa8bbMbReZ1SuQ6q6iI5I
	 tLPBiPXB66F15pnIh/mg/tC1ifZ1/Ae7N7xOOzjKM5zL7jS5qhjMZVz6gyJ4gc5XdxiKt
	 IOJqWfghDTviO7zLvbswQzjOGO8/SeWXE0bB8JkBSKMuN/X6fKf2RiBiqhLKXEGY9qNmK
	 gBJmX2lLWaY0xqzLAhgaIWgzyeLbJuZwqX30m4g3EcKMjNDOwXJKDIhKDGG31mq9ZX7g+
	 AJBV6P6xJRD2W3Oy0I3s9sulFTkJYY8OsetOT2RxaEbWa13287PMN4UvmKVv7ETYIvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795857996;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc:
	 MIME-Version:Content-Type:Content-Disposition:User-Agent;
	bh=dXthLYgbhH4K4dQPOzjBOY95MCWmDjDCppxjt2xq/3U=;
	b=dwVUpvh9cLYACOuqLDEhKSzVU9/Eo3ROGruRLOYXLlUPr5aWkq//MJsfCTKOAMk3pt2y
	 GI6yCYI8anot/e0nIcnCMBcrLfunWI/EIIp60y2msR+NNbk/X0xM+oyoGr368u/bnBgS+
	 JV6ythdqktc0E0VUB0XV+XSZjWljOnwREzdamxxpwbhmy0ndfLqRSqxXhfR3nun8gQunD
	 Ye8gJRRNk5OZEaLX1nhqtwJYx0sBNTU4eZmPf1pIo1+z4AJOa2inOptu/CyaICUwDjsNq
	 dsr336/iRPu15XeN8mRSgQsiUJTD1+duxKBlrhaUV7lhFkGzU25CwNimCH+lGXU6SjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=qUCQJ6bW;
	arc=none smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E64606A32A
	for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 09:26:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83E64606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=qUCQJ6bW
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b4d6981c67so57839127b3.1
        for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 01:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795857995; x=1796462795; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dXthLYgbhH4K4dQPOzjBOY95MCWmDjDCppxjt2xq/3U=;
        b=qUCQJ6bWqvb52V3+BkjUHK1DHbfP0gUWHUA3JAvuX2rosYTKSbatEhSyetfABiJY4d
         KTEwZN2Ynhc9Jy/WUOZxbmZ3xF2ROjGgg1BcrBIxY8Le9tparMMHm9fhQ1gfqWrWb4MM
         w8Sihwl4/s9Lc44bk7MbWcK8g7lbQ8j3wm9a0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795857995; x=1796462795;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dXthLYgbhH4K4dQPOzjBOY95MCWmDjDCppxjt2xq/3U=;
        b=y2yzYevjxOUqnAJoVdeanQP+Q0m0kn4LuLhfMVeZ/t3YE/cHISr045/601pbGcR0c+
         00DeZWRxjEDYjixghs++T48Zu4R82OVbW3Wwpl2/b70To2yn8KzVNn5qtdknz7rCSNwo
         3lqoMDZtJuVmz4xkJnvHztTK3ELTnUT3yFhlUErblCB7SXp2o5XyWM616hzNLlK52Tq2
         KgkgX5nG30/AANulw2YOspJ6oa1ubXphfIuEqprkgq8mY9NkYD0SdLFPZHTP90ylaW2q
         dfJ3+Ptv9L3d9yj0e4KsgQmURroFaBnFv+6Qk9qSBua6sRzFAC6kkOdATRTZpEerlL7G
         wuQg==
X-Forwarded-Encrypted: i=1; AL+hErFhNHdNAJgOHlI2GtT+dXJmFXZDczQtJtMfwqO9CDghErJqgDof85acy/4uSDCZD2Uv1/hg3xw30oUn@vger.kernel.org
X-Gm-Message-State: APuU4Z/tqAT2mnyZv/UzCiIwMj4OMsoGiRWbefTeLz01WuEeILTlZyQT
	QvJSq6PHEVndaPRrh5GkWlPFAvIGEHwwcc/xNfv5wU3EsrQEB8R0DY8itvmTsR176HY=
X-Gm-Gg: AZFdTZesNSd/ZD2wAV8G2gUoH35OPEigprz7OZ7MfQDKLEQ1h7lnZJC4oTMprtF3Ehv
	3q/PktxYBifaX8Jzrk3t3AR9alNvewmt1hS2F2qHvHVs0jTDbUixzMNHmuMIbCPbzsSJk1mos93
	xdpNmu0iTXrKfnVlphzuVy6kBIpQjRPTPmxeTM2MIBs2zzK7QV1NmmkndZ/wjAAsRVJhgviih76
	3tlH+2GmEPh0VIWeWUPPiNA3FouaEtAre0KY8LOagIx3Id2jAQQ01LWgRI11q2r6ZdANi7//+AQ
	frF5P0+xgyfvCPdsye/KgnLA6L6baxaU40UVf6CVu/LQN7FFcwZxIUbKcMPkfWS8a+p5kanjxtj
	tbjQGdenlx7FMB8l35TIxxUoyn1N8Z2NnoRQeXTGoEJdBiFsv2a03ORTRmKn9d85h7n6OWz8Lao
	3xdd/XnIU4mA7mc3zDwiEW3A9LiGphUnCZGtzW+Gya9xiY2O+/LehyX1QRxz/DR+wCH/Ibhso83
	+sAKp6nlAyv9FZoXG/9CvQUQRGubq1Bwx2LnvN+I0pLJn+fNBFrRmeemI+ljLCTejEOb9qvT3fl
	WwdWfqtN+46Rx2g21q8H6zZdcRxwllzKxT5V3oAXLbD5XTzpeFEtwTlt4OkN8HYSGGdYJ6HUcVr
	Td3ykCkcC8/wGjFFD0J+ZYcauJRvmsA4vy9n/rUiiy07B0gMEvU4C51YJH3uydGe9YTkde+RglC
	AmzIw3jkMtRgxKRjhZYNk1cF864aaw1PdryzwfTkItdBoUWPsKruvdew+PtkkEWKxqKbP6KO79a
	5gYuXGH7h9gkqwsnd1aOYY=
X-Received: by 2002:a05:690c:dc5:b0:8b3:4122:f464 with SMTP id 00721157ae682-8b5204f191bmr139489267b3.55.1795857995500;
        Sat, 28 Nov 2026 01:26:35 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52028d628sm102527817b3.8.2026.11.28.01.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:26:34 -0800 (PST)
Date: Sat, 28 Nov 2026 01:26:33 -0800
Message-ID: <d7cba111662e11f810404d5f39cc72b4a357f442.1795842371.git.chris@chrisdown.name>
In-Reply-To: <cover.1795842371.git.chris@chrisdown.name>
References: <cover.1795842371.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 2/5] scsi: sd: Fix data corruption in WRITE SAME(10) write
 zeroes
To: "Martin K. Petersen" <mkp@kernel.org>,
    "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

In writesame_10_unmap mode we send write zeroes as WRITE SAME(10).
If the LBA or count doesn't fit, we truncate it and can return
success without zeroing the requested range. If the LBA wraps, we
can also corrupt live data near the start of the disk.

The LBA doesn't always fit because WRITE SAME(10) only has 32 bits for
it. Given that, we should only select writesame_10_unmap when a 32-bit
LBA can address the whole disk, and we shouldn't accept it in
zeroing_mode for a bigger disk either. A bigger disk gets WRITE SAME
without UNMAP instead, which already uses the 16-byte command where it
has to.

For the count, let's cap the queue limit when sd selects this mode so
large requests can still unmap in chunks. Writing to zeroing_mode
doesn't update the limits, so don't accept writesame_10_unmap there if
max_write_same_blocks is too big for it.

Fixes: e4b878371b85 ("sd: implement unmapping Write Zeroes")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 drivers/scsi/sd.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c7018a5de847..88b1c1d56d2f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -146,6 +146,12 @@ static void sd_large_pool_destroy(void)
 	mutex_unlock(&sd_mutex_lock);
 }
 
+/* WRITE SAME(10) only has a 32-bit LBA field. */
+static bool sd_can_use_ws10(struct scsi_disk *sdkp)
+{
+	return sdkp->capacity <= 1 + (sector_t)0xffffffff;
+}
+
 static void sd_disable_discard(struct scsi_disk *sdkp)
 {
 	sdkp->provisioning_mode = SD_LBP_DISABLE;
@@ -630,6 +636,11 @@ zeroing_mode_store(struct device *dev, struct device_attribute *attr,
 	if (mode < 0)
 		return -EINVAL;
 
+	if (mode == SD_ZERO_WS10_UNMAP &&
+	    (!sd_can_use_ws10(sdkp) ||
+	     sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS))
+		return -EINVAL;
+
 	sdkp->zeroing_mode = mode;
 
 	return count;
@@ -1214,13 +1225,18 @@ static void sd_config_write_same(struct scsi_disk *sdkp,
 
 	if (sdkp->lbprz && sdkp->lbpws)
 		sdkp->zeroing_mode = SD_ZERO_WS16_UNMAP;
-	else if (sdkp->lbprz && sdkp->lbpws10)
+	else if (sdkp->lbprz && sdkp->lbpws10 && sd_can_use_ws10(sdkp))
 		sdkp->zeroing_mode = SD_ZERO_WS10_UNMAP;
 	else if (sdkp->max_ws_blocks)
 		sdkp->zeroing_mode = SD_ZERO_WS;
 	else
 		sdkp->zeroing_mode = SD_ZERO_WRITE;
 
+	/* Split large requests so they can still unmap. */
+	if (sdkp->zeroing_mode == SD_ZERO_WS10_UNMAP)
+		sdkp->max_ws_blocks = min(sdkp->max_ws_blocks,
+					  (u32)SD_MAX_WS10_BLOCKS);
+
 	if (sdkp->max_ws_blocks &&
 	    sdkp->physical_block_size > logical_block_size) {
 		/*
-- 
2.56.1

