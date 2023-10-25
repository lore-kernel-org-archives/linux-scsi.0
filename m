Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138F5C25B6B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 19:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjJYT2y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 15:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJYT2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 15:28:53 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3FF137;
        Wed, 25 Oct 2023 12:28:51 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1c9d922c039so273715ad.3;
        Wed, 25 Oct 2023 12:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698262131; x=1698866931;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ltIn3vFWlxT3mxPbD5xjQgB8wwLwBqiwbjGwaxafQk4=;
        b=gQhOfWYKEd8lHOLcBXR0EDMTOTu4D4cCoZMmxlj33dLAcJoWPoHb/1/6c8SL0wWQnz
         vsuJA3ySLEdfV3xd/J0s35Wl59QTs6T5YJk/l2e+gbaRWip6L5laul7SdanqoCfb52fi
         Vw5HXxWrvokDpm2QvzmRWN5ookUqCFyqJpWSua2cORENzHBE0mckQWMeokmrMgeuGqtj
         7L8/MJ3t1dbqKmJR5ehbUKTNSNSipdYNn92MNBj6KI+DXpDQED/IVUaPYr/ZY0ehiDXE
         efh/Z/ibCEH2z8LBY7MhDbfS6NNztnr/q0Zb+4PZT8fTcE3IZJkhOa0/l+z+r140dMXT
         0MuQ==
X-Gm-Message-State: AOJu0Yx7qasUr8Q6lQocchwt8mbmCi7lf7Eae4Oj76ZKjONyiSunWRWP
        /yuEr/teGyB+a48tD40rXRM=
X-Google-Smtp-Source: AGHT+IHNLnoLKm+tO/50cZnXvNkOA1/XpJzZLuQq8dcBNAa55qWHyAuM0jBulu8gdyeDgMhlcoNjYw==
X-Received: by 2002:a17:902:ea07:b0:1c9:c93a:ca35 with SMTP id s7-20020a170902ea0700b001c9c93aca35mr16865689plg.64.1698262130752;
        Wed, 25 Oct 2023 12:28:50 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:4dcf:e974:e319:6ce8? ([2620:15c:211:201:4dcf:e974:e319:6ce8])
        by smtp.gmail.com with ESMTPSA id t12-20020a170902a5cc00b001c74876f032sm9503865plq.162.2023.10.25.12.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 12:28:50 -0700 (PDT)
Message-ID: <312d57eb-f5b6-40cd-8d65-9bb564218da5@acm.org>
Date:   Wed, 25 Oct 2023 12:28:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 10/19] scsi: core: Retry unaligned zoned writes
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-11-bvanassche@acm.org>
 <249db38e-43c0-46d7-9e61-7788ee710f42@kernel.org>
 <7027b9b9-80cb-418a-8510-b4104a8cdadf@acm.org>
 <e3e92b62-ebeb-42d1-8857-c66721c0325e@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e3e92b62-ebeb-42d1-8857-c66721c0325e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/23 00:25, Damien Le Moal wrote:
> On 10/25/23 02:22, Bart Van Assche wrote:
>> On 10/23/23 17:13, Damien Le Moal wrote:
>>> On 10/24/23 06:54, Bart Van Assche wrote:
>>>>    	case ILLEGAL_REQUEST:
>>>> +		/*
>>>> +		 * Unaligned write command. This may indicate that zoned writes
>>>> +		 * have been received by the device in the wrong order. If zone
>>>> +		 * write locking is disabled, retry after all pending commands
>>>> +		 * have completed.
>>>> +		 */
>>>> +		if (sshdr.asc == 0x21 && sshdr.ascq == 0x04 &&
>>>> +		    !req->q->limits.use_zone_write_lock &&
>>>> +		    blk_rq_is_seq_zoned_write(req) &&
>>>> +		    scmd->retries <= scmd->allowed) {
>>>> +			sdev_printk(KERN_INFO, scmd->device,
>>>> +				    "Retrying unaligned write at LBA %#llx.\n",
>>>> +				    scsi_get_lba(scmd));
>>>
>>> KERN_INFO ? Did you perhaps mean KERN_DEBUG ? An info message for this will be
>>> way too noisy.
>>
>> Hi Damien,
>>
>> Are you sure that KERN_INFO will be too noisy? On our test setups we see
>> this message less than once a day. Anyway, I will change the severity level.
> 
> I am not sure. But better safe than sorry :)
> 
> So given that we should not scare the user with errors that are not errors (as
> the next tries will succeed), we should be silent and log a message only if the
> retry count is exhausted and we still see a failure.

Hi Damien,

I will wrap SCSI_LOG_ERROR_RECOVERY(1, ...) around the above
sdev_printk() call. As you probably know SCSI logging is disabled by
default.

Thanks,

Bart.

