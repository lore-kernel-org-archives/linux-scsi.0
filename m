From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: When must the io_request_lock be held?
Date: Wed, 07 Aug 2002 10:26:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208071526.g77FQOt03034@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA12461
	for <linux-scsi@vger.kernel.org>; Wed, 7 Aug 2002 08:26:28 -0700
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Wed, 07 Aug 2002 10:48:47 EDT." <20020807104847.B10872@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>, linux-scsi@vger.kernel.org

dledford@redhat.com said:
> I can't, for the life of me, remember right now if the new_eh
> strategy, abort, device_reset, and bus_reset routines are called with
> a lock held, you'll have to look that up by going into scsi_error.c
> and checking it out.

They are, but you can drop it (as long as you reacquire it before exit).

dledford@redhat.com said:
> You can use the spin_unlock() variant if you wish, but that will leave
> interrupts disabled and therefore buy you exactly zero benefit on UP
> systems.

This isn't necessarily true.  Some SCSI cards have a single mailbox for 
outgoing and incoming transfer parameters and commands.  If you have one of 
these, you need to keep interrupts disabled as you set up a command so that 
your own interrupt routine doesn't overwrite the values if you get a reconnect 
interrupt while you're programming the card.

dledford@redhat.com said:
> You are, of course, responsible for doing sane locking in your driver
> if you choose to unlock the locks the mid layer holds for you.

This is a very important point to bear in mind.  Since the io_request_lock 
must be held when calling the done() routine, you are asking to create a 
deadlock if you use your own locks in the driver (it's not impossible to get 
this correct, just very difficult).

Basically, the io_request_lock is used to protect structures within the SCSI 
and block layer.  Once you get into the LLD, you may extend it if you wish to 
protect the individual data structures of your driver (which is why it's held 
on entry to most of the LLD API) but if you don't want to, it is safe to drop 
it (as long as your queuecommand is re-entrant and you re-acquire it before 
exiting the API routines).

James


