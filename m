From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Thu, 12 Aug 2004 09:45:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040812074520.GE29466@elf.ucw.cz>
References: <4119611D.60401@optonline.net> <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net> <1092231462.2087.3.camel@mulgrave> <1092267400.2136.24.camel@gaston>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs214-50.eurotel.cz ([160.218.214.50]:22916 "EHLO amd.ucw.cz")
	by vger.kernel.org with ESMTP id S268448AbUHLHpl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 03:45:41 -0400
Content-Disposition: inline
In-Reply-To: <1092267400.2136.24.camel@gaston>
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Nathan Bryant <nbryant@optonline.net>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

Hi!

> > Actually, the answer is to most intents and purposes "yes".  You are
> > technically correct: there's no way to disable DMA in SCSI.  However,
> > once a device is quiesced, it has no outstanding commands, so there will
> > be no outstanding DMA to that device.  When all devices on a host have
> > been quiesced, then there will be no DMA at all going on *except* if the
> > user initiates any via another interface (like sending a device probe or
> > doing a unit scan).  The guarantee should be strong enough for swsusp to
> > proceed, but we can look at quiescing a host properly (however, we'd
> > need to move to a better host state model than we currently possess).
> 
> Some hosts will continuously DMA to memory iirc.. I remember having a
> problem with 53c8xx on some macs when transitionning from MacOS to Linux
> because of that.
> 
> We need to properly quisce the host, but that's a per host driver thing
> and shouldn't be too difficult.
> 
> Regarding suspend-to-disk, it's fairly easy for the sd driver not to
> spin down the disk for S4 (only for S3). However, we will still probably
> do at least a bus reset when waking up...
> 
> Pavel: That's one of the reason I wanted an argument to resume() too so
> drivers can make a difference between the immediate wakeup that happens
> for writing the image to disk, vs. the real wakeup on resume. In the first
> case, SCSI can avoid the bus reset, and any kind of re-configuring, in the 
> second case, the full stuff might be necessary. 

Hmm, and it can not be handled by "just remember why you were
suspended", because it is one suspend, two resumes...

Yes, I agree that argument will be usefull. Just who does all the
driver updating? ;-).
								Pavel
-- 
People were complaining that M$ turns users into beta-testers...
...jr ghea gurz vagb qrirybcref, naq gurl frrz gb yvxr vg gung jnl!
