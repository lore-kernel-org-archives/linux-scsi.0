Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4552AC71153
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 16:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242734AbjHXQwi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 12:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242750AbjHXQwQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 12:52:16 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57A41BC2;
        Thu, 24 Aug 2023 09:52:13 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-68a3e271491so70975b3a.0;
        Thu, 24 Aug 2023 09:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692895933; x=1693500733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dKJijkF155eGYoq1EBWJ9X5JNwQHMUG5mlsWsZ3nTqk=;
        b=hUfuFU7If0c4h2ETcS0bnBoPqW/IJG1YNxRhdtmTwPuQN/7RIGdzELU3M+jYYfv6kZ
         7UaggKGXTOF9d7BKuckk+J9q7vMuWP7oTrXdoFBH0HA+O1KF4S0EaRgSYpaLRO5AoT4X
         2rGV5ln5/qVsOYELiVvOUnZFAFkJ4CGl7detjXDYcm95n7jUaiXRopS/5uiEhYCB6U/u
         PiL2oXr265WqI79RkZgSWGtD6XGZc0W2s7Fvz7c15nnkkJYHiHKbzif7Mq/FkQim2tj6
         /lWqcxsqMQ6AmCbUHolZ6FchMrAKr+AqpFyL7vvzf6fRQ9foK6fdL96kjKT8e1Z95val
         +sig==
X-Gm-Message-State: AOJu0YxAqkGsTSjCM9DItDAdhcKApt5tOb030sChvlGGsF+ljSb27U1O
        flZu5CMdZkqacF80nFTp4To=
X-Google-Smtp-Source: AGHT+IGCbX01wUabFA10fO9YzvjZ5TWcCaMiVWqPfI5uv8jJP9TYMhM7crYZB4rkXHd30AkPejkbww==
X-Received: by 2002:a05:6a00:2389:b0:686:be77:431c with SMTP id f9-20020a056a00238900b00686be77431cmr16715374pfc.13.1692895933183;
        Thu, 24 Aug 2023 09:52:13 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e6ec:4683:972:2d78? ([2620:15c:211:201:e6ec:4683:972:2d78])
        by smtp.gmail.com with ESMTPSA id a18-20020aa78652000000b00666e649ca46sm7800956pfo.101.2023.08.24.09.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 09:52:12 -0700 (PDT)
Message-ID: <1e54cf7a-4e8f-4539-6677-d6bf0ec88ea5@acm.org>
Date:   Thu, 24 Aug 2023 09:52:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v11 04/16] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
 <20230822191822.337080-5-bvanassche@acm.org>
 <3562fc36-4bc2-b4fb-a2ad-1e310baf1b47@suse.de>
 <078d2954-f4af-6678-29ce-d8f65ff1397a@acm.org>
 <741e19ae-d4fd-11f5-7faa-18b888ff769c@kernel.org>
 <6355b575-3f59-93dc-5acf-4726c6e80a15@acm.org>
 <5c36ae01-a806-a36b-0196-41c217f78307@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5c36ae01-a806-a36b-0196-41c217f78307@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/24/23 09:44, Hannes Reinecke wrote:
> On 8/24/23 16:47, Bart Van Assche wrote:
>> Thanks for the feedback. I agree that it would be great to have zone 
>> append
>> support in F2FS. However, I do not agree that switching from regular 
>> writes
>> to zone append in F2FS would remove the need for sorting SCSI commands 
>> by LBA in the SCSI error handler. Even if F2FS would submit zoned writes
>> then the following mechanisms could still cause reordering of the zoned
>> write after these have been translated into regular writes:
>> * The SCSI protocol allows SCSI devices, including UFS devices, to 
>> respond
>> with a unit attention or the SCSI BUSY status at any time. If multiple 
>> write commands are pending and some of the pending SCSI writes are not
>> executed because of a unit attention or because of another reason, this
>> causes command reordering.
> 
> Yes. But the important thing to remember is that with 'zone append' the 
> resulting LBA will be returned on completion, they will _not_ be 
> specified in the submission. So any command reordering doesn't affect 
> the zone append commands as they heven't been written yet.
> 
>> * Although the link between the UFS controller and the UFS device is 
>> pretty
>> reliable, there is a non-zero chance that a SCSI command is lost. If this
>> happens the SCSI timeout and error handlers are activated. This can cause
>> reordering of write commands.
>>
> Again, reordering is not an issue with zone append. With zone append you 
> specify in which zone the command should land, and upon completion the 
> LBA where the data is written will be returned.
> 
> So if there is an error the command has not been written, consequently 
> there is no LBA to worry about, and you can reorder at will.

Hi Hannes,

I agree that reordering is not an issue for NVMe zone append commands.
It is an issue however with SCSI devices because there is no zone append
command in the SCSI command set. The sd_zbc.c code translates zone
appends (REQ_OP_ZONE_APPEND) into regular WRITE commands. If these WRITE
commands are reordered, the ZBC standard requires that these commands
fail with an UNALIGNED WRITE error. So I think for SCSI devices what you
wrote is wrong.

Bart.

