Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5089CDB465
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 19:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345159AbjJSTun (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 15:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjJSTum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 15:50:42 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0451CCA;
        Thu, 19 Oct 2023 12:50:41 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1ca82f015e4so244575ad.1;
        Thu, 19 Oct 2023 12:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697745040; x=1698349840;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Gzq/gzso30UiG3pCarLGRQ/H1gh08CnkHPjn+a7Vcs=;
        b=VimFSXloXRMhMfVMAmYClbmfWQrn+75mes/ZsjobvKe9jn4D6/c3sN/uNup9q+YKUJ
         +Q0tfL9z2oeh9aprRk8T8a/k0Mrx144VCSdlXWcvxPfyVFgxWeQz3R6NrYvjT03rVi7n
         N1Qv1nwrjetKVq/Zwx56un4tOxfjR4KvL32GlxJgXjbnWSsMwzpV2tLRZaWZZXSGQuHj
         mnoXzSOtydQpDe+6i1PHo0vMO63DPCq9NfB1skL55TLtwnUyHESmZsTltS6cUQM70suF
         bOMWMFwkf1FPmGfP1Hqe2a3bx+0fO/C44ZLjviLmYMK06oTluZtw65xDQIQI7zqt+mxb
         9cTQ==
X-Gm-Message-State: AOJu0YxyW3JKdyjXKP7EheXun6PkKR8Z9NgfTPODu0myxin6TWHQtyyQ
        OgLXcU9NTGxc4qoHWS5FJ9o=
X-Google-Smtp-Source: AGHT+IEGq4ylOKbMXm3HQeZJdlDYfnTjsFKDDOdK2kSQqQZ0d1MqTZdDuFWCKi2l+149xVejwZBS4w==
X-Received: by 2002:a17:902:e214:b0:1ca:4681:eb37 with SMTP id u20-20020a170902e21400b001ca4681eb37mr2806194plb.14.1697745040301;
        Thu, 19 Oct 2023 12:50:40 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3306:3a7f:54e8:2149? ([2620:15c:211:201:3306:3a7f:54e8:2149])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902cec400b001c60d0a6d84sm83388plg.127.2023.10.19.12.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 12:50:39 -0700 (PDT)
Message-ID: <1e9f919e-ae05-4b15-bf3c-01849d122a5d@acm.org>
Date:   Thu, 19 Oct 2023 12:50:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/18] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231018175602.2148415-1-bvanassche@acm.org>
 <20231018175602.2148415-6-bvanassche@acm.org>
 <9ee7edc0-5edb-4e17-abae-bb7ffcf0f147@kernel.org>
 <47a5508c-cb80-4398-aa9c-e905be06ad1d@acm.org>
In-Reply-To: <47a5508c-cb80-4398-aa9c-e905be06ad1d@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/23 10:53, Bart Van Assche wrote:
> 
> On 10/18/23 17:24, Damien Le Moal wrote:
>> On 10/19/23 02:54, Bart Van Assche wrote:
>>> +void scsi_call_prepare_resubmit(struct list_head *done_q)
>>> +{
>>> +    struct scsi_cmnd *scmd, *next;
>>> +
>>> +    if (!scsi_needs_preparation(done_q))
>>> +        return;
>>
>> This function will always go through the list of commands in done_q. 
>> That could
>> hurt performance for scsi hosts that do not need this prepare 
>> resubmit, which I
>> think is UFS only for now. So can't we just add a flag or something to 
>> avoid that ?
>
> The SCSI error handler is only invoked after an RCU grace period has 
> expired. The time spent in scsi_needs_preparation() is negligible
> compared to an RCU grace period, especially if the
> .eh_needs_prepare_resubmit pointers are NULL.

(replying to my own e-mail)

Do you perhaps want me to drop the eh_needs_prepare_resubmit function
pointer and introduce a flag instead? That sounds good to me.

Thanks,

Bart.

