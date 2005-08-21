From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sun, 21 Aug 2005 19:03:51 +0200
Message-ID: <20050821170351.GB18942@lst.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <430766F8.1090100@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:42445 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751161AbVHUVlt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 17:41:49 -0400
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j7LH49Re004635
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 10:04:10 -0700
Content-Disposition: inline
In-Reply-To: <430766F8.1090100@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Sat, Aug 20, 2005 at 01:23:04PM -0400, Luben Tuikov wrote:
> I don't mind LLDD giving channel and id to SCSI Core.  Not at all.
> What I mind is the _way_ it is done.
> 
> Just consider this (and I'm sure you have the same sentiments):
> slave alloc gives you channel and id and lun/2 to find out
> the device it wants to poke at...  And the really sad part is
> that NO ONE at linux-scsi finds this objectionable.   This should've
> been thrown out 5 years ago (well slave alloc wasn't around then)
> when iSCSI was making its way in, and when people suggested it.
> Sadly it was shot down by the Maintainers and this is what we
> have here today.

->slave_alloc gives you a scsi_device.  With proper transport class
integration that can include lots of transport-specific information.

> Ok, to answer both your and Jeff's email, this is how this all is done:
> 
> Let, (channel, id) tuple be *just another label*!

They pretty much are that as far as the scsi core code is concerned.
Just do a little grep for ->channel and ->id over the scsi core, there's
very few users except printks, and most of those few are in optional
library functions that should move into the SPI transport class one day.

