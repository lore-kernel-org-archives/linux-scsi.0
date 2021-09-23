Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE03C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 06:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5059260E08
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 06:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbhIWGvj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 02:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239456AbhIWGvi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Sep 2021 02:51:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 236C961107;
        Thu, 23 Sep 2021 06:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632379807;
        bh=hHWN+TfDAPOD7qatdLGVEtQ+KJQ8XqxddymrhiGs8BA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V/RctXiYoa3KwKUs/0U/UaDg2DpxVOBfjlmB8O1boa83YWUWVjb5xh8hrkox2LuLu
         zGHF20H29WOrgbO8eEOeFSgIBUFU86qlk9d3Oyx4p8IeKfflKkXTa+u+40JN6EFzK3
         k+ISMht0FAOen6/wITUzkrfqYgEMKat5bRhr7S7E=
Date:   Thu, 23 Sep 2021 08:49:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 80/84] staging: rts5208: Call scsi_done() directly
Message-ID: <YUwjg1ojIXm4Go1p@kroah.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210922162603.476745-1-bvanassche@acm.org>
 <20210922162603.476745-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922162603.476745-2-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 22, 2021 at 09:25:58AM -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/staging/rts5208/rtsx.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
> index 898add4d1fc8..f1136f6bcee2 100644
> --- a/drivers/staging/rts5208/rtsx.c
> +++ b/drivers/staging/rts5208/rtsx.c
> @@ -140,7 +140,6 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
>  	}
>  
>  	/* enqueue the command and wake up the control thread */
> -	srb->scsi_done = done;
>  	chip->srb = srb;
>  	complete(&dev->cmnd_ready);
>  
> @@ -423,7 +422,7 @@ static int rtsx_control_thread(void *__dev)
>  
>  		/* indicate that the command is done */
>  		else if (chip->srb->result != DID_ABORT << 16) {
> -			chip->srb->scsi_done(chip->srb);
> +			scsi_done(chip->srb);
>  		} else {
>  skip_for_abort:
>  			dev_err(&dev->pci->dev, "scsi command aborted\n");
> @@ -635,7 +634,7 @@ static void quiesce_and_remove_host(struct rtsx_dev *dev)
>  	if (chip->srb) {
>  		chip->srb->result = DID_NO_CONNECT << 16;
>  		scsi_lock(host);
> -		chip->srb->scsi_done(dev->chip->srb);
> +		scsi_done(dev->chip->srb);
>  		chip->srb = NULL;
>  		scsi_unlock(host);
>  	}

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
