From: Doug Ledford <dledford@redhat.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Thu, 3 Oct 2002 12:35:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021003163548.GE30853@redhat.com>
References: <dledford@redhat.com> <20021002221837.GB30503@redhat.com> <200210031246.g93CkLF02116@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210031246.g93CkLF02116@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 03, 2002 at 08:46:19AM -0400, James Bottomley wrote:
> dledford@redhat.com said:
> > Go look at the QUEUE_FULL handler in the aic7xxx_old driver.  This is
> > how  most/all reasonably well written drivers handle queue depth
> > adjustments.   Trust me, they don't go around adjusting the depth all
> > the time.  Most of  the time there will be one initial adjustment,
> > then maybe one more  adjustment as we lock it down to the max upper
> > limit when one exists, the  rest of the time we just handle the
> > occasional random queue depth  QUEUE_FULL messages as exactly that and
> > only temporarily freeze the queue  to let the drive get some work
> > done. 
> 
> OK, I spent a nice evening doing this (do I get brownie points?).  I see your 
> algorithm is roughly lower the depth after 14 queue fulls and assume that luns 
> of the same pun need to be treated equivalently.

(Note: the aic7xxx_old driver has flawed pun/lun tagged queue 
differentiation.  I know this.  It's not trivial to fix and I'm not going 
to fix it until I send in the patch that implements decision making at the 
library level.  I have no plan to ever fix it in the actual aic7xxx_old 
driver, only in the library)  Yes, you get brownie points ;-)

> I failed entirely to find how the queue depth is increased (no brownie points 
> here).  How is that done?

It isn't.  When we set the queue depth during init, we set it to the 
maximum allowed.  We only reduce the depth after getting 14 consecutive 
QUEUE_FULLs at the same depth.  By that point in time we can safely assume 
that the 14 QUEUE_FULLs represented a hard limit, not a transient limit, 
and therefore there is no need to ever raise the limit again.  Keep in 
mind that in the driver, every time we get a QUEUE_FULL, we freeze the 
queue until either A) a command completes or B) 10ms have passed.  That 
means we won't get 14 QUEUE_FULLs without the drive having a chance to 
change the current situation and remedy any transient conditions.

> > The mid layer simply does not have access to the info needed to do
> > what  you are talking about.  Let me give you an example from the
> > aic7xxx  driver.  On this card we have a sequencer that handles the
> [...]
> > how we avoid the random flip flops of queue depth that you were
> > worried about earlier. 
> 
> Yes, many HBAs have internal "issue" queues where commands wait before being 
> placed on the bus.  I was assuming, however, that when a HBA driver got QUEUE 
> FULL, it would traverse the issue queue and respond QUEUE FULL also to all 
> pending commands for that device.  The mid-layer should thus see a succession 
> of QUEUE FULLs for the device (we even have a nice signature for this because 
> the QUEUE FULL occurs while device_blocked is set).  However, as long as it 
> can correctly recognise this, it knows that when the last QUEUE FULL is 
> through it has the true device queue depth, doesn't it?

Nope.  It *might* be possible to make this work, but there is no guarantee 
as it stands.  Consider that while processing the QUEUE_FULLs I may have 
other successfully completed commands on my done queue waiting to be sent 
to the mid layer.  Furthermore, they get queued for a tasklet to handle.  
What happens if a driver sends the QUEUE_FULLs first and then the 
completed commands next?  We get a wrong count.  In general, you are 
suggesting that we impose a strict syncronization between the mid layer 
and the low level driver, including ordering restrictions and more, when 
instead we could just call one function with our final count once we know 
it.  We still have to do all the work in the low level driver of finding 
the commands anyway, so my way of doing things only adds a few lines of 
code to each driver beyond what they must have regardless and it avoids 
the syncronization headache this other method brings up.

> > Now, what can be moved to the mid layer, and is on my list to do, is a
> >  generic interface for coming up with the proper action after a
> > QUEUE_FULL.   Currently, each driver not only determines the real
> > depth, but then also  does it's own magic to tell if it's a random
> > event or a hard limit.  It  would be easy to add something like
> > scsi_notify_queue_full(sdev, count);  where scsi_notify_queue_full()
> > would keep track of the last queue full  depth, etc.  Let the low
> > level driver come up with the accurate count,  then they can use this
> > function to determine what to do about it.  On any  change to queue
> > depth, the function can return the amount of commands to  add/
> > subtract, then the low level driver can adjust it's own internal
> > structure counts and also call scsi_adjust_queue_depth() to have the
> > mid  layer do likewise.  BTW, I'll change the adjust_queue_depth code
> > to make  it immediately adjust the depth down when possible and do
> > lazy increases  so that hitting a hard limit will free up resources
> > immediately, but that  will go with making the commands linked list
> > based so that it can simply  do a while(sdev->queue_depth > sdev->
> > new_queue_depth &&  list_not_empty(sdev->free_list)) {
> > kfree(get_list_head(sdev->free_list));  sdev->queue_depth--; }  
> 
> I'll go for this.  That would address my main concern which is a proliferation 
> of individual queue full handling algorithms in the LLDs. (and it's better 
> than teaching the mid-layer about QUEUE FULL sequences).

Good, then we agree 100% then ;-)


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
