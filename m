From: Bernd Schubert <bs@q-leap.de>
Subject: Re: cache flush timeouts by blk_queue_ordered()
Date: Mon, 26 Jan 2009 23:39:42 +0100
Message-ID: <20090126223942.GA12463@lanczos.q-leap.de>
References: <20081120181919.GA3818@lanczos.q-leap.de> <20090126115540.694ea262.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:37010 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbZAZWjx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 17:39:53 -0500
Content-Disposition: inline
In-Reply-To: <20090126115540.694ea262.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

Andrew, thanks a lot! I'm really always impressed how you manage to find time
to grep through all the threads, even those nobody cared to look at for months.


On Mon, Jan 26, 2009 at 11:55:40AM -0800, Andrew Morton wrote:
> On Thu, 20 Nov 2008 19:19:19 +0100
> Bernd Schubert <bs@q-leap.de> wrote:
> 
> > Hello,
> > 
> > with some FC hardware-raid units we have the problem that the 
> > SYNCHRONIZE_CACHE command reproducibly fails. 
> > 
> > [658715.827428] sd 6:0:2:2: last recovery: 4311805647, now: 4459793681
> > [658715.833980] sd 6:0:2:2: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
> > [658715.842288] sd 6:0:2:2: [sdk] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
> > [658715.850954] sd 6:0:2:2: Activating scsi error recovery (1)
> > [658715.856793] sd 6:0:2:2: trying to abort command
> > [658715.861820] qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df2 2002.
> > [658746.004124] sd 6:0:2:2: last recovery: 4459793692, now: 4459801236
> > [658746.010686] sd 6:0:2:2: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
> > [658746.019004] sd 6:0:2:2: [sdk] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
> > [658746.027680] sd 6:0:2:2: Activating scsi error recovery (2)
> > [658746.033526] sd 6:0:2:2: trying to abort command
> > [658746.038543] qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df4 2002.
> 
> Does this result in a dead machine, or does the system still struggle
> along somehow?

Hmm, well, the failure that did then follow with that kernel version is 
more or less my fault. Actually the system does recover after some time,
except with the kernel version I had installed there:

Its a bit difficult to explain and please skip this part if is too boring.
On the other hand, below is the explanation of another scsi-eh bug:

The firmware of the same vendor manages to crash sometimes.
The units will then still accept basic scsi commands, but everything related
to real io will timeout, since it is a bug in their cache logic. So the linux 
scsi error handler will activate send recovery commands, but nothing related 
to io, and so it will succeed to 'recover' the device.  Normal io will
continue, but timeout again...  The error recovery loop would last endless. 
So I introduced additional patches, which only allow a maximum number of 
errors within a time limit to offline really failed units. 
Well, in that kernel version, I still had the number of error and the time
as fixed parameter, in the mean time it is adjustable by sysfs (I didn't post
the patches yet, see below why).

Probably the real solution would be to let the error handler to read some bytes
from the device after the basic recovery. 

> 
> > My guess is that these units flush their cache when this command is send
> > even though they have a battery backup unit and flushing 2GB cache may
> > take some time... Since I can only reproduce it on systems in production
> > I can't do any experiments, but I guess the default timeout of 30s is not
> > sufficient.
> > 
> > Problem is now that this timeout cannot be adjusted by the sysfs scsi device 
> > timeout, since sd_prepare_flush() doesn't have the required device 
> > structure. The reason for that is blk_queue_ordered(). It neither
> > gets a timeout argument, nor any pointer to the device.
> > 
> > I already tried to use container_of() in sd_prepare_flush, but somehow
> > that doesn't seem work if the structure member is a pointer.
> > 
> > The next solution that comes into my my mind is to add the timeout argument
> > to blk_queue_ordered() and subsequentely to modifiy all callers.
> > Would such a patch be accepted? Or is there any better solution?
> > 
> > Any help is appreciated.
> 
> Is this problem still open?

I posted a patch, but never got a comment on it.

https://kerneltrap.org/mailarchive/linux-scsi/2008/11/26/4242484

> 
> > 
> > Thanks,
> > Bernd
> > 
> > PS: (I'm also discussing the cache flush issue with one of our 
> > hardware vendors, but fixing their firmware might take ages). 
> 
> Making the timeout tunable sounds like a suitable (if minimal)
> approach.  It appears to presently be a qlogic-specific thing? 
> Command_Entry.time_out?

I don't think it is qlogic-specific. On the same qlogic controller also
more recent Infortrend device are connected (by fc-switch) and with 
these units the sync-cache timeouts never came up. The issue may be worked 
around by a higher timeouts (one needs 120s for all Infortrend units anyway)
and also by not using raid-6 on these specific units. But except throwing
away all these specific units, there it no real solution ;)


Thanks again for your help,
Bernd
