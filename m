From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Mon, 21 Jan 2013 16:04:17 +0800
Message-ID: <20130121080417.GA6904@aaronlu.sh.intel.com>
References: <50FA5F67.4080102@intel.com>
 <Pine.LNX.4.44L0.1301191312050.13032-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301191312050.13032-100000@netrider.rowland.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 19, 2013 at 01:46:15PM -0500, Alan Stern wrote:
> On Sat, 19 Jan 2013, Aaron Lu wrote:
> 
> > > What happens if you're not running a desktop graphical environment, so
> > > gvfs doesn't mount the disc?  Basically, I'm worried that the drive may
> > > remain suspended after sr_open() returns.
> > 
> > Tried on my notebook with a normal ODD, using mplayer under console
> > mode, no GUI environment running, works fine.
> > 
> > The usage count will be incremented by the app, and get decreased
> > only when it exits. So the ODD will not be in runtime suspended state
> > when the app is running.
> 
> You missed my point.  What happens when sr_open() gets called?  It 
> doesn't try to resume the device.  Will we run into trouble then?

Oh yes, you mean the cdo->open gets called without going through sr's
block interface.

I just checked the code, it looks to me the cdrom interface code is the
code common to cdrom functionality, to be used by various underlying
block drivers like sr, ide-cd, etc. All the code cdrom.c has provided
requires a cdi parameter, which can only be provided by the underlying
block driver, so I don't think those cdrom_device_ops functions will be
called without going through the block drivers' interface.

But the functions defined in block_device_operations by sr can be called
by other kernel components as long as they have access to the gendisk
structure of the block device, so I'll add get/sync pair to all those
functions(i.e. sr_block_revalidate_disk, sr_block_ioctl in addition to
the open/release/check_events calls).

> 
> > > What happens if you use a program other than rhythmbox?  There are (or
> > > used to be) programs which would issue the PLAY AUDIO command and then
> > > exit.  The drive would continue playing even while the device file was
> > 
> > Then we indeed have a problem. But I didn't find any such app in
> > Fedora's repo or by searching the internet.
> 
> http://rpm.pbone.net/index.php3/stat/4/idpl/2392183/dir/redhat_5.x/com/cdp-0.33-10.i386.rpm.html
> 
> > > closed.  Do we want to drop support for that kind of behavior?
> > 
> > I don't think we should drop such support.
> > And the safest way to avoid such break is we refine the suspend
> > condition for ODD, and using what ZPODD defined condition isn't that
> > bad to me:
> > - for tray type, no media inside and tray close;
> > - for slot type, no media inside.
> > While whether tray is closed or not may not be that important, but at
> > least we should make sure there is no media inside.
> > 
> > Thoughts?
> 
> That sounds reasonable to me, at least as a first step.  If people want 
> their CD drive to suspend, they can eject the disc.

I'm gonna add the cd->media_present check in sr's runtime suspend
callback, if sr thinks there is media inside, suspend will not proceed.

Thanks,
Aaron

