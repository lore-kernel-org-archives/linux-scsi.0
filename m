Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3756C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 21:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353100AbhLAVqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 16:46:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34110 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243105AbhLAVqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 16:46:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 21544CE2105
        for <linux-scsi@vger.kernel.org>; Wed,  1 Dec 2021 21:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76143C53FCC;
        Wed,  1 Dec 2021 21:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638394992;
        bh=ELK584yFCwTITNDnujOCBwKtp8klCZc1fH1loQiZDpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CAuubg191q6f/wKjgnUS4aaBd4O/7wks2mltK9VxSYJ9HwngkGq7ho0/EQesxZdpN
         2nzdjh/UddmJ6D5IyBSBycE4t7IPxgfThlSLiH3ySrjnu3zNivwWA2jgADqG4OHlym
         72+mXIJ90wxt7cK8cCJW5HL9gCEDAtYiIUgUyw2uV4FGDiNcmPU1Nf69u0Ly1JVAD9
         nvN3vYKkyx+9FwK2Q0AfKU7PtUs2FynnOc+GyDmyyFh95D9W/TUNhseqS1A99hf25X
         /OrCZMrZj/5GqA6ZoDlJPMmHpSsp8xaL6O0/Rey2jUsSWFhzhIaqqJ2oXz5i/FGGBj
         EPDeqefZDRnWA==
Date:   Wed, 1 Dec 2021 13:43:09 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 02/17] scsi: core: Fix a race between scsi_done() and
 scsi_times_out()
Message-ID: <20211201214309.GA3836713@dhcp-10-100-145-180.wdc.com>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130233324.1402448-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 30, 2021 at 03:33:09PM -0800, Bart Van Assche wrote:
> This patch restores the behavior of the following algorithm from the legacy
> block layer:
> - Before completing a request, test-and-set REQ_ATOM_COMPLETE atomically.
>   Only call the block driver completion function if that flag was not yet
>   set.
> - Before calling the block driver timeout function, test-and-set
>   REQ_ATOM_COMPLETE atomically. Only call the timeout handler if that flag
>   was not yet set. If that flag was already set, do not restart the timer.
> 
> Cc: Keith Busch <kbusch@kernel.org>
> Reported-by: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: 065990bd198e ("scsi: set timed out out mq requests to complete")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 9cb0f9df621a..cd05f2db3339 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -331,6 +331,14 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>  	enum blk_eh_timer_return rtn = BLK_EH_DONE;
>  	struct Scsi_Host *host = scmd->device->host;
>  
> +	/*
> +	 * scsi_done() may be called concurrently with scsi_times_out(). Only
> +	 * one of these two functions should proceed. Hence return early if
> +	 * scsi_done() won the race.
> +	 */
> +	if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
> +		return BLK_EH_DONE;
> +

If the the timeout handler successfully sets the state to complete, and
the lld returns BLK_EH_RESET_TIMER, who gets to complete this command?

>  	trace_scsi_dispatch_cmd_timeout(scmd);
>  	scsi_log_completion(scmd, TIMEOUT_ERROR);
>  
> @@ -341,20 +349,6 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>  		rtn = host->hostt->eh_timed_out(scmd);
>  
>  	if (rtn == BLK_EH_DONE) {
> -		/*
> -		 * Set the command to complete first in order to prevent a real
> -		 * completion from releasing the command while error handling
> -		 * is using it. If the command was already completed, then the
> -		 * lower level driver beat the timeout handler, and it is safe
> -		 * to return without escalating error recovery.
> -		 *
> -		 * If timeout handling lost the race to a real completion, the
> -		 * block layer may ignore that due to a fake timeout injection,
> -		 * so return RESET_TIMER to allow error handling another shot
> -		 * at this command.
> -		 */
> -		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
> -			return BLK_EH_RESET_TIMER;
>  		if (scsi_abort_command(scmd) != SUCCESS) {
>  			set_host_byte(scmd, DID_TIME_OUT);
>  			scsi_eh_scmd_add(scmd);
