From: R.E.Wolff@BitWizard.nl (Rogier Wolff)
Subject: Re: Sym53C8xx Driver Hardening
Date: Tue, 23 Jul 2002 17:38:30 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207231538.RAA03408@cave.bitwizard.nl>
References: <1027437862.31787.136.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1027437862.31787.136.camel@irongate.swansea.linux.org.uk> from
 Alan Cox at "Jul 23, 2002 04:24:22 pm"
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>, linux-scsi@vger.kernel.org

Alan Cox wrote:
> On Tue, 2002-07-23 at 14:57, Rogier Wolff wrote:
> > Now it won't be as easy as this. But for instance in my firestream
> > driver, you sometimes put a value in a register in the chip, and if
> > later on you read it back, you want the chip to have left it
> > unmodified, or to have it changed in a predictable way. If the value
> > is unexpected, a panic is the right "way out". 
> 
> The high reliability people take a different view. I actually agree with
> them. It isnt about 'oops didnt happen' it is about controlling the
> failure case
> 
> Suppose your firestream driver reports catacylsmic internal error
> status. Their argument is not that you should pretend life is good but
> that the driver should log a fault and shut off the chip as best it can.
> So you might have a firestream_failed() function which did
> 
> 	Disable master bit
> 	Put board into D3
> 	Wait
> 	Put board into running state
> 	Try to reset and configure it
> 	If this fails shove it in D3 and give up
> 
> At this point the high reliability system is servicing the other links
> it manages and flashing warning lights to the engineers, rather than
> completely down

That might indeed be preferable. However, the "wild DMA" may have
corrupted users' data, and/or the kernel's datastructures. So
continuing may lead to a bad situation getting worse...

Maybe we want to generalize "panic" so that you pass it a pointer to
"shutdown this hardware" routine, allowing diversion of the "policy"
about what to do to a user-definable central place.....

Userspace would then be notified: "We shut down atm0 due to an
irrecoverable error". And userspace can then decide to kick the device
as you suggest above.

Or, I could configure it to do an immediate reboot, with/without
attempting to sync disks....

		Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2137555 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
* There are old pilots, and there are bold pilots. 
* There are also old, bald pilots. 
