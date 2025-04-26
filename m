Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8CB1C36
	for <linux-scsi@vger.kernel.org>; Sat, 26 Apr 2025 20:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745700912; cv=none; b=Kj1hsa8NY/eRLmUNZkRcd2o6odImekVcJe1/TjE/35Qwu8xLefPPhI6WUztzvHDpSgaQXDlw+UERZ50d18EGamsEFWEGIS0k2ABBQG4q1Xs+zPuPasatC+eutjStMAVXAARVRorfBru41GZR6O5o5nSjzOpdmJ9Z5QC9Ww6x1gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745700912; c=relaxed/simple;
	bh=GR0et2AwKgp3vmVNejIiFHatuZSAnT+uvpuWTUzRXLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jbd9nSgsWq5bAxXK9yiKZEutYAlTqgrhElhQ4gqFYvgG0Y5ViZo1I/TK+6EvjF0fiZfbVfwDYMBPwrdlVOK1rctVY+6Od5oTeMsKehPinDlE1uVOWrW6lorx9q6RerK7Og3D79i32GZGQKAHZ3z5vGT8tv4KEEJS7Cq09iAKvmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=J/AOG9SH; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="J/AOG9SH"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54298ec925bso4562334e87.3
        for <linux-scsi@vger.kernel.org>; Sat, 26 Apr 2025 13:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745700908; x=1746305708; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnDZRPlFbm1053jKklog97r5KegFtkdDeMGDw6bAqlM=;
        b=J/AOG9SHfoEfJ7yO+CJHtHyREPTF79SiVj75FnLP5s9fuKSIfT4v/tYHQ2t0QL4xf6
         /afVoKAJ5dfLs4Kpmuto71gO3j9lN706Y50RPbWKqLH8SMX/bqGxB76VepqLZej0YIqE
         Dp7DHSHwuu3fFRxKmZJ+m4F6txdVKjHSvjMsFVCk/Mg0Qjf35KPZPCtQT/kwIwX53da/
         cip/SgiSjkg2NeZ2SB30l5VY3jNA+z25bqvwdOUGAaoe39uRFmem/F96NJr9wEoFxhDP
         j8MK4U0/rXhW5znv4ArEZNa7gyLuwKYVfTB7GcfZnoLcrfVyXXL7xddeuIUc5ndHFog5
         /Ilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745700908; x=1746305708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnDZRPlFbm1053jKklog97r5KegFtkdDeMGDw6bAqlM=;
        b=Ct0LcAQViYOWrLDPI5oNEjL1tRt/kaf1+4PTpZllmEI4TWYijjMvtNlRJ+begnRUmS
         FEqStg6hA22ootJFoS/Edq+C4qzGHnUbIRKdbIowuxM1wSRZkfjL6rmxToze0tNx2QG4
         WavW65YY0BukGESfuAe9QuNRQKWYfp1n0n3l+Yc3Yo7lseBt+0KWH8y9vT//iL+3Xe9h
         9Et7I4YnoDGfIqzhFbfXIGMw4ghsV0hUFCSLzM40lmlyF67UNyeVF2TWeL4YGSFdSuuo
         rM6xrI2eKTe5TIIrKOr8KDELMOp1ALYpfFxUpkdU/R4nTqHZHu4MKFFIsn2xtF22ILJ9
         VTpA==
X-Gm-Message-State: AOJu0YwCSs4JRZcAyOzi/BmQte5gV9hfPOyNy+dC0cQndc4Zb+gNBpBU
	6ZEsdoMiWX+uRA6sh/y+YpUNMM5ZBzKOhTMY4tq2/mgf/UwzeC0m4qmt20yE6p62K3u3aPUIcVb
	EUXQ8MIjaTsou/Dc0/mpBMwjNiEmHbk49LrfsDA==
X-Gm-Gg: ASbGncuPy18fXvdDnaRs6TAl4MRFbhy9dZJQJVwPiBeJsK08C3NSEFJBbp0Kz+hdMWU
	Ejq72Nr1rZHwxEpyrJ7PL6mpoyXVQjslLnnYXB74QwShvP7LC18yb7C+KdEnTGvT8DYlEljxyn0
	FshH/Jnn8w7vmswuNkpbvpLXI=
X-Google-Smtp-Source: AGHT+IG9RuJtoYCmoJVB354pnG1NBrRFHu/xQtaCwXq0JuOyH1mTTNEjnJhVT82M90oFSmPRqXOPhj+PA7YwCb5dixw=
X-Received: by 2002:a05:6512:3da2:b0:54d:67e3:91cd with SMTP id
 2adb3069b0e04-54e8cc05233mr1862551e87.36.1745700907645; Sat, 26 Apr 2025
 13:55:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi> <20250311112516.5548-4-Kai.Makisara@kolumbus.fi>
In-Reply-To: <20250311112516.5548-4-Kai.Makisara@kolumbus.fi>
From: Lee Duncan <lduncan@suse.com>
Date: Sat, 26 Apr 2025 13:54:55 -0700
X-Gm-Features: ATxdqUFljyPww05GewSOW36IE--aL0kbCwcX3AK3gbfPxQlLese9z01lsjQMX0Y
Message-ID: <CAPj3X_WHRj7eDsyET6Mt4MF0ZvzQoUETnrQkPNRv30qiGsmMPQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] scsi: st: Tighten the page format heuristics with
 MODE SELECT
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	James.Bottomley@hansenpartnership.com, jmeneghi@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2025 at 4:26=E2=80=AFAM Kai M=C3=A4kisara <Kai.Makisara@kol=
umbus.fi> wrote:
>
> In the days when SCSI-2 was emerging, some drives did claim SCSI-2
> but did not correctly implement it. The st driver first tries MODE
> SELECT with the page format bit set to set the block descriptor.
> If not successful, the non-page format is tried.
>
> The test only tests the sense code and this triggers also from
> illegal parameter in the parameter list. The test is limited to
> "old" devices and made more strict to remove false alarms.
>
> Signed-off-by: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
> ---
>  drivers/scsi/st.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 55809f8a62d3..c33c0f2045b7 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3104,7 +3104,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsi=
gned int cmd_in, unsigned lon
>                            cmd_in =3D=3D MTSETDRVBUFFER ||
>                            cmd_in =3D=3D SET_DENS_AND_BLK) {
>                         if (cmdstatp->sense_hdr.sense_key =3D=3D ILLEGAL_=
REQUEST &&
> -                           !(STp->use_pf & PF_TESTED)) {
> +                               cmdstatp->sense_hdr.asc =3D=3D 0x24 &&
> +                               (STp->device)->scsi_level <=3D SCSI_2 &&
> +                               !(STp->use_pf & PF_TESTED)) {
>                                 /* Try the other possible state of Page F=
ormat if not
>                                    already tried */
>                                 STp->use_pf =3D (STp->use_pf ^ USE_PF) | =
PF_TESTED;
> --
> 2.43.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
