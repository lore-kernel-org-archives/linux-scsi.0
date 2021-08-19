Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1B1C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 18:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A9AD610A3
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 18:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhHSSh7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 14:37:59 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:40812 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhHSSh7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 14:37:59 -0400
Received: by mail-pj1-f44.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso11934265pjh.5
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 11:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TEJZgYtCqm+iTlIRjeRiEC3DXwL6PK2RQJLhBcsQ6pI=;
        b=G44ANH2J8Z0iXHlO7eUV2eyVcaM/UuQIxDrJiRg7bVN1JAOu0ywqJYCa0g7O2qZL2c
         TF+K5MNqkdn117L8tAf1zurIlbzC5TNyLV/N3I+uSjpe0XF9PARPifY+fNlSyFvH7/H0
         QG970HqF8NdkMzE8uMHkwQ8QnnK5FqDZBblbYSWvEPS5Q5e0GWgAAZGNIT54odhb0qaR
         kUFYjX4/xzCGG3kFwiZxeKARwNkHq54RTMKxSmoXnC09r/leQvHKVY7TRdOETmFWa726
         gxifhyHEkt/lGOQ2BLWZH0NSlwHWWhcOCBd5p4cTB1fSMyX9236CBYyqhTqCzUNU+Ay8
         TBgg==
X-Gm-Message-State: AOAM531cZ2KMVC87WbxCLdLeG/kZdXEIUhgjcq5XfBCFMk611ROMu7HC
        rzCrXMpHz8xpMk0Tp1HcjQM=
X-Google-Smtp-Source: ABdhPJzwwEVaaQHCrBihGXdj7qypaoW3RI/hfu4tUurw0dua8NY7DFhkGRNL2eQKvDnBCtKxwjSkeQ==
X-Received: by 2002:a17:90a:940d:: with SMTP id r13mr139690pjo.124.1629398242282;
        Thu, 19 Aug 2021 11:37:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8b47:c5d7:9562:9d96])
        by smtp.gmail.com with ESMTPSA id w14sm4315251pfn.91.2021.08.19.11.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 11:37:21 -0700 (PDT)
Subject: Re: [PATCH 36/51] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-37-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5d434e7f-9688-0521-e6b6-769b376f1da3@acm.org>
Date:   Thu, 19 Aug 2021 11:37:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817091456.73342-37-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 2:14 AM, Hannes Reinecke wrote:
> diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
> index cf0649e0c3a9..e09c81a54702 100644
> --- a/Documentation/scsi/scsi_eh.rst
> +++ b/Documentation/scsi/scsi_eh.rst
> @@ -215,6 +215,7 @@ considered to fail always.
>   
>       int (* eh_abort_handler)(struct scsi_cmnd *);
>       int (* eh_device_reset_handler)(struct scsi_cmnd *);
> +    int (* eh_target_reset_handler)(struct scsi_target *);
>       int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
>       int (* eh_host_reset_handler)(struct Scsi_Host *);

Inconsistent indentation?

> +    /**
> +    *      eh_target_reset_handler - issue SCSI target reset
> +    *      @starget: identifies SCSI target to be reset
> +    *
> +    *      Returns SUCCESS if command aborted else FAILED
> +    *
> +    *      Locks: None held
> +    *
> +    *      Calling context: kernel thread
> +    *
> +    *      Notes: Invoked from scsi_eh thread. No other commands will be
> +    *      queued on current host during eh.
> +    *
> +    *      Optionally defined in: LLD
> +    **/
> +	int eh_target_reset_handler(struct scsi_target * starget)

The above block comment does not follow the Linux kernel coding style ...

Otherwise this patch looks good to me.

Bart.
