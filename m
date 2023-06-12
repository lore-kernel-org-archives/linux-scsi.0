Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2007BC88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 13:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbjFLNlZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 09:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjFLNlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 09:41:24 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B877C121;
        Mon, 12 Jun 2023 06:41:17 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-54fac329a71so13447a12.1;
        Mon, 12 Jun 2023 06:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686577277; x=1689169277;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nofhknKgsSqsBQYSoNjjyr+/XuZVhRAaDNyU4ix/7uw=;
        b=CLANenAqBRDdqVp7dTZI2cUwapqggduRhVkWecs3SKCC3k4Hn3glwQIyenBM7qrpuh
         PT6bHIjj4v++8X1hq0cTaKM/99N0Dq3hULYeMw+GhIq9JnnNFWKzbp0kgYwUH2BMtrZF
         jJamcjGSPIa2wFhxgPqao/JAs1/iBSnStCSZ0lTbmmDTUd/9U5eBew1wEtJufJQsXqld
         cOKmDvE9bmFYxaxqh64g5VK0m+RkpOgDzuaigpMLdZ3c/HVcT5QMA/lC9BtFOYt6iKw/
         zL7J3zX0Y9vtMA/ac+0wyQj+Gni5vdUmoXcKeITv4LMd97wmx017Eb7Et/Dp+N3aV6qx
         Z9lA==
X-Gm-Message-State: AC+VfDzpLtEptIJZn5oejKO9jB3CTsSQS4ru36cDcgHuhsZvO31AOtJ1
        7lAWIaUHdj5p/gmW+bLsWrU=
X-Google-Smtp-Source: ACHHUZ5Bwf5tCvfo841w22WO+TURHY8/TrUlN9/7Y9gqBF+CyyH27JsNO8/jxi0/9cQIRv9g+X3V/Q==
X-Received: by 2002:a17:90a:1b22:b0:25b:d3f9:af01 with SMTP id q31-20020a17090a1b2200b0025bd3f9af01mr3313383pjq.35.1686577276760;
        Mon, 12 Jun 2023 06:41:16 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id fy11-20020a17090b020b00b00256353eb8f2sm3575793pjb.5.2023.06.12.06.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 06:41:16 -0700 (PDT)
Message-ID: <dd9acaed-89de-6402-a763-7db6736a6f5f@acm.org>
Date:   Mon, 12 Jun 2023 06:41:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 4/8] scsi: call scsi_stop_queue() without state_mutex
 held
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230607182249.22623-1-mwilck@suse.com>
 <20230607182249.22623-5-mwilck@suse.com>
 <3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org>
 <50cb1a5bd501721d7c816b1ca8bf560daa8e3cc9.camel@suse.com>
 <ff669f59e3c42e5dec4920d705e2b8748ad600d5.camel@suse.com>
 <20230608054444.GB11554@lst.de>
 <5be7eebb-f734-1a0a-9f97-1b3534bc26ac@acm.org>
 <dcef340d-0b43-42d3-0e1c-a96cd90283d3@oracle.com>
 <2bfdb9a65668109c204f7d4677bd717f049b1e83.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2bfdb9a65668109c204f7d4677bd717f049b1e83.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 04:15, Martin Wilck wrote:
> I guess the race that Bart was hinting at is hard to trigger.

Are you sure about this? I think this scenario can be triggered by 
writing into the sysfs attribute that changes the SCSI device state 
while a scsi_target_block() call is in progress. See also 
store_state_field().

> I would like to remark that the fact that we need to hold the SCSI
> state_mutex while calling blk_mq_quiesce_queue_nowait() looks like a
> layering issue to me. Not sure if, and how, this could be avoided,
> though.

I do not agree that this is a layering issue. Is holding a mutex around 
a call of a function in a lower layer ever a layering issue?

What matters is to be very careful with locks while invoking callback 
functions. See also slide 7 in Ousterhout's presentation "Why Threads 
Are A Bad Idea (for most purposes)" from 1996 
(https://web.stanford.edu/~ouster/cgi-bin/papers/threads.pdf).

Bart.

