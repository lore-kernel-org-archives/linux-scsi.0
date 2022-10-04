Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0639C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJDW1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJDW1K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:27:10 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656256C139
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:27:09 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id l1so1037406pld.13
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4LZKtXqS9igEU6avKmjQDjxfbOhKt5fzG6EclIjxTSY=;
        b=k05xVn2/iWfINvnvnNgDfVaIkS9uBk4zhcxYVJBbtebupKgM6AGuDzhe4Ckd7Lf1z2
         L1Wo0lIJ7l2txu4rRefymSqSX5q7YmEqKMb8ViAO1p+/yYM4t5hR/G6jAX+BJSR7/WVQ
         oSvZPN006wfHThv097Yk4CCd7VMfVkkGI+8iCI4aX37qCbqA2APRza7V20xlJvlpi3Yh
         uVWbQ2bm4T2ig73ZfZVH1Mxdg32z1DYlXinrGiRqTgMoCX0jSHPLvHo9P4dqSIruVxg/
         sERYrM51WDFp1WvlUtXhp5V5c205TJz1dLhbEbagjWXrylSwXMhK3VDzYJ9Qlh4Xff2l
         sOOQ==
X-Gm-Message-State: ACrzQf2NZHnec11rAc4SQDRn3hnwHUcLg8jr9NoKIYtz63Z5uxdBrQkj
        aJc1TFewPSzQrbQ6bahOySGeNewmV34=
X-Google-Smtp-Source: AMsMyM7Y+gV7yEHSRKdH5FGl1lqNyBqPFTajOgDB35yiGX9LN23zQ1HTe/xLMUh8Dc+TsrmL0Eyc8w==
X-Received: by 2002:a17:90a:4493:b0:20a:a066:9154 with SMTP id t19-20020a17090a449300b0020aa0669154mr1809795pjg.177.1664922428774;
        Tue, 04 Oct 2022 15:27:08 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id v20-20020a170902f0d400b00176cdd7e4c6sm9417737pla.50.2022.10.04.15.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:27:07 -0700 (PDT)
Message-ID: <1c610cd3-505a-df66-dc05-1f7eb3e460af@acm.org>
Date:   Tue, 4 Oct 2022 15:27:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 02/35] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-3-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> +static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
> +{
> +	struct scsi_failure *failure;
> +	struct scsi_sense_hdr sshdr;
> +	enum scsi_disposition ret;
> +	u8 status;

How about using type enum sam_status instead of u8 for 'status'?

> +	int i;
> +
> +

A single blank line to separate declarations and code please.

> +	if (!scmd->result || !scmd->failures)
> +		return SCSI_RETURN_NOT_HANDLED;

A comment that explains what the "not handled" return value indicates
would be welcome, e.g. above the scsi_check_passthrough() function.

> +		if (((__get_status_byte(failure->result)) !=
> +		    SAM_STAT_CHECK_CONDITION) ||
> +		    (failure->sense == SCMD_FAILURE_SENSE_ANY))
> +			goto maybe_retry;

Please do not use more parentheses than necessary. I think that 6
parentheses can be left out from the if-expression without affecting the
readability of the above code.

> @@ -1608,6 +1608,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   
>   	/* Usually overridden by the ULP */
>   	cmd->allowed = 0;
> +	cmd->failures = NULL;
>   	memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
>   	return scsi_cmd_to_driver(cmd)->init_command(cmd);
>   }

Shouldn't the cmd->failures assignment be moved into scsi_initialize_rq()
rather than keeping it in scsi_prepare_cmd() such that the value set by
scsi_execute() is preserved?

> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index bac55decf900..9ab97e48c5c2 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -65,6 +65,24 @@ enum scsi_cmnd_submitter {
>   	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
>   } __packed;
>   
> +#define SCMD_FAILURE_NONE	0
> +#define SCMD_FAILURE_ANY	-1

This is the same value as -EPERM. Would something like 0x7fffffff be a better
choice for SCMD_FAILURE_ANY?

> +struct scsi_failure {
> +	int result;
> +	u8 sense;
> +	u8 asc;
> +	u8 ascq;
> +
> +	s8 allowed;
> +	s8 retries;
> +};

Why has 'retries' type s8 instead of u8?

Thanks,

Bart.
