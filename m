Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68CD36134
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 10:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720432919; cv=none; b=S0aslVTpDfEQYzeB1xvRlb9kYxC6luxgL0JE9/UAg2IhbPnd+YFxVhJIIHu0z4ozBUiNUV+aGyahCiLet1jjOiSiWHDJDuGDhQn4AX733oRggJljLbr8AH+Oq90uAyHRBYbaCk0c0dtPL8Q0qbVV+w7GGVG3Q43Ho9EF+4hLVso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720432919; c=relaxed/simple;
	bh=SVihhqPsjw1aby9Mnriupbd1CRSchBT64K5CWP/L6Hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EDpSsIDzD3WRh1CulYAmmC6cA1dO5Z7auAsI88LDZB+InQW5g73m/F47DU+tX/AcTjao6novmGYajMew/0IhkyOEshsdbJ/6CEbjTntWpLtAc+aMrNbH0u6nqlJlYCZcjOJsG3rO/Y2QdQUetfrYBjawALp+9juRuYBkSa0x9U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Gxny2AqM; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Gxny2AqM"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3d91e390601so1534118b6e.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 03:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720432917; x=1721037717; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6qk7Fc3i9dd3OlZuL04X6Rue/WRCbHYH2AlZY6gbT1k=;
        b=Gxny2AqMbwE1d+LxjEoKIm/ybDX9dE1fcvgo710lEpPeUFAr7F0Ak4xAURbzAtKwYB
         PpS7tcT2pBnTI+EeYQGsyw9LcoC9o902B2SHRGDoXSjoPkmWX1siZhXK6j9Fqa3K0ZN4
         RdRUycV42/AOFeaUvTggmcNesWaioRj2pO9Yuek19EmnKkCJlegbIGI96bkeo0EPSetf
         vhOteFXR33w0fDso1UUofW9IfFL5J35zG2QEiaqzTyoyO0WeCNCBUEwrx3qlF4nDQlZ2
         wyIq3KCeD6Uw1+ABjbcczLIgORnPdU3jSbWfrcDYBXm7DBoiuhaj8h/6mbgeu4F3b8YB
         1Tyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720432917; x=1721037717;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6qk7Fc3i9dd3OlZuL04X6Rue/WRCbHYH2AlZY6gbT1k=;
        b=v0tiX21olgxNdjsfBheGF7MsxR9N10SgsmErMOMajTX6SGXJMEOEG4NmYtW2/nmlKi
         GBxggn7RIn+ZaklOCzC+0f+eIMs2eVTHd7hmnhaCINIxpdX2Kx0bdIfaNYRHCCozivno
         sBsfwQm6tZx0dElOKHit3xV5aPdwjucDx21XqF63wcqtvaSeCdr/q5CF9LI8yn64RvwY
         iAu6QiNqATI9P0WEmGpNuEWA8eayBn8I49cGFqHfRNRIUPQJsLh0H/IFkmaM+xbn037H
         UGD41lqCK82fTHL5i0NuyXkDhRVviQvIrDCrpHklbnAqNzfqbC+d0dzT2tX/qQWN5ycu
         UL3w==
X-Gm-Message-State: AOJu0YxUF805JQAsSrWquVTQ+Uw3dHlc6l/g4kZKd/lrmwAEgjJgp9pr
	jDoYZsncRbkdEBQReOUiUZMkEhGxTe4xo7VIpl0aFkEE2+8SZqss2q41B3dNq3AFI5AtQSeCTsX
	wBY2M9gNDu1PTQBAqoN8Er3l4DitBNemV523kfQ==
X-Google-Smtp-Source: AGHT+IF3h2FT1NdyCnJBUlwrVg0fkKLI6Bw9BPSqTY3LI5E43LkfcHgkqRxr3+bNUcKY9t3hgY9B887bEbhhWArf5iw=
X-Received: by 2002:a05:6870:2195:b0:25e:24b:e65b with SMTP id
 586e51a60fabf-25e2bec9856mr9419383fac.42.1720432916918; Mon, 08 Jul 2024
 03:01:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-6-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-6-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 8 Jul 2024 11:01:45 +0100
Message-ID: <CADrjBPqrdoDzBesV7e=paz4mj3VDnZTynjPYD6kCV=xe9aszbQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	William McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Tue, 2 Jul 2024 at 08:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Since the nonstandard inline encryption support on Exynos SoCs requires
> that raw cryptographic keys be copied into the PRDT, it is desirable to
> zeroize those keys after each request to keep them from being left in
> memory.  Therefore, add a quirk bit that enables the zeroization.
>
> We could instead do the zeroization unconditionally.  However, using a
> quirk bit avoids adding the zeroization overhead to standard devices.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by:  Peter Griffin <peter.griffin@linaro.org>

[..]

regards,

Peter
