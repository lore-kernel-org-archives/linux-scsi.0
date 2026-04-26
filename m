Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8EA282F1B
	for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2026 21:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777237406; cv=none; b=uVtYgfYa3OcsBzArvnKJpS9WTNieeym0jjJMg/IU+rwcVpafqKdEx5odp6aqQO8veZB461Rq6u+b3j4fVVWhj6Cc8SyVPXWlHaVi1VT8P2Lc5hqI7OwivCezztOrcWGVE4Qd6o2BMEXOcwLb0DSVhV5GnT/PesKHvzLpwEwoe30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777237406; c=relaxed/simple;
	bh=3N0BTUK4hwMIbU4X17dhSmMuaydlpkauKb/7bBC/ImU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RkIWKh8BygiKM2rNBunWFI6rrLqxUWaRDvlOwWl67Ev5PvEeIXO2bK4yKotFxQHTpHCwmixHMetMbpcZOGnB5f0TS5zNQbzzrcXK+eGeefDRmUhdQoaroOhFajgvb20aSa+R7RnZ6VK4nOZVN8Zpcp2KR68p5CZsc5WkpkF00nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk; spf=pass smtp.mailfrom=philpotter.co.uk; dkim=pass (2048-bit key) header.d=philpotter-co-uk.20251104.gappssmtp.com header.i=@philpotter-co-uk.20251104.gappssmtp.com header.b=C8mhFsq8; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpotter.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20251104.gappssmtp.com header.i=@philpotter-co-uk.20251104.gappssmtp.com header.b="C8mhFsq8"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so87988395e9.0
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2026 14:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20251104.gappssmtp.com; s=20251104; t=1777237401; x=1777842201; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X9eLWtLuKgwqYCUe7plu0gxvPjwLDa7/o9IyiJWuVIU=;
        b=C8mhFsq8CCSyRz8CjUxOmySjtmEes8hSKvBgz51aVUHmBu0CvsagzXreH8cDFDjlhh
         qvNPblpHVfnjaNb70nmZC+Fbk+K3KDLwLNxiaQuFgGh5CadoSuXSFhmKo7yH4MzcXsbo
         BSIy0rgLldlcWxhAUOy/MQObc3ut5n4qnBjQEwc5zEFEgyNz1O+HgGeJgC6GMCR0W0y/
         yGXnR6c8FYZIwYgLd5TW/4rNBGbkXS9KV2qPGldRIOMneCoio7yCf1El/CfIk7lBIJtL
         andhby5xTxhSocK2UXq/a6QbMZ51qKDm+whPG5GuO0vV94ED1lGMHZzrqVP3enNB9e3K
         x6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777237401; x=1777842201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9eLWtLuKgwqYCUe7plu0gxvPjwLDa7/o9IyiJWuVIU=;
        b=QSFwz+jYDIBLjYlZ7unmPDoNvkJ2C8zf7GNJDsL+O2bJ9/vEQwQJvF4hrfxQBDNw6e
         fejCAq8zQFbJMuRXawx8uROfrbIbxRVUHYVDhIB0FFLRhrIhi9tQ2WcHMocWdB+CxIQa
         xTuPdGJpI+W2BrjV/9shU1yTcSJQacGlsEIx4VpWqArhjd26vIoGv9jDEehWu2REn4CD
         5QMwd3VlEFlPETszS8U6dthtpzLTpH5oUEbAL8cXjd1B2bSYdjb7LJmmJdfQEqvvGRbJ
         UIYV5Qckmq2Ajmcr+S4XR7WZRw5tMFnBIDxvQlsbB3C58AQMYrJhDngCh594GOeOj8x6
         hCng==
X-Forwarded-Encrypted: i=1; AFNElJ9ulINDHtq2HENtXwpaBXn0YZlBfbwTEbd24bw2etWKar/HWuih9X1DczS3pI4ZDd3hdgWqH3PLm1VI@vger.kernel.org
X-Gm-Message-State: AOJu0YysuA4bkllEZnqb8TEF0nb4MqTOBWG2O/640DP5s6dz9/ECJaHL
	UTCK/vWP6bVF6OeQLKuPJbBcR4BqUScAGmHLX1gk2EDrM1LgPsQB/EHmEsvgCynLgVg=
