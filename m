Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289DBC77B75
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 02:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjERCen (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 22:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjERCem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 22:34:42 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A188211F
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 19:34:41 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1ac4910e656so5597905ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 19:34:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684377281; x=1686969281;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DhahBaLDK96VCh5BzZu0vWdQFu1RZlWsvbhhDv9JCYc=;
        b=Bf23F9YxwWFM1zYiKMSznI5WAadgkLnhLMa+codQ85eUnuIdnZuBeqVaFLNhl/Ylzv
         ZcNqYnp/BKO0FBtEbvyvVnchlKex8DK2wruPMuwEnXFN9IKonI9dY2+94WeHir39px5q
         aVJK9huo0QhymXcUN7QkF31JYjhetWwAsdjSfVuIks/569Gi7wOrpXnDWWNTFaD5QU3t
         EujIINnP6kBTBgSu0St1BtXb8hI990HCj7vI6nNW+5v4de9p5SCnq7Pihp0ViH6baQop
         guqx48HWo0iC1xdt/Sodx0x9So6Zoayr62gp0txwCwFOpddaA87nplxdEMeLWnOksNvK
         344w==
X-Gm-Message-State: AC+VfDyJq0rmQlgA2gZFyc6hFwOpb+/IvO3HQvXIPt6NcbGy+6AEnGC0
        cyEZQWDwI9d1TrS7S6XmZHm34TMCHMA=
X-Google-Smtp-Source: ACHHUZ50uVasAjvJ7ffEBxqh/03V+gI9Ohc7SY9GJs/KGVfQLndbGBsAdFajEZlNptsWY6uH1bo4Qg==
X-Received: by 2002:a17:902:ecc1:b0:1ab:1260:19de with SMTP id a1-20020a170902ecc100b001ab126019demr733204plh.11.1684377280501;
        Wed, 17 May 2023 19:34:40 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902b94700b001acae9734c0sm57222pls.266.2023.05.17.19.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 19:34:39 -0700 (PDT)
Message-ID: <07c13761-7f71-3281-fff7-60ec196759c5@acm.org>
Date:   Wed, 17 May 2023 19:34:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 4/4] scsi: core: Delay running the queue if the host is
 blocked
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
References: <20230517230927.1091124-1-bvanassche@acm.org>
 <20230517230927.1091124-5-bvanassche@acm.org>
 <ZGV8YfsLYIR2H21/@ovpn-8-16.pek2.redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZGV8YfsLYIR2H21/@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/23 18:16, Ming Lei wrote:
> On Wed, May 17, 2023 at 04:09:27PM -0700, Bart Van Assche wrote:
>> @@ -1767,7 +1767,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>   		break;
>>   	case BLK_STS_RESOURCE:
>>   	case BLK_STS_ZONE_RESOURCE:
>> -		if (scsi_device_blocked(sdev))
>> +		if (scsi_device_blocked(sdev) || shost->host_self_blocked)
>>   			ret = BLK_STS_DEV_RESOURCE;
> 
> What if scsi_unblock_requests() is just called after the above check and
> before returning to block layer core? Then this request is invisible to
> scsi_run_host_queues()<-scsi_unblock_requests(), and io hang happens.

If returning BLK_STS_DEV_RESOURCE could cause an I/O hang, wouldn't that 
be a bug in the block layer core? Isn't the block layer core expected to 
rerun the queue after a delay if a block driver returns 
BLK_STS_DEV_RESOURCE? See also blk_mq_dispatch_rq_list().

Thanks,

Bart.

