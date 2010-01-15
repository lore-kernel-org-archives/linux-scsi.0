From: scameron@beardog.cce.hp.com
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Fri, 15 Jan 2010 15:44:55 -0600
Message-ID: <20100115214455.GG13413@beardog.cce.hp.com>
References: <20100114165602.GY13413@beardog.cce.hp.com> <4B4F617B.5050609@interlog.com> <20100114200715.GB13413@beardog.cce.hp.com> <4B4FAC25.1050504@s5r6.in-berlin.de> <20100115081030.GZ13771@kernel.dk> <tkrat.956a5012a91df155@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:26911 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410Ab0AOVm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2010 16:42:29 -0500
Content-Disposition: inline
In-Reply-To: <tkrat.956a5012a91df155@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, mikem@beardog.cce.hp.com, dab@hp.com, hch@infradead.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Fri, Jan 15, 2010 at 10:03:09AM +0100, Stefan Richter wrote:
> On 15 Jan, Jens Axboe wrote:
> > On Fri, Jan 15 2010, Stefan Richter wrote:
> >> The sg driver's open method takes a reference to the underlying SCSI
> >> device representation of the mid layer.  Among else, this step increases
> >> the module use count of the respective low-level driver
> ...
> >> In short, it is normal, expected, and necessary what you are seeing.
> > 
> > Hmm... Unless I'm reading Stephens email incorrectly, he's holding the
> > device open, removing it, closing the device, and then attempting to
> > remove the host driver. So at the point that he wants to rmmod the
> > module, there is indeed no references to it anymore.
> > 
> > It looks like a bug.
> 
> Oh, right, I missed that the device file was indeed closed ( = the
> seemingly last user of it exited) before rmmod was attempted.
> 
> I.e. remove-single-device while an sg file is open leaves a dangling
> reference, while remove-single-device while an sd file is open does
> not...
> -- 
> Stefan Richter
> -=====-==-=- ---= -====
> http://arcgraph.de/sr/
> 

I've since tried this on a newer kernel, 2.6.33rc4 (previously I 
was using a 2.6.27 kernel). 

With the 2.6.33rc4 kernel, so far the problem hasn't appeared. 

Thanks, and sorry I didn't try the newer kernel first.

-- steve

