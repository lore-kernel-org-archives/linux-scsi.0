Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BB3420E98;
	Mon, 14 Sep 2026 09:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789379148; cv=none; b=IwYyKCGyH2nmE3YK/iwkIoj9Bl8I7Bmjdy9J+sqq1MSYUnUACgQZVx/4kNYPS35UmIOd6/TWce/BzouJyEFzaD+s2J/mFYp+mxeCifoG49mKXx6pySKK89NGM4oAwydeDOinhPQyX9XLsi7ZrlUzsDagjADEK2PaF7HGPO8ikZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789379148; c=relaxed/simple;
	bh=odYIDX4jCXYwxCdyrhSuvjU+Du7Mhw06F5wrY6FyKlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGdAdEEJyji++ODs3pcduBmRB8JierWC5cWBsRd+epjoWUzh+Z4mbhH6cMc4IsvWjg78RD5XmSbAvqoh6uO7QuvhuIGtzsBUYcGgLZXMIp5beBIH/YRrd5nk8d3R/K2/bjKdWX7ztUmGO2ckFzDgkLnsHdq+3AeApG/97Jl/ktQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYvTuOtn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYvTuOtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA971F000FF;
	Mon, 14 Sep 2026 09:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789379146;
	bh=yMawZMkfuQw56UbgQ22U5fo/LYdGce1H55eI7RTHbKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mYvTuOtnMmjfmgQU04+QflA7yoaOvmjQlyYcu5mesOM5r6qF/ayWKMO7sry/VXEx7
	 2anz8qiVFlHXrERHSU2OjP9gSFKQ7dvOvIowo6PzI2If2tQinz2sfs74+ZGAjimQs9
	 /H39/MoDtiXJeCC5WvS0nH+hJXI9F9OL3tZhDY/8=
Date: Mon, 14 Sep 2026 11:45:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6.12 0977/1376] scsi: core: sysfs: Make use of bus
 callbacks
Message-ID: <2026091428-overlaid-omission-49cf@gregkh>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065629.342165847@linuxfoundation.org>
 <e6152171-5c2c-4243-8b64-0a619a0f44e3@googlemail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e6152171-5c2c-4243-8b64-0a619a0f44e3@googlemail.com>

