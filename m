From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH] scsi: sr: support runtime pm
Date: Tue, 22 Jan 2013 10:27:23 +0800
Message-ID: <20130122022723.GB20211@aaronlu.sh.intel.com>
References: <20130121093707.GB11010@aaronlu.sh.intel.com>
 <Pine.LNX.4.44L0.1301211157530.19920-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301211157530.19920-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, Julian Calaby <julian.calaby@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 21, 2013 at 11:59:06AM -0500, Alan Stern wrote:
> On Mon, 21 Jan 2013, Aaron Lu wrote:
> 
> > On Sat, Jan 19, 2013 at 01:46:15PM -0500, Alan Stern wrote:
> > > On Sat, 19 Jan 2013, Aaron Lu wrote:
> > > > I don't think we should drop such support.
> > > > And the safest way to avoid such break is we refine the suspend
> > > > condition for ODD, and using what ZPODD defined condition isn't that
> > > > bad to me:
> > > > - for tray type, no media inside and tray close;
> > > > - for slot type, no media inside.
> > > > While whether tray is closed or not may not be that important, but at
> > > > least we should make sure there is no media inside.
> > > > 
> > > > Thoughts?
> > > 
> > > That sounds reasonable to me, at least as a first step.  If people want 
> > > their CD drive to suspend, they can eject the disc.
> > 
> > Here is an updated patch to address the problem, please review, thanks.
> > 
> > Changes to v13:
> > - Add PM get/put pair functions to all the block device operation
> >   functions; Move the existing PM get/put pair functions in
> >   sr_check_events to sr_block_check_events;
> > - Add sr_runtime_suspend, it will check if there is media inside and if
> >   yes, avoid suspend.
> > 
> > From 378bf55810a1118ede481f45132b5c39af891d23 Mon Sep 17 00:00:00 2001
> > From: Aaron Lu <aaron.lu@intel.com>
> > Date: Wed, 26 Sep 2012 15:14:56 +0800
> > Subject: [RFC PATCH] scsi: sr: support runtime pm
> > 
> > This patch adds runtime pm support for sr.
> > 
> > It did this by increasing the runtime usage_count of the device when
> > its block device is accessed. And decreasing the runtime usage_count
> > of the device when the access is done.
> > 
> > The idea is discussed here:
> > http://thread.gmane.org/gmane.linux.acpi.devel/55243/focus=52703
> > and here:
> > http://thread.gmane.org/gmane.linux.ide/53665/focus=58836
> > 
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> 
> This looks good now.  When you submit the patch, you might want to 
> mention the restriction about no media being present in the changelog 
> entry.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 

Will add that in the changelog, thanks a lot for your kind help.

-Aaron

