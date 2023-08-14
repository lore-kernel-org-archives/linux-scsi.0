Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0F2C04A6A
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 02:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjHNCSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Aug 2023 22:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjHNCSq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Aug 2023 22:18:46 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5EBA8;
        Sun, 13 Aug 2023 19:18:45 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-686bc261111so2525030b3a.3;
        Sun, 13 Aug 2023 19:18:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691979525; x=1692584325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fR1qgv/4gRqtXSg0JodzrUQ/Bobh3zihlkH5J23oWvQ=;
        b=cG1cdURsPsnjNwSXFxAqTbFC4h8SSSCFok2frPx6IEe6vecWI9XGw9XUt6lM5c4RTH
         6sQc/zCpMOt0/GgloiRjZJAKeJRlnGzQQIzeRnVtk4QsxNfd6/KIrf4BO25lsaHcxKsL
         GuG7lAwW3nhkbK4iju9MlWJkZuB/BVC7TZuVFqvyaxthpzdzwO3JHusTeFOWKcWe8n9h
         /LwomxAXIEcLWugliaCjUwe0wsYSQstMNZZB9VK7j58u+g4yR8Z6VZ9B+7CHM9hdtCIC
         8vqQyapr7UWZpP4rnkKmZ749edvm2PbXnBbmWHEvfPUUD0shu0plfZKE8WUBJ6OnJ3Uy
         lphQ==
X-Gm-Message-State: AOJu0YyA0LDM/21AL/8KpuWPzTThilxIFUVFB3pQ1fltO6s7iYRsequO
        sSOtXDp4IRipLgYgrweaZTn11lgL8sA=
X-Google-Smtp-Source: AGHT+IGljdOCIUCbJnLNqNvOrCYY7ONvIX99LtAiaceWyLUsnt+5geO4fi+GuMMQ62U/oZAHWzwUrA==
X-Received: by 2002:a05:6a00:390b:b0:686:fb87:7f55 with SMTP id fh11-20020a056a00390b00b00686fb877f55mr9266000pfb.15.1691979525252;
        Sun, 13 Aug 2023 19:18:45 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id i22-20020aa79096000000b006871fdde2c7sm6771940pfa.110.2023.08.13.19.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Aug 2023 19:18:44 -0700 (PDT)
Message-ID: <057e08f2-7349-bcad-c21d-11586c059fac@acm.org>
Date:   Sun, 13 Aug 2023 19:18:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v8 3/9] scsi: core: Call .eh_prepare_resubmit() before
 resubmitting
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-4-bvanassche@acm.org>
 <29cca660-4e66-002c-7378-2d2df5c79a08@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <29cca660-4e66-002c-7378-2d2df5c79a08@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/13/23 18:19, Damien Le Moal wrote:
> On 8/12/23 06:35, Bart Van Assche wrote:
>> Make the error handler call .eh_prepare_resubmit() before resubmitting
> 
> This reads like the eh_prepare_resubmit callback already exists. But you are
> adding it. So you should state that.

Hi Damien,

I will rephrase the patch description.

>> +++ b/drivers/scsi/Makefile.kunit
>> @@ -0,0 +1 @@
>> +obj-$(CONFIG_SCSI_ERROR_TEST) += scsi_error_test.o
> 
> All the above kunit changes (and the test changes below) seem unrelated to what
> the commit message describes. Should these be split into a different patch ?

Some people insist on including unit tests in the same patch as
the patch that introduces the code that is being tested. I can
move the unit test into a separate patch if that is preferred.

>> +	/*
>> +	 * Call .eh_prepare_resubmit for each range of commands with identical
>> +	 * ULD driver pointer.
>> +	 */
>> +	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
>> +		struct scsi_driver *uld = scsi_cmd_to_driver(scmd);
>> +		struct list_head *prev, uld_cmd_list;
>> +
>> +		while (&next->eh_entry != done_q &&
>> +		       scsi_cmd_to_driver(next) == uld)
>> +			next = list_next_entry(next, eh_entry);
>> +		if (!uld->eh_prepare_resubmit)
>> +			continue;
>> +		prev = scmd->eh_entry.prev;
>> +		list_cut_position(&uld_cmd_list, prev, next->eh_entry.prev);
>> +		uld->eh_prepare_resubmit(&uld_cmd_list);
> 
> Is it guaranteed that all uld implement eh_prepare_resubmit ?

That is not guaranteed. Hence the if (!uld->eh_prepare_resubmit)
test in the above loop.

Thanks,

Bart.
