From: Linas Vepstas <linas@austin.ibm.com>
Subject: Re: Symbios PCI error recovery [Was: Re: [PATCH/RFC] ppc64: EEH +
	SCSI recovery (IPR only)]
Date: Thu, 31 Mar 2005 14:06:22 -0600
Message-ID: <20050331200622.GG15596@austin.ibm.com>
References: <20050223002409.GA10909@austin.ibm.com>
	<20050223174356.GH13081@kroah.com>
	<1109207532.5384.32.camel@gaston>
	<20050224013137.GF2088@austin.ibm.com>
	<20050226063609.GC7036@colo.lackof.org>
	<20050321231028.GV498@austin.ibm.com>
	<20050322175728.GE12675@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc64-dev-bounces@ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20050322175728.GE12675@colo.lackof.org>
List-Unsubscribe: <https://ozlabs.org/cgi-bin/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc64-dev>
List-Post: <mailto:linuxppc64-dev@ozlabs.org>
List-Help: <mailto:linuxppc64-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/cgi-bin/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc64-dev-bounces@ozlabs.org
Errors-To: linuxppc64-dev-bounces@ozlabs.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linuxppc64-dev@ozlabs.org, linux-scsi@vger.kernel.org, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org

Hmm,

Got distracted by other issues, so I'm answering a week late...

On Tue, Mar 22, 2005 at 10:57:28AM -0700, Grant Grundler was heard to remark:
> On Mon, Mar 21, 2005 at 05:10:28PM -0600, Linas Vepstas wrote:
> > My current hardware will halt all i/o to/from the symbios controller
> > upon detection of a PCI error.  The recovery proceedure that I am
> > currently using is to call system firmware (aka 'bios') to raise
> > and then lower the #RST pci signal line for 1/4 second, then wait 2
> > seconds for the  PCI bus to settle, then restore the PCI config space
> > registers (BARs, interrupt line, etc) to what they used to be. Then,
> > I call sym_start_up() in an attempt to get the symbios card working
> > again.  And that's where I get stuck ... 
> 
> Does this process cause a SCSI bus reset?

Don't get a chance to get that far.  Have to bring up the PCI interfaces
first, before any scsi command can be issued.

> BTW, when did sym2 get a chance to cleanup "pending" requests?

Yes, the sym2 driver has mechanisms for that.

> You want everything moved back to the "queued" state or failed
> (flush pending IO so upper layers can retry if they want).

Upper layer is the linux block device; my understanding is that it does
not retry, nor do the filesystems above that.  Passing errors upwards
seems to be pretty darned fatal.  My goal is to limit retries to the
driver.

> > Sometimes, I get the PCI error while the card is sitting there idly
> > after the #RST, but more often, I get the error in sym_chip_reset(),
> > immediately after the   OUTB (nc_istat, SRST);
> 
> Oh? Is this the driver trying to issue SCSI Reset?

No I am trying to reinitialize the scsi card after the pci bus has been
reset.  This has nothing to do with scsi bus resets, as far as I know
... 

--linas
