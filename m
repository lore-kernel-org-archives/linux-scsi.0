Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF523C47253
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF2DA2166E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgEARnt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 13:43:49 -0400
Received: from verein.lst.de ([213.95.11.211]:48082 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729393AbgEARnt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 13:43:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E1E6368D0D; Fri,  1 May 2020 19:43:45 +0200 (CEST)
Date:   Fri, 1 May 2020 19:43:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 03/41] scsi: Implement scsi_cmd_is_reserved()
Message-ID: <20200501174345.GB23795@lst.de>
References: <20200430131904.5847-1-hare@suse.de> <20200430131904.5847-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430131904.5847-4-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 03:18:26PM +0200, Hannes Reinecke wrote:
> Add function to check if a SCSI command originates from the reserved
> tag pool and update scsi_put_reserved_cmd() to only free commands if
> they originate from the reserved tag pool.

The SCSI bits should go into the previous patch.  The block layer
bits should be a separate prep patch before that.

> +/**
> + * blk_mq_rq_is_reserved - Check for reserved request
> + *
> + * @rq: Request to check

No empty line before the parameter description, please.

>   */
>  void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
>  {
> +	struct request *rq;
>  
> +	if (scmd && scsi_cmd_is_reserved(scmd)) {
> +		rq = blk_mq_rq_from_pdu(scmd);
> +		blk_mq_free_request(rq);
> +	}

The check looks weird.  Passing a NULL cmnd here seems like an API
abuse to start with, and !scsi_cmd_is_reserved should at best be
a WARN_ON_ONCE.

So I think this should just be something like:

void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
{
	WARN_ON_ONCE(!scsi_cmd_is_reserved(scmd));
	blk_mq_free_request(blk_mq_rq_from_pdu(scmd));
}

> +/**
> + * scsi_cmd_is_reserved - check for reserved scsi command
> + * @scmd: command to check
> + *
> + * Returns true if @scmd originates from the reserved tag pool.
> + */
> +static inline bool scsi_cmd_is_reserved(struct scsi_cmnd *scmd)
> +{
> +	struct request *rq = blk_mq_rq_from_pdu(scmd);
> +
> +	return blk_mq_rq_is_reserved(rq);

Can be shortened to:

	return blk_mq_rq_is_reserved(blk_mq_rq_from_pdu(scmd));
