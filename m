From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Thu, 6 Sep 2012 11:06:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209061103530.1363-100000@iolanthe.rowland.org>
References: <20120905224912.GA1443@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120905224912.GA1443@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Oliver Neukum <oneukum@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 6 Sep 2012, Aaron Lu wrote:

> > That's why we have an autosuspend delay.  Although for some reason the 
> > SCSI subsystem doesn't use it currently...  We need to add a call to 
> > pm_runtime_use_autosuspend() in scsi_sysfs_add_sdev().  Likewise, the 
> > pm_schedule_suspend() call in scsi_runtime_idle() should be changed to 
> > pm_runtime_autosuspend().  And there should be calls to 
> > pm_runtime_set_autosuspend_delay() in the sd and sr drivers.
> 
> I tried to use autosuspend when preparing the patch, but the fact that
> the devices will be polled every 2 seconds make it impossible to enter
> suspend state if the autosuspend delay is larger than that.

You can always increase the polling interval.

But in the long run that wouldn't be a good solution.  What I'd really 
like is a way to do the status polling without having it reset the 
idle timer.

Oliver, what do you think?  Would that be a good solution?

Alan Stern

