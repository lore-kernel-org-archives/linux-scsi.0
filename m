From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] sg block layer tcqing fix
Date: Tue, 6 Jan 2004 16:22:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106152215.GD3483@suse.de>
References: <3FF08EAF.9080708@us.ibm.com> <3FFA426B.2030406@torque.net> <1073402071.2047.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:10476 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264522AbUAFPWe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2004 10:22:34 -0500
Content-Disposition: inline
In-Reply-To: <1073402071.2047.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: dougg@torque.net, Brian King <brking@us.ibm.com>, dgilbert@interlog.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 06 2004, James Bottomley wrote:
> On Mon, 2004-01-05 at 23:06, Douglas Gilbert wrote:
> > Given that no other ULDs call blk_queue_*_tag() routines it seems
> > a bit strange that sg, st and osst need to call blk_queue_end_tag()
> > prior to calling scsi_release_request(). Perhaps the cleanup can be
> > built into scsi_release_request() or a new variant (e.g.
> > scsi_release_special_request() ) could be introduced.
> 
> I agree.  Having the ULD stop tags but not start them is a layering
> violation.  The attached patch will end the tag in the release request.
> 
> It's still appropriate to release the tag earlier, as the mid layer does
> to free up tag slots for other requests.  Once the tag is ended, the tag
> queue flag is cleared, so the check in release request now fails.
> 
> James
> 
> ===== drivers/scsi/scsi.c 1.132 vs edited =====
> --- 1.132/drivers/scsi/scsi.c	Tue Sep 30 09:24:17 2003
> +++ edited/drivers/scsi/scsi.c	Tue Jan  6 09:10:25 2004
> @@ -142,6 +142,23 @@
>  
>  void __scsi_release_request(struct scsi_request *sreq)
>  {
> +	struct request *req = sreq->sr_request;
> +
> +	/* unlikely because the tag was usually ended earlier
> +	 *
> +	 * NOTE: the lock should be held while checking the
> +	 * flag.  However, any race here requiring the lock
> +	 * would be a gross error. */

I don't agree with this comment - why would you need to have the queue
lock to check req->flags?

-- 
Jens Axboe

