From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Setting queue depths in the scsi mid layer, an intro
Date: 11 Oct 2002 14:22:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1034342560.7042.83.camel@irongate.swansea.linux.org.uk>
References: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com>
	<1034332488.6462.55.camel@irongate.swansea.linux.org.uk>
	<20021011103958.GA28490@redhat.com>
	<1034340422.6463.78.camel@irongate.swansea.linux.org.uk>
	<20021011124938.GD28490@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021011124938.GD28490@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2002-10-11 at 13:49, Doug Ledford wrote:
> And to a certain extent, both of those are true.  Overall performance in 
> the face of odd conditions and such is pretty much driver dependant 
> though.  Armwaving a generic setting gets you an armwaved generic error 
> handler at best ;-)

Which is fair enough. Having users able to write adequate but working
drivers is incredibly important to Linux. We have a wide variety of
"functional" ethernet drivers and a smaller set of precision honed
drivers that cover the common high performance chips.

> Hmmm...I think we are talking different terms.  It would seem a bit 
> difficult for a card driver to program the DMA engine on the card 

There are cards whose interface is basically

	"give me the address of the next packet buffer
	"please now send this address"

and
	"do you have a packet and if so where"
	"thank you, I have finished with it"

> them and say "buff X has been filled").  That's pretty analogous to the 
> hardware detail level required to fully handle QUEUE_FULL messages 
> properly.  Half-assed handling of QUEUE_FULL messages is easy and can be 
> done with generic armwaving settings ;-) (and in fact it will be, expect 
> those changes when I've had some sleep and get back to work on it, the 
> aic7xxx_old patch I just sent to Linus disables the intelligent QF 
> handling in the driver so I can test mid layer handling instead).

Cool. I just want to be able to make sure that all the simpler drivers
can say "yeah Im not perfect but I work pretty sanely and I dont curl up
and die"

> That's not going to be a problem.  Doing things optimally and doing things 
> well enough are both going to be options like they almost always have 
> been.  The goal is that the optimal version will be a good bit easier and 
> be able to be done with smaller drivers in the future though.

Great. Then we are actually on the same path