X-Gm-Gg: AeBDievL6MgT345lATjTJFtDN2wJfE65dWmrjLEn8MGHBvuj+mXjrADO6P43WHQ0nS1
	VJIqh3ZkdDEgyNBg/igdAmTSsq73Kwh2yEW7A6eKDau5oBVazh2yURiEu3PV0qfjwDB5CV88wmZ
	Q7V33r4ZLpyD2kWF8JpiTS/xpFKXHMbpAzrI33xziL70tB1/N7BMTB4st7ksbUHDdhpfwt7r/LN
	4x5ho4m6wfYvUUZ5lhE549Tw4oqUrWJ/Ogmue2CljE3doHJ16tJ2a6M6XjwTxAWOrKI1EMK824G
	Y9/pdjzhHyFu2mLIzVjgrfQZPg6ctQhUd0AOEP2ZneMCxrt/kWnoLrD36K9XlrBeIZpeP8ubCKq
	Li4bzeahVAte5KtM3Mq/d3WlxXKMpE6xd3OW9ZRQnZwfv2mV851nkeZ0UYrLTcnxBq00BLkE9Kq
	7LUtjTrNTGUT+ea3jS9F7FfpbMhzYh66BlmTs27mLEo3O1Kwnj51ee5hPArYwXltlCvLSbVlCFz
	Wh98pl/BcW0s6f+sO8A
X-Received: by 2002:a05:600c:3213:b0:489:149a:f9e6 with SMTP id 5b1f17b1804b1-489149afa07mr257887595e9.28.1777237401017;
        Sun, 26 Apr 2026 14:03:21 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891bb3d121sm823690925e9.14.2026.04.26.14.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:03:20 -0700 (PDT)
Date: Sun, 26 Apr 2026 22:03:18 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: Daan De Meyer <daan.j.demeyer@gmail.com>
Cc: phil@philpotter.co.uk, martin.petersen@oracle.com,
	James.Bottomley@hansenpartnership.com, axboe@kernel.dk,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, Daan De Meyer <daan@amutable.com>
Subject: Re: [PATCH v2] cdrom, scsi: sr: propagate read-only status to block
 layer via set_disk_ro()
Message-ID: <ae59luYMh6npxD09@equinox>
References: <20260330133403.796330-1-daan@amutable.com>
 <20260422113206.246267-1-daan@amutable.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422113206.246267-1-daan@amutable.com>

