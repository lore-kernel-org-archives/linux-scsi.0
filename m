Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1CC17C77
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2025 11:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752492080; cv=none; b=WUzymDIUlME2+pGWLxcrIprR0FplUdNYrICigMdqhyN7hjW5DB61wvaMyfAFP59yVqa8OmXiDDr5rIgObiZbG4HvMtMq+kGgSjYjDFm+A9fEaLCdzCeXepS71xHEp2xFSxVcUyBJVz2csU0M3FrcUsF1+Rdo0JC5xWZjqsmi8dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752492080; c=relaxed/simple;
	bh=xctNMv3FU6CVTV142T84o4JbDzWuUaOZGL8KSO9CNaQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mkp5VmSnR1Suh5f95T0DC6XVliOcER9gjM2T3kgg+Plbn0/cTqCTEDzfuOel9eeXUmr+/zU4XUUm45lcWqjOo+HnbsGaaM2pdBiTncGUxDKNz/lTJhTUvCZe0QdA48mKQa95dNOeD5svOGKH4sjCjied/ck1HcugvyN1DfyKu8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b8nco8O6; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8nco8O6"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-60dffae17f3so6324092a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2025 04:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752492075; x=1753096875; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xctNMv3FU6CVTV142T84o4JbDzWuUaOZGL8KSO9CNaQ=;
        b=b8nco8O6YB4qibdutbSit+xf8gPlXoUcig57xXL8k8akNM3M5YjH98SY8yEcWduYl8
         gok8nS1UjNt6SwHbOzUg/h81Wb/jYpYQB4D4Oh5zCkfXU7Gyw7rN3Vp/2mb/j9dNGQXS
         I7fAVbCGE/qGI3ZPV3RjPx4P3eh2eah2zhX3LAoFK4Uv1HplQBxC1kzb1FHBYvr5ikbq
         +heb9BNHNnAuZ16d/TkUWl4BCbBn23v42c4Qc+7nZFvjXzD/c6RDteVnghUky3Z/du87
         46lJ3Gn8Y/L8zA1qwr0mWjhHs2rGYFKvnaJOq6O1ob1aVxs4APv8y5K8DLrpRbPGp2zH
         22rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752492075; x=1753096875;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xctNMv3FU6CVTV142T84o4JbDzWuUaOZGL8KSO9CNaQ=;
        b=JFCHrFYj2p75NGxsONAbAN6+4C1aF739fPlDqufp1EHZFnWKw7ECL7CQ9fmN+Upd4L
         zNtjPW/8ApNMnHesjc/F/tFFAdsLDg0ps1mUApHh8xcoEvda6baAQG4wDa/P3AcIzaZj
         kEU8q+1Nl0tdke5Q0UlH6XuggZUKuiLhzo8lEJ01Q1W9oTBYpIL87asxV961TQoJ6YWA
         APh4emUPG5d+YVfXsZrIXpcHIwl1/U+KZAB/zHnvmGeXAXhFYZZJHs+5euHl1GFTv4qw
         ZIGuunoyCYgCGEmgdbT8DyX92fY2WwanGZNWCFEpxWT2fmfIAIFDgFYNljfwzHB7JcX+
         ZHuw==
X-Forwarded-Encrypted: i=1; AJvYcCU/A32u5POz3SMXbHt2JtAt1/xL2gmLOrDtajngw11B1pwlbk89nTLuOsGrr2hwYnEFT1NFtYMfyta6@vger.kernel.org
X-Gm-Message-State: AOJu0YxM996+GgSEPps3xUeWK09cUFHqzyaZnl9Gh/wcLKR91qp39bCN
	KMLIAQzeJ2oGfj+BN9SnDqdXzMi2eiA5/9p8deLVLl0at+71Gge1pn1e
X-Gm-Gg: ASbGnctWi2dvnhM334DxSoTEFh+G8NAdnUcX60IsNA0cUn0/3tKRCrDpIGwk83h5UyH
	CrQ/5kriv2jj0iosvq35QsOnoMdkp8VaJKxy/sLXyudfaRnpfLYo6ZwlACT9HIwEL9p5LZ5t5zU
	gyA3009C5nzVnJgtC3SydImHryV7DdovT8pS/ZZhZvxAjjrEky2H1xcLW7yTb7AWxAA6uZdUAbz
	B7lj1nuFo7ICnkirOxmuGv1r4XnSgzpnxoMOXgTHDiKU/YYtYnoq5e/FmJIxbvoW85PhzLPORLG
	uJAadWBgutHmWEIuNISXF6z5LJGpMQNUVoo64ME0Y5ZVCDb6FiaRn43owABF0lAgqkyBkkFSyzl
	1ksQ9bn99bvAqZJAkGvca2NLnlmYcTGZimFE=
X-Google-Smtp-Source: AGHT+IH2Gh6ZO4CS0lXaePAdcnZ5Mtt21WZqiYFRFMqV/L3IcRL0JvOR+DjK9/I2ykEOY/UjCjJmig==
X-Received: by 2002:aa7:ca52:0:b0:607:ff13:3a24 with SMTP id 4fb4d7f45d1cf-611e84d4f69mr9310147a12.28.1752492074462;
        Mon, 14 Jul 2025 04:21:14 -0700 (PDT)
Received: from [10.176.234.34] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611c94f4587sm5820786a12.5.2025.07.14.04.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 04:21:13 -0700 (PDT)
Message-ID: <b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>
Subject: Re: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
From: Bean Huo <huobean@gmail.com>
To: Seunghui Lee <sh043.lee@samsung.com>, alim.akhtar@samsung.com, 
 avri.altman@wdc.com, bvanassche@acm.org,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
Date: Mon, 14 Jul 2025 13:21:12 +0200
In-Reply-To: <20250714090617.9212-1-sh043.lee@samsung.com>
References: 
	<CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>
	 <20250714090617.9212-1-sh043.lee@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-07-14 at 18:06 +0900, Seunghui Lee wrote:
> If the h8 exit fails during runtime resume process,
> the runtime thread enters runtime suspend immediately
> and the error handler operates at the same time.
> It becomes stuck and cannot be recovered through the error handler.
> To fix this, use link recovery instead of the error handler.
>=20
> Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
> ---
> =C2=A0drivers/ufs/core/ufshcd.c | 10 +++++++++-
> =C2=A01 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 50adfb8b335b..dc2845c32d72 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4340,7 +4340,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,=
 struct uic_command *cmd)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->uic_async_done =3D N=
ULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (reenable_intr)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret && !hba->pm_op_in_prog=
ress) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_set_link_broken(hba);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_schedule_eh_work(hba);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> @@ -4348,6 +4348,14 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba=
, struct uic_command *cmd)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock_irqrestore(hb=
a->host->host_lock, flags);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(&hba->uic_cm=
d_mutex);
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If the h8 exit fails during=
 the runtime resume process,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * it becomes stuck and cannot=
 be recovered through the error handler.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * To fix this, use link recov=
ery instead of the error handler.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret && hba->pm_op_in_progr=
ess)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0ret =3D ufshcd_link_recovery(hba);
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ret;
> =C2=A0}
> =C2=A0
I have one queston:

In the error handler, if the link is broken(set by ufshcd_set_link_broken()=
), then in ufshcd_err_handler(),
will ufshcd_reset_and_restore(hba), does not this work?


Kind regards,
Bean

