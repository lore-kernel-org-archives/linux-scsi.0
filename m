Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C691D5CFB
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 03:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781751966; cv=pass; b=PGV8qc8z4DJLyhCv+Nbo/FsbagpWMb12FCEChYc9HlXgnjyt8mMAqwNn3Z3Aia7Lcztx0PyeGATyyxD4b5rWnXcac9XEqHmoN5U0WeiG+OCXNsbZSZpLelgR8+zKRaz4o6uVXJSQ4pWCi693iimo7aenlT4StS11Q0BfBb/NrX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781751966; c=relaxed/simple;
	bh=e127pn6LW6tWjlOu9OkPQSyzPri3W469H9m6nmPZIco=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Crk7rwQcN17vZsC1w12xpqs+Eogs9B7xrdkOrWg9EW3MsQhT3jFCu7n4N1TyHhk6d1nRJZ4Pk4QkQhnqxzJRCGOcc/MiCylbO95/CJjsRIRst6uoSomTJThssNTI375VzVqhI3gTaBNijOzUmXN0uX/WVRV4igcwixoA9CLRzIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lBCAOgF3; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lBCAOgF3"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ad4d840d43so2525e87.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 20:06:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781751963; cv=none;
        d=google.com; s=arc-20260327;
        b=S2Mjwlcl1c2iLAW4hmjC52yL07cP0/vwNDLcYvIO3cWypm8tLXh9BUK8tkWjNhI5D/
         z+PlxsxxFC+erQwn5cv8xpYj6aH/13i0nQ9nPwN0MF1/QcAHqBEycxVxLQAWInCRpXut
         9IG6acRQBOqkXoOeomGnKaXflCSLSdTcf46sX+p2OmqJzf0m7l9eT16g6Ib2wRxYk3vp
         gYI5WPQ1UZBxYWRi9DpT9RGRHo/5i2JmbVrMDGyovydCA1CzOuHO5ukS4HY3ePo8RoKR
         yjHTV3sHwf4fXkbhuP6QWpCZHllK+O0B/YUgFYmD90iJDaKnyQKHb1LI/TbydU4i0PpS
         VOQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MuDhO499MU+2PPSIhfdkWixg8e0XSYoAizgkD/hJtd4=;
        fh=wHoQBhPHdcEDH0gtn2az5f4534FjALeLmW/4Jb7qbQI=;
        b=kL6O4aq3v8AV2fPK4kMUVRbrihX3vuo/vZOZz/YgXJXCPRxeoZ2nb9bp+Pim+06Ch0
         LqXArbXYC2mJqjgVYzArqAFTmO6UcUaNaCY5IMMw3IzGwFSIl0FloTxC6aUApFKKOZWx
         6twvI+g07r+rtVhz3crOGi5mO2QLK446UftGx8BWNH6mqioDKM6uZgHk2sBU+fYejOY0
         76tbK5E3P2iUafWVcjL+ZnhjeZl9smExWpdasAPX0WStD383ChXvtG/0sSC9YVUim5UX
         NDVY4n2/MHPmeyPvpc3cvymOATcbR7pzpAs3/P/8/VaCLTi1FdKSNRR7kTsAQ+yIKhj3
         22QQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781751963; x=1782356763; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MuDhO499MU+2PPSIhfdkWixg8e0XSYoAizgkD/hJtd4=;
        b=lBCAOgF3aFVwbVCKChLmuZmaIw+VlLan+mgGxjifRFlnv6/LDvk1SbMXZSk4oQu3rt
         TXXO50SKLrHHFRQDlij1hI85Ka0NUdbbnmL1zW9VSu8CthVp1ZrlLoMrmRCW7GqDc+BR
         AGifkAcA1WkyDyMcAzHdPMONuASNIuUhm2DZ40IQQyJiQIysjWIh22/VF67AnBneQhDB
         bjZMJbQJf++PPvGlK1u+svDyOzGtouBR5XNuf1i9jwmBA/OA36GVQQ6tYKEjVmi2k73I
         WXcjkfL2JgICFKrRezKtISUjEb++gqXd9xcdikh6p2IznRQudu6NP4hoeOMuF54R/vBS
         bfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781751963; x=1782356763;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MuDhO499MU+2PPSIhfdkWixg8e0XSYoAizgkD/hJtd4=;
        b=tYK83m2yS5Va2HxqC/U5L1+JNVzp/l8eqtN2RBr8E3jsZ5hos/zyhZGpwI61j6huVR
         4qL7FD9RYRV9cwt9uMWVkhonai2Y7vn0eqDo/K1oNdwuadv6xB+KwKft2Rt9WWAy1Rua
         Pn7pLxOufwZAHT3FawzwLoubNZIpaqmtnFXJ5bv5Zm9K2AkTYzwx2JH5Sr5LTI1M/wU0
         RuNHbYE6vpVzb9I2GLaUXrtSIC6YmMRSFxvytgHY+Ypci80ZEBROGoGIC8KYKFVqM79l
         chqdnAKxQbQFYRH+o3Lg3ow2fYSEGyaDyFbW36AepfQhyU8qfyBfzeR6kJJYRGs5TjNy
         cETw==
