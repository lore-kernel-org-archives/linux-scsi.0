From: Doug Ledford <dledford@redhat.com>
Subject: Re: When must the io_request_lock be held?
Date: Wed, 7 Aug 2002 10:48:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807104847.B10872@redhat.com>
References: <20020805195325.B19398@ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020805195325.B19398@ma.emulex.com>; from Jamie.Wellnitz@emulex.com on Mon, Aug 05, 2002 at 07:53:25PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 05, 2002 at 07:53:25PM -0400, Jamie Wellnitz wrote:
> When does a low-level driver have to hold the io_request_lock?

If you are using the io_request_lock as your driver's only big lock, then
you should leave it held in the queuecommand(), abort(), reset() routines.  
I can't, for the life of me, remember right now if the new_eh strategy,
abort, device_reset, and bus_reset routines are called with a lock held,
you'll have to look that up by going into scsi_error.c and checking it
out. You should grab it prior to entering your interrupt handler body and
you should grab it from any timer based entry points in your driver.  
Releasing of the lock is OK as long as you reacquire it before returning
and as long as you know that not owning a lock at that time is safe.  You
can use the spin_unlock() variant if you wish, but that will leave
interrupts disabled and therefore buy you exactly zero benefit on UP
systems.  The spin_unlock_irq() is what I typically use since that
actually allows other interrupts to come in while you are working.  You
are, of course, responsible for doing sane locking in your driver if you
choose to unlock the locks the mid layer holds for you.  In 2.4.19, the 
io_request_lock would be held.  In 2.5.x, the io_request_lock is gone and 
instead the host->host_lock would be held.

>  I know
> that a driver should take the lock when it calls a SCSI command's done
> function.

In both 2.4.x and 2.5.x if your driver uses the new error handling code, 
then this is not necessary.  It may call the done() function without any 
locks held since all the done function does is grab the bottom half 
handler lock long enough to stuff the command onto a list and then 
releases the lock and returns.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
