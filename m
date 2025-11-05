Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BCB21D3DC
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 14:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762353997; cv=none; b=F3WBwEhOFqkeVEVP2oC5AbteXXfjRnfiHyx2ZB+eS4PkK28o58vq2wIcWzGKsiMvlf3saqou1eVgLmnI2j7m0ISS66z+gXnXW2++nwTdm3pp8l9Bj1qxl4gB/9NZnRSnx6s4Ikb9ClIFE5nUxNI9plFIFzqT7buP95j5mh7sVLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762353997; c=relaxed/simple;
	bh=7GHF9drscydM8VlSDyNkUaIR6HtQ621NPbVjDAEzaSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GU3vCzE6Kplz7cLrR3rqEMiD7WcorTI3tP+NgH+ZEzhg16fmz8TDZM6BKYbjFN3R4+pahj3AAdSo6pDEuyxQF9TOsmpdHAiHkegbfxBoZbc/ADXcYj+mucdcQNZSM0zvqTNbgpKyGXpxopA/hCP9amPJCxQt0xpt31oKaihXwHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pZbuh3Ex; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pZbuh3Ex"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b4f323cf89bso468092866b.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Nov 2025 06:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762353993; x=1762958793; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=85Bq0egfrxZA4M7BAnfcstD/897TxaHcMzubb+eabQs=;
        b=pZbuh3ExC8u9Jl0lPGk2PRkA00uwak+9effgeATqsXYZvSUT5DV32vkC2bAAeeFxnv
         PqSIk1nxZatKONSaQnG44xo2RvTcQgYMewqWbHIGjqqk0xiKWy7XDhK5qFRq1R+SpGaa
         56pYuoXtwjWjiEWtYjH27LPIH8ghTQpKRYb/rk3qpQxEqSjj0/mj1hdLvICmmtGIX365
         PKw+0Vp6hhjrChHdpDMTlYnT8k9U0ugMZNo/YQAdMUG7IlFjl6h6rwyTEJwb+Lsx4ocZ
         NGX+pYUL/HPVKLfB/SUdSWtIrUymcwGsrjAkLfiacPKzbHmyqXaX++qZ9ZImHdQGc4cu
         Mr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762353993; x=1762958793;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=85Bq0egfrxZA4M7BAnfcstD/897TxaHcMzubb+eabQs=;
        b=L5MFv8pbqfkDDC+IdnWI0ofd/vTfd+4Y+6sxGv/QOStCarkJT40CWOeXVIBnhRjymi
         wLSiwr8iLx2ONeJiVzTJR2dC0Sp/QzJD/4NbVhE8Hd2LMuO4S0sHtxAPiujbaqvmKpCj
         NLuc6oITYqMItI9Aid0rHjZ4Gm5HDRgGMgnlZvYK5Cz+x1TfvgQc3Z6wDA6zPumK4Iqz
         ERve/B2kKO8iNsaQ4vriwQuATWHFILvJ3xmGnFILuRFUNjjGuLxsj4jyZOZWKGC+iN+0
         w8o4az77v2kUuh/sXn771ACeRCWez/OHsCv63H+zpmR2IVqG5vmEgb6xsUrslPSpGCZO
         pwuQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4JNJ+ttJ1lYGIyIzvwi9Yg+YeoTiMFvzEH6qNgf9fHE+HwmveLKTtlzqMOAu1npyj9BLYzQXEaSOa@vger.kernel.org
X-Gm-Message-State: AOJu0YxC5Q+iaXN+7kn24BBVh6t6euTk+DUX8KUqnleLFwj6IDCk88xl
	/r9DaMoWa6m6j+FttyLhxtqCgKNmwwDJIiPsp1MIjE62LalPZ1R6f9je4VvcwjEFtsw=
