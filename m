From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Ubuntu PATCH] CDROMEJECT cannot eject some devices
Date: Mon, 3 Jul 2006 15:04:55 -0600
Message-ID: <20060703210455.GD1605@parisc-linux.org>
References: <44A98220.2000007@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:7312 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932123AbWGCVE4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jul 2006 17:04:56 -0400
Content-Disposition: inline
In-Reply-To: <44A98220.2000007@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, axboe <axboe@suse.de>, jejb <James.Bottomley@SteelEye.com>, scsi <linux-scsi@vger.kernel.org>

On Mon, Jul 03, 2006 at 01:46:24PM -0700, Randy Dunlap wrote:
> 
> Fix the bug where CDROMEJECT cannot eject some devices.

> --- linux-2617-g21.orig/block/scsi_ioctl.c
> +++ linux-2617-g21/block/scsi_ioctl.c
> @@ -501,7 +501,7 @@ static int __blk_send_generic(request_qu
>  	struct request *rq;
>  	int err;
>  
> -	rq = blk_get_request(q, WRITE, __GFP_WAIT);
> +	rq = blk_get_request(q, READ, __GFP_WAIT);

I don't believe this hunk is necessary for mainline.  IIRC, there was a
bug around length checks vs read vs write which is now fixed.
Presumably it's still needed in Ubuntu's kernel though.

