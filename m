From: Doug Ledford <dledford@redhat.com>
Subject: Re: Setting queue depths in the scsi mid layer, an intro
Date: Fri, 11 Oct 2002 06:39:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021011103958.GA28490@redhat.com>
References: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com> <1034332488.6462.55.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1034332488.6462.55.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 11, 2002 at 11:34:48AM +0100, Alan Cox wrote:
> > and ordered tags allowed), and the queue depth.  Most disk devices will
> > end up looking something like this:
> > 
> > scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, queue_depth);
> >
> > on all disks to 253 in order to get the best possible performance, but 
> > when the driver found out that some disk had a hard limit of say 64, it 
> > was too late to tell the mid layer to adjust things down to a reasonable 
> > value.  This allows the low level driver to make changes to the queue 
> > depth later and still have the mid layer honor them.
> 
> This seems a somewhat broken interface to me. Not in the facilities it
> provides - which are fine, but because in the general case surely this
> is entirely the business of the mid layer or mid layer provided library
> code to get right.

<Arghhh!!!  Pulling hair out>

I wish people would decide on whether or not they want the drivers to be 
able to control things.  One week I hear everyone say "The driver should 
be able to set feature X because only it knows what to do" and the next 
week I get what you see above...

</frustration>

No, the mid layer is not the right place to handle this.  Largely because
we have both drivers like the 152x Adaptec and MegaRAID/ServeRAID in the
tree.  The mid layer can't accomodate all of them in terms of queue depth
the same as it can't accomodate them all in terms of reasonable default
command timeouts.

> Why should each driver now be required to know about queue depths and
> snoop inquiry commands ?

Who said anything about snooping INQUIRY commands?  As for queue depths, 
the driver is the *only* one that knows what it can support.  The mid 
layer still snoops the INQUIRY data from devices and uses it to set a 
bunch of flags in the scsi device struct (disconnect, sdtr, wdtr, ppr, 
tagged_supported to name the most important ones).  Then the mid layer 
calls the slave_attach() routine after all of these items have already 
been set.  The lldd only needs to check these bits (or it can, at it's 
option, snoop the INQUIRY directly via SDptr->inquiry).

> It seems analogous to each net driver knowing
> about tcp windowing rather than the protocol doing it.

No, it's more analogous to each net driver knowing it's own transmit and 
receive ring sizes.

> Or am I misunderstanding. If I blindly do
> 
> 	scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, 64);
> 
> will the mid layer then figure out if it should trim the queue or turn
> off ordered tags ?

Not reliably.  It can't usually because of internal queues on smart cards 
and crap like that.  Also, it can't know to turn off ordered tags unless 
the low level driver passes back the MSG_REJECT message it should have 
gotten when issuing the ordered tag if the device doesn't support ordered 
tags.  Of course, since there's no facility for passing that info back...

What my aic7xxx_old driver does is in the MSG_REJECT handler, if last 
message was MSG_ORDERED_TAG, then call:

scsi_adjust_queue_depth(SDptr, MSG_SIMPLE_TAG, SDptr->new_queue_depth);

which leaves the actual depth unchanged but turns off ordered tags.

Now, this is all really pointless though unless the driver is *also* 
updated to honor the tag type the block layer requests, which is another 
subject all together and hasn't been brought up yet ;-)

> The interface most authors need is probably more like
> 
> 
> 	scsi_default_queue_depth(....)
> 
> 	eh_tag_error: scsi_default_tag_eh
> 
> Alan

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
