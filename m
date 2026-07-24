Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9413F3546FD
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784907836; cv=pass; b=kB0oRWOVW92nHEuH34CzhpQ7pwNA2ELGUoig0w28760eCP2gxL61XqY5QvP5zcc4UpW2kcUwOr7o1MTH/7hsVG++Sfy4IuHdA+rc8BfW3vBoqDP4qoh9ILdMBO4p4TfSc3XxMLLibH/nQ3e7sDAam7i9kU64vhd7P7L6Ps+uhYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784907836; c=relaxed/simple;
	bh=ILofpUWGWH9zp6AGMmvbmtrtheP7UpO/eX+BW6pBBWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rZ0rBf2m/D2lDSycqiaYAhFZSS1Lg00k2DBOWwlJfpjEcSTRMOVHq1HpGWAMz9sazlCn0bBWrksmDgqdTUEr0t0r8vbcKswdXCDrds86LgN0Aj14dhlRwuISn0vOkpSU0r644DMQuOba0aLhqa99EX0Vdvd5Fh2t3UfLu8QscUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fFeaWtiF; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fFeaWtiF"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e9f4ab2a6fso35786a34.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 08:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784907833; cv=none;
        d=google.com; s=arc-20260327;
        b=qVzgiZv0C6IC7vtfSpd5wQKQTRgZYnEGkAAqr8UF8eQPWNfyFON/+uhagMcecGJ49Y
         h9KJuFpS94+BIrIaE/lrWhePJhg2AYD0wunJl597KXELDTrB/+n4u8F2KZP3XhEeFrq7
         kFSXDLMphZadVuuAPyhM0dARgBGvbgOx0aTgebzqgdqewMBCKlRaOXREVNBUYm7Zj3Oe
         yK9otMFF/8mWzlYqZTqjPoU0fubVQdyP1JOrzLSp/Xei1iDXs6It7iDhzKkrWQEVT8jH
         qNu73FeQX57DbU1z3C+wfz0uWyByamNHqTMSuMAFgqrXgLQj/rxltTObhFYb3F9gjalx
         10hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lvfkPaw63mygCj4Ez7HrV9WaH81ot3VV5r5WvjvtNbY=;
        fh=sHa9XSqKTimznp88LlNQQ9sDJommdTyvofPkr7ytMCM=;
        b=FQ/Dtm6ntaI6yTOcqZcMBaV1t2a3BevG9NZWn3NJnGAm2/nwiP+HoeLEUq1abuXouy
         CMFb8YFpehyVfJXrFJzI3RDl/Kd+vDfEAICLer+w0vSqN+7o6EjelOFrMb0nr9RkoSUP
         azju5izkRIXmsWxCmxffL5CjUTl9E82MsIkZWaaIbl3zVkpdQ/BaQklKalvw+hU0yRfw
         c0VkU1u5GPoPihQrM/8cMXsi6sGSuKlkEh3s0pSjUKxLn5TjVtO5DaUWdhnhxmNYWjkt
         zxtOc+kGGLTOqg/Pnt7HcCA3O0Y1JMngGTz/QyE2EdAH0tVNyGEsBqwHBkSZdbc6ZUi5
         cwvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1784907833; x=1785512633; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lvfkPaw63mygCj4Ez7HrV9WaH81ot3VV5r5WvjvtNbY=;
        b=fFeaWtiFUf+jNiky+HPe+Nc19K4llYdf9nya5WHaGrigiwx8Rkc/9r1vkuxGSNIkeE
         MLMIvwOhMYf7R8hoGifZdoGfnKgnw4Me0GdwxO9/PfeBwSrfYy4mJg4lVsQ9MNaqpIjM
         7o8AJrBIDiGzxyC8xaWxLsbCfwoP67TN1Vo+Twv0HIKGEThqPcy1ZcJXzF7LuUJb+WBA
         BnuJQboKRbiEAirOm/C9LKohX4Fca+9zwl/xUGcl0Z1T39IFNRbH3hGedCnmM9LrILnr
         zHgM94B/DbhEw+cVmgbpOCVN1+A+bQvy9Pi+8PPuCH8f7w/a6EBdtWog/7ZE/pGZi3Hm
         iDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784907833; x=1785512633;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lvfkPaw63mygCj4Ez7HrV9WaH81ot3VV5r5WvjvtNbY=;
        b=WmunoeK4Ht+gBRGo2EekLDP0aq+xyUbOaZW294uh5Ms579r2GkvCGfnintn9B0ebXo
         dgSNEB/v90FWyBtWgWy2mR37Qk5SFHMCr0WNL12BE0tWShVd/NSk8oqqluQdlynsy3zT
         jjVFTayCm+IefMhSK17Fat05bUQ5qwmNMgy9igQ2HLukaHHZBY8ztTOnpyBEvXpHRCj7
         TCAmkEvOS00+ebPuDRm3lAfTwWZ6SE1BIp/LVr45dg5yOhX2/Uq2agmExZA+IjsVUQ23
         LWyqNjFr5wv222s0k6LyQoM3+m50xvKQFBvtBVWJtwPY9YoDrUn/hD+8WXRM6Lrf4/fF
         OTTg==
