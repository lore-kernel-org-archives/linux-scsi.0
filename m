From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/3 ver2] block layer extended-cdb support
Date: Fri, 4 Apr 2008 13:46:14 +0200
Message-ID: <20080404114614.GJ29686@kernel.dk>
References: <47E92672.1040208@panasas.com> <47E92934.6040903@panasas.com> <1207240982.3048.45.camel@localhost.localdomain> <47F522A6.3080806@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:22745 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbYDDLtF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2008 07:49:05 -0400
Content-Disposition: inline
In-Reply-To: <47F522A6.3080806@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Apr 03 2008, Boaz Harrosh wrote:
>  static void req_bio_endio(struct request *rq, struct bio *bio,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 6f79d40..2f87c9d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -213,8 +213,15 @@ struct request {
>  	/*
>  	 * when request is used as a packet command carrier
>  	 */
> -	unsigned int cmd_len;
> -	unsigned char cmd[BLK_MAX_CDB];
> +	unsigned short cmd_len;
> +	unsigned short ext_cdb_len;  /* length of ext_cdb buffer */
> +	union {
> +		unsigned char cmd[BLK_MAX_CDB];
> +		unsigned char *ext_cdb;/* an optional extended cdb.
> +	                                   * points to a user buffer that must
> +	                                   * be valid until end of request
> +	                                   */
> +	};

Why not just something ala

        unsigned short cmd_len;
        unsigned char __cmd[BLK_MAX_CDB];
        unsigned char *cmd;

and then have rq_init() do

        rq->cmd = rq->__cmd;

and just have a function for setting up a larger ->cmd and adjusting
->cmd_len in the process?

Then rq_set_cdb() would be

static inline void rq_set_cdb(struct request *rq, u8 *cdb, short cdb_len)
{
        rq->cmd = cdb;
        rq->cmd_len = cdb_len;
}

and rq_get_cdb() plus rq_get_cdb_len() could just go away.

-- 
Jens Axboe

