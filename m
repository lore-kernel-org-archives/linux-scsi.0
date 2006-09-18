From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Mon, 18 Sep 2006 19:47:12 +0100
Message-ID: <20060918184712.GA17670@infradead.org>
References: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10634 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751707AbWIRSre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 14:47:34 -0400
Content-Disposition: inline
In-Reply-To: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Fri, Sep 01, 2006 at 02:31:51PM +0800, Ed Lin wrote:
>  static int
> +stex_slave_alloc(struct scsi_device *sdev)
> +{
> +	/* Cheat: usually extracted from Inquiry data */
> +	sdev->tagged_supported = 1;
> +
> +	scsi_activate_tcq(sdev, sdev->host->can_queue);

these two calls look wrong here. scsi_activate_tcq is supposed to be
called from slave_configure.  similarly tagged_supported is probably
going to be overwriten as part of the scanning process, but you already
set it in slave_configure anyway.

> +	tag = cmd->request->tag;
> +
> +	if (unlikely(tag >= host->can_queue))
>  		return SCSI_MLQUEUE_HOST_BUSY;

Do we really need this check?  I'm pretty sure the block layer never
hands out tags bigger than what you told it to with scsi_activate_tcq.

