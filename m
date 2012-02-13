From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Mon, 13 Feb 2012 10:01:54 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org>
References: <1329124271-29464-5-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329124271-29464-5-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 13 Feb 2012, Lin Ming wrote:

> From: Zhang Rui <rui.zhang@intel.com>
> 
> Introduce flag can_power_off in device structure to support runtime
> power off/on.
> 
> Note that, for a specific device driver,
> "support runtime power off/on" means that the driver .runtime_suspend
> callback needs to
> 1) save all the context so that it can restore the device back to the previous
>    working state after powered on.
> 2) set can_power_off flag to tell the driver model that it's ready for power off.
> 
> The following example shows how this works.
> 
> device A
>  |---------|
>  v         v
> device B  device C
> 
> A is the parent of device B and device C, and device A/B/C shares the
> same power logic
> (Only device A knows how to turn on/off the power).
> 
> In order to power off A, B, C at runtime,
> 1) device B and device C should support runtime power off
>    (runtime suspended with can_power_off flag set)
> 2) pm idle request for device A is fired by runtime PM core.
> 3) in device A .runtime_suspend callback, it tries to set can_power_off flag.
> 4) if succeed, it means all its children have been ready for power off
>    and it can turn off the power at any time.
> 5) if failed, it means at least one of its children does not support runtime
>    power off, thus the power can not be turned off.

I'm not sure if this is really the right approach.  What you're trying 
to do is implement two different low-power states, basically D3hot and 
D3cold.  Currently the runtime PM core doesn't support such things; all 
it knows about is low power and full power.

Before doing an ad-hoc implementation, it would be best to step back
and think about other subsystems.  Other sorts of devices may well have
multiple low-power states.  What's the best way for this to be
supported by the PM core?

Alan Stern

