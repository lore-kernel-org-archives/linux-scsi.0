From: Doug Ledford <dledford@redhat.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Wed, 2 Oct 2002 18:18:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002221837.GB30503@redhat.com>
References: <dledford@redhat.com> <20021002002854.GF28265@redhat.com> <200210022141.g92LfCh01941@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210022141.g92LfCh01941@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 02, 2002 at 05:41:12PM -0400, James Bottomley wrote:
> dledford@redhat.com said:
> > This patch makes it possible to adjust the queue depth of a scsi
> > device  after it has been in use some time and you have a better idea
> > of what the  optimal queue depth should be.  For the most part this
> > should work, but my  2.5.40 test machine is blowing chunks on the
> > serverworks IDE support right  now so it isn't tested :-( 
> 
> I note that there's a lot more than dynamic queue depth adjustment in this 
> patch (PPA inquiry, slave attach etc.).

The slave attach is required for the queue depth adjustment stuff to work.  
The goal is to remove the select_queue_depths() function entirely and make 
slave_attach() -> adjust_queue_depth() the replacement.  The PPR message 
ability flag was just a simple bit that goes along with slave attach.  
There's more to be done there, but that's in there as a sample.

> How do HBA's that don't support this now work?

The mid layer calls into the HBA driver's select_queue_depths() function 
and the driver sets the queue depth on each device from there.

>  You've taken any dependency on 
> scsi_host.cmd_per_lun out of the code (thus rendering it useless) so every HBA 
> driver now is forced to use an initial queue depth adjustment just to start 
> tagged command queueing.

This is true both before and after my patch.  If the HBA doesn't implement 
the select_queue_depths function then it will never get tagged queueing.  
Besides, cmd_per_lun is *not* for tagged queueing, it's the queue depth 
the scsi mid layer is suppossed to keep for *non* tagged devices.

>  Can't we at least start with cmd_per_lun as the 
> default depth?

The current mid layer never has enabled a default depth, all scsi drivers 
must enable tagged queueing for each device before it happens.  I'm just 
changing how that's done from a specific select_queue_depths() call in 
point that does one and only one thing to a generic slave_attach() call in 
point that sets various post-INQUIRY data drive specific items, queue 
depth and acceptable speed negotiation message protocols being the two 
examples in my patch.

> I'm not entirely happy with the idea that we control the queue depth by 
> adjusting the number of the device's allocated commands.

It's the only safe way to do it.  You can't count on being able to 
allocate commands because you may not have available mem, and you don't 
want extra laying around because that wastes mem, and it allows my next 
changes to go in which includes switching to linked lists for commands and 
that way we can have a free list for each lun and when there is a command 
on the free list, then you know you are under your queue depth count 
because if all commands are used, then none are on the free list.

>  I know the patch 
> goes to great lengths to move these kmallocs out of the critical path, but 
> there are certain environments (multi-initiator) where the queue depth can be 
> nastily and randomly variable.

Go look at the QUEUE_FULL handler in the aic7xxx_old driver.  This is how 
most/all reasonably well written drivers handle queue depth adjustments.  
Trust me, they don't go around adjusting the depth all the time.  Most of 
the time there will be one initial adjustment, then maybe one more 
adjustment as we lock it down to the max upper limit when one exists, the 
rest of the time we just handle the occasional random queue depth 
QUEUE_FULL messages as exactly that and only temporarily freeze the queue 
to let the drive get some work done.

>  If the allocations were more lazy (wait a 
> while before freeing a struct Scsi_Cmnd to see if the queue depth goes up 
> again for instance) this would address some of these concerns (perhaps just 
> moving to a slab allocator for command blocks would do it?)

