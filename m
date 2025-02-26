Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1FB1E1E1E;
	Wed, 26 Feb 2025 11:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740569316; cv=none; b=Nir649zNTbFrxa2dMcoLM6IJGLhEoxdnxIH2mHQg8Qu0EV5VA+s6auCk+sGSdROVJdujq9OtjqJfeWo/U3Cp0FMHpY9HnFZHbePqGGLSF24bq4QzVZZUWoswb7DXyZewZpRUkQuNb/oUya0Y2ijKA5lVSrJygVJn+uvgvevU4xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740569316; c=relaxed/simple;
	bh=IHVV0VEiY51JiQMba95CWP2QqrEyuH8K6cJYGrV0vxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d7e+ex6OYjRBlZiSkmRK+ejut4b1zT2MsiEf8HjurNcE19Yx5QzgqtbAKc+vr1RvadPFESHlYw/TNnfeJpLJRsQHY6DM30dKEEztkWOKS3T01mzsY0L372IYPlRITkTmtgoOkhUQd9Mh9/VMSq3cL57GRWUsu/QBPD5rWqEcXQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ae3TUF/P; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ae3TUF/P"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5461a485a72so6464439e87.0;
        Wed, 26 Feb 2025 03:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740569313; x=1741174113; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TGWA47ydXjPk/ArJwGLRdTzUR2JDCR2yxtlUSj8iJJU=;
        b=ae3TUF/PiW02DvsiQGb9jif232/VR/I7kVGPbteOEcrJ5nDMrc1gufPipy51ywYF7c
         RW8kwB7HjPts5U6rbT0IXwiE5h0shcYTNOiJHjB6MGKfBDTO2fd2iV+9ZRS+Z88gBzuK
         7yam4RPAu7/SzH5mx9KGB1qZNHskHT/e32jG2BC1m1I3gyF/eBP5VP4sfS98rJMb45JG
         9xrkLOPY19wb+a7fNvc3288frTP0goYTNDI4dDMVJ5cDdq8O6MOc5muIGAJMepLLalcD
         Mpcpy8hau6tTWq9iw7WcEILSfKphQKKjX90G2udk1lp0qKXdPxfEHY1vGcgwu1FUARnl
         YiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740569313; x=1741174113;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TGWA47ydXjPk/ArJwGLRdTzUR2JDCR2yxtlUSj8iJJU=;
        b=nWr3+Co3iyNIu24NToFnUtP+TLn5xKczkCKGOxJK8G4NEaDW6IsVkX9zfSTLglNsVb
         ubyZqVOgNfHeVBK6h1qA+F2gA167JreaHWWnbnXZWyzEYolCg1uRK2/IhyfDatCw/+1k
         GO9mR6gFaX91KP62G9VEusJ7Odw72cSYOkJub9vICUaEUl4zU+oyo7QgHZjgDHpufkWB
         IhTuJ6lHf4u4nJIGRXHVsQfEW1wFUes+FfzdTQz/3rzlav8SHRbp1D/UcVlWGKmSy7pA
         lzcPh3hUMYrxxKshaDWnsGPyqyWPcLjD2XGQVU8Tl9YJ4gq5EZhjWkvtUL5rkA6vj0Xi
         xDEg==
X-Forwarded-Encrypted: i=1; AJvYcCV2xDD+qdFrVcEFjbw4/jOxmlP9aEL5DkpsVeqUxYJa5LwEJDo675rbVcZVbAPuBR3g7tryXCtQ34LYww==@vger.kernel.org, AJvYcCXnujLpR4KoHvHhF+qTwMl03KQ1xefXD7rglzS0uzw3r/0UOdLMaHGLPpgtYWzIJh0eP5FWrITaeOny8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIeATV46jbFaqlVx9MG3YbTqzCRN2XqrNBTF6IWTXxMm91QgwE
	p2JvTL3NPgBAWJ9DthKcz9uFX38Xfwf70qoZE8kLNDN/qz1Yuj/r61SiqZxD2Z+JID1rplKttGn
	KAUPc0IkiX92TDnS8Hz7XpZ3kxGbXWE4=
