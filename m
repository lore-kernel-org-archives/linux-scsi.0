From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Fri, 14 Sep 2012 09:17:20 +0100
Message-ID: <1347610640.2794.11.camel@dabdike.int.hansenpartnership.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120914052041.GA5177@mint-spring.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-09-14 at 13:20 +0800, Aaron Lu wrote:
> On Thu, Sep 13, 2012 at 10:26:44AM +0100, James Bottomley wrote:
> > On Thu, 2012-09-13 at 17:07 +0800, Aaron Lu wrote:
> > > So I think this is basically 2 things, one is the runtime suspend of the
> > > disk, another is when it is runtime suspended, how to remove its power.
> > > I'm currently doing the latter one, which is simpler, so I want to do it
> > > first :-)
> > 
> > Well, I don't like the way the interaction of the patches is going.
> > You're the one proposing powering down the device outside of the
> > standards defined transitions, so you need to be responsible for the
> > actions that necessitates, including synchronizing the cache. The specs
> 
> OK, I'll update the code.
> 
> > (SPC-4) say that cache management is explicitly unnecessary for the
> > standard SCSI power states (Active, Idle, Standby and Stopped), so
> 
> Just read the SPC-4 spec, in section 5.12.3, it has words like this:
> 
> Logical units that contain cache memory shall write all cached data to
> the medium for the logical unit(e.g., as a logical unit would do in
> response to a SYNCHRONIZE CACHE command as described SBC-3) prior to
> entering into any power condition that prevents accessing the
> media(e.g., before a hard drive stops its spindle motor during a change
> to the standby power condition).
> 
> So this looks like cache needs to be synced before the device enter
> standby/stopped power condition. Or do I miss somthing?

Um, no it says the device shall do the sync on its own (as though it
received a sync cache).  That section says the device shall be
responsible for cache management in the power states.

> > someone at some point is going to read that and remove the unnecessary
> > cache sync in the code.  When that happens, you'll start getting data
> > loss.
> 
> Indeed, I'll make sure cache gets synced when we are to power off the
> device. Thanks for the remind.

Great, thanks.

James


