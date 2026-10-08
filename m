Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCB533A032
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 14:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791469275; cv=none; b=U/F/ilySDN1PHLw52CcIpy7eA+BmExaHSoiRE9QvuojZVikGo03BfWfOI+osNfuM2bowH53xZzJyXxBor4AkqnbDmhAaHej0+/9TBmRVXE6qnSHgpK7ZBsiecrGdEoIxM+SCcp4odVdfEhR9+IOTT2L2m/l2SFLdAgnOtOdH+Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791469275; c=relaxed/simple;
	bh=HOnNmzTNdFDd+lzt8KQGKtj80sIOXNhuClH4YwMAFvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J4JgQWr5Z5KsGsG4zFWE3vAo7D/aVPaQuBobl1CtVWLKswQAvogd5Alu3mGO7Lnss1h4r37+FW88s/37GUs12xGjJIpiwErknwy2pHVGbUHrBjWb9lQQGOf0UEqdKWrbAitWpbWMx54JskIvkl9HJ14Xk6MmYgT9ywx2M0DsUl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=WNbpmLfx; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="WNbpmLfx"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-885cf67963eso33721737b3.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 07:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1791469273; x=1792074073; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p/NKP5W3kT9gmvEjNElRhq3AEzgmNpYLCkrBSAflJAg=;
        b=WNbpmLfxSFDb8UVX6bAMLmLfsEnxkdTDtgHyMJz4geaqe0DE9m/eZrchk/HJCCH2U4
         uDuZSklA7l82uEFyCwEmH2VD5yo5HE1Ui1fcxPQVI87racO8ds/V38sg0TVv9jXAPf2m
         UJS8ydoSrYCorbYQ2w+P4bxsFHXZQAoq+LAOW56m2u/NkeKgcUe20VT70qSLgz2b5toa
         T7qWPZI3bSXWkYKQyoZKiqRfGMpangp8+LDmY0MECysM4KoBvbHDGSJD4iUStA4FJp1l
         D9qwBVqUvhKnrl/5ZlBsIIUJ9rToiwK6F1bfwmw3z5IQzSVkca3BOKyxC66ezYh/f/RU
         9YNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791469273; x=1792074073;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p/NKP5W3kT9gmvEjNElRhq3AEzgmNpYLCkrBSAflJAg=;
        b=QaTiOLA+kL/mpT96OseQEn09nio5GM+G3Thj7e8ZmM4XtWQyfbKj84CHx/7kRvqJT9
         uvec1tKHbP9j2DSEt7O6IavwZGdd5ylRwGhL+XvekQvA4+tCGH2WPC6IRzdpIRulSuhp
         gcRgi/0vgVeq7byFwYQo5W9M9++ug9TCrR/wlDjewZWyqgRoGHqtnRzwvBQwI2zmmT0O
         xe6K+3mKX0ur5aVxkr48H/6LXQgBRxbTdI8ONkKFy5/mierRQDhx8C5eFuUhSsjGw53V
         BSzXPrYAx2v5DsJj6hsopuFTaRPuADjsOac6cN7AublfIIpQ08eBKXw+v3KEA2ciEqUY
         AAEg==
X-Forwarded-Encrypted: i=1; AKwUvBxnEDwQf1eZkmxhyL9u+QjE/cV6iUgH8GBXhv8xT2RrgDYNsalODzT8GB8FwLaz8DmyLLCy8VCK4W5u@vger.kernel.org
X-Gm-Message-State: AFq9FYJPIHPfPTfWw5zWxjz4I8Jir7//fKJG0ql6TnrVUyuiwEoUuMf8
	d/+XweJ7WhG1NPq7E0FMI+8R1Nc5fMCZ/kNDQ3dibGU28sE3B0d3z0HBsL1zqH3O7g==
X-Gm-Gg: AYBFou09KwIBLdOW5NCUOGmmP35525yE+bnjrem438taFR2l1T01Cbh7TbMtmQlEyWi
	6V2pxfpYE5NMYYVx9llT+j0yxMGp5ATinZ1/+Us2G+3QGCtDxMusz3+gBZYwd8AqBUzrioKKMj4
	Xfm5epx4sdbfxyi9DsX2JrEDLCwPh7vJaJ72YsZrYnJiJRQnjKxpgFnh/gq3tMHvdWuvXJDK3gC
	01pwawvCrRVTYYOgeTA0M6ri9NE915wqCMoAunWFpIOsF5+h6Z+1a8M1tPL3SazyyNASNCdEp+o
	2yoq/ozAOQ6W+v5W8dUwfoOyBVWQ8Y1aEr2gJH9qeO1eJLj5dnAWB95DBdeHhyTyGDAKrwxDJ8U
	yDzTBTU388pIcEa3PtdiK3CZMxE3wn6SH/1aZnuH8ZCPwFUP6HjUgxVFDC1CLiIcmSf0dSg1QMW
	A9Tisiw/VfQtuydxZ9A1Mu3iaAfvuIMEIdaGtCju54W7Mi/ShMZ41WoStJO6EIPwTZI0h4MiyrI
	XiJXztJbB7zeLeu
