From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Setting queue depths in the scsi mid layer, an intro
Date: 11 Oct 2002 13:47:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1034340422.6463.78.camel@irongate.swansea.linux.org.uk>
References: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com>
	<1034332488.6462.55.camel@irongate.swansea.linux.org.uk>
	<20021011103958.GA28490@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021011103958.GA28490@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2002-10-11 at 11:39, Doug Ledford wrote:
> <Arghhh!!!  Pulling hair out>
> 
> I wish people would decide on whether or not they want the drivers to be 
> able to control things.  One week I hear everyone say "The driver should 
> be able to set feature X because only it knows what to do" and the next 
> week I get what you see above...
> 

It isnt an either/or question. I think thats the problem. 

Do we want drivers to be able to control things - yes
Do we want drivers to be able to armwave generic settings - yes
 
> the driver is the *only* one that knows what it can support.  The mid 
> layer still snoops the INQUIRY data from devices and uses it to set a 
> bunch of flags in the scsi device struct (disconnect, sdtr, wdtr, ppr, 

Ok.

> tagged_supported to name the most important ones).  Then the mid layer 
> calls the slave_attach() routine after all of these items have already 
> been set.  The lldd only needs to check these bits (or it can, at it's 
> option, snoop the INQUIRY directly via SDptr->inquiry).

Ok thats not as bad.

> No, it's more analogous to each net driver knowing it's own transmit and 
> receive ring sizes.

Believe it or not, some of them don't, and the tcp layer actually
figures out the right buffering behaviour itself. But thats a bit
different.

> Now, this is all really pointless though unless the driver is *also* 
> updated to honor the tag type the block layer requests, which is another 
> subject all together and hasn't been brought up yet ;-)

Done that bit, and for things like i2o_scsi I'm happy to do the full job
where I can, but for a lot of the older dumber devices really all they
want is "generic_do_it_conservatively"

Alan

