From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache
	scsi_cmd_cache
Date: Fri, 12 May 2006 13:58:45 -0500
Message-ID: <1147460325.3769.46.camel@mulgrave.il.steeleye.com>
References: <20060511151456.GD3755@harddisk-recovery.com>
	 <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com>
	 <20060512171632.GA29077@harddisk-recovery.com>
	 <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
	 <1147456038.3769.39.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24002 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751322AbWELS66 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 14:58:58 -0400
In-Reply-To: <1147456038.3769.39.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Erik Mouw <erik@harddisk-recovery.com>, Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, axboe@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, 2006-05-12 at 12:47 -0500, James Bottomley wrote:
> I'll look at the release paths and see if I can work out what it is.

OK, here's the scoop.  The problem patch adds a get of driverfs_dev in
add_disk(), but doesn't put it again until disk_release() (which occurs
on final put_disk() of the gendisk).

However, in SCSI, the driverfs_dev is the sdev_gendev.  That means
there's a reference held on sdev_gendev  until final disk put.
Unfortunately, we use the driver model driver_remove to trigger
del_gendisk (which removes the gendisk from visibility and decrements
the refcount), so we've introduced an unbreakable deadlock in the
reference counting with this.

I suggest simply reversing this patch at the moment.  If Russell and
Jens can tell me what they're trying to do I'll see if there's another
way to do it.

James


