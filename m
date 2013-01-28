From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 3/4] block: implement runtime pm strategy
Date: Mon, 28 Jan 2013 10:11:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301281010160.1997-100000@iolanthe.rowland.org>
References: <20130128092121.GB2568@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20130128092121.GB2568@aaronlu.sh.intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 28 Jan 2013, Aaron Lu wrote:

> On Sat, Jan 19, 2013 at 01:11:45PM -0500, Alan Stern wrote:
> > On Sat, 19 Jan 2013, Aaron Lu wrote:
> > > Considering ODD's use case, I was thinking of moving the
> > > blk_pm_runtime_init call to sd.c, as sr will not use request based auto
> > > suspend. Probably right before we decrease usage count for the device in
> > > sd_probe_async. What do you think?
> > 
> > That makes sense.  But then you should review the changes in scsi_pm.c 
> > to make sure they will work okay for devices that aren't using 
> > block-layer runtime PM.
> 
> Now that we have two different runtime PM schemes for scsi device, and
> I think there are two ways to make them work:
> 
> 1 Do it all in scsi_pm.c. In bus' runtime PM callback, check if this
>   device is using block layer runtime PM API, and act accordingly;
> 2 Do it in indivisual drivers' runtime PM callback. Bus' runtime PM
>   callbacks just call pm_generic_runtime_xxx, and each driver's runtime
>   PM callback will need to do what is appropriate for them.
> 
> Personally I want to go with option 1, but I would like to hear your
> opinion :-)

I don't think it matters very much.  Option 1 is okay with me.  James 
might have a stronger feeling one way or the other.

Alan Stern

