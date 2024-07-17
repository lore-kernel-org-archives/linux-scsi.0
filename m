Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AD938385;
	Wed, 17 Jul 2024 11:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721215541; cv=none; b=QNISePhjyBvwwnpTALMDvFGzfmU4NXOQJxhQ/Y7Pd9kjH5BHddeo15eu24emqsJ/tT6eYcYFmt/EUc2nj69Q5AU2QIyamJzyKFxRaZiQv1vYrqv1ohfFxZcLVuvvaaeZ/qve0orxhwt8zauVc5FrY28Qc9vl+r4xllXLzXIzg40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721215541; c=relaxed/simple;
	bh=UZR1BVRqjDPQ/etMDZvxrNCu48OQyhNEJhtGJu2o6Bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CEPbsgEGwd7cr2oTF8XAG9CnpnhDYZJai69NfQxBGTNwDOs5Sx7bSMyyJDC1dQC4Rw7Ic6fapcM0pEg84oNsOiISI95zwK8+8B8Vbesdnp1C6zqecOyBwFwEmutAlIsPrLPrBopHNVZLaFh+qhMTauLB9ABE7yiKl7FkXyqllVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIVCJHJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIVCJHJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12D4C32782;
	Wed, 17 Jul 2024 11:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721215540;
	bh=UZR1BVRqjDPQ/etMDZvxrNCu48OQyhNEJhtGJu2o6Bg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gIVCJHJBcIep4p2HqxOpsqIeh5Wacu4KBWD1ML4uk10r1P+kmT5inNC2SuwCcT9Yu
	 MKwMzTtyy9OiA3yhnjXwiqjrlRs2iRs6mEEK7Me+10gQz2fkHVG1tVuYKarU/2ZTHG
	 9TSn9YclPh7/mWCOdJ8om1ufVU91qYku3H59NuGbtCB2rqOuUAtFNDwOssWlZVMU8L
	 Sacz1CwcmtX/E8oU45bCNNm3u0dgxBU2j8q92siUTuBQXkU/BELTQxJ9lvRpAXBCdj
	 Yzm1lq2mES8Pio2Bl5Q2Iyl4xgUOw1HjwDBof1tAnxOvPv92mR2sLIxb9i8bFHO4sr
	 otFwJwldEcVPg==
Received: from johan by xi.lan with local (Exim 4.97.1)
	(envelope-from <johan@kernel.org>)
	id 1sU2n0-000000006Im-3odx;
	Wed, 17 Jul 2024 13:25:42 +0200
Date: Wed, 17 Jul 2024 13:25:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Johan Hovold <johan+linaro@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: sd: Do not repeat the starting disk
 message"
Message-ID: <ZpeqNohYoQI5HQP-@hovoldconsulting.com>
References: <20240716161101.30692-1-johan+linaro@kernel.org>
 <39143ca8-68e4-44eb-8619-0b935aa81603@kernel.org>
 <ZpeIOsEbBIho9P_1@hovoldconsulting.com>
 <bb277462-579b-4dc3-b63c-bf5768dd1ce4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb277462-579b-4dc3-b63c-bf5768dd1ce4@kernel.org>

