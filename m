Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB122FD7CC
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 09:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755162144; cv=none; b=dlts8hHEA0EBST7lEjxrAkJZH7W1c2dZV8iyp/LyXjoyWmwrloI33mnG3cgYcdvTgHKvMrFJJPqmOq5PPv5bdDGvvnyNXr4hY2cLqfkYL11i6O+qXG/1Pu5ETh2Y4Wf8kiJ8NhnXMLr6Ng2hIDLlYQHQGYX89q6nicQrFSKARno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755162144; c=relaxed/simple;
	bh=JLLDng3WCUg9SFgs4ph7xCsBaWrE0h2S4Zx9YViB1I0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EkDRMeDPUfMj0ieIhC1cgx1ls5+0DaqFWEEB4x6dQanSZqWeAYQLlAUhPUH+Y4kAEPJ02f9gp5JEbg1xX+vjpUOwviPTSkHZKvxvPYfEVSCrpboVY6FE033Fm2pz78GttAQFMb9ICSJuDtQrMbxWphYGCK+hhLr4JEgnvQupo8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ehuirhfp; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ehuirhfp"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6188b657bddso1339744a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 02:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755162140; x=1755766940; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JLLDng3WCUg9SFgs4ph7xCsBaWrE0h2S4Zx9YViB1I0=;
        b=EhuirhfpikKq+EiSbJobin7maY6JoGrCFXxnORYA3mtbzldKTfEfed5HS/GlBXY/D9
         sbSHCl23fzasmRIUTyH/Rkb1Qdp/6gSHlw6lpuOpySWObQuwdCzdQOdaWq1R2sm7GZej
         eSSIE1pRtB1jlkXymh9O4s/c4jbRzxeISUIZzNKsd6Uohc3k0IiGiJjA3gXx4clUujoF
         2qtPZYd+78ovYLrppetvqwMkiKwkN6l400r9MNUF35XPYFcHDFqYKWWaPNlOJmR7kp+f
         jCqmTisnU9PhxwV8AQpQr9qWslQRaMTWOBzO6bIspOTGoIBO9VXrI8zKo3Pq6TilDUXP
         gqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755162140; x=1755766940;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JLLDng3WCUg9SFgs4ph7xCsBaWrE0h2S4Zx9YViB1I0=;
        b=WRgDLpM3QNjg0pH1UAvTbPhga/XQpMHJ4xuqqdCMjUi0qMdkDFTsckqLYtIKGtJeEW
         U6C0c5NCeMZ0PhHNIoxgZELrio4He7GU+uHD/3M0P3nlybOJuiHfhNLkRCztRIBinKTt
         kCVsaQ8SMImBmm3lyydWMHoml/yY8E7j8DtlD0AKm7OuF2x/i+BBLOjslVw50nOPLWLz
         0CoE85bTTiqQedXn4U8OacoHtWaLicBbyb9kFdyXZZDf3/gVaB+mm7mbNB17+24nEGV+
         z1YijEdHiyeZBw898JP4tLxmf7UO6q7l3sPmJQ3RbwkgQUFKeGWp5JxIKXaDP9Gt4Vi7
         ZaLg==
X-Gm-Message-State: AOJu0YxG3WmFeE0SQqSoLgHilnIpzRfrMw5uvV2SN8Prtl7hUz1bBa6q
	1tJX/lZgk/r1O6f7+slLpdxJBRf1WzFf6Z/YAfTXa/VqCBvJnUDIUeII
X-Gm-Gg: ASbGncveVb6T+3LEWaNuNOX6au1cYo0XyDHG4Hw2ATRuFA5lenRYAudQxvfNwnlYP1Y
	rO7dD5vVbhjHtdnlTq+ocfQOsQECwOVO5OG8ejzylE3V00rFoOv/CRQC3tQzc/yiFCiEURY/2eK
	9l0VqTC8t2ucA/XlvD/xifa6/d2Km5vOCsR7FgHSCnrmK7+VzwWwaWcRn9MLtfqLmrh197k+6at
	jJJZVSXUd+5f3Vh2VaG9DQYg5rI6ojZ8BWJSZ3ELYVc8I42f5jJ86ptCuZ1+flZkBAQr/emlo4C
	OoRxKTvvBAtxto+dhhe/yiC3m8oqDMq5FdSvvIbFElwTJu7HnQ0J39FGlGdHaZdfsxs0TG21/oq
	NLbcwE43RazL+EI37m4IyIiP/
X-Google-Smtp-Source: AGHT+IEgKSaXupaidQ60pwKNINOwPmWhdb1heOOL2FH3gTuohn5d5ERImoR8xy1Bacr+kfeNprhhLA==
X-Received: by 2002:a05:6402:46c4:b0:618:1d7d:b967 with SMTP id 4fb4d7f45d1cf-6188b9a6132mr2015488a12.12.1755162139466;
        Thu, 14 Aug 2025 02:02:19 -0700 (PDT)
Received: from [10.176.234.34] ([137.201.254.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618461ab3dcsm5372487a12.56.2025.08.14.02.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:02:18 -0700 (PDT)
Message-ID: <2aad6f5c443501e72c776ce96f4aadaa10ed3889.camel@gmail.com>
Subject: Re: [PATCH] ufs: core: Improve IOPS
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>,  Avri Altman <avri.altman@sandisk.com>, Bean Huo
 <beanhuo@micron.com>, Manivannan Sadhasivam <mani@kernel.org>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, Adrian Hunter <adrian.hunter@intel.com>
Date: Thu, 14 Aug 2025 11:02:17 +0200
In-Reply-To: <20250813171049.3399387-1-bvanassche@acm.org>
References: <20250813171049.3399387-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-08-13 at 10:10 -0700, Bart Van Assche wrote:
> Measurements have shown that IOPS improve by 2% - 3% on my UFS 4 test
> setup every time a ktime_get() call is removed from the UFS driver
> command processing path. Hence this patch that modifies
> ufshcd_clk_scaling_start_busy() such that ktime_get() is only called
> if the returned value will be used.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> =C2=A0drivers/ufs/core/ufshcd.c | 4 +++-
> =C2=A01 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b20f262fc8e4..9579e2481062 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2231,11 +2231,13 @@ static void ufshcd_exit_clk_gating(struct ufs_hba=
 *hba)
> =C2=A0static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool queue_resume_work =
=3D false;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ktime_t curr_t =3D ktime_get()=
;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ktime_t curr_t;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!ufshcd_is_clkscaling=
_supported(hba))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0curr_t =3D ktime_get();
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0guard(spinlock_irqsave)(&=
hba->clk_scaling.lock);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!hba->clk_scaling.act=
ive_reqs++)
>=20

Nice!

Reviewed-by: Bean Huo <beanhuo@micron.com>


