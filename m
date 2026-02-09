Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED993793D2
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2026 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770650335; cv=pass; b=G3z0YtBTVulNyM7xfplb8hHAJbc9rbcHejDmud7H/GSFztRPlDyytlOEQerrh+Fp7aBO4VZ5Oo9wRVD2cGWqekowkJlr8pFtV/oTJU1UsbOcAMjF9jwJGQ/zL/zcpd+zpT5hu5WGtXSoQBukTuR8Vyjkjc+0mmkhh9RzPN+4emM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770650335; c=relaxed/simple;
	bh=dIWXmylZPzNqdN6BM181qWUOHr0EYoBlXJFLEn66gf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GDWjn4DcsIVvfqZcTpRVJa+TJsmUAOJ21FshhU75Zh792tuI+hOMTBYW+DdNb9CkYa/XblxyZiiJTw9mY42FmrrSxe1xswlSbQYWF18xeMJ0bjbHjaWhOWyDRdYk+2IygP53Rve98XlqYI30LG2VkdgBcesHkHbZuQ1Uas7IQDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=zQGG9RsE; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="zQGG9RsE"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8837152db5so605918866b.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Feb 2026 07:18:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770650333; cv=none;
        d=google.com; s=arc-20240605;
        b=ajhP55d4LCIAdt2q7rrixDoUGPMzU7Jn/nto4grDqmWIMZ+w8aMIxZhx+gbujYofhs
         bh2fk/FEKNqWsrJDfvbuTyqm2Km2eCfdiX98PvZc8Kc8gtYZzawz8t5Ppu1Uarcwcwak
         E9kVmTQYcsxU25ySNzof5x8bXvFpOSQMdy0n7tVjbShKIEVeHwUMvClXep4n68SbiDCp
         qPUVAQY7oozfoeDVdyNLyeEPNrcXRfvIHguOaRdITiIzBfBzlcMO1fGQ9GVSc9LEf7YQ
         ZLzZRrQ/OO0fnu7YR6Xe2+tRP0xkpAYTuEm7lu3NTaw/Y9fm8SJDCJWvYYg8BYDa4sA4
         WDmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sWZTFl9HnKvhHeUb1Vsrqj6kNSRtJUq9FBG0uoT0OjI=;
        fh=tySuugcvanpjueTx330NxoWEEXv4YzTcxfySTe+v/Kg=;
        b=bMcoe6qA33qfODwSwJh/qTmSnyyNFdLuIvBqm7Fjf/QhfKr9asL+l5+3JtkH5Z5Tyb
         TpBB0a35JheWtys6L4/ZFefc0jZ53N9jCMCu5i2D06Eg1sylBoodnY8taEh8YHQUrpiK
         WY9aoCAbfgIvBZUWdwhW+YbQpG14IBdGWQhRqOy3IiSCxfOc7aa2BQjT0z8ewP6fLfBI
         3fa2mYCO7kvKLCHtCrUs4ej7XfOpROOrDV3x36izKvVVr9WKi9spBhdw4jOVCnxzj0+G
         JpYZ0dzF2V7Dsi4fYLWk2LnOscw4oKMcYNb7CVgUGzOVJJveCJZNEo4FoAVnPH3zvsu8
         MOUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1770650333; x=1771255133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sWZTFl9HnKvhHeUb1Vsrqj6kNSRtJUq9FBG0uoT0OjI=;
        b=zQGG9RsEINuQ4pz6XMSjMEAs75/TyiClNt2exu7J1EoQF5QFBzleTEyk1TC77w/bdQ
         cdYFM8UPksv0Cwil9uSHlYciocJoxp72UPBsokkUk/NbQ4M4wqU62S/GDQn7ad6XZrer
         gJ5s/74nc0Ub2EyqdLk5TzZpGd7xRlh0TzwxQs86+dvcxgpbb7Ij6p9B2fACMB3EtiLe
         R1MegnAyvPpzj8tFdyyiA0FFZW874hxNO6P/mP3zLq2SXnKDXbQCJhDYJWzvPUcDobTA
         ogMQxa1nl/Y8Yn3tQhWWyg8ZvpnL4p8mIQRBBkbeWvVruc5vOQ0fghQ2djz2vc/FYOeN
         i4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770650333; x=1771255133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sWZTFl9HnKvhHeUb1Vsrqj6kNSRtJUq9FBG0uoT0OjI=;
        b=hs6l2jXbUuRY4MkIaCe9Salx/5Il07/lneGwK17sl7Q+6dO8T8UtnwAX770K9tyiDG
         vwdRRPCoan3racCgf221AiEQIFl1MqENHz30EmtRi8yViGmiLy9uoNtHKwbzOZv8qwaO
         Qod4NcYA7exiQq8txZieIkXUMCZJ9vEyYEyxoUbDkHgxVqCVMfqAGTTVVHIjdV0+zuL/
         mS6vJ7p6EQvC9JBZNe9E7eKfqlBgH7gEUuS8qaout5MBb2SjpgEneVvnClgJtGHEqgfM
         JGm8lH+khBXqVH1NQ7f1ysUjO/pSIdTWP065qKDP4Vqo4X0eTkTJ90e8tNX5CJtWrJYg
         zcGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVnync/Be1wnQ7EzHD8i+08iwLqjJcsC2mJE+Z+oFFAx8t5T7Ji5FxWNMEmg40SV7mYsRflWOSQh9t@vger.kernel.org
