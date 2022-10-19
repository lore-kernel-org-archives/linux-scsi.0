Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AADC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 22:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiJSWRY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 18:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiJSWRX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 18:17:23 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7791F628
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:17:22 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id o64so20842854oib.12
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42mfYFijj0SyYOeStZfwAk76oPLfPxYSOWEmVCuQmkY=;
        b=pqTEB4DE5GPLD1mQk6dlzPVUE1yF3lE7CTj98V46pmELUtKMA7i3wnvPNu6Z9TbzYH
         vmHJ+xHK8e/GMtfuw0nwJkS+Y4umFxHTyT4uQ5VXuTkdt6+FhkgGmXJmAtpg+e/Z1cbX
         K0ZLpApueYG62+cBuPXN/0cOl72G6YmvsEXfEcWC3N9yn5OklrjLnJxhYbLy2EYx9Hrk
         QDAACjpHIscEMksKMkf5e1q09KN/lBNViTN/niIHtfBPR9NgJOv6ptVqaEXBIUcDFLsx
         cXA+uE0fsddpAVo2/R6Md4EKt8YY4L0taGG0MQ4b+yv+7s75wqwgc5Ce7YsS0UHU3fb4
         U/KQ==
X-Gm-Message-State: ACrzQf2xYMtRnTVEm0ENvrrxA5AlppKUEbDWOxK66BvrPFDBSQ+w28q7
        rDkhzW0YiqchkFYHYbxKvcqVdpHfCn0=
X-Google-Smtp-Source: AMsMyM5ai9+M0e6vJXOnrqBEXFw3PhHi0KUS8kaDOEgcbzmLFRou/xfqp7f9RQhyEv+Fuk/qOdZ3tw==
X-Received: by 2002:a17:90b:2803:b0:210:3b5e:62eb with SMTP id qb3-20020a17090b280300b002103b5e62ebmr4030793pjb.95.1666217831638;
        Wed, 19 Oct 2022 15:17:11 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8280:2606:af57:d34? ([2620:15c:211:201:8280:2606:af57:d34])
        by smtp.gmail.com with ESMTPSA id z188-20020a6233c5000000b00561c3ec5346sm11855293pfz.129.2022.10.19.15.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 15:17:10 -0700 (PDT)
Message-ID: <9cc51535-e89b-3be6-84cc-ac5d6e4d08ea@acm.org>
Date:   Wed, 19 Oct 2022 15:17:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 02/36] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-3-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221016195946.7613-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/22 12:59, Mike Christie wrote:
> +/**
> + * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
> + * @scmd: scsi_cmnd to check.
> + *
> + * Return value:
> + *	SCSI_RETURN_NOT_HANDLED - if the caller should process the command
> + *	because there is no error or the passthrough user wanted the default
> + *	error processing.
> + *	SUCCESS, FAILED or NEEDS_RETRY - if this function has determined the
> + *	command should be completed, go through the erorr handler due to
> + *	missing sense or should be retried.

erorr -> error?

> +static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
> +{
> +	struct scsi_failure *failure;
> +	struct scsi_sense_hdr sshdr;
> +	enum scsi_disposition ret;
> +	enum sam_status status;
> +	int i;
> +
> +	if (!scmd->result || !scmd->failures)
> +		return SCSI_RETURN_NOT_HANDLED;
> +
> +	for (i = 0, failure = &scmd->failures[i]; failure->result;
> +	     failure = &scmd->failures[++i]) {

Since the cmd->failures array has a sentinel, can the local variable 'i' 
be left out by changing "failure = &scmd->failures[++i]" into "failure++"?

> +#define SCMD_FAILURE_NONE	0

Is there any patch in this patch series that uses this constant? If not, 
please remove it.

> +#define SCMD_FAILURE_ANY	0x7fffffff

Please consider embedding the word "result" in the name of the above 
constant, e.g. SCMD_ANY_RESULT_FAILURE or SCMD_RESULT_FAILURE_ANY or 
SCMD_FAILURE_RESULT_ANY.

Thanks,

Bart.
