Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24A7C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 09:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2F8A61474
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 09:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhDXJVi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 05:21:38 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52324 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhDXJVh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 05:21:37 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 41B8922830;
        Sat, 24 Apr 2021 05:20:55 -0400 (EDT)
Date:   Sat, 24 Apr 2021 19:20:59 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 24/39] wd33c93: translate message byte to host byte
In-Reply-To: <20210423113944.42672-25-hare@suse.de>
Message-ID: <496782e-7377-ac6b-874-213f4e520b6@nippy.intranet>
References: <20210423113944.42672-1-hare@suse.de> <20210423113944.42672-25-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 23 Apr 2021, Hannes Reinecke wrote:

> Instead of setting the message byte translate it to the appropriate
> host byte. As error recovery would return DID_ERROR for any non-zero
> message byte the translation doesn't change the error handling.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/wd33c93.c | 46 ++++++++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index a23277bb870e..187b363db00e 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -1176,13 +1176,14 @@ wd33c93_intr(struct Scsi_Host *instance)
>  			if (cmd->SCp.Status == ILLEGAL_STATUS_BYTE)
>  				cmd->SCp.Status = lun;
>  			if (cmd->cmnd[0] == REQUEST_SENSE
> -			    && cmd->SCp.Status != SAM_STAT_GOOD)
> -				cmd->result =
> -				    (cmd->
> -				     result & 0x00ffff) | (DID_ERROR << 16);
> -			else
> -				cmd->result =
> -				    cmd->SCp.Status | (cmd->SCp.Message << 8);
> +			    && cmd->SCp.Status != SAM_STAT_GOOD) {
> +				set_host_byte(cmd, DID_ERROR);
> +				set_status_byte(cmd, SAM_STAT_GOOD);
> +			} else {
> +				set_host_byte(cmd, DID_OK);
> +				translate_msg_byte(cmd, cmd->SCp.Message);
> +				set_status_byte(cmd, cmd->SCp.Status);
> +			}
>  			cmd->scsi_done(cmd);
>  
>  /* We are no longer  connected to a target - check to see if
> @@ -1262,11 +1263,15 @@ wd33c93_intr(struct Scsi_Host *instance)
>  		    hostdata->connected = NULL;
>  		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
>  		hostdata->state = S_UNCONNECTED;
> -		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != SAM_STAT_GOOD)
> -			cmd->result =
> -			    (cmd->result & 0x00ffff) | (DID_ERROR << 16);
> -		else
> -			cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
> +		if (cmd->cmnd[0] == REQUEST_SENSE &&
> +		    cmd->SCp.Status != SAM_STAT_GOOD) {
> +			set_host_byte(cmd, DID_ERROR);
> +			set_status_byte(cmd, SAM_STAT_GOOD);
> +		} else {
> +			set_host_byte(cmd, DID_OK);
> +			translate_msg_byte(cmd, cmd->SCp.Message);
> +			set_status_byte(cmd, cmd->SCp.Status);
> +		}
>  		cmd->scsi_done(cmd);
>  
>  /* We are no longer connected to a target - check to see if
> @@ -1295,14 +1300,15 @@ wd33c93_intr(struct Scsi_Host *instance)
>  			hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
>  			hostdata->state = S_UNCONNECTED;
>  			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
> -			    if (cmd->cmnd[0] == REQUEST_SENSE
> -				&& cmd->SCp.Status != SAM_STAT_GOOD)
> -				cmd->result =
> -				    (cmd->
> -				     result & 0x00ffff) | (DID_ERROR << 16);
> -			else
> -				cmd->result =
> -				    cmd->SCp.Status | (cmd->SCp.Message << 8);
> +			if (cmd->cmnd[0] == REQUEST_SENSE
> +			    && cmd->SCp.Status != SAM_STAT_GOOD) {
> +				set_host_byte(cmd, DID_ERROR);
> +				set_status_byte(cmd, SAM_STAT_GOOD);
> +			} else {
> +				set_host_byte(cmd, DID_OK);
> +				translate_msg_byte(cmd, cmd->SCp.Message);
> +				set_status_byte(cmd, cmd->SCp.Status);
> +			}
>  			cmd->scsi_done(cmd);
>  			break;
>  		case S_PRE_TMP_DISC:
> 

I think these three hunks all have the same mistake, which would force 
SAM_STAT_GOOD.
