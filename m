From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v8 10/11] scsi: sr: support (un)block events
Date: Tue, 30 Oct 2012 08:34:29 +0400
Message-ID: <1351571669.3051.18.camel@dabdike>
References: <Pine.LNX.4.44L0.1210291818100.31151-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1210291818100.31151-100000@netrider.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-10-29 at 18:22 -0400, Alan Stern wrote:
> On Mon, 29 Oct 2012, James Bottomley wrote:
> 
> > On Mon, 2012-10-29 at 17:01 +0800, Aaron Lu wrote:
> > > 2 interfaces are added to block/unblock events for the disk sr manages.
> > > This is used by SATA ZPODD, when ODD is runtime powered off, the events
> > > poll is no longer needed so better be blocked. And once powered on,
> > > events poll will be unblocked.
> > > 
> > > These 2 interfaces are needed here because SATA layer does not have
> > > access to the gendisk structure sr manages.
> > 
> > I'm afraid this is a nasty layering violation.  You can't have a low
> > level driver have knowledge of a call back in an upper layer one (in
> > this case sr_block_events).
> > 
> > This is all done it looks like because of the problem of getting access
> > to the scsi_cd structure from libata, but it's not the right way to
> > solve it.
> > 
> > I also don't really think you need to do any blocking or unblocking.  As
> > I said in the previous thread, just fake the events the standard tells
> > you to, so userspace can probe to its heart's content and you can keep
> > the device powered off.
> 
> James, one of us has misunderstood the event-polling mechanism.  As far
> as I know, the polling calls that Aaron is concerned with are generated
> by the kernel, not by userspace.

I don't think the origin of the poll changes anything in what I said
above, does it?

James


