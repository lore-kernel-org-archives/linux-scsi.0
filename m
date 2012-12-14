From: scameron@beardog.cce.hp.com
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Fri, 14 Dec 2012 10:44:21 -0600
Message-ID: <20121214164421.GQ20898@beardog.cce.hp.com>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C9F2B9.4050500@acm.org> <20121213172513.GH20898@beardog.cce.hp.com> <50CA0692.2010903@acm.org> <20121213164912.GA28496@infradead.org> <50CAF502.3070300@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5469 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab2LNPoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2012 10:44:24 -0500
Content-Disposition: inline
In-Reply-To: <50CAF502.3070300@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com, scameron@beardog.cce.hp.com

On Fri, Dec 14, 2012 at 10:44:34AM +0100, Bart Van Assche wrote:
> On 12/13/12 17:49, Christoph Hellwig wrote:
> >On Thu, Dec 13, 2012 at 05:47:14PM +0100, Bart Van Assche wrote:
> >> From my experience with block and SCSI drivers option (1) doesn't
> >>look attractive from a performance point of view. From what I have
> >>seen performance with QD=1 is several times lower than performance
> >>with QD > 1. But maybe I overlooked something ?
> >
> >What you might be missing is that at least on Linux no one who cares
> >about performance uses the Posix AIO inferface anyway, as the
> >implementation in glibc always has been horrible.  The Linux-native
> >aio interface or the various thread pool implementations don't imply
> >useless ordering and thus can be used to fill up large queues.
> 
> Some applications need write ordering without having a need for 
> enforcing durability as fsync() does [1]. What I'm wondering about is 
> whether an operating system kernel like the Linux kernel should penalize 
> application performance when using block drivers and storage hardware 
> that preserve the order of write requests because there exist other 
> drivers and storage devices that do not preserve the order of write 
> requests ?

Which devices don't re-order requests?  So far as I know every single
disk drive ever made that is capable of handling multiple requests will
also re-order requests as it sees fit.

I expect the flash devices re-order requests as well, simply because
to feed requests to the things at a sufficient rate, you have to pump
requests into them concurrently on multiple hardware queues -- a single
cpu jamming requests into them as fast as it can is still not fast enough
to keep them busy.  Consequently, they *can't* care about ordering, as the
relative order requests on different hardware queues are submitted into them
is not even really controlled, so the OS *can't* count on concurrent requests
not to be essentially "re-ordered", just because of the nature of the way
requests get into the device.

So I think the property that devices and drivers are free to reorder
concurrent requests is not going away.

-- steve

