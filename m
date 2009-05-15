From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH block#for-2.6.31 1/3] ub: use __blk_end_request_all()
Date: Fri, 15 May 2009 11:31:14 -0600
Message-ID: <20090515113114.68ae93ae.zaitcev@redhat.com>
References: <4A0D86DB.9000203@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49531 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbZEORlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 May 2009 13:41:02 -0400
In-Reply-To: <4A0D86DB.9000203@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>

On Sat, 16 May 2009 00:14:35 +0900, Tejun Heo <tj@kernel.org> wrote:

> @@ -834,12 +829,7 @@ static void ub_end_rq(struct request *rq
>  		error = -EIO;
>  		rq->errors = scsi_status;
>  	}
> -	rqlen = blk_rq_bytes(rq);    /* Oddly enough, this is the residue. */
> -	if (__blk_end_request(rq, error, cmd_len)) {
> -		printk(KERN_WARNING DRV_NAME
> -		    ": __blk_end_request blew, %s-cmd total %u rqlen %ld\n",
> -		    blk_pc_request(rq)? "pc": "fs", cmd_len, rqlen);
> -	}
> +	__blk_end_request_all(rq, error);
>  }

I applaud this. We needed blk_end_this_mudafakin_request() for a long time.
Why two underscores?

-- Pete
