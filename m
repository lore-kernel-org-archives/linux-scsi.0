From: Doug Ledford <dledford@redhat.com>
Subject: Re: When must the io_request_lock be held?
Date: Wed, 7 Aug 2002 12:18:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807121846.F10872@redhat.com>
References: <dledford@redhat.com> <200208071526.g77FQOt03034@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200208071526.g77FQOt03034@localhost.localdomain>; from James.Bottomley@steeleye.com on Wed, Aug 07, 2002 at 10:26:24AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>, linux-scsi@vger.kernel.org

On Wed, Aug 07, 2002 at 10:26:24AM -0500, James Bottomley wrote:
> dledford@redhat.com said:
> > You can use the spin_unlock() variant if you wish, but that will leave
> > interrupts disabled and therefore buy you exactly zero benefit on UP
> > systems.
> 
> This isn't necessarily true.  Some SCSI cards have a single mailbox for 
> outgoing and incoming transfer parameters and commands.  If you have one of 
> these, you need to keep interrupts disabled as you set up a command so that 
> your own interrupt routine doesn't overwrite the values if you get a reconnect 
> interrupt while you're programming the card.

Then you better not *ever* release the lock under those conditions.  
Leaving interrupts disabled may work on UP, but on SMP it only disables 
interrupts on that one CPU and if you aren't holding your lock then 
another CPU can run the interrupt routine and trash your data.  So, back 
to my point, if you aren't enabling interrupts, then there is no reason to 
release the lock because you obviously need some sort of lock type 
protection.

> dledford@redhat.com said:
> > You are, of course, responsible for doing sane locking in your driver
> > if you choose to unlock the locks the mid layer holds for you.
> 
> This is a very important point to bear in mind.  Since the io_request_lock 
> must be held when calling the done() routine,

Don't get too hung up on this point.  In 2.5 you don't need either the 
io_request_lock or host->host_lock when calling the done function.  In 
2.4.19 you don't need it if you are a new eh driver, only if you are old.  
And hopefully by 2.4.20 that won't be true either.  If Marcello takes the 
patch I've got for 2.4 that we shipped in our Red Hat 7.3 product, then 
both new and old eh drivers will no longer have to hold a lock when they 
call the done function because both of them will be using the new eh 
code's bottom half mechanism.

> you are asking to create a 
> deadlock if you use your own locks in the driver (it's not impossible to get 
> this correct, just very difficult).

Again, if Marcello takes my patch, this will become easier as well since 
it adds a host->lock lock that allows you to get your driver off the 
horrible io_request_lock once and for all.  (Note: I may have to change 
the name to host->host_lock to make it match 2.5, but that just annoys the 
hell out of me because I *detest* totally redundant names like that...)

> Basically, the io_request_lock is used to protect structures within the SCSI 
> and block layer.  Once you get into the LLD, you may extend it if you wish to 
> protect the individual data structures of your driver (which is why it's held 
> on entry to most of the LLD API) but if you don't want to, it is safe to drop 
> it (as long as your queuecommand is re-entrant and you re-acquire it before 
> exiting the API routines).
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
