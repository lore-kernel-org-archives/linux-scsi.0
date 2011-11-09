From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
Date: Wed, 9 Nov 2011 09:36:37 -0800
Message-ID: <20111109173637.GA5568@suse.de>
References: <20111109162512.GB1260@google.com>
 <1320859800.8294.27.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1320859800.8294.27.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 09, 2011 at 11:30:00AM -0600, James Bottomley wrote:
> On Wed, 2011-11-09 at 08:25 -0800, Tejun Heo wrote:
> > This reverts commit a72c5e5eb738033938ab30d6a634b74d1d060f10.
> > 
> > The commit introduced alias for block devices which is intended to be
> > used during logging although actual usage hasn't been committed yet.
> > This approach adds very limited benefit (raw log might be easier to
> > follow) which can be trivially implemented in userland but has a lot
> > of problems.
> 
> It has the specific benefit that on snipped logs we don't get a mismatch
> between device name and actual device.
> 
> We already had this discussion at the kernel summit.  The structured
> logging that might give us this facility in userspace isn't there yet
> (and may not be for a while), so while users cut and paste logs it's
> useful for the logs to show the device preferred name.
> 
> With just logs, we can't solve the cross reference problem, since the
> cross references appear at different points in the log files.

It's not just a log issue, it's a userspace tool issue, which is not
addressed here at all.

Actually I don't think this solves the log issue either, but that's
a different point...

> > It is much worse than netif renames because it doesn't rename the
> > actual device but just adds conveninence name which isn't used
> > universally or enforced.  Everything internal including device lookup
> > and sysfs still uses the internal name and nothing prevents two
> > devices from using conflicting alias - ie. sda can have sdb as its
> > alias.
> > 
> > This has been nacked by people working on device driver core,
> 
> Which is why it went into gendisk rather than the driver core
> 
> > block
> > layer and kernel-userland interface and shouldn't have been
> > upstreamed.  Revert it.
> 
> No, I can't agree with this ... if you propose a working alternative,
> I'm listening, but in the absence of one, I think the hack fills a gap
> we have in log analysis and tides us over until we have an agreed on
> proper solution (at which point, I'm perfectly happy to pull the hack
> back out).

Once it becomes a userspace api, it's almost impossible to ever remove,
you know that.

And as you agree this is a hack, and it really doesn't provide the
correct solution, why should it have been accepted?

Again, this is fixable in userspace, the author of the patch agrees with
that, yet refuses to make the userspace changes despite having a few
_years_ in which to so so.

Also, you should have gotten this through the block layer maintainer...

greg k-h
