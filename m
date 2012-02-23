From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Thu, 23 Feb 2012 13:10:14 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202231306340.1671-100000@iolanthe.rowland.org>
References: <1330004496.2469.3.camel@hp6530s>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1330004496.2469.3.camel@hp6530s>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 23 Feb 2012, Lin Ming wrote:

> > > For example,
> > > /sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0:0/1:0:0:0/
> > > 
> > > ata0 is resumed.
> > > 
> > > Then who will be responsible to resume host1, target1:0:0 and 1:0:0:0?
> > > 
> > > Or do you mean that we don't need to resume these devices at all?
> > > host1 and target1:0:0 are logical devices, but I think 1:0:0:0 is not.
> > 
> > That's right.  It makes no difference whether the host and target 
> > are resumed or suspended.  In fact, you could also call 
> > pm_runtime_no_callbacks() for them.
> 
> But host and target are added in scsi layer. How do we know if they are
> "logical device"?

Those data structures may be created by the SCSI layer, but you know
that the hardware is all controlled by the ATA layer.  Therefore you
know there is no physical hardware corresponding to the host or target
device.

> Or do you mean that we can call pm_runtime_no_callbacks() for them
> because scsi layer(scsi_pm.c) only implements runtime pm for scsi
> device.

That's right.  And you know why?  It's because the SCSI host and target
do not refer to power-manageable hardware.

Alan Stern

