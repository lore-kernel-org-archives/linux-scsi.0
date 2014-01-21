From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Disk spin-up optimization during system resume
Date: Tue, 21 Jan 2014 10:44:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401211042250.1272-100000@iolanthe.rowland.org>
References: <CAPcyv4iZ4Qfzd2tZUOSbz9bGUqfzOD3zamFw6gip4ceB3=SK+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56840 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754261AbaAUPon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2014 10:44:43 -0500
In-Reply-To: <CAPcyv4iZ4Qfzd2tZUOSbz9bGUqfzOD3zamFw6gip4ceB3=SK+Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Phillip Susi <psusi@ubuntu.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 21 Jan 2014, Dan Williams wrote:

> On Sat, Jan 18, 2014 at 6:08 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Fri, 17 Jan 2014, Dan Williams wrote:
> >
> >> I think it's a bit of an interface surprise to have pm_runtime disable
> >> have side effects only for scsi_disk devices.  I think lazy_resume
> >> needs to be an explicit attribute of the disk.  For ata devices any
> >> command wakes up the drive.  Perhaps we could simply do the same for
> >> scsi devices.  In lazy_resume mode flag the device as "needs spinup"
> >> at sd_resume time and schedule it when a command arrives.
> >
> > What you have just described is essentially what runtime PM does.
> 
> Deliberately so...
> 
> > There's no need to implement it any other way.  And this explains why
> > disabling runtime PM would also disable lazy resume.
> 
> The need is to avoid tying rpm and dpm ops together in surprising new
> ways that require userspace to change if it wants to keep the default
> behavior of hiding resume latency as much as possible.  A lazy_resume
> knob vs changing the default let's the few setups that care set the
> power-up in standby mode.

That's why I proposed it.  What are you getting at?

>  It should also "perform" better given it
> does not require the disk to be runtime suspended prior to system
> suspend, it will unconditionally resume on demand.

None of my posts in this email thread have required the disk to be in 
runtime suspend prior to the system suspend.

Alan Stern