On Sun, Sep 13, 2026 at 03:21:16PM +0200, Peter Schneider wrote:
> Am 12.09.2026 um 08:56 schrieb Greg Kroah-Hartman:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> > 
> > [ Upstream commit f7d4f1bf5724e52de049c619beddd53c62206624 ]
> > 
> > Introduce a bus-specific probe, remove and shutdown function. For now
> > this only allows to get rid of a cast of the generic device to a SCSI
> > device in the drivers and changes the remove prototype to return
> > void---a non-zero return value is ignored anyhow.
> > 
> > The objective is to get rid of users of struct device_driver callbacks
> > .probe(), .remove() and .shutdown() to eventually remove these. Until
> > all SCSI drivers are converted, this results in a runtime warning about
> > the drivers needing an update because there is a bus probe function and
> > a driver probe function. The in-tree drivers are fixed by the following
> > commits.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> > Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Link: https://patch.msgid.link/a54e363a3fd2054fb924afd7df44bca7f444b5f1.1766133330.git.u.kleine-koenig@baylibre.com
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/scsi/scsi_sysfs.c  | 73 ++++++++++++++++++++++++++++++++++++--
> >   include/scsi/scsi_driver.h |  3 ++
> >   2 files changed, 74 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 7f69f0613c08c..0b29cbcbd7e1f 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -554,10 +554,48 @@ static int scsi_bus_uevent(const struct device *dev, struct kobj_uevent_env *env
> >   	return 0;
> >   }
> > +static int scsi_bus_probe(struct device *dev)
> > +{
> > +	struct scsi_device *sdp = to_scsi_device(dev);
> > +	struct scsi_driver *drv = to_scsi_driver(dev->driver);
> > +
> > +	if (drv->probe)
> > +		return drv->probe(sdp);
> > +	else
> > +		return 0;
> > +}
> > +
> > +static void scsi_bus_remove(struct device *dev)
> > +{
> > +	struct scsi_device *sdp = to_scsi_device(dev);
> > +	struct scsi_driver *drv = to_scsi_driver(dev->driver);
> > +
> > +	if (drv->remove)
> > +		drv->remove(sdp);
> > +}
> > +
> > +static void scsi_bus_shutdown(struct device *dev)
> > +{
> > +	struct scsi_device *sdp = to_scsi_device(dev);
> > +	struct scsi_driver *drv;
> > +
> > +	if (!dev->driver)
> > +		return;
> > +
> > +	drv = to_scsi_driver(dev->driver);
> > +
> > +	if (drv->shutdown)
> > +		drv->shutdown(sdp);
> > +}
> > +
> > +
> >   const struct bus_type scsi_bus_type = {
> > -        .name		= "scsi",
> > -        .match		= scsi_bus_match,
> > +	.name		= "scsi",
> > +	.match		= scsi_bus_match,
> >   	.uevent		= scsi_bus_uevent,
> > +	.probe		= scsi_bus_probe,
> > +	.remove		= scsi_bus_remove,
> > +	.shutdown	= scsi_bus_shutdown,
> >   #ifdef CONFIG_PM
> >   	.pm		= &scsi_bus_pm_ops,
> >   #endif
> > @@ -1609,6 +1647,30 @@ void scsi_remove_target(struct device *dev)
> >   }
> >   EXPORT_SYMBOL(scsi_remove_target);
> > +static int scsi_legacy_probe(struct scsi_device *sdp)
> > +{
> > +	struct device *dev = &sdp->sdev_gendev;
> > +	struct device_driver *driver = dev->driver;
> > +
> > +	return driver->probe(dev);
> > +}
> > +
> > +static void scsi_legacy_remove(struct scsi_device *sdp)
> > +{
> > +	struct device *dev = &sdp->sdev_gendev;
> > +	struct device_driver *driver = dev->driver;
> > +
> > +	driver->remove(dev);
> > +}
> > +
> > +static void scsi_legacy_shutdown(struct scsi_device *sdp)
> > +{
> > +	struct device *dev = &sdp->sdev_gendev;
> > +	struct device_driver *driver = dev->driver;
> > +
> > +	driver->shutdown(dev);
> > +}
> > +
> >   int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
> >   {
> >   	struct device_driver *drv = &sdrv->gendrv;
> > @@ -1616,6 +1678,13 @@ int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
> >   	drv->bus = &scsi_bus_type;
> >   	drv->owner = owner;
> > +	if (!sdrv->probe && drv->probe)
> > +		sdrv->probe = scsi_legacy_probe;
> > +	if (!sdrv->remove && drv->remove)
> > +		sdrv->remove = scsi_legacy_remove;
> > +	if (!sdrv->shutdown && drv->shutdown)
> > +		sdrv->shutdown = scsi_legacy_shutdown;
> > +
> >   	return driver_register(drv);
> >   }
> >   EXPORT_SYMBOL(__scsi_register_driver);
> > diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> > index 40aba9a9349a6..249cea724abd1 100644
> > --- a/include/scsi/scsi_driver.h
> > +++ b/include/scsi/scsi_driver.h
> > @@ -12,6 +12,9 @@ struct request;
> >   struct scsi_driver {
> >   	struct device_driver	gendrv;
> > +	int (*probe)(struct scsi_device *);
> > +	void (*remove)(struct scsi_device *);
> > +	void (*shutdown)(struct scsi_device *);
> >   	int (*resume)(struct device *);
> >   	void (*rescan)(struct device *);
> >   	blk_status_t (*init_command)(struct scsi_cmnd *);
> 
> 
> As Wentao Guan pointed out, this is the patch that caused the dmesg warnings
> I encountered in boot-testing 6.12.110-rc1 and 6.18.52-rc1 on my machine:
> 
> [    2.397237] Driver 'sr' needs updating - please use bus_type methods
> ...
> [   84.031323] Driver 'ses' needs updating - please use bus_type methods
> 
> Is this really stable material? I feel that a new stable release should not
> trigger new warning messages. Feels like a regression, even if it does no
> harm... No?!
> 
> Or are there some driver patches missing that still need proper backports?
> 
> CC'ing linux-scsi list, too.

I've dropped this now, thanks.

greg k-h
