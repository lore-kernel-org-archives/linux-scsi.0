From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: make sysfs scsi queue_depth read/write [patch]
Date: Wed, 14 Jan 2004 16:37:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040114153713.GW20560@drinkel.cistron.nl>
References: <20040114114132.GA12621@cistron.nl> <1074092186.1805.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 10fwd.cistron-office.nl ([62.216.29.197]:38098 "EHLO
	smtp.cistron-office.nl") by vger.kernel.org with ESMTP
	id S261188AbUANPhQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 10:37:16 -0500
Content-Disposition: inline
In-Reply-To: <1074092186.1805.23.camel@mulgrave> (from James.Bottomley@steeleye.com on Wed, Jan 14, 2004 at 15:56:24 +0100)
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 14 Jan 2004 15:56:24, James Bottomley wrote:
> On Wed, 2004-01-14 at 06:41, Miquel van Smoorenburg wrote:
>
> > Below is a patch that makes /sys/block/<dev>/device/queue_depth
> > a read/write variable. Minimum limit is 1, maximum limit is the
> > value set in host->cmd_per_lun, so it should be perfectly safe.
> 
> In 2.6 this isn't the correct way to do it.
> 
> The problem (which your patch doesn't address) is that a queue often has
> driver allocated resources behind it, so the driver needs to participate
> in queue depth adjustment.  You account for this in the check to make
> sure the user isn't raising the depth, but nothing frees the (now
> useless) queue resources the driver potentially has.

Ah, I see. That is a problem. Thanks for pointing that out.

> The correct fix is to do a queue depth attribute override in the 3ware
> driver.  For an example of exactly how this is done, look in the
> 53c700.c driver.  It actually has no driver backed queue resources, so
> it does essentially what your second patch does...If the 3ware is in the
> same position (i.e. can stand a depth increase) then I've no problem
> with moving this store_queue_depth routine into scsi_sysfs and making it
> globally available for drivers that want a settable queue depth.

Oh, that looks pretty cool indeed. Nice infrastructure! That's easily
implementable in 3w-xxxx.c, so that's what I'll do.

Thanks!

Mike.
