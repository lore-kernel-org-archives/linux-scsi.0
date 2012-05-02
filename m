From: Andi Shyti <andi.shyti@gmail.com>
Subject: Re: [PATCH 07/17] hpsa: do not give up retry of driver cmds after
 only 3 retries
Date: Wed, 2 May 2012 22:27:59 +0200
Message-ID: <20120502202759.GB19349@andi>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
 <20120501164240.11705.10308.stgit@beardog.cce.hp.com>
 <20120501172634.GA11302@andi>
 <20120501182011.GS11802@beardog.cce.hp.com>
 <20120501213934.GD11302@andi>
 <20120502163009.GV11802@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56648 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab2EBU2I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2012 16:28:08 -0400
Content-Disposition: inline
In-Reply-To: <20120502163009.GV11802@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

On Wed, May 02, 2012 at 11:30:09AM -0500, scameron@beardog.cce.hp.com wrote:
> On Tue, May 01, 2012 at 11:39:34PM +0200, Andi Shyti wrote:
> > Hi Steve,
> > 
> > Thanks for the walk-through, but still some doubts...
> > 
> > On Tue, May 01, 2012 at 01:20:11PM -0500, scameron@beardog.cce.hp.com wrote:
> > > On Tue, May 01, 2012 at 07:26:34PM +0200, Andi Shyti wrote:
> > > > >  
> > > > >  	do {
> > > > >  		memset(c->err_info, 0, sizeof(*c->err_info));
> > > > >  		hpsa_scsi_do_simple_cmd_core(h, c);
> > > > >  		retry_count++;
> > > > > +		if (retry_count > 3) {
> > > > > +			msleep(backoff_time);
> > > > 
> > > > for 10ms isn't it better to avoid using msleep?
> > > 
> > > [...] 
> > > > > +			if (backoff_time < 1000)
> > > > > +				backoff_time *= 2;
> > > 
> > > Eh, maybe.  from Documentation/timers-howto.txt
> > > 
> > >                         msleep(1~20) may not do what the caller intends, and
> > >                         will often sleep longer (~20 ms actual sleep for any
> > >                         value given in the 1~20ms range). In many cases this
> > >                         is not the desired behavior.
> > > 
> > > Sleeping longer (~20ms instead of 10ms) in this instance is fine, as I don't
> > > really care too much exactly how long it sleeps, and it backs off to up to
> > > 1280ms eventually anyway.  The idea is, "wait a bit, and retry, and then if
> > > that doesn't work, wait twice as long, and retry, etc."  *exactly* how long
> > > "a bit" is is not super important.  I could change the initial back_off time
> > > to 20 or 30 to satisfy the letter of the advice in Documentation/timers-howto.txt,
> > > if doing so is important.
> > 
> > No, you're right, it should not really matter, but here in the
> > worst case you put the driver on sleep for almost 22 seconds,
> > that is a huge difference compared to the original
> > implementation.
> >  
> > > This is kind of a corner case of a corner case, I don't expect
> > > things will ordinarily end up waiting that long, because normally
> > > one of the 1st 3 retries will succeed.  I just wanted to make it 
> > > a little more robust and not just give up immediately if the 3
> > > initial retries don't succeed, the specific number of retries,
> > > wait times, etc, I just made up.
> > 
> > Premising that I don't know the device, therefore I could be
> > totally wrong, if you don't expect things to wait so long, why not
> > to decrease the MAX_DRIVER_CMD_RETRIES and sleep increasingly (as
> > you did) but for shorter period?
> 
> [...]
> 
> So yeah, the "echo 1 > /sys/blah/blah/rescan" process will sleep for up to ~20 seconds
> in the event of some (presumably very rare) 20 second BUSY condition, but it will work in
> cases the old code will not, and so it sleeps 20 secs, I don't think that's really a 
> problem, esp. compared to the alternative of just failing.
>

Uhh... that was a good explanation :)
Thanks a lot! You convinced me :)

If you want you can add

Reviewed-by: Andi Shyti <andi.shyti@gmail.com> 
