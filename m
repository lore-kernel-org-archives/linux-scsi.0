From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system suspend
Date: Thu, 24 Nov 2011 17:54:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1111241735300.26861-100000@netrider.rowland.org>
References: <20111124195703.GA6735@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111124195703.GA6735@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 24 Nov 2011, Tejun Heo wrote:

> Hello,
> 
> On Thu, Nov 24, 2011 at 11:36:20AM -0500, Alan Stern wrote:
> > I think this email discussion has answered his objection: The only SCSI
> > top-level driver implementing runtime suspend is sd, and sd treats
> > runtime suspend the same as system sleep.  It might be a good idea to
> > add a comment with this explanation along with the new code, however.
> 
> Hmmm... I see.  This shouldn't affect host controller states - we'll
> be skipping only the drive PM transitions, right?

Right.

>  As long as it's
> well documented, I guess it's okay but at the same time I don't think
> it's such a big deal to spin up drives when the system is entering
> hibernation from runtime powersave.  On most systems, they'll need to
> be spun up for image dump pretty soon anyway.

Hmm, that's true.  Or more precisely, they'll all be spun up for the
THAW stage of hibernation, prior to storing the memory image -- even
though the image is generally stored on only a single drive.

Okay, Ming, your most recent suggested patch can be used as is (though
adding a comment would be a good idea).  Here's my suggestion for the
patch description:

The only high-level SCSI driver that currently implements runtime PM is
sd, and sd treats runtime suspend exactly the same as the SUSPEND and
HIBERNATE stages of system sleep, but not the same as the FREEZE stage.

Therefore, when entering the SUSPEND or HIBERNATE stages of system
sleep, we can skip the callback to the driver if the device is already
in runtime suspend.  When entering the FREEZE stage, however, we should
first issue a runtime resume.  The overhead of doing this is
negligible, because a suspended drive would be spun up during the THAW
stage of hibernation anyway.

Alan Stern

