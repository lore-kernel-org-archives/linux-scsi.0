From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/16] block: fix elevator init check
Date: Tue, 24 Jan 2017 08:02:52 +0100
Message-ID: <ebb3e9f6-df35-74a7-23a9-71521098a124@suse.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbdAXHC4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Jan 2017 02:02:56 -0500
In-Reply-To: <1485185361-29786-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 01/23/2017 04:29 PM, Christoph Hellwig wrote:
> We can't initalize the elevator fields for flushes as flush share space
> in struct request with the elevator data.  But currently we can't
> commnicate that a request is a flush through blk_get_request as we
> can only pass READ or WRITE, and the low-level code looks at the
> possible NULL bio to check for a flush.
> 
> Fix this by allowing to pass any block op and flags, and by checking for
> the flush flags in __get_request.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c | 26 ++++----------------------
>  1 file changed, 4 insertions(+), 22 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
