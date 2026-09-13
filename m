Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58F42E1EFC
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 13:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789305682; cv=none; b=hnQV37lsVOqouiqVCIak/2XXmV+Xz5U0/ZHBkLLdCiI/1eehDNgOMrZqQuQ+HRhtA2TrkzHiOxfKTdGY872/blJegRpNQxbslQSoWu0WZa7reiKmwKktJS0eIPCbWyfJmEtWZOuvRiJAxtuc0/p/rP2d8Cw2PTtZKllpXtfuiZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789305682; c=relaxed/simple;
	bh=Phi07PPMJdWHszbQDLkmYpvn2FXNZIvtH//ocNjPnZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=byuIdQMgKpEkp9DkL6FH1IwmBsJb+Sg+lEnRcc+6UTHWWZe49s131qNv62ZmRdamlnp6YReCicDha2DMoHoyVS9Vx7dRZu04qwWM0BAZOWd52ztJ0OPsahOcvs3510c0inriHyEIV1y0JPibs+LVbuIC/JYYvThOQD9j7S15t+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=HcrsK/JJ; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="HcrsK/JJ"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f88so538376f8f.2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 06:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789305678; x=1789910478; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ilAntqs10N3cuZV3xb1rPgVYySTl8brlVvPmSH3oaLw=;
        b=HcrsK/JJlOy+3d1BfEmJ/3QAuwI8070Hd64Rp8suFgB9uL00RBG+gGgHPElhsIbjli
         F2qCbf/vAMj2qW5HwCgbpGrKd7iNPpPgFIyqRCjYrH05zB0rtYZq7FmHC4sNr5YUBkEe
         vGkpP+Q00K9UZN5G7ql+6gI7V4XrxPfOmTugvk5TF+hzh06L27/aYHTAkBrX2WOcYZzL
         4cNf686+LyzvvpzJ9yGmAf2A5z1oaMogo+zP7KQiWn3/s+ZI3VmV6k+H51YQPzNkYeer
         iHFgXgfYVpTs7YJ655mHXeih0khG7n3JGGaiOHYOX0pgC8PxKnwwxMUsDfq2HZqoYz4o
         tf+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789305678; x=1789910478;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ilAntqs10N3cuZV3xb1rPgVYySTl8brlVvPmSH3oaLw=;
        b=LWBAYlm6hPKp8U5CevYtYJOO9oO/V5HHZn8f7qmQ9OwbqBPcCBTR7gWNM15/onvQ+4
         lta8vx24jeWW22lnO1+pyaWMdXNA3+ZqT077XmFLk3iztzjgzoHic3V0+ase9AeHUfz4
         WHrxuq/UKLLl87fpYFGpl/iqwPHzYVyxzxaaTq5dq5OuM/M9lzIU0gtoWNP7hgYf6cDW
         zBn1tfZuDzjrixhkNtP2eZi8CQB6ZuGtdXOOkfJz7e2i9O4K92kg2w2Rxv2r+/Ya3H0E
         8ZqlA6+mX+/p9HC30Zl4r6O5qVSzestcWBbX3brky2OKFZ02KUGpyI/jCfSnwm3wjhuD
         uhsA==
X-Forwarded-Encrypted: i=1; AKwUvBxxvPYqKphVB5vKFvfYk/z7EPxoZCW0MHueOdkL1YTxW3fiZRHsvcX+bPIJcdVA2RLQRbqCGANQ23Ox@vger.kernel.org
X-Gm-Message-State: AFuF++n3o9hpnNftte03FTef/QDnjg9xso0+ib64BYSHc4h+IYjbZdAL
	r6K9BzuLmyd2sJkajTg5SHfTAr75c2egiz3pLbVTWkJT5ITqHlWdg1o=
