Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4D81586C3
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 11:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523886; cv=none; b=ZSgSPlZBFiexI0ssItZDNK2ri5k3vwJctboEQaxSsS1JpRScGrAiALlx1bVD397vOoF2Z/gz70ccVjRDSeowsOifYMTatTlNGJ0siGDqJG/ZcHGrpC6nChDmoT/aLK95LcirpCXPWlQhZzQv8MFMgxnKxPWPrRMB/7dtcdFNVB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523886; c=relaxed/simple;
	bh=q4IZnwro1hysVr+IKysyM+k1ocYPSAwKdXkEuBCYQgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pw+up/EkBVvx6o0up7HplnL/FLeySrCKkeYGQAaGZkiIYdN8xxqxyBU2rfoyMbAgrmdGslAk0AY/maSnFVDLVWtOrBAJ1U1hJoP9tuotYgz6SFzbXQyYxPHv+ZNRM9JlJ1Mn5XGxila0jET+2Vwz9uULM4xGdPHi5o/jrS2Bapk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wgpqyzm5; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wgpqyzm5"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5c66909738fso1219090eaf.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jul 2024 04:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720523884; x=1721128684; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/kYqs1Q+xI1eSls+p+PjTZV9wRnUsY1aUqXWiCZsXW4=;
        b=wgpqyzm5uc0nEdrlRqzzE/1SKmc7N6Aij23eWD7uOQCP//TKxO4jkzQa3qtdjjHyKc
         8DMgdCLt55McWVev+PmlXfcBszHBacVzuQbKHFkh2FikIJF+iAQBaiMffDr8ywXs9I8s
         zvKow8P7hHF9ijep8anf2ouI2QdEYEER1r6hu0TpKchjfDykkon37Kyw1F3nvwyaSRwp
         oghe2xrlr/GiSN3HebbeHtyPTeh43D0d6aL9a5KWRW5J5Z3AmTcVObAqV/YJ6YrDgaHF
         SwvhxP7fI5kZbGWmwtKXOcWTdJdCjwrmpmjb6FK0V00ZzZ4yNWx+UVqv5lx+mDAKObdb
         lqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720523884; x=1721128684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/kYqs1Q+xI1eSls+p+PjTZV9wRnUsY1aUqXWiCZsXW4=;
        b=q/ziHpPodUDmorrrP58pydGwJyBn0MW9939xyW95EH1EUmY54IfEB4nQB3lt6ZAxY9
         Ky6yiwc/F+xo8bS4pWw4o6XfCMTMe7SGBq04T1sEaGdBGrS9mkJRs4yO8EWIQ1u8WagO
         Tycif4Mm3LzdCfTntd1BQLByaigQrg5BcwNHBGDyfxEh/HUZaEic2jipoFARgGrUmw/V
         n1PxH9D9Tn8vQAM6tPJQc/vxRyjzEEDc+II+dScenTALSMBf6hGxaXgnuDNbuepGfA2U
         tN2EBYrebO0hRs4Rmcz/q9hxTKpqzxgq+xzm9apfcX3M0bpBtyxXkA0hWC86BMJhLUeG
         AjUw==
X-Gm-Message-State: AOJu0Yyk9e/8InppZ78vKbJd60/xEVQblIkNyj1tcQ3cKf+2Mo4JAxvc
	SVA3Ks4PaDLY7mCf1UMUX40L5AP5gGbGrBNxfvJAVKfdh0VzXPFuvR+aNuHYauGYG+WMlZz4AQH
	KAMzuxLLjK7dRNrGFyuIwfyPsuEkVKhoF9F/sbA==
X-Google-Smtp-Source: AGHT+IEQ9kzUHbR1gBbXXP7izJdEFiG4U52pBXGa8KT7QcUkwLTd1MGDwwCyxR5oZ7xdLEiq7TCBKMzfOJTI2/fJdRA=
X-Received: by 2002:a05:6870:3288:b0:25e:fca:e689 with SMTP id
 586e51a60fabf-25eaf94c51emr846195fac.10.1720523884328; Tue, 09 Jul 2024
 04:18:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708235330.103590-1-ebiggers@kernel.org> <20240708235330.103590-7-ebiggers@kernel.org>
In-Reply-To: <20240708235330.103590-7-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 9 Jul 2024 12:17:53 +0100
Message-ID: <CADrjBPq4sEamwD3+wT2p481en-J2Ee7G0f+UbXG3g3RqUMiv3w@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	William McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Tue, 9 Jul 2024 at 00:55, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add support for Flash Memory Protector (FMP), which is the inline
> encryption hardware on Exynos and Exynos-based SoCs.
>
> Specifically, add support for the "traditional FMP mode" that works on
> many Exynos-based SoCs including gs101.  This is the mode that uses
> "software keys" and is compatible with the upstream kernel's existing
> inline encryption framework in the block and filesystem layers.  I plan
> to add support for the wrapped key support on gs101 at a later time.
>
> Tested on gs101 (specifically Pixel 6) by running the 'encrypt' group of
> xfstests on a filesystem mounted with the 'inlinecrypt' mount option.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>

and

Tested-by: Peter Griffin <peter.griffin@linaro.org>

Tested by running the encrypt group of xfstests on my Pixel 6, using
the Yocto development env described here
https://git.codelinaro.org/linaro/googlelt/pixelscripts

Notes on testing, in addition to above README.

1. Enabled following additional kernel configs gs101_config.fragment
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
CONFIG_SCSI_UFS_CRYPTO=y
CONFIG_BLK_INLINE_ENCRYPTION=y
CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y
CONFIG_CRYPTO_HCTR2=y

2. Add meta-security layer to bblayers.conf and relevant packages to local.conf
BBLAYERS += "/yocto-builds/yocto/meta-security"
IMAGE_INSTALL:append = " xfstests ecryptfs-utils fscryptctl keyutils
cryptmount "

3. Rebuild/reflash Yocto rootfs

bitbake virtual/kernel core-image-full-cmdline
fastboot flash userdata core-image-full-cmdline-google-gs.rootfs.ext4

4. On the device ran the following

mkfs.ext4 -O encrypt /dev/sda26
mkfs.ext4 -O encrypt /dev/sda20
mkdir -p /mnt/scratchdev
mkdir -p /mnt/testdev
mount /dev/sda20 -o inlinecrypt /mnt/testdev
mount /dev/sda26 -o inlinecrypt /mnt/scratchdev
export TEST_DEV=/dev/sda20
export TEST_DIR=/mnt/testdev
export SCRATCH_DEV=/dev/sda26
export SCRATCH_MNT=/mnt/scratchdev
cd /usr/xfstests
check -g encrypt

All 28 tests passed

<snip>
Ran: ext4/024 generic/395 generic/396 generic/397 generic/398
generic/399 generic/419 generic/421 generic/429 generic/435
generic/440 generic/548 generic/549 generic/550 generic/576
generic/580 gener9
Not run: generic/399 generic/550 generic/576 generic/584 generic/613
Passed all 28 tests

kind regards,

Peter

[..]
