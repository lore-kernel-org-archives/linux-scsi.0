From: Linas Vepstas <linas@austin.ibm.com>
Subject: Symbios PCI error recovery [Was: Re: [PATCH/RFC] ppc64: EEH + SCSI
	recovery (IPR only)]
Date: Mon, 21 Mar 2005 17:10:28 -0600
Message-ID: <20050321231028.GV498@austin.ibm.com>
References: <20050223002409.GA10909@austin.ibm.com>
	<20050223174356.GH13081@kroah.com>
	<1109207532.5384.32.camel@gaston>
	<20050224013137.GF2088@austin.ibm.com>
	<20050226063609.GC7036@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050226063609.GC7036@colo.lackof.org>
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


Hi,

There has been a running thread for a while on several mailing lists 
concerning PCI bus error recovery.  Very breifly, some architectures
have PCI error recovery mechanisms built into them (e.g. IBM PowerPC,
also new PCI-Express chips from Intel (and other vendors) and possibly
pa-risc and others).  

I've been trying to prototype  error recovery.  I currently have
ethernet and the IPR scsi driver working, but I am having trouble with 
the symbios driver.  I need help/advice ... 

On Fri, Feb 25, 2005 at 11:36:09PM -0700, Grant Grundler was heard to remark:
> On Wed, Feb 23, 2005 at 07:31:37PM -0600, Linas Vepstas wrote:
> > I also want to do the symbios driver...
> 
> FYI, Mathew Wilcox maintains the sym2 driver in cvs.parisc-linux.org.


My current hardware will halt all i/o to/from the symbios controller
upon detection of a PCI error.  The recovery proceedure that I am
currently using is to call system firmware (aka 'bios') to raise
and then lower the #RST pci signal line for 1/4 second, then wait 2
seconds for the  PCI bus to settle, then restore the PCI config space
registers (BARs, interrupt line, etc) to what they used to be. Then,
I call sym_start_up() in an attempt to get the symbios card working
again.  And that's where I get stuck ... 

My assumption is that after the #RST, that the symbios card will sit
there, dumb and stupid, with no scripts running.  But sometimes I find 
that the card has done something to make the PCI error hardware trip
again.  Typically, this means that the card attempted to DMA to some
address that its not allowed to touch, or raised #SERR or possibly 
#PERR (I can't tell which). 

Sometimes, I get the PCI error while the card is sitting there idly
after the #RST, but more often, I get the error in sym_chip_reset(),
immediately after the   OUTB (nc_istat, SRST);

Any clue what this is about? Am I missing something? I'm rather
perplexed at this point, any clues/hints/suggestions are welcome.

--linas