X-Forwarded-Encrypted: i=1; AFNElJ/WeUXZLZ+7kid0TibGaFg1zv/dav8ABV2b5q9IwmvcDezBb4IAtWoF1SuF0MYwVOUmFQEhbvr7Erw8@vger.kernel.org
X-Gm-Message-State: AOJu0YwvEHOoF9Ncs2kvpFXCgMS/nlmXfFMp50h0dmGiozI6Apd5S/Wj
	3sGL+BILHQThE0i/FpppOWBJ/Q1VzIQc9oYJIylQIzdFYHmeGHHJOEY5+doF6DPVGkIqFw7oN7A
	ddqcgvJTHHXme61sAhFUhg5lsDEkIo9QqHFQolZ8Q
X-Gm-Gg: AfdE7cljB6mv+TfsR7F9GTmH2hPy1wTq8TglFwdRBuPjrZj8W1+xlkAbJkqnEER1VV7
	u7KaqFvKdIIMDk4iYOGtsXStpZRLVpFoJSQGHqJOu6fn3mv2Ovhl/GB0V3JWtkGc4UpUqJh3Myo
	cluUvbp0lXOO7mVFYKfiyGcRXcOy7vzb4uttv6AqTLU7LwSLkub/MconNKAPrpm/6dOysLIc2pq
	Btgz43XksebcAdVitxltblrcHRT2jHy1w50bG6zdxFHHWIRaIP8WcQ5sXXCP7o66Y4E23LYAvle
	bp9i8RjHTtCnWPkeMg/YSjNVCpE=
X-Received: by 2002:a05:6512:acc:b0:5aa:8842:2420 with SMTP id
 2adb3069b0e04-5ad4eea1b8fmr65032e87.13.1781751962820; Wed, 17 Jun 2026
 20:06:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2026061659-enjoyer-boogeyman-25c0@gregkh> <20260616100121.548759-1-himanshubatra@google.com>
 <c040d167-8747-43f7-ac30-2f5c5bcfbc02@acm.org>
In-Reply-To: <c040d167-8747-43f7-ac30-2f5c5bcfbc02@acm.org>
From: Himanshu Batra <himanshubatra@google.com>
Date: Thu, 18 Jun 2026 08:35:51 +0530
X-Gm-Features: AVVi8CcSKL0KXs9JB7ChTXdSYXke5gD27GwHmkdssl-qtb3Vm2jqmaifmUoOFSw
Message-ID: <CAEif7DQFd4e6u0C4GWxFbrMYdFRjm-Tz0Sf0OTP3qB5aWek83w@mail.gmail.com>
Subject: Re: [PATCH v3] scsi: ufs: sysfs: Add HS_GEAR6 string in
 power_info/gear sysfs output
To: Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, 
	vamshigajjela@google.com, manugautam@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2026 at 7:07=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 6/16/26 3:01 AM, Himanshu Batra wrote:
> > In power_info/gear sysfs, currently it supports output only till gear 5=
.
> > If operating mode is gear 6, it outputs "UNKNOWN".
> > Add support for HS_GEAR6 string in sysfs output when operating mode
> > is gear 6.
>
> Some general advice:
> - New versions of a patch should be posted as a new email thread instead
>    of as a reply to an existing email conversation. Replies to an
>    existing email conversation tend to get overlooked.
> - At least 24 hours should elapse before a new version of a patch is
>    posted. Otherwise reviewers who are in another time zone don't have
>    the chance to reply. For large patch series, more time should elapse
>    between reposts (e.g. one week).
> - The "scsi:" prefix is no longer used for UFS kernel patches.

Acked, I will follow this for future contributions.

>
> Since the code changes look good to me:
>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>