X-Gm-Gg: AYBFou0dj7LG9O62ACz3tAprHTD7RHD7m/nVrogwMhV6lOrKdn9ajVTNBl7q9ffX5Oi
	wuj4xGFVrXnfGjUC3vKnDG/Ch3Xo8yGlgH6TRrE0q2C7vrgS/x5H0OYq2TapnpG67JPJDdNq5Dg
	VTjCxSys7qo9nYWbPMF4XM5HvYR+yV5E602+DKi+HvUoox4OGDCLvgPQtcVkP0MQcy4KMn+0mi+
	c8arIaR2gTiwlw67gCSntwWn+GDT1ORHqN0EfClNJbS1PW1OV08uAOfyBbbJznRn9wycWXtyeuj
	J7ziBVeeS3+HDxLqjTlhLpQcx0DON6rAUtmBMWASXiL7NrragwthNl8AzkLgdDaoVSqwVEnSuuL
	eqQ0vrrmKRbiABFsgMuu/bH4N5Ya9/B/SooXYtpOtCIzWCKdtBduWXh7R4u11czHUtZkH6HpDqM
	WFAHXdKFQiPljhIV9Rt1GqCjNW2vcFPBpWblZxPBW+dRk6ON/R6rVxz8HGi1rUEnbLyodqh7djy
	XjYv08abHe12qhzBm7ts5XzNTRI408SgWLMmeVs7k6wvkTE
