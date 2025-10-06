Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77951F936
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 18:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759773641; cv=none; b=FK5zl5O+udp691sKMXZomcL5lwV4h2nh9Tzxi8HPNpenwibj2CYRsxepl4rsfOD2Xl4xE9S6eLOhk1zRDGi3qVNo4xoD2rSfIrAwHWlbr4eVhs397VFeX7jb9Pxxc7Zzl7FqiI0GuMjofuO0fUjsHIiDqa2a2VStN+Yx/fxODkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759773641; c=relaxed/simple;
	bh=0GEMNRcZziGzb3s681pgK1hZuY+IKAUR9TQA+X75qiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z7yzB8I0BUrA6ia4EdPIRj9r3jIn/rkQK8yGTIUBZ/Y35JoQOK82quIcWGwaQeH+J1JFxbseNVO7ycVbFI4pv7+djyHw+nrLxRPpMbDKmfEBWcIn0Fvi5bQQ/EIIneddREm5PXWzukGmO0FSkhWvic4WLnIfG659fgtgxU6OwCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XGopF/qP; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGopF/qP"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6394b4ff908so8076552a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 11:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759773638; x=1760378438; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inbCGeX0MlCaOTe4pzWEAkquVwCrsIcfcgv0X9AXOR8=;
        b=XGopF/qPtyupbN0LE08URXj6BA3OCXBI4X3IA99iabFOuSjMJHI/cnVZyuud7W7juJ
         2IVLb3DxuhxwCLM76sHpS8JGl2AgjRh8jhhSJaVyE3OChfepX5Ye/z1eljXWGlsREGYD
         rBdGcsoIEZ15Odw4mwYlo6pmtItN9ZaSfeMJWBwI3qw0cLyCD8lkSPfwZszZx7Tu7/T9
         IYRTsEJFZ2nltYgmyjO7z/5sOYYvuPv3ke+37ylNK/UaNbywR0O2uZy29vaFLSW4Trzx
         uKamB45KFXxym6plXieuIeFNRSHiIATxLWfvQcNcLKGGwbTvSl3bV+sA/J1U0B5IJSBf
         ntfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759773638; x=1760378438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=inbCGeX0MlCaOTe4pzWEAkquVwCrsIcfcgv0X9AXOR8=;
        b=ZgeUiFrzJ971jpxTqmHgCqYilMKdEp8QuHteRcusUJsXteYEx0MW7bded/CTsfFZhA
         cAUFdOVuIVo5DtooSWnyp2hD40wsfDN6rorP6z2gxH3oriNknz7uhnpmPmUcsfJ7gtr4
         1gt0KHKvgEqEoReOliIBxvlHjpB+ikYHjduJ4DnxQEtQBN2R4XdsjKfrmMHkPILkCeUl
         q7sWaxR6WAUIP2r/SycHdQMpju2Um7QJd8EVY7jEm/xWIpJQ9pKs5K+SF+1WIIcbPNM4
         tMfIxQ6bwgf+g3VpNXQr4rehjJkRI6OLauf0aqlzoTzwjutkGVTS58Gf7u9Fdq+oHDTR
         sB9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQrvmEKZhbqqbb66R1osiQEuqybzim1n3x6sB5dnS6bVFL9Qt0caL5LBuAp8ZVAL+1yCb/hx5WH3s8@vger.kernel.org
X-Gm-Message-State: AOJu0YyOlFuv+Ah0dxUhN7qJTxsL6keisncChACTbnl+nQ794yfp8syk
	OPRZI/GpapXsDzv8L8hdFXyChHH2WnLIwTUX9r9DpRUP048NiKcZWV8ghuL2eqiK9wXUocuTaSj
	OFJqG4qY4S+AHDXd8TxOOocpndFOi+8A=
X-Gm-Gg: ASbGnctFF1UWbjpW0g0KzYonE4c3LDSEnxWN0KNKg4WbSro+64geflv5mha6S/sOzro
	/GfFYfZPlxEsN3OloHLHnhS7KYoWDBkvNbq2XhjId4ymh+JftVn4obgklRye7kJVoJcyDmeRoPq
	JRlSeoT8g7/7B50SEGh5voudlfsAP+esZPLpO9M6ABn1mKNurYQKjqVYEibS/GgGHaEDP4JN9PU
	ay3wfVyyd300LUru6J2Xjt42BpfazwAswjF+w5GLAcd6wQIua3fHSkfrDzR9wnLx6QTsJhb85I=
X-Google-Smtp-Source: AGHT+IHc/KM682jYWj3WvcK4lSK7EMboJJkdUb1lxllQSBBYt5rLkWpEgXxcvdPFJR/OuHQrWNQ0UC2LN9vnzduKPDI=
X-Received: by 2002:a05:6402:354c:b0:633:d0b7:d6c3 with SMTP id
 4fb4d7f45d1cf-639348e53b3mr15040695a12.5.1759773637242; Mon, 06 Oct 2025
 11:00:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251006174658.217497-1-kshitijvparanjape@gmail.com>
In-Reply-To: <20251006174658.217497-1-kshitijvparanjape@gmail.com>
From: vivek yadav <vivekyadav1207731111@gmail.com>
Date: Mon, 6 Oct 2025 23:30:25 +0530
X-Gm-Features: AS18NWBipFXoldgwotbv0EXeAnZgq5bGgzj04ZlSOSM0MjF-bQqudelsREmIC6Q
Message-ID: <CABPSWR6B0M=nos=wBpjidXMPVYVDKYi0i+-ufuR460_m48vjVw@mail.gmail.com>
Subject: Re: [PATCH] scsi: fix shift out-of-bounds in sg_build_indirect The
 num variable is set to 0. The variable num gets its value from
 scatter_elem_sz. However the minimum value of scatter_elem_sz is PAGE_SHIFT.
 So setting num to PAGE_SIZE when num < PAGE_SIZE.
To: Kshitij Paranjape <kshitijvparanjape@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, skhan@linuxfoundation.org, 
	david.hunter.linux@gmail.com, khalid@kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	stable@vger.kernel.org, syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kshitij,

Subject line of your patch should not exceed more than 80 characters
[recommended]
Please check your patch format.

~~vivek

On Mon, Oct 6, 2025 at 11:17=E2=80=AFPM Kshitij Paranjape
<kshitijvparanjape@gmail.com> wrote:
>
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D270f1c719ee7baab9941
> Signed-off-by: Kshitij Paranjape <kshitijvparanjape@gmail.com>
> ---
>  drivers/scsi/sg.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index effb7e768165..9ae41bb256d7 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1888,6 +1888,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * s=
fp, int buff_size)
>                 if (num < PAGE_SIZE) {
>                         scatter_elem_sz =3D PAGE_SIZE;
>                         scatter_elem_sz_prev =3D PAGE_SIZE;
> +                       num =3D scatter_elem_sz;
>                 } else
>                         scatter_elem_sz_prev =3D num;
>         }
> --
> 2.43.0
>
>
