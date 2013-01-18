From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Fri, 18 Jan 2013 15:42:40 +0800
Message-ID: <20130118074240.GA6861@aaronlu.sh.intel.com>
References: <1358351148.2384.34.camel@dabdike.int.hansenpartnership.com>
 <Pine.LNX.4.44L0.1301161127540.1704-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301161127540.1704-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 16, 2013 at 11:31:31AM -0500, Alan Stern wrote:
> On Wed, 16 Jan 2013, James Bottomley wrote:
> 
> > On Tue, 2013-01-15 at 17:20 +0800, Aaron Lu wrote:
> > > This patch adds runtime pm support for sr.
> > > 
> > > It did this by increasing the runtime usage_count of the device when:
> > > - its block device is opened;
> > > - the events checking is to run.
> > > 
> > > And decreasing the runtime usage_count of the device when:
> > > - its block device is closed;
> > > - After the events checking is done.
> > > 
> > > The idea is discussed in this mail thread:
> > > http://thread.gmane.org/gmane.linux.acpi.devel/55243/focus=52703
> > > 
> > > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > 
> > I'd like an ack from Alan Stern as well, please, but with that, you can
> > add my acked-by.
> 
> Aaron, have you checked whether this patch works okay when you play a
> track on an audio-only CD on the computer?  The block interface looks 
> okay but I'm not sure about the cdrom_device interface.

Just verified it works OK with the whole patchset applied using 2 audio
CDs.

After the ODD has been put into zero power state, insert an audio cd.
ODD will be resumed, gvfs will automatically mount the disc, and a
dialog titled "Audio Disc" asks me what to do. Press OK, the rhythmbox
application will get started. Press the Play button of rhythmbox, songs
will start to play, and runtime_usage is 2. Eject the disc, the ODD will
be put to zero power state some time later.

Thanks,
Aaron

