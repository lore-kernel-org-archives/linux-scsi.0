From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 4/4] sd: change to auto suspend mode
Date: Mon, 28 Jan 2013 10:12:44 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301281011570.1997-100000@iolanthe.rowland.org>
References: <20130128085651.GA2568@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20130128085651.GA2568@aaronlu.sh.intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 28 Jan 2013, Aaron Lu wrote:

> > Someone just asked about the default autosuspend delay, and I realized
> > your patch series doesn't set one.  Since we don't know the properties
> > of the disk drive at this point (or even whether the device is a disk
> > drive), the only safe course is to call
> > 
> > 	pm_runtime_set_autosuspend_delay(&sdev->sdev_gendev, -1);
> > 
> > before calling blk_pm_runtime_init().  Then autosuspends will be 
> > prevented until userspace writes a non-negative value into the device's 
> > control/autosuspend_delay_ms file.
> 
> Shall we do it inside blk_pm_runtime_init? This way, we do not need to
> do it for every driver. And for drivers that do know a proper value for
> autosuspend delay, they can call pm_runtime_set_autosuspend_delay
> somewhere after blk_pm_runtime_init.

Yes, that seems like a good approach.  Be sure to mention it in the 
kerneldoc.

Alan Stern

