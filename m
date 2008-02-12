From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] bsg: bidi bio map failure fix
Date: Tue, 12 Feb 2008 15:12:38 -0600
Message-ID: <1202850758.3137.135.camel@localhost.localdomain>
References: <20080212204024.GA13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46079 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757303AbYBLVMn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 16:12:43 -0500
In-Reply-To: <20080212204024.GA13643@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On Tue, 2008-02-12 at 15:40 -0500, Pete Wyckoff wrote:
> If blk_rq_map_user requires more than one bio, and fails mapping
> somewhere after the first bio, it will return with rq->bio set to
> non-NULL, but it will have already unmapped the partial bio.  The
> "out:" error exit section will see the non-null bio and try to unmap
> it again, triggering a mapcount bug via bad_page().
> 
> Signed-off-by: Pete Wyckoff <pw@osc.edu>
> ---
>  block/bsg.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 3337125..bba7154 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -295,8 +295,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
>  
>  		dxferp = (void*)(unsigned long)hdr->din_xferp;
>  		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
> -		if (ret)
> +		if (ret) {
> +			next_rq->bio = NULL;  /* do not unmap twice */

Nice ... that's a nasty asymmetry of the blk_rq_map_user API.  The map
takes a request gets a ref and fills in the bio.  The unmap has to be
called on the bio leaving you to clear the now removed bio reference
manually.

James


