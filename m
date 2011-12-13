From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v5 5/6] ata: add ata port system PM callbacks
Date: Tue, 13 Dec 2011 10:47:49 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1112131038360.1888-100000@iolanthe.rowland.org>
References: <1323786040.3769.24.camel@hp6530s>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323786040.3769.24.camel@hp6530s>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 13 Dec 2011, Lin Ming wrote:

> I just realized that the ata port runtime PM status need to be updated
> after system resume.
> 
> I tried below patch.
> Unfortunately, it causes a problem that sd can't resume correctly.
> 
> During system resume, ata port is resumed first and then sd resumed.
> 
> When ata port resumed, device_resume(...) calls pm_runtime_put_sync(..),
> which causes ata port to be runtime suspended immediately.
> 
> So sd resume fails because it requires ata port to be active to handle
> start device command.
> 
> This seems a PM core's bug.
> 
> device_resume(...) should not runtime suspend the parent device, because
> its children have not resumed yet.
> 
> Alan, 
> 
> What do you think?

This appears to be the first time this problem has come up.  But it is 
a real problem.

If a child device was runtime-suspended when a system suspend began, 
then there will be nothing to prevent its parent from 
runtime-suspending as soon as it is woken up during the system resume.  
Then when the time comes to resume the child, the resume will fail 
because the parent is already back at low power.

On the other hand, there are some devices which should remain at low 
power across an entire suspend-resume cycle.  The details depend on the 
device and the platform.

This suggests that the PM core is not the right place to solve the 
problem.  One possible solution is for the subsystem or device driver 
to call pm_runtime_get_sync(dev->parent) at the start of the 
system-resume procedure and pm_runtime_put_sync(dev->parent) at the 
end.

Alan Stern
