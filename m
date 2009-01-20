From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH ver2 printk_ratelimit] bsg: Error print if device is
 not bidi capable when refusing a bidi command
Date: Wed, 21 Jan 2009 08:10:26 +0900
Message-ID: <20090121080839D.fujita.tomonori@lab.ntt.co.jp>
References: <4975DC00.2090005@panasas.com>
	<20090120141517.GM30821@kernel.dk>
	<4975E1EE.5070101@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37738 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbZATXKq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2009 18:10:46 -0500
In-Reply-To: <4975E1EE.5070101@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Tue, 20 Jan 2009 16:38:38 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> If a bidi command was issued to a request_queue not mark as
> QUEUE_FLAG_BIDI. Issue an error report. This is a misconfiguration
> an administrator would like to know about, which is otherwise
> hard to detect.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  block/bsg.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 44a2a0f..1da14fe 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -270,6 +270,11 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
>  
>  	if (rw == WRITE && hdr->din_xfer_len) {
>  		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
> +			if (printk_ratelimit()) {
> +				printk(KERN_ERR
> +					"bsg: Attempt to send a bidi command "
> +					"to a none bidi device\n");
> +			}
>  			ret = -EOPNOTSUPP;
>  			goto out;

I don't think that we need this patch. Returning -EOPNOTSUPP should be
enough.
