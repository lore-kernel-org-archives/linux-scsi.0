From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Burning multiple DVDs at one time
Date: Sat, 28 Apr 2012 12:02:27 -0400
Message-ID: <20120428160226.GA9811@animx.eu.org>
References: <20120315225310.GB3152@animx.eu.org>
 <20120317095644.145d0588@stein>
 <20120317142255.GB26403@animx.eu.org>
 <20120317162853.13afa28b@stein>
 <20120318133059.GB10172@animx.eu.org>
 <20120318150127.5f8db40c@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120318150127.5f8db40c@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> On Mar 18 Wakko Warner wrote:
> > Stefan Richter wrote:
> > > On Mar 17 Wakko Warner wrote:
> > > > Thanks.  I looked at the patch.  I would just like to confirm that I can
> > > > patch my 3.0.0 vanilla kernel, compile the sr module, unload the current and
> > > > load the patched one without the need to reboot.
> > > 
> > > Yes, this should be possible.
> > > 
> > > Oh, I only noticed just know that you also wrote:
> > > 
> > > > > > The kernel is a vanilla kernel v3.0.0.  (This also happened with 2.6.35)
> > > 
> > > In 2.6.35, the Big Kernel Lock was still in place there.  That lock
> > > behaved differently from a plain mutex --- notably it was released when a
> > > thread went to sleep --- so maybe there is more to your problem than just
> > > sr_mutex blocking unrelated sr accesses.
> > 
> > There is a good possibility that I was mistaken on the 2.6.35.
> > 
> > I manually applied your patch to 3.0.0, compiled, removed sr-mod module and
> > inserted the newly compiled one.
> > 
> > With the vanilla one, I would see the buf % in wodim drop while the fifo was
> > full.  With the patch (removing the mutex), buf stayed above 98% and the
> > burn speed was 16x at the end (10x avg).
> > 
> > Seems to have fixed my problem.
> 
> Very nice; so there is an almost easy fix.  Now I or somebody else need to
> work out the required cdrom_device_info protection on which Arnd and James
> commented.

Has anything come of this as far as the fix going into the kernel?

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
