Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A19C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 19:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbiF3T23 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 15:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbiF3T22 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 15:28:28 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826803B036
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 12:28:27 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id s27so237244pga.13
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 12:28:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=ezSRldQmKfMb3strrQ86BPA9cKxPUqRhFH6wemNDoiA=;
        b=cI1bC0cUp68nT4L89+ZYLXADyZ5uyK1hVT3lv1nL4tLc3TeYFmTCZGJOzBUwNvhZFh
         797gSqxiqIxyzkPws/+4mtKReKJ0LZDp4PBP8I0U2E5ibM7HCL4GgXgAykIgbx7YjSXW
         V/zRHb3U2RshCg178qE2PYbadG3Ot5j8kS4182FFXJDtjeJnWtFVeFxmXN6QIrOEwrZS
         UVPj/D/P/8dOjWwULi+q5bgkHOo1EYiYVl3ndBb7MPPu+JbxjVPmtBD33zmt1j5bCNmB
         QQ6YwUSsxCqqQPErO6emJcdO7ZQsglqv06rS1W66nxB/fKI4o9MiCxUntKFzwnqT3yfl
         vJQQ==
X-Gm-Message-State: AJIora9oQbviVx+/NmdZqKMwm7tV2+NWgXB4OWoZ4E7IVfCN/P18AxDw
        Ki6RMzHlscpsdREvFyiOvzQ=
X-Google-Smtp-Source: AGRyM1tb5T1BtapLncsFLAzFybWpl8N2dZ29uLpplzBQIlrOvkFRgl+WUW9iJ0Ta0mOmoW+wjXYZzw==
X-Received: by 2002:a63:5964:0:b0:411:4724:e618 with SMTP id j36-20020a635964000000b004114724e618mr8758747pgm.484.1656617306927;
        Thu, 30 Jun 2022 12:28:26 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c5-20020a17090abf0500b001ef0fed7046sm4870928pjs.15.2022.06.30.12.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 12:28:26 -0700 (PDT)
Message-ID: <149f0b6d-ae98-90c9-0ce4-ddf5f769a3fc@acm.org>
Date:   Thu, 30 Jun 2022 12:28:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 3/3] scsi: sd: Rework asynchronous resume support
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        ericspero@icloud.com, jason600.groome@gmail.com
References: <20220628222131.14780-1-bvanassche@acm.org>
 <20220628222131.14780-4-bvanassche@acm.org>
 <82e30007-1ffc-92e4-38b5-eaf7dd2e316d@huawei.com>
 <b55be9e0-e1b7-8c8e-7c40-0cb633e381d3@acm.org>
In-Reply-To: <b55be9e0-e1b7-8c8e-7c40-0cb633e381d3@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/22 11:57, Bart Van Assche wrote:
> On 6/30/22 09:23, John Garry wrote:
>> On 28/06/2022 23:21, Bart Van Assche wrote:
>>> +/* A START command finished. May be called from interrupt context. */
>>> +static void sd_start_done(struct request *req, blk_status_t status)
>>> +{
>>> +    const struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
>>> +    struct scsi_disk *sdkp = scsi_disk(req->q->disk);
>>> +
>>> +    sdkp->start_result = scmd->result;
>>> +    WARN_ON_ONCE(scmd->sense_len > SCSI_SENSE_BUFFERSIZE);
>>
>> If scmd->sense_len > SCSI_SENSE_BUFFERSIZE, do you really want to go 
>> on to copy at sdkp->start_sense_buffer (which is of size 
>> SCSI_SENSE_BUFFERSIZE)? Won't that cause a corruption?
> 
> scsi_mq_init_request() allocates a buffer with size 
> SCSI_SENSE_BUFFERSIZE. SCSI LLDs copy sense data into that buffer. I am 
> not aware of any SCSI LLD that modifies the cmd->sense_buffer pointer. 
> So if scmd->sense_len would be larger than SCSI_SENSE_BUFFERSIZE that 
> either indicates that the LLD reported a sense length that is too large 
> or that it wrote outside the bounds of the sense buffer. Do we really 
> need to add a protection in the SCSI core against buggy LLDs?

A result of the above is that SCSI_SENSE_BUFFERSIZE bytes can be copied 
instead of scmd->sense_len. I will make that change.

Bart.
