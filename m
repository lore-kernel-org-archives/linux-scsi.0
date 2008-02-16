From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
Date: Sat, 16 Feb 2008 18:11:31 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802161756330.3753-100000@netrider.rowland.org>
References: <47B756B5.7070901@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756002AbYBPXLo@vger.kernel.org>
In-Reply-To: <47B756B5.7070901@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Buehler <abuehler.kernel@gmail.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 16 Feb 2008, Andrew Buehler wrote:

> > For another, getting two copies of a message is no big deal --
> 
> I disagree.

Everyone has his own taste.  Obviously there's no world-wide consensus,
possibly because different people have different workflow habits and so
are affected by duplicate messages to varying extents.

> When I receive a message sent directly to me in a discussion which is on
> a list, I expect that it is because someone either considered it
> important enough to warrant making certain it came to my attention
> specifically, or wanted to continue the discussion but felt that it
> should not continue to take place on the mailing list.

Sometimes that is the case but often it isn't.  Your expectations are
at variance with other people's behavior; you shouldn't expect everyone
else to change just to match your personal ideals.

On the other hand, I would be perfectly happy to edit your name out of 
the reply list -- but since you said you aren't receiving all the 
messages in this thread via the list that might not be a good thing to 
do at the moment...


> > People on LKML who are more familiar with interrupt routing problems
> > might be able to offer more help.  For now, you can try things like
> > turning on CONFIG_USB_DEBUG, posting the output from dmesg, posting
> > the contents of /proc/interrupts (say before and after a new USB
> > device is plugged in).
> 
> In my current testing kernel, which I believe is the one with which I
> captured the sole successful non-2.6.23.1 dmesg so far, CONFIG_USB_DEBUG
> is on. The associated dmesg (obtained yesterday from booting with the
> Flash drive connected) is attached. (The flood of 'no version magic,
> tainting kernel' messages between line 600 and line 1160 are a side
> effect of Novell's custom environment which I have not yet made the
> effort to fix; the boot scripts attempt to detect the network card by
> modprobing every network driver available until they find one which
> works. Here, because the correct one fails, they wind up trying each one
> twice.)

The line saying:

> ehci_hcd 0000:00:1d.7: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.

is an indication that interrupt routing is indeed not working right.  
Or possibly your EHCI controller isn't working.  You could try 
blacklisting or unloading ehci-hcd to see if that helps.  Of course 
then none of your USB devices would be able to run at high speed.

> I have transcribed the contents of /proc/interrupts both before and
> after plugging in the Flash drive I have been using for testing, and
> they are also attached. I have been as careful as I could to be sure
> that the contents of the attached 'r61-interrupts-[12].txt' files is the
> same as what was shown on the laptop, but cannot absolutely guarantee
> that I have not missed something. For the record, the '1' is from before
> connecting the drive, and the '2' is from after.

Notice that the interrupt count for IRQ 11 doesn't change when you plug 
in the device.  Obviously something is wrong there.

In fact, it's a little surprising that almost all the USB controllers
are routed to the same IRQ.  However this is beyond my area of 
expertise.  You could try posting a message on the linux-acpi mailing 
list; the people there should know a lot more about these issues.


> > Assuming that the 2.6.23 kernel works on your computer, you can go
> > the extreme route of installing git and doing a bisection to find the
> > first patch causing your difficulty.
> 
> That would require me to learn enough of how git works, as distinct from
> more traditional VCSes, to be able to use it with some confidence. This
> is not impossible - indeed I want to do it at some point - but for the
> time being I have no idea where to start, and indeed I am not especially
> clear on exactly what (from a user's perspective) the differences been
> git and e.g. CVS or Subversion are. I know that the entire concept
> relies around a lack of centralization, but I have not been able to get
> my head around what that means in a practical sense.

There are some excellent tutorials on the web, with detailed
explanations of how to do a bisection to track down a kernel bug.

Alan Stern
