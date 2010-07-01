From: scameron@beardog.cce.hp.com
Subject: Re: cciss: WARNING/BUG in do_cciss_intr (it's back)
Date: Thu, 1 Jul 2010 09:28:24 -0500
Message-ID: <20100701142824.GT17187@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: zhanglinbao@gmail.com
Cc: randy.dunlap@oracle.com, bob_zhang2004@163.com, axboe@kernel.dk, mike.miller@hp.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, james.bottomley@hansenpartnership.com, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Bob Zhang wrote:

> Hi all,
> 
> I want to know the final result.
> have you fixed this bug ?  if yes, how to fix ?
> Now , I am using 2.6.32.12-7 from sles11SP1(ia64) , I still happened
> this problem.
> 
> 
> Any comments are welcome .
> 
> another point ,
> >> Randy,
> >> I think this is a different bug than the one you reported previously.
> >> Please open a new bugzilla.
> >
> > I think it's the same one. The first warning that now triggers is:
> >
> Could you give me the previous one link ?
> 
> attachment is the booting information and eror.

( See: http://lkml.org/lkml/2009/2/4/342 for a bit more context )

and Jens Axboe wrote, back in Feb of 2009:

> I think it's the same one. The first warning that now triggers is:
> 
> WARNING: at drivers/block/cciss.c:225 
> 
> which is
> 
>         if (WARN_ON(hlist_unhashed(&c->list)))
> removeQ(), this is where we would have crashed before due to trying to
> remove a command from a list it didn't belong to. And then we crash
> right after in the interrupt handler. So I'm pretty sure this is 100%
> the same bug.
> 

I did not see a similar error in the log file you provided.

The above problem appeared to be triggered by the reset_devices path (e.g. kdump) picking
up completions from the previous kernel, due to the device not actually being reset.
All the Smart arrays since the p600 can't be reset by the PCI power management
method.  Some of them can be reset by using the "doorbell" register, and a patch
for hpsa to do this has been implemented, this one:

http://marc.info/?l=linux-scsi&m=127671403229420&w=2

which is one patch in a series of other patches to hpsa.

I am currently working on a similar series of patches for cciss.

However, this won't help the P400, P400i, E500, P800, and P700m, which cannot
be reset by either method.  Also, the 6402 and 6404, while they can
be reset, it's inadvisable since they share a battery backed cache 
module, hence this patch to hpsa:

http://marc.info/?l=linux-scsi&m=127671403029407&w=2

See also: https://bugzilla.redhat.com/show_bug.cgi?id=609522
and https://bugzilla.redhat.com/show_bug.cgi?id=598681
(you need an account to see those, I think.)

-- steve
 
