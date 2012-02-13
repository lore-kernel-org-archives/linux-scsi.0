From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Mon, 13 Feb 2012 21:50:41 +0100
Message-ID: <201202132150.42115.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202131534040.11382-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1202131534040.11382-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday, February 13, 2012, Alan Stern wrote:
> On Mon, 13 Feb 2012, Rafael J. Wysocki wrote:
> 
> > > I'm not sure if this is really the right approach.  What you're trying 
> > > to do is implement two different low-power states, basically D3hot and 
> > > D3cold.  Currently the runtime PM core doesn't support such things; all 
> > > it knows about is low power and full power.
> > 
> > I'd rather say all it knows about is "suspended" and "active", which mean
> > "the device is not processing I/O" and "the device may be processing I/O",
> > respectively.  A "suspended" device may or may not be in a low-power state,
> > but the runtime PM core doesn't care about that.
> 
> Yes, okay.  We can say that this patch tries to implement two different 
> "suspended" states, basically "low power" and "power off" (or D3hot and 
> D3cold).
> 
> > > Before doing an ad-hoc implementation, it would be best to step back
> > > and think about other subsystems.  Other sorts of devices may well have
> > > multiple low-power states.  What's the best way for this to be
> > > supported by the PM core?
> > 
> > Well, I honestly don't think there's any way they all can be covered at the
> > same time and that's why we chose to support only "suspended" and "active"
> > as defined above.  The handling of multiple low-power states must be
> > implemented outside of the runtime PM core (like in the PCI core, for example).
> 
> That's the point.  If this is to be implemented outside of the runtime
> PM core, should the patch be allowed to add new fields to struct
> dev_pm_info (which has to be shared among all subsystems)?
> 
> Or to put it another way, if we do add new fields to struct dev_pm_info
> (like can_power_off) in order to help support multiple "suspended"  
> states, shouldn't these new fields be such that they can be used by
> many different subsystems rather than being special for the
> full-power/no-power situation?
> 
> Likewise, should new routines like pm_runtime_allow_power_off() be
> added to the runtime PM core if they are going to be used just by PCI?

No, they shouldn't.

Thanks,
Rafael
