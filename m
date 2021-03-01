Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC90C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 567C264E40
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhCAHSW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:18:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:58882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232125AbhCAHSU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:18:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F0575AD29;
        Mon,  1 Mar 2021 07:17:37 +0000 (UTC)
Subject: Re: [PATCH 20/24] mpi3mr: wait for pending IO completions upon
 detection of VD IO timeout
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-21-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9dc71c8b-0ee1-1c98-775d-af0ee28a0381@suse.de>
Date:   Mon, 1 Mar 2021 08:17:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-21-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Wait for (default 180 seconds) host IO completion if IO timeout is detected
> on VDs
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
>   drivers/scsi/mpi3mr/mpi3mr_fw.c |  2 ++
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 45 +++++++++++++++++++++++++++++++++
>   3 files changed, 48 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 1d51e42778f6..5554b0e49a58 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -102,6 +102,7 @@ extern struct list_head mrioc_list;
>   #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
>   #define MPI3MR_TSUPDATE_INTERVAL		900
>   #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
> +#define	MPI3MR_RAID_ERRREC_RESET_TIMEOUT	180
>   
>   #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
>   
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 36a68c488019..b27e44f78544 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -3749,6 +3749,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
>   		}
>   	}
>   
> +	mpi3mr_wait_for_host_io(mrioc, MPI3MR_RESET_HOST_IOWAIT_TIMEOUT);
> +
>   	mpi3mr_ioc_disable_intr(mrioc);
>   
>   	if (snapdump) {
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 8e665c70604d..1708aca1a5cd 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2437,6 +2437,43 @@ static void mpi3mr_print_pending_host_io(struct mpi3mr_ioc *mrioc)
>   	    mpi3mr_print_scmd, (void *)mrioc);
>   }
>   
> +/**
> + * mpi3mr_wait_for_host_io - block for I/Os to complete
> + * @mrioc: Adapter instance reference
> + * @timeout: time out in seconds
> + * Waits for pending I/Os for the given adapter to complete or
> + * to hit the timeout.
> + *
> + * Return: Nothing
> + */
> +void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout)
> +{
> +	enum mpi3mr_iocstate iocstate;
> +	int i = 0;
> +
> +	iocstate = mpi3mr_get_iocstate(mrioc);
> +	if (iocstate != MRIOC_STATE_READY)
> +		return;
> +
> +	if (!mpi3mr_get_fw_pending_ios(mrioc))
> +		return;
> +	ioc_info(mrioc,
> +	    "%s :Waiting for %d seconds prior to reset for %d I/O\n",
> +	    __func__, timeout, mpi3mr_get_fw_pending_ios(mrioc));
> +
> +	for (i = 0; i < timeout; i++) {
> +		if (!mpi3mr_get_fw_pending_ios(mrioc))
> +			break;
> +		iocstate = mpi3mr_get_iocstate(mrioc);
> +		if (iocstate != MRIOC_STATE_READY)
> +			break;
> +		msleep(1000);
> +	}
> +
> +	ioc_info(mrioc, "%s :Pending I/Os after wait is: %d\n", __func__,
> +	    mpi3mr_get_fw_pending_ios(mrioc));
> +}
> +
>   /**
>    * mpi3mr_eh_host_reset - Host reset error handling callback
>    * @scmd: SCSI command reference
> @@ -2462,6 +2499,14 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
>   		dev_type = stgt_priv_data->dev_type;
>   	}
>   
> +	if (dev_type == MPI3_DEVICE_DEVFORM_VD) {
> +		mpi3mr_wait_for_host_io(mrioc,
> +		    MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
> +		if (!mpi3mr_get_fw_pending_ios(mrioc)) {
> +			retval = SUCCESS;
> +			goto out;
> +		}
> +	}
>   	mpi3mr_print_pending_host_io(mrioc);
>   	ret = mpi3mr_soft_reset_handler(mrioc,
>   	    MPI3MR_RESET_FROM_EH_HOS, 1);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
