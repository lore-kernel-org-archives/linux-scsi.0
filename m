From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Wed, 8 Jan 2014 11:39:38 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401081130410.1659-100000@iolanthe.rowland.org>
References: <20140108004724.GA14082@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140108004724.GA14082@xanatos>
Sender: stable-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: walt <w41ter@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 7 Jan 2014, Sarah Sharp wrote:

> On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
> > On 01/07/2014 01:21 PM, Sarah Sharp wrote:
> > 
> > > Can you please try the attached patch, on top of the previous three
> > > patches, and send me dmesg?
> > 
> > Hi Sarah, I just now finished running 0001-More-debugging.patch for the
> > first time.  The previous dmesg didn't include that patch, but this one
> > does.
> > 
> > I read through this dmesg but I nodded off somewhere around line 500.
> > I hope you can stay awake :)
> 
> Well, it has all the info I need, but the results don't make me too
> happy.  Everything I've checked seems consistent, and I don't know why
> the host stopped.  The link TRBs are intact, the dequeue pointer for the
> endpoint was pointing to the transfer that timed out and it had the
> cycle bit set correctly, etc.  Perhaps the no-op TRBs are really the
> issue.

This may be a foolish question, but why is xhci-hcd using no-op TRBs in 
the first place?

It makes sense that they would be needed if you have to unlink an URB 
that isn't the first one on the endpoint ring.  But usb-storage never 
does that; whenever it unlinks an URB, it always unlinks the earliest 
entry in the endpoint's queue.

After unlinking the first URB on the ring, you don't need to fill in
its TRBs with no-ops.  Instead, when you are ready to start the ring
againk, just tell the host controller to move the dequeue pointer up to
the start of the next surviving URB.  (You'll also have to adjust the
CYCLE bits of the TRBs that get skipped over, but that's trivial.)

Alan Stern
