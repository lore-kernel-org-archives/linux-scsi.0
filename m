From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] scsi: increase upper limit for max_sectors
Date: Wed, 28 May 2014 03:39:31 -0700
Message-ID: <20140528103931.GC13542@infradead.org>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
 <1401021816-10423-4-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54448 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaE1Kjb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 06:39:31 -0400
Content-Disposition: inline
In-Reply-To: <1401021816-10423-4-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

On Sun, May 25, 2014 at 09:43:35PM +0900, Akinobu Mita wrote:
> max_sectors in struct Scsi_Host specifies maximum number of sectors
> allowed in a single SCSI command.  The data type of max_sectors is
> unsigned short, so the maximum transfer length per SCSI command is
> limited to less than 256MB in 4096-bytes sector size. (0xffff * 4096)
> 
> This commit increases the SCSI mid level's limitation for max_sectors
> upto the block layer's limitation for max_hw_sectors by extending the
> data type of max_sectors in struct Scsi_Host and scsi_host_template,
> so that SCSI lower level drivers can specify more than 0xffff.
> 
> This change requires the scsi disk (sd) driver to handle the requests
> whose transfer length is more than 0xffff with READ_16 or WRITE_16.
> Also, this needs to prevent SG_GET_RESERVED_SIZE and SG_SET_RESERVED_SIZE
> ioctls for the scsi generic (sg) driver from integer overflow when
> converting max_sectors to bytes.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Looks good, but I think this should be three patches, one for the ioctl
in sg, one for the command selection in sd, and one to change the field
with in the scsi core.

