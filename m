From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Thu, 14 Jun 2007 13:56:00 +0200
Message-ID: <20070614115600.GF6149@kernel.dk>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E1D51.9070007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <466E1D51.9070007@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 12 2007, Tejun Heo wrote:
> Arjan van de Ven wrote:
> >> I'm not sure about this.  We need better PM framework to support 
> >> powersaving in other controllers and some ahcis don't save much
> >> when only link power management is used,
> > 
> > do you have data to support this?
> 
> Yeah, it was some Lenovo notebook.  Pavel is more familiar with the
> hardware.  Pavel, what was the notebook which didn't save much power
> with standard SATA power save but needed port to be completely turned off?
> 
> > The data we have from this patch is that it saves typically a Watt of
> > power (depends on the machine of course, but the range is 0.5W to
> > 1.5W). If you want to also have an even more agressive thing where
> > you want to start disabling the entire controller... I don't see how
> > this is in conflict with saving power on the link level by "just"
> > enabling a hardware feature ....
> 
> Well, both implement about the same thing.  I prefer software
> implementation because it's more generic and ALPE/ASP seems too
> aggressive to me.  Here are reasons why sw implementation wasn't merged.
> 
> 1. It didn't have proper interface with userland.  This was mainly
> because of missing ATA sysfs nodes.  I'm not sure whether adding this to
> scsi node is a good idea.
> 
> 2. It was focused on SATA link PS and couldn't cover the Lenovo case.
> 
> I think we need something at the block layer.

I think the hardware method is preferable, actually. Doing this in the
block layer would mean keeping track of idle time, and that quickly
turns into a lot of timer management. Not exactly free, in terms of CPU
usage.

I've yet to do some power measurements with this ahci patch, I just
noticed that with min_power performance drops from ~55mb/sec to
~15mb/sec sequential on my drive. That's pretty drastic :-)

-- 
Jens Axboe

