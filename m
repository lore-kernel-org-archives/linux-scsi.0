From: Jens Axboe <axboe@suse.de>
Subject: Re: [OOPS] 2.6.11 - NMI lockup with CFQ scheduler
Date: Tue, 29 Mar 2005 14:26:36 +0200
Message-ID: <20050329122635.GP16636@suse.de>
References: <20050329122226.94666.qmail@web52902.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:20362 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262262AbVC2M0j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 07:26:39 -0500
Content-Disposition: inline
In-Reply-To: <20050329122226.94666.qmail@web52902.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Mar 29 2005, Chris Rankin wrote:
> >> > I have one IDE hard disc, but I was using a USB memory stick at one
> > > point. (Notice the usb-storage and vfat modules in my list.) Could
> > > that be the troublesome SCSI device?
> 
> --- Jens Axboe <axboe@suse.de> wrote:
> > Yes, it probably is. What happens is that you insert the stick and do io
> > against it, which sets up a process io context for that device. That
> > context persists until the process exits (or later, if someone still
> > holds a reference to it), but the queue_lock will be dead when you yank
> > the usb device.
> > 
> > It is quite a serious problem, not just for CFQ. SCSI referencing is
> > badly broken there.
> 
> That would explain why it was nautilus which caused the oops then.
> Does this mean that the major distros aren't using the CFQ then?
> Because how else can they be avoiding this oops with USB storage
> devices?

CFQ with io contexts is relatively new, only there since 2.6.10 or so.
On UP, we don't grab the queue lock effetively so the problem isn't seen
there.

You can work around this issue by using a different default io scheduler
at boot time, and then select cfq for your ide hard drive when the
system has booted with:

# echo cfq > /sys/block/hda/queue/scheduler

(substitute hda for any other solid storage device).

-- 
Jens Axboe

