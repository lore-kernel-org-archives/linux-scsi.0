Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155572165E2
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759745258; cv=none; b=tbI1Oa6nWLygiSPWjeHJ3LLDnzxlrm5syiezFVO9/IlJTdklYVRREoDlsQwTX/xsLz8PABp2Xrll7fBYZqXsWPydvGfxfDBeurjYg97OIhQWNMxzAE42IGp3XI3L7S0dKMqI7tv6xe473MrfYZjliz23a9vf2s56/RQATJYO5SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759745258; c=relaxed/simple;
	bh=Reg6DEUnvSG/PqMheoUThHkpNRwNh1kG272ad8We2Gw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CQDBEp0VQ78qBldUrRwS9MRJ/m+ZzHggNpXLgImlE46CjmdTwOkLAaBjsRfguDNPySBfkAOFyymVbEKZZdJClIz16/UGYsr+dpCiDC4DCXcrp2aDbOnQmhmsS6fQ2TIXA4NivECN8VD1rdzeafnD1E3iMxu2YGm0Mlt4S7flV+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sxkCshM4; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sxkCshM4"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-79f79e37c04so3304221a34.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 03:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759745256; x=1760350056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwsmE3SV2vtMhHon4ZznLX7pnLrz2wmwEFX8iUdXXb4=;
        b=sxkCshM4w7gQLCxgAmpn91btv66isSbGY4g4Jz8yy87UKqSTE7eBp90aEjOORRZEzu
         cVsg4EA1s85JTAO3w1xr/j8fa20hQKRTISPd2D2BXR6Ct2Rk5RCuMaSFDrRH5QW9xXbg
         fD4uVtZTs5WbxZqaUmXkbczA0kW8F5EGa7zvQ61HdTcMxoxB3Gctd++PIpkL187m+SwG
         OUG2HG+L8ZN/WQ22pW7HMCGusAm+PXYpF8Nuw2Dh3EKl0xZaceMWEY7C3z2gEKPP/zeM
         yKvVLRuD2ukrmTTZrhZnCopqbq8Ere68HYqEpEOoopcQ0uevyyrikDnm/Y+UYpGtLn04
         84sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759745256; x=1760350056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fwsmE3SV2vtMhHon4ZznLX7pnLrz2wmwEFX8iUdXXb4=;
        b=muajDefJY9AJFOh0HMqBeHfLvdym6wrnokVRm507ZmwovBL4H/WaSoEaa7yyT5wPpX
         JIUKFeKYhdCM8wFt9Yh2O9ebu9zunBGkTtP9Pt4a9+xHR8M23FnSkZ8lhlbob7yE1uLO
         J2qESyiOUKwrP91xr5chwsWjdWsHz4QlcQPYr61lYITcz4nnGqkaL7YAuAKTv0ieYIUq
         AValI6zW8sLQW/h/YULxWMyhLK4Z9lyTJmSMaJL9k6U4eCYrPMKh+ETcXhKnGLjYeRxt
         59awPgms0CsmgkGrE4jTl/qNAP1fctTCpb/gjWJNG3IOiXOb3oNu+HYBe093jwSToX20
         GIlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx4dsqeirpbEumflUHNQNKZp8XtgYEeQ6WX2vcIMbJ0TgQBFLXwlt6LkNKgdXZhQlP1A9WCc5Vahq1@vger.kernel.org
X-Gm-Message-State: AOJu0YxyMfrn5derN3jiEHjT//4BJcZQ7vfpzjgtLVyZohQiHmn9s+pC
	/FFtZUz0U40WMrdP4Wana/IpnI+8AvfV59MuW2tLCPg/clrj2HR18GzmAeu6tDrIUpMiCw15x9h
	DsZQR3DMHitfwl1GrJqX0zdg5taeDUkctkDiy2rS3UtYJoL/SG5f1M0A=
X-Gm-Gg: ASbGncuM7ZgIS9y1W47dGJRg1Yy+3mybcOOdy+osFcYh5uP26d9RFbR5PVq0Z8TDS4p
	EZBnPqF04NUCT7stq0jzHwOvDyaT4DkQzP0Ynm9ZulcVXwEJXEMzflKbVfsn59HO6xh1QQ5xE7k
	MeTTaiP7NFZ6TSMWeMTgjofn5uf6X6HCJacuos61ADXnfaa/Gr/Q4bVwZnSq2EDj/6xNh6XilDJ
	YMIiFuRS/mLTxNfDOAVPvwPxBQLJxfmQph4
X-Google-Smtp-Source: AGHT+IEdJ5Le2b9EMN+8OcDi2xR/v9zl58sylKncZKdQEw83GkEpTqtV4uR5jTler9bHHHLpjFyrCxpl+3Txo6zqQzs=
X-Received: by 2002:a05:6808:4f53:b0:43d:6a69:7752 with SMTP id
 5614622812f47-43fc176d2fdmr5320387b6e.2.1759745255999; Mon, 06 Oct 2025
 03:07:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001060805.26462-1-beanhuo@iokpp.de> <20251001060805.26462-2-beanhuo@iokpp.de>
In-Reply-To: <20251001060805.26462-2-beanhuo@iokpp.de>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Mon, 6 Oct 2025 12:07:24 +0200
X-Gm-Features: AS18NWDfF8QtP2N_zckbluKcwTLkJmTAFyn3AWX8aYt6fYlCV-dWp71IEBl-Yw0
Message-ID: <CAHUa44FeRN2MWmSngJWKHVXXvUaK9yongfBxbXDLQs357nUq_Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] rpmb: move rpmb_frame struct and constants to
 common header
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	ulf.hansson@linaro.org, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:08=E2=80=AFAM Bean Huo <beanhuo@iokpp.de> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> Move struct rpmb_frame and RPMB operation constants from MMC block
> driver to include/linux/rpmb.h for reuse across different RPMB
> implementations (UFS, NVMe, etc.).
>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/mmc/core/block.c | 42 --------------------------------------
>  include/linux/rpmb.h     | 44 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 42 deletions(-)

Acked-by: Jens Wiklander <jens.wiklander@linaro.org>

Thanks,
Jens
