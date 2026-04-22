Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EF33CF047
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776858296; cv=pass; b=ZySO0bxhStjV9h06fZSXVOaieNLcNPHAiQzVWdmjZAdIfaBNbBD2zG5UW+64QSis4V43slzYEEH7mcdAgrE8atUpoc0n8B0sLP4ymmc0lRq05toCtb21D5Sdkli9alLN8j6M5jSArg4PCxcrx/kbiFoEXrWmtf426h4t8GG47tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776858296; c=relaxed/simple;
	bh=qFil1a71cRmcPqBTgFbC/PBLK3Bx7xQMbbPa9YfzOg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JloUTV9V8aWgey/QxdA49puASDWdHCHvCVIp7Emf5Shp5mtw5Da83mOj9/3YDmmnLeXjf1yhPeca0qXRBrAwmcGxiuB/x78X7WvcdE7GOpLDoCty7XgXl5IvHiBK/41Hfu+s3SRbmMBKgh6+KVtLPnkxeJoI59oaZD3Mov9B0ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oNSrdPF2; arc=pass smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oNSrdPF2"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-41c4d660b19so1425104fac.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 04:44:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776858294; cv=none;
        d=google.com; s=arc-20240605;
        b=TIvTPnjSXgZ/iC0VZToV3ZH35ZyUvwI+52r3S2oouYKIOpll6iaIuRQRvu8cDzoEVs
         SwJSgLz2z9qdfmy8Xb8eTgIiSDCkW3ka+ajIfaxbjh8/8k9gDMt48u8jpDStc0G/7Gxh
         F6BP/IplOV4i3jOEkylG5R6gBcTQicTDFNPs4Uo1u58UNoByjQ0m3fWjDScMcMLtnvRC
         WnkiBF4Kn3CA8YGCLOiXD6RdJfD3Rhds2wmX7LUbx4f7eCSLVY47wirK7rCdXezKHvVg
         t+zSBci4eg0WYTh/ADV15kyzPe8OIeePe1RztWYHltBg+zZLBPNemep7SseDsadgS6x1
         au/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qFil1a71cRmcPqBTgFbC/PBLK3Bx7xQMbbPa9YfzOg4=;
        fh=rzLiX0iFRlHgw10BSVM8PvEDWa3UoZ3gMhTs2PG+oJg=;
        b=g0ff2Szy2R5Bl5xWYEdbQQ+9PnKNOai9bXWPa+pFesHt1iwQDAAWnjp1dNj+Inu+Yc
         TmYuFY6fH7f/TRQhOVHhQUxd0dwRYJqupVPGQtfR4ohdsLJWcaHDKDaQzJOvbjtqtK29
         D2lp4ukFPXyw8fA/5DWVZV48sAMfiuljtguHPFKuQmqZ2MEuOyLCQEPA7pCD8YDndjzx
         iU8oFLH13tbW5mh7PM7yipX0t2dyVCjTgL8oFkpMSnW32sZBQw2enRDifMBSmewgQmEh
         oX/n2Ug4dAgu9qx4AhHjI4LnF20t5QEjmLUPBfKG3iqi6u08GidLBy+eJ1ZFxbuuK/me
         Cmww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776858294; x=1777463094; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qFil1a71cRmcPqBTgFbC/PBLK3Bx7xQMbbPa9YfzOg4=;
        b=oNSrdPF20EEJC1EGPnJeR0uJUQ21yOeJP2cQV6oN+rMnmzSu7DH/z8dNA4zI+sAX/G
         GSF/IV4S/vAMCEPKXLKsmt9tlzhQLBxLu05WV18GVeSSuaw3DRWQrwGu0bR8X6KhyXge
         FqhREIwlrh+pq1N34/f+43hMLlrHF95NMOr1dQ/TKiWGxTVdVTJKWeuNUuiJeeGJuWbX
         gzZiL1asqUdBJjp25A39zNTrhlyCT6wF6wIXjybG2yTE1O6zSJQ0QKxoxRlBI/KlszLV
         EiL4/dpD7NPbLUcYSjJyIX0blwEK9d2C8AeLT+SruT0vUJSXs4uXBlPb/Z0ju4K41iyY
         xqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776858294; x=1777463094;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qFil1a71cRmcPqBTgFbC/PBLK3Bx7xQMbbPa9YfzOg4=;
        b=UqMTwCFHctH9Nq+oXUobeEP8OtpcRGzXnzviDeIBAhj2zgyuKImXm3NcH0qBSj8LLQ
         thpt1RwvYeBtxJVxi5eckRaJKPGnTddd0PRV97jmfeFLfv6Pw6qxpyszeCjkZCFGkDU2
         xPC6qf4w0LzLcQDIxdmfmd6S2qI3lFC9getLyATVGxrwP/57dXhMs/aEOAi7rM9dRqNE
         gupTn2X7qHx+pGaOcq+EFhfvgqpU9hW44wT6FQ3FKKl6X9vq86UcZXbhs6Gm7/GTji7S
         2K8R8DvRCvOPSM+6cAfAd8YuBGJ6deUZROPmzfVr/JCLXJAu9pC+hz7lQ7Pvehn5N28h
         Iypg==
