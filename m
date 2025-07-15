Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4919118DF80
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 15:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592909; cv=none; b=bbAyb6I5JrdGYK0Tpl0BUCwcaBCwEir282AW8QIauKq5ml+QbAUlcoj9ef+RrVdEq4Dq48UKufaAhUNzhR4oQnyxZ0zLG91JXSwES2y6Fb40wh95sQYpUDx3TvCkmJIaykzcqObkqCJ4UnjjGbGubhmtlbELLMKsPa8RANNrzsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592909; c=relaxed/simple;
	bh=VH7YZsMRDiM2yfmDGgerEW0XRR/46B+G/q7OSW+5Pms=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t5RJCpFcuDvzg4ceZu8jlNnxl5ap02IeIixeMp8kZEsjzuJA+vMwEm011hUbv858YqNVA/QpvF2BAOPscOhDp2eyZkqm39k7QFWOJ9JwtOJhWXGZRlV25+VnGav4DoOrRdv/wt3Qu22fZI48o40g5SEOCp3Ed7KIDNpo3tVPpYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TqAcv/Gc; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TqAcv/Gc"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-60c60f7eeaaso8754635a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 08:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752592905; x=1753197705; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VH7YZsMRDiM2yfmDGgerEW0XRR/46B+G/q7OSW+5Pms=;
        b=TqAcv/Gc5oA/cWWbh/IhPLB8FhU0JZDiRgHxpoT5KG2T1xZ4ThZ1rPlkjwNgsaUKNF
         MoscFyKda/zqEKm2NnxPF0SVxktf6oTDbd42O+sftCimiVMd4+B0gOkQZLBDqOzu8Pdm
         OACJ0JcLM4SuWH4hRqvAXOB7j0k3a2jXkEFGGyNG2ZSudi0NvkWTKe1dcDRKaxbDm+QX
         1YKePKg44YnyWNIHtRE/421uOPk9s7T386MpImMOwbNgvGAgtnNY3aUiHRoHbug9RcwM
         ioxCQKOmp4r0p5z8miy+m1E8aDFjIo7wJT9GTkUMZey7ZYMb/+usE6y3JEpjuPXKxtjj
         Rk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752592905; x=1753197705;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VH7YZsMRDiM2yfmDGgerEW0XRR/46B+G/q7OSW+5Pms=;
        b=DHj2vd+y90nTC5/NfN7kCFYnqhgL1YT4C1T9CrnHC45tFlmkExEKxICMQsF6IP2Ntm
         PVJbBhQdiPx0KfxL0M8swg9Yo46vH/doocQz0vnSG7JD4KrSW4+8ZLRVJGnZMfjA0ofm
         gjqJtoIZdBIBgfU/V5T+aNC5RvwNO0mo5a2nXVosouLmYdYpYacVEXJbTVA9A66/ZKpj
         XWIuG6HdQth2zr0031PtDtD8agHSEEeTqsO7H40ASZZqx7dxAmzek8mTPBjYHCSahTAH
         GcBU1KGnYtUUu/EEyEn7susKxo0jBLQsFv+D1mbzFXGBIVIZW50ip10PBqgVwaEQMfHG
         rU7w==
X-Forwarded-Encrypted: i=1; AJvYcCWNm6mZogkPTq1d7dQRa08udvR4t2qyicTr2JrPcJJZYuimmhcMELEQK9xvCjC+k0pW8VbF0mkaksXX@vger.kernel.org
X-Gm-Message-State: AOJu0YzKH3nbBNWH/gr8zWwwRNeWY3GegIfOFcUD4Hi+ywLRQ3zzCr3r
	B1vwI3pSaPK7oBVM047xafP63IvDT6KMKx4ukw2zueMgDAXiUq8NExR+
X-Gm-Gg: ASbGncsOsBjVYo4lhs7jgtT+2BXaKGq2X9Sgy3BcbQiR2Div3if8W6pys9LfosOr4AR
	vN6XDEMAtq1Dw6EzaCi0rkrnfZGVAkzTDjOE8jy3JZpPSIEtM3A4tDeJpmADSIKFppLkpk0PvD4
	W7Bm3sXrjwc2QF1MTG83bLbhgzd/wcNhwGMVu0ZW+xiDTKNZ4lyOWTTy9WFvPsK9CT/sczyE5y7
	k2K1iPhSAsjzm/qqUpJE89qeTy/VrSvyjZheucBvIeFkTFXVVzPiN/soZ38WVcGOEkz/UKSs20o
	DHAe5GEmJXslDqIHUL+I28cvQpNHVKci0q/ZJgKA5JATpwQGbWzBLBE/xersdyUe3U1/fOidZOC
	5L7JHNFMaFb7oRT5dLNxUAKpl6oLd3JBC3Lg=
X-Google-Smtp-Source: AGHT+IFqvERhb/GORXHa/CFpJV9KUuY07dbc5NmNayj5rN4zHUmRNBhOAShvznIppEMIsAm1bTkEZg==
X-Received: by 2002:a05:6402:2547:b0:60c:4bc0:453e with SMTP id 4fb4d7f45d1cf-6126b5b27a7mr2573031a12.2.1752592905053;
        Tue, 15 Jul 2025 08:21:45 -0700 (PDT)
