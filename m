Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E028C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 17:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjHNR55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 13:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjHNR5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 13:57:50 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED80D1730;
        Mon, 14 Aug 2023 10:57:40 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-686efa1804eso3065950b3a.3;
        Mon, 14 Aug 2023 10:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692035860; x=1692640660;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ufQuicBvrofs80MI0QvdkWQQ8J8+6ORxBUdLnfG0hcA=;
        b=XdaUjZrGQqXrAruKEZbcukAxLUpv6GcDedWxGVb1RqCek3T4tWIlBAuP2EsNUtIVDJ
         t+6jb+KjhOn2b4MERSlZSj01q1oV4IwYzYoveauK9zO4/j+WY8tAML/Jxgm8XTUWa7dP
         vW2UCRZdlD766HsNeU3SNLGX//q32SXn5chQLp0xiFLpYZf7Ed7WJmgHDGww1tcImmVK
         9MwJwKljWBv+f4yQ1qyPTynXSEUq1BgfdS3IrBjvsYiDrJZr8pl4/lRJP4/P1Fv+b24q
         hLIqo3uDiFCEG2X+b3brcUiqSYczVGu+ATkPNhqXWzi1xy656srzw63NlCYhOjjEm5L8
         3vgg==
X-Gm-Message-State: AOJu0YzRbMUAGPuIQmAzVI04hOPIfG78Y3jelhoK+TLCYxfUNAdiUO0z
        xgPxDFi93nGKO7Yf5qgU5lw=
X-Google-Smtp-Source: AGHT+IEYzrACy7Xmn81B5heo7X8voGVlxcbJoSSDOtU793zyc85KpDL0pIfeuzoNiXLfkQPbHfciZA==
X-Received: by 2002:a05:6a20:1606:b0:13e:6447:ce45 with SMTP id l6-20020a056a20160600b0013e6447ce45mr10810630pzj.43.1692035860228;
        Mon, 14 Aug 2023 10:57:40 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e105:59a6:229c:65de? ([2620:15c:211:201:e105:59a6:229c:65de])
        by smtp.gmail.com with ESMTPSA id g6-20020a63be46000000b00563ea47c948sm8104741pgo.53.2023.08.14.10.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 10:57:39 -0700 (PDT)
Message-ID: <fd60a934-4b9f-97b2-6dd4-522d9194f9c7@acm.org>
Date:   Mon, 14 Aug 2023 10:57:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v8 5/9] scsi: core: Retry unaligned zoned writes
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-6-bvanassche@acm.org>
 <7dd67537-1ad8-79ca-281c-540bade2cb83@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7dd67537-1ad8-79ca-281c-540bade2cb83@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 05:36, Damien Le Moal wrote:
> On 8/12/23 06:35, Bart Van Assche wrote:
>> +	if (!rq->q->limits.use_zone_write_lock && blk_rq_is_seq_zoned_write(rq))
> 
> This condition could be written as a little inline helper
> blk_req_need_zone_write_lock(), which could be used in mq-dealine patch 2.

Hi Damien,

Since q->limits.use_zone_write_lock is being introduced, how about
modifying blk_req_needs_zone_write_lock() such that it tests that new member
variable instead of checking rq->q->disk->seq_zones_wlock? That would allow
me to leave out one change from block/mq-deadline.c. I do not have a strong
opinion about whether the name blk_req_needs_zone_write_lock() should be
retained or whether that function should be renamed into
blk_req_use_zone_write_lock().

Thanks,

Bart.