On Wed, Apr 22, 2026 at 11:32:06AM +0000, Daan De Meyer wrote:
> 
>  drivers/cdrom/cdrom.c | 73 ++++++++++++++++++++++++++++---------------
>  drivers/scsi/sr.c     | 11 ++-----
>  drivers/scsi/sr.h     |  1 -
>  include/linux/cdrom.h |  1 +
>  4 files changed, 51 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index fc049612d6dc..62934cf4b10d 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -631,6 +631,16 @@ int register_cdrom(struct gendisk *disk, struct cdrom_device_info *cdi)
>  
>  	WARN_ON(!cdo->generic_packet);
>  
> +	/*
> +	 * Propagate the drive's write support to the block layer so BLKROGET
> +	 * reflects actual write capability. Drivers that use GET CONFIGURATION
> +	 * features (CDC_MRW_W, CDC_RAM) must have called
> +	 * cdrom_probe_write_features() before register_cdrom() so the mask is
> +	 * complete here.
> +	 */
> +	set_disk_ro(disk, !CDROM_CAN(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM |
> +				     CDC_CD_RW));
> +
>  	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
>  	mutex_lock(&cdrom_mutex);
>  	list_add(&cdi->list, &cdrom_list);
> @@ -742,6 +752,44 @@ static int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write)
>  	return 0;
>  }
>  
> +/*
> + * Probe write-related MMC features via GET CONFIGURATION and update
> + * cdi->mask accordingly. Drivers that populate cdi->mask from the MODE SENSE
> + * capabilities page (e.g. sr) should call this after those MODE SENSE bits
> + * have been set but before register_cdrom(), so that the full set of
> + * write-capability bits is known by the time register_cdrom() decides on the
> + * initial read-only state of the disk.
> + */
> +void cdrom_probe_write_features(struct cdrom_device_info *cdi)
> +{
> +	int mrw, mrw_write, ram_write;
> +
> +	mrw = 0;
> +	if (!cdrom_is_mrw(cdi, &mrw_write))
> +		mrw = 1;
> +
> +	if (CDROM_CAN(CDC_MO_DRIVE))
> +		ram_write = 1;
> +	else
> +		(void) cdrom_is_random_writable(cdi, &ram_write);
> +
> +	if (mrw)
> +		cdi->mask &= ~CDC_MRW;
> +	else
> +		cdi->mask |= CDC_MRW;
> +
> +	if (mrw_write)
> +		cdi->mask &= ~CDC_MRW_W;
> +	else
> +		cdi->mask |= CDC_MRW_W;
> +
> +	if (ram_write)
> +		cdi->mask &= ~CDC_RAM;
> +	else
> +		cdi->mask |= CDC_RAM;
> +}
> +EXPORT_SYMBOL(cdrom_probe_write_features);
> +
>  static int cdrom_media_erasable(struct cdrom_device_info *cdi)
>  {
>  	disc_information di;
> @@ -894,33 +942,8 @@ static int cdrom_is_dvd_rw(struct cdrom_device_info *cdi)
>   */
>  static int cdrom_open_write(struct cdrom_device_info *cdi)
>  {
> -	int mrw, mrw_write, ram_write;
>  	int ret = 1;
>  
> -	mrw = 0;
> -	if (!cdrom_is_mrw(cdi, &mrw_write))
> -		mrw = 1;
> -
> -	if (CDROM_CAN(CDC_MO_DRIVE))
> -		ram_write = 1;
> -	else
> -		(void) cdrom_is_random_writable(cdi, &ram_write);
> -	
> -	if (mrw)
> -		cdi->mask &= ~CDC_MRW;
> -	else
> -		cdi->mask |= CDC_MRW;
> -
> -	if (mrw_write)
> -		cdi->mask &= ~CDC_MRW_W;
> -	else
> -		cdi->mask |= CDC_MRW_W;
> -
> -	if (ram_write)
> -		cdi->mask &= ~CDC_RAM;
> -	else
> -		cdi->mask |= CDC_RAM;
> -
>  	if (CDROM_CAN(CDC_MRW_W))
>  		ret = cdrom_mrw_open_write(cdi);
>  	else if (CDROM_CAN(CDC_DVD_RAM))
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 7adb2573f50d..c36c54ecd354 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -395,7 +395,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
>  
>  	switch (req_op(rq)) {
>  	case REQ_OP_WRITE:
> -		if (!cd->writeable)
> +		if (get_disk_ro(cd->disk))
>  			goto out;
>  		SCpnt->cmnd[0] = WRITE_10;
>  		cd->cdi.media_written = 1;
> @@ -681,6 +681,7 @@ static int sr_probe(struct scsi_device *sdev)
>  	error = -ENOMEM;
>  	if (get_capabilities(cd))
>  		goto fail_minor;
> +	cdrom_probe_write_features(&cd->cdi);
>  	sr_vendor_init(cd);
>  
>  	set_capacity(disk, cd->capacity);
> @@ -899,14 +900,6 @@ static int get_capabilities(struct scsi_cd *cd)
>  	/*else    I don't think it can close its tray
>  		cd->cdi.mask |= CDC_CLOSE_TRAY; */
>  
> -	/*
> -	 * if DVD-RAM, MRW-W or CD-RW, we are randomly writable
> -	 */
> -	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) !=
> -			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) {
> -		cd->writeable = 1;
> -	}
> -
>  	kfree(buffer);
>  	return 0;
>  }
> diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
> index dc899277b3a4..2d92f9cb6fec 100644
> --- a/drivers/scsi/sr.h
> +++ b/drivers/scsi/sr.h
> @@ -35,7 +35,6 @@ typedef struct scsi_cd {
>  	struct scsi_device *device;
>  	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
>  	unsigned long ms_offset;	/* for reading multisession-CD's        */
> -	unsigned writeable : 1;
>  	unsigned use:1;		/* is this device still supportable     */
>  	unsigned xa_flag:1;	/* CD has XA sectors ? */
>  	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
> index b907e6c2307d..260d7968cf72 100644
> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -108,6 +108,7 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
>  extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
>  				       unsigned int clearing);
>  
> +extern void cdrom_probe_write_features(struct cdrom_device_info *cdi);
>  extern int register_cdrom(struct gendisk *disk, struct cdrom_device_info *cdi);
>  extern void unregister_cdrom(struct cdrom_device_info *cdi);
>  
> -- 
> 2.53.0
>

Hi Daan,

I've looked through the patch and it looks good to me. Looks like a
decent change. I think in this case too, it's unlikely this historically
broken behaviour is being relied upon (i.e. it seems unlikely to me that
fixing it would break anything).

In addition, I've build tested and booted/run some read/write tests with
your patch which worked fine for me too.

Reviewed-by: Phillip Potter <phil@philpotter.co.uk>

One final question from me though, and a purely procedural one:
The patch was submitted from your gmail address, but signed off by your
corporate address. Are you happy for me to adjust the submission so that
the author appears as your corporate address when sending on for
inclusion? Let me know, thanks.

Regards,
Phil
