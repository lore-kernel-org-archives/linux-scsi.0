Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6DCC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 09:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 052BF61445
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 09:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbhDVJgD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 05:36:03 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44164 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbhDVJgD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 05:36:03 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 7D15628290;
        Thu, 22 Apr 2021 05:35:24 -0400 (EDT)
Date:   Thu, 22 Apr 2021 19:35:24 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 16/42] NCR5380: Fold SCSI message ABORT onto DID_ABORT
In-Reply-To: <20210421174749.11221-17-hare@suse.de>
Message-ID: <b329f340-62f5-a8f3-b18d-8a584c74a093@nippy.intranet>
References: <20210421174749.11221-1-hare@suse.de> <20210421174749.11221-17-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2021, Hannes Reinecke wrote:

> The message byte can take only two values, COMMAND_COMPLETE and ABORT.
> So we can easily map ABORT to DID_ABORT and do not set the message byte.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/NCR5380.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 855edda9db41..76b4dce22e03 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -1827,7 +1827,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					hostdata->connected = NULL;
>  					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
>  
> -					set_msg_byte(cmd, cmd->SCp.Message);
> +					if (cmd->SCp.Message == ABORT)
> +						set_host_byte(cmd, DID_ABORT);
>  					set_status_byte(cmd, cmd->SCp.Status);
>  
>  					set_resid_from_SCp(cmd);
> 

Can that be expressed more succinctly? E.g.

                                 switch (tmp) {
                                 case ABORT:
+					set_host_byte(cmd, DID_ABORT);
                                 case COMMAND_COMPLETE:

Should this be folded into the preceding patch?
