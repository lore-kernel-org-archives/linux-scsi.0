Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96644C25B47
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 17:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbjJXRWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 13:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjJXRWO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 13:22:14 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81C8122;
        Tue, 24 Oct 2023 10:22:10 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6bd73395bceso3463304b3a.0;
        Tue, 24 Oct 2023 10:22:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698168130; x=1698772930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aeMoFt3hvG765biesWb18thtSRfhB4ekkkzPqilREOo=;
        b=obpF4eLi18ctJbrsgON6uN/Pgle/WMgc9qfkAFH90YSW+FrB4b1aLA3EpkthMBzrn7
         cwPlQAP1wEVrDAdeQ35zU3tpdkCRVytVN1wuGFkZScNh17eEjG8pYL4+/gKMygPzXoQ4
         ibBLiygx23VvSS3erhk1Spdg9xaBJPmZm8bhDqWxBZVM5pOozh7DeMC+yqdyq/hOrtjX
         wUifswUJtlPJq8zyFYbSB5PEWKmwf+Qy5lUOsyOAKPj+V12t/rdUoSZ5G+MJK2jZi8fc
         4H6CTY8n8llhAE5ePO7E4V6GwGeZyR8yiidIbT73hOwNeoLRqpb7VBAj4rWMsNCoTdHD
         pH1A==
X-Gm-Message-State: AOJu0YwddZt39P5aCDIloD52pFPvXbvN2fyQhWWK4xnxYqSLN6gh5ULu
        SXYJDIflSKG2bLW3+/MZzOgqRXoYfBg=
X-Google-Smtp-Source: AGHT+IEHlF/wjLVuurvln+1I11b4Itc3ugRgWadi0lRsA3yqf5ymVCkkn4u5JpaunapeqBr18HP2FQ==
X-Received: by 2002:a05:6a00:9393:b0:6be:c6f7:f9fd with SMTP id ka19-20020a056a00939300b006bec6f7f9fdmr25509713pfb.11.1698168130020;
        Tue, 24 Oct 2023 10:22:10 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:30e1:c9d3:6b41:493d? ([2620:15c:211:201:30e1:c9d3:6b41:493d])
        by smtp.gmail.com with ESMTPSA id e8-20020a056a0000c800b006bd26bdc909sm7925691pfj.72.2023.10.24.10.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 10:22:09 -0700 (PDT)
Message-ID: <7027b9b9-80cb-418a-8510-b4104a8cdadf@acm.org>
Date:   Tue, 24 Oct 2023 10:22:08 -0700
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <249db38e-43c0-46d7-9e61-7788ee710f42@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/23 17:13, Damien Le Moal wrote:
> On 10/24/23 06:54, Bart Van Assche wrote:
>>   	case ILLEGAL_REQUEST:
>> +		/*
>> +		 * Unaligned write command. This may indicate that zoned writes
>> +		 * have been received by the device in the wrong order. If zone
>> +		 * write locking is disabled, retry after all pending commands
>> +		 * have completed.
>> +		 */
>> +		if (sshdr.asc == 0x21 && sshdr.ascq == 0x04 &&
>> +		    !req->q->limits.use_zone_write_lock &&
>> +		    blk_rq_is_seq_zoned_write(req) &&
>> +		    scmd->retries <= scmd->allowed) {
>> +			sdev_printk(KERN_INFO, scmd->device,
>> +				    "Retrying unaligned write at LBA %#llx.\n",
>> +				    scsi_get_lba(scmd));
> 
> KERN_INFO ? Did you perhaps mean KERN_DEBUG ? An info message for this will be
> way too noisy.

Hi Damien,

Are you sure that KERN_INFO will be too noisy? On our test setups we see
this message less than once a day. Anyway, I will change the severity level.

Bart.