X-Gm-Message-State: AOJu0YxZcBLhveALmz5rPR1l2fcVqVjZpKx7fhmbHNmP0ZGoTk5iD/kZ
	9XCreosiGpj+QZWwPYjXbjKb9oMZo/Z6M+dXohyLh7L8SbdVE2T1molyIVBIG6Rntha76queYI4
	vPRYZhRZEiXFUEkrh+C7Rot9+RmmWQPjQ1qUB
X-Gm-Gg: AeBDiesAgeyB/igYCw4BYsDuiofPEK0rbwqPYTdAC/Srdmc2hZ6roux2VLkm3V5oSWb
	Zl/6LC2MGSgg8AQ7ZbEsWKj6novGVZa6t7uhWNZztYiLML5zmkjncpo5tHBB2b3yyIEAATDpwCL
	IefgwFEuEk0yxRoG6Hp0OamzhrXwX1PFv3uD0j0oInUQNt0Fhzu5fGF1oMLSfdOF7t1FcYV0mUJ
	aMPID2OwuG3negXrxmyLZcI14gVDBgNjnWZDJBKWy7vRu4MJ8joojM1iwpNue0n5IouW/XSVu8w
	bqYbJpvL/nqIQtSEOUqASllmVITyq7z7OZZmlR65RRrQMCuvNi9th8m7dRxO+n9YeQMA/fXnkgZ
	TJkeuJLMudoM1eq0X8Tt5y/uMFTvdFIsQuTg=
X-Received: by 2002:a05:6870:788d:b0:417:3cc0:8dc9 with SMTP id
 586e51a60fabf-42aded1cc8cmr12369248fac.24.1776858293887; Wed, 22 Apr 2026
 04:44:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260415065110.3496246-2-daan@amutable.com> <yq1eck7lq27.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1eck7lq27.fsf@ca-mkp.ca.oracle.com>
From: Daan De Meyer <daan.j.demeyer@gmail.com>
Date: Wed, 22 Apr 2026 13:44:42 +0200
X-Gm-Features: AQROBzC0EuJbwXzs_LYysCCRdzN7gefBYAZhr1DCZh71rUfjTaZXHOUUg3i38tg
Message-ID: <CAO8sHckA37kkL6YSF3GZ4nVxCE0cp_G4=PT-QxFhenPxnZ9Qzg@mail.gmail.com>
Subject: Re: [PATCH RESEND] scsi: sr: exclude CDC_MRW_W and CDC_RAM from
 writeable check
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, 
	Daan De Meyer <daan@amutable.com>
Content-Type: text/plain; charset="UTF-8"

Martin,

> My preference would be to defer setting the device writable state until
> after GET CONFIGURATION has been called in cdrom.c.

This doesn't quite work because that means BLKROGET would return
read-only for writable cd-rom devices until someone tried to open them
RDWR which seems unintuitive. I've sent a v2
(https://lore.kernel.org/linux-scsi/20260422113206.246267-1-daan@amutable.com/T/#u)
that instead moves the GET CONFIGURATION probe earlier before we call
register_cdrom() so that set_disk_ro() can be called inside
register_cdrom() based on the mask.

Daan

On Wed, 22 Apr 2026 at 04:01, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Daan,
>
> > The writeable check in get_capabilities() includes CDC_MRW_W and
> > CDC_RAM in its bitmask, but these capabilities are not determined from
> > the MODE SENSE capabilities page. They require the SCSI GET
> > CONFIGURATION command, which is only issued later by
> > cdrom_open_write() at device open time.
>
> Reviewing this involved quite a bit of digging through ancient specs...
>
> I don't particularly like how that decision process is split between
> sr.c and cdrom.c.
>
> My preference would be to defer setting the device writable state until
> after GET CONFIGURATION has been called in cdrom.c.
>
> --
> Martin K. Petersen
