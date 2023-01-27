Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F352C61DA4
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 15:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbjA0PfE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 10:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjA0PfD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 10:35:03 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BDB8348E;
        Fri, 27 Jan 2023 07:35:01 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C9C411F74B;
        Fri, 27 Jan 2023 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674833699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uRZ+OCkJMnLZ9NFOSGl06xuMvvOCjtAAikt6fJOoX1Y=;
        b=bBCQKPg+e/aWdNanUuQjRid8VPDWsMgiJ5XKKSOBf1w5+oMiZRska/IfwJuBFEotlfDzK8
        8/VFxY2Kt5YXbkUf8h2aUD/9JG4gU594X4sAwV/m0ZBGvfokgoLgSRnlOTS0eZe0chQ3/a
        suS6UR35OP5fycu1HAascOEUn0z3MJU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674833699;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uRZ+OCkJMnLZ9NFOSGl06xuMvvOCjtAAikt6fJOoX1Y=;
        b=RCRAhVw/UTPRtPsAe51dqo/LLfebfsI1xtVJebd/rlcvETmZO+iEs+NDwqm8tSIOpfAv4Y
        NagJtVV0iHGVs/CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B72F1138E3;
        Fri, 27 Jan 2023 15:34:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Yih0LCPv02OBaQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 15:34:59 +0000
