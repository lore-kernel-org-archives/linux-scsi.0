From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: RE: [PATCH v2 2/2] Adds new device resume mode in PM core, async
 plus non-blocking
Date: Mon, 3 Jun 2013 21:10:28 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A1706057ED@FMSMSX103.amr.corp.intel.com>
References: <11E08D716F0541429B7042699DD5C1A16B97BD8A@FMSMSX103.amr.corp.intel.com>,<Pine.LNX.4.44L0.1305171539470.1012-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1305171539470.1012-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Thanks for the feedback, I've taken things back to the drawing board in lieu of these issues and will be resubmitting once I have a patch that fits better into the formal power management architecture. Would you like to be CC'ed?

Todd Brandt
Linux Kernel Developer OTC, Hillsboro OR
https://opensource.intel.com/linux-wiki/ToddBrandt


________________________________________
From: Alan Stern [stern@rowland.harvard.edu]
Sent: Friday, May 17, 2013 12:44 PM
To: Brandt, Todd E
Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org; linux-pm@vger.kernel.org; Jeff Garzik; Jens Axboe; Greg Kroah-Hartman; Wysocki, Rafael J; Arjan van de Ven
Subject: Re: [PATCH v2 2/2] Adds new device resume mode in PM core, async plus non-blocking

On Fri, 17 May 2013, Brandt, Todd E wrote:

> Updates the drivers/base/power subsystem to allow any devices which
> have registred as asynchronous and who have not registered "complete"
> callbacks to be non-blocking. i.e system resume can finish and return
> control to the user while these devices continue resuming.

This does not sound like a good idea.  The presence or absence of a
"complete" callback has nothing to do with whether or not system resume
can finish before the device is ready.  It is more closely related to
whether the device's driver can register hot-plugged children below the
device or needs to perform other actions after the children have been
resumed.

The whole approach seems wrong -- it violates the implicit agreement
that the kernel will not try to perform I/O through a device that isn't
at full power.

A better approach would be to modify the SCSI disk driver to carry out
the spin-up operation asynchronously with respect to the resume
callback.  Then the disk could be reported as back to full power while
the spin-up is taking place.

Alan Stern