Nope, this is a non concern because we don't call adjust_queue_depth on 
every queue full (or at least we shouldn't, there isn't any documentation 
yet to tell people that, but that was the purpose of making the 
aic7xxx_old driver implement the new method since it serves as an example 
and it does exactly as I'm talking about).

> > Side note: I left the control of queue depth setting solely in the
> > hands  of the low level drivers since they are the *only* ones that
> > can get an  accurate queue depth reading at the time of any given
> > QUEUE_FULL message  (see what the aic7xxx_old driver has to do in the
> > QUEUE_FULL handler to  find out how many commands the drive has seen
> > at this exact point in time  vs. how many we may have queued up to the
> > card, the difference in numbers  can be significant).  For that
> > reason, the adjust_queue_depth call was  made to defer the action
> > until later so that it was interrupt context  safe.
> 
> I appreciate that the HBA driver is the most exact counter of the queue depth, 
> but would it make a significant difference if the adjustments were done 
> globally in the mid-layer?

The mid layer simply does not have access to the info needed to do what 
you are talking about.  Let me give you an example from the aic7xxx 
driver.  On this card we have a sequencer that handles the scsi protocol 
for us.  When we get a command from the mid layer it goes either to the 
card's QINFIFO (queue of commands that the sequencer hasn't started yet) 
or to the device's waiting queue (queue of commands that we can't send to 
the sequencer yet because of some reason).  Once it is on the card and the 
sequencer starts the process of selecting the target device, the command 
is moved to the waiting_q on the card (queue of commands already started 
but for which the target device has not yet responded).  Once the device 
is selected and we get to send the command, then we usually go directly 
into status phase and get our QUEUE_FULL.  At this point the sequencer 
pauses all operations on the scsi bus and interrupts the kernel to handle 
the QUEUE_FULL.  Prior to this command being selected, there may have been 
any number of commands place in the cards QOUTFIFO (our queue of already 
completed SCSI commands which the kernel interrupt driver hasn't processed 
yet).  So when the kernel driver gets the QUEUE_FULL interrupt, it must 
first plug this device up.  It then must remove any commands it finds in 
the QINFIFO and in the waiting_q on the card and requeue them back into 
the device's waiting queue.  Each command it moves like this decrements 
the device's active command count since when we place a command on the 
QINFIFO that's when we increment the active count.  Then we have to pull 
any possible completed commands out of the QOUTFIFO and place them on the 
done queue (commands we have queued to go back to the mid layer), also 
decrementing the active count each time.  Finally, we decrement the active 
count for the device one more time to accomodate our QUEUE_FULL command.  
Only after we have done *all* of this crap do we have an accurate queue 
depth count for the command that returned a QUEUE_FULL.  As you can see, 
lots of this is very hardware specific.  Controller cards that don't have 
a sequencer like control engine won't be starting commands off in a lazy 
fasion like this and so don't need all this stuff.  That's why the only 
place where we can get an accurate count of the queue depth is in the low 
level driver.  So, that code *must* stay there since getting an accurate 
count is how we avoid the random flip flops of queue depth that you were 
worried about earlier.

Now, what can be moved to the mid layer, and is on my list to do, is a 
generic interface for coming up with the proper action after a QUEUE_FULL.  
Currently, each driver not only determines the real depth, but then also 
does it's own magic to tell if it's a random event or a hard limit.  It 
would be easy to add something like scsi_notify_queue_full(sdev, count); 
where scsi_notify_queue_full() would keep track of the last queue full 
depth, etc.  Let the low level driver come up with the accurate count, 
then they can use this function to determine what to do about it.  On any 
change to queue depth, the function can return the amount of commands to 
add/subtract, then the low level driver can adjust it's own internal 
structure counts and also call scsi_adjust_queue_depth() to have the mid 
layer do likewise.  BTW, I'll change the adjust_queue_depth code to make 
it immediately adjust the depth down when possible and do lazy increases 
so that hitting a hard limit will free up resources immediately, but that 
will go with making the commands linked list based so that it can simply 
do a while(sdev->queue_depth > sdev->new_queue_depth && 
list_not_empty(sdev->free_list)) { kfree(get_list_head(sdev->free_list)); 
sdev->queue_depth--; } 

>  The great advantage is that we would gain dynamic 
> queue depth adjustments without having to add specific code to every driver, 

You're never going to get around this and have a reasonably reliable 
method :-(

> at the cost of not always being entirely accurate about the depth.  Is there a 
> good argument that this really, really must be done at the LLD level given the 
> cost in terms of LLD modifications?  You could still add hooks for those HBAs 
> that really want to do it themselves.

Well, all the device drivers that implement queue depth adjustments at all 
already do it themselves, so my proposed method is better than what we 
currently have since it at least allows them to move the decide 
disposition stuff into a library call or they can do it themselves.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
