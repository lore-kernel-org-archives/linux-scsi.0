From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Tue, 19 Jun 2007 07:43:24 +0200
Message-ID: <20070619054324.GA18542@lst.de>
References: <20070615113919.142332000@pademelon.sonytel.be> <20070615120848.352093000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:36118 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbXFSFoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2007 01:44:04 -0400
Content-Disposition: inline
In-Reply-To: <20070615120848.352093000@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 01:39:23PM +0200, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> Add a Disk Storage Driver for the PS3:
>   - Implemented as a block device driver with a dynamic major
>   - Disk names (and partitions) are of the format ps3d%c(%u)
>   - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
>     doesn't support scatter-gather

Looks good to me.  Only nitpicks are:

 - ps3disk_priv should probably be an inline function instead of a macro
 - ps3disk_open is not needed at all and should be removed completely.
 - please remove PS3DISK_MAJOR - and just pass 0 to register_blkdev.
   Passing 0 to get an unassigned dev_t range is the normal convention
   and giving it a suprising symbolic names makes reading the code a
   little harder.  
 - put_disk in ps3disk_remove should be done after you finished tearing
   down the device, not before
 - calling free_irq directly followed by request_irq in ps3disk_probe
   looks rather dumb.  I'd rather move the request_irq out of
   ps3stor_setup into the low-level driver.

