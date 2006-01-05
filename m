From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: blk_cleanup_queue, sleep in invalid context
Date: Thu, 05 Jan 2006 12:08:15 -0500
Message-ID: <1136480895.3288.26.camel@mulgrave>
References: <20060104165300.23fb4ce8.akpm@osdl.org>
	 <20060105005609.GA17604@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:3971 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751171AbWAERIa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2006 12:08:30 -0500
In-Reply-To: <20060105005609.GA17604@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Olaf Hering <olh@suse.de>

On Wed, 2006-01-04 at 16:56 -0800, Greg KH wrote:
> You mean, put a might_sleep() in put_device()?  Yes, I can do that, as
> that function might sleep.  SCSI is the culprit here, and I thought that
> the scsi developers had fixed this up already.

No .. I identified one clear culprit which was fixed, but I also said we
have exposure to this all over the place.  Our basic problem is that we
have a complex refcounted model for hosts, devices and commands.  Since
the I/O paths are all accessible from either user or softirq context,
most of these puts will be in potentially illegal places.

We could get out of this by dumping device refcounting and implementing
our own instead, but that really doesn't sound to be the right thing to
do.  Conversely, putting workqueues everywhere to get around this, like
I did for the target handling, is going to get very messy.

James


