Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FBB23D7F0
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2026 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779324224; cv=none; b=PA8kVhg7dGBOorBtStwhTSE2EMfT3csx8ExzRuR+frU6s4UDBcUMr695M84BgKO+Tpju1p4e+rHMPrZa/zkpO9V7jkf0V4Ersd2+mGJypwKdsM4MAJXHbWa8/Z93D1BtY8qSBzK1fY5u196XEokmjP+PxIokV8BD8ofmXaFRoDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779324224; c=relaxed/simple;
	bh=IEIzvlRRqDl+bWvL9H8iIJCwiKrUdTUr0U3EgaWDVWo=;
	h=Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fIxEBLK+2R6b8VB9gSXKOXCUiIZKLVvU0ebdWhvzQQG8Tb7PKF1P3KH+qiuR0oeJULWmhNcuwbv5v9rjNJ8hUOevVbuMOcv9dOpekz/PNUTj6ZWurnxKdyp6+4nGPHoVtbzpot643FzUzRc0xPjdKd7Ut8wJWUaZBbm1Jt9gMrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=chDufqv5; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="chDufqv5"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bd8d0e4e341so709775766b.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 17:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779324220; x=1779929020; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+uQ3Q0GrDaAUefTv9AQLXze2AquCr/DP4u2vUROxGQ=;
        b=chDufqv5kulo53fezyEyTxtb2SL3xMz0aYVAukaG4fJKB4kIZzLE5nFXg9LquI2Smw
         z6Uj2B/GoNAeoWLyWXzMfEtGm5kEEQ/Q67fSv88ueH10oZFldfQqNNbD4OiP2W3Ogb9H
         sQhm6u8ic3wJHdyU5xARAvYMkQnN+RpJywI/2xiRgW/Ti1GJg+8ygjX9bQz44mbgHfgD
         lUjfnitFCq6Qzca4B9iwfPefsMQmuJYHEjdo4AnAvn1P+zFgwMJTCRcr8GvRciRaIjsL
         A/2A1f2VV+YrPPP9upn0DC3NriKPWSqHb6fsHdyGpTURNh80goha954gjX+Qs3qOzFz0
         1QwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779324220; x=1779929020;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D+uQ3Q0GrDaAUefTv9AQLXze2AquCr/DP4u2vUROxGQ=;
        b=TfmLSzvVLkIPZ6F+CLErxC2RoSiMeeurSIXLkblZmRAnXbbxayt8UGkw7iAn3JoJPF
         OTgTK+eswSVlg3WLZqzsOVlle2uRpdYfEcMg/vm1XiUs4Vrmw8mFze9q8OfsKDEOmiRQ
         4WqNgS6Jm4QOSVx5VTY9HnAUru8OTAah2ypi9fLErsqtHW+M8TEuvux6fa3To4Bwoajz
         INP43gZfIJg3BgzbLvZMP7vE1VqVgGRuQaUSyeyz+rXGPJAMAWvPB8SqdyVKEQdTI1Xy
         2qRGbwNV1H81Z7REg3EpxYISATgZQv/joYpViD0OQqAy3/EXu1MhLuqTfwAaiVpwfqjq
         NA6w==
X-Forwarded-Encrypted: i=1; AFNElJ/Je19+hT+Nj1fdtmLDgssVGmPTUk/NauIwejMBeybsiFpv3RZJC8zo5tGTSlbUWi6ZySaOXdo/UJun@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlvj3vSiRkvdmr1zZPPCE3RrzFnjWbLDXfayzJhDHsePBDUdFy
	fp2xszGL2S4/7+dayYRpBeBoQ5SEXLWAQ7nxXyaiuS+AgeCOdVRHLh34
X-Gm-Gg: Acq92OGlsU6PMx4JgEhug6NRabOPPU36UqU5xjRHaOQ77xwSykh0obDqQpRgZ+ZiZpK
	0mPQUo8ToR0gwSbwODCGs7TbA8sihFae3znCOAXGPXZFbAatpNdwBA9jx7GLzDEHWIjhaVfjGF/
	1OI9Kh4RFvINwFeFuD4zQb/yYSVqHJqFe7ILeXLiFoR3/F+j9nYPdgQAG3vA3/oclv/N/tBfNf2
	WwUCblPzNHEZ6Zjdnaz2a4Up4S4v8foeDlDA50W/fO/v2gQhcS7ikExQfhMvLFccgehaZ+adVtT
	Cyiu4tFc1ktrK3NQn5kkF7AmklhEp7tfGvRLs/7iMmjNYJe74CTOhTYwvPBNjvUQkqrXzp99Gr7
	Od2LCadJ306EE68OpiPAhTGn1uAaZd4H4JXVKBGtzGo+8aQa+U2N8foHaarFGzQn+9Q12TPSobQ
	9itIo7+TRGNYm1eUxW43Ygo/DTIw9TVJ/D4uQkvJTxBadLcSSRquEE2Hzu0go4mYcVhAYuIeOGM
	QQe3sZAyCQkas2OfZX/pUGoSyQ3fyTgLT8bI2X1m31qjPo0+1U1hjvb1UhGo2pxiimwDmzQxPpC
	KaLN1AtE6vGLdiqdZxlvaPkYeUGZ
X-Received: by 2002:a17:907:3c95:b0:bc3:c6f5:1d47 with SMTP id a640c23a62f3a-bdc12f857c9mr22479466b.11.1779324219917;
        Wed, 20 May 2026 17:43:39 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4dea94bsm919213866b.33.2026.05.20.17.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 17:43:38 -0700 (PDT)
Message-ID: <6a0e553a.010ccaa2.2ab173.fc09@mx.google.com>
Date: Wed, 20 May 2026 17:43:38 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: d.bogdanov@yadro.com
Cc: mlombard@arkamax.eu, martin.petersen@oracle.com, bvanassche@acm.org,
 ddiss@suse.de, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org, hossu.alexandru@gmail.com
Subject: Re: [PATCH v2] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
In-Reply-To: <20260520180204.GA15940@yadro.com>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260518235040.48647-1-hossu.alexandru@gmail.com>
 <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu> <20260520180204.GA15940@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, May 20, 2026, Dmitry Bogdanov <d.bogdanov@yadro.com> wrote:
> Yes, the length of Base64 decoded string is not deterministic.
> Moreover, length of Base64 encoded string must be divisible by 4. Which
> is biger that 4/3 of decoded.
>
> | MD5_SIGNATURE_SIZE      | 16   | 21,33333 | 22       | 24                =
   |
> | SHA256_SIGNATURE_SIZE   | 32   | 42,66667 | 43       | 44                =
   |
>
> So, that formula is not correct and will break all iscsi authentication.

v3 (sent about an hour before your email) already handles this. Trailing
'=3D' are stripped before the comparison, so the check is applied only to
the data characters:

	while (r_len > 0 && chap_r[r_len - 1] =3D=3D '=3D')
		r_len--;
	if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {

Using your table as input:

  MD5 padded:     "data=3D=3D" -> r_len =3D 24-2 =3D 22, 22 <=3D 22 =E2=9C=93
  SHA-256 padded: "data=3D"  -> r_len =3D 44-1 =3D 43, 43 <=3D 43 =E2=9C=93

> Alexandru, may be better just to change size of client_diggest variable
> to match it with chap_r like for initiatorchg and initiatorchg_binhex?

That also prevents the overflow. The length check is preferred for
consistency with the HEX branch, which validates input length before
calling the decoder rather than relying on a larger destination buffer.

Alexandru
