From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Fri, 14 Sep 2012 11:26:29 +0100
Message-ID: <1347618389.2450.5.camel@dabdike.int.hansenpartnership.com>
References: <1347522049-1836-1-git-send-email-aaron.lu@intel.com>
	  <1347522049-1836-2-git-send-email-aaron.lu@intel.com>
	  <1347524092.2720.1.camel@dabdike.int.hansenpartnership.com>
	  <50519801.6080502@intel.com>
	  <1347525466.2720.10.camel@dabdike.int.hansenpartnership.com>
	  <50519E08.10800@intel.com>
	  <1347526590.2720.15.camel@dabdike.int.hansenpartnership.com>
	  <5051A25F.7040704@intel.com>
	  <1347528404.2720.28.camel@dabdike.int.hansenpartnership.com>
	  <20120914052041.GA5177@mint-spring.sh.intel.com>
	 <1347610640.2794.11.camel@dabdike.int.hansenpartnership.com>
	 <5052EF5F.3000103@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <5052EF5F.3000103@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-09-14 at 16:48 +0800, Aaron Lu wrote:
> On 09/14/2012 04:17 PM, James Bottomley wrote:
> >> Just read the SPC-4 spec, in section 5.12.3, it has words like this:
> >>
> >> Logical units that contain cache memory shall write all cached data to
> >> the medium for the logical unit(e.g., as a logical unit would do in
> >> response to a SYNCHRONIZE CACHE command as described SBC-3) prior to
> >> entering into any power condition that prevents accessing the
> >> media(e.g., before a hard drive stops its spindle motor during a change
> >> to the standby power condition).
> >>
> >> So this looks like cache needs to be synced before the device enter
> >> standby/stopped power condition. Or do I miss somthing?
> > 
> > Um, no it says the device shall do the sync on its own (as though it
> > received a sync cache).  That section says the device shall be
> > responsible for cache management in the power states.
> 
> Oh, I thought it was the host software's responsibility, thanks for the
> explanation.
> 
> So if we program the device to let it enter standby/stopped power
> condition with the start_stop_unit command, do we need to sync the
> cache?

No, that's what the spec says.  The device must manage the cache in both
the forced (start stop unit) and timed (power control mode page) cases.

The reason is the spec doesn't define what idle and standby actually
mean (just that they're "lower" power states).  So the device
implementers get to choose if they stop the platter or power off the
motor.  The spec just means that if they do anything that causes danger
to data in the cache, they have to deal with it themselves.

James


