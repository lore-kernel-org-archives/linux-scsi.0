From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Tue, 11 Sep 2012 14:10:18 +0200
Message-ID: <3491742.cmOxhNregO@linux-lqwf.site>
References: <Pine.LNX.4.44L0.1209061437050.1182-100000@iolanthe.rowland.org> <1545884.X9DCxzsAFq@linux-lqwf.site> <20120911111107.GA20361@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120911111107.GA20361@mint-spring.sh.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 11 September 2012 19:11:08 Aaron Lu wrote:
> On Tue, Sep 11, 2012 at 11:30:35AM +0200, Oliver Neukum wrote:
> > On Tuesday 11 September 2012 17:24:13 Aaron Lu wrote:

> > Yes, but because the whole system had been suspended.
> > In that case you can have a locked door.
> 
> By locked, do you mean the door is closed or the door is locked by the
> sr_lock_door function with param lock set to 1?

sr_lock_door()

> > That need not be the case. What happens if the door button is pressed while
> > the system is resuming?
> 
> In that case, if the hardware logic is ready, an ACPI event will fire
> and the device will be runtime resumed; if the hardware logic is not
> ready yet due to the system is resuming, nothing happens.

So we have this race:

sr_lock_door()
system goes to S3
system starts resuming from S3
user presses door button
sr_resume()
door opens

I guess this should not happen.

	Regards
		Oliver

