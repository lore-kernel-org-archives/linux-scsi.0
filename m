From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: Symbios PCI error recovery [Was: Re: [PATCH/RFC] ppc64: EEH +
	SCSI recovery (IPR only)]
Date: Thu, 31 Mar 2005 23:08:34 -0700
Message-ID: <20050401060834.GB29734@colo.lackof.org>
References: <20050223002409.GA10909@austin.ibm.com>
	<20050223174356.GH13081@kroah.com>
	<1109207532.5384.32.camel@gaston>
	<20050224013137.GF2088@austin.ibm.com>
	<20050226063609.GC7036@colo.lackof.org>
	<20050321231028.GV498@austin.ibm.com>
	<20050322175728.GE12675@colo.lackof.org>
	<20050331200622.GG15596@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc64-dev-bounces@ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20050331200622.GG15596@austin.ibm.com>
List-Unsubscribe: <https://ozlabs.org/cgi-bin/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc64-dev>
List-Post: <mailto:linuxppc64-dev@ozlabs.org>
List-Help: <mailto:linuxppc64-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/cgi-bin/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc64-dev-bounces@ozlabs.org
Errors-To: linuxppc64-dev-bounces@ozlabs.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linuxppc64-dev@ozlabs.org, linux-scsi@vger.kernel.org, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 31, 2005 at 02:06:22PM -0600, Linas Vepstas wrote:
> > Does this process cause a SCSI bus reset?
> 
> Don't get a chance to get that far.  Have to bring up the PCI interfaces
> first, before any scsi command can be issued.

My point is you want the scsi bus to get reset so devices
drop all pending IO and stop trying to tell you how much work
they've done. I thought this was possible by banging on registers
in the 53c8xx chips.

> > BTW, when did sym2 get a chance to cleanup "pending" requests?
> 
> Yes, the sym2 driver has mechanisms for that.

Uhm, *when*?
It wasn't clear from your previous description.
I would take care of this *before* trying to get the card
back on it's feet.

> > You want everything moved back to the "queued" state or failed
> > (flush pending IO so upper layers can retry if they want).
> 
> Upper layer is the linux block device; my understanding is that it does
> not retry, nor do the filesystems above that.  Passing errors upwards
> seems to be pretty darned fatal.  My goal is to limit retries to the
> driver.

That's a bad idea. Been there done that.

Upper layers can be alot smarter about retries than the driver ever
could be. While the driver knows more about the transport and why
someting might fail, upper layers will know alternate pathes 
to the same devices or to the same data on different devices.
Upper layers also set the recovery policy for particular storage.

Trying to do recovery transperently in the drivers is going to also
mess up other high level SW like Service Guard or LifeKeeper.
They want to know when a path has failed, log it, and make sure
someone gets sent to service the HW if threshholds are exceeded.

Let higher layers like dm, VxFS, LVM worry about recovery.

> > > Sometimes, I get the PCI error while the card is sitting there idly
> > > after the #RST, but more often, I get the error in sym_chip_reset(),
> > > immediately after the   OUTB (nc_istat, SRST);
> > 
> > Oh? Is this the driver trying to issue SCSI Reset?
> 
> No I am trying to reinitialize the scsi card after the pci bus has been
> reset.  This has nothing to do with scsi bus resets, as far as I know
> ... 

Ok. Sounds like the card hasn't yet recovered from the PCI Bus reset.
I don't know enough about programming 53c8xx chips to tell you where
in the process it's dying or why. If you collect traces of which
registers get read/written before it dies again, that would
a necessary step in for whoever tries to sort this out.

hth,
grant
