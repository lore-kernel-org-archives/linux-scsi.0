From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Fri, 18 Jul 2003 21:39:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030718213916.A18974@infradead.org>
References: <1058474814.4638.11.camel@markh1.pdx.osdl.net> <1058481553.19508.5.camel@markh1.pdx.osdl.net> <1058485621.7424.30.camel@dell_ss5.pdx.osdl.net> <20030717170055.5dbe20c1.akpm@osdl.org> <3F17821A.307@cyberone.com.au> <1058540605.20130.48.camel@markh1.pdx.osdl.net> <1058545730.20130.62.camel@markh1.pdx.osdl.net> <1058547377.1826.61.camel@mulgrave> <1058550386.20130.75.camel@markh1.pdx.osdl.net> <1058559719.1826.106.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:11781 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S270375AbTGRUYY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 16:24:24 -0400
Content-Disposition: inline
In-Reply-To: <1058559719.1826.106.camel@mulgrave>; from James.Bottomley@steeleye.com on Fri, Jul 18, 2003 at 03:21:56PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Haverkamp <markh@osdl.org>, Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Jens Axboe <axboe@suse.de>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jul 18, 2003 at 03:21:56PM -0500, James Bottomley wrote:
> +++ edited/drivers/block/ll_rw_blk.c	Fri Jul 18 14:54:34 2003
> @@ -1518,6 +1518,7 @@
>   * @rq:		request to be inserted
>   * @at_head:	insert request at head or tail of queue
>   * @data:	private data
> + * @reinsert:	true if request it a reinsertion of previously processed one
>   *
>   * Description:
>   *    Many block devices need to execute commands asynchronously, so they don't
> @@ -1532,7 +1533,7 @@
>   *    host that is unable to accept a particular command.
>   */
>  void blk_insert_request(request_queue_t *q, struct request *rq,
> -			int at_head, void *data)
> +			int at_head, void *data, int reinsert)

Shouldn't the parameter be after at_head for consistency?

