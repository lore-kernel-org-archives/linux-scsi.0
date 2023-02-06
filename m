Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FDFC636D3
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Feb 2023 21:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjBFVOb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 16:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjBFVO3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 16:14:29 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC74161AC
        for <linux-scsi@vger.kernel.org>; Mon,  6 Feb 2023 13:14:28 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id hv11-20020a17090ae40b00b002307b580d7eso9026763pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2023 13:14:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=21gHeGVmIzRP1Ro1PLJnF7RaX2VoA4fZA0HL9Q8gCq8=;
        b=EF2tpK/QUIi0++Vi1akYIxUil/8ClZTyMyTRdE1yqAsIgdpLtOXdR41fOBJLJy/h9u
         1DfV5Qc29WcK483r7HqPXjnFtbgr6F+R5iv/ONLVWKpOfId/ld261AHJW36rRjreAWZf
         FO8TpmxZiGvRAlIbwt41iyUd5o0U8R7JnhfOg4deFdg0U9SYeSxaIxeV7t97l5aXYFFg
         CAqEW0GS0RmOUFSL8Hf2wNUdqOz7QJRuG4EZJSz6o1G8mq8tB3XaqSrKTBLUvWiOq8xa
         zUFaqo4/KmXi/wL4wS3L8vrm2mz/1ciHm46PjHSvq9uCbQ9Pux4DDvqUCNqYxR2KGQdW
         NYBw==
X-Gm-Message-State: AO0yUKXZLMr4NmblGov/xNG7lWYs/UoWNj/SzZRzpaCkNSkRrMaRrpqN
        mWXuD69WEZ+m686DUz4H2yg=
X-Google-Smtp-Source: AK7set+biiAoSoOv52P0hs5ofJjLIiUfb9knqRkdfeSrRAU0Yc3avOCd/1UqZA9mMifgsW3FVBXaOw==
X-Received: by 2002:a05:6a21:29c1:b0:bf:de0f:c4ac with SMTP id tv1-20020a056a2129c100b000bfde0fc4acmr437955pzb.57.1675718068195;
        Mon, 06 Feb 2023 13:14:28 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:546b:df58:66df:fe23? ([2620:15c:211:201:546b:df58:66df:fe23])
        by smtp.gmail.com with ESMTPSA id t8-20020aa78f88000000b0059260f01115sm7543860pfs.76.2023.02.06.13.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 13:14:27 -0800 (PST)
Message-ID: <bc1183a8-e4fa-20c6-0508-ec36d395a20d@acm.org>
Date:   Mon, 6 Feb 2023 13:14:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] scsi: core: Extend struct scsi_exec_args
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230202220412.561487-1-bvanassche@acm.org>
 <20230202220412.561487-2-bvanassche@acm.org>
 <a81cb9bc-246b-1b82-fcc6-37bfb5829bab@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a81cb9bc-246b-1b82-fcc6-37bfb5829bab@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/23 01:50, John Garry wrote:
> On 02/02/2023 22:04, Bart Van Assche wrote:
>> Allow SCSI LLDs to specify RQF_* and SCMD_* flags.
> 
> As I see, if BLK_MQ_REQ_PM is set for scsi_exec_args.req_flags, then 
> RQF_PM gets set automatically in blk_mq_rq_ctx_init() for 
> request.rq_flags. Christoph previously mentioned that we are required to 
> set both (BLK_MQ_REQ_PM and RQF_PM). So where does it matter that we 
> need to set RQF_PM (that setting BLK_MQ_REQ_PM doesn't cover)?

I will rework this patch such that both flags are set instead of only 
one of the two.

Thanks,

Bart.