Message-ID: <f4cca0e6-9c3b-5f0a-c125-fb3960d35e5e@suse.de>
Date:   Fri, 27 Jan 2023 16:34:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 09/18] scsi: sd: handle read/write CDL timeout failures
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-10-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-10-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:02, Niklas Cassel wrote:
> Commands using a duration limit descriptor that has limit policies set
> to a value other than 0x0 may be failed by the device if one of the
> limits are exceeded. For such commands, since the failure is the result
> of the user duration limit configuration and workload, the commands
> should not be retried and terminated immediately. Furthermore, to allow
> the user to differentiate these "soft" failures from hard errors due to
> hardware problem, a different error code than EIO should be returned.
> 
> There are 2 cases to consider:
> (1) The failure is due to a limit policy failing the command with a
> check condition sense key, that is, any limit policy other than 0xD.
> For this case, scsi_check_sense() is modified to detect failures with
> the ABORTED COMMAND sense key and the COMMAND TIMEOUT BEFORE PROCESSING
> or COMMAND TIMEOUT DURING PROCESSING or COMMAND TIMEOUT DURING
> PROCESSING DUE TO ERROR RECOVERY additional sense code. For these
> failures, a SUCCESS disposition is returned so that
> scsi_finish_command() is called to terminate the command.
> 
> (2) The failure is due to a limit policy set to 0xD, which result in the
> command being terminated with a GOOD status, COMPLETED sense key, and
> DATA CURRENTLY UNAVAILABLE additional sense code. To handle this case,
> the scsi_check_sense() is modified to return a SUCCESS disposition so
> that scsi_finish_command() is called to terminate the command.
> In addition, scsi_decide_disposition() has to be modified to see if a
> command being terminated with GOOD status has sense data.
> This is as defined in SCSI Primary Commands - 6 (SPC-6), so all
> according to spec, even if GOOD status commands were not checked before.
> 
> If scsi_check_sense() detects sense data representing a duration limit,
> scsi_check_sense() will set the newly introduced SCSI ML byte
> SCSIML_STAT_DL_TIMEOUT. This SCSI ML byte is checked in
> scsi_noretry_cmd(), so that a command that failed because of a CDL
> timeout cannot be retried. The SCSI ML byte is also checked in
> scsi_result_to_blk_status() to complete the command request with the
> BLK_STS_DURATION_LIMIT status, which result in the user seeing ETIME
> errors for the failed commands.
> 
> Co-developed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/scsi/scsi_error.c | 46 +++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_lib.c   |  4 ++++
>   drivers/scsi/scsi_priv.h  |  1 +
>   3 files changed, 51 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index cf5ec5f5f4f6..9988539bc348 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -536,6 +536,7 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
>    */
>   enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>   {
> +	struct request *req = scsi_cmd_to_rq(scmd);
>   	struct scsi_device *sdev = scmd->device;
>   	struct scsi_sense_hdr sshdr;
>   
> @@ -595,6 +596,22 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>   		if (sshdr.asc == 0x10) /* DIF */
>   			return SUCCESS;
>   
> +		/*
> +		 * Check aborts due to command duration limit policy:
> +		 * ABORTED COMMAND additional sense code with the
> +		 * COMMAND TIMEOUT BEFORE PROCESSING or
> +		 * COMMAND TIMEOUT DURING PROCESSING or
> +		 * COMMAND TIMEOUT DURING PROCESSING DUE TO ERROR RECOVERY
> +		 * additional sense code qualifiers.
> +		 */
> +		if (sshdr.asc == 0x2e &&
> +		    sshdr.ascq >= 0x01 && sshdr.ascq <= 0x03) {
> +			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
> +			req->cmd_flags |= REQ_FAILFAST_DEV;
> +			req->rq_flags |= RQF_QUIET;
> +			return SUCCESS;
> +		}
> +
>   		if (sshdr.asc == 0x44 && sdev->sdev_bflags & BLIST_RETRY_ITF)
>   			return ADD_TO_MLQUEUE;
>   		if (sshdr.asc == 0xc1 && sshdr.ascq == 0x01 &&
> @@ -691,6 +708,15 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>   		}
>   		return SUCCESS;
>   
> +	case COMPLETED:
> +		if (sshdr.asc == 0x55 && sshdr.ascq == 0x0a) {
> +			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
> +			req->cmd_flags |= REQ_FAILFAST_DEV;
> +			req->rq_flags |= RQF_QUIET;
> +			return SUCCESS;

You can kill this line, will be done anyway.

> +		}
> +		return SUCCESS;
> +
>   	default:
>   		return SUCCESS;
>   	}
> @@ -785,6 +811,14 @@ static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
>   	switch (get_status_byte(scmd)) {
>   	case SAM_STAT_GOOD:
>   		scsi_handle_queue_ramp_up(scmd->device);
> +		if (scmd->sense_buffer && SCSI_SENSE_VALID(scmd))
> +			/*
> +			 * If we have sense data, call scsi_check_sense() in
> +			 * order to set the correct SCSI ML byte (if any).
> +			 * No point in checking the return value, since the
> +			 * command has already completed successfully.
> +			 */
> +			scsi_check_sense(scmd);

I am every so slightly nervous here.
We never checked the sense code for GOOD status, so heaven knows if 
there are devices out there which return something here.
And you have checked that we've cleared the sense code before submitting 
(or retrying, even), right?

>   		fallthrough;
>   	case SAM_STAT_COMMAND_TERMINATED:
>   		return SUCCESS;
> @@ -1807,6 +1841,10 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>   		return !!(req->cmd_flags & REQ_FAILFAST_DRIVER);
>   	}
>   
> +	/* Never retry commands aborted due to a duration limit timeout */
> +	if (scsi_ml_byte(scmd->result) == SCSIML_STAT_DL_TIMEOUT)
> +		return true;
> +
>   	if (!scsi_status_is_check_condition(scmd->result))
>   		return false;
>   
> @@ -1966,6 +2004,14 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
>   		if (scmd->cmnd[0] == REPORT_LUNS)
>   			scmd->device->sdev_target->expecting_lun_change = 0;
>   		scsi_handle_queue_ramp_up(scmd->device);
> +		if (scmd->sense_buffer && SCSI_SENSE_VALID(scmd))
> +			/*
> +			 * If we have sense data, call scsi_check_sense() in
> +			 * order to set the correct SCSI ML byte (if any).
> +			 * No point in checking the return value, since the
> +			 * command has already completed successfully.
> +			 */
> +			scsi_check_sense(scmd);
>   		fallthrough;
>   	case SAM_STAT_COMMAND_TERMINATED:
>   		return SUCCESS;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e1a021dd4da2..406952e72a68 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -600,6 +600,8 @@ static blk_status_t scsi_result_to_blk_status(int result)
>   		return BLK_STS_MEDIUM;
>   	case SCSIML_STAT_TGT_FAILURE:
>   		return BLK_STS_TARGET;
> +	case SCSIML_STAT_DL_TIMEOUT:
> +		return BLK_STS_DURATION_LIMIT;
>   	}
>   
>   	switch (host_byte(result)) {
> @@ -797,6 +799,8 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
>   				blk_stat = BLK_STS_ZONE_OPEN_RESOURCE;
>   			}
>   			break;
> +		case COMPLETED:
> +			fallthrough;
>   		default:
>   			action = ACTION_FAIL;
>   			break;
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 74324fba4281..f42388ecb024 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -27,6 +27,7 @@ enum scsi_ml_status {
>   	SCSIML_STAT_NOSPC		= 0x02,	/* Space allocation on the dev failed */
>   	SCSIML_STAT_MED_ERROR		= 0x03,	/* Medium error */
>   	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
> +	SCSIML_STAT_DL_TIMEOUT		= 0x05, /* Command Duration Limit timeout */
>   };
>   
>   static inline u8 scsi_ml_byte(int result)

Cheers,

Hannes

