From: Doug Ledford <dledford@redhat.com>
Subject: Re: Setting queue depths in the scsi mid layer, an intro
Date: Fri, 11 Oct 2002 08:49:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021011124938.GD28490@redhat.com>
References: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com> <1034332488.6462.55.camel@irongate.swansea.linux.org.uk> <20021011103958.GA28490@redhat.com> <1034340422.6463.78.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1034340422.6463.78.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 11, 2002 at 01:47:02PM +0100, Alan Cox wrote:
> On Fri, 2002-10-11 at 11:39, Doug Ledford wrote:
> > <Arghhh!!!  Pulling hair out>
> > 
> > I wish people would decide on whether or not they want the drivers to be 
> > able to control things.  One week I hear everyone say "The driver should 
> > be able to set feature X because only it knows what to do" and the next 
> > week I get what you see above...
> 
> It isnt an either/or question. I think thats the problem. 
> 
> Do we want drivers to be able to control things - yes
> Do we want drivers to be able to armwave generic settings - yes

And to a certain extent, both of those are true.  Overall performance in 
the face of odd conditions and such is pretty much driver dependant 
though.  Armwaving a generic setting gets you an armwaved generic error 
handler at best ;-)
 
> > No, it's more analogous to each net driver knowing it's own transmit and 
> > receive ring sizes.
> 
> Believe it or not, some of them don't,

Hmmm...I think we are talking different terms.  It would seem a bit 
difficult for a card driver to program the DMA engine on the card 
(assuming it has one, if it doesn't I don't really care about how it works 
anyway) without knowing the ring of receive buffers it has (like the ring 
on an e100 card where they set up 32 or so commands as empty receive buffs 
and tell the card where they exist and then wait for the card to interrupt 
them and say "buff X has been filled").  That's pretty analogous to the 
hardware detail level required to fully handle QUEUE_FULL messages 
properly.  Half-assed handling of QUEUE_FULL messages is easy and can be 
done with generic armwaving settings ;-) (and in fact it will be, expect 
those changes when I've had some sleep and get back to work on it, the 
aic7xxx_old patch I just sent to Linus disables the intelligent QF 
handling in the driver so I can test mid layer handling instead).

> > Now, this is all really pointless though unless the driver is *also* 
> > updated to honor the tag type the block layer requests, which is another 
> > subject all together and hasn't been brought up yet ;-)
> 
> Done that bit, and for things like i2o_scsi I'm happy to do the full job
> where I can, but for a lot of the older dumber devices really all they
> want is "generic_do_it_conservatively"

That's not going to be a problem.  Doing things optimally and doing things 
well enough are both going to be options like they almost always have 
been.  The goal is that the optimal version will be a good bit easier and 
be able to be done with smaller drivers in the future though.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
