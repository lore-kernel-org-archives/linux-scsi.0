Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541343382CA
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707186; cv=pass; b=spaL6G1LlfbvL14l5ST//+Es6VG1Ld3uCdFYoyMJX54xVabE2W+vbCXvxlCnuUfbizRvYDAz4GVXJS+Gn8dEJqZcH4QgKmPg4FhFnicoa3NgKQcawX1j7m6aUYVx1UmjL3H3vjNqRP9m9e7yZMKgz0CuvGw0TNMLKNKHG0EMgcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707186; c=relaxed/simple;
	bh=qMPRz8CcuEOu8W8eWVzoigWcXHvvgJkLwm4p4aQZMMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gDwfIzpN1jpJQCZAKF+1Or0uCzOEwDwcJxeJTWH8bvtdKpcfQaBFoTh3sIW99Qt4qYe6EzaXEBGCfK1lasnihEs/VMBftkpcf69hBDm8tgS1nKe0BKslI3YXv5IT+YsRYTUbULkDAZCkDsnbsAuKW752IEKogU4wzBPdOJ1GCvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UDvwsPb+; arc=pass smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UDvwsPb+"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-59ddb20b720so7460e87.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 09:19:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769707182; cv=none;
        d=google.com; s=arc-20240605;
        b=aODDYF7+LTjco6DTcty1z4XBCixtFDzbwX11fFaoYJQvXDpeQa6mKDfnKLs68ik0GE
         Q6dKJwtVDBp4Kue7GJTIYG4kbaQnR61DgdlMGA1IHc/M6om7Wj9RMi8BqQMnGTjP+9o1
         vEr3LqIxAYQhq7nZZLH2ppP/o6ImfXcpRZJwDL6ioM/rVZMiby8vEMlURZ33JyVMNbrC
         cKr3zNGKE7wyowst7fKPcQqT051xFvKzij2gPa6VuQEmIwumdJvGdKv4BUcKPOouzimN
         DgzNlUGu5i+XehDRYDYL95zw4xsfBmFCqgGBuVP3y46dAEmz3YHUybIa1gbcbxQ3Q0iA
         vewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qMPRz8CcuEOu8W8eWVzoigWcXHvvgJkLwm4p4aQZMMM=;
        fh=Gg2k+xyRa1OZrL98wqXtWhtBV1SEOKnneiWijGp5Sv0=;
        b=dwo30bdQ41BJernLpatVsecHAWB7T2TfVoy6FtJ+LQIsU/3iyUAxYz4t7zPLDgqb1M
         I/hk6yTampJwUQSSdHLa9X/boWEVArei/b+svfrdRxlSEMMdOJUnf5oOu6re6JzuuyeM
         XtlFLhNfGUMOyqM3A6rRib7BjePYpJyuY2v8CetxhPkLrAPK4zdA1vO/vYIWbkkg2yEk
         TZSzS5Z58HKJrlD63hwfyBbG3ah8r3cgCUFusspylHeTCEZxNwB2bWxLPgdz3X82yHJ0
         gURJi1QLFo5JjEFbAlMltBLkT80CKniQ0rqMQeFFficyW1qVV6rPlZ1FoHEfvO5gjnUJ
         quBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769707182; x=1770311982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qMPRz8CcuEOu8W8eWVzoigWcXHvvgJkLwm4p4aQZMMM=;
        b=UDvwsPb+ANO3W4AKTOo0JXcF4z8Lln48aRCrWENHtJUCbddFTKI03zaIcBr8iDrKQC
         ah3bBfGzuV2b+8a+ZrEg2lYGFEmh1023cmzPl89FvmlvcuAWsjnfaIjh1G22o9wdZMwG
         Grp8MPPQ2EdlmgUkW8ntltzOb725h6MT3bVaZ9WcLFkClREolTMi9Ozjj8F6wku865a8
         CeCXKhn0tfUp+GKD3XoXYLai8YFTFPkZtQ0CwGMdgw8wnJ+PetUXhQOHNK/x4pZWY95K
         SytGFkUU5qTBZUokbET+J6Cj5rI3kstbADvFX0yx7M9ufQh3/61Wy7zXO55jQW04i8Si
         Lq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769707182; x=1770311982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qMPRz8CcuEOu8W8eWVzoigWcXHvvgJkLwm4p4aQZMMM=;
        b=Z4nW7HopHVsTQbA/jri5wvsw9CFPZBiR2WoHFaNxTC6QDx7T621zZfMIZWP5qn9kQh
         oONOazrq7/HkF6bMTMvJ0OAdX5CdlMNq4qj1L0DzgPlW3q2xNvz5mNQ6rE+gMs4VP1y1
         X7Vq+Fnep+Jzr/tsrWeRHJSwMmcxhWyP+tOjeXj7+OHReD6/mhzQUaAiYC3jBZuDQXtx
         6WiFYCWQnUdjybb3J2vGF54yvaENGSjktHvig/P3gRfd+69ojtn5AMwW87G1QQzJ+gQs
         2bSy3Q5yS1aKVePbf6NIK1VjVzEiWAn/ttDIvRTSAascPsraAtgbmwxtKJnb0zGTb2IW
         /mdg==
