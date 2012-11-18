From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Sun, 18 Nov 2012 12:41:06 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1211181221350.4991-100000@netrider.rowland.org>
References: <20121118150555.GL7306@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121118150555.GL7306@mtj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 18 Nov 2012, Tejun Heo wrote:

> Hello, Alan.

Hi.

> On Mon, Nov 12, 2012 at 02:34:01PM -0500, Alan Stern wrote:
> > It wouldn't do anything for the device, but it would allow the device's
> > parent to go to low power in between polls.  That's why Aaron at one
> > point suggested lengthening the polling interval.
> 
> Ah, okay.  Entering and leaving suspend even every two seconds may
> save noticeable power for some controllers.  Does that, tho, mean that
> the port would get reset every two seconds?

I don't know how suspend works for (S)ATA ports.  For USB mass storage, 
suspend/resume does not involve any resets unless something goes wrong.

>  If so (I can't see how
> else it would behave), it may not really work.  I mean, you would be
> spending about ten seconds reinitiaizing everything and then enter
> sleep and do it all over again two seconds later, most likely wasting
> power in the process.  Sounds weird to me.  What am I missing?

Does it really take 10 seconds to recover from an ATA suspend?  That 
sounds awfully long.

The two second value is merely the default interval for media polling.  
Devices with no async notification mechanism require some sort of
polling if anybody wants to know when media is inserted or removed,
and the polling can't be carried out if the device's port is suspended.

You asked about autopm.  "Autopm" is a rather vague and ugly term I
made up; it means that the kernel automatically suspends the device
after some specified idle time.  In the case of optical drives, "idle"  
currently means the device file is not open (which implies the drive
doesn't contain a mounted filesystem).  As far as I know, the kernel
has no direct way to affect the power level of an optical drive that
isn't ZP.  For these devices "suspended" is merely a logical state,
meaning that the device isn't in use and therefore its parent can be
put into a low-power mode.

Regardless, an optical drive can't remain suspended when polling
occurs.  So unless there's some other mechanism for getting the
information about media changes, suspended drives (and their parents)  
will have to be resumed periodically for polling.

Hence there's a tradeoff.  How can we use the minimum amount of energy
while still polling the drive acceptably often?  In general, the kernel
doesn't know.  That's why these things can be controlled from
userspace.  And the answer may be different for ATA drives vs.  
USB-connected drives.

Does this answer your questions?

Alan Stern

