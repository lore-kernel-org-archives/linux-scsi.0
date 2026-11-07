Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794069318;
	b=hjPmP17xBBIxVuUqeXP5hClzfwNnR2lTHnTGYaMasnLTE4O7i8JU9+iHEyzEodo09r66
	 rykVBuiAfN20jBw/cFAbjNTDu7Kwf6InMR7M9NqBhHB6q+HoGdWrKQMgMoU6yNCVYk62e
	 pQ1erb3fH+cMSg726gHNfF36FYIWGiDMqJvndfmCZn9riAxt2VkigmvA7NNtmZKhHOKlV
	 wyxmbRMsm0MKIROXkegBzo4fUz4Q5mOXSbNVmYHneXgdGmdnsVmBBgVhouWV2+lZct3gq
	 Bl3rk1vXHQQi2LHWdivElHxUSLOmB5krJGtQZ9ZxN+HAsjPlWXODr4gttfzoCYyoOig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069318;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=20tO0gCqFaIMc3GUy21bEiP/bDZFkmSZ4ZjOjeh6U0E=;
	b=MaZfIQq0hJJSxNWgSJ1jd+MfW3POxdl1OwcbfnC1Dlp0qiqBLW6RlmjX1it8p1w4Iyb+
	 nVqoVez8lBscBuFKXLDK7QD/yVihl61CkL87MzO4KTsAshfHmY+GRgCsaylNNVBEUoFQ6
	 9bnJYoXo8NQ6/NbaIBPv4YuAVxAfmuCq+Fd/rVcXbqg3kNaS+9MCHX6B73Jec3NTkylpk
	 HZkeoDAn/OeHnh5kOVfCZl5lkWF5xBIIjY6elgiS9FpsCMqka/KBXQwjBObnzOOazIItr
	 v14/RVkg99vymdCkDX+aRnpnljl6XeGYC6oPy2fbVy1tfml+/en8H1mpPW9qwS1JuOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=DApHBhDA;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B33606A326
	for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2026 16:35:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7B33606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=DApHBhDA
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b5a6f2f27fso90851b3a.3
        for <linux-scsi@vger.kernel.org>; Sat, 07 Nov 2026 08:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794069317; x=1794674117; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=20tO0gCqFaIMc3GUy21bEiP/bDZFkmSZ4ZjOjeh6U0E=;
        b=DApHBhDAZt5cCtwwcJoPRrh15WgOWNG/OMKJZirFYhT8d+oxm6iFzq/eL5ldkox2GX
         3UY3SbBT9MtxOcXcDMloZaiJl2lsrBZ/pAvfb08N3szSDmilM38f8unUA33CJceejWdN
         SXA9XpbGQBdpmxCAvprHQQQKL7SoXgWukXDYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794069317; x=1794674117;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=20tO0gCqFaIMc3GUy21bEiP/bDZFkmSZ4ZjOjeh6U0E=;
        b=Xg4x8+vjl+8c9WUYAP8K1jbWuDt2JHoNxKAsTpS6EftgjIbfwBcnvEdR6GqN5YO+K5
         HeIS5qg4Miqr3Ag+BUZDJCWX2lIH1X8KLMMKssGsxAPXjiog/bNejiVhbOLL2nuK9rGS
         6W4eJWXIVTiVmPZDS1cjY/NnXy4VgwzWBXjXDAEahQe/XC8peO/F/dTFpmF7dsimnDIW
         BoqYz1ejIjqTL+ZCzHJvfMXq2pXyXQIhPdRJ5GfgyjWKsQpdNYylySEhwEvqGnIv94iR
         vAso7FbenWc7eh5aJEzCdRuY26cXehzvj+ygpQ7yqGAkn6b6N97wqf976fIko4eae9VN
         GNzg==
X-Forwarded-Encrypted: i=1; AKwUvBx2jdqBv51aQOOvZcUPouzq5N5VtiiTQQXvAX9Hnk4YUV/5C1jxRlnSc0wId1+69y9gRi6NTkeQ8mMn@vger.kernel.org
X-Gm-Message-State: APuU4Z/Uy2LiSaGMManpSNKyleNCtOte6R2EAr56pk8DC0TVKPo6d73R
	ucmyeWxvEsdNOrQqnO1UuHPH/+fMWTuZodxFYRqJEex3fPMzjU0s88jCToz5Tv9qdj0=
