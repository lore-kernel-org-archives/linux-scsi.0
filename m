Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FC8C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 17:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIVRCx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 13:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiIVRCw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 13:02:52 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB9830F7A
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 10:02:51 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id t70so9740245pgc.5
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 10:02:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8C/9HZqcQraX8ZhadiT38RZQ49ZOltwCalVfBaxmxCM=;
        b=oC2TNTtkN5wXZt66VVQVdfdXwKc4dE0HgSs75I898obp6PVn6XaAhYQdEFKGJRHxJY
         /qA1g00iaBmvO4EfH9fg+jWdi79aNX0iY9KHEW3gfS6UkE6mWYfhUQrn2yN88TpCJiyf
         ldCY1a0BfDy4e7aUC42VymMiGHb2Rxm9UlU9kRsAgwkQvU7yK/Q2MNZsu8V3JZvKb0zG
         1Ua02RPdE+ze/wy/2Bgh1hLBtf1V21eO8hNEOndc6hv+SoedTuoFiTjAU283fwK1yLVB
         apfuLjOWebNCIVOpLl1PbJQnz8nIREItAP0Gg+y4jGShlwXwm2CHmltbk66Jg9jMyZQe
         WkVQ==
X-Gm-Message-State: ACrzQf1hbE8wU59OZFdde1HpBj+4Tf+o+2fJehR4SB6TbIUuo1Gamds4
        YWxLQPuC3Fd39kYlZy7sC1E/I5A7ohA=
X-Google-Smtp-Source: AMsMyM75iRCvAIWlyT4k2NCtkqMXCpHIc0g9q6yZwb87X0n92ACV0WBWbxsL2/LavMf1fWj7OZZ/hg==
X-Received: by 2002:a05:6a00:e13:b0:53e:7528:d014 with SMTP id bq19-20020a056a000e1300b0053e7528d014mr4618919pfb.33.1663866170942;
        Thu, 22 Sep 2022 10:02:50 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:7c7b:f882:f26a:23ca? ([2620:15c:211:201:7c7b:f882:f26a:23ca])
        by smtp.gmail.com with ESMTPSA id 9-20020a17090a0f0900b001f8c532b93dsm32753pjy.15.2022.09.22.10.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 10:02:50 -0700 (PDT)
Message-ID: <1a152b62-7124-4a80-b4b6-1d927aaeb175@acm.org>
Date:   Thu, 22 Sep 2022 10:02:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH RFC 03/22] scsi: Take an array of failures for passthrough
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220922100704.753666-1-michael.christie@oracle.com>
 <20220922100704.753666-4-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220922100704.753666-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/22 03:06, Mike Christie wrote:
> @@ -458,24 +459,26 @@ extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>   			int data_direction, void *buffer, unsigned bufflen,
>   			unsigned char *sense, struct scsi_sense_hdr *sshdr,
>   			int timeout, int retries, blk_opf_t flags,
> -			req_flags_t rq_flags, int *resid);
> +			req_flags_t rq_flags, int *resid,
> +			struct scsi_failure *failures);
>   /* Make sure any sense buffer is the correct size. */
>   #define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
> -		     sshdr, timeout, retries, flags, rq_flags, resid)	\
> +		     sshdr, timeout, retries, flags, rq_flags, resid,	\
> +		     failures)						\
>   ({									\
>   	BUILD_BUG_ON((sense) != NULL &&					\
>   		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
>   	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
>   		       sense, sshdr, timeout, retries, flags, rq_flags,	\
> -		       resid);						\
> +		       resid, failures);				\
>   })
>   static inline int scsi_execute_req(struct scsi_device *sdev,
>   	const unsigned char *cmd, int data_direction, void *buffer,
>   	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
> -	int retries, int *resid)
> +	int retries, int *resid, struct scsi_failure *failures)
>   {
> -	return scsi_execute(sdev, cmd, data_direction, buffer,
> -		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
> +	return scsi_execute(sdev, cmd, data_direction, buffer, bufflen, NULL,
> +			    sshdr, timeout, retries,  0, 0, resid, failures);
>   }

Both scsi_execute() and scsi_execute_req() have way too many arguments. 
Please do not add any new arguments but instead convert the existing and 
new arguments into a struct. That will allow callers to be written e.g. 
as follows:

	scsi_execute((struct scsi_execute_args){.sdev = ..., .cmd = ...,
			...});

Thanks,

Bart.
