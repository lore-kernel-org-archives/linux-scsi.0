From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: spinlock recursion in scsi_end_request() (kernel 2.6.24)
Date: Thu, 20 May 2010 10:29:41 -0500
Message-ID: <1274369381.4458.2.camel@mulgrave.site>
References: <AANLkTilIYz-UITAugWx08u-AvKB5gI-E1M3LORZ55wro@mail.gmail.com>
	 <4BF508C8.9050405@kernel.org>
	 <AANLkTilPaI-b4IUNfUnVKahK299fujgYTXsxC1BROw0L@mail.gmail.com>
	 <4BF54FAF.6020104@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42004 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab0ETP3s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2010 11:29:48 -0400
In-Reply-To: <4BF54FAF.6020104@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Prashant <0xfffff0@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2010-05-20 at 17:05 +0200, Tejun Heo wrote:
> Hello,
> 
> On 05/20/2010 01:33 PM, Prashant wrote:
> > I have a question related to code which is almost same in the
> > current kernel.  I don't know whether this is the right mailing list
> > for the following question.
> 
> linux-scsi would probably fit better (cc'd).
> 
> > When a sata drive is unplugged, its corresponding sdev's state is set
> > to SDEV_OFFLINE. Now if IO requests are still comming on the same device,
> > They will be killed by calling scsi_kill_request().
> > 
> > 1) scsi_kill_request does following things:
> >     i) Unlock request queue
> >     ii) Increment host_busy count
> >     iii) Lock request queue
> >     iv) Calls __scsi_done()
> > 
> > 2) __scsi_done() does following things:
> >      i) set request completion data
> >      ii) Calls blk_completion_request()
> > 
> > 3) blk_completion_request() does following things:
> >      i) Adds request->donelist to blk_cpu_done softirq queue
> >         and raise the softirq (which is scsi_softirq_done)
> > 
> > 4) next sequence is:
> >     scsi_softirq_done >> scsi_finish_command >> scsi_device_unbusy()
> > 
> > 5) scsi_device_unbusy() again locks the request_queue. This is the place where
> >     we can get into the spinlock recursion.
> > 
> >     Is this correct? Please correct me if something is wrong.
> 
> Raising softirq defers the work to another context and grabbing the
> same lock from softirq handler doesn't constitute a recursive locking.
> Please try to reproduce the problem on recent kernel w/ lockdep
> enabled.

Just to confirm what Tejun says: the design of the cmd -> done (i.e.
scsi_done) going through the block sofirq handler is specifically so it
can be called either locked or unlocked, so this can never be a
recursion.

James


