Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ACB2737E0
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691676; cv=none; b=WnCE7FFfTYMWxS1i6vcvWH17E0+/JSkxUNX4zcmULdlyeA3ZtJciUqGonnexWlbnhCyPnCfOqClzcrLnsT75/o7iBoE+mmBGWq6QcJG+TL3a6FZ2MGk/zY/MhK4zr8yEiwivLxwni+OWLNB8gSdQkb4GneAxyVcbjqCwMYEQojE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691676; c=relaxed/simple;
	bh=ufgKqIgP8UmQ1bSZZ8ZffS0nEZq/QlRpfZabK2nFt34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hK+o2BXLLOABF/2GSO0pxX9GLvoS3Xo39OhICVXjZXS6NnFBGFiLS7v3y1TJ95ZxLDpb06Njxa+LD98ZGSBWtq6LDFyvW9W6xg0xBRPZq9zO0n4kjb44Woyf8UFEO2nxCZdez/dhV1WJqVx8cnKXzU2LBYKfnx3/kcnn8Db4xTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e53UJcKj; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e53UJcKj"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-657523b5db0so1149889eaf.2
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 08:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764691673; x=1765296473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVDxhncTLUZzAxeGgQ+/Pff5dWdNRIlWaEJ3XUBhP6k=;
        b=e53UJcKjdKQZ/cksNKiEeoCT40uYUr0fZ8Trz7irawBHVjk+5FAQoS3KzGNlBkABIT
         TOyj97OLNGGE1Gh50kCUFB7k5/jJgLqn4IsrRA1zgO+glnO8I/h596kHiDU0Hv2WoUpl
         XyUTeD3Kx3iWO3hmfebavZobYS4Nd/b8zd+WOLi1dO+3zmVFh45LyAz5TePcrk3xYG2J
         wlEBTtFjfB/jgIVXdUn4TtS/el7aOBntSrOkMmG4Cu8/pTyI2pOwbmhYU/Ys2//ZJfc9
         xVlFmDSS+X03mGHY6zM9RwBoas6sNOHbcAyKoDo93idtm7uEJ3zY+zBi05aCyTtWId4B
         Lk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691673; x=1765296473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JVDxhncTLUZzAxeGgQ+/Pff5dWdNRIlWaEJ3XUBhP6k=;
        b=U09wQy3bPsG0TR63rxYp5CbJPBN13sP7d77A+XHXGSNIflQtlJRaQJ7vHP/IT005Jy
         udWEhxcxpyhyUGh+yoSRyEM4hl//QPzfciNYBXSOUHjgoKit8+Ym+xURxlUVztu6Wb9u
         Dj798nioFUrR+a2X64npRp4ujpP+ikauurdogLMMwEulRMVyflGG642RfLcYGfh4ekvF
         jErEva4WtCfWP9FRX7tNTMjcrHcVLpVGuhmxf9SU5z9c0cLwOkyjYByT2v5tWYcNGp/h
         qzty6b6OT2xpJCXCrcY2tR8OWxvAnLkkqvC9vt4kqoG9TQkGrTxI6IeLM33bB/+aVPLI
         /aLg==
X-Forwarded-Encrypted: i=1; AJvYcCVN2O1K8F2yOXZjjP7dLCvWGhKQL0w/pMyXq8M6s5U6xwoqsvooGLGEuZyZxHOA4HxbnUAa+jJ84gcM@vger.kernel.org
X-Gm-Message-State: AOJu0YwVakTVSP0xnV8RkwUF4z5vPeB+Z7vBujMwc2EyMycCc16jNO7h
	Hfn/DqgpaxkknNRKwoxF9bSxBiWl1yTrJIvYNLeHeU9wIRS7Lb4ZBJOBELFGfyjTFFpYOGW4E+a
	WeePfCRHaNNb2qyvxIwbTyCbGiqIat8QV/B5E/SAdVw==
X-Gm-Gg: ASbGnct6D9Bf56665g79C728W8sHYSTRf4C/wuHyICnG7mFopp8Q72O6W4HSn41WX2S
	+GIURR00p8x1DgMYwO2CCn4BzqzLvndjoqN1sEaSOW+XJHBaSKb5D4XeQlqtJJm4Logc0LwGeYX
	hl4flJhFzPkSBCTs7NVoS0sUJ3GSj438cvu7NkRHWY0rPHSHB1JpfJPOqL7fIlifxiPmDdoRFcq
	w4emFm1oG2rtSexz2M5xmH+M72pQOoPsVlcuTYYNL34c1t3kn2RVcXIcPzwD6TjVRQJqmaenDRk
	6nu5cP01oHGMFV8WMNuFEVc4Tg==
X-Google-Smtp-Source: AGHT+IEAiZ2W76nI1phpEJedFLponDc7da5KHHni6vqnhnXsJDr+bXEokB0K3rN1LiUhm0iZiuLz1GMvmjYG9CgVCFc=
X-Received: by 2002:a05:6820:2285:b0:657:17a5:b314 with SMTP id
 006d021491bc7-659702eb91amr89387eaf.0.1764691671883; Tue, 02 Dec 2025
 08:07:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202155138.2607210-1-beanhuo@iokpp.de>
In-Reply-To: <20251202155138.2607210-1-beanhuo@iokpp.de>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Tue, 2 Dec 2025 17:07:39 +0100
X-Gm-Features: AWmQ_bnXEdWDGnxkCaMKzIHZ2ZGQX7qmxnor3PEI72ODA58NJAKSwySxqjDIqw8
Message-ID: <CAHUa44HapG7pb-Fh8RORZ7mDmGvENSAf1qbH2Ge62Dko9gpwqw@mail.gmail.com>
Subject: Re: [PATCH v1] scsi: ufs: Fix RPMB link error by reversing Kconfig dependencies
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, avri.altman@sandisk.com, bvanassche@acm.org, 
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com, 
	arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 4:52=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> When CONFIG_SCSI_UFSHCD=3Dy and CONFIG_RPMB=3Dm, the kernel fails to link
> with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove():
>
> ld: drivers/ufs/core/ufshcd.c:8950: undefined reference to `ufs_rpmb_prob=
e'
> ld: drivers/ufs/core/ufshcd.c:10505: undefined reference to `ufs_rpmb_rem=
ove'
>
> The issue is that RPMB depends on its consumers (MMC, UFS) in Kconfig, wh=
ich
> is backwards. This prevents proper module dependency handling when the li=
brary
> is modular but consumers are built-in.
>
> Fix by reversing the dependency:
> - Remove 'depends on MMC || SCSI_UFSHCD' from RPMB Kconfig
> - Add 'depends on RPMB || !RPMB' to SCSI_UFSHCD Kconfig
>
> This allows RPMB to be an independent library while ensuring correct
> linking in all module/built-in combinations.
>
> Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for U=
FS devices")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202511300443.h7sotuL0-lkp@i=
ntel.com/
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Jens Wiklander <jens.wiklander@linaro.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/misc/Kconfig | 1 -
>  drivers/ufs/Kconfig  | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)

Looks good:
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>

Cheers,
Jens