On Wed, Jul 17, 2024 at 07:46:14PM +0900, Damien Le Moal wrote:
> On 7/17/24 18:00, Johan Hovold wrote:
> > On Wed, Jul 17, 2024 at 07:48:26AM +0900, Damien Le Moal wrote:
> >> On 7/17/24 01:11, Johan Hovold wrote:
> >>> This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.
> >>>
> >>> The offending commit tried to suppress a double "Starting disk" message
> >>> for some drivers, but instead started spamming the log with bogus
> >>> messages every five seconds:
> >>>
> >>> 	[  311.798956] sd 0:0:0:0: [sda] Starting disk
> >>> 	[  316.919103] sd 0:0:0:0: [sda] Starting disk
> >>> 	[  322.040775] sd 0:0:0:0: [sda] Starting disk
> >>> 	[  327.161140] sd 0:0:0:0: [sda] Starting disk
> >>> 	[  332.281352] sd 0:0:0:0: [sda] Starting disk
> >>> 	[  337.401878] sd 0:0:0:0: [sda] Starting disk
> >>> 	[  342.521527] sd 0:0:0:0: [sda] Starting disk
> >>> 	[  345.850401] sd 0:0:0:0: [sda] Starting disk
> >>> 	[  350.967132] sd 0:0:0:0: [sda] Starting disk
> >>> 	[  356.090454] sd 0:0:0:0: [sda] Starting disk
> >>> 	...
> >>>
> >>> on machines that do not actually stop the disk on runtime suspend (e.g.
> >>> the Qualcomm sc8280xp CRD with UFS).
> >>
> >> This is odd. If the disk is not being being suspended, why does the platform
> >> even enable runtime PM for it ? 
> > 
> > This is clearly intended to be supported as sd_do_start_stop() returns
> > false and that prevents sd_start_stop_device() from being called on
> > resume (and similarly on suspend which is why there are no matching
> > stopping disk messages above):
> > 
> > 	[   32.822189] sd 0:0:0:0: sd_resume_common - runtime = 1, sd_do_start_stop = 0, manage_runtime_start_stop = 0
> 
> Yes, so we can suppress the "Starting disk" message for runtime resume, to match
> the runtime suspend not having the message.

No, the point is that the stopping disk message is also suppressed when
sd_do_start_stop() returns false (i.e. when sd_start_stop_device() is
never called). See sd_suspend_common().

> >> Are you sure about this ? Or is it simply that
> >> the runtime pm timer is set to a very low interval ?
> > 
> > I haven't tried to determine why runtime pm is used this way, but your
> > patch is clearly broken as it prints a message about starting the disk
> > even when sd_do_start_stop() returns false.
> 
> The patch is not *that* broken, because sd_do_start_stop() returning false mean
> only that the disk will *not* be started using a START STOP UNIT command. But
> the underlying LLD must start the drive. So the message is not wrong, even
> though it is probably best to suppress it for the runtime case.

From a quick look at the code I interpret the (original) intention to be
to only print these messages in cases were sd_start_stop_device() is
actually called.
 
> The point here is that sd_runtime_resume() should NOT be called every 5s unless
> there is also a runtime suspend in between the calls. As mentioned, this can
> happen if the autosuspend timer is set to a very low timeout to aggressively
> suspend the disk after a short idle time. That of course makes absolutely no
> sense for HDDs given the spinup time needed, but I guess that is a possiblity
> for UFS drives.

I don't see anything obviously wrong with this for things like UFS.

Here's what some printk reveal for the Qualcomm platform in question:

[   50.659451] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume
[   50.669756] sd 0:0:0:0: sd_resume_runtime
[   52.911603] sd 0:0:0:0: sd_suspend_runtime
[   52.921707] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_suspend
[   53.472894] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume
[   53.481464] sd 0:0:0:0: sd_resume_runtime
[   55.550493] sd 0:0:0:0: sd_suspend_runtime
[   55.559697] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_suspend
[   58.595554] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume
[   58.607868] sd 0:0:0:0: sd_resume_runtime
[   60.667330] sd 0:0:0:0: sd_suspend_runtime
[   60.677623] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_suspend
[   63.714149] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume
[   63.724498] sd 0:0:0:0: sd_resume_runtime
[   65.772893] sd 0:0:0:0: sd_suspend_runtime
[   65.784696] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_suspend
[   68.836015] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume
[   68.849576] sd 0:0:0:0: sd_resume_runtime
[   71.359102] sd 0:0:0:0: sd_suspend_runtime
[   71.368928] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_suspend
[   73.955031] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume
[   73.963040] sd 0:0:0:0: sd_resume_runtime
[   76.032153] sd 0:0:0:0: sd_suspend_runtime
[   76.042100] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_suspend

Looks like a 2-second autosuspend timeout somewhere, and the controller
stays suspended for 1-3 seconds in between.

> >> It almost sound like what we need to do here is suppress this message for the
> >> runtime resume case, so something like:
> > 
> > No, that would only make things worse as I assume you'd have a stopped
> > disk message without a matching start message for driver that do end up
> > stopping the disk here.
> 
> OK. so let's revert this patch and I will rework that message to be displayed
> only on device removal, system suspend and system shutdown.

Sounds good.

Johan
