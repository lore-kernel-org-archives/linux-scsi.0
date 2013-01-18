From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Fri, 18 Jan 2013 10:24:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301181017070.1988-100000@iolanthe.rowland.org>
References: <20130118074240.GA6861@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20130118074240.GA6861@aaronlu.sh.intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 18 Jan 2013, Aaron Lu wrote:

> > Aaron, have you checked whether this patch works okay when you play a
> > track on an audio-only CD on the computer?  The block interface looks 
> > okay but I'm not sure about the cdrom_device interface.
> 
> Just verified it works OK with the whole patchset applied using 2 audio
> CDs.
> 
> After the ODD has been put into zero power state, insert an audio cd.
> ODD will be resumed, gvfs will automatically mount the disc, and a
> dialog titled "Audio Disc" asks me what to do. Press OK, the rhythmbox
> application will get started. Press the Play button of rhythmbox, songs
> will start to play, and runtime_usage is 2. Eject the disc, the ODD will
> be put to zero power state some time later.

What happens if you use a non-ZP drive?

What happens if you're not running a desktop graphical environment, so
gvfs doesn't mount the disc?  Basically, I'm worried that the drive may
remain suspended after sr_open() returns.

What happens if you use a program other than rhythmbox?  There are (or
used to be) programs which would issue the PLAY AUDIO command and then
exit.  The drive would continue playing even while the device file was
closed.  Do we want to drop support for that kind of behavior?

Alan Stern

