Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE00C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 21:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiDIVlB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Apr 2022 17:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiDIVlA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Apr 2022 17:41:00 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32ED89FE5
        for <linux-scsi@vger.kernel.org>; Sat,  9 Apr 2022 14:38:52 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id e8-20020a17090a118800b001cb13402ea2so8499329pja.0
        for <linux-scsi@vger.kernel.org>; Sat, 09 Apr 2022 14:38:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EVXy+VsB4So31fgppLNCjtzSgpzIcZ5hnWbFE5zWaVo=;
        b=yCchvs/KzCzWK2DGJBV5t/R2qMMM4QpG9b6KuXxvdxTdUE68Wl0L9Z7N//oST6qCS0
         7MtQBG7SEkOmpwnqX5/kMGBy2FicrlZrD44R2aiRe3P/4FaK9M68IhM2rG581TPphiH7
         hG8sj48w8Bo6X6yP+qEv1OAM8SiI/N8upr6KJrM4QOkuEO/tfYXTAEtfIQD/DZqtOuu3
         JnR6Bf96tFGHz4jBXq7VZd4v5zLotHxzrZZ24ZnaZxCKHGZPP8ikr2J/9l4TU80t+mTN
         Lah3vaQ5xQWZlEyCfPokjuK79xDOsjDM6t/wCim+S7H0ilxrVk+b6nnG4rh3s15k45TN
         OcZw==
X-Gm-Message-State: AOAM530KqNaKCyly5Uf36KmvGUL248/+4bNGH2yPIAlzWz9Oo/SXux7/
        yIOghrL1UXw1T2YUj1IU0bSGCI2v6CE=
X-Google-Smtp-Source: ABdhPJx419oJCE/EncHeXuUu5vJZk4LJznHLETH7Sou2PTGxvuvOzg+iXaCdje+Z7PcuzoMNAopXbA==
X-Received: by 2002:a17:90a:b108:b0:1ca:c272:1a5f with SMTP id z8-20020a17090ab10800b001cac2721a5fmr28567308pjq.49.1649540331507;
        Sat, 09 Apr 2022 14:38:51 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b004e1bea9c582sm30425466pfj.43.2022.04.09.14.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Apr 2022 14:38:50 -0700 (PDT)
Message-ID: <07bb9fa3-2632-4388-4e2d-69bf54877436@acm.org>
Date:   Sat, 9 Apr 2022 14:38:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/6] scsi_cmnd: reinstate support for cmd_len > 32
Content-Language: en-US
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        hch@lst.de
References: <20220408035651.6472-1-dgilbert@interlog.com>
 <20220408035651.6472-2-dgilbert@interlog.com>
 <78f9dc98-cca8-6ba2-9146-082f95c8d5ab@acm.org>
 <13393a17-b68d-c0b3-2baf-0b553265bc7d@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <13393a17-b68d-c0b3-2baf-0b553265bc7d@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/8/22 21:42, Douglas Gilbert wrote:
> On 2022-04-08 10:55, Bart Van Assche wrote:
>> On 4/7/22 20:56, Douglas Gilbert wrote:
>>> +/* This value is used to size a C array, see below if cdb length > 
>>> 32 */
>>> +#define SCSI_MAX_COMPILE_TIME_CDB_LEN 32
>>
>> Since CDBs longer than 16 bytes are rare, how about using 16 as the 
>> maximum compile-time CDB size?
> 
> Well that was the way it was before the surgery performed by Christoph.
> If reducing the size of the scsi_cmnd structure by another 16 bytes
> is that important, it can be easily done. My "long cdb" side of the
> union takes 16 bytes currently (12 on a 32 bit machine).

Some environments (e.g. Android TV booting from UFS) are 
memory-constrained. Hence the request to keep struct scsi_cmnd as small 
as possible (without sacrificing performance for high-end setups).
> IMO there should be comments added to scsi_cmnd.h to stress an object
> of that type is always preceded (in memory) by a struct request object.
> They are created as a pair, and are destroyed (freed, destructed) as
> a pair.

Although adding such a comment seems fine to me: isn't this something 
that applies to all blk-mq drivers?

Thanks,

Bart.
