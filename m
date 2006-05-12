From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache
	scsi_cmd_cache
Date: Fri, 12 May 2006 12:47:18 -0500
Message-ID: <1147456038.3769.39.camel@mulgrave.il.steeleye.com>
References: <20060511151456.GD3755@harddisk-recovery.com>
	 <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com>
	 <20060512171632.GA29077@harddisk-recovery.com>
	 <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11963 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932174AbWELRrn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 13:47:43 -0400
In-Reply-To: <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Erik Mouw <erik@harddisk-recovery.com>, Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, axboe@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, 2006-05-12 at 10:36 -0700, Linus Torvalds wrote:
> Ok, that's just _strange_. Clearly bisection picked the right commit, 
> since:

I can guess what the problem is.

The kmem_cache_release is triggered from the device model release of the
host generic device.   I suspect we've induced a tangle in here that
means scsi devices (and hence hosts) get deleted but never released.

I'll look at the release paths and see if I can work out what it is.

James


