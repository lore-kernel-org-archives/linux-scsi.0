Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F614C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 19:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbiLLTpT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 14:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbiLLTpS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 14:45:18 -0500
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E6B11465
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 11:45:17 -0800 (PST)
Received: by mail-qt1-f179.google.com with SMTP id c7so2401061qtw.8
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 11:45:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VtzScB9qi8ZwQLH9cYsbLFlcuKsz6jnTnPLDd5aqsxQ=;
        b=7Tk2WyPgXl0vPq8fi1ZwC/h9/MNGEbRgv7AwYZBixhMPGhtWTWi1CRsJoFjqfm7BDw
         YAneY4/FasZhTQHjPNw6bz3bBAe//hg6Bn+WpLJDhrO1uWurjoFZG/CJIRBvMgN4Hjuo
         q2fhD9RIR862QQxS1kL7l4XYJKV8o1a3ZJQmbGQhQaFK76i/mswqkDPC/LVL4F6sVl0U
         1fBR66KqVjImimZXGb7tSrKhZ7RPOfOTJGCtOwQop1kGEG/m43KovjJAKfki/Po6Ke1l
         IvWUoR6NXVuhVz5nz9MS5IjjrTeTOrcxDKdp+UbXJe2LE9WSToZVfjNIIMTszn9I6zDA
         CkKQ==
X-Gm-Message-State: ANoB5pkJrhbuzPYYqIG93nS8eUCpi5m1pM3UvyTko4OB8+bp+GMoC1Ik
        GZseYWSEvza/PZVDiGJXLodVAytsNDg=
X-Google-Smtp-Source: AA0mqf7bwqYzkMmspAQ/impi31rnPyogbcWngL3nNhDR21Wsr6dsbEClGqnKNmyeIqmIHJSEk3jAvg==
X-Received: by 2002:ac8:4658:0:b0:3a7:eb36:5cb3 with SMTP id f24-20020ac84658000000b003a7eb365cb3mr23940985qto.41.1670874316498;
        Mon, 12 Dec 2022 11:45:16 -0800 (PST)
Received: from [172.22.37.189] (rrcs-76-81-102-5.west.biz.rr.com. [76.81.102.5])
        by smtp.gmail.com with ESMTPSA id c3-20020ac81103000000b003a50ef44a77sm6277031qtj.28.2022.12.12.11.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 11:45:15 -0800 (PST)
Message-ID: <bc73ce08-5294-bebe-4bad-b123b226bcb8@acm.org>
Date:   Mon, 12 Dec 2022 11:45:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 01/15] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-2-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> This begins to move the SCSI execution functions to use a struct for
> passing in optional args. This patch adds the new struct, temporarily
> converts scsi_execute and scsi_execute_req and add two helpers:
> 1. scsi_execute_args which takes the scsi_exec_args struct.
> 2. scsi_execute_cmd does not support the scsi_exec_args struct.
                     ^^^
                     which?

> @@ -232,8 +222,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>   	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>   	scmd->allowed = retries;
>   	req->timeout = timeout;
> -	req->cmd_flags |= flags;
> -	req->rq_flags |= rq_flags | RQF_QUIET;
> +	req->rq_flags |= RQF_QUIET;

My understanding is that neither scsi_alloc_request() nor any of the
functions it calls copies its 'flags' argument into req->rq_flags. I
think this is a behavior change that has not been described in the
patch description. I'm not saying that this change is wrong but that
careful review is required if this change is retained.

Thanks,

Bart.