X-Forwarded-Encrypted: i=1; AJvYcCUr0itIcdSjRwycI5xHN1eXuYjXejt2jR1FhKwrA8dlC0Xb3J+uDd9GZOIDxwY0czXYAi3cNhgzxf4Y@vger.kernel.org
X-Gm-Message-State: AOJu0YzFas0NJSyeizHWlTH15wAOh+++jjH7oLat2crYR47G5byHjdhG
	7Beg/JdAGMFwSY5MGH9BOFPW1mFUyeVrPb0FXHoL3fxHnMUdeWVIxuzUCg/l63qtgnhYaHN5eI6
	z2GWHgmJ3LN5dzctdZD8Jm7z6ZmPmzrjZHVn6a8VU
X-Gm-Gg: AZuq6aLoUiW4HqwBg5YJSvUk3i1rMhmXpXp1KNcP+sqHX2nki8IDsPHN9ABYvCCBmd7
	jXLpv9+hmQ7Z4DfRIITqBOJ7ZIr5UqBrp2LxITxLm8T5/ftlZJyYo0nIeLl7mLQUmxqzTBjwhR4
	27sfAW0XECECeaSZK8+pfjP1K6hKXEk+PseAKJ5AIuUj+fsMgnUHnIpFjl6Arkd6p5gKt0uDo3Q
	mimbhs75WKj6hF5sYiHbCIdcWeMNmNpr8XU/25Fr1vhncSbhXfQl8MI0QS8F0Vz1wwLE14nqreZ
	7BxBiVNeApyT9g3hv08MOFU=
X-Received: by 2002:ac2:41c6:0:b0:59b:67e8:1447 with SMTP id
 2adb3069b0e04-59e0f534c7emr129681e87.9.1769707182249; Thu, 29 Jan 2026
 09:19:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129070657.678532-1-thomasyen@google.com> <491d53b9-a110-431b-9a5e-3b46d833fdbb@acm.org>
In-Reply-To: <491d53b9-a110-431b-9a5e-3b46d833fdbb@acm.org>
From: Thomas Yen <thomasyen@google.com>
Date: Fri, 30 Jan 2026 01:19:28 +0800
X-Gm-Features: AZwV_QiDG32hkmkX3wu5y7bnnB92Q2_mE_V-LjMXUX5IPKy4NdnxXX0daM1vNFc
Message-ID: <CALw5pqG735L-6-umZspQOKB9DfRHf7D0AfpkRD_=xwX0LtZ2Vg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
To: Bart Van Assche <bvanassche@acm.org>
Cc: Stable Tree <stable@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bart,

Thanks for the tip regarding the tag ordering. I will ensure the Cc
tag is placed above the Signed-off-by tag in future submissions.

I had just sent v4 (to add the missing Fixes tag) before seeing this
message. Since the code logic in v4 is identical to v3, I hope that is
acceptable. Thanks.

Thomas


On Fri, Jan 30, 2026 at 1:04=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 1/28/26 11:06 PM, Thomas Yen wrote:
> > Ensure that the exception event handling work is explicitly flushed
> > during suspend when the runtime power management level is set to
> > UFS_PM_LVL_0.
> >
> > When the RPM level is zero, the device power mode and link state both
> > remain active. Previously, the UFS core driver bypassed flushing
> > exception event handling jobs in this configuration. This created a rac=
e
> > condition where the driver could attempt to access the host controller
> > to handle an exception after the system had already entered a deep
> > power-down state, resulting in a system crash.
> >
> > Explicitly flush this work and disable auto BKOPs before the suspend
> > callback proceeds. This guarantees that pending exception tasks complet=
e
> > and prevents illegal hardware access during the power-down sequence.
> >
> > Signed-off-by: Thomas Yen <thomasyen@google.com>
> > Cc: Stable Tree <stable@vger.kernel.org>
> For future patch submissions, please place the Cc: tag above the
> Signed-off-by tag. I think that is a widely used convention in the Linux
> kernel community. Anyway:
>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>
