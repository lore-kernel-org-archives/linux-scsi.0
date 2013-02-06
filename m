From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 4/4] sd: change to auto suspend mode
Date: Wed, 6 Feb 2013 10:51:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1302061048180.1893-100000@iolanthe.rowland.org>
References: <5111BBA1.4010200@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <5111BBA1.4010200@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 6 Feb 2013, Aaron Lu wrote:

> > The "if (err == -EAGAIN)" test and the call to pm_schedule_suspend seem
> > to have been dropped since v8 of this series.  It looks like they ought
> > to be moved into sdev_runtime_suspend.
> 
> I thought they were no longer needed...

You did not mention this in the patch description.

> For sd, we have request based rutime PM and the PM core will always try
> to autosuspend the device with the timer; and for sr, the poll will
> trigger suspend constantly.

What if the poll has been disabled?

> And for both, we don't return -EAGAIN anyway.
> So I suppose that code is not necessary?

You could replace it with WARN_ON(err == -EAGAIN).  That way if some 
SCSI driver does return -EAGAIN in the future, people will know 
something is wrong.

> BTW, I'll be on vocation till 02/17, and I don't have access to the
> internet in my hometown, but please feel free to drop any comments and
> I'll check them when I get back.

I'm going on vacation next week too.  Enjoy your trip.

Alan Stern

