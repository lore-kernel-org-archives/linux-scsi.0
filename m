From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Thu, 20 Jun 2002 15:45:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620154557.E9181@redhat.com>
References: <20020618204753.A8597@redhat.com> <20020619141522.A11733@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020619141522.A11733@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Jun 19, 2002 at 02:15:22PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 19, 2002 at 02:15:22PM -0700, Patrick Mansfield wrote:
> On Tue, Jun 18, 2002 at 08:47:53PM -0400, Doug Ledford wrote:
> 
> Doug -
> 
> > As mentioned, this adds a new scsi_adjust_queue_depth routine that lets 
> > the low level driver update the queue depth on a device at any point in 
> > time.  So, when Justin Gibbs' driver allocates a queue depth of 253 
> > commands on drive X, then finds out that drive X has a hard limit of 64, 
> > then we aren't continuing to waste 189 commands worth of allocated kernel 
> > memory that can never be effectively used.  Future plans here include 
> > linking this into the bio queueing so that adjusting the mid layer queue 
> > depth does the "right thing" in regards to the bio layer (for all I know 
> > it does already, I haven't gotten into the bio->scsi interface yet).
> 
> > Once this stuff is in place, then my next goal is to get the queueing code 
> > in the mid layer up to useable standards (the goal is to be able to rip 
> > the buts of the QUEUE_FULL and BUSY handling out of my driver and still 
> > have the system do the "right thing" instead of my driver having it's own 
> > complete internal queue mechanism including timers and such like it does 
> > now).
> 
> The Scsi_Cmnd initialization should have its own function (maybe
> including allocation), called from scsi_adjust_queue_depth and your
> new code.

I disagree, but see below for why.

> So do you think the current select_queue_depths should (eventually)
> be removed?

Yes, that's my goal.  The current method is confusing to some driver 
writers as they end up seeing the same device multiple times when someone 
does any scsi-add-single-device magic on thier bus.  It only lets you 
adjust the queue depth when a device is added, not when you need to.  It's 
a bad design and needs to go away.

> Not a comment on your patch, but why isn't the queue depth setting
> handled completely in the mid-layer?

Because the mid layer doesn't have the information needed to do so.  Queue 
depth settings are limited by two things.  1) the drive's ability to 
support tagged queue commands.  2) the driver/hardware's ability to send 
those commands.  The driver's often used shared tags amongst all drives 
for efficiency reasons (my aic7xxx driver does for example).  Details such 
as this impact what can and can not be done in terms of tagged queueing.  
Only the low level driver does/should have that information, so only the 
low level driver should control the tagged queueing.  The mid layer is, 
for the most part, totally tag ignorant.  It only needs to know that they 
are supported and it can send X of them, that's all.  There isn't any real 
reason to try and make it control things.  (Not yet anyway, but I am 
planning on adding one specific type of control to the mid layer in 
regards to tagged queueing, but that's still a few patches down the road)

> The cmd_per_lun and can_queue fields are in Scsi_Host, and the mid-layer
> already checks for tagged queueing. I don't see what adavantage there
> is to having the low level adapters each set the queue depth in their
> own way. Plus, a lot of common (and not so common) code would go away.

Each low level driver *must* set the queue depth in its own way.  A few 
examples should illustrate this for you quite nicely:

1) In the aic7xxx driver I have a 255 command limit per card.  In host
memory I have a set of card/command specific data structures.  For each
command that comes in, I fill in one of these structures and I then start
the command.  The tag value used in talking to the device is actually a
direct index into this array of command structures.  That way, when a
device reconnects and tells the card what tag it is reconnecting, the card
can download the saved command state immediately.  This means that actual
tag values used between drives *must* always be unique.  Therefore, the
mid layer is not in a position to assign the actual tag value for me, but
only in a position to say "send this as a tagged command".

2) Currently (and this is broken BTW, but oh well), the aic7xxx driver 
does most of it's indexing into device specific structs based upon the 
target ID, but not based upon the lun.  That means that when connecting 
the aic7xxx driver to an external SCSI RAID chassis that exports more than 
one drive as the same target ID and different luns, we have overlap in the 
data structures in the driver.  Setting the queue depth for these 
overlapping devices requires internal knowledge of how the overlap effects 
things.  Obviously, the mid layer can't know these details.

3) The aic7xxx driver is capable of setting up a waiting queue on the card 
itself.  In this queue we may have up to 16 commands waiting to be sent to 
the device.  Now, imagine that we already have 64 commands sent to a 
Seagate drive, and we have just queued up 16 more.  When the first of 
those 16 commands connects to the Seagate drive, it might generate a 
QUEUE_FULL response.  If so, in my interrupt handler, I pull the other 15 
commands out of the waiting queue so I don't hit the drive with a bunch of 
commands when the drive can't take them.  I also count exactly how many 
commands are *actually* on the drive and active so I can track whether or 
not the QUEUE_FULL messages always happen at the same depth.  It is 
impossible to do this count without knowing intimate hardware details of 
the controller and its outgoing queue structure.  This is also the only 
reliable way of detecting when a device has a hard queue depth limit or if 
it generates QUEUE_FULL messages at differing depths based upon current 
resource allocations on the drive itself.  This happens at interrupt time 
because the command completion, where we get the QUEUE_FULL status, is 
obviously an interrupt.

> And then scsi_adjust_queue_depth() could be called when not in interrupt
> context.

This is totally backwards to what you say earlier.  Earlier you want the
mid layer to handle command queueing so that each driver doesn't have to
write specific code for setting things, and here you advocate each driver
writing its own method for calling adjust_queue_depth out of the interrupt
context when instead this lazy queue depth setting handler is one of the
few items that *could* be handled just in one place.  I think your take on
tagged queueing is about the perfect opposite of most implementation
details.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
