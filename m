From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: 2.4.19 SCSI error handing, door locking, etc
Date: Sat, 5 Oct 2002 10:23:09 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210051000080.3098-100000@kai.makisara.local>
References: <20021004204925.D31015@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kai.makisara.local ([62.248.130.205])
          by fep07-app.kolumbus.fi with ESMTP
          id <20021005072309.IKO8133.fep07-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Sat, 5 Oct 2002 10:23:09 +0300
In-Reply-To: <20021004204925.D31015@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, 4 Oct 2002, Russell King wrote:

> On Fri, Oct 04, 2002 at 12:41:36PM -0700, Mike Anderson wrote:
> > 01-scsi-cmd-retry-3.diff
> > 	- I need to think on this. I currently have 1 retry for TUR and
> > 	  non for REQ sense. If a device is not responding the way we want the
> > 	  probability of sending multiple commands in a short time period
> > 	  especially TURs is most likely not going to result in what we
> > 	  want. Though your delay mentioned below is something I
> > 	  currently do not have.
>
> With the current behaviour, I've seen this situation:
>
> - bus reset
> - tape drive responds to bus reset by positioning at the start of tape
> - while tape drive is repositioning, it returns "drive not ready"
> - we mark the tape drive off line despite there being absolutely
>   nothing wrong with it.

Because of this possible rewind at reset, st needs to know that a reset
has happened. For instance, writing after this may be more or less
catastrophic (depending on the value of the data that was on the tape).

Currently st uses the SDpnt->was_reset flag to reject any request until
the user has performed a command or activity that moves the tape to a
known position (e.g., rewind or insert new tape). After this it is safe to
continue. But, there is no need to offline the tape device after reset.

Looking at the current st code and the midlevel code, there seems to be a
problem in st (and it is good that the device has been offlined ;-).
The midlevel tries to lock the drive door and resets the was_reset flag
during processing of the next request and st loses the knowledge of reset.
I have to change this so that st maintains its own flag. There seem to be
also some other details to fix but these are not fatal.

In general, there is one with resets that I have not seen discussed (or
I have missed the discussion). The drivers can set the mode parameters
they know about. However, in some cases there may be some parameters set
by a user space program. Should the reset cause a hotplug event or
soemthing similar?

	Kai


