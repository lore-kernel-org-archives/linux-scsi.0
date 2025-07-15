Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADCA1991D2
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 12:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752583641; cv=none; b=Y3+odTthquw0vzanq1cZhfqGlgfobmTBxDQGhLG9mPRBpOBw8HuBBXn5a9iP/nqX3hnNFcxuM6zOhkMb+A4X+ioe1R9I2m9jh6nHMpLZUpa9yZwVS8W/xFGV3XspjQ1KUEfMq0ViPDvFkhVqIOb+0JxEQeEjg5NSEb/00naNYII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752583641; c=relaxed/simple;
	bh=j4h1xBx+E5pkAwQur4Yxn6OUCRxH7PHCPHAB1/GSI/8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HM8CwRCVC6opzfNT+zW8LVZm69UbELJqXgttA6Ycx/a6Hs1EeZAu40L7+wDPOOznUYjda7ARUqkDSNuQeMPOTn0oYE8IEtbBYWP+UwkidtA9KsnYCw/0dE19dsn7R+s4eL5RboG/u7JI6+JGNHsRv6pgkbu9307mMfHNvvIYYnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gQ0aKQC1; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gQ0aKQC1"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6070293103cso8572599a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 05:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752583638; x=1753188438; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4h1xBx+E5pkAwQur4Yxn6OUCRxH7PHCPHAB1/GSI/8=;
        b=gQ0aKQC1poUtUcJpzqHSdJk8NlfW1WBLe4PxQJyDNEeTlUdyVTsWwpeKwTfmHC1vPs
         m1eUYTLdbZ88qgYv55OdqNtN2ywazMS1/mZ3E4RjvAQsKHd6d6KJ6BnYTMm0eQqGDvj8
         MaWfwj3x6xZ6RouVdEA+tx38PIGV+ZqmlPIh/thUtoI3hy62uwRlEdPtkQRtkNPMkQyy
         Vcd2O/rKQoxtyRtvWpCyaUNH9RJrGKKaVq1YxpKZuNH5q6XHrcrq/5Pk6aK8PgY4Gi6F
         M8lbLjg50WcUINKkK/BbiKHRD+Xasp2PjkqLHtG8RWsAa3wLvVW9i3p1I+G9TfIolZTo
         xacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752583638; x=1753188438;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j4h1xBx+E5pkAwQur4Yxn6OUCRxH7PHCPHAB1/GSI/8=;
        b=KeHvPyPoAcHXypAKvT8IHLC6MSQmU27a0QSV/wfxKV5zf1YNsPPiSUNCU22q0znXEH
         RrkNZD7uuMjKKxwe5+Aw2YHNVIPTz5RR7BSqq2563B4EQpZsa5fOL9POsJ/bDfumJFJj
         yFo90lS+7m74YiXW3OXfgYBFYX/eD86JFPidZyd9lza01ZabBGbwYIBms4XSlYYMNYVJ
         uWlqdM1SF28Bt2pFg+F/0UXB7OtUP+ATP5Cu9w2v2dU+uSni3NVVy+DnegmMTVaYGwLe
         6rMwtzm/HL/OTsjBeT7+SI1ORxWrzxl1xqIQBJuWUfd3Oul+ZVr0jiN/100OwA28QYtu
         6sUw==
X-Forwarded-Encrypted: i=1; AJvYcCWuRrocPQdfa0wX2IUvi8h5pfv8VUl7G3T3ke5/lMqqMdLn65xgXN6F4QcPEGqjPvIBOj0V3aneH1tA@vger.kernel.org
X-Gm-Message-State: AOJu0YzMcw8AGOgbSwv/cyba4tX+Gi5V0sQd6CwT1U8u7iIpuNCFf1OR
	ATyiRubJXPh5tobQlZLZansLfoTApqoojoiq1mb+MHdbB0XCmqZuAQDR
X-Gm-Gg: ASbGncv8dqbKfrjmK8cWwQrPyLuWHw+sN2bxDZvqnZqPDEmzAHF657KWqitFJOyKvx/
	f9MYNryVraAtU0hwF7aX5UY/3lZhOdTJ1ijzCWB/lozZ5UVlmrPsbFSPc58ZdO7ol6SdEFFnN3/
	S4uK1j+lGDm9d8c4SQA7KlEqLe383Lnnh99S9x2BEk55NZpUVEkmm2WAfypP1eWoKWQgJcNBsLr
	qK00cZ2tUaTVeyzZi8KkamSPc1VfT6Rw48V+YfrDPYguJvSpcujx9HPlzZwoI5OAhpqnnrAulYF
	uoH8uJXdjQxbOIkBydbUK4oR7mWymvgtxsEfHekiyOTnW5B/567WmalFyp1VsnafxzUwWSOypL7
	x7nMMRltA0TvZrER56vzfAVoU
X-Google-Smtp-Source: AGHT+IH/5XlPS/8JwaKs7vIUBvKOKPIH+wiV8Ui0e0Akl3FGy63R8OVzjXmjQrDyDhJWqZ6A1ZX8NQ==
X-Received: by 2002:a17:906:7314:b0:ae0:bd48:b9c2 with SMTP id a640c23a62f3a-ae6fbe866b3mr1799714566b.21.1752583637388;
        Tue, 15 Jul 2025 05:47:17 -0700 (PDT)
Received: from [10.176.234.34] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8294bd9sm1004684766b.132.2025.07.15.05.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 05:47:16 -0700 (PDT)
Message-ID: <f2f221d00bf5d2c83628a098eda72f29a6503f87.camel@gmail.com>
Subject: Re: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
From: Bean Huo <huobean@gmail.com>
To: =?UTF-8?Q?=EC=9D=B4=EC=8A=B9=ED=9D=AC?= <sh043.lee@samsung.com>, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
Date: Tue, 15 Jul 2025 14:47:15 +0200
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
> =C2=A0=C2=A0=20
> [=C2=A0=C2=A0 65.105305] [1: kworker/u32:10:13604] ufshcd-qcom 1d84000.uf=
shc: ufshcd_err_handler finished; HBA state operational
> [=C2=A0=C2=A0 65.105310] [1: kworker/u32:10:13604] ufshcd-qcom 1d84000.uf=
shc: ufshcd_err_handler started; HBA state operational; powered 1; shutting=
 down 0; saved_err =3D 0; saved_uic_err =3D 0; force_reset =3D=20


Thanks for updating the logs =E2=80=94 I can now see the issue clearly.
Please add the appropriate Fixes tag to the patch.

By the way, I prefer the second approach as well and would rather handle re=
covery in a single interface.
It=E2=80=99s strange that it's not working as expected.
However, I don=E2=80=99t see ufschd_recover_pm_err() being invoked in my co=
de either.

kind regards,
Bean
