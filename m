Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D16CA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 23:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B05920882
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 23:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbfJUXQk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 19:16:40 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52562 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729606AbfJUXQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Oct 2019 19:16:39 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 753CF29E53;
        Mon, 21 Oct 2019 19:16:36 -0400 (EDT)
Date:   Tue, 22 Oct 2019 10:16:33 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/24] wd33c93: use SCSI status
In-Reply-To: <20191021095322.137969-4-hare@suse.de>
Message-ID: <alpine.LNX.2.21.1910220948520.14@nippy.intranet>
References: <20191021095322.137969-1-hare@suse.de> <20191021095322.137969-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Oct 2019, Hannes Reinecke wrote:

> Use standard SCSI status and drop usage of the linux-specific ones.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/wd33c93.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index f81046f0e68a..98e04a7b9d63 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -1176,10 +1176,8 @@ wd33c93_intr(struct Scsi_Host *instance)
>  			if (cmd->SCp.Status == ILLEGAL_STATUS_BYTE)
>  				cmd->SCp.Status = lun;
>  			if (cmd->cmnd[0] == REQUEST_SENSE
> -			    && cmd->SCp.Status != GOOD)
> -				cmd->result =
> -				    (cmd->
> -				     result & 0x00ffff) | (DID_ERROR << 16);
> +			    && cmd->SCp.Status != SAM_STAT_GOOD)
> +				set_host_byte(cmd, DID_ERROR);

This isn't obviously equivalent. Perhaps the set_host_byte() changes 
should be done in a separate patch to the SAM_STAT_FOO changes (?)

>  			else
>  				cmd->result =
>  				    cmd->SCp.Status | (cmd->SCp.Message << 8);
> @@ -1262,9 +1260,8 @@ wd33c93_intr(struct Scsi_Host *instance)
>  		    hostdata->connected = NULL;
>  		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
>  		hostdata->state = S_UNCONNECTED;
> -		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != GOOD)
> -			cmd->result =
> -			    (cmd->result & 0x00ffff) | (DID_ERROR << 16);
> +		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != SAM_STAT_GOOD)
> +			set_host_byte(cmd, DID_ERROR);

Same.

>  		else
>  			cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
>  		cmd->scsi_done(cmd);
> @@ -1294,12 +1291,10 @@ wd33c93_intr(struct Scsi_Host *instance)
>  			hostdata->connected = NULL;
>  			hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
>  			hostdata->state = S_UNCONNECTED;
> -			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
> -			    if (cmd->cmnd[0] == REQUEST_SENSE
> -				&& cmd->SCp.Status != GOOD)
> -				cmd->result =
> -				    (cmd->
> -				     result & 0x00ffff) | (DID_ERROR << 16);
> +			DB(DB_INTR, printk(":%d", cmd->SCp.Status));
> +			if (cmd->cmnd[0] == REQUEST_SENSE
> +			    && cmd->SCp.Status != SAM_STAT_GOOD)
> +				set_host_byte(cmd->result, DID_ERROR);

Same.

-- 

>  			else
>  				cmd->result =
>  				    cmd->SCp.Status | (cmd->SCp.Message << 8);
> 
