Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD27C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 06:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5499561107
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 06:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbhIWGvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 02:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239373AbhIWGvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Sep 2021 02:51:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4172D60E08;
        Thu, 23 Sep 2021 06:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632379793;
        bh=UF/2UxGtg5tTexOwPHRmFbZVMiGLYyw9spNsv9RLCY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1kI9oPIiT8AwM2oAFnIyk99+USYdJIlRcgiV0dMm9mepyRR1b/NEETnKPsmI5DwPx
         FjdGIDjnFRwOpix2RnfJbZiQbmVY307Yowe+T2Y+XPVX5/CUyUdO2isRlRKIzD1n/+
         8KydAMSyHr7rm5JJ7GLk0mjzxXveXYPe+0VIICQM=
Date:   Thu, 23 Sep 2021 08:49:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     20210918000607.450448-1-bvanassche@acm.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        David Kershner <david.kershner@unisys.com>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Song Chen <chensong_2000@189.cn>
Subject: Re: [PATCH 81/84] staging: unisys: visorhba: Call scsi_done()
 directly
Message-ID: <YUwjc43KkY1sSkhX@kroah.com>
References: <20210921173436.3533078-1-bvanassche@acm.org>
 <20210921173436.3533078-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921173436.3533078-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 21, 2021 at 10:34:33AM -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/staging/unisys/visorhba/visorhba_main.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
> index 41f8a72a2a95..6a8fa0587280 100644
> --- a/drivers/staging/unisys/visorhba/visorhba_main.c
> +++ b/drivers/staging/unisys/visorhba/visorhba_main.c
> @@ -327,7 +327,7 @@ static int visorhba_abort_handler(struct scsi_cmnd *scsicmd)
>  	rtn = forward_taskmgmt_command(TASK_MGMT_ABORT_TASK, scsidev);
>  	if (rtn == SUCCESS) {
>  		scsicmd->result = DID_ABORT << 16;
> -		scsicmd->scsi_done(scsicmd);
> +		scsi_done(scsicmd);
>  	}
>  	return rtn;
>  }
> @@ -354,7 +354,7 @@ static int visorhba_device_reset_handler(struct scsi_cmnd *scsicmd)
>  	rtn = forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsidev);
>  	if (rtn == SUCCESS) {
>  		scsicmd->result = DID_RESET << 16;
> -		scsicmd->scsi_done(scsicmd);
> +		scsi_done(scsicmd);
>  	}
>  	return rtn;
>  }
> @@ -383,7 +383,7 @@ static int visorhba_bus_reset_handler(struct scsi_cmnd *scsicmd)
>  	rtn = forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsidev);
>  	if (rtn == SUCCESS) {
>  		scsicmd->result = DID_RESET << 16;
> -		scsicmd->scsi_done(scsicmd);
> +		scsi_done(scsicmd);
>  	}
>  	return rtn;
>  }
> @@ -476,8 +476,7 @@ static int visorhba_queue_command_lck(struct scsi_cmnd *scsicmd,
>  	 */
>  	cmdrsp->scsi.handle = insert_location;
>  
> -	/* save done function that we have call when cmd is complete */
> -	scsicmd->scsi_done = visorhba_cmnd_done;
> +	WARN_ON_ONCE(visorhba_cmnd_done != scsi_done);
>  	/* save destination */
>  	cmdrsp->scsi.vdest.channel = scsidev->channel;
>  	cmdrsp->scsi.vdest.id = scsidev->id;
> @@ -686,8 +685,7 @@ static void visorhba_serverdown_complete(struct visorhba_devdata *devdata)
>  		case CMD_SCSI_TYPE:
>  			scsicmd = pendingdel->sent;
>  			scsicmd->result = DID_RESET << 16;
> -			if (scsicmd->scsi_done)
> -				scsicmd->scsi_done(scsicmd);
> +			scsi_done(scsicmd);
>  			break;
>  		case CMD_SCSITASKMGMT_TYPE:
>  			cmdrsp = pendingdel->sent;
> @@ -853,7 +851,7 @@ static void complete_scsi_command(struct uiscmdrsp *cmdrsp,
>  	else
>  		do_scsi_nolinuxstat(cmdrsp, scsicmd);
>  
> -	scsicmd->scsi_done(scsicmd);
> +	scsi_done(scsicmd);
>  }
>  
>  /*

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
