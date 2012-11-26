From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 26 Nov 2012 23:15:54 +0400
Message-ID: <1353957354.2681.6.camel@dabdike>
References: <Pine.LNX.4.44L0.1211261120190.2168-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1211261120190.2168-100000@iolanthe.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-11-26 at 11:21 -0500, Alan Stern wrote:
> On Mon, 26 Nov 2012, James Bottomley wrote:
> 
> > I'm also curious about driving sleep from autopm, since mode page timers
> > don't control the sleep transition.
> 
> Is it feasible to do this the other way around?  That is, to drive 
> runtime suspend by noticing when the device decides to put itself into 
> a low-power state?

Well, yes and no.  The spec is annoyingly (and deliberately) vague about
what the states actually mean.  The two states that the devices go into
because of timers is idle and standby.  The supposedly deeper low power
state of sleep can only be reached by sending a command to the device.
The design is that software (or HBA drivers) don't really need to notice
idle and standby; the device automatically manages transitions between
them depending on command activity.  For sleep, we do have to care (if
it actually makes some meaningful difference).

James