X-Received: by 2002:a05:690c:7108:b0:890:659e:3c84 with SMTP id 00721157ae682-8b05afe3d83mr42387637b3.57.1791469270028;
        Thu, 08 Oct 2026 07:21:10 -0700 (PDT)
Received: from rowland.harvard.edu ([140.247.181.15])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91996d00badsm46695466d6.24.2026.10.08.07.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 07:21:08 -0700 (PDT)
Date: Thu, 8 Oct 2026 10:21:04 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Luca Cecchi <luca.cecchi.info@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, oneukum@suse.com
Subject: Re: [PATCH v2 1/2] usb: uas: implement .change_queue_depth to allow
 per-device queue depth override
Message-ID: <07d145c7-08a2-44ee-ac00-46535e0ca9e9@rowland.harvard.edu>
References: <20261008112645.1820678-1-luca.cecchi.info@gmail.com>
 <20261008122604.1862534-1-luca.cecchi.info@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008122604.1862534-1-luca.cecchi.info@gmail.com>

On Thu, Oct 08, 2026 at 02:26:03PM +0200, Luca Cecchi wrote:
> uas_host_template does not implement .change_queue_depth. Because of
> that, the standard sysfs queue_depth attribute stays read-only for
> every UAS device, not just mine: scsi_sysfs.c:sdev_store_queue_depth()
> requires sht->change_queue_depth to be non-NULL before it allows a
> write.
> 
> uas_probe() already defaults can_queue to qdepth - 2, with a comment
> acknowledging that "some bridge firmwares" need extra margin. That
> margin isn't enough for every bridge. Right now the only way to work
> around a bridge that needs more headroom is the IGNORE_UAS quirk,
> which disables UAS entirely and falls back to BOT/usb-storage - a
> large performance cost for a queue-depth problem.
> 
> This patch wires up .change_queue_depth so affected users can lower
> the depth for just their device (e.g. via a udev rule matching
> idVendor/idProduct), without disabling UAS altogether. Default
> behaviour (qdepth - 2) is unchanged unless userspace asks for less.
> 
> Tested against a Lexar ES3 external SSD enclosure (VID:PID 21c4:0003)
> that locks up under sustained heavy concurrent random writes at the
> default queue depth. Capping the depth to 24 via this interface
> eliminated the lockup across 6 consecutive test runs, including a
> continuous 1-hour soak test (1.36TB written, ~822MB/s, no
> uas_eh_abort_handler events).
> 
> v2: guard against devinfo->qdepth holding a negative error code left
>     over from a failed uas_configure_endpoints() call in
>     uas_post_reset()/uas_reset_resume() (the device stays live after
>     such a failure); without the guard a negative depth would reach
>     scsi_change_queue_depth() and underflow the unsigned queue_depth
>     in the block layer (found by Sashiko AI review)
> 
>     Re-tested on the same Lexar ES3 hardware: writing 0 or a negative
>     value to the sysfs queue_depth attribute is now rejected cleanly
>     (queue_depth stays at the previously set 24, no error in dmesg),
>     confirming the "depth < 1" guard behaves correctly against real
>     userspace input. I was not able to reproduce the specific failure
>     path itself (devinfo->qdepth left negative by a failed
>     usb_alloc_streams() during reset) on this machine - the running
>     kernel has CONFIG_FAULT_INJECTION disabled, so I could not force
>     that call to fail on demand. That half of the fix is verified by
>     code inspection only, not by a live reproduction.
> 
>     Also switched devinfo's lookup to sdev->hostdata (same pattern
>     already used by uas_sdev_configure() and the other scsi_device-
>     level callbacks in this file) instead of casting
>     sdev->host->hostdata, which was pushing the line past 80 columns.
> 
> Signed-off-by: Luca Cecchi <luca.cecchi.info@gmail.com>
> ---
>  drivers/usb/storage/uas.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 2651629..971a47f 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -910,6 +910,38 @@ static int uas_sdev_configure(struct scsi_device *sdev,
>  	return 0;
>  }
>  
> +/*
> + * uas does not implement .change_queue_depth, so the standard sysfs
> + * queue_depth attribute stays read-only for every UAS device (see
> + * scsi_sysfs.c:sdev_store_queue_depth(), which requires
> + * sht->change_queue_depth != NULL).

This sentence will no longer be true after the patch is merged.  It does 
not belong here.

>  Some bridge chips become
> + * unstable under deep command queueing; wiring this up lets affected
> + * users lower the depth for just their device (e.g. via a udev rule
> + * matching idVendor/idProduct), without disabling UAS altogether.
> + * Default behaviour (qdepth - 2) is unchanged unless userspace asks
> + * for less.
> + */

In fact, does anything in this comment tell the reader something that 
isn't already obvious?  Maybe no part of the comment is needed.  Or just 
a minimal comment, such as:

/*
 * Implementing .change_queue_depth allows users to lower the per-device
 * depth queue via sysfs.
 */

Alan Stern