Received: from [10.176.234.34] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611fb169550sm5566966a12.50.2025.07.15.08.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 08:21:44 -0700 (PDT)
Message-ID: <cd0959939d2fefe927b66ca12620c094c4cfb7a2.camel@gmail.com>
Subject: Re: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
From: Bean Huo <huobean@gmail.com>
To: =?UTF-8?Q?=EC=9D=B4=EC=8A=B9=ED=9D=AC?= <sh043.lee@samsung.com>, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
Date: Tue, 15 Jul 2025 17:21:43 +0200
In-Reply-To: <000901dbf52f$63a69090$2af3b1b0$@samsung.com>
References: 
	<CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>
	 <20250714090617.9212-1-sh043.lee@samsung.com>
	 <b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>
	 <000901dbf52f$63a69090$2af3b1b0$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-07-15 at 11:23 +0900, =EC=9D=B4=EC=8A=B9=ED=9D=AC wrote:
>=20
> 2> if eh_in_progress, err EBUSY return in ufshcd_runtime_suspend to guara=
ntee the error handling done.
> -> It doesn't work as well.
>=20
> --- a/common/drivers/ufs/core/ufshcd.c
> +++ b/common/drivers/ufs/core/ufshcd.c
> @@ -10371,6 +10371,9 @@ int ufshcd_runtime_suspend(struct device *dev)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ktime_t start =3D ktime_get();
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ufshcd_eh_in_progress(hba))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return -EBUSY;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D ufshcd_suspend(hba);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace_ufshcd_runtime_suspend(h=
ba, ret,
>=20
> [=C2=A0=C2=A0 63.010841] [4:=C2=A0=C2=A0=C2=A0 kworker/4:0:=C2=A0=C2=A0 5=
2] ufshcd-qcom 1d84000.ufshc: ufshcd_uic_hibern8_exit: hibern8 exit failed.=
 ret =3D -110
> [=C2=A0=C2=A0 63.010844] [4:=C2=A0=C2=A0=C2=A0 kworker/4:0:=C2=A0=C2=A0 5=
2] ufshcd-qcom 1d84000.ufshc: __ufshcd_wl_resume: hibern8 exit failed -110
>=20
> [=C2=A0=C2=A0 63.010845] [0: kworker/u32:10:13604] ufshcd-qcom 1d84000.uf=
shc: ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting do=
wn 0; saved_err =3D 0; saved_uic_err =3D 0; force_reset =3D 0;
> link is broken
>=20
> [=C2=A0=C2=A0 63.011430] [4:=C2=A0=C2=A0=C2=A0 kworker/4:0:=C2=A0=C2=A0 5=
2] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume failed: -110
> [=C2=A0=C2=A0 63.011433] [4:=C2=A0=C2=A0=C2=A0 kworker/4:0:=C2=A0=C2=A0 5=
2] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume: 574917us, pwr_mod=
e(1), link state(3)
> -> ufshcd_wl_runtime_resume failed done.
> =C2=A0=C2=A0 -> ufshcd_rpm_get_sync() in ufshcd_err_handling_prepare()
>=20
> [=C2=A0=C2=A0 63.011457] [4:=C2=A0=C2=A0=C2=A0 kworker/4:0:=C2=A0=C2=A0 5=
2] ufshcd-qcom 1d84000.ufshc: ufshcd_runtime_suspend: eh_in_progress
> -> EBUSY return in ufshcd_runtime_suspend due to eh_in_progress
>=20
> [=C2=A0=C2=A0 63.011464]I[0: kworker/u32:10:13604] ufshcd-qcom 1d84000.uf=
shc: ufshcd_check_errors: Auto Hibern8 Exit failed - status: 0x00000020, up=
mcrs: 0x00000001
> [=C2=A0=C2=A0 63.011468]I[0: kworker/u32:10:13604] ufshcd-qcom 1d84000.uf=
shc: ufshcd_check_errors: saved_err 0x20 saved_uic_err 0x0
>=20
> [=C2=A0=C2=A0 63.039824] [0: kworker/u32:10:13604] ufshcd-qcom 1d84000.uf=
shc: ufs_qcom_device_reset: Waiting for device internal cache flush
>=20
> [=C2=A0=C2=A0 65.084604] [0: kworker/u32:10:13604] ufshcd-qcom 1d84000.uf=
shc: ESI configured
> [=C2=A0=C2=A0 65.084728] [0: kworker/u32:10:13604] ufshcd-qcom 1d84000.uf=
shc: MCQ configured, nr_queues=3D9, io_queues=3D8, read_queue=3D0, poll_que=
ues=3D1, queue_depth=3D64
> -> ufshcd_reset_and_restore() works well.
>=20
> [=C2=A0=C2=A0 65.105186] [1: kworker/u32:10:13604] ufs_device_wlun 0:0:0:=
49488: runtime PM trying to activate child device 0:0:0:49488 but parent (t=
arget0:0:0) is not active
> -> ufschd_recover_pm_err()
> =C2=A0=C2=A0 -> Because of this error, pm_request_resume doesn't call her=
e.


You patched ufshcd_runtime_suspend() to return -EBUSY if eh_in_progress is =
true =E2=80=94 meant to avoid suspend during error handling. I don't unders=
tand why here parent is not active?

would like to try return -EAGAIN?=20


Kind regards,
Bean

