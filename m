From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [OOPS] 2.6.11 - NMI lockup with CFQ scheduler
Date: Tue, 29 Mar 2005 13:22:26 +0100 (BST)
Message-ID: <20050329122226.94666.qmail@web52902.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web52902.mail.yahoo.com ([206.190.39.179]:4183 "HELO
	web52902.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262251AbVC2MWa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 07:22:30 -0500
In-Reply-To: 6667
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>> > I have one IDE hard disc, but I was using a USB memory stick at one
> > point. (Notice the usb-storage and vfat modules in my list.) Could
> > that be the troublesome SCSI device?

--- Jens Axboe <axboe@suse.de> wrote:
> Yes, it probably is. What happens is that you insert the stick and do io
> against it, which sets up a process io context for that device. That
> context persists until the process exits (or later, if someone still
> holds a reference to it), but the queue_lock will be dead when you yank
> the usb device.
> 
> It is quite a serious problem, not just for CFQ. SCSI referencing is
> badly broken there.

That would explain why it was nautilus which caused the oops then. Does this mean that the major
distros aren't using the CFQ then? Because how else can they be avoiding this oops with USB
storage devices?

Send instant messages to your online friends http://uk.messenger.yahoo.com 
