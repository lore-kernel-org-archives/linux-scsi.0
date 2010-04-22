From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] Re: SYNCHRONIZE_CACHE from sd_preppare_flush does not
 have retries.!
Date: Thu, 22 Apr 2010 12:23:47 -0400
Message-ID: <1271953427.2889.195.camel@mulgrave.site>
References: <1C9608B8A4CD534FB19C7C7543CBB249021C7718FA@inbmail02.lsi.com>
	 <201004201654.04934.bs_lists@aakef.fastmail.fm>
	 <4BCE015C.7060307@cs.wisc.edu>
	 <201004202238.10551.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52254 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0DVQXw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2010 12:23:52 -0400
In-Reply-To: <201004202238.10551.bs_lists@aakef.fastmail.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2010-04-20 at 22:38 +0200, Bernd Schubert wrote:
> On Tuesday 20 April 2010, Mike Christie wrote:
> > On 04/20/2010 09:54 AM, Bernd Schubert wrote:
> > > On Tuesday 20 April 2010, Desai, Kashyap wrote:
> > >>>>>> all block device flushes or is this more device specific? I was
> > >>>>>> thinking that we may want to create a sysfs interface under the
> > >>>
> > >>> block
> > >>>
> > >>>>>> dirs and have blk-sysfs.c and blk-barrier.c handle this.
> > >>>
> > >>> queue_flush
> > >>>
> > >>>>>> could set the timeout and retries that is set by some new files
> > >>>
> > >>> under
> > >>>
> > >>>>>> /sys/block/sdX/queue/ ?
> > >>
> > >> Thanks a lot for your comments.
> > >>
> > >> This is very close to my understanding. I feel this is more close to
> > >> block layer and I am almost agreeing with your thought. I tried to
> > >> understand why upstream does not have retries at
> > >> queue_flush()/sd_prepare_flush() ??? It looks like there is not specific
> > >> reason. If I am wrong can someone explain is there any specific reason
> > >> not to set rq->retries in sd_prepare_flush?
> > >
> > > I don't understand why we should need another queue timeout, when we
> > > already have a device timeout that is used as queue timeout?
> > 
> > I think a possible problem is that the one timeout setting is now being
> > used for two different operations. Currently, for disks that timeout is
> > used for READ/WRITEs. For the sync cache, if we are hitting a problem
> > with it taking longer than the current value of 30 secs, then could we
> > want to set the READ/WRITE timeout to a lower value like 60 secs, but
> > then the sync cache timeout might have to be multiple minutes.
> 
> Hmm, I don't know storage systems where it might take several minutes, but 
> sure, if a system has hundreds of gigabyte of cache with only a few disks, a 
> very long timeout might required. Though, I'm not sure if such device 
> shouldn't ignore the SYNC_CACHE command at all.
> DDN storage recommends to set the host timeout one seconds less than the 
> command timeout on the controller (70 to 90 seconds).
> 
> I hope I will find some time on Thursday or Friday to improve the patch.

Just to bring closure to this, although I personally don't think
increasing the timeout for flush to be a good idea, most other people
do, so an additional flush timeout somewhere in block controllable via
sysfs, that we can take the timeout from would likely be the best way to
go.

Thanks,

James


