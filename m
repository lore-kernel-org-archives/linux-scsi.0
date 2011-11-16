From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 4/4] ata: add ata port runtime PM callbacks
Date: Wed, 16 Nov 2011 10:42:11 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1111161038360.2086-100000@iolanthe.rowland.org>
References: <1321449252.2565.2.camel@hp6530s>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1321449252.2565.2.camel@hp6530s>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 16 Nov 2011, Lin Ming wrote:

> > > Something to be careful about is there are different types of suspend
> > > states (PMSG_*).  IIUC, runtime PM is using PMSG_SUSPEND.  Other
> > > states may or may not be compatible with PMSG_SUSPEND expectations, so
> > > you can skip suspend operation if the newly requested state is
> > > PMSG_SUSPEND but otherwise the controller needs to be woken up and
> > > told to comply to the new state.
> > 
> > That's right.  Surprisingly enough (and contrary to what I wrote
> > earlier), the sd_suspend() routine doesn't spin down a drive for
> > runtime suspend.  This probably should be considered a bug.
> > 
> > Anyway, it looks like the correct approach would be more like this:
> 
> Thanks.
> 
> I think ata_port_suspend also needs to call pm_runtime_resume, as below.
> 
> static int ata_port_suspend(struct device *dev)
> {
>         struct ata_port *ap = to_ata_port(dev);
>         int rc;
> 
>         pm_runtime_resume(dev);
>         rc = ata_port_request_pm(ap, PMSG_SUSPEND, 0, ATA_EHI_QUIET, 1);
>         return rc;
> }

Maybe not.  You know a lot more about the state of the ATA ports than
you do about the state of the SCSI devices.  If there's no difference
in the port states for runtime suspend and system sleep then you don't
have to power up the port just in order to power it down again.

Alan Stern

