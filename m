From: scameron@beardog.cce.hp.com
Subject: Re: 16 commands per lun limitation bug?
Date: Wed, 10 Feb 2010 20:27:30 -0600
Message-ID: <20100211022730.GO11649@beardog.cce.hp.com>
References: <20100210201916.GK11649@beardog.cce.hp.com> <1265839165.2769.553.camel@mulgrave.site> <0F5B06BAB751E047AB5C87D1F77A778869C9E3AA47@GVW0547EXC.americas.hpqcorp.net> <1265840560.2769.584.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30382 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0BKCYh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2010 21:24:37 -0500
Content-Disposition: inline
In-Reply-To: <1265840560.2769.584.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, axboe@kernel.dk, jay.allison@hp.com, scameron@beardog.cce.hp.com

On Wed, Feb 10, 2010 at 05:22:40PM -0500, James Bottomley wrote:
> On Wed, 2010-02-10 at 22:19 +0000, Miller, Mike (OS Dev) wrote:
> > 
> > > -----Original Message-----
> > > From: James Bottomley [mailto:James.Bottomley@suse.de] 
> > > Sent: Wednesday, February 10, 2010 3:59 PM
> > > To: scameron@beardog.cce.hp.com
> > > Cc: linux-scsi@vger.kernel.org; Miller, Mike (OS Dev)
> > > Subject: Re: 16 commands per lun limitation bug?
> > > 
> > > On Wed, 2010-02-10 at 14:19 -0600, scameron@beardog.cce.hp.com wrote:
> > > > We have seen the amount of commands per lun that are sent 
> > > to low level 
> > > > scsi driver limited to 16 commands per lun, (seemingly 
> > > artificially, 
> > > > well below our can_queue and cmd_per_lun limits of 1020)
> > > > 
> > > > 2.6.29 does not exhibit this bad behavior.
> > > > 2.6.30, 2.6.31, 2.6.32 (2.6.32.1 through 2.6.32.8) do 
> > > exhibit this bad 
> > > > behavior
> > > > 2.6.31-rc1 does not exhibit this bad behavior
> > > 
> > > I can't think of any reason for this.  Best guess at the fix 
> > > would be the new queue full ramp up ramp down code, but no 
> > > clue as to what the problem is ... no other drivers seem to 
> > > have noticed the performance problems this would likely cause 
> > > ... and 2.6.32 is becoming the standard enterprise kernel.
> > > 
> > James,
> > I'm not sure there's much hardware out there that's capable of queuing
> > up so many commands without choking the disks. I _think_ in most cases
> > if you queue up say 64 commands on a single scsi disk that's just too
> > much. But with Smart Array we can queue up to 1024 commands (on most
> > controllers) and those are then distributed across all the drives in
> > the array(s). IOW, we're thinking not many people would have noticed
> > such a change. Hope this makes sense.
> 
> Fibre drivers to FC arrays would regard a depth of 16 as "fiddling small
> change" to quote hitchhikers.  If any of the FC drivers got limited in
> this regard, we'll see substantial enterprise performance drops ...
> which I haven't actually heard about yet.

Nevertheless, the problem is repeatable here on varied hardware,
and I figured out how to make git bisect work, patching in hpsa as I went.
It went through the several thousand commits between v2.6.29
and v2.6.30 and eventually homed in on this one as the apparent
cause of the symptoms I'm seeing:

Script started on Wed 10 Feb 2010 08:10:03 PM CST
scameron@sixx:~/lx26/linux-2.6> git bisect good
2f5cb7381b737e24c8046fd4aeab571fb71315f5 is first bad commit
commit 2f5cb7381b737e24c8046fd4aeab571fb71315f5
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Apr 7 08:51:19 2009 +0200

    cfq-iosched: change dispatch logic to deal with single requests at the time
    
    The IO scheduler core calls into the IO scheduler dispatch_request hook
    to move requests from the IO scheduler and into the driver dispatch
    list. It only does so when the dispatch list is empty. CFQ moves several
    requests to the dispatch list, which can cause higher latencies if we
    suddenly have to switch to some important sync IO. Change the logic to
    move one request at the time instead.
    
    This should almost be functionally equivalent to what we did before,
    except that we now honor 'quantum' as the maximum queue depth at the
    device side from any single cfqq. If there's just a single active
    cfqq, we allow up to 4 times the normal quantum.
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

:040000 040000 be8b0f16d8faba88fc04e877eaa9240ec5d00648 5fd6eb925f065f411ed0d387277e45ba722ea154 M	block
scameron@sixx:~/lx26/linux-2.6> exit
exit


Script done on Wed 10 Feb 2010 08:10:34 PM CST


Any thoughts Jens?

BTW, snipped out of the above email was an fio config
file I was using to do the testing to produce the symptoms.
It was 4k random reads, libaio, iodepth of 128, one drive,
/dev/sdb, hpsa driver.



> 
> James
> 