X-Forwarded-Encrypted: i=1; AHgh+RqxCGDvlkWbsLkott1mKXhj4O5WVbaLoPjnqeaiicAh1AVQ84L9q52BhhVu7cqNVpkSX7/TON5sohvh@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl6Vrm+Na+5IdQ6oXdUMtpWXai7WEvimDObctYlw3MB3Nin1NW
	bOvlUPTsgkhrMH12kodiW6vRzrfGmlWv2+UgEPsa0HvYiDy4xjTciME+mrUi2V48QACc1xbQSqY
	MKiMaXlow5/If7As+Sj/o2SzxlfEqeAK5yCcrZ2DI9g==
X-Gm-Gg: AR+sD136cK56LkB3Ynfly/ewQDZxYC+JhgftQdDU2xqmZuiCRns8JcEAq7PCWDnnXtG
	PxJpyErX342ayZVVrnnM+zR+THRNoznPdvIGOtG8HDBWix55oCesKtbl14G0CtKHsitv4Teo50F
	DZTHOLtqQk4ZMLhAcnTEkHqm/kv++50sIVvXfw4m5BPy6nmtixMzQTWUlyHyec+/QdS5PKMXpBa
	si+4fOk/NOi1ShERr9C0UjH5Pp7T5oLnhnhZO41nT2W/9ro81i48yr2RZXNKoE=
X-Received: by 2002:a05:6830:61c9:b0:7e9:cdc6:b930 with SMTP id
 46e09a7af769-7ee57ae92afmr2130467a34.6.1784907833352; Fri, 24 Jul 2026
 08:43:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720032338.461681-1-yangxiuwei@kylinos.cn>
 <20260720032338.461681-2-yangxiuwei@kylinos.cn> <CADUfDZpAW261MhFJg434=4nZFMD7mV=LL7F-ZiAWPa7dYvGpcQ@mail.gmail.com>
 <20260724004907.2742329-1-yangxiuwei@kylinos.cn> <CADUfDZpsTH7zU4gyVE11R9GxdadjbcrcGVX+btoEjRYS-tBiGQ@mail.gmail.com>
 <20260724020240.2938587-1-yangxiuwei@kylinos.cn>
In-Reply-To: <20260724020240.2938587-1-yangxiuwei@kylinos.cn>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 24 Jul 2026 08:43:42 -0700
X-Gm-Features: AUfX_mxV-8Cou1n7v3Ks8R-DjIB_eyYje8GjN7815YyL2Gqfxab6vzNDmm4_9HM
Message-ID: <CADUfDZp=pCYGY0TCnMxXPG3LR3Kwk3DB-Hq+EvHZshruX3pv5Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough command setup
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	rc@rexion.ai, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, 
	bvanassche@acm.org, linux-scsi@vger.kernel.org, io-uring@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 7:03=E2=80=AFPM Yang Xiuwei <yangxiuwei@kylinos.cn>=
 wrote:
>
> Hi Caleb,
>
> On Thu, Jul 23, 2026 at 06:10:27PM -0700, Caleb Sander Mateos wrote:
> > On Thu, Jul 23, 2026 at 5:50=E2=80=AFPM Yang Xiuwei <yangxiuwei@kylinos=
.cn> wrote:
> > >
> > > max_response_len is similar here: we clamp with
> > > min(..., SCSI_SENSE_BUFFERSIZE), so it cannot overflow the sense
> > > buffer. Same idea for response.
> >
> > I don't think that's true. Without READ_ONCE(), the compiler can
> > assume no other thread will concurrently write cmd->max_response_len
> > (else it would be UB). So it's allowed to load it multiple times:
> > cmd->max_response_len ? min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZ=
E)
> >                       : SCSI_SENSE_BUFFERSIZE
> > becomes
> > cmd->max_response_len ? (cmd->max_response_len < SCSI_SENSE_BUFFERSIZE =
?
> >                          cmd->max_response_len : SCSI_SENSE_BUFFERSIZE)
> >                       : SCSI_SENSE_BUFFERSIZE
> > And if cmd->max_response_len changes between the second and third
> > loads, this could definitely evaluate to a value greater than
> > SCSI_SENSE_BUFFERSIZE.
>
> IIUC Kernel min() is __careful_cmp() -> __careful_cmp_once(), which does:
>
>   auto ux =3D (x); auto uy =3D (y);
>   (ux < uy) ? ux : uy;
>
> so cmd->max_response_len is only loaded once inside min(). The outer
> ?: may load it again for the condition, but the value coming out of
> min() should still be <=3D SCSI_SENSE_BUFFERSIZE. Did I get that right?

Without READ_ONCE(), there is no requirement that
cmd->max_response_len only be loaded once. The compiler is allowed to
assume the value won't be modified concurrently by another thread
(that would be a data race, undefined behavior). So it's free to
combine or separate the loads. If you want to ensure that the value
read from cmd->max_response_len is consistent, READ_ONCE() is
required.

Best,
Caleb
