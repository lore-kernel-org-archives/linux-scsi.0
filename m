From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: Symbios PCI error recovery [Was: Re: [PATCH/RFC] ppc64: EEH +
	SCSI recovery (IPR only)]
Date: Tue, 22 Mar 2005 10:57:28 -0700
Message-ID: <20050322175728.GE12675@colo.lackof.org>
References: <20050223002409.GA10909@austin.ibm.com>
	<20050223174356.GH13081@kroah.com>
	<1109207532.5384.32.camel@gaston>
	<20050224013137.GF2088@austin.ibm.com>
	<20050226063609.GC7036@colo.lackof.org>
	<20050321231028.GV498@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050321231028.GV498@austin.ibm.com>
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

On Mon, Mar 21, 2005 at 05:10:28PM -0600, Linas Vepstas wrote:
> My current hardware will halt all i/o to/from the symbios controller
> upon detection of a PCI error.  The recovery proceedure that I am
> currently using is to call system firmware (aka 'bios') to raise
> and then lower the #RST pci signal line for 1/4 second, then wait 2
> seconds for the  PCI bus to settle, then restore the PCI config space
> registers (BARs, interrupt line, etc) to what they used to be. Then,
> I call sym_start_up() in an attempt to get the symbios card working
> again.  And that's where I get stuck ... 

Does this process cause a SCSI bus reset?
SCSI devices will continue *forever* to send status back to the host
on IO's that have completed. At least that's what I remember from
working on this 8 years ago. Issuing a SCSI "Bus Reset" or
"Bus Device Reset" (BDR) will quiesce the devices.

I'm asking because it's possible sym2 driver isn't expecting
anything from any device at that point.

BTW, when did sym2 get a chance to cleanup "pending" requests?
You want everything moved back to the "queued" state or failed
(flush pending IO so upper layers can retry if they want).

> My assumption is that after the #RST, that the symbios card will sit
> there, dumb and stupid, with no scripts running.  But sometimes I find 
> that the card has done something to make the PCI error hardware trip
> again.  Typically, this means that the card attempted to DMA to some
> address that its not allowed to touch, or raised #SERR or possibly 
> #PERR (I can't tell which). 

PCI Reset typically only affects PCI facing parts of a chip.
e.g. some LAN Phy's don't get reset and need to be manually reset.
I'm skeptical sym2 will (or should) issue a SCSI Bus reset when
PCI Reset is asserted. Think multi-initiator.

> Sometimes, I get the PCI error while the card is sitting there idly
> after the #RST, but more often, I get the error in sym_chip_reset(),
> immediately after the   OUTB (nc_istat, SRST);

Oh? Is this the driver trying to issue SCSI Reset?

> Any clue what this is about? Am I missing something? I'm rather
> perplexed at this point, any clues/hints/suggestions are welcome.

Sorry - I'm no expert on 53c8xx chips. Hope the above helps.

grant
