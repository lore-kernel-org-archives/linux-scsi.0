From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: make sysfs scsi queue_depth read/write [patch]
Date: 14 Jan 2004 09:56:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074092186.1805.23.camel@mulgrave>
References: <20040114114132.GA12621@cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:59107 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266352AbUANO4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 09:56:34 -0500
In-Reply-To: <20040114114132.GA12621@cistron.nl>
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-01-14 at 06:41, Miquel van Smoorenburg wrote:
> I have been testing with a 3ware controller over the last few weeks.
> It turns out that in RAID5 mode, it performs much better if the
> queue depth is limited to 64 instead of the default 254.
> 
> So I patched the 3ware driver to make this tunable through a kernel/module
> command line option, documented my findings, and send all that
> stuff to the (very responsive) 3ware folks who are now looking at it
> to see if this fixes a problem or just the symptoms of a
> bigger problem.
> 
> Then it occured to me that it would be much easier to set this
> limit (which is per device, not per host anyway) though sysfs.
> Since a lot of SCSI drivers have options to set the queue depth,
> it probably fills a need.
> 
> Below is a patch that makes /sys/block/<dev>/device/queue_depth
> a read/write variable. Minimum limit is 1, maximum limit is the
> value set in host->cmd_per_lun, so it should be perfectly safe.
> 
> Since the patch is trivial and it fixes a real problem (in my case,
> tuning this gains 200% performance) please consider this for
> 2.6.NEXT (or 2.6.mm-next).

In 2.6 this isn't the correct way to do it.

The problem (which your patch doesn't address) is that a queue often has
driver allocated resources behind it, so the driver needs to participate
in queue depth adjustment.  You account for this in the check to make
sure the user isn't raising the depth, but nothing frees the (now
useless) queue resources the driver potentially has.

The correct fix is to do a queue depth attribute override in the 3ware
driver.  For an example of exactly how this is done, look in the
53c700.c driver.  It actually has no driver backed queue resources, so
it does essentially what your second patch does...If the 3ware is in the
same position (i.e. can stand a depth increase) then I've no problem
with moving this store_queue_depth routine into scsi_sysfs and making it
globally available for drivers that want a settable queue depth.

James


