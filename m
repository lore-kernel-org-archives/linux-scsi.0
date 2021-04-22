Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143BFC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 09:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B48661445
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 09:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhDVJgn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 05:36:43 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44180 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbhDVJgl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 05:36:41 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 39C042AB7C;
        Thu, 22 Apr 2021 05:36:04 -0400 (EDT)
Date:   Thu, 22 Apr 2021 19:36:04 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 15/42] NCR5380: use SCSI result accessors
In-Reply-To: <20210421174749.11221-16-hare@suse.de>
Message-ID: <b2a899f-d6a8-165f-63e1-c3b8e642289a@nippy.intranet>
References: <20210421174749.11221-1-hare@suse.de> <20210421174749.11221-16-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2021, Hannes Reinecke wrote:

> Use accessors to set the SCSI result.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/NCR5380.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index d7594b794d3c..855edda9db41 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -538,7 +538,7 @@ static void complete_cmd(struct Scsi_Host *instance,
>  
>  	if (hostdata->sensing == cmd) {
>  		/* Autosense processing ends here */
> -		if (status_byte(cmd->result) != GOOD) {
> +		if (get_status_byte(cmd) != SAM_STAT_GOOD) {
>  			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
>  		} else {
>  			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
> @@ -567,18 +567,19 @@ static int NCR5380_queue_command(struct Scsi_Host *instance,
>  	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
>  	unsigned long flags;
>  
> +	set_host_byte(cmd, DID_OK);
> +	set_status_byte(cmd, SAM_STAT_GOOD);
>  #if (NDEBUG & NDEBUG_NO_WRITE)
>  	switch (cmd->cmnd[0]) {
>  	case WRITE_6:
>  	case WRITE_10:
>  		shost_printk(KERN_DEBUG, instance, "WRITE attempted with NDEBUG_NO_WRITE set\n");
> -		cmd->result = (DID_ERROR << 16);
> +		set_host_byte(cmd, DID_ERROR);
>  		cmd->scsi_done(cmd);
>  		return 0;
>  	}
>  #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
>  
> -	cmd->result = 0;
>  

Please remove the superfluous blank line.
