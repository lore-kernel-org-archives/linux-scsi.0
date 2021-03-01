Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60887C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B65C64E38
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhCAHN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:13:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:57826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhCAHN6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:13:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B589AAAC5;
        Mon,  1 Mar 2021 07:13:16 +0000 (UTC)
Subject: Re: [PATCH 16/24] mpi3mr: hardware workaround for UNMAP commands to
 nvme drives
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-17-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d2a7f9fd-10ad-1f76-3b79-6a81633cfcf9@suse.de>
Date:   Mon, 1 Mar 2021 08:13:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-17-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> The controller hardware can not handle certain unmap commands for NVMe
> drives, this patch adds support in the driver to check those commands and
> handle as appropriate.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 99 +++++++++++++++++++++++++++++++++
>   1 file changed, 99 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 07a7b1efbc4f..742cf45d4878 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2865,6 +2865,100 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
>   	return retval;
>   }
>   
> +/**
> + * mpi3mr_check_return_unmap - Whether an unmap is allowed
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI Command reference
> + *
> + * The controller hardware cannot handle certain unmap commands
> + * for NVMe drives, this routine checks those and return true
> + * and completes the SCSI command with proper status and sense
> + * data.
> + *
> + * Return: TRUE for not  allowed unmap, FALSE otherwise.
> + */
> +static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd)
> +{
> +	unsigned char *buf;
> +	u16 param_len, desc_len;
> +
> +	param_len = get_unaligned_be16(scmd->cmnd + 7);
> +
> +	if (!param_len) {
> +		ioc_warn(mrioc,
> +		    "%s: CDB received with zero parameter length\n",
> +		    __func__);
> +		scsi_print_command(scmd);
> +		scmd->result = DID_OK << 16;
> +		scmd->scsi_done(scmd);
> +		return true;
> +	}
> +
> +	if (param_len < 24) {
> +		ioc_warn(mrioc,
> +		    "%s: CDB received with invalid param_len: %d\n",
> +		    __func__, param_len);
> +		scsi_print_command(scmd);
> +		scmd->result = (DRIVER_SENSE << 24) |
> +		    SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
> +		    0x1A, 0);
> +		scmd->scsi_done(scmd);
> +		return true;
> +	}
> +	if (param_len != scsi_bufflen(scmd)) {
> +		ioc_warn(mrioc,
> +		    "%s: CDB received with param_len: %d bufflen: %d\n",
> +		    __func__, param_len, scsi_bufflen(scmd));
> +		scsi_print_command(scmd);
> +		scmd->result = (DRIVER_SENSE << 24) |
> +		    SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
> +		    0x1A, 0);
> +		scmd->scsi_done(scmd);
> +		return true;
> +	}
> +	buf = kzalloc(scsi_bufflen(scmd), GFP_ATOMIC);
> +	if (!buf) {
> +		scsi_print_command(scmd);
> +		scmd->result = (DRIVER_SENSE << 24) |
> +		    SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
> +		    0x55, 0x03);
> +		scmd->scsi_done(scmd);
> +		return true;
> +	}
> +	scsi_sg_copy_to_buffer(scmd, buf, scsi_bufflen(scmd));
> +	desc_len = get_unaligned_be16(&buf[2]);
> +
> +	if (desc_len < 16) {
> +		ioc_warn(mrioc,
> +		    "%s: Invalid descriptor length in param list: %d\n",
> +		    __func__, desc_len);
> +		scsi_print_command(scmd);
> +		scmd->result = (DRIVER_SENSE << 24) |
> +		    SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
> +		    0x26, 0);
> +		scmd->scsi_done(scmd);
> +		kfree(buf);
> +		return true;
> +	}
> +
> +	if (param_len > (desc_len + 8)) {
> +		scsi_print_command(scmd);
> +		ioc_warn(mrioc,
> +		    "%s: Truncating param_len(%d) to desc_len+8(%d)\n",
> +		    __func__, param_len, (desc_len + 8));
> +		param_len = desc_len + 8;
> +		put_unaligned_be16(param_len, scmd->cmnd+7);
> +		scsi_print_command(scmd);
> +	}
> +
> +	kfree(buf);
> +	return false;
> +}
>   
>   /**
>    * mpi3mr_allow_scmd_to_fw - Command is allowed during shutdown
> @@ -2957,6 +3051,11 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
>   		goto out;
>   	}
>   
> +	if ((scmd->cmnd[0] == UNMAP) &&
> +	    (stgt_priv_data->dev_type == MPI3_DEVICE_DEVFORM_PCIE) &&
> +	    mpi3mr_check_return_unmap(mrioc, scmd))
> +		goto out;
> +
>   	host_tag = mpi3mr_host_tag_for_scmd(mrioc, scmd);
>   	if (host_tag == MPI3MR_HOSTTAG_INVALID) {
>   		scmd->result = DID_ERROR << 16;
> 
One _could_ have modified the firmware instead ... oh well.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
