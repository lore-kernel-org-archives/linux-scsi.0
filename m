Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01FAC3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 20:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245404AbiHIUNe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 16:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245325AbiHIUNd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 16:13:33 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF331F2FE
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 13:13:31 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id gj1so12796557pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2022 13:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=CN87CWcTKkVb77YE07MqFghlq8sKh7r/eX4RN5eGHbE=;
        b=Ov8ZNAogGUJpEMy/vWnBNwbgEqLiVyRo3orRSbhsm/ujgAV09KUKwcBZPDfOInGyuc
         zUMJxLrWYBDdjsfQI6oxOLdlHQ7sLwjbYys9zE2/xT/Q0kVpyYYygteoo/7tHq8NDrX4
         4tlSQJQl9Q77Fs8Z4BbRb6WmacoPDpeflOD0a6ta4fL/fa2LJFn3LdSf+/ngfnueIf9a
         XrsNg0HlNA4zZAU9a0S5Dsdox/77P7pGskoKu5+n5l4Y18JvFc7BhGs/7ekvn9xT78Qs
         sT34K30WyuO3jt3W+9L6bbcVpl2ebTuPkUG8isRG2FVI0uJLiTP9IHrggZF724jD12V0
         agzQ==
X-Gm-Message-State: ACgBeo3YTdehm2RHdTCleMZe3CAlymwvXvaGA3XusHr7gBX3BmOpPczT
        cIRWPS/SYkG/r71jR0jRLjONMKyEL38=
X-Google-Smtp-Source: AA6agR7QD+sHInMIbapkP/aWow17myY4f7Nc+dm54fOYd7Wv83+HPuPS9sENJAW4znya3ahxCFbvtA==
X-Received: by 2002:a17:90b:1c0d:b0:1f5:4ddf:1607 with SMTP id oc13-20020a17090b1c0d00b001f54ddf1607mr206777pjb.90.1660076010418;
        Tue, 09 Aug 2022 13:13:30 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d? ([2620:15c:211:201:61e9:2f41:c2d4:73d])
        by smtp.gmail.com with ESMTPSA id l6-20020a170903120600b0016c29dcf1f7sm11444938plh.122.2022.08.09.13.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:13:29 -0700 (PDT)
Message-ID: <67db6828-0e1b-83ad-9c4e-1fbd736e39b4@acm.org>
Date:   Tue, 9 Aug 2022 13:13:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 08/10] scsi: Add error codes for internal scsi-ml use.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, jgross@suse.com,
        njavali@marvell.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, stefanha@redhat.com, oneukum@suse.com,
        manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-9-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220804034100.121125-9-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/3/22 20:40, Mike Christie wrote:
> If a driver returns:
> 
> DID_TARGET_FAILURE
> DID_NEXUS_FAILURE
> DID_ALLOC_FAILURE
> DID_MEDIUM_ERROR
> 
> we hit a couple bugs:
> 
> 1. The SCSI error handler runs because scsi_decide_disposition has no
> case statements for them and we return FAILED.
> 
> 2. For SG IO the userspace app gets a success status instead of failed,
> because scsi_result_to_blk_status clears those errors.
> 
> This patch adds a new internal error code byte for use by scsi-ml. It
> will be used instead of the above error codes, so we don't have to play
> that clearing the host code game in scsi_result_to_blk_status and
> drivers cannot accidentally use them.
> 
> The next patch will then remove the internal users of the above codes and
> convert us to use the new ones.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_error.c |  5 +++++
>   drivers/scsi/scsi_lib.c   | 22 ++++++++++++++++++++++
>   drivers/scsi/scsi_priv.h  | 11 +++++++++++
>   3 files changed, 38 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 947d98a0565f..4adadd3fb410 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -514,6 +514,11 @@ static void scsi_report_sense(struct scsi_device *sdev,
>   	}
>   }
>   
> +static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
> +{
> +	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
> +}
> +
>   /**
>    * scsi_check_sense - Examine scsi cmd sense
>    * @scmd:	Cmd to have sense checked.
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2aca0a838ca5..eaf4865a2cb6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -576,6 +576,11 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>   	return false;
>   }
>   
> +static inline u8 get_scsi_ml_byte(int result)
> +{
> +	return (result >> 8) & 0xff;
> +}
> +
>   /**
>    * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
>    * @cmd:	SCSI command
> @@ -586,6 +591,23 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>    */
>   static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
>   {
> +	/*
> +	 * Check the scsi-ml byte first in case we converted a host or status
> +	 * byte.
> +	 */
> +	switch (get_scsi_ml_byte(result)) {
> +	case SCSIML_STAT_OK:
> +		break;
> +	case SCSIML_STAT_RESV_CONFLICT:
> +		return BLK_STS_NEXUS;
> +	case SCSIML_STAT_SPACE_ALLOC:
> +		return BLK_STS_NOSPC;
> +	case SCSIML_STAT_MED_ERROR:
> +		return BLK_STS_MEDIUM;
> +	case SCSIML_STAT_TGT_FAILURE:
> +		return BLK_STS_TARGET;
> +	}
> +
>   	switch (host_byte(result)) {
>   	case DID_OK:
>   		if (scsi_status_is_good(result))
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 5c4786310a31..9d2d32bf0171 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -18,6 +18,17 @@ struct scsi_nl_hdr;
>   
>   #define SCSI_CMD_RETRIES_NO_LIMIT -1
>   
> +/*
> + * Error codes used by scsi-ml internally. These must not be used by drivers.
> + */
> +enum scsi_ml_status {
> +	SCSIML_STAT_OK			= 0x00,
> +	SCSIML_STAT_RESV_CONFLICT	= 0x01,	/* Reservation conflict */
> +	SCSIML_STAT_SPACE_ALLOC		= 0x02,	/* Space allocation on the dev failed */
> +	SCSIML_STAT_MED_ERROR		= 0x03,	/* Medium error */
> +	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
> +};

How about changing "SPACE_ALLOC" into "ENOSPC"?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
