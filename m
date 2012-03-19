From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v2 5/8] libata-acpi: add ata port runtime D3Cold
 support
Date: Mon, 19 Mar 2012 15:03:40 +0800
Message-ID: <1332140620.17875.35.camel@minggr>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
	 <1330592577-16546-6-git-send-email-ming.m.lin@intel.com>
	 <20120319033616.GA32695@localhost.amd.com>
	 <1332134820.17875.17.camel@minggr>
	 <20120319063544.GA2707@localhost.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17152 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab2CSHDr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2012 03:03:47 -0400
In-Reply-To: <20120319063544.GA2707@localhost.amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>

On Mon, 2012-03-19 at 14:35 +0800, Aaron Lu wrote:
> Hi,
> 
> On Mon, Mar 19, 2012 at 01:27:00PM +0800, Lin Ming wrote:
> > On Mon, 2012-03-19 at 11:36 +0800, Aaron Lu wrote:
> > > Hi,
> > > 
> > > On Thu, Mar 01, 2012 at 05:02:54PM +0800, Lin Ming wrote:
> > > > ATA port may support runtime D3Cold state, for example, Zero-power ODD case.
> > > > This patch adds wakeup notifier and enable/disable run_wake during
> > > > supend/resume.
> > > 
> > > I've been thinking this for some time and realized that it would be
> > > impossible for AMD's platform to work with this patch, the reason:
> > > There is no _PRW in AMD's acpi implementation. And no _PRW would mean
> > > the device is not wake up capable in current Linux ACPI implementation.
> > > 
> > > I've checked the ACPI spec and it said: 'the _PRW is only required for
> > > devices that have the ability to wake the system from a system sleeping
> > > state.'
> > > So I'm not sure if _PRW fits here, since the most common use case for
> > > zpodd would be: odd put to D3 cold and system is at S0, and odd is back
> > > to D0 when necessary without affecting the system sleep state.
> > > 
> > > I suggest we install the acpi pm notifier on the handle based on the
> > > following two criteria:
> > > 1 This ata device is DA capable;
> > > 2 Its acpi device indicates it is able to wake up itself in S0(_S0W
> > > evaluates 4).
> > 
> > OK, reasonable to me.
> > 
> > > 
> > > Does this make sense and will this work for your platform?
> > 
> > Yes.
> > 
> 
> Great ;-)
> 
> > > 
> > > Another problem is how to place this ODD device into D3 cold state,
> > > since our platform uses _PS3 control method to power off it. Do you have
> > > any suggestions?
> > 
> > acpi_bus_set_power will execute _PS3 too.
> > 
> > So I think no problem for AMD's platform.
> > 
> 
> Sorry I didn't make it clear.
> The problem here is, we are going to set the device power state to D3
> cold, and current OSPM has no support for it.
> 
> Another patch of yours solved this problem by defining:
> 1 Device supports D3 cold if it has _PR3;
> 2 For a device to be put to D3 cold, power off all the power resources
> referenced in its _PR3.
> 
> Since this can't work for AMD's platform(there is no _PR3 for the sata
> acpi device), I would like to change this a little bit:
> 1 Device supports D3 cold if it has _PR3 or _PS3;

_PS3 may only mean D3Hot support for other device.

You mentioned that AMD platform defined a special device, named ODDZ.

How about device supports D3 cold if

_PR3 or (is ODDZ and ODDZ._PS3)?

> 2 For a device to be put to D3 cold, execute _PS3 first if available and
> then deal with _PR3 as above.

__acpi_bus_set_power(...) has done this.


> 
> What do you think of this?
> If you are OK to the above idea, I can change the corresponding patch for
> you to review.

OK.

Thanks,
Lin Ming

> 
> Thanks,
> Aaron
> 
> 


