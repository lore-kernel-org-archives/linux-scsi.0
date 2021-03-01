Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0CBC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F077464E31
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhCAHBf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:01:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:49674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232256AbhCAHBa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:01:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0FB3BAE5C;
        Mon,  1 Mar 2021 07:00:46 +0000 (UTC)
Subject: Re: [PATCH 12/24] mpi3mr: add bios_param shost template hook
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-13-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bf5265ac-1531-a8d3-abb4-d62d1bd72a5b@suse.de>
Date:   Mon, 1 Mar 2021 08:00:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-13-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 40 +++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 4d94352a4d48..7e0eacf45d84 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2078,6 +2078,45 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
>   	return ret;
>   }
>   
> +/**
> + * mpi3mr_bios_param - BIOS param callback
> + * @sdev: SCSI device reference
> + * @bdev: Block device reference
> + * @capacity: Capacity in logical sectors
> + * @params: Parameter array
> + *
> + * Just the parameters with heads/secots/cylinders.
> + *
> + * Return: 0 always
> + */
> +static int mpi3mr_bios_param(struct scsi_device *sdev,
> +	struct block_device *bdev, sector_t capacity, int params[])
> +{
> +	int heads;
> +	int sectors;
> +	sector_t cylinders;
> +	ulong dummy;
> +
> +	heads = 64;
> +	sectors = 32;
> +
> +	dummy = heads * sectors;
> +	cylinders = capacity;
> +	sector_div(cylinders, dummy);
> +
> +	if ((ulong)capacity >= 0x200000) {
> +		heads = 255;
> +		sectors = 63;
> +		dummy = heads * sectors;
> +		cylinders = capacity;
> +		sector_div(cylinders, dummy);
> +	}
> +
> +	params[0] = heads;
> +	params[1] = sectors;
> +	params[2] = cylinders;
> +	return 0;
> +}
>   
>   /**
>    * mpi3mr_map_queues - Map queues callback handler
> @@ -2511,6 +2550,7 @@ static struct scsi_host_template mpi3mr_driver_template = {
>   	.slave_destroy			= mpi3mr_slave_destroy,
>   	.scan_finished			= mpi3mr_scan_finished,
>   	.scan_start			= mpi3mr_scan_start,
> +	.bios_param			= mpi3mr_bios_param,
>   	.map_queues			= mpi3mr_map_queues,
>   	.no_write_same			= 1,
>   	.can_queue			= 1,
> 
OMG. I had hoped we could kill this eventually.
Oh well.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
