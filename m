From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
Date: Thu, 3 Nov 2011 10:22:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1111031019250.2136-100000@iolanthe.rowland.org>
References: <1320325700.2813.61.camel@hp6530s>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1320325700.2813.61.camel@hp6530s>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@Parallels.com>, Tejun Heo <tj@kernel.org>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 3 Nov 2011, Lin Ming wrote:

> I realize that this is not the natural way to do ata port runtime pm.
> Hooking it to scsi host runtime pm is not good. It does not deal with
> the races with system suspend/resume of host controller.
> 
> How about making ata port as the parent device of scsi host?
> Then, for example, the runtime suspend happens as below,
> 
> disk suspend --> scsi target suspend --> scsi host suspend --> ata port
> suspend.
> 
> Current device tree is:
> /sys/devices/pci0000:00/0000:00:1f.2/
> |-- ata1
> |-- host0
> 
> After the change, the tree will become as:
> /sys/devices/pci0000:00/0000:00:1f.2/ata1/
> |-- host0

I don't know enough about the ATA subsystem to say much, except that 
this looks more logical.

> The tricky part is ata port(parent device) suspend need to schedule scsi
> EH which will resume scsi host(child device). Then the child device
> resume will in turn make parent device resume first. This is kind of
> recursive.
> 
> We can fix this by adding a flag somewhere to tell scsi EH don't resume
> the host in ata port pm request handling case.
> 
> What do you think?

Yes, it is a problem.  But it looks like the underlying issue is that
you're using the SCSI error handler to do something it was not intended
for.  Can't you suspend and resume the ATA port without using the error
handler?

Alan Stern

