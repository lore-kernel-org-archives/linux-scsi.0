Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E3DC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD8061059
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhDZPVB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:21:01 -0400
Received: from verein.lst.de ([213.95.11.211]:41741 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhDZPVA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 11:21:00 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 897B368C4E; Mon, 26 Apr 2021 17:20:16 +0200 (CEST)
Date:   Mon, 26 Apr 2021 17:20:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 08/39] scsi: Kill DRIVER_SENSE
Message-ID: <20210426152016.GA25615@lst.de>
References: <20210423113944.42672-1-hare@suse.de> <20210423113944.42672-9-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423113944.42672-9-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 23, 2021 at 01:39:13PM +0200, Hannes Reinecke wrote:
> Introduce scsi_status_is_check_condition() and

That was added in the last patch, wasn't it?

> +++ b/block/bsg.c
> @@ -97,6 +97,8 @@ static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
>  	hdr->device_status = sreq->result & 0xff;
>  	hdr->transport_status = host_byte(sreq->result);
>  	hdr->driver_status = driver_byte(sreq->result);
> +	if (scsi_status_is_check_condition(sreq->result))
> +		hdr->driver_status |= DRIVER_SENSE;

I think hdr->driver_status also needs to be cleared to 0 first.  A little
comment on the history would be nice as well.

> @@ -257,6 +257,8 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>  	hdr->msg_status = msg_byte(req->result);
>  	hdr->host_status = host_byte(req->result);
>  	hdr->driver_status = driver_byte(req->result);
> +	if (hdr->status == SAM_STAT_CHECK_CONDITION)
> +		hdr->driver_status |= DRIVER_SENSE;

Same here.  Also why the open coded check in one please and the
SAM_STAT_CHECK_CONDITION comparism in another?

Maybe we need a little helper instead of duplicating the logic?

> +			} else
> +				hp->driver_status |= DRIVER_SENSE;

Shouldn't this be where the previous driver_byte call was?  And
maybe also use a proper helper?

> @@ -131,6 +131,8 @@ struct compat_sg_io_hdr {
>  #define SG_INFO_DIRECT_IO 0x2   /* direct IO requested and performed */
>  #define SG_INFO_MIXED_IO 0x4    /* part direct, part indirect IO */
>  
> +/* Obsolete DRIVER_SENSE setting */
> +#define DRIVER_SENSE 0x08

I think this needs a better documentation on what it means and why it
is obsolete.