X-Gm-Gg: ASbGncu4h5+QCCTRvVQXCz9J7bZzPHmLimLAAeCEaGKj6iB7qrgV6VzppHMER2/GIY2
	3n7cNDiVZ2Wj+t5FECAtkiEJ8+zaxokgPlVvTNyrKrk9W1GngiSVoTUCT0PiCi46hdROGd0WFQa
	6niv9EYbY=
X-Google-Smtp-Source: AGHT+IH+Zjc+bSh26ZsVjU3bqp76TTCLT0O7VaVEWFGY3H7jTf7GiuF0ZJl8GQK9eeazQ/KZTqZRV1mtBf3J32sedzA=
X-Received: by 2002:a05:6402:254f:b0:5e0:b542:fb32 with SMTP id
 4fb4d7f45d1cf-5e4a0d88ac4mr3401857a12.19.1740569301171; Wed, 26 Feb 2025
 03:28:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250225044653.6867-1-anuj20.g@samsung.com> <CGME20250225045514epcas5p10d06ab361a4125a94933fa8235fe3fa8@epcas5p1.samsung.com>
 <20250225044653.6867-2-anuj20.g@samsung.com> <20250225150626.GA6099@lst.de>
In-Reply-To: <20250225150626.GA6099@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 26 Feb 2025 16:57:42 +0530
X-Gm-Features: AQ5f1JrVzXdezh5PQ5o_BGjgjz3qnhupiyvcy-dL-1mUwfQLc2HYvilNGs8wJSU
Message-ID: <CACzX3AupuX0NYqBxq-7hBxU5E1v3BhHeYoeuWxYuyXqu++iMcg@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] block: Fix incorrect integrity sysfs reporting for
 DM devices
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org, 
	martin.petersen@oracle.com, nikh1092@linux.ibm.com, 
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, 
	M Nikhil <nikhilm@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index c44dadc35e1e..c32517c8bc2e 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -861,7 +861,8 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
> >
> >       if (!ti->tuple_size) {
> >               /* inherit the settings from the first underlying device */
> > -             if (!(ti->flags & BLK_INTEGRITY_STACKED)) {
> > +             if (!(ti->flags & BLK_INTEGRITY_STACKED) &&
> > +                 (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE)) {
> >                       ti->flags = BLK_INTEGRITY_DEVICE_CAPABLE |
> >                               (bi->flags & BLK_INTEGRITY_REF_TAG);
> >                       ti->csum_type = bi->csum_type;
>
> Hmm.  I wonder if this is the correct logic.  Basically we do not want to
> allow mixing integrity capable and not integrity devices, do we?

It is about a situation where a non-integrity-capable device incorrectly
reports integrity capability due to improper flag propagation. The issue
is that BLK_INTEGRITY_DEVICE_CAPABLE is set incorrectly even when the
first underlying device does not support integrity. This part of the patch
tries to fix that.
For example, when I create a dm-linear device using an integrity-incapable
device, the resulting DM device wrongly reports integrity capability [1]

Rest of the handling in this patch would not be required once we correctly
initialize in blk_validate_integrity_limits as you suggested in the other
reply [2]

[1]
# cat /sys/block/nvme0n1/integrity/device_is_integrity_capable
0
# echo 0 409600 linear /dev/nvme0n1 0 > /tmp/table
# echo 409600 409600 linear /dev/nvme0n1 0 >> /tmp/table
# dmsetup create two /tmp/table
# cat /sys/block/dm-0/integrity/device_is_integrity_capable
1

[2]
https://lore.kernel.org/linux-block/20250225150753.GB6099@lst.de/

> So maybe the logic should be more something like:
>
>         if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
>                 return true;
>
>         if (ti->flags & BLK_INTEGRITY_STACKED) {
>                 /* check blk_integrity compatibility */
>         } else {
>                 ti->flags = BLK_INTEGRITY_STACKED;
>                 /* inherit blk_integrity, including the empty one  */
>         }
>