X-Gm-Gg: ASbGncsk7LeT38lJkr0Z1ydmflEUWR4Ha2BgTOdvkDk8tnSeEUnwPblPmsEjEMOQFqm
	qzIXBvfP0MANtzcnNC+UIdfbt061pXMm/Pvm0Hkvw5oq5QSEvlfq0Yno45EroGurGnbliYj2tMS
	SNh1m6K2ryIRofBNcb45cfglQn3cOjVPBGU3jbFyx6Hr9AZMotCukSi0Zm/f3nQ8ONWVEJGmg2C
	IeE2IJQv0okeB8K+0RuS3OC5ue7fx0/NT9YTGk7usmxwczBDXPCszJpIE2WTiTudjDo00gUQgxe
	OcMXDmPMs2wz26+9dy+sTezuJZg3Jyv16OxWX1rBdBDukHmZhsAVvXrImZlikMeiedgSODecOZy
	BhMTexqYxm6Au4atAULTOpffkYjbQj/eNEL/HH+x3ZvsEhoHjrB9eSWlbZZU34YXEAEIzhBAeot
	MNLJZveVEoY6FS
X-Google-Smtp-Source: AGHT+IGXiYMjE4MZ4KaJmY+QgVHdNn4HEJ2OJAx5eUeCXhhwUT8sSEarGObVX+Ze2HK1oicnld1HEw==
X-Received: by 2002:a17:907:3f9a:b0:b54:8670:7c2d with SMTP id a640c23a62f3a-b7265682a9bmr338995866b.55.1762353992648;
        Wed, 05 Nov 2025 06:46:32 -0800 (PST)
Received: from localhost ([87.213.113.147])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723f6e06e2sm539356766b.40.2025.11.05.06.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:46:32 -0800 (PST)
Date: Wed, 5 Nov 2025 17:46:31 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ally Heev <allyheev@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix uninitialized pointers with free attr
Message-ID: <f6592ccc-155d-48ba-bac6-6e2b719a5c3e@suswa.mountain>
References: <20251105-aheev-uninitialized-free-attr-scsi-v1-1-d28435a0a7ea@gmail.com>
 <6d199d062b16abfbf083750820d7a39cb2ebf144.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d199d062b16abfbf083750820d7a39cb2ebf144.camel@HansenPartnership.com>

On Wed, Nov 05, 2025 at 09:21:45AM -0500, James Bottomley wrote:
> On Wed, 2025-11-05 at 19:44 +0530, Ally Heev wrote:
> > Uninitialized pointers with `__free` attribute can cause undefined
> > behaviour as the memory assigned(randomly) to the pointer is freed
> > automatically when the pointer goes out of scope
> > 
> > scsi doesn't have any bugs related to this as of now, but
> > it is better to initialize and assign pointers with `__free` attr
> > in one statement to ensure proper scope-based cleanup
> > 
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Closes:
> > https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
> > Signed-off-by: Ally Heev <allyheev@gmail.com>
> > ---
> >  drivers/scsi/scsi_debug.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index
> > b2ab97be5db3d43d5a5647968623b8db72448379..89b36d65926bdd15c0ae93a6bd2
> > ea968e25c0e74 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -2961,11 +2961,11 @@ static int resp_mode_sense(struct scsi_cmnd
> > *scp,
> >  	int target_dev_id;
> >  	int target = scp->device->id;
> >  	unsigned char *ap;
> > -	unsigned char *arr __free(kfree);
> >  	unsigned char *cmd = scp->cmnd;
> >  	bool dbd, llbaa, msense_6, is_disk, is_zbc, is_tape;
> >  
> > -	arr = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
> > +	unsigned char *arr __free(kfree) =
> > kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
> > +
> 
> Moving variable assignments inside code makes it way harder to read. 
> Given that compilers will eventually detect if we do a return before
> initialization, can't you have smatch do the same rather than trying to
> force something like this?

This isn't a Smatch thing, it's a change to checkpatch.

(Smatch does work as you describe).

regards,
dan carpenter

