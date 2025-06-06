Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDC41B4F09
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749221226; cv=none; b=HcsVI0JiFMYoaaZKC+VnZGCXAjPiHoaXf+sdsX2/GZBKacVn5+MVl+ZHeWXoDALRwJ7JruObqLa7m8T94eEXgUAEyP/YGc1sbFSz4OT8BxgaDfIxsG8gMrWZzhrALG9YpidFqxNA29Kh7rdLVSuslQSikfspEloDTIbnPx2K9IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749221226; c=relaxed/simple;
	bh=WRlLELstaNpW7yEx1JeER9RD1FzlSogCAowXKNoqzUs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rl2bXSymHqlmWtUIbWOvzu1XXQF7U6t5q+i9XE5vdR86UC1vj5I/2aSFAv8vwS/uuYbsTvlMtnr3JTOMGqHOeur8awu99jqGnB7oogtPOwv5Z0p3+c5D2OXuCZgv/hB/0KVnyeB8FcIEyPMbNgIumwtdhyh4OZ3LI71VvoQS6eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eBNZ+Trv; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eBNZ+Trv"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55342bca34eso2240511e87.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2025 07:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1749221223; x=1749826023; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJ8SD8Nt1oQltLkUYIecVVOB5LiS2FtNSos97bg2CI0=;
        b=eBNZ+Trvvx99IVUTKbfilzjy+FHGuLuBWBqABmKyT8NDY5dntjuzj7DLEaBFL8/jf5
         +1EvN1Q4iywAay20qEDX9KLUtnTymJSga8QofgwyOTWO7McU6yqT0gyty9xPL4NWP5UA
         cygNet51muORKPaTwsTYsF3DMaEqQggF9NWVpk2bzlreWb30vo2Me1ADjvLXO5WPCq11
         QWMW8t2E36IvQsXVFSOFiAkjrOICpGm3SglXrBznDxbXa4WtFaS6gQx6wyl8qS8GSQbQ
         h2obSdVqVjJqy4ToRrdLStLri98D+Id97mBSTfZph5mz8BfDCTccKZQmOxtK+cjmE63a
         q22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749221223; x=1749826023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJ8SD8Nt1oQltLkUYIecVVOB5LiS2FtNSos97bg2CI0=;
        b=PFeGifip9+gvlNKpF65lOogxFXTFJyLfuCyVszBcwSlSf00y3NipbCVVsFBAedmIoS
         guVNJfXlPUfkyHs5WsXdcbnUnqNDXRGyt6WYxvSKZPIGT1t2QFv1imBAehsn8svHRnrr
         /lBiPEh0kO7GyVwBZoUWO/+ikkUE0oIVNris97NCrNEpfNFpiZxVe0TzXGIsGxj9VsMM
         mfUOPXuyYH5A1mDnY47UQwVIdRMhcGMvxtp/izDykOeRqjJgwgWsMHrXQx6uij2fdfyb
         UbDe0WmaBkQRpnOXxQRieI/TyFOrwOct1Ezwvl9+PrX7YF6MwNIG7rVlPkvHwkEA/TZR
         dymQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpRiPEjyqH6EWzTUuQKdYfaIeixjT8r6zcp0HmRXwB/LclnnX6oHVCukkJis4RPJdiNvsPSR0zE6wA@vger.kernel.org
X-Gm-Message-State: AOJu0YxzHgiWKvJmE9xYXYP3mCELK5IUv/N7crUovb7MmeexCakFRKPj
	FScT1i9zCUyN5Fvmq8Hc0fOBdbwPpkhOZ3OTDwRlGvJ3R9zAXqBJBYxqCR2P3fpzIhC/YH480Dq
	7dUN2jAj7yWS3LKSCY1YrbNWeGJXwBttUk3zOmWvf3A==
X-Gm-Gg: ASbGncsvlR9PdWPO/I1ZV99GCZ3CnkBXBlGTKxORrD/1L1+lIOwSkfvQ0sjm5Vf4Rta
	0WvWtrl7q6P/lQ70okdFFkmq0HtFOM4l+TLWOvypgpJ0Mn4YTEx4fQi2CKV2tzkakPzRpUcytDj
	oMsQpelaOd4DyxgAoTFRefAj/EmyoG+znWSZw4doUgIzI3
X-Google-Smtp-Source: AGHT+IFe3OpcPnZlD8lOzt3MFcIqPO5oyX/9F+jryTxNhc6JYjYSJSjUyYlFKMFuQNL9+UZzr5xwvYhfQEGpZEX5CHk=
X-Received: by 2002:a05:6512:1306:b0:553:2e99:c18 with SMTP id
 2adb3069b0e04-55366c0af51mr999336e87.38.1749221222680; Fri, 06 Jun 2025
 07:47:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606135924.27397-1-hare@kernel.org>
In-Reply-To: <20250606135924.27397-1-hare@kernel.org>
From: Lee Duncan <lduncan@suse.com>
Date: Fri, 6 Jun 2025 07:46:51 -0700
X-Gm-Features: AX0GCFuj0UIpzD4WYkgmBhw539ks8JbaoRo-t8g8JnQIcLG82tSGHq2KGsfxOs8
Message-ID: <CAPj3X_XHv6pthzouVKxoTcZqQ4bT1rJxFbFwDQ_5VYp=kPpQZg@mail.gmail.com>
Subject: Re: [PATCH] I/O errors for ALUA state transitions
To: Hannes Reinecke <hare@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, 
	Rajashekhar M A <rajs@netapp.com>, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 7:01=E2=80=AFAM Hannes Reinecke <hare@kernel.org> wr=
ote:
>
> From: Rajashekhar M A <rajs@netapp.com>
>
> When a host is configured with a few LUNs and IO is running,
> injecting FC faults repeatedly leads to path recovery problems.
> The LUNs have 4 paths each and 3 of them come back active after
> say an FC fault which makes two of the paths go down, instead of
> all 4. This happens after several iterations of continuous FC faults.
>
> Reason here is that we're returning an I/O error whenever we're
> encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
> ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 376b8897ab90..746ff6a1f309 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -665,7 +665,8 @@ enum scsi_disposition scsi_check_sense(struct scsi_cm=
nd *scmd)
>                  * if the device is in the process of becoming ready, we
>                  * should retry.
>                  */
> -               if ((sshdr.asc =3D=3D 0x04) && (sshdr.ascq =3D=3D 0x01))
> +               if ((sshdr.asc =3D=3D 0x04) &&
> +                   (sshdr.ascq =3D=3D 0x01 || sshdr.ascq =3D=3D 0x0a))
>                         return NEEDS_RETRY;
>                 /*
>                  * if the device is not started, we need to wake
> --
> 2.35.3
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
