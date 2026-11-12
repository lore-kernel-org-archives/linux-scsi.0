Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794444224;
	b=Y8dZ8JB4ohmFTeyBXr4JKPhVs2pqAtHAlKgr5kUwHRfMXPDBPIN34/Gl2yWT2pHT8F2h
	 +MoYuTHeDmdG9sovNDEIiRqoN9FurazssPVVpiAEQsc3Fwz/S8BnBhNicHglnwNhwY2NB
	 nZGJUfpgqwWVsZa7/G1OztPiwa1RE1Lm3aoZigvHeYV/Ej0BViRMwSHCm9Bwy/Q1ieyVS
	 OtF/aOSHfbGGdkIdKJ+ZfZRc3vJnKLgnVvsaIRNQbYzE9snJoLT+z5YOTeQHp1hlj+z6J
	 GYrRY/EytRL7Ep2+EcBaqqqpdJFEXKV+4xVtc14/o0Iw2ewFuENSjv83gVdiMTZt+iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794444224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=hSyluR/dxUK77LHU2y4jYATB8HCJe2GhcZU7P8Sz6hg=;
	b=XFjGIRpKqleq0sAfVuzLs2PGTjrxVAqn++ZK4N8m0/vASxc3jnPU8nbIydhxGhyAA+2U
	 PDPnSMPfj7d2h+mX4Ba8Q1KRq7Za0a2qDECG4cD9o0M2tguIEVfknhe2L+POkIqLPwLb1
	 UxRzpUmU8JOQBko1Fyg7V3usAmRBiOKapCr0TUtNwSrMh9AmMcn+iHKUNd824iv+a17O2
	 kcQbjgLMyiWE6uMWi5PhCqmm6LTg4lTQEehUEAaf/Ledss+9aVGxy0wd7kVeOYEyKfobo
	 RNxOGL+UpCuofmrempnr/xSvbPS2j04+RPCWb/nwIwgy56UgDguUfxf0EbD1hcbfmeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lHobAEFp;
	arc=none smtp.remote-ip=209.85.216.71
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB84606A326
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 00:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCB84606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lHobAEFp
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b0e00d7cc2so3454247a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 16:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794444223; x=1795049023; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hSyluR/dxUK77LHU2y4jYATB8HCJe2GhcZU7P8Sz6hg=;
        b=lHobAEFpPNodsOrZAO/MJWT0XrffSgZyI1gfmeiobgQ3ON+qNjHXPplABL731CQxc/
         9dpI3Ofh7qY4jV0gAMLkXGjiI47Y38wIgpkJlEL8AQDXx6lWak1iKtZLuFNodMzaMyYh
         pfdC5+ns+v8uniBBnL80jNek2BXcSEI5uJstCe9rnuLFypjr2mghMGBVKXLu4iOMibsm
         PFL23tU8WYXqbIfqaJK4WePJlOAwz8Mh/+IhTA4rhegNZIP3bYIBBPuxgGboHvGJALn3
         46DdPJR7mve8re7bXX/dxfPB7qvnqV6zo9GTMYKAUNjtJG82qcxXg60keli1ug1L6v9R
         7+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794444223; x=1795049023;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hSyluR/dxUK77LHU2y4jYATB8HCJe2GhcZU7P8Sz6hg=;
        b=OqgVpbuoQyXVd4dLFYMbG0k7HIFHGT8SrdbX3OPrUzUKq34HpTDCvIk40GZH+Cnm7M
         kFLVnCN+1vy38xa5JM9gWKU91rpgMgUbmIqa0vItSLgei6hnoBDa4d8LxWbd+abc6iNU
         8iDZCTpKU1sGpYIxkP2YwpLq4uAv0p5X/9xm/dfvQ7GZ2/S8skF4lUuFAM3D1Wz+n0Z6
         O/9Im9f2vMXZm/7EXxNZNClRDPL3o8SImt4SgWJegbq+wVcUVGbDNwnp3ju3Ggoz3ump
         sMAJ8ovKYODKCZap1DioMVVbcZnh5BW/X0iyyGCil7P1n3nlZavoWCVNQl7kuTLVAdOI
         uxPA==
X-Forwarded-Encrypted: i=1; AL+hErGBz6fAhRhqfiZeKpMQAinuqEZYplK5SOyGlpWVlZXDTbbIuzHohmXcD7XIRtoFjC5PoI3StkXGddpz@vger.kernel.org
X-Gm-Message-State: APuU4Z+QpnQZT24XJu7VAX2G6VhnlajoBpul81W0VpCFzOyQrZZ1zxLd
	BG9AigxaowqSmTh7ld/g1xSPFWDrxW1rUp5yqegDF4Zk+FXE+lfLOtyNyv252zHgZcrI7SP90y4
	DZaSj1/DinVz0h+kdG2t6rQ==
X-Received: from pgac17.prod.google.com ([2002:a05:6a02:2951:b0:cc7:e0b2:a5a2])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e41:b0:3a7:f4d:b23d with SMTP id 98e67ed59e1d1-3b182f9e1ebmr3416903a91.52.1794444222998;
 Wed, 11 Nov 2026 16:43:42 -0800 (PST)
Date: Thu, 12 Nov 2026 08:43:40 +0800
In-Reply-To: <4ec390037882aa4cbfd8437b5597009058409460.camel@iokpp.de>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20260914144910.931518-1-stanleyjhu@google.com>
 <18d98074c73f90db.3137322e31362e3131332e313435.266ebc.0000sendgmr@google.com> <4ec390037882aa4cbfd8437b5597009058409460.camel@iokpp.de>
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112004340.3079348-1-stanleyjhu@google.com>
Subject: Re: [PATCH v5 0/3] rpmb: Fix request serialisation and teardown races
From: Stanley Jhu <stanleyjhu@google.com>
To: Bean Huo <beanhuo@iokpp.de>, Jens Wiklander <jenswi@kernel.org>, 
	Jens Wiklander <jens.wiklander@oss.qualcomm.com>, Alexey Charkov <alchark@flipper.net>
Cc: "Martin K . Petersen" <mkp@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Avri Altman <avri.altman@sandisk.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Ulf Hansson <ulfh@kernel.org>, Linus Walleij <linusw@kernel.org>, 
	Shyam Saini <shyamsaini@linux.microsoft.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 11, 2026 at 07:49:39PM +0100, Bean Huo wrote:
> Gentle ping. Alexey just hit the same failure on Rockchip and sent a
> separate fix https://patchwork.kernel.org/project/linux-scsi/patch/20261111-ufs-rpmb-bus-v1-1-b07100e53f6c@flipper.net/

Thanks for the ping, Bean. v5 no longer applies to mkp/scsi.git
for-next, so I sent v6 rebased on it:
https://lore.kernel.org/r/20261112004112.3059801-1-stanleyjhu@google.com

Alexey, a Tested-by on v6 from your Rockchip board would be very
welcome.

Thanks,
Stanley