X-Received: by 2002:a05:6000:2902:b0:486:f620:63bd with SMTP id ffacd0b85a97d-486f6a7d6d1mr6273755f8f.0.1789305677847;
        Sun, 13 Sep 2026 06:21:17 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4716.dip0.t-ipconnect.de. [91.43.71.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32d5f1sm20960810f8f.12.2026.09.13.06.21.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 06:21:17 -0700 (PDT)
Message-ID: <e6152171-5c2c-4243-8b64-0a619a0f44e3@googlemail.com>
Date: Sun, 13 Sep 2026 15:21:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 0977/1376] scsi: core: sysfs: Make use of bus
 callbacks
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?=
 <u.kleine-koenig@baylibre.com>, Peter Wang <peter.wang@mediatek.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sasha Levin <sashal@kernel.org>, Wentao Guan <guanwentao@uniontech.com>,
 linux-scsi@vger.kernel.org
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065629.342165847@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260912065629.342165847@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.09.2026 um 08:56 schrieb Greg Kroah-Hartman:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> 
> [ Upstream commit f7d4f1bf5724e52de049c619beddd53c62206624 ]
> 
> Introduce a bus-specific probe, remove and shutdown function. For now
> this only allows to get rid of a cast of the generic device to a SCSI
> device in the drivers and changes the remove prototype to return
> void---a non-zero return value is ignored anyhow.
> 
> The objective is to get rid of users of struct device_driver callbacks
> .probe(), .remove() and .shutdown() to eventually remove these. Until
> all SCSI drivers are converted, this results in a runtime warning about
> the drivers needing an update because there is a bus probe function and
> a driver probe function. The in-tree drivers are fixed by the following
> commits.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Link: https://patch.msgid.link/a54e363a3fd2054fb924afd7df44bca7f444b5f1.1766133330.git.u.kleine-koenig@baylibre.com
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/scsi/scsi_sysfs.c  | 73 ++++++++++++++++++++++++++++++++++++--
>   include/scsi/scsi_driver.h |  3 ++
>   2 files changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 7f69f0613c08c..0b29cbcbd7e1f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -554,10 +554,48 @@ static int scsi_bus_uevent(const struct device *dev, struct kobj_uevent_env *env
>   	return 0;
>   }
>   
> +static int scsi_bus_probe(struct device *dev)
> +{
> +	struct scsi_device *sdp = to_scsi_device(dev);
> +	struct scsi_driver *drv = to_scsi_driver(dev->driver);
> +
> +	if (drv->probe)
> +		return drv->probe(sdp);
> +	else
> +		return 0;
> +}
> +
> +static void scsi_bus_remove(struct device *dev)
> +{
> +	struct scsi_device *sdp = to_scsi_device(dev);
> +	struct scsi_driver *drv = to_scsi_driver(dev->driver);
> +
> +	if (drv->remove)
> +		drv->remove(sdp);
> +}
> +
> +static void scsi_bus_shutdown(struct device *dev)
> +{
> +	struct scsi_device *sdp = to_scsi_device(dev);
> +	struct scsi_driver *drv;
> +
> +	if (!dev->driver)
> +		return;
> +
> +	drv = to_scsi_driver(dev->driver);
> +
> +	if (drv->shutdown)
> +		drv->shutdown(sdp);
> +}
> +
> +
>   const struct bus_type scsi_bus_type = {
> -        .name		= "scsi",
> -        .match		= scsi_bus_match,
> +	.name		= "scsi",
> +	.match		= scsi_bus_match,
>   	.uevent		= scsi_bus_uevent,
> +	.probe		= scsi_bus_probe,
> +	.remove		= scsi_bus_remove,
> +	.shutdown	= scsi_bus_shutdown,
>   #ifdef CONFIG_PM
>   	.pm		= &scsi_bus_pm_ops,
>   #endif
> @@ -1609,6 +1647,30 @@ void scsi_remove_target(struct device *dev)
>   }
>   EXPORT_SYMBOL(scsi_remove_target);
>   
> +static int scsi_legacy_probe(struct scsi_device *sdp)
> +{
> +	struct device *dev = &sdp->sdev_gendev;
> +	struct device_driver *driver = dev->driver;
> +
> +	return driver->probe(dev);
> +}
> +
> +static void scsi_legacy_remove(struct scsi_device *sdp)
> +{
> +	struct device *dev = &sdp->sdev_gendev;
> +	struct device_driver *driver = dev->driver;
> +
> +	driver->remove(dev);
> +}
> +
> +static void scsi_legacy_shutdown(struct scsi_device *sdp)
> +{
> +	struct device *dev = &sdp->sdev_gendev;
> +	struct device_driver *driver = dev->driver;
> +
> +	driver->shutdown(dev);
> +}
> +
>   int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
>   {
>   	struct device_driver *drv = &sdrv->gendrv;
> @@ -1616,6 +1678,13 @@ int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
>   	drv->bus = &scsi_bus_type;
>   	drv->owner = owner;
>   
> +	if (!sdrv->probe && drv->probe)
> +		sdrv->probe = scsi_legacy_probe;
> +	if (!sdrv->remove && drv->remove)
> +		sdrv->remove = scsi_legacy_remove;
> +	if (!sdrv->shutdown && drv->shutdown)
> +		sdrv->shutdown = scsi_legacy_shutdown;
> +
>   	return driver_register(drv);
>   }
>   EXPORT_SYMBOL(__scsi_register_driver);
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index 40aba9a9349a6..249cea724abd1 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -12,6 +12,9 @@ struct request;
>   struct scsi_driver {
>   	struct device_driver	gendrv;
>   
> +	int (*probe)(struct scsi_device *);
> +	void (*remove)(struct scsi_device *);
> +	void (*shutdown)(struct scsi_device *);
>   	int (*resume)(struct device *);
>   	void (*rescan)(struct device *);
>   	blk_status_t (*init_command)(struct scsi_cmnd *);


As Wentao Guan pointed out, this is the patch that caused the dmesg warnings I encountered in boot-testing 6.12.110-rc1 
and 6.18.52-rc1 on my machine:

[    2.397237] Driver 'sr' needs updating - please use bus_type methods
...
[   84.031323] Driver 'ses' needs updating - please use bus_type methods

Is this really stable material? I feel that a new stable release should not trigger new warning messages. Feels like a 
regression, even if it does no harm... No?!

Or are there some driver patches missing that still need proper backports?

CC'ing linux-scsi list, too.

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