X-Gm-Message-State: AOJu0YxdLJFfBt0K9cI3MEbjOwJlhuGmWfnRK+rQ4IXBZOftwqJ9OYUq
	XAS867iKZ7/6Z9R5nzXG2dksHtaE/xGFMZpKWVhQ1+oJONDE+EsJJiNNV8BS5LjjDdqxzIjlanA
	MBqCMIYOC1j4wI3l/m3b2Lfu9A7oGxm1XwykweI/rrQ==
X-Gm-Gg: AZuq6aJqC+XqFkl070ZFlWR55umqWvXV4duS54xAEu41vH+zzk/GPqY6yNH+E/zxNu7
	su4NCGnTTJYTR2RjAXEXZmy1dfm+DVKtm7P+2zH5ARImWmBtDtcyUO8UqijEHb41mJmTtteRAet
	32UY0e7TY1mQ9OnQcSz49BF4ftcNmA/QNrFxptuqtwIPaxCl6TeukA0Nkxfge/lBA26ZTNdMvmN
	pJ+q0ytuuXvkOLycEhpHPWPeHL9qXPUyF+jL5EiTk0ZnJVk0/xtDSIoLIcOrYmIVgQh1M96bpuM
	rHvgmDeabdFxpLuMblN35GMu017Z6CGwyjc6tQ==
X-Received: by 2002:a17:907:6d0c:b0:b8e:d4ed:5ea8 with SMTP id
 a640c23a62f3a-b8edf2ffe66mr675457466b.42.1770650332900; Mon, 09 Feb 2026
 07:18:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205-ufs-rpmb-v2-1-5e1572ee52bf@flipper.net> <e96f69b108eb13a87838581aef9325dd74c556d0.camel@gmail.com>
In-Reply-To: <e96f69b108eb13a87838581aef9325dd74c556d0.camel@gmail.com>
From: Alexey Charkov <alchark@flipper.net>
Date: Mon, 9 Feb 2026 19:18:41 +0400
X-Gm-Features: AZwV_Qi7l8Lun8llFPbeVBs0F2HyCOP24UjzbWTJPUSSNzBWpVTvupK184oPlqU
Message-ID: <CAKTNdwGSYcD430zcuD=z=o5=pRDDvZtDNSY8SYtnyiuUB8r2Bw@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix RPMB region size detection for
 UFS 2.2
To: Bean Huo <huobean@gmail.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 9, 2026 at 6:51=E2=80=AFPM Bean Huo <huobean@gmail.com> wrote:
>
> On Thu, 2026-02-05 at 12:30 +0400, Alexey Charkov wrote:
> > Older UFS spec devices (2.2 and earlier) do not expose per-region RPMB
> > sizes, as only one RPMB region is supported. In such cases, the size of
> > the single RPMB region can be deduced from the Logical Block Count and
> > Logical Block Size fields in the RPMB Unit Descriptor.
> >
> > Add a fallback mechanism to calculate the RPMB region size from these
> > fields if the device implements an older spec, so that the RPMB driver
> > can work with such devices - otherwise it silently skips the whole RPMB=
.
> >
> >         Section 14.1.4.6 (RPMB Unit Descriptor)
> >
> > Link: https://www.jedec.org/system/files/docs/JESD220C-2_2.pdf
> > Cc: stable@vger.kernel.org
> > Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for=
 UFS
> > devices")
> > Signed-off-by: Alexey Charkov <alchark@flipper.net>
>
> Hi Alexey,
>
> please address Bart's suggestion in the next version, and add my reviewed=
 tag.
>
> Reviewed-by: Bean Huo <beanhuo@micron.com>

Thanks Bean! Added in v3, along with the fixed comment per Bart's feedback.

Best regards,
Alexey
