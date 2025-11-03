Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2CD153BED
	for <linux-scsi@vger.kernel.org>; Mon,  3 Nov 2025 07:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762154297; cv=none; b=Shi9RTW0LPaIOyQln3sjwVamfg2lRbOoF7KI5Heo8ctqSzjrG5c63l4Cbwdb6WNxKRT/dnHNQuWBI/ACFYmTyJDqMTquVNOAn/XRKQuTjz8FWVVasHvPpxizUxDu01Zyeu77Lra/vrJZnHEpVd3dOnSaRS4Vp15Gwf49u4RbDJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762154297; c=relaxed/simple;
	bh=mNiBHRHLdMqnvaJIEavpx7C7tTm8CYCoyLazYi6SDLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HFwg7hX6mo+PFEgGVy6aQhxbSc7wF/ixnOGRQCHmzhB+oQ72pUg1AzaLixrkr78UEEFnoTAXPosgSURUEuMEZCy4bhD+znS/kvNhJqqFvUN3712mhB5HaJKqX7aRiz+rbGweVwy3VobhKN+0le5Zsgr06am9yB0YsSt17C49/W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NBvkeDKl; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NBvkeDKl"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47109187c32so19995075e9.2
        for <linux-scsi@vger.kernel.org>; Sun, 02 Nov 2025 23:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762154293; x=1762759093; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fyxHa9/8/Ar3cmThFu6k2oVGwIVFxlREAcZe35Eyfc8=;
        b=NBvkeDKlfAkIDsV3UME85lnO9awL8QzNTwhFYaIiXF9Af/y9CYyrD70ovpNljZmod3
         rFP7K3fGfVVqsaBHO6UKTsL+kif5I7mVOUCMLTCcb5wcGyYI1jGpsZKnXqYcNavXmv19
         Yr1fgqjxa6wHgu9aIKZ+qOY7FxuDKLNXa3XqLlBfAxvq5wnFec/HEXubeEttJlb6fFu3
         1/DXeHl2ZQ//HVGCciwqXamvP0mSsXWGOONj6Dxx560+qhaFySNYYjtMztf1MS0mjZll
         WHJdl+kqkVsyORk2/8wZZ8tt8O8rYf+W52e6SHEsgAvy4Z6D1ZssqXRP9yzOrjST19yM
         vmGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762154293; x=1762759093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fyxHa9/8/Ar3cmThFu6k2oVGwIVFxlREAcZe35Eyfc8=;
        b=SpSkG38CDi4XHAnzrZQeRotedln5gfCD2TwnoeJRcRjYTfpO8BfLi/YiDh+xcGN7xd
         WMNGq0pKN1FLHDOTgaOnEgAYSnJ3S2uDlRLIDHGyFMPIMTnF01reeoyFSvfMETJMa54z
         sYCNLDqd8VbpfqR8a6DPC0PwPhUOseZxAOgkvPeXHykSrBV76X88Hll0WHY69BNRDgwU
         3CC51S5mE4TsDiVDNRv+AutjMgAUhwFA31i4zwZgD10ekxBoScTtsvzO3WY17uXFKVWo
         z+ACnXZquhLW/VL7vSYhqJi2PdkSFJ3k5jRjz7ACa+acrD2epyZFuDuPurL56KGWHe8G
         lqMA==
X-Forwarded-Encrypted: i=1; AJvYcCXGz5mQXLwKL8INMT0IJQONT3O6LiEwyWUCRNteewjiGlhiHPIVVTtu7/mSW+8wQJ8WntGTTp3d/qdL@vger.kernel.org
X-Gm-Message-State: AOJu0Yxsots1O0ZF+Id3cfkcJfaGti9zg/enjld3M5DaCTYdJZ7vdrr6
	RMEtp+SD5yQQEA8NfWTHXxmwdCpd3K6v1Pu5Nrw5CjapF6GJ7YvDIXrXoa/Ww5tW/cbivTyVQiw
	gRCskoSR78Wl4jqcayEkTh6idVqXJ03IlgF1nCshavA==