X-Gm-Gg: AYBFou2QbUwjM42OQpAk4qWf6pu1Frhbr2yNefhGS4qau8eIUuOx4FxEqzJ1WI8W1+S
	vPINM+ds828yrAZvG78ZbXMoJxAxWZaLSwWgir4O4sRvK9LYu9VcNjpuq8RhMB8Me7v6sKP1J9N
	ny18jdqXfUCpCGqTRRAAN7jY7W6BLYq+7+MMxjkcuZqfbdVyyfxeEOjborau5EXt3+W8/FuExaU
	fR4lcL+vkGXjTQysSHAlf4Bz+5GciwlqKvxQJ4NAaKqPE8tL/6dRA5+kOe6pzx1bxdhwSgtwz3P
	3JyZJrB3Ns0Wgf8Z//+LOOM5V38GqCoCND59ga+1X20bmdFAlgaCW/olDOAkA5Izp0SYt7j3H7+
	GFQl4wt9scPL8IH3q3ZJ54fSxwbyzAXnaMBZ6Ld2Cfywovj5z1KJG3knRoyPPdfOvVdo9Iedcfv
	I2ZD+wJtTkCpitwZLN1Ye8aLJwbhWCBS8bvmioUWGMLk3UT/BDaJiWihCU6ul/d/sdo58Yhrxez
	BYCYsoVs9pyHdE1oKlrj221Bi3kxklR4FoVzn6xLJByXu9ubeovdgY6DgWU6n4A4+rjAxkwRYoT
	IN9TKT+G7gF/+iRGtBjpuOPp19TdnqolUrltaLPfvs7zABAL0rYpahahXuo0ks9c0DxXHiLPu3Y
	oRTy4uPYuNMYN6jrBHePrGJaVUDB9lF4KKT0wDIjnDP0U7pPVn6gBkuZCYKHilKwiJaJ6ZaN5dp
	dwHSFlHz+fRY602FTUPMDA1bj7MfJFgyb4CEEBN2mmXl16Y4+Mh9eS
X-Received: by 2002:a05:6300:220c:b0:3e0:c3f8:4821 with SMTP id adf61e73a8af0-3ebb2a0b0f2mr6449677637.41.1794069316979;
        Sat, 07 Nov 2026 08:35:16 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb8f1ad3c3sm71870a12.16.2026.11.07.08.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:35:15 -0800 (PST)
Date: Sat, 7 Nov 2026 08:35:14 -0800
From: Chris Down <chris@chrisdown.name>
To: "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH 1/2] scsi: sd: Fix data corruption in WRITE SAME(10) write
 zeroes
Message-ID: <5cb23933fe87df3c342d9805a7fe8c2a1e08ff37.1794069087.git.chris@chrisdown.name>
References: <cover.1794069087.git.chris@chrisdown.name>
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
In-Reply-To: <cover.1794069087.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)

In writesame_10_unmap mode, we send write zeroes as WRITE SAME(10).
If the LBA or count doesn't fit, we truncate it and can return
success without zeroing the requested range. If the LBA wraps, we
can also corrupt live data near the start of the disk.

Cap the queue limit when sd selects this mode so large requests can
still unmap in chunks. If the LBA or count still won't fit, fall back
to WRITE SAME(16) with UNMAP clear. All the caller needs is for the
requested blocks to read back as zeroes.

Fixes: e4b878371b85 ("sd: implement unmapping Write Zeroes")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 drivers/scsi/sd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dc45df819c42..a28d11886aca 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1164,7 +1164,10 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 		case SD_ZERO_WS16_UNMAP:
 			return sd_setup_write_same16_cmnd(cmd, true);
 		case SD_ZERO_WS10_UNMAP:
-			return sd_setup_write_same10_cmnd(cmd, true);
+			if (lba <= 0xffffffff && nr_blocks <= 0xffff)
+				return sd_setup_write_same10_cmnd(cmd, true);
+			/* Unmapping is optional for write zeroes. */
+			break;
 		}
 	}
 
@@ -1221,6 +1224,11 @@ static void sd_config_write_same(struct scsi_disk *sdkp,
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
2.54.0

