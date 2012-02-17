From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Fri, 17 Feb 2012 10:07:42 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202171003060.1350-100000@iolanthe.rowland.org>
References: <744357E9AAD1214791ACBA4B0B90926305BFDC@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926305BFDC@SHSMSX101.ccr.corp.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Lin, Ming M" <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 17 Feb 2012, Zhang, Rui wrote:

> > Do you basically want
> > the ZPODD always to be suspended and resumed along with the ATA port,
> 
> No. ZPODD suspends itself, which put ZPODD to a SCSI low power state (NOT power off/D3_COLD).
> And then it is the "Runtime PM core" that suspends ATA port after ZPODD being suspended.
> And the .runtime_suspend callback for ATA port actually turns off the ZPODD power.
> 
> During resume, ATA port is resumed first because of the ACPI wakeup event. 
> But in fact, this wakeup event should be read as "ZPODD remote wakeup signal", thus runtime resume request is sent to ZPODD, done by Patch 3/6.
> 
> > or should it be possible to suspend the ZPODD while the port remains
> > running?
> > 
> Sure, but the power is still on at this time.

Then maybe you can use pm_runtime_no_callbacks() for the ZPODD device.  
It's explained in Documentation/power/runtime_pm.txt, and I use it for 
USB interfaces.

The idea is that the ZPODD will never receive any runtime PM callbacks 
from the PM core.  Instead the ATA port callback routines will be 
responsible for power management of the ZPODD device.

Alan Stern

