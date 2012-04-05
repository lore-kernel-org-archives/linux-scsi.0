From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Thu, 5 Apr 2012 10:03:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204051000450.1361-100000@iolanthe.rowland.org>
References: <20120405083245.GA19508@localhost.amd.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120405083245.GA19508@localhost.amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 5 Apr 2012, Aaron Lu wrote:

> Hi,
> 
> On Thu, Apr 05, 2012 at 02:00:57PM +0800, Lin Ming wrote:
> > >
> > > Another thing to consider is, user might want to eject the tray by
> > > software like the
> > > eject /dev/sr0 command or some UI mouse clicks against the cdrom icon. I'm still
> > > thinking how to do this correctly.
> > 
> > Assume eject /dev/sr0 is implemented as:
> > 
> > int fd = open("/dev/sr0", ...)
> > ioctl(fd, CDROMEJECT)
> > 
> 
> Indeed, it is implemented as this :-)
> 
> > We may need to resume ODD in the ioctl handler(scsi_cmd_ioctl).
> > 
> 
> I prefer we do this in sr_block_ioctl.
> Suppose the ODD is now runtime suspended and received an ioctl:
> if the ioctl's cmd is CDROMEJECT, resume it.
> For other cases, return an error code like EPERM.
> When done, according to the result of ioctl: if success, leave it resumed;
> if failed, put it back to sleep.

Alternatively, you may want to do the runtime resume in sr_open and 
sr_block_open and the suspend in the corresponding release routines.  
It's up to you.

Alan Stern

