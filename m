From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 02 Apr 2004 19:25:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080951925.1829.172.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave> <20040402084338.GA3547@us.ibm.com>
	<1080921450.1804.66.camel@mulgrave> <20040402164531.GB3880@us.ibm.com>
	<1080925518.1830.93.camel@mulgrave> <20040402174442.GE3880@us.ibm.com>
	<1080929583.1804.122.camel@mulgrave>  <20040402234051.GB1472@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:23464 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261425AbUDCA0C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 19:26:02 -0500
In-Reply-To: <20040402234051.GB1472@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, stern@rowland.harvard.edu

On Fri, 2004-04-02 at 18:40, Mike Anderson wrote:
> Greg stopped by and after talking this over I think I see why sd is
> racing in its current form. The race happens when sd_remove and do_open
> race. Even though I do not like adding a lock_kernel it would appear
> adding on to sd_remove would serialize sd_remove and do_open. This would
> ensure either do_open's get_gendisk returns a gendisk struct and sd
> ref's are incremented or we will start cleaning up and sd_open will not
> be called.
> 
> I would believe similar alignment in sr.c to what sd is doing plus
> agreement on the lock_kernel should fix both drivers.
> 
> I think the "error out correctly" on trying to get a ref on sdev_gendev
> may need some higher serialization as I think there is a race on a release
> function starting and the reference count trying to be taken to 1 (i.e.
> you need something subsystem wide as you cannot look at the item you
> maybe deleting.

I'm not convinced we need any other serialisation.  As long as we get
the reference we may use the device (of course if the device is being
removed and sd_remove is being called, then I/O to it will fail, but I
think that's fine). Leaving the user with an open device that won't
accept I/O is also fine (as long as it returns the correct error codes).

Could you outline what the consequences of this race are?

James


