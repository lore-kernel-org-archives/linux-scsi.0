From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 19 Nov 2012 06:56:05 -0800
Message-ID: <20121119145605.GC15971@htj.dyndns.org>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <1352443922-13734-7-git-send-email-aaron.lu@intel.com>
 <20121112191303.GE5560@mtj.dyndns.org>
 <50A2FF6F.3080603@intel.com>
 <20121118150004.GJ7306@mtj.dyndns.org>
 <50A9A2F4.3020006@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50A9A2F4.3020006@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey, Aaron.

On Mon, Nov 19, 2012 at 11:09:40AM +0800, Aaron Lu wrote:
> > What I'm confused about is what autopm does for devices w/o zpodd.
> > What happens then?  Is it gonna leave power on for the device and,
> > say, go on to suspend the controller?  But, how would that work for,
> > say, future devices with async notification for media events?
> 
> Maybe we shouldn't allow autopm for such devices?

Yeah, maybe.  It would be nice to be able to automatically power off
disks and ports which aren't being used tho.

> > That said, I can't say the snooping is pretty.  It's a rather nasty
> > thing to do.  So, libata now wants information from the event polling
> > in block layer, but reaching for block_device from ata_devices is
> > nasty too.  Hmmm... but aren't you already doing that to block polling
> > on a powered down device?
> 
> I was feeling brain damaged by this for some time :-)
> 
> Basically, only ATA layer is aware of the power off thing, and sr knows
> nothing about this(or it is not supposed to know this, at least, this is
> what SCSI people think) and once powered off, I do not want the poll to
> disturb the device, so I need to block the poll. I can't come up with
> another way to achieve this except this nasty way.
> 
> James suggests me to keep the poll, but emulate the command. The problem
> with this is, the autopm for resume will kick in on each poll, so I'll
> need to decide if power up the ODD for this time's resume is needed in
> port's runtime resume callback. This made things complex and it also put
> too much logic in the resume callback, which is not desired. And even if
> I keep the ODD in powered off state by emulating this poll command, its
> ancestor devices will still be resumed, and I may need to do some trick
> in their resume callback to avoid needless power/state transitions. This
> doesn't feel like an elegant way to solve this either.
> 
> So yes, I'm still using this _nasty_ way to make the ODD stay in powered
> off state as long as possible. But if there is other elegant ways to
> solve this, I would appreciate it and happily using it. Personally, I
> hope we can make sr aware of ZPODD, that would make the pain gone.

I really think we need a way for (auto)pm and event polling to talk to
each other so that autopm can tell event poll to sod off while pm is
in effect.  Trying to solve this from inside libata doesn't seem
right.  The problem, again, seems to be figuring out which hardware
device maps to which block device.  Hmmm... Any good ideas?

Thanks.

-- 
tejun
