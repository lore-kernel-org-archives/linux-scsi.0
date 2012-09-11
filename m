From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Tue, 11 Sep 2012 20:31:17 +0800
Message-ID: <20120911123116.GB20978@mint-spring.sh.intel.com>
References: <Pine.LNX.4.44L0.1209061437050.1182-100000@iolanthe.rowland.org>
 <1545884.X9DCxzsAFq@linux-lqwf.site>
 <20120911111107.GA20361@mint-spring.sh.intel.com>
 <3491742.cmOxhNregO@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3491742.cmOxhNregO@linux-lqwf.site>
Sender: linux-acpi-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 11, 2012 at 02:10:18PM +0200, Oliver Neukum wrote:
> On Tuesday 11 September 2012 19:11:08 Aaron Lu wrote:
> > On Tue, Sep 11, 2012 at 11:30:35AM +0200, Oliver Neukum wrote:
> > > On Tuesday 11 September 2012 17:24:13 Aaron Lu wrote:
> 
> > > Yes, but because the whole system had been suspended.
> > > In that case you can have a locked door.
> > 
> > By locked, do you mean the door is closed or the door is locked by the
> > sr_lock_door function with param lock set to 1?
> 
> sr_lock_door()
> 
> > > That need not be the case. What happens if the door button is pressed while
> > > the system is resuming?
> > 
> > In that case, if the hardware logic is ready, an ACPI event will fire
> > and the device will be runtime resumed; if the hardware logic is not
> > ready yet due to the system is resuming, nothing happens.
> 
> So we have this race:
> 
> sr_lock_door()
> system goes to S3
> system starts resuming from S3
> user presses door button
> sr_resume()
> door opens
> 
> I guess this should not happen.

OK, I think I got your meaning.

For a simpler scenario:
1 User application did an ioctl to lock the door of the ODD when there
is no medium inside(but why? :-);
2 The ODD is runtime suspended;
3 The ODD is runtime powered off;
4 User presses the eject button, and the door is ejected in sr_resume.

Condition 1 is a must for this to happen, as if there is medium inside,
the ODD will never be powered off; or if the underlying block device is
opened by some process, it will not enter runtime suspend state.

Looks like I need to record if the door is locked in scsi_cd structure
so that I did not mistakenly eject the door. Does this sound OK?

Thanks,
Aaron
