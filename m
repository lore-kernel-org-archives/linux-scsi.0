From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: 2.6.24 regression w/ QLA2300
Date: Tue, 5 Feb 2008 08:02:46 -0800
Message-ID: <20080205160246.GF19882@plap3.qlogic.org>
References: <47A88736.6090706@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:2765 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYBEQCs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 11:02:48 -0500
Content-Disposition: inline
In-Reply-To: <47A88736.6090706@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-driver@qlogic.com

On Tue, 05 Feb 2008, Alan D. Brunelle wrote:

> commit 9b73e76f3cf63379dcf45fcd4f112f5812418d0a
> Merge: 50d9a12... 23c3e29...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Jan 25 17:19:08 2008 -0800
> 
>     Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
> 
>     * git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6: (200 commits)
> 
> I believe a regression was introduced. I'm running on a 4-way IA64,
> with straight 2.6.24 and 2 dual-port cards:
> 
> 40:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
> 40:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
> c0:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
> c0:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
> 
> the adapters failed initialization. In particular, I narrowed it down
> to failing the qla2x00_mbox_command call within qla2x00_init_firmware
> function. I went and removed the qla2x00-related parts of this (large-ish)
> merge, and the 4 ports initialized just fine.

Could you load the (default 2.6.24) driver with
ql2xextended_error_logging modules parameter set:

	# insmod qla2xxx ql2xextended_error_logging=1

and send the resultant kernel logs?

> Specifically, reverting the "patch" below enabled the devices to initialize properly.
> 
> If need be, I'm certainly willing to help narrow down to the specific part in
> this patch...

That's a rather large patch... :(   Any chance you could git-bisect?
Also, could you send your .config file you are using?

Thanks,
Andrew Vasquez
