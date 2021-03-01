Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8AFC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDBD264DDC
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhCAHMb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:12:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:57476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232288AbhCAHMT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:12:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8B3F5AE5C;
        Mon,  1 Mar 2021 07:11:35 +0000 (UTC)
Subject: Re: [PATCH 15/24] mpi3mr: allow certain commands during pci-remove
 hook
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-16-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1459a7b4-9ebd-bcd4-d071-33cb608c417e@suse.de>
Date:   Mon, 1 Mar 2021 08:11:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-16-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> This patch allows SSU and Sync Cache commands to be sent to the controller
> instead of driver returning DID_NO_CONNECT during driver unload to flush
> any cached data from the drive.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 24 +++++++++++++++++++++++-
>   1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 6f19e5392433..07a7b1efbc4f 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2865,6 +2865,27 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
>   	return retval;
>   }
>   
> +
> +/**
> + * mpi3mr_allow_scmd_to_fw - Command is allowed during shutdown
> + * @scmd: SCSI Command reference
> + *
> + * Checks whether a CDB is allowed during shutdown or not.
> + *
> + * Return: TRUE for allowed commands, FALSE otherwise.
> + */
> +
> +inline bool mpi3mr_allow_scmd_to_fw(struct scsi_cmnd *scmd)
> +{
> +	switch (scmd->cmnd[0]) {
> +	case SYNCHRONIZE_CACHE:
> +	case START_STOP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>   /**
>    * mpi3mr_qcmd - I/O request despatcher
>    * @shost: SCSI Host reference
> @@ -2900,7 +2921,8 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
>   		goto out;
>   	}
>   
> -	if (mrioc->stop_drv_processing) {
> +	if (mrioc->stop_drv_processing &&
> +	    !(mpi3mr_allow_scmd_to_fw(scmd))) {
>   		scmd->result = DID_NO_CONNECT << 16;
>   		scmd->scsi_done(scmd);
>   		goto out;
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
