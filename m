From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] scsi_debug: allow huge transfer length for
 read/write commands
Date: Wed, 28 May 2014 03:39:55 -0700
Message-ID: <20140528103955.GD13542@infradead.org>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
 <1401021816-10423-5-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaE1Kjz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 06:39:55 -0400
Content-Disposition: inline
In-Reply-To: <1401021816-10423-5-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

On Sun, May 25, 2014 at 09:43:36PM +0900, Akinobu Mita wrote:
> This change enables to test read/write commands with huge transfer
> length such as 1GB.  For example:
> 
> 	# modprobe scsi_debug dev_size_mb=1024 clustering=1 opts=1
> 	# cat /sys/block/$DEV/queue/max_hw_sectors_kb > \
> 		/sys/block/$DEV/queue/max_sectors_kb
> 	# fio --name=test --rw=write --bs=1g --size=1g --filename=/dev/$DEV \
> 		--mem=mmaphuge  --direct=1
> 
> The data type of max_sectors in scsi_host_template has been extended
> to unsigned int by the previous change.  So we can increase it from
> 0xffff to 0xffffffff to allow such huge transfer length.
> 
> Also, this increases sg_tablesize and max_segment_size, otherwise the
> maximum transfer length is limited to 64MB.
> (sg_tablesize * max_segment_size = 256 * 256KB)
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
