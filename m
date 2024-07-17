Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4503A8493;
	Wed, 17 Jul 2024 09:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721206842; cv=none; b=uQXioYOyBadcl4RIvUJNxeAGIq6XjaVtjfNzHdvinwKL4H0BRYYRE3yEQRYkKTaUikVwe3X0K90RFu0dusnZkSXmmaWhKUezIG+q7TnkW0VBpoP86Ex5mlcZba6tvnwziGAlpXHLd8M8J/ei7V/EdSOMwgPrT4QuAzWrmjh1vUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721206842; c=relaxed/simple;
	bh=S+vNdNYt6/4XnOa6ae/hoTsv6eC/oZJVUbLX89ckCuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhfieQwkqYlp/CdFQrG/2WCaL7hE6cDv+B67go8L68YODZU2N9myuKPsmnPQkOGrEtZLzg/ygo9pEPvANqvqpJ+dT6zUDwkXlORaCU3hNti3ovomwaeSTnGV3o8WkFWEHla4fQ+KYNCC4rTH3W1ci4onj6QfT6OkonKnOJq7OAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XEoOuZZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEoOuZZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EBDC4AF0F;
	Wed, 17 Jul 2024 09:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721206841;
	bh=S+vNdNYt6/4XnOa6ae/hoTsv6eC/oZJVUbLX89ckCuE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XEoOuZZhaG2Os231agiwz3/Oe3Kl8aV1/NiMSr8JgQd3ESRU/NSLMVeq6eStOGpII
	 Dkb9drwVfpRMQziE3mJh8a0/wqJzyH5ZXGY2ZHlmigPU7F4WOojkjuJCQAomG6gp9w
	 pCPfuJNRMD727N+o0fIaT8+vDdYouQRMX5Hb7RkRadbP4wka2fK9HGdHa+NWGB75us
	 PSYuoV0z9uxIlZjG/1ndYCE2Rj/jWpx/IvPhkWhhYtjQll0W1LSQah6ziHv+LqpkJH
	 Ri0bhbL95rITe6LYhgw3KSv3JbyDVPxmRAa/YfnKh2ekwpAvJqTBwoJlnfb0rH/FG0
	 Dzzx3n8fvSkmA==
Received: from johan by xi.lan with local (Exim 4.97.1)
	(envelope-from <johan@kernel.org>)
	id 1sU0Wg-000000002Zs-1ziF;
	Wed, 17 Jul 2024 11:00:43 +0200
Date: Wed, 17 Jul 2024 11:00:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Johan Hovold <johan+linaro@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: sd: Do not repeat the starting disk
 message"
Message-ID: <ZpeIOsEbBIho9P_1@hovoldconsulting.com>
References: <20240716161101.30692-1-johan+linaro@kernel.org>
 <39143ca8-68e4-44eb-8619-0b935aa81603@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39143ca8-68e4-44eb-8619-0b935aa81603@kernel.org>

On Wed, Jul 17, 2024 at 07:48:26AM +0900, Damien Le Moal wrote:
> On 7/17/24 01:11, Johan Hovold wrote:
> > This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.
> > 
> > The offending commit tried to suppress a double "Starting disk" message
> > for some drivers, but instead started spamming the log with bogus
> > messages every five seconds:
> > 
> > 	[  311.798956] sd 0:0:0:0: [sda] Starting disk
> > 	[  316.919103] sd 0:0:0:0: [sda] Starting disk
> > 	[  322.040775] sd 0:0:0:0: [sda] Starting disk
> > 	[  327.161140] sd 0:0:0:0: [sda] Starting disk
> > 	[  332.281352] sd 0:0:0:0: [sda] Starting disk
> > 	[  337.401878] sd 0:0:0:0: [sda] Starting disk
> > 	[  342.521527] sd 0:0:0:0: [sda] Starting disk
> > 	[  345.850401] sd 0:0:0:0: [sda] Starting disk
> > 	[  350.967132] sd 0:0:0:0: [sda] Starting disk
> > 	[  356.090454] sd 0:0:0:0: [sda] Starting disk
> > 	...
> > 
> > on machines that do not actually stop the disk on runtime suspend (e.g.
> > the Qualcomm sc8280xp CRD with UFS).
> 
> This is odd. If the disk is not being being suspended, why does the platform
> even enable runtime PM for it ? 

This is clearly intended to be supported as sd_do_start_stop() returns
false and that prevents sd_start_stop_device() from being called on
resume (and similarly on suspend which is why there are no matching
stopping disk messages above):

	[   32.822189] sd 0:0:0:0: sd_resume_common - runtime = 1, sd_do_start_stop = 0, manage_runtime_start_stop = 0

> Are you sure about this ? Or is it simply that
> the runtime pm timer is set to a very low interval ?

I haven't tried to determine why runtime pm is used this way, but your
patch is clearly broken as it prints a message about starting the disk
even when sd_do_start_stop() returns false.

> It almost sound like what we need to do here is suppress this message for the
> runtime resume case, so something like:

No, that would only make things worse as I assume you'd have a stopped
disk message without a matching start message for driver that do end up
stopping the disk here.

> However, I would like to make sure that this platform is not calling
> sd_resume_runtime() for nothing every 5s. If that is the case, then there is a
> more fundamental problem here and reverting this patch is only hiding that.

This is with the Qualcomm UFS driver, but it seems it just relies on the
generic ufshcd_pltfrm_init() implementation.

Also not sure why anyone would want to see these messages on every
runtime suspend (for drivers that end up taking this path), but that's a
separate discussion.

Johan
