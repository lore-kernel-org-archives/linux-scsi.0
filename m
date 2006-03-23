From: Jens Axboe <axboe@suse.de>
Subject: Re: unify SCSI_IOCTL_SEND_COMMAND implementations
Date: Thu, 23 Mar 2006 11:18:19 +0100
Message-ID: <20060323101819.GV4285@suse.de>
References: <20060322165204.GA32287@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:46671 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932106AbWCWKSQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Mar 2006 05:18:16 -0500
Content-Disposition: inline
In-Reply-To: <20060322165204.GA32287@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Wed, Mar 22 2006, Christoph Hellwig wrote:
> We currently have two implementations of this obsolete ioctl, one in
> the block layer and one in the scsi code.  Both of them have drawbacks.
> 
> This patch kills the scsi layer version after updating the block version
> with the missing bits:
> 
>  - argument checking
>  - use scatterlist I/O
>  - set number of retries based on the submitted command
> 
> This is the last user of non-S/G I/O except for the gdth driver, so
> getting this in ASAP and through the scsi tree would be nie to kill
> the non-S/G I/O path.  Jens, what do you think about adding a check
> for non-S/G I/O in the midlayer?

Looks good to me. Are cdrom/sr sg clean as well?

-- 
Jens Axboe