X-Gm-Gg: ASbGncuCWW5+HWcmK/uXbyky3QAsrk4Ark1qwAhCdPr1lZBkVDAtXeEcUuluVw8pWi8
	Q06CSQ4mbX5o41n7zG86fq/s9QLSzFkYy9eRTTLJ+OvRZgncjXQyp+7ovzURbIscEupx//9v5c4
	kuTiHhmHCE71l3SCNCUtglDc4c0Yp5PuoIpwyjuO/C4LTC5sD52Z0TTNxmlMLyEs4ejzw7alDIy
	h79PIAgM81BFj8OMXILfH70j9TPpEtQtvbunyE1DRN+uFW3NlbJhTBUoui2tGmY1Db03QpVNTcB
	JJTAydD6AMxeJvcDymKvG+WK1Pot1TEMmyO/TsJvD/mRCnfB4i0PJa4IIWEn+7qvVvAn
X-Google-Smtp-Source: AGHT+IHqUQu8mdmKFV60YUxpDIMFoEiDUTPxoVdwOa3d9A2KABNI1QO1FJGgMlmc/MHoUnrp0Cz2XrvfjpDIzK4Hz9g=
X-Received: by 2002:a05:600c:620a:b0:471:7a:791a with SMTP id
 5b1f17b1804b1-4773bf42644mr79682075e9.7.1762154292857; Sun, 02 Nov 2025
 23:18:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031061307.185513-1-dlemoal@kernel.org> <20251031061307.185513-2-dlemoal@kernel.org>
 <55887a39-21ee-4e6c-a6f3-19d75af6395a@acm.org> <bd71691f-e230-42ca-8920-d93bf1ea6371@kernel.org>
In-Reply-To: <bd71691f-e230-42ca-8920-d93bf1ea6371@kernel.org>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 3 Nov 2025 08:18:00 +0100
X-Gm-Features: AWmQ_bmxLu0zc6F1WlZXfm4Psv5Sxs14UirqMZbxcqRpQmruSk8F7QkSWlVIM64
Message-ID: <CAPjX3FebPLu_P=-BuP63VuaiAnC62rthcQ0vb+J8b-w0OckyqA@mail.gmail.com>
Subject: Re: [PATCH 01/13] block: freeze queue when updating zone resources
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Keith Busch <keith.busch@wdc.com>, 
	Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org, 
	David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 3 Nov 2025 at 06:55, Damien Le Moal <dlemoal@kernel.org> wrote:
>
> On 11/1/25 02:48, Bart Van Assche wrote:
> > Hi Damien,
> >
> > disk_update_zone_resources() only has a single caller and just below the
> > only call of this function the following code is present:
> >
> >       if (ret) {
> >               unsigned int memflags = blk_mq_freeze_queue(q);
> >
> >               disk_free_zone_resources(disk);
> >               blk_mq_unfreeze_queue(q, memflags);
> >       }
> >
> > Shouldn't this code be moved into disk_update_zone_resources() such that
> > error handling happens without unfreezing and refreezing the request
> > queue?
>
> Check the code again. disk_free_zone_resources() if the report zones callbacks
> return an error, and in that case disk_update_zone_resources() is not called.
> So having this call as it is cover all cases.

I understand Bart's idea was more like below:

> @@ -1568,7 +1572,12 @@ static int disk_update_zone_resources(str
uct gendisk *disk,
>       }
>
>   commit:
> -     return queue_limits_commit_update_frozen(q, &lim);
> +     ret = queue_limits_commit_update(q, &lim);
> +
> +unfreeze:

+       if (ret)
+               disk_free_zone_resources(disk);

> +     blk_mq_unfreeze_queue(q, memflags);
> +
> +     return ret;
>   }
>
>   static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,

And then in blk_revalidate_disk_zones() do this:

        if (ret > 0) {
                ret = disk_update_zone_resources(disk, &args);
        } else if (ret) {
                unsigned int memflags;

                pr_warn("%s: failed to revalidate zones\n", disk->disk_name);

               memflags = blk_mq_freeze_queue(q);
               disk_free_zone_resources(disk);
                blk_mq_unfreeze_queue(q, memflags);
        }

The question remains if this looks better?

> --
> Damien Le Moal
> Western Digital Research
>
